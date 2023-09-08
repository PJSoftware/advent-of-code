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

my @testSim = (
  'Bob can fly 1 km/s for 1 seconds, but then must rest for 2 seconds.',
);
my $testSimDuration = 20;
my %testBob = resetRacers(@testSim);
my $BobAlwaysWins = calcWinner(\%testBob, $testSimDuration);
Advent::test("test sim", runRace(\%testBob, $testSimDuration), $BobAlwaysWins);

print "\n";

my $testRaceDuration = 1000;
my $testWinner = 'Comet => 1120';
my %testHerd = resetRacers(@tests);
Advent::test("test race (calc)", calcWinner(\%testHerd, $testRaceDuration), $testWinner);
Advent::test("test race (sim)", runRace(\%testHerd, $testRaceDuration), $testWinner);

print "\n";
##############################################################################

my @reindeer = Advent::readArray('14-input.txt');
my $raceDuration = 2503;

##############################################################################
print "Test Full Simulation:\n";
my %racers = resetRacers(@reindeer);
Advent::test("test part 1 race simulation", runRace(\%racers, $raceDuration), "Rudolph => 2640");
$DEBUG = 0;
print "\n";
##############################################################################

%racers = resetRacers(@reindeer);
# Advent::solution(calcWinner(\%racers, $raceDuration),"calculation");
Advent::solution(runRace(\%racers, $raceDuration),"in first place");
Advent::solution(winnerOnPoints(\%racers),"on points");

sub resetRacers {
  my @stats = @_;
  my %racers = ();
  foreach my $stat (sort @stats) {
    registerReindeer(\%racers, $stat);
  }
  return %racers;
}

sub registerReindeer {
  my ($dbRef, $stats) = @_;

  if ($stats =~ m{(\S+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds}) {
    my ($name,$fSpeed,$fDuration,$rDuration) = ($1,$2,$3,$4);
    $dbRef->{$name}{flightSpeed} = $fSpeed;
    $dbRef->{$name}{flightDuration} = $fDuration;
    $dbRef->{$name}{restDuration} = $rDuration;
    $dbRef->{$name}{state} = 'flying';
    $dbRef->{$name}{duration} = 0;
    $dbRef->{$name}{distance} = 0;
    $dbRef->{$name}{leadPoints} = 0;
  } else {
    print "Input not recognised: $stats\n";
    exit 1;
  }
}

sub runRace {
  my ($dbRef, $duration) = @_;

  foreach my $second (1 .. $duration) {
    # print "After $second seconds:\n";
    foreach my $racer (sort keys %{$dbRef}) {
      if ($dbRef->{$racer}{state} eq 'flying') {
        $dbRef->{$racer}{distance} += $dbRef->{$racer}{flightSpeed};
        $dbRef->{$racer}{duration}++;
        # print "- $racer has flown for $dbRef->{$racer}{duration} seconds, and covered $dbRef->{$racer}{distance}km\n";
        if ($dbRef->{$racer}{duration} == $dbRef->{$racer}{flightDuration}) {
          $dbRef->{$racer}{state} = 'resting';
          $dbRef->{$racer}{duration} = 0;
        }
      } elsif ($dbRef->{$racer}{state} eq 'resting') {
        $dbRef->{$racer}{duration}++;
        # print "- $racer has rested for $dbRef->{$racer}{duration} seconds (at $dbRef->{$racer}{distance}km)\n";
        if ($dbRef->{$racer}{duration} == $dbRef->{$racer}{restDuration}) {
          $dbRef->{$racer}{state} = 'flying';
          $dbRef->{$racer}{duration} = 0;
        }
      }
    }

    foreach my $racer (inFront($dbRef)) {
      $dbRef->{$racer}{leadPoints}++;
    }
  }
  return winner($dbRef);
}

sub inFront {
  my ($dbRef) = @_;
  my $dist = 0;

  foreach my $racer (sort keys %{$dbRef}) {
    if ($dbRef->{$racer}{distance} > $dist) {
      $dist = $dbRef->{$racer}{distance};
    }
  }

  my @rv = ();
  foreach my $racer (sort keys %{$dbRef}) {
    if ($dbRef->{$racer}{distance} == $dist) {
      push(@rv, $racer);
    }
  }

  return @rv;
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

sub winnerOnPoints {
  my ($dbRef) = @_;
  my ($winner,$points) = ('',0);

  foreach my $racer (sort keys %{$dbRef}) {
    if ($dbRef->{$racer}{leadPoints} > $points) {
      $points = $dbRef->{$racer}{leadPoints};
      $winner = $racer;
    }
  }
  return "$winner => $points (at $dbRef->{$winner}{distance}km)";
}

sub calcWinner {
  my ($dbRef, $length) = @_;
  my ($winner,$dist) = ('',0);

  foreach my $racer (sort keys %{$dbRef}) {
    my $cycleDuration = $dbRef->{$racer}{flightDuration}+$dbRef->{$racer}{restDuration};
    my $numCycles = int($length/$cycleDuration);
    my $remainder = $length - $numCycles * $cycleDuration;
    # print "$racer has $numCycles cycles in this race, plus $remainder extra seconds\n";

    if ($remainder > $dbRef->{$racer}{flightDuration}) {
      $remainder = $dbRef->{$racer}{flightDuration};
    }

    my $distance = $numCycles * $dbRef->{$racer}{flightSpeed} * $dbRef->{$racer}{flightDuration};
    $distance += $remainder * $dbRef->{$racer}{flightSpeed};
    # print "  They can cover a total distance of ${distance}km in $length seconds!\n";

    if ($distance > $dist) {
      $dist = $distance;
      $winner = $racer;
    }
  }

  return "$winner => $dist";
}