#!/bin/perl

use strict;
use lib "../lib";

use Advent;
use List::Util qw{ sum };

my @testSizes = qw{ 20 15 10 5 5 };
my $testVolume = 25;
my $testOptions = 4;


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

Advent::test("options", solve($testVolume, @testSizes), $testOptions);

$DEBUG = 0;
print "\n";
##############################################################################

my @containers = Advent::readArray('17-input.txt');
my $targetVolume = 150;
Advent::solution(solve($targetVolume, @containers));

sub solve {
  my ($target, @data) = @_;
  my @solution = Advent::generateCombinationsWithTarget($target,@data);
  # print "Num of results = ".@solution."\n";
  # foreach my $result (@solution) {
  #   my $sum = sum(@{$result});
  #   print " - sum(@{$result}) = $sum\n";
  # }

  return scalar(@solution);
}
