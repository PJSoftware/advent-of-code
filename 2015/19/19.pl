#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my @testInput = (
  'H => HO',
  'H => OH',
  'O => HH',
  '',
  'HOH',
);
my $testDistinct = 4;
my $testDistinctHOHOHO = 7;

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

my ($testStartMolecule, %testReplacements) = parseInput(@testInput);
Advent::test("start molecule", $testStartMolecule, 'HOH');

my %testOutput = calibrate($testStartMolecule, %testReplacements);
Advent::test("calibration", scalar(keys %testOutput), $testDistinct);

%testOutput = calibrate('HOHOHO', %testReplacements);
Advent::test("calibration HOHOHO", scalar(keys %testOutput), $testDistinctHOHOHO);

$DEBUG = 0;
print "\n";
##############################################################################

my @input = Advent::readArray('19-input.txt');
my ($startMolecule, %replacements) = parseInput(@input);
my %output = calibrate($startMolecule, %replacements);
Advent::solution(scalar(keys %testOutput),"number of unique molecules");

##############################################################################

sub parseInput {
  my (@input) = @_;

  my %replacement = ();
  my $molecule = '';

  return($molecule,%replacement);
}

sub calibrate {
  my ($molecule, %repDB) = @_;

  my %output = ();
  return %output;
}
