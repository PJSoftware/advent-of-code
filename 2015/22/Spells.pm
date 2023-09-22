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

sub new {
  my ($class, $name, $cost, $duration, $attack, $heal, $recharge, $shield) = @_;
  my $self = bless \do{my $anon}, $class;
  
  $name{$self} = $name;

  $manaCost{$self} = $cost;
  $duration{$self} = $duration;

  $attackPerTurn{$self} = $attack;
  $healPerTurn{$self} = $heal;
  $rechargePerTurn{$self} = $recharge;
  $armourBonus{$self} = $shield;

  return $self;
}

## spells available

sub MagicMissile  { return Spells->new('Magic Missile',  53, 0, 4, 0, 0, 0); }
sub Drain         { return Spells->new('Drain',          73, 0, 2, 2, 0, 0); }
sub Shield        { return Spells->new('Shield',        113, 6, 0, 0, 0, 7); }
sub Poison        { return Spells->new('Poison',        173, 6, 0, 4, 0, 0); }
sub Recharge      { return Spells->new('Recharge',      229, 5, 0, 0, 101, 0); }

## spell attributes

sub name { my $self = shift; return $name{$self}; }
sub cost { my $self = shift; return $manaCost{$self}; }
sub duration { my $self = shift; return $duration{$self}; }

sub attackPerTurn { my $self = shift; return $attackPerTurn{$self}; }
sub healPerTurn { my $self = shift; return $healPerTurn{$self}; }
sub rechargePerTurn { my $self = shift; return $rechargePerTurn{$self}; }
sub armourBonus { my $self = shift; return $armourBonus{$self}; }

}

1;
