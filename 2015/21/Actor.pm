package Actor;

use strict;

{

my $COMBAT_VERBOSE = 0;

my %name = ();
my %health = ();
my %attackStrength = ();
my %defendStrength = ();
my %inventory = ();
my %advantage = ();

# Constructor

sub new {
  my ($class, $name, $hp, $dmg, $armour, $adv) = @_;
  my $self = bless \do{my $anon}, $class;
  
  $name{$self} = $name;
  $health{$self} = $hp;
  $attackStrength{$self} = $dmg;
  $defendStrength{$self} = $armour;
  $advantage{$self} = $adv;
  @{$inventory{$self}} = ();

  return $self;
}

## Getter Methods

sub name {
  my $self = shift;
  return $name{$self};
}

sub hp {
  my $self = shift;
  return $health{$self};
}

sub ac {
  my $self = shift;
  return $defendStrength{$self};
}

sub dmg {
  my $self = shift;
  return $attackStrength{$self};
}

sub advantage {
  my $self = shift;
  return $advantage{$self};
}

## Action/combat Methods

sub canDefeat {
  my $self = shift;
  my ($target) = @_;

  my $advantage = $self->advantage() - $target->advantage();
  my $roundsToVictory = $self->roundsToDefeat($target);
  my $roundsToDefeat = $target->roundsToDefeat($self);
  $roundsToVictory -= $advantage;
  return ($roundsToVictory < $roundsToDefeat)?1:0;
}

sub roundsToDefeat {
  my $self = shift;
  my ($target) = @_;

  my $dmgPerRound = $self->damagePerRound($target);
  my $rounds = int($target->hp()/$dmgPerRound);
  if ($dmgPerRound * $rounds < $target->hp()) {
    $rounds++;
  }
  # print $self->name()." will take $rounds rounds to defeat ".$target->name()."\n";
  return $rounds;
}

sub attack {
  my $self = shift;
  my ($target) = @_;
  my $damage = $self->damagePerRound($target);
  print "$name{$self} attacks ".$target->name()." for $damage damage\n" if $COMBAT_VERBOSE;
  $target->takeWound($damage);
}

sub damagePerRound {
  my $self = shift;
  my ($target) = @_;

  my $dmgPerRound = $self->dmg() - $target->ac();
  $dmgPerRound = 1 if $dmgPerRound < 1;
  return $dmgPerRound;
}

sub takeWound {
  my $self = shift;
  my ($damage) = @_;
  $damage = 0 if $damage < 0;
  $health{$self} -= $damage;
  $health{$self} = 0 if $health{$self} < 0;
  print "** $name{$self} is dead!\n" if $health{$self} == 0 && $COMBAT_VERBOSE;
}

# Class subroutines

sub combat {
  my ($player1, $player2, $verbose) = @_;
  $COMBAT_VERBOSE = $verbose // 0;

  if ($player2->advantage() > $player1->advantage()) {
    ($player1,$player2) = ($player2,$player1);
  }
  print $player1->name()." has advantage, and attacks first!\n" if $COMBAT_VERBOSE;

  while (1) {

    $player1->attack($player2);
    if ($player2->hp() == 0) {
      return $player1;
    }

    $player2->attack($player1);
    if ($player1->hp() == 0) {
      return $player2;
    }

  }
}

}

1;