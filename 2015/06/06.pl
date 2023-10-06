#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my $LAYOUT_X = 1000;
my $LAYOUT_Y = 1000;

my @LIGHTS = createLights($LAYOUT_X,$LAYOUT_Y);

my @testInput = (
  'turn on 1,1 through 10,10', # 10x10 = 100 brightness
  'turn off 3,3 through 8,8', # 6x6 = 36; 100-36 = 64 brightness
  'toggle 2,1 through 3,10', # 20 increased by 2; 64+40 = 104 brightness
);

my @testResults = (100, 64, 104);

foreach my $test (0 .. scalar(@testInput)-1) {
  my $input = $testInput[$test];
  my $exp = $testResults[$test];
  controlLights($input);
  my $got = calculateBrightness();
  Advent::test($input, $got, $exp);
}
resetLights();

my @input = Advent::readArray('06-input.txt');
foreach my $instruction (@input) {
  controlLights($instruction);
}

Advent::solution(calculateBrightness());

#####

sub createLights {
  my ($numX, $numY) = @_;
  my @lights = ();
  foreach my $x (0..$numX-1) {
    foreach my $y (0..$numY-1) {
      $lights[$x][$y] = 0;
    }
  }
  return @lights;
}

sub resetLights {
  my ($numX, $numY) = ($LAYOUT_X,$LAYOUT_Y);
  foreach my $x (0..$numX-1) {
    foreach my $y (0..$numY-1) {
      $LIGHTS[$x][$y] = 0;
    }
  }
}

sub controlLights {
  my ($command) = @_;
  my ($numX, $numY) = ($LAYOUT_X,$LAYOUT_Y);

  my ($cmd, $minX,$minY, $maxX,$maxY);
  if ($command =~ m{^(turn on|toggle|turn off) (\d+),(\d+) through (\d+),(\d+)\s*$}) {
    ($cmd, $minX,$minY, $maxX,$maxY) = ($1,$2,$3,$4,$5);
  } else {
    print "Command did not fit expected format: $command\n";
    exit 1;
  }
  validateCoords($minX, $minY, $maxX, $maxY);

  foreach my $x ($minX..$maxX) {
    foreach my $y ($minY..$maxY) {
      if ($cmd eq 'turn on') {        # translation: increase by 1
        $LIGHTS[$x][$y] += 1;

      } elsif ($cmd eq 'turn off') {  # translation: decrease by 1 (min 0)
        $LIGHTS[$x][$y] -= 1 if $LIGHTS[$x][$y] > 0;

      } else {                        # toggle translation: increase by 2
        $LIGHTS[$x][$y] += 2;

      }
    }
  }
}

sub calculateBrightness {
  my $lightsOn = 0;
  my ($numX, $numY) = ($LAYOUT_X,$LAYOUT_Y);
  foreach my $x (0..$numX-1) {
    foreach my $y (0..$numY-1) {
      $lightsOn += $LIGHTS[$x][$y];
    }
  }
  return $lightsOn;
}

sub validateCoords {
  my ($minX,$minY, $maxX,$maxY) = @_;
  if ($minX < 0 || $minX > 999) { print "minX out of bounds: $minX\n"; exit 2 }
  if ($minY < 0 || $minY > 999) { print "minY out of bounds: $minY\n"; exit 2 }
  if ($maxX < 0 || $maxX > 999) { print "maxX out of bounds: $maxX\n"; exit 2 }
  if ($maxY < 0 || $maxY > 999) { print "maxY out of bounds: $maxY\n"; exit 2 }

  if ($maxX < $minX) { print "coords X values out of order: $minX -> $maxX\n"; exit 3 }
  if ($maxY < $minY) { print "coords Y values out of order: $minY -> $maxY\n"; exit 3 }
}