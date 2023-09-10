#!/bin/perl

use strict;
use lib "../lib";

use Advent;

# my %tests = (
#   'abcdef'  => 609043,
#   'pqrstuv' => 1048970,
# );

# ##############################################################################
# print "Tests:\n";
# my $DEBUG = 1;

# foreach my $testInput (sort keys %tests) {
#   Advent::test($testInput, solve($testInput), $tests{$testInput});
# }

# $DEBUG = 0;
# print "\n";
##############################################################################

my @auntData = Advent::readArray('16-input.txt');
my %clue = (
  children => 3,
  cats => 7,
  samoyeds => 2,
  pomeranians => 3,
  akitas => 0,
  vizslas => 0,
  goldfish => 5,
  trees => 3,
  cars => 2,
  perfumes => 1,
);

foreach my $aunt (@auntData) {
  if ($aunt =~ m{^Sue (\d+): (\S+): (\d+), (\S+): (\d+), (\S+): (\d+)$}) {
    my ($num,$obj1,$c1,$obj2,$c2,$obj3,$c3) = ($1,$2,$3,$4,$5,$6,$7);
    if ($clue{$obj1} eq $c1 && $clue{$obj2} eq $c2 && $clue{$obj3} eq $c3) {
      print "Aunt Sue #$num is a match! -> $aunt\n";
    }
  } else {
    print "Input not as expected: '$aunt'\n";
  }
}