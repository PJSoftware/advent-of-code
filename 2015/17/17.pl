#!/bin/perl

use strict;
use lib "../lib";

use Advent;
use List::Util qw{ sum };

my @testSizes = qw{ 20 15 10 5 5 };
my $testVolume = 25;
my $testOptCount = 4;
my $testMinCount = 3;


##############################################################################
print "Tests: generateCombosWithTarget\n";

my @results = ();

@results = Advent::generateCombinationsWithTarget(10,(10));
print "Num of results = ".@results."\n";
foreach my $result (@results) {
  print " - @{$result}\n";
}

@results = Advent::generateCombinationsWithTarget(10,(7,3,3));
print "Num of results = ".@results."\n";
foreach my $result (@results) {
  print " - @{$result}\n";
}

@results = Advent::generateCombinationsWithTarget($testVolume,@testSizes);
print "Num of results = ".@results."\n";
foreach my $result (@results) {
  print " - @{$result}\n";
}

##############################################################################
print "Tests: (@testSizes) => $testVolume\n";
my $DEBUG = 1;

my @testSolution = Advent::generateCombinationsWithTarget($testVolume, @testSizes);
Advent::test("options", scalar(@testSolution), $testOptCount);
Advent::test("count-minimum", countMinimum(@testSolution), $testMinCount);

$DEBUG = 0;
print "\n";
##############################################################################

my @containers = Advent::readArray('17-input.txt');
my $targetVolume = 150;

my @solution = Advent::generateCombinationsWithTarget($targetVolume, @containers);
Advent::solution(scalar(@solution),"number of ways to store 150L");
Advent::solution(countMinimum(@solution),"number of ways with minimal containers");

sub countMinimum {
  my (@options) = @_;

  my $minimum = -1;
  my $count = 0;
  foreach my $choice (@options) {
    my $num = scalar(@{$choice});
    if ($minimum == -1 || $num < $minimum) {
      $count = 1;
      $minimum = $num;
    } elsif ($num == $minimum) {
      $count++;
    }
  }

  return $count;
}