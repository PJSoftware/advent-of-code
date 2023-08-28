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

my $input = readInput('01-input.txt');
printSolution($input);

sub testSolution {
  my ($input,$expected) = @_;
  my $got = solve($input);
  if ($got == $expected) {
    print "OK '$input' -> $expected\n";
  } else {
    print "** FAIL for '$input'; got $got, exp $expected\n";
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

sub solve {
  my $input = shift;
  my $floor = 0;
  my $ch;

  while (length($input) > 0) {
    $ch = substr($input,0,1);
    $input = substr($input,1);
    if ($ch eq '(') {
      $floor++;
    } elsif ($ch eq ')') {
      $floor--;
    }
  }

  return $floor;
}