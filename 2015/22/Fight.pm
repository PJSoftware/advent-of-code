package Fight;

use strict;

use List::Util qw{ min max };

use lib '.';
use Spells;

{

# Package variables
my %spellsAvail = ();
my $optimalFight = 0;
my @optimalSpells = ();

# Object variables
my %heroHP = ();
my %heroMax = ();
my %heroAC = ();
my %heroMana = ();
my %heroManaSpent = ();

my %isHard = ();

my %bossHP = ();
my %bossMax = ();
my %bossDmg = ();

my %pass = ();
my %parent = ();

my %fightSpellsUsed = ();
my %fightSpellsAvail = ();

sub initSpellList {
  return if scalar(keys %spellsAvail);
  foreach my $spell (
    Spells->MagicMissile(),
    Spells->Drain(),
    Spells->Shield(),
    Spells->Poison(),
    Spells->Recharge(),
  ) {
    $spellsAvail{$spell->name()} = $spell;
  }
}

sub new {
  my $class = shift;
  $optimalFight = 0;

  my $self = bless \do{my $anon}, $class;
  initSpellList();
  @{$fightSpellsUsed{$self}} = ();
  foreach my $spellName (keys %spellsAvail) {
    $fightSpellsAvail{$self}{$spellName} = 0;
  }
  
  $pass{$self} = 0;
  $isHard{$self} = 0;
  return $self;
}

sub addHero {
  my $self = shift;
  my ($hp,$mana) = @_;
  $heroHP{$self} = $hp;
  $heroMax{$self} = $hp;
  $heroAC{$self} = 0;
  $heroMana{$self} = $mana;
  $heroManaSpent{$self} = 0;
}

sub addBoss {
  my $self = shift;
  my ($hp,$dmg) = @_;
  $bossHP{$self} = $hp;
  $bossMax{$self} = $hp;
  $bossDmg{$self} = $dmg;
}

sub setDifficultyHard {
  my $self = shift;
  $isHard{$self} = 1;
}

sub bestFight {
  my $self = shift;
  my @options = ();

  # Start Player Turn
  $heroHP{$self}-- if $isHard{$self};
  return if $heroHP{$self} <= 0;

  $self->triggerSpellEffects();
  foreach my $spellID ($self->canCast()) {
    my $option = $self->child();
    $option->cast($spellID);

    # Start Boss Turn
    $option->triggerSpellEffects();
    $option->bossAttack();
    push(@options,$option) if $option->isOngoing();
  }

  foreach my $option (@options) {
    $option->bestFight();
  }
}

sub canCast {
  my $self = shift;

  my @spells = ();
  foreach my $spellID (keys %{$fightSpellsAvail{$self}}) {
    push(@spells,$spellID) if $fightSpellsAvail{$self}{$spellID} == 0;
  }

  return @spells;
}

sub child {
  my $self = shift;
  my $child = bless \do{my $anon}, 'Fight';

  $heroHP{$child} = $heroHP{$self};
  $heroMax{$child} = $heroMax{$self};
  $heroAC{$child} = $heroAC{$self};
  $heroMana{$child} = $heroMana{$self};
  $heroManaSpent{$child} = $heroManaSpent{$self};

  $bossHP{$child} = $bossHP{$self};
  $bossMax{$child} = $bossMax{$self};
  $bossDmg{$child} = $bossDmg{$self};

  $isHard{$child} = $isHard{$self};

  $pass{$child} = $pass{$self}+1;

  foreach my $spellName (keys %spellsAvail) {
    $fightSpellsAvail{$child}{$spellName} = $fightSpellsAvail{$self}{$spellName};
  }

  $parent{$child} = $parent{$self} || $self;
  @{$fightSpellsUsed{$child}} = @{$fightSpellsUsed{$self}};

  return $child;
}

sub cast {
  my $self = shift;
  my ($spellID) = @_;
  my $spell = $spellsAvail{$spellID};

  my @spells = @{$fightSpellsUsed{$self}};
  push(@spells,$spell);
  @{$fightSpellsUsed{$self}} = @spells;

  $heroMana{$self} -= $spell->cost();
  if ($heroMana{$self} < 0) {
    $heroHP{$self} = 0; # drained by excess magic use
    return;
  }

  $heroManaSpent{$self} += $spell->cost();

  if ($spell->duration == 0) {
    $bossHP{$self} = max(0,$bossHP{$self}-$spell->attackPerTurn());
    $heroHP{$self} = min($heroHP{$self}+$spell->healPerTurn(),$heroMax{$self});
  } else {
    $fightSpellsAvail{$self}{$spell->name()} = $spell->duration();
  }
}

sub triggerSpellEffects {
  my $self = shift;

  foreach my $spellID (keys %{$fightSpellsAvail{$self}}) {
    my $duration = $fightSpellsAvail{$self}{$spellID};
    my $spell = $spellsAvail{$spellID};
    if ($duration > 0) {
      $bossHP{$self} = max(0,$bossHP{$self}-$spell->attackPerTurn());
      $heroHP{$self} = min($heroHP{$self}+$spell->healPerTurn(),$heroMax{$self});
      $heroMana{$self} += $spell->rechargePerTurn();
      if ($spell->armourBonus() > 0) {
        $heroAC{$self} = $spell->armourBonus();
      }

      $duration--;
      if ($duration == 0 && $spell->armourBonus() > 0) {
        $heroAC{$self} = 0;
      }

      $fightSpellsAvail{$self}{$spellID} = $duration;
    }
  }
}

sub bossAttack {
  my $self = shift;
  return if $bossHP{$self} <= 0;

  my $dmg = max(1,$bossDmg{$self}-$heroAC{$self});
  $heroHP{$self} -= $dmg;
}

sub isOngoing {
  my $self = shift;

  if ($heroHP{$self} <= 0) {
    return 0;
  }

  if ($bossHP{$self} <= 0) {
    if ($optimalFight == 0 || $heroManaSpent{$self} < $optimalFight) {
      $optimalFight = $heroManaSpent{$self};
      @optimalSpells = @{$fightSpellsUsed{$self}};
      $self->status();
    }
    return 0;
  }

  if ($optimalFight > 0 && $heroManaSpent{$self} > $optimalFight) {
    return 0;
  }

  return 1;
}

sub status {
  my $self = shift;
  print "At Pass $pass{$self}: ";
  print "Hero HP: $heroHP{$self}/$heroMax{$self}; ";
  print "Boss HP: $bossHP{$self}/$bossMax{$self}; ";
  print " **HARD**" if $isHard{$self};
  print "\n";
  print "Optimal mana cost => $optimalFight\n";
  foreach my $spell (@optimalSpells) {
    print " -> ".$spell->name()."\n";
  }
  print "\n";
}

sub manaSpent {
  my $self = shift;
  return $heroManaSpent{$self};
}

sub optimalFight {
  return $optimalFight;
}

sub optimalSpells {
  return @optimalSpells;
}
}

1;
