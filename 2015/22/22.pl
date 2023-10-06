#!/bin/perl

use strict;

use lib "../lib";
use Advent;

use lib '.';
use Fight;

my %tests = (
  'abcdef'  => 609043,
  'pqrstuv' => 1048970,
);

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

my $testCombat1 = Fight->new();
$testCombat1->addHero(10,250);
$testCombat1->addBoss(13,8);
$testCombat1->bestFight();
Advent::test("optimal mana spend 1", $testCombat1->manaSpent(),226);

my $testCombat2 = Fight->new();
$testCombat2->addHero(10,250);
$testCombat2->addBoss(14,8);
$testCombat2->bestFight();
Advent::test("optimal mana spend 2", $testCombat2->manaSpent(),641);

$DEBUG = 0;
print "\n";

exit 1;
##############################################################################

my $combat = Fight->new();
$combat->addHero(50,500);
$combat->addBoss(51,9); # Hard coded values from input
$combat->bestFight();
Advent::solution($combat->manaSpent());
