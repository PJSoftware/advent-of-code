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
Advent::test("test race (sim)", runRace(\%testHerd, $testRaceDuration), $testWinner);
Advent::test("test race (calc)", calcWinner(\%testHerd, $testRaceDuration), $testWinner);

print "\n";
##############################################################################

my @reindeer = Advent::readArray('14-input.txt');
my %racers = ();
my $raceDuration = 2503;

##############################################################################
print "Test Full Simulation:\n";
foreach my $deerStats (sort @reindeer) {
  registerReindeer(\%racers, $deerStats);
}
Advent::test("test part 1 race simulation", runRace(\%racers, $raceDuration), "Rudolph => 2640");
$DEBUG = 0;
print "\n";
##############################################################################

%racers = ();
foreach my $deerStats (sort @reindeer) {
  registerReindeer(\%racers, $deerStats);
}
Advent::solution(calcWinner(\%racers, $raceDuration),"calculation => correct");
Advent::solution(runRace(\%racers, $raceDuration),"simulation => WRONG!");


sub registerReindeer {
  my ($dbRef, $stats) = @_;

  if ($stats =~ m{(\S+) can fly (\d+) km/s for (\d+) seconds, but then must rest for (\d+) seconds}) {
    my ($name,$fSpeed,$fDuration,$rDuration) = ($1,$2,$3,$4);
    $dbRef->{$name}{flightSpeed} = $fSpeed;
    $dbRef->{$name}{flightDuration} = $fDuration;
    $dbRef->{$name}{restDuration} = $rDuration;
    $dbRef->{$name}{state} = 'flying';
    $dbRef->{$name}{duration} = $fDuration;
    $dbRef->{$name}{distance} = 0;
  } else {
    print "Input not recognised: $stats\n";
    exit 1;
  }
}

sub runRace {
  my ($dbRef, $duration) = @_;

  # For some reason our simulation of the race seems to be adding an extra
  # second to both the race and rest times -- but if I simply add "-1" in the
  # relevant locations, the test fails. Something weird is happening.
  #
  # Let's try Plan B
  foreach my $second (1 .. $duration) {
    foreach my $racer (sort keys %{$dbRef}) {
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

    # print "$racer has travelled $dbRef->{$racer}{distance}km after $second seconds ($dbRef->{$racer}{state} for $dbRef->{$racer}{duration})\n" if $DEBUG;
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