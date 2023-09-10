#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my @testSizes = qw{ 20 15 10 5 5};
my $testVolume = 25;
my $testOptions = 4;

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

Advent::test("options", solve($testVolume, @testSizes), $testOptions);

$DEBUG = 0;
print "\n";
##############################################################################

my @containers = Advent::readArray('17-input.txt');
my $volume = 150;
Advent::solution(solve($volume, @containers));

sub solve {
  my ($vol, @available) = @_;

  return 0;
}
