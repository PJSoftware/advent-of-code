#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my @testData = (
  'Alice would gain 54 happiness units by sitting next to Bob.',
  'Alice would lose 79 happiness units by sitting next to Carol.',
  'Alice would lose 2 happiness units by sitting next to David.',
  'Bob would gain 83 happiness units by sitting next to Alice.',
  'Bob would lose 7 happiness units by sitting next to Carol.',
  'Bob would lose 63 happiness units by sitting next to David.',
  'Carol would lose 62 happiness units by sitting next to Alice.',
  'Carol would gain 60 happiness units by sitting next to Bob.',
  'Carol would gain 55 happiness units by sitting next to David.',
  'David would gain 46 happiness units by sitting next to Alice.',
  'David would lose 7 happiness units by sitting next to Bob.',
  'David would gain 41 happiness units by sitting next to Carol.',
);
my $testResult = 330;

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

foreach my $input (@testData) {
  addToModel($input);
}
Advent::test('test_happiness',maximiseHappiness(), $testResult);

$DEBUG = 0;
print "\n";
##############################################################################

my @inputData = Advent::readArray('13-input.txt');
foreach my $input (@inputData) {
  addToModel($input);
}
Advent::solution(maximiseHappiness());

sub addToModel {
  my ($input) = @_;
}

sub maximiseHappiness {
  return 0;
}