#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my @testData = (
  'Alice would gain 54 happiness units by sitting next to Bob.',
  'Alice would lose 79 happiness units by sitting next to Carol.',
  'Alice would lose 2 happiness units by sitting next to David.',
  'Bob would gain 83 happiness units by sitting next to Alice.',
  'Bob would lose 7 happiness units by sitting next to Carol.',
  'Bob would lose 63 happiness units by sitting next to David.',
  'Carol would lose 62 happiness units by sitting next to Alice.',
  'Carol would gain 60 happiness units by sitting next to Bob.',
  'Carol would gain 55 happiness units by sitting next to David.',
  'David would gain 46 happiness units by sitting next to Alice.',
  'David would lose 7 happiness units by sitting next to Bob.',
  'David would gain 41 happiness units by sitting next to Carol.',
);
my $testResult = 330;

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

my %testModel = ();
foreach my $input (@testData) {
  addToModel(\%testModel,$input);
}
Advent::test('test_happiness',maximiseHappiness(\%testModel), $testResult);

$DEBUG = 0;
print "\n";
##############################################################################

my @inputData = Advent::readArray('13-input.txt');
my %seatingDB = ();
foreach my $input (@inputData) {
  addToModel(\%seatingDB,$input);
}
addSelfToModel(\%seatingDB,"Myself",0);
Advent::solution(maximiseHappiness(\%seatingDB));

sub addToModel {
  my ($dbRef,$input) = @_;
  my $self = 'Myself';
  if ($input =~ /^(\S+) would (lose|gain) (\d+) happiness units by sitting next to (\S+)[.]$/) {
    my ($n1,$dir,$hu,$n2) = ($1,$2,$3,$4);
    if ($dir eq 'lose') {
      $hu = -$hu;
    }
    $dbRef->{$n1}{$n2} = $hu;
  }
}

sub addSelfToModel {
  my ($dbRef,$self,$selfHappy) = @_;
  foreach my $person (sort keys %{$dbRef}) {
    next if $person eq $self;
    $dbRef->{$person}{$self} = $selfHappy;
    $dbRef->{$self}{$person} = $selfHappy;
  }
}

sub maximiseHappiness {
  my ($dbRef) = @_;

  my @guestList = ();
  foreach my $guest (sort keys %{$dbRef}) {
    push(@guestList,$guest)
  }
  my @seatingArrangements = Advent::generateCombinations(@guestList);

  my $maxHappiness = 0;
  foreach my $saRef (@seatingArrangements) {
    my @sa = @{$saRef};
    my $pairs = scalar(@sa);
    push(@sa,$sa[0]); # circular table; last person next to first person

    my $happiness = 0;
    foreach my $pair (0..$pairs) {
      my $p1 = @sa[$pair];
      my $p2 = @sa[$pair+1];
      $happiness += $dbRef->{$p1}{$p2} + $dbRef->{$p2}{$p1};
    }
    if ($happiness > $maxHappiness) {
      $maxHappiness = $happiness;
    }
  }
  return $maxHappiness;
}