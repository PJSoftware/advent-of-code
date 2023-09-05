#!/bin/perl

use strict;
use lib "/c/_dev/advent-of-code/2015/lib";

use Advent;

my %tests = (
  '1' => '11',
  '11' => '21',
  '21' => '1211',
  '1211' => '111221',
  '111221' => '312211',
);

foreach my $testInput (sort keys %tests) {
  Advent::test($testInput, solve($testInput), $tests{$testInput});
}

my $input = Advent::readBlock('10-input.txt');
my $answer;
for my $i (1..40) {
  $answer = solve($input);
  $input = $answer;
  print "$i -> ".length($answer)."\n";
}
Advent::solution(length($answer));

sub solve {
  my ($input) = @_;

  if ($input eq '') {
    return '';
  }

  if ($input =~ m{^(\d)(\1*)(.*)}) {
    my $ch = $1;
    my $seq = $2;
    my $rem = $3;
    my $len = length("$ch$seq");
    return "$len$ch".solve($rem);
  }

  print "Could not parse '$input'\n";
  exit 1;
}
