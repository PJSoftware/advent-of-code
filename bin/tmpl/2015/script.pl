#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my %tests = (
  'abcdef'  => 609043,
  'pqrstuv' => 1048970,
);

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

foreach my $testInput (sort keys %tests) {
  Advent::test($testInput, solve($testInput), $tests{$testInput});
}

$DEBUG = 0;
print "\n";
##############################################################################

my $input = Advent::readBlock('NN-input.txt');
Advent::solution(solve($input));

sub solve {
  my ($input) = @_;

  return 123456;
}
