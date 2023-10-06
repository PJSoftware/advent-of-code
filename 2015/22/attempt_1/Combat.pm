package Combat;

use strict;
use lib '.';
use Actor;

my $LOWEST_WINNING_MANA = 0;

my %hero = ();
my %boss = ();
my %lost = ();
my %drained = ();

sub new {
  my ($class, $hero, $boss) = @_;
  my $self = bless \do{my $anon}, $class;
  
  $hero{$self} = $hero->copy();
  $boss{$self} = $boss->copy();
  $lost{$self} = 0;
  return $self;
}

sub available {
  my $self = shift;
  return $hero{$self}->spellsAvailable();
}

sub nextRound {
  my $self = shift;
  my ($spell) = @_;

  if ($spell->cost() > $hero{$self}->mana()) {
    $drained{$self} = 1;
    return 1;
  }

  # Hero turn
  $hero{$self}->activateSpellEffects();
  if ($self->combatOver()) {
    return 1;
  }
  $hero{$self}->castSpell()
  $spell->cast($hero{$self},$boss{$self});
  if ($self->combatOver()) {
    return 1;
  }

  #Boss turn
  $hero{$self}->activateSpellEffects();
  if ($self->combatOver()) {
    return 1;
  }
  $boss{$self}->attack($hero{$self});
  if ($self->combatOver()) {
    return 1;
  }

  return 0;
}

sub winner {
  my $self = shift();
  if ($drained{$self}) {
    return $boss{$self};
  }

  if ($hero{$self}->hp() == 0) {
    return $boss{$self};
  }

  if ($boss{$self}->hp() == 0) {
    return $hero{$self};
  }

  return 0;
}

sub combatOver {
  my $self = shift;
  if ($self->winner() == 0) {
    return 0;
  }

  return 1;
}