#!/bin/perl

use strict;
use lib "/c/_dev/advent-of-code/2015/lib";

use Advent;

my @testGen = ('A','B','C');
print "testGen -> @testGen\n";
my @testResult = generateTrips(@testGen);
my @testAnswer = ();
foreach my $test (@testResult) {
  push(@testAnswer,join('',@{$test}));
}
my $testTrips = join(',',sort(@testAnswer));
Advent::test("trip generation",$testTrips,"ABC,ACB,BAC,BCA,CAB,CBA");

my @testDataUK = (
  "London to Dublin = 464",
  "London to Belfast = 518",
  "Dublin to Belfast = 141",
);
my $testAnswerUK = 605;
Advent::test("shortest distance", solve($testDataUK[0]), 464);
Advent::test("shortest distance", solve($testDataUK[1]), 518);
Advent::test("shortest distance (UK)", solve(@testDataUK), $testAnswerUK);

# My first idea would actually return the alphabetic route (Belfast->Dublin->London)
# which happens to be the correct answer, but not the answer we want! The AUS dataset
# would return Brisbane->Darwin->Melbourne->Sydney which is most definitely NOT
# the correct result. (Correct _should_ be Darwin->Brisbane->Sydney->Melbourne!)
my @testDataAUS = (
  "Sydney to Brisbane = 733",
  "Sydney to Melbourne = 714",
  "Brisbane to Melbourne = 1376",
  "Brisbane to Darwin = 2850",
  "Sydney to Darwin = 3152",
  "Melbourne to Darwin = 3151",
);
my $testAnswerAUS = 2850+733+714;
Advent::test("shortest distance (AUS)", solve(@testDataAUS), $testAnswerAUS);

print "\n";

my @input = Advent::readArray('09-input.txt');
Advent::solution(solve(@input));

sub solve {
  my (@input) = @_;

  my %location = ();
  my %distances = ();
  foreach my $dist (@input) {
    if ($dist =~ m{^(\S+) to (\S+) = (\d+)$}) {
      $location{$1} = 1;
      $location{$2} = 1;
      $distances{$1}{$2} = 0+$3;
      $distances{$2}{$1} = 0+$3;
    } else {
      print "Data does not fit expected format: '$dist'\n";
      exit 1;
    }
  }

  my @locations = (sort keys %location);
  return shortestTrip(\%distances, @locations);
}

sub shortestTrip {
  my ($distDB, @locations) = @_;
  my $shortestTrip = -1;

  my @trips = generateTrips(@locations);
  foreach my $trip (@trips) {
    my $tripLength = calcTripLength($trip, $distDB);
    if ($shortestTrip == -1 || $tripLength < $shortestTrip) {
      $shortestTrip = $tripLength;
    }
  }
  return $shortestTrip;
}

sub generateTrips {
  my (@locations) = @_;
  my @rv = ();

  if (scalar(@locations) == 1) {
    push(@rv,\@locations);
    return @rv;
  }

  foreach my $loc (@locations) {
    my @remainder = allExcept($loc,@locations);
    my @trips = generateTrips(@remainder);
    foreach my $trip (@trips) {
      my @whole = ($loc);
      push(@whole,@{$trip});
      push(@rv,\@whole);
    }
  }
  return @rv;
}

sub calcTripLength {
  my ($trip, $distDB) = @_;

  my $dist = 0;
  my $steps = scalar(@{$trip})-1;
  foreach my $step (0 .. $steps-1) {
    $dist += getDist($trip->[$step],$trip->[$step+1],$distDB);
  }
  
  return $dist;
}

sub getDist {
  my ($loc1,$loc2,$distDB) = @_;
  if (!defined($distDB->{$loc1}{$loc2})) {
    print "Distance unknown between $loc1 and $loc2\n";
    exit 3;
  }
  return $distDB->{$loc1}{$loc2};
}

sub allExcept {
  my ($value, @array) = @_;
  my @rv = ();
  foreach my $item (@array) {
    push(@rv, $item) unless $item eq $value;
  }
  return @rv;
}
