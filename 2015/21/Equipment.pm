package Equipment;

use strict;

{

my %store = ();

sub available {
  %store = ();

  $store{"Dagger"} = Equipment->newWeapon("Dagger",8,4,0);
  $store{"Shortsword"} = Equipment->newWeapon("Shortsword",10,5,0);
  $store{"Warhammer"} = Equipment->newWeapon("Warhammer",25,6,0);
  $store{"Longsword"} = Equipment->newWeapon("Longsword",40,7,0);
  $store{"Greataxe"} = Equipment->newWeapon("Greataxe",74,8,0);

  $store{"Leather"} = Equipment->newArmour("Leather",13,0,1);
  $store{"Chainmail"} = Equipment->newArmour("Chainmail",31,0,2);
  $store{"Splintmail"} = Equipment->newArmour("Splintmail",53,0,3);
  $store{"Bandedmail"} = Equipment->newArmour("Bandedmail",75,0,4);
  $store{"Platemail"} = Equipment->newArmour("Platemail",102,0,5);

  $store{"Damage +1"} = Equipment->newRing("Damage +1",25,1,0);
  $store{"Damage +2"} = Equipment->newRing("Damage +2",50,2,0);
  $store{"Damage +3"} = Equipment->newRing("Damage +3",100,3,0);
  $store{"Defense +1"} = Equipment->newRing("Defense +1",20,0,1);
  $store{"Defense +2"} = Equipment->newRing("Defense +2",40,0,2);
  $store{"Defense +3"} = Equipment->newRing("Defense +3",80,0,3);

  return %store;
}

my %type = ();
my %name = ();
my %cost = ();
my %attackStrength = ();
my %defendStrength = ();

# Constructor

sub _new_equip {
  my ($class, $type, $name, $cost, $dmg, $armour) = @_;
  my $self = bless \do{my $anon}, $class;
  
  $type{$self} = $type;
  $name{$self} = $name;
  $cost{$self} = $cost;
  $attackStrength{$self} = $dmg;
  $defendStrength{$self} = $armour;
  return $self;
}

sub newWeapon {
  my ($class, $name, $cost, $dmg, $armour) = @_;
  return _new_equip($class, 'WEAPON', $name, $cost, $dmg, $armour);
}
sub newArmour {
  my ($class, $name, $cost, $dmg, $armour) = @_;
  return _new_equip($class, 'ARMOUR', $name, $cost, $dmg, $armour);
}
sub newRing {
  my ($class, $name, $cost, $dmg, $armour) = @_;
  return _new_equip($class, 'RING', $name, $cost, $dmg, $armour);
}

## Getter Methods

sub type {
  my $self = shift;
  return $type{$self};
}

sub name {
  my $self = shift;
  return $name{$self};
}

sub cost {
  my $self = shift;
  return $cost{$self};
}

sub ac {
  my $self = shift;
  return $defendStrength{$self};
}

sub dmg {
  my $self = shift;
  return $attackStrength{$self};
}

sub isWeapon {
  my $self = shift;
  return $type{$self} eq 'WEAPON';
}

sub isArmour {
  my $self = shift;
  return $type{$self} eq 'ARMOUR';
}

sub isRing {
  my $self = shift;
  return $type{$self} eq 'RING';
}

}

1;