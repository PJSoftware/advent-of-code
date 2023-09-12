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
Advent::solution(scalar(keys %output),"number of unique molecules");

##############################################################################

sub parseInput {
  my (@input) = @_;

  my %replacement = ();
  my $molecule = '';

  foreach my $line (@input) {
    next unless $line;
    if ($line =~ /^([A-Z][a-z]?) => ([A-za-z]+)$/) {
      my ($src,$trg) = ($1,$2);
      $replacement{$src} = () unless $replacement{$src};
      push(@{$replacement{$src}},$trg);
    } else {
      $molecule = $line; 
    }
  }

  return($molecule,%replacement);
}

sub calibrate {
  my ($molecule, %repDB) = @_;

  my %output = ();
  my @molStructure = deconstruct($molecule);
  my $numAtoms = scalar(@molStructure);

  my $repCount = 0;
  foreach my $src (sort keys %repDB) {
    foreach my $trg (sort @{$repDB{$src}}) {
      foreach my $elIndex (0 .. $numAtoms-1) {
        if ($molStructure[$elIndex] eq $src) {
          my @dup = @molStructure;
          $dup[$elIndex] = $trg;
          my $newMolecule = construct(@dup);
          $output{construct(@dup)}++;
          $repCount++;
        }
      }
    }
  }
  print "Total $repCount replacements, ".scalar(keys %output)." distinct molecules\n";
  return %output;
}

sub deconstruct {
  my ($molecule) = @_;
  my @structure = ();
  while ($molecule =~ /^([A-Z][a-z]?)(.*)/) {
    my $element = $1;
    $molecule = $2;
    push(@structure, $element);
  }
  return @structure;
}

sub construct {
  my (@structure) = @_;
  return join('',@structure);
}