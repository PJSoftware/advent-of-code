#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my $reElement = '[A-Z][a-z]?';
my $reElementOrElectron = 'e|[A-Z][a-z]?';

my @testInput = (
  'e => H',
  'e => O',
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

my %testOutput = fabricate($testStartMolecule, %testReplacements);
Advent::test("calibration", scalar(keys %testOutput), $testDistinct);

%testOutput = fabricate('HOHOHO', %testReplacements);
Advent::test("calibration HOHOHO", scalar(keys %testOutput), $testDistinctHOHOHO);

Advent::test("fab steps", fabricateSteps($testStartMolecule, %testReplacements), 3);
Advent::test("fab steps HOHOHO", fabricateSteps('HOHOHO', %testReplacements), 6);

my %testDeconstruct = genDeconstructDB(%testReplacements);
Advent::test("deconstruct steps", deconstructionSteps($testStartMolecule, %testDeconstruct), 3);
Advent::test("deconstruct steps", deconstructionSteps('HOHOHO', %testDeconstruct), 6);

$DEBUG = 0;
print "\n";

##############################################################################

my @input = Advent::readArray('19-input.txt');
my ($startMolecule, %replacements) = parseInput(@input);
my %output = fabricate($startMolecule, %replacements);
Advent::solution(scalar(keys %output),"number of unique molecules");

my @sm = deconstruct($startMolecule);
my %elVariable = ();
my %elFixed = ();

foreach my $el (sort keys %replacements) {
  $elVariable{$el}++;
}

foreach my $el (@sm) {
  $elFixed{$el} = 1 unless $elVariable{$el};
}

Advent::solution(scalar(@sm),"molecule length");
print "Fixed:";
foreach my $el (sort keys %elFixed) {
  print " $el";
}
print "\n";
print "Variable:";
foreach my $el (sort keys %elVariable) {
  print " $el";
}
print "\n";

my %dcDB = genDeconstructDB(%replacements);
Advent::solution(deconstructionSteps($startMolecule, %dcDB),"steps to deconstruct");
# Advent::solution(fabricateSteps($startMolecule, %replacements),"steps to fabricate");

##############################################################################

sub deconstructionSteps {
  my ($molecule, %dcDB) = @_;

  my $step = 0;
  while ($molecule ne 'e') {
    if ($dcDB{$molecule} eq 'e') {
      return $step + 1;
    }

    my $inState = $molecule;
    foreach my $pattern (sort keys %dcDB) {
      next if $dcDB{$pattern} eq 'e';
      if ($molecule =~ /$pattern/) {
        my $src = $dcDB{$pattern};
        $molecule =~ s{$pattern}{$src};
        $step++;
      }
    }
    if ($molecule eq $inState) {
      print "no possible changes; stuck at #$step: '$inState'\n";
      exit 2;
    }
  }
  return $step;
}

sub parseInput {
  my (@input) = @_;

  my %replacement = ();
  my $molecule = '';

  foreach my $line (@input) {
    next unless $line;
    if ($line =~ /^($reElementOrElectron) => ([A-za-z]+)$/) {
      my ($src,$trg) = ($1,$2);
      $replacement{$src} = () unless $replacement{$src};
      push(@{$replacement{$src}},$trg);
    } else {
      $molecule = $line; 
    }
  }

  return($molecule,%replacement);
}

sub genDeconstructDB {
  my (%repDB) = @_;
  my %dcDB = ();
  foreach my $src (sort keys %repDB) {
    foreach my $trg (sort @{$repDB{$src}}) {
      if ($dcDB{$trg}) {
        print "Multiple possible sources for '$trg' ($src & $dcDB{$trg})\n";
        exit 1;
      } else {
        $dcDB{$trg} = $src;
      }
    }
  }
  return %dcDB;
}

sub fabricateSteps {
  my ($targetMolecule, %repDB) = @_;

  my $startMolecule = 'e';
  my @inputOptions = ($startMolecule);
  my $step = 0;
  my $found = 0;
  while (!$found) {
    $step++;
    print "Step $step: ";
    my %allOutput = ();
    foreach my $opt (@inputOptions) {
      my %output = fabricate($opt, %repDB);
      foreach my $mol (sort keys %output) {
        $allOutput{$mol}++;
        if ($mol eq $targetMolecule) {
          print "target molecule found!\n";
          return $step;
        }
      }
    }
    @inputOptions = (sort keys %allOutput);
    print scalar(@inputOptions)." distinct molecules created!\n";
  }
}

sub fabricate {
  my ($molecule, %repDB) = @_;

  my %output = ();
  my @molStructure = deconstruct($molecule);
  my $numAtoms = scalar(@molStructure);

  my $repCount = 0;
  my $skipNext = 0;
  foreach my $src (sort keys %repDB) {
    foreach my $trg (sort @{$repDB{$src}}) {
      foreach my $elIndex (0 .. $numAtoms-1) {
        
        # Shortcuts based on visual analysis of replacement data
        if ($skipNext) {
          $skipNext--;
          next;
        }
        my $seq2 = $molStructure[$elIndex] . ($molStructure[$elIndex+1] // '');
        if ($seq2 =~ /CRn|NRn|ORn|YF|YMg/) {
          $skipNext++;
          next;
        } 
        next if $elFixed{$molStructure[$elIndex]};

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
  # print "Total $repCount replacements, ".scalar(keys %output)." distinct molecules\n";
  return %output;
}

sub deconstruct {
  my ($molecule) = @_;
  my @structure = ();
  while ($molecule =~ /^($reElementOrElectron)(.*)/) {
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