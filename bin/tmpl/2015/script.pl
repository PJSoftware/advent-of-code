#!/bin/perl

use strict;
use lib "/c/_dev/advent-of-code/2015/lib";

use Advent;

my %tests = (
  'abcdef'  => 609043,
  'pqrstuv' => 1048970,
);

foreach my $testInput (sort keys %tests) {
  Advent::test($testInput, solve($testInput), $tests{$testInput});
}

my $input = Advent::readBlock('NN-input.txt');
Advent::solution(solve($input));

sub solve {
  my ($input) = @_;

  return 123456;
}
