#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my @testIngredients = (
  'Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8',
  'Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3',
);
my $testPerfectScore = 62842880;
##############################################################################
print "Tests:\n";
my $DEBUG = 1;

Advent::test("test batch", perfectCookies(@testIngredients), $testPerfectScore);

$DEBUG = 0;
print "\n";
##############################################################################

my @ingredients = Advent::readArray('15-input.txt');
Advent::solution(perfectCookies(@ingredients));

sub perfectCookies {
  my (@ingredients) = @_;

  return 0;
}
