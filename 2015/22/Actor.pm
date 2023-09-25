package Actor;

use strict;

use lib ".";
use Spells;

{

my $COMBAT_VERBOSE = 0;

my %name = ();
my %isWizard = ();

my %health = ();
my %maxHealth = ();

my %mana = ();
my %manaSpent = ();
my %maxMana = ();

my %attackStrength = ();
my %magicDefense = ();
my %advantage = ();

my %enemy = ();

my %spellsAvailable = ();
my %spellsActive = ();

# Constructor

sub new {
  my ($class, $name, $hp, $mana, $dmg, $isWizard, $adv) = @_;
  my $self = bless \do{my $anon}, $class;
  
  $name{$self} = $name;
  $isWizard{$self} = $isWizard;

  $maxHealth{$self} = $hp; $self->reviveHP();
  $maxMana{$self} = $mana; $self->reviveMana();

  $attackStrength{$self} = $dmg;
  $magicDefense{$self} = 0;
  $advantage{$self} = $adv;

  return $self;
}

## Setter Methods

sub setEnemy {
  my $self = shift;
  $enemy{$self} = shift;
}

sub learnSpells {
  my $self = shift;

  %{$spellsActive{$self}} = ();
  %{$spellsAvailable{$self}} = ();

  $spellsAvailable{$self}{MagicMissile} = Spells->MagicMissile();
  $spellsAvailable{$self}{Drain}        = Spells->Drain();
  $spellsAvailable{$self}{Shield}       = Spells->Shield();
  $spellsAvailable{$self}{Poison}       = Spells->Poison();
  $spellsAvailable{$self}{Recharge}     = Spells->Recharge();
}

sub takeWound {
  my $self = shift;
  my ($damage) = @_;
  $damage = 0 if $damage < 0;
  return unless $damage;
  $health{$self} -= $damage;
  $health{$self} = 0 if $health{$self} < 0;
  print " - $name{$self} takes $damage damage (and has $health{$self} left)\n";
  print "** $name{$self} is dead!\n" if $health{$self} == 0 && $COMBAT_VERBOSE;
}

sub heal {
  my $self = shift;
  my ($healBy) = @_;
  return unless $healBy;
  $health{$self} += $healBy;
  $health{$self} = $maxHealth{$self} if $health{$self} > $maxHealth{$self};
  print " - $name{$self} is healed for $healBy damage (and now has $health{$self})\n";
}

sub spendMana {
  my $self = shift;
  my $mana = shift;
  $mana{$self} -= $mana;
  print " - $name{$self} spends $mana mana (and now has $mana{$self} left)\n";
  if ($mana{$self} < 0) {
    print "** $name{$self} is unexpectedly dead, drained of Mana!\n";
    exit 20;
  }
  $manaSpent{$self} +- $mana;
}

sub gainMana {
  my $self = shift;
  my $mana = shift;
  return unless $mana;
  $mana{$self} += $mana;
  print " - $name{$self} gains $mana mana (and now has $mana{$self})\n";
}

sub magicalArmour {
  my $self = shift;
  my $newAC = shift;
  if ($newAC != $magicDefense{$self}) {
    print " - $name{$self} now has magical armour of $newAC\n";
  }
  $magicDefense{$self} = $newAC;
}

## Getter Methods

sub reviveHP {
  my $self = shift;
  $health{$self} = $maxHealth{$self};
}

sub reviveMana {
  my $self = shift;
  $mana{$self} = $maxMana{$self};
  $manaSpent{$self} = 0;
}

sub name {
  my $self = shift;
  return $name{$self};
}

sub hp {
  my $self = shift;
  return $health{$self};
}

sub mana {
  my $self = shift;
  return $mana{$self};
}

sub ac {
  my $self = shift;
  my $ac = $magicDefense{$self};
  return $ac;
}

sub dmg {
  my $self = shift;
  my $dmg = $attackStrength{$self};
  return $dmg;
}

sub advantage {
  my $self = shift;
  return $advantage{$self};
}

sub manaSpent {
  my $self = shift;
  return $manaSpent{$self};
}

## Action/combat Methods

sub castRandomSpell {
  my $self = shift;
  my %spellsHash = %{$spellsAvailable{$self}};
  my @spellKeys = (keys %spellsHash);
  my $randSpell = int(rand(scalar(@spellKeys)));
  my $spellKey = $spellKeys[$randSpell];
  my $spell = $spellsAvailable{$self}{$spellKey};
  print "$name{$self} randomly casts ".$spell->name();
  print " on ".$enemy{$self}->name() unless $spell->onSelf();
  print "\n";

  my $hasEffect = $spell->cast($self,$enemy{$self});
  if ($hasEffect) {
    delete($spellsAvailable{$self}{$spellKey});
    $spellsActive{$self}{$spellKey} = $spell;
  }
}

sub activateSpellEffects {
  my $self = shift;
  foreach my $spellKey (sort keys %{$spellsActive{$self}}) {
    my $spell = $spellsActive{$self}{$spellKey};
    if (!$spell->applyEffects()) {
    delete($spellsActive{$self}{$spellKey});
    $spellsAvailable{$self}{$spellKey} = $spell;
    }
  }
}

sub attack {
  my $self = shift;
  my ($target) = @_;

  if ($isWizard{$self}) { # Wizard analyses situation and casts spell
    $self->castRandomSpell();
  } else {  # Fighter attacks with weapon
    my $damage = $self->damagePerRound($target);
    print "$name{$self} attacks ".$target->name()." for $damage damage\n" if $COMBAT_VERBOSE;
    $target->takeWound($damage);
  }
}

sub damagePerRound {
  my $self = shift;
  my ($target) = @_;

  my $dmgPerRound = $self->dmg() - $target->ac();
  $dmgPerRound = 1 if $dmgPerRound < 1;
  return $dmgPerRound;
}

# Class subroutines

sub combat {
  my ($player1, $player2, $verbose) = @_;
  $COMBAT_VERBOSE = $verbose // 0;

  $player1->setEnemy($player2);
  $player1->learnSpells();

  my $turn = 0;
  while (1) {

    $turn++;
    print "Combat: Turn $turn\n";
    # Turn 1
    $player1->activateSpellEffects();
    print "----\n";
    if ($player2->hp() == 0) {
      return $player1;
    }
    $player1->attack($player2);
    if ($player2->hp() == 0) {
      return $player1;
    }
    print "\n";

    $turn++;
    print "Combat: Turn $turn\n";
    # Turn 2
    $player1->activateSpellEffects();
    print "----\n";
    if ($player2->hp() == 0) {
      return $player1;
    }
    $player2->attack($player1);
    if ($player1->hp() == 0) {
      return $player2;
    }
    print "\n";

  }
}

}

1;