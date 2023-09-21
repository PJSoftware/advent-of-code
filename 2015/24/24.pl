#!/bin/perl

use strict;

use lib "../lib";
use Advent;

my @testWeights = (1,2,3,4,5,7,8,9,10,11);

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

Advent::test("compartment weight", compartmentWeight(@testWeights), 20);
my @testPassengerSpace = smallestGroup(@testWeights);
Advent::test("quantum entanglement", quantumEntanglement(@testPassengerSpace), 99);

$DEBUG = 0;
print "\n";

exit 1;
##############################################################################

my @weights = Advent::readArray('24-input.txt');

Advent::solution(compartmentWeight(@weights), "compartment weight");
my @PassengerSpace = smallestGroup(@weights);
Advent::solution(quantumEntanglement(@PassengerSpace), "quantum entanglement");

##############################################################################

sub compartmentWeight {
  my (@weights) = @_;

  my $sum = 0;
  foreach my $weight (@weights) {
    $sum += $weight;
  }
  return int($sum/3);
}

sub smallestGroup {
  my (@weights) = @_;
  return @weights;
}

sub quantumEntanglement {
  my (@weights) = @_;

  my $prod = 1;
  foreach my $weight (@weights) {
    $prod *= $weight;
  }
  return $prod;
}