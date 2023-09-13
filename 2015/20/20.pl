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

my $LAST_PRIME = 0;
my $input = Advent::readBlock('20-input.txt');
my $house = firstHouseToReceive($input);
my $presents = presentsForHouse($house);

Advent::solution($presents,"presents");
Advent::solution($house,"first house > $input");
# my @factors = factorsOf($house);
# print "Factors: @factors\n";
Advent::solution($LAST_PRIME,"last prime seen");

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

  $LAST_PRIME = $num if $PRIME;
  return sort keys %factors;
}

sub firstHouseToReceive {
  my ($target) = @_;
  my $house = 1;
  $house = 269897 unless $DEBUG; # Start where we paused
  my $maxPresents = 0;
  while ((my $presents = presentsForHouse($house)) < $target) {
    if ($presents > $maxPresents) {
      $maxPresents = $presents;
      print "Max presents found = $presents (at #$house) [last prime = $LAST_PRIME]\n";
    }
    $house++;
  }

  return $house;
}
