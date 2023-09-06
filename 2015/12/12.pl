#!/bin/perl

use strict;
use lib "../lib";

use Advent;
use List::Util qw{ sum };

my %tests = (

  '[1,2,3]' => 6,
  '{"a":2,"b":4}' => 6,
  '[[[3]]]' => 3,
  '{"a":{"b":4},"c":-1}' => 3,
  '{"a":[-1,1]}' => 0,
  '[-1,{"a":1}]' => 0,
  '[]' => 0,
  '{}' => 0,
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

my $input = Advent::readBlock('12-input.txt');
Advent::solution(solve($input));

sub solve {
  my ($input) = @_;

  my @numbers = split(/[^-0-9]+/,$input);
  # print "$input -> @numbers\n" if $DEBUG;

  if (scalar(@numbers) == 0) { return 0; }
  return sum(@numbers);
}
