#!/bin/perl

use strict;

use lib "../lib";
use Advent;

use lib ".";
use Actor;
use Equipment;

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

my $testHero = Actor->new("Hero",8,5,5,1);
my $testBoss = Actor->new("Boss",12,7,2,0);

print "TEST Combat:\n";
Advent::test("will hero win",$testHero->canDefeat($testBoss),1);
Advent::test("will boss win",$testBoss->canDefeat($testHero),0);

my $winner = Actor::combat($testHero, $testBoss, 1);
Advent::test("winner",$winner->name(),$testHero->name());
Advent::test("boss hp",$testBoss->hp(),0);
Advent::test("hero hp",$testHero->hp(),2);

my %bossData = Advent::readHash('21-input.txt');
Advent::test("data HP",$bossData{'Hit Points'},100);
Advent::test("data DMG",$bossData{'Damage'},8);
Advent::test("data AC",$bossData{'Armor'},2);

$DEBUG = 0;
print "\n";

##############################################################################

my $hero = Actor->new("Hero McStudly", 100,0,0, 1);
my $boss = Actor->new("Boss von BadGuy", $bossData{'Hit Points'}, $bossData{'Damage'}, $bossData{'Armor'});

if ($hero->canDefeat($boss)) {
  print "That was a cheap win!\n";
  Actor::combat($hero,$boss,1);
}

my %EquipRUs = Equipment::available();
print "Items available: ".scalar(keys %EquipRUs)."\n";

$hero->buy($EquipRUs{'Greataxe'});
$hero->buy($EquipRUs{'Chainmail'});
Advent::solution($hero->canDefeat($boss));
Advent::solution($hero->inventoryCost(),"cost");

my %allOptions = purchaseOptions(%EquipRUs);

optimisePurchases($hero,$boss, %allOptions);
Actor::combat($hero,$boss,1);
$hero->showInventory();
Advent::solution($hero->inventoryCost(),"cost");

# Traitor shopkeep
$hero->revive();
$boss->revive();

deoptimisePurchases($hero,$boss, %allOptions);
Actor::combat($hero,$boss,1);
$hero->showInventory();
Advent::solution($hero->inventoryCost(),"cost");
##############################################################################

sub purchaseOptions {
  my (%shop) = @_;
  
  my @weapon = ();
  my @armour = ();
  my @ring = ();

  foreach my $item (sort keys %shop) {
    my $equip = $shop{$item};
    push(@weapon,$equip) if $equip->isWeapon();
    push(@armour,$equip) if $equip->isArmour();
    push(@ring,$equip) if $equip->isRing();
  }

  my %options = ();
  foreach my $wIdx (0 .. $#weapon) {
    foreach my $aIdx (-1 .. $#armour) {
      foreach my $r1Idx (-1 .. $#ring) {
        foreach my $r2Idx (-1 .. $r1Idx-1) {
          my @swag = ();
          push(@swag,$weapon[$wIdx]);
          push(@swag,$armour[$aIdx]) if $aIdx >= 0;
          push(@swag,$ring[$r1Idx]) if $r1Idx >= 0;
          push(@swag,$ring[$r2Idx]) if $r2Idx >= 0;
          my $cost = 0;
          foreach my $item (@swag) {
            $cost += $item->cost();
          }
          # Using \@swag as a key stringifies it; it is no longer a reference
          my $key = "KEY:".\@swag;
          $options{$key}{cost} = $cost;
          $options{$key}{swag} = \@swag;
        }
      }
    }
  }
  return %options;
}

sub optimisePurchases {
  my ($hero,$boss, %options) = @_;

  foreach my $opt (sort { $options{$a}{cost} <=> $options{$b}{cost} } keys %options) {
    my $cost = $options{$opt}{cost};
    $hero->dropAll();
    foreach my $item (@{$options{$opt}{swag}}) {
      $hero->buy($item);
    }

    if ($hero->canDefeat($boss)) {
      return;
    }
  }
}

sub deoptimisePurchases {
  my ($hero,$boss, %options) = @_;

  foreach my $opt (sort { $options{$b}{cost} <=> $options{$a}{cost} } keys %options) {
    my $cost = $options{$opt}{cost};
    $hero->dropAll();
    foreach my $item (@{$options{$opt}{swag}}) {
      $hero->buy($item);
    }

    if (!$hero->canDefeat($boss)) {
      return;
    }
  }
}