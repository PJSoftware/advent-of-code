#!/bin/perl

use strict;

use lib "../lib";
use Advent;

use lib ".";
use Actor;

my %tests = (
  'abcdef'  => 609043,
  'pqrstuv' => 1048970,
);

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

##                        $name, $hp, $mana, $dmg, $isWizard, $adv
my $testWizard = Actor->new("Wizard",10,250,0,1,1);
my $testBoss = Actor->new("Boss",13,0,8,0,0);

print "TEST Combat:\n";
# Advent::test("will hero win",$testWizard->canDefeat($testBoss),1);
# Advent::test("will boss win",$testBoss->canDefeat($testWizard),0);

my $winner = Actor::combat($testWizard, $testBoss, 1);
Advent::test("winner",$winner->name(),$testWizard->name());
Advent::test("boss hp",$testBoss->hp(),0);
Advent::test("hero hp",$testWizard->hp(),2);

my %bossData = Advent::readHash('22-input.txt');
Advent::test("data HP",$bossData{'Hit Points'},51);
Advent::test("data DMG",$bossData{'Damage'},9);

$DEBUG = 0;
print "\n";

exit 1;
##############################################################################

Advent::solution("enter code here");

##############################################################################
