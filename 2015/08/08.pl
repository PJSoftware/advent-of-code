#!/bin/perl

use strict;
use lib "/c/_dev/advent-of-code/2015/lib";

use Advent;

my @tests = qw{
  ""
  "abc"
  "aaa\"aaa"
  "\x27" 
};

Advent::test('4 strings', solve(@tests), 12);

my @input = Advent::readArray('08-input.txt');
Advent::solution(solve(@input));

sub solve {
  my @input = @_;

  my ($escaped, $actual) = (0,0);
  foreach my $line (@input) {
    $escaped += length($line);
    my $xLine = $line;
    $xLine =~ s{^"}{};
    $xLine =~ s{"$}{};
    $xLine =~ s{\\\\|\\"|\\x[0-9a-f]{2}}{.}g;
    $actual += length($xLine);
  }

  return $escaped - $actual;
}
