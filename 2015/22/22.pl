#!/bin/perl

use strict;

use lib "../lib";
use Advent;

use lib ".";
use Actor;

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

## $name, $hp, $mana, $dmg, $isWizard, $adv
my $testWizard1 = Actor->new("Rincewind",10,250,0,1,1);
my $testBoss1 = Actor->new("Spelling",13,0,8,0,0);

print "TEST Combat (1):\n";
my $winner = Actor::combat($testWizard1, $testBoss1, 1);
Advent::test("winner",$winner->name(),$testWizard1->name());
Advent::test("mana spent",$testWizard1->manaSpent(), 226);
Advent::test("boss hp",$testBoss1->hp(),0);
Advent::test("hero hp",$testWizard1->hp(),2);

#####

my $testWizard2 = Actor->new("Merlin",10,250,0,1,1);
my $testBoss2 = Actor->new("Mordred",14,0,8,0,0);

print "TEST Combat (2):\n";
$winner = Actor::combat($testWizard2, $testBoss2, 1);
Advent::test("winner",$winner->name(),$testWizard2->name());
Advent::test("mana spent",$testWizard2->manaSpent(), 641);
Advent::test("boss hp",$testBoss2->hp(),0);
Advent::test("hero hp",$testWizard2->hp(),2);

##### 

my %bossData = Advent::readHash('22-input.txt');
Advent::test("data HP",$bossData{'Hit Points'},51);
Advent::test("data DMG",$bossData{'Damage'},9);

$DEBUG = 0;
print "\n";

exit 1;
##############################################################################

my $hero = Actor->new("Raistlin",50,500,0,1,1);
my $boss = Actor->new("Caramon", $bossData{'Hit Points'},0,$bossData{'Damage'}, 0,0);

$winner = Actor::combat($hero,$boss,1);
Advent::test("wizard won",$winner->name(),$hero->name());
Advent::solution($hero->manaSpent());

##############################################################################
