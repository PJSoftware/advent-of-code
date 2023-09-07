#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my @tests = (
  'Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.',
  'Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.',
);

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

my %testHerd = ();
my $testRaceDuration = 1000;
my $testWinner = 'Comet => 1120';
foreach my $testInput (sort @tests) {
  registerReindeer(\%testHerd, $testInput);
}
Advent::test("test race", runRace(\%testHerd, $testRaceDuration), $testWinner);

$DEBUG = 0;
print "\n";
##############################################################################

my @reindeer = Advent::readArray('14-input.txt');
my %racers = ();
my $raceDuration = 2503;

foreach my $deerStats (sort @reindeer) {
  registerReindeer(\%racers, $deerStats);
}
Advent::solution(runRace(\%racers, $raceDuration));

sub registerReindeer {
  my ($dbRef, $stats) = @_;
}

sub runRace {
  my ($dbRef, $duration) = @_;
  return 0;
}
