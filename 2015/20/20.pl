#!/bin/perl

use strict;

use lib "../lib";
use Advent;

use List::Util qw{ sum };

my %tests = (
  '1' => 10,
  '2' => 30,
  '3' => 40,
  '4' => 70,
  '5' => 60,
  '6' => 120,
  '7' => 80,
  '8' => 150,
  '9' => 130,
);

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

foreach my $test (sort keys %tests) {
  Advent::test($test, presentsForHouse($test), $tests{$test});
}
Advent::test("lowest number to receive 130+", firstHouseToReceive(130), 8);

$DEBUG = 0;
print "\n";

##############################################################################

my $input = Advent::readBlock('20-input.txt');
Advent::solution(firstHouseToReceive($input));

##############################################################################

sub presentsForHouse {
  my ($num) = @_;

  my @factors = factorsOf($num);
  return 10 * sum(@factors);
}

sub factorsOf {
  my ($num) = @_;
  $num += 0;

  my $FOUND = 'x';
  my $PRIME = 1;
  my %factors = ();
  $factors{1} = $FOUND;
  $factors{$num} = $FOUND;

  my $test = 2;
  while ($test < $num && !$factors{$test}) {
    if ($num % $test == 0) {
      $PRIME = 0;
      $factors{$test} = $FOUND;
      $factors{$num/$test} = $FOUND;
    }
    $test++;
  }

  print "Prime found: $num\n" if $PRIME;
  return sort keys %factors;
}

sub firstHouseToReceive {
  my ($target) = @_;
  my $house = 1;
  while (presentsForHouse($house) < $target) {
    $house++;
  }

  return $house;
}
