#!/bin/perl

use strict;

use lib "../lib";
use Advent;

my @testProg = (
  'inc a',
  'jio a, +2',
  'tpl a',
  'inc a',
);

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

Advent::test("isEven(1)", isEven(1), '');
Advent::test("isEven(2)", isEven(2), 1);

runProgram(@testProg);
Advent::test("register A", valueOfA(), 2);
Advent::test("register B", valueOfB(), 0);

$DEBUG = 0;
print "\n";

##############################################################################

my @prog = Advent::readArray('23-input.txt');
runProgram(@prog);
Advent::solution(valueOfB());

runProgram("inc a", @prog);
Advent::solution(valueOfB(), "a starts at 1");

##############################################################################

{

my %REGISTER = ();

sub runProgram {
  my (@prog) = @_;
  $REGISTER{a} = $REGISTER{b} = 0;

  my $progPtr = 0;
  my $loopCount = 0;

  while (defined($prog[$progPtr])) {
    my $offset = 1;
    my $inst = $prog[$progPtr];

    if ($inst =~ /^hlf ([ab])$/) {
      my $reg = $1;
      $REGISTER{$reg} = int($REGISTER{$reg}/2);

    } elsif ($inst =~ /^tpl ([ab])$/) {
      my $reg = $1;
      $REGISTER{$reg} = $REGISTER{$reg}*3;

    } elsif ($inst =~ /^inc ([ab])$/) {
      my $reg = $1;
      $REGISTER{$reg}++;

    } elsif ($inst =~ /^jmp ([-+]?[\d]+)$/) {
      $offset = $1;

    } elsif ($inst =~ /^jie ([ab]), ([-+]?[\d]+)$/) {
      my $reg = $1;
      if (isEven($REGISTER{$reg})) {
        $offset = $2;
      }

    } elsif ($inst =~ /^jio ([ab]), ([-+]?[\d]+)$/) {
      my $reg = $1;
      if ($REGISTER{$reg} == 1) {
        $offset = $2;
      }

    } else {
      print "Unrecognised instruction: '$inst'\n";
      exit 1;
    }

    if ($offset == 0) {
      $loopCount++;
      if ($loopCount == 10) {
        print "Stuck in a loop!\n";
        exit 2;
      }
    } elsif ($offset) {
      $loopCount == 0;
      $progPtr += $offset;
    } else {
      $loopCount == 0;
      $progPtr++;
    }
  }
}

sub isEven {
  my ($num) = @_;
  return ($num % 2 == 0);
}

sub valueOfA { return $REGISTER{a}; }
sub valueOfB { return $REGISTER{b}; }

}