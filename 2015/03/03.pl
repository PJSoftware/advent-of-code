#!/bin/perl

use strict;


testSolution('>',2);
testSolution('^>v<',4);
testSolution('^v^v^v^v^v',2);
print "\n";

my $input = readInput('03-input.txt');
my $solution = solve($input);
print "Solution = $solution\n";

sub testSolution() {
  my ($input,$exp) = @_;
  my $got = solve($input);
  if ($got == $exp) {
    print "OK '$input' => $got\n";
  } else {
    print "** FAIL for '$input':\n";
    print "  - got $got, exp $exp\n";
    exit 3;
  }
}

sub solve {
  my ($input) = @_;
  my %VISITED = ();
  my ($x,$y) = (0,0);

  $VISITED{"$x,$y"}++;

  my $ch = '';
  while (length($input) > 0) {
    $ch = substr($input,0,1);
    $input = substr($input,1);
    if ($ch eq '<') {
      $x++;
    } elsif ($ch eq '>') {
      $x--;
    } elsif ($ch eq '^') {
      $y++;
    } elsif ($ch eq 'v') {
      $y--;
    } else {
      print "** Unexpected Character: '$ch'\n";
      exit 4;
    }
    $VISITED{"$x,$y"}++;
  }

  return scalar(keys %VISITED);
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
