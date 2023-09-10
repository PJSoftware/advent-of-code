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
my %clueEQ = (
  children => 3,
  samoyeds => 2,
  akitas => 0,
  vizslas => 0,
  cars => 2,
  perfumes => 1,
);

my %clueLT = (
  pomeranians => 3,
  goldfish => 5,
);

my %clueGT = (
  cats => 7,
  trees => 3,
);

foreach my $aunt (@auntData) {
  if ($aunt =~ m{^Sue (\d+): (\S+): (\d+), (\S+): (\d+), (\S+): (\d+)$}) {
    my ($num,$obj1,$c1,$obj2,$c2,$obj3,$c3) = ($1,$2,$3,$4,$5,$6,$7);
    if (good($obj1,$c1) && good($obj2,$c2) && good($obj3,$c3)) {
      print "Aunt Sue #$num is a match! -> $aunt\n";
    }
  } else {
    print "Input not as expected: '$aunt'\n";
  }
}

sub good {
  my ($clue, $count) = @_;
  if (defined($clueEQ{$clue}) && $count == $clueEQ{$clue}) {
    return 1;
  }
  if (defined($clueLT{$clue}) && $count < $clueLT{$clue}) {
    return 1;
  }
  if (defined($clueGT{$clue}) && $count > $clueGT{$clue}) {
    return 1;
  }
  return 0;
}