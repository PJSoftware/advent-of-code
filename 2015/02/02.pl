#!/bin/perl -w

use strict;

use List::Util qw{ min };

testSolution('2x3x4',58,34);
testSolution('1x1x10',43,14);
print "\n";

my @inputs = readArray('02-input.txt');
printSolution(@inputs);

sub testSolution {
  my ($input,$paper,$ribbon) = @_;
  my $gotPaper = solvePaper($input);
  my $gotRibbon = solveRibbon($input);
  if ($gotPaper == $paper && $gotRibbon == $ribbon) {
    print "OK '$input' -> $gotPaper / $gotRibbon\n";
  } else {
    print "** FAIL for '$input':\n";
    print "  - Paper: got $gotPaper, exp $paper\n";
    print "  - Ribbon: got $gotRibbon, exp $ribbon\n";
    exit 1;
  }
}

sub readArray {
  my $fn = shift;
  open (my $IN, '<', $fn);
  my @rv = ();
  foreach my $line (<$IN>) {
    $line =~ s{[\r\n]+$}{};
    push(@rv, $line);
  }
  close $IN;

  return @rv;
}

sub printSolution {
  my @inputs = @_;
  my $paperTotal = 0;
  my $ribbonTotal = 0;

  foreach my $input (@inputs) {
    $paperTotal += solvePaper($input);
    $ribbonTotal += solveRibbon($input);
  }
  print "Solution for given input: Paper = $paperTotal sq ft\n";
  print "Solution for given input: Ribbon = $ribbonTotal ft\n";
}

sub solvePaper {
  my ($input) = @_;
  my $area = 0;
  if ($input =~ m{(\d+)x(\d+)x(\d+)}) {
    my ($l,$w,$h) = ($1,$2,$3);
    my $f1 = $l * $w;
    my $f2 = $w * $h;
    my $f3 = $h * $l;
    $area = 2*($f1 + $f2 + $f3) + min($f1,$f2,$f3);
  }

  return $area;
}

sub solveRibbon {
  my ($input) = @_;
  my $len = 0;
  if ($input =~ m{(\d+)x(\d+)x(\d+)}) {
    my ($l,$w,$h) = ($1,$2,$3);
    my $c1 = $l + $w;
    my $c2 = $w + $h;
    my $c3 = $h + $l;
    $len = min($c1,$c2,$c3)*2 + $l*$w*$h;
  }

  return $len;
}
