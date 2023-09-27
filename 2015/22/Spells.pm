package Spells;

use strict;

use lib '.';
use Actor; ## Can Perl do circular dependencies?

{

my %name = ();

my %manaCost = ();
my %duration = ();

my %attackPerTurn = ();
my %healPerTurn = ();
my %rechargePerTurn = ();
my %armourBonus = ();
my %turnsRemaining = ();
my %onSelf = ();

my %caster = ();
my %target = ();

sub new {
  my ($class, $name, $cost, $duration, $attack, $heal, $recharge, $shield, $onSelf) = @_;
  my $self = bless \do{my $anon}, $class;
  
  $name{$self} = $name;

  $manaCost{$self} = $cost;
  $duration{$self} = $duration;

  $attackPerTurn{$self} = $attack;
  $healPerTurn{$self} = $heal;
  $rechargePerTurn{$self} = $recharge;
  $armourBonus{$self} = $shield;
  $onSelf{$self} = $onSelf;

  $turnsRemaining{$self} = 0;

  return $self;
}

## spells available

sub MagicMissile  { return Spells->new('Magic Missile',  53, 0, 4, 0, 0, 0, 0); }
sub Drain         { return Spells->new('Drain',          73, 0, 2, 2, 0, 0, 0); }
sub Shield        { return Spells->new('Shield',        113, 6, 0, 0, 0, 7, 1); }
sub Poison        { return Spells->new('Poison',        173, 6, 3, 0, 0, 0, 0); }
sub Recharge      { return Spells->new('Recharge',      229, 5, 0, 0, 101, 0, 1); }

sub cast {
  my $self = shift();
  my ($caster,$target) = @_;
  $caster{$self} = $caster;
  $target{$self} = $target;
  $self->caster()->spendMana($self->cost());
  
  if ($duration{$self} == 0) {
    $self->applyEffects(1);
    return 0;
  } else {
    $turnsRemaining{$self} = $duration{$self};
    return 1;
  }
}

sub caster { my $self = shift; return $caster{$self}; }
sub target { my $self = shift; return $target{$self}; }

sub applyEffects {
  my $self = shift;
  my $isImmediate = shift // 0;

  $self->target()->takeWound($self->attackPerTurn(),$self->name());
  $self->caster()->heal($self->healPerTurn(),$self->name());
  $self->caster()->gainMana($self->rechargePerTurn(),$self->name());
  $self->caster()->magicalArmour($self->armourBonus(),$self->name()) if $self->armourBonus();

  return 0 if $isImmediate;
  
  $turnsRemaining{$self}--;
  if ($turnsRemaining{$self} == 0 && $self->armourBonus() > 0) {
    $self->caster()->magicalArmour(0);
  }

  return ($turnsRemaining{$self} > 0);
}

## spell attributes

sub name { my $self = shift; return $name{$self}; }
sub cost { my $self = shift; return $manaCost{$self}; }
sub duration { my $self = shift; return $duration{$self}; }

sub attackPerTurn { my $self = shift; return $attackPerTurn{$self}; }
sub healPerTurn { my $self = shift; return $healPerTurn{$self}; }
sub rechargePerTurn { my $self = shift; return $rechargePerTurn{$self}; }
sub armourBonus { my $self = shift; return $armourBonus{$self}; }

sub onSelf { my $self = shift; return $onSelf{$self}; }

}

1;
