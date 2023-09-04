#!/bin/perl

use strict;
use lib "/c/_dev/advent-of-code/2015/lib";

use Advent;

my @testSteps = (
  "123 -> x",
  "456 -> y",
  "x AND y -> d",
  "x OR y -> e",
  "x LSHIFT 2 -> f",
  "y RSHIFT 2 -> g",
  "NOT x -> h",
  "NOT y -> i",
);

my %signalsExpected = (
  "d" => 72,
  "e" => 507,
  "f" => 492,
  "g" => 114,
  "h" => 65412,
  "i" => 65079,
  "x" => 123,
  "y" => 456,
);

my %testSignals = solveFor(0, @testSteps);

foreach my $signal (sort keys %signalsExpected) {
  Advent::test("signal on $signal", $testSignals{$signal}, $signalsExpected{$signal});
}
print "\n";

my $target = 'a';
my @input = Advent::readArray('07-input-part2.txt');
my %signal = solveFor($target,@input);

Advent::solution($signal{$target});

sub solveFor {
  my ($target, @connections) = @_;

  my %signal = ();
  my $foundTarget = 0;
  my @processed = ();

  my $step = 0;
  my $wire = '([a-z]+)';
  my $val = '(\d+)';

  while (!$foundTarget) {
    my $changed = 0;
    my @pending = ();
    foreach my $conn (@connections) {

      if ($conn =~ m{^$val -> $wire$}) { # Assign value
        if (defined($signal{$2})) { print "Reassigning '$2': $conn\n"; exit 2; }
        $signal{$2} = to16($1);
        push(@processed, $conn);
        $changed++;

      } elsif ($conn =~ m{^$wire -> $wire$}) { # Transfer wire value
        if (defined($signal{$2})) { print "Reassigning '$2': $conn\n"; exit 2; }
        if (defined($signal{$1})) {
          $signal{$2} = $signal{$1};
          push(@processed, $conn);
          $changed++;
        } else {
          push(@pending, $conn);
        }

      } elsif ($conn =~ m{^NOT $wire -> $wire$}) { # NOT
        if (defined($signal{$2})) { print "Reassigning '$2': $conn\n"; exit 2; }
        if (defined($signal{$1})) {
          $signal{$2} = to16(~$signal{$1});
          push(@processed, $conn);
          $changed++;
        } else {
          push(@pending, $conn);
        }

      } elsif ($conn =~ m{^$wire LSHIFT $val -> $wire$}) { # LSHIFT
        if (defined($signal{$3})) { print "Reassigning '$3': $conn\n"; exit 2; }
        if (defined($signal{$1})) {
          $signal{$3} = to16($signal{$1} << $2);
          push(@processed, $conn);
          $changed++;
        } else {
          push(@pending, $conn);
        }

      } elsif ($conn =~ m{^$wire RSHIFT $val -> $wire$}) { # RSHIFT
        if (defined($signal{$3})) { print "Reassigning '$3': $conn\n"; exit 2; }
        if (defined($signal{$1})) {
          $signal{$3} = to16($signal{$1} >> $2);
          push(@processed, $conn);
          $changed++;
        } else {
          push(@pending, $conn);
        }

      } elsif ($conn =~ m{^$wire AND $wire -> $wire$}) { # AND
        if (defined($signal{$3})) { print "Reassigning '$3': $conn\n"; exit 2; }
        if (defined($signal{$1}) && defined($signal{$2})) {
          $signal{$3} = to16($signal{$1} & $signal{$2});
          push(@processed, $conn);
          $changed++;
        } else {
          push(@pending, $conn);
        }

      } elsif ($conn =~ m{^$val AND $wire -> $wire$}) { # AND
        if (defined($signal{$3})) { print "Reassigning '$3': $conn\n"; exit 2; }
        if (defined($signal{$2})) {
          $signal{$3} = to16($1 & $signal{$2});
          push(@processed, $conn);
          $changed++;
        } else {
          push(@pending, $conn);
        }

      } elsif ($conn =~ m{^$wire OR $wire -> $wire$}) { # OR
        if (defined($signal{$3})) { print "Reassigning '$3': $conn\n"; exit 2; }
        if (defined($signal{$1}) && defined($signal{$2})) {
          $signal{$3} = to16($signal{$1} | $signal{$2});
          push(@processed, $conn);
          $changed++;
        } else {
          push(@pending, $conn);
        }

      } elsif ($conn =~ m{^$wire XOR $wire -> $wire$}) { # XOR
        if (defined($signal{$3})) { print "Reassigning '$3': $conn\n"; exit 2; }
        if (defined($signal{$1}) && defined($signal{$2})) {
          $signal{$3} = to16($signal{$1} ^ $signal{$2});
          push(@processed, $conn);
          $changed++;
        } else {
          push(@pending, $conn);
        }

      } else {
        print "Unhandled instruction: $conn\n";
        exit 1;
      }

    }

    @connections = @pending;
    if ($target && defined($signal{$target})) {
      $foundTarget = 1;
    } elsif (scalar(@connections) == 0) {
      $foundTarget = 1;
    }

    $step++;
  }

  print "$step steps in circuit analysis\n";
  return %signal;
}

sub to16{
  return ($_[0] & 0xFFFF)+0;
}