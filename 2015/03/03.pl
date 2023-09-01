#!/bin/perl

use strict;

testSolution('>',2,-1);
testSolution('^v',-1,3);
testSolution('^>v<',4,3);
testSolution('^v^v^v^v^v',2,11);
print "\n";

my $input = readInput('03-input.txt');
my ($solution1,$solution2) = solve($input);
print "Solution year 1 = $solution1\n";
print "Solution year 2 = $solution2\n";

sub testSolution() {
  my ($input,$exp1,$exp2) = @_;
  my ($got1,$got2) = solve($input);
  if ($exp1 > 0) {
    if ($got1 == $exp1) {
      print "OK yr 1 '$input' => $got1\n";
    } else {
      print "** FAIL yr 1 for '$input':\n";
      print "  - got $got1, exp $exp1\n";
      exit 3;
    }
  }

  if ($exp2 > 0) {
    if ($got2 == $exp2) {
      print "OK yr 2 '$input' => $got2\n";
    } else {
      print "** FAIL yr 2 for '$input':\n";
      print "  - got $got2, exp $exp2\n";
      exit 3;
    }
  }
}

sub solve {
  my ($input) = @_;
  my %visitedYear1 = ();
  my %visitedYear2 = ();

  my %origSanta = ( x => 0, y => 0 );
  my %santa = ( x => 0, y => 0 );
  my %robo = ( x => 0, y => 0 );

  my @santas = (\%santa, \%robo);
  my $active = 0;

  $visitedYear1{"0,0"}++;
  $visitedYear2{"0,0"}++;

  my $ch = '';
  while (length($input) > 0) {
    $ch = substr($input,0,1);
    $input = substr($input,1);
    if ($ch eq '<') {
      $origSanta{x}++;
      $santas[$active]->{x}++;
    } elsif ($ch eq '>') {
      $origSanta{x}--;
      $santas[$active]->{x}--;
    } elsif ($ch eq '^') {
      $origSanta{y}++;
      $santas[$active]->{y}++;
    } elsif ($ch eq 'v') {
      $origSanta{y}--;
      $santas[$active]->{y}--;
    } else {
      print "** Unexpected Character: '$ch'\n";
      exit 4;
    }
    $visitedYear1{santaLocation(\%origSanta)}++;
    $visitedYear2{santaLocation($santas[$active])}++;
    $active = 1 - $active;
  }

  return scalar(keys %visitedYear1),scalar(keys %visitedYear2);
}

sub santaLocation {
  my $santaPtr = shift;
  return $santaPtr->{x} . "," . $santaPtr->{y};
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
