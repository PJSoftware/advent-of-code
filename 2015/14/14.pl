#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my @tests = (
  'Comet can fly 14 km/s for 10 seconds, but then must rest for 127 seconds.',
  'Dancer can fly 16 km/s for 11 seconds, but then must rest for 162 seconds.',
);

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

my %testHerd = ();
my $testRaceDuration = 1000;
my $testWinner = 'Comet => 1120';
foreach my $testInput (sort @tests) {
  registerReindeer(\%testHerd, $testInput);
}
Advent::test("test race", runRace(\%testHerd, $testRaceDuration), $testWinner);

$DEBUG = 0;
print "\n";
##############################################################################

my @reindeer = Advent::readArray('14-input.txt');
my %racers = ();
my $raceDuration = 2503;

foreach my $deerStats (sort @reindeer) {
  registerReindeer(\%racers, $deerStats);
}
Advent::solution(runRace(\%racers, $raceDuration));

sub registerReindeer {
  my ($dbRef, $stats) = @_;

  if ($stats =~ m{(\S+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds}) {
    my ($name,$fSpeed,$fDuration,$rDuration) = ($1,$2,$3,$4);
    $dbRef->{$name}{flightSpeed} = $fSpeed;
    $dbRef->{$name}{flightDuration} = $fDuration;
    $dbRef->{$name}{restDuration} = $rDuration;
    $dbRef->{$name}{state} = 'ready';
    $dbRef->{$name}{duration} = 0;
    $dbRef->{$name}{distance} = 0;
  } else {
    print "Input not recognised: $stats\n";
    exit 1;
  }
}

sub runRace {
  my ($dbRef, $duration) = @_;

  foreach my $second (1 .. $duration) {
    foreach my $racer (sort keys %{$dbRef}) {
      if ($dbRef->{$racer}{state} eq 'ready') {
        $dbRef->{$racer}{state} = 'flying';
        $dbRef->{$racer}{duration} = $dbRef->{$racer}{flightDuration};
      }

      if ($dbRef->{$racer}{state} eq 'flying') {
        if ($dbRef->{$racer}{duration} > 0) {
          $dbRef->{$racer}{duration}--;
          $dbRef->{$racer}{distance} += $dbRef->{$racer}{flightSpeed};
        } else {
          $dbRef->{$racer}{state} = 'resting';
          $dbRef->{$racer}{duration} = $dbRef->{$racer}{restDuration};
        }
      } elsif ($dbRef->{$racer}{state} eq 'resting') {
        if ($dbRef->{$racer}{duration} > 0) {
          $dbRef->{$racer}{duration}--;
        } else {
          $dbRef->{$racer}{state} = 'flying';
          $dbRef->{$racer}{duration} = $dbRef->{$racer}{flightDuration};
        }
      }

    }
  }
  return winner($dbRef);
}

sub winner {
  my ($dbRef) = @_;
  my ($winner,$dist) = ('',0);

  foreach my $racer (sort keys %{$dbRef}) {
    if ($dbRef->{$racer}{distance} > $dist) {
      $dist = $dbRef->{$racer}{distance};
      $winner = $racer;
    }
  }
  return "$winner => $dist";
}