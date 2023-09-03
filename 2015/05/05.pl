#!/bin/perl

use strict;
use lib "/c/_dev/advent-of-code/lib";

use Advent;

my %tests = (
  'ugknbfddgicrmopn' => 'nice',
  'aaa' => 'nice',
  'jchzalrnumimnmhp' => 'naughty',
  'haegwjzuvuyypxyu' => 'naughty',
  'dvszwmarrgswjxmb' => 'naughty',
);

foreach my $testInput (sort keys %tests) {
  Advent::test($testInput, solve($testInput), $tests{$testInput});
}

my @input = Advent::readArray('05-input.txt');

my $count = 0;
foreach my $word (@input) {
  $count++ if solve($word) eq 'nice';  
}
Advent::solution($count);

sub solve {
  my ($input) = @_;

  my $naughty = 'naughty';
  my $nice = 'nice';

  return $naughty if $input =~ m{ab|cd|pq|xy};
  return $naughty unless $input =~ m/([aeiou].*){3}/;
  return $naughty unless $input =~ m{([a-z])\1};  
  return $nice;
}
