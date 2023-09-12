#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my $LIVE = '#';
my $DEAD = '.';

my @testInput = (
  '.#.#.#',
  '...##.',
  '#....#',
  '..#...',
  '#.#..#',
  '####..',
);
my $testSteps = 4;
my $testCount = 4;
my $testStepsStuck = 5;
my $testCountStuck = 17;

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

my @testGrid = convertToGrid(@testInput);
@testGrid = animate($testSteps, @testGrid);
Advent::test("test animation", countLive(@testGrid), $testCount);

# Reset grid for second pass
@testGrid = convertToGrid(@testInput);
@testGrid = animateStuckCorners($testStepsStuck, @testGrid);
Advent::test("stuck corners", countLive(@testGrid), $testCountStuck);

printGrid(@testGrid);

$DEBUG = 0;
print "\n";
##############################################################################

my @grid = convertToGrid(Advent::readArray('18-input.txt'));
my $steps = 100;

Advent::solution(countLive(@grid),'before');
@grid = animate($steps,@grid);
Advent::solution(countLive(@grid),'after');

# Reset grid for second pass
@grid = convertToGrid(Advent::readArray('18-input.txt'));
@grid = animateStuckCorners($steps,@grid);
Advent::solution(countLive(@grid),'stuck');

sub animate {
  my ($steps, @grid) = @_;
  my $maxX = scalar(@grid)-1;
  my $maxY = scalar(@{$grid[0]})-1;

  foreach my $step (1..$steps) {
    my @nextState = ();
    foreach my $x (0 .. $maxX) {
      foreach my $y (0 .. $maxY) {
        my $cell = $DEAD;
        my $nc = countNeighbours($x,$y, @grid);
        if ($grid[$x][$y] eq $LIVE) {
          if ($nc == 2 || $nc == 3) {
            $cell = $LIVE;
          }
        } else {
          if ($nc == 3) {
            $cell = $LIVE;
          }
        }
        $nextState[$x][$y] = $cell;
      }
    }
    @grid = @nextState;
  }

  return @grid;
}

sub animateStuckCorners {
  my ($steps, @grid) = @_;
  my $maxX = scalar(@grid)-1;
  my $maxY = scalar(@{$grid[0]})-1;

  @grid = cornersStuckOn($maxX, $maxY, @grid);
  foreach my $step (1..$steps) {
    my @nextState = ();
    foreach my $x (0 .. $maxX) {
      foreach my $y (0 .. $maxY) {
        my $cell = $DEAD;
        my $nc = countNeighbours($x,$y, @grid);
        if ($grid[$x][$y] eq $LIVE) {
          if ($nc == 2 || $nc == 3) {
            $cell = $LIVE;
          }
        } else {
          if ($nc == 3) {
            $cell = $LIVE;
          }
        }
        $nextState[$x][$y] = $cell;
      }
    }
    @grid = cornersStuckOn($maxX, $maxY, @nextState);
  }

  return @grid;
}

sub cornersStuckOn {
  my ($maxX, $maxY, @grid) = @_;
  $grid[0][0] = $LIVE;
  $grid[$maxX][0] = $LIVE;
  $grid[0][$maxY] = $LIVE;
  $grid[$maxX][$maxY] = $LIVE;
  return @grid;
}
sub convertToGrid {
  my (@stringArray) = @_;
  my $maxX = scalar(@stringArray)-1;
  my $maxY = length($stringArray[0])-1;
  my @grid;
  foreach my $x (0 .. $maxX) {
    @{$grid[$x]} = split(//,$stringArray[$x]);
  }

  return @grid;
}

sub countNeighbours {
  my ($x, $y, @grid) = @_;
  my $maxX = scalar(@grid)-1;
  my $maxY = scalar(@{$grid[0]})-1;
  my ($x1,$x2) = surrounds($x,$maxX);
  my ($y1,$y2) = surrounds($y,$maxY);

  my $count = 0;
  foreach my $ix ($x1..$x2) {
    foreach my $iy ($y1..$y2) {
      next if $iy == $y && $ix == $x;
      $count++ if $grid[$ix][$iy] eq $LIVE;
    }
  }
  return $count;
}

sub printGrid {
  my (@grid) = @_;
  my $maxX = scalar(@grid)-1;
  my $maxY = scalar(@{$grid[0]})-1;
  foreach my $x ($0..$maxX) {
    foreach my $y ($0..$maxY) {
      print $grid[$x][$y];
    }
    print "\n";
  }
}

sub surrounds {
  my ($x,$max) = @_;
  my $x1 = $x - 1;
  my $x2 = $x + 1;

  if ($x1 < 0) {
    $x1 = 0;
  }
  if ($x2 > $max) {
    $x2 = $max;
  }

  return ($x1,$x2);
}

sub countLive {
  my (@grid) = @_;
  my $maxX = scalar(@grid)-1;
  my $maxY = scalar(@{$grid[0]})-1;

  my $alive = 0;
  foreach my $x (0 .. $maxX) {
    foreach my $y (0 .. $maxY) {
      $alive++ if $grid[$x][$y] eq $LIVE;
    }
  }
  return $alive;
}