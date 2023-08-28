#!/bin/perl -w

use strict;

use List::Util qw{ min };

testSolution('2x3x4',58);
testSolution('1x1x10',43);
print "\n";

my @inputs = readArray('02-input.txt');
printSolution(@inputs);

sub testSolution {
  my ($input,$expected) = @_;
  my $got = solve($input);
  if ($got == $expected) {
    print "OK '$input' -> $expected\n";
  } else {
    print "** FAIL for '$input'; got $got, exp $expected\n";
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
  my $areaTotal = 0;

  foreach my $input (@inputs) {
    $areaTotal += solve($input);
  }
  print "Solution for given input: $areaTotal sq ft\n";
}

sub solve {
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
