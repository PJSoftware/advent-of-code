#!/bin/perl

use strict;
use lib "/c/_dev/advent-of-code/lib";

use Advent;
use Digest::MD5 qw{ md5_hex };

my %tests = (
  'abcdef'  => 609043,
  'pqrstuv' => 1048970,
);

foreach my $testInput (sort keys %tests) {
  Advent::test($testInput, solve($testInput, 5), $tests{$testInput});
}
print "\n";

my $input = Advent::readBlock('04-input.txt');
Advent::solution(solve($input, 6));

### solver ###

sub solve {
  my ($input, $numZeroes) = @_;

  my $prefix = '0' x $numZeroes;
  my $rv = 0;
  my $md5 = '';
  do {
    $rv++;
    $md5 = md5_hex("$input$rv");
  } until substr($md5,0,$numZeroes) eq $prefix;

  return $rv;
}
