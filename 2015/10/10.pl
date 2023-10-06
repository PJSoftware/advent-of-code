#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my %tests = (
  '1' => '11',
  '11' => '21',
  '21' => '1211',
  '1211' => '111221',
  '111221' => '312211',
);

foreach my $testInput (sort keys %tests) {
  Advent::test($testInput, solveLinear($testInput), $tests{$testInput});
}

my $input = Advent::readBlock('10-input.txt');
my $answer;
for my $i (1..50) {
  $answer = solveLinear($input);
  $input = $answer;
  print "$i -> ".length($answer)."\n";
}
Advent::solution(length($answer));

## solveRecursive() fails with an 'Out of memory!' error while attempting to
## calculate the 42nd result in the sequence. The length of #41 id 469694.
sub solveRecursive {
  my ($input) = @_;

  if ($input eq '') {
    return '';
  }

  if ($input =~ m{^(\d)(\1*)(.*)}) {
    my $ch = $1;
    my $seq = $2;
    my $rem = $3;
    my $len = length("$ch$seq");
    return "$len$ch".solveRecursive($rem);
  }

  print "Could not parse '$input'\n";
  exit 1;
}

sub solveLinear {
  my ($input) = @_;

  my $rv = '';
  my ($ch,$seq,$rem);
  do {
    if ($input =~ m{^(\d)(\1*)(.*)}) {
      $ch = $1;
      $seq = $2;
      $rem = $3;
      my $len = length("$ch$seq");
      $rv .= "$len$ch";
      $input = $rem;
    }
  } while $rem ne '';
  return $rv;
}