#!/bin/perl

use strict;
use lib "../lib";

use Advent;

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

Advent::test("1st", nth(1,1), 1);
Advent::test("2nd", nth(2,1), 2);
Advent::test("3rd", nth(1,2), 3);
Advent::test("12th", nth(4,2), 12);
Advent::test("15th", nth(1,5), 15);
Advent::test("19th", nth(3,4), 19);
Advent::test("21st", nth(1,6), 21);
Advent::test("23rd", nth(6,2), 23);

Advent::test("code(1)", code(1), 20151125);
Advent::test("code(2)", code(2), 31916031);
Advent::test("code(3)", code(3), 18749137);
Advent::test("code(12)", code(12), 32451966);
Advent::test("code(15)", code(15), 10071777);
Advent::test("code(19)", code(19), 7981243);
Advent::test("code(21)", code(21), 33511524);
Advent::test("code(23)", code(23), 6796745);

# foreach my $testInput (sort keys %tests) {
#   Advent::test($testInput, solve($testInput), $tests{$testInput});
# }

$DEBUG = 0;
print "\n";

##############################################################################

my ($row, $col) = (2947, 3029);
my $nth = nth($row,$col);
Advent::solution($nth,"nth");
Advent::solution(code($nth),"code");

##############################################################################

sub nth {
  my ($row, $col) = @_;

  my ($r,$c,$n) = 1;

  while (!($r == $row && $c == $col)) {
    $n++;
    if ($r == 1) {
      $r = $c+1;
      $c = 1;
    } else {
      $r--;
      $c++;
    }
  }
  return $n;
}

sub code {
  my ($n) = @_;

  my $code = 20151125;
  my $cNum = 1;

  while ($cNum < $n) {
    $code = ($code * 252533) % 33554393;
    $cNum++;
  }
  return $code;
}