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

# Actor::combat($hero,$boss,1);

##############################################################################
