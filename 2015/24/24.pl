#!/bin/perl

use strict;

use lib "../lib";
use Advent;

my @testWeights = (1,2,3,4,5,7,8,9,10,11);

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

Advent::test("compartment weight", compartmentWeight(\@testWeights), 15);
my @testPassengerSpace = smallestGroup(\@testWeights);
Advent::test("quantum entanglement", quantumEntanglement(\@testPassengerSpace), 44);

$DEBUG = 0;
print "\n";

##############################################################################

my @weights = Advent::readArray('24-input.txt');

Advent::solution(compartmentWeight(\@weights), "compartment weight");
my @PassengerSpace = smallestGroup(\@weights);
Advent::solution(quantumEntanglement(\@PassengerSpace), "quantum entanglement");

##############################################################################

sub compartmentWeight {
  my ($weightsRef) = @_;

  my $sum = 0;
  foreach my $weight (@{$weightsRef}) {
    $sum += $weight;
  }
  return int($sum/4);
}

sub smallestGroup {
  my ($weightsRef) = @_;

  my $target = compartmentWeight($weightsRef);
  my @possible = Advent::generateCombinationsWithTarget($target,@{$weightsRef});

  my @rv = ();
  my $size = scalar(@{$weightsRef})+1;
  my $qe = quantumEntanglement($weightsRef);

  foreach my $optRef (@possible) {
    my $newQE = quantumEntanglement($optRef);
    if (scalar(@{$optRef}) < $size) {
      @rv = @{$optRef};
      $qe = $newQE;
      $size = scalar(@rv);
    } elsif (scalar(@{$optRef}) == $size && $newQE < $qe) {
      @rv = @{$optRef};
      $qe = $newQE;
    }
  }

  return @rv;
}

sub findGroups {
  my ($target, $weightsRef) = @_;
  my @rv = Advent::generateCombinationsWithTarget($target, @{$weightsRef});
  return @rv;
}

sub quantumEntanglement {
  my ($weightsRef) = @_;

  my $prod = 1;
  foreach my $weight (@{$weightsRef}) {
    $prod *= $weight;
  }
  return $prod;
}