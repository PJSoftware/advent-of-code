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

Advent::test('decoder', solveDecode(@tests), 12);
Advent::test('encoder', solveEncode(@tests), 19);

my @input = Advent::readArray('08-input.txt');
Advent::solution(solveDecode(@input),'decode');
Advent::solution(solveEncode(@input),'encode');

sub solveDecode {
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

sub solveEncode {
  my @input = @_;

  my ($escaped, $actual) = (0,0);
  foreach my $line (@input) {
    $actual += length($line);
    my $xLine = $line;
    $xLine =~ s{\\}{\\\\}g;
    $xLine =~ s{"}{\\"}g;
    $xLine = "\"$xLine\"";
    $escaped += length($xLine);
  }

  return $escaped - $actual;
}
