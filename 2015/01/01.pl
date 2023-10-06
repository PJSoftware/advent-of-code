#!/bin/perl -w

use strict;

testSolution('(())',0);
testSolution('()()',0);
testSolution('(((',3);
testSolution('(()(()(',3);
testSolution('))(((((',3);
testSolution('())',-1);
testSolution('))(',-1);
testSolution(')))',-3);
testSolution(')())())',-3);
print "\n";

my $input = readInput('01-input.txt');
printSolution($input);
findFirstEntry($input, -1);

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

sub readInput {
  my $fn = shift;
  open (my $IN, '<', $fn);
  my $input = '';
  foreach my $line (<$IN>) {
    $line =~ s{[\r\n]+$}{};
    $input = $line;
  }
  close $IN;

  return $input;
}

sub printSolution {
  my $input = shift;
  print "Solution for given input: ".solve($input)."\n";
}

sub findFirstEntry {
  my ($input,$targetFloor) = @_;
  solve($input,$targetFloor);
}

sub solve {
  my ($input,$targetFloor) = @_;
  $targetFloor = '' unless defined($targetFloor);

  my $floor = 0;
  my $pos = 0;
  my $ch;

  while (length($input) > 0) {
    $ch = substr($input,0,1);
    $input = substr($input,1);
    if ($ch eq '(') {
      $floor++;
      $pos++;
    } elsif ($ch eq ')') {
      $floor--;
      $pos++;
    }

    if ($targetFloor eq $floor) {
      print "Enters level $targetFloor on position: $pos\n";
      $targetFloor = '';
    }
  }

  return $floor;
}