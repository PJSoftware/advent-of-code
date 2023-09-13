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
Advent::solution(newDelivery($input),"new approach");

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
  $house = 776100 unless $DEBUG; # Start where we paused
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

sub newDelivery {
  my ($target) = @_;
  my $upperHouseLimit = int($target/11 + 0.99);

  my %delivered = ();
  my $elf = 1;
  while (!$elf <= $upperHouseLimit) {
    foreach my $hIndex (1..50) {
      my $house = $elf*$hIndex;
      next if $house > $upperHouseLimit;
      $delivered{$house} += 11*$elf;
      if ($delivered{$house} >= $target) {
        $upperHouseLimit = $house;
        if ($hIndex == 1) {
          return $house;
        }
      }
    }
    $elf++;
    if ($elf % 10000 == 0) {
      print "Elf $elf\n";
    }
  }

  print "Loop exited at Elf $elf\n";
}
