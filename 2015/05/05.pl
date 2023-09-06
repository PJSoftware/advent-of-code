#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my %tests = (
  'ugknbfddgicrmopn' => 'nice',
  'aaa' => 'nice',
  'jchzalrnumimnmhp' => 'naughty',
  'haegwjzuvuyypxyu' => 'naughty',
  'dvszwmarrgswjxmb' => 'naughty',
);
my %testsNew = (
  'qjhvhtzxzqqjkmpb' => 'nice',
  'xxyxx' => 'nice',
  'aaa' => 'naughty',
  'uurcxstgmygtbstg' => 'naughty',
  'ieodomkazucvgmuy' => 'naughty',
);

print "test old rules:\n";
foreach my $testInput (sort keys %tests) {
  Advent::test($testInput, solve($testInput), $tests{$testInput});
}

print "\ntest new rules:\n";
foreach my $testInput (sort keys %testsNew) {
  Advent::test($testInput, solveNew($testInput), $testsNew{$testInput});
}

my @input = Advent::readArray('05-input.txt');

my $count = 0;
my $countNew = 0;
foreach my $word (@input) {
  $count++ if solve($word) eq 'nice';  
  $countNew++ if solveNew($word) eq 'nice';  
}
Advent::solution($count, "old");
Advent::solution($countNew, "new");

sub solve {
  my ($input) = @_;

  my $naughty = 'naughty';
  my $nice = 'nice';

  return $naughty if $input =~ m{ab|cd|pq|xy};
  return $naughty unless $input =~ m/([aeiou].*){3}/;
  return $naughty unless $input =~ m{([a-z])\1};  
  return $nice;
}

sub solveNew {
  my ($input) = @_;

  my $naughty = 'naughty';
  my $nice = 'nice';

  return $naughty unless $input =~ m/([a-z])([a-z]).*\1\2/;
  return $naughty unless $input =~ m{([a-z]).\1};  
  return $nice;
}