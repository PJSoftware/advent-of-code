#!/bin/perl

use strict;
use lib "../lib";

use Advent;

use List::Util qw{ sum };

my $ncb = '[^{}]*';
my $redObj = '"[a-z]+":"red"';

my %tests = (
  '[1,2,3]' => 6,
  '{"a":2,"b":4}' => 6,
  '[[[3]]]' => 3,
  '{"a":{"b":4},"c":-1}' => 3,
  '{"a":[-1,1]}' => 0,
  '[-1,{"a":1}]' => 0,
  '[]' => 0,
  '{}' => 0,
);

my %testsRed = (
  '[1,2,3]' => 6,
  '[1,{"c":"red","b":2},3]' => 4,
  '{"d":"red","e":[1,2,3,4],"f":5}' => 0,
  '[1,"red",5]' => 6,
);

my $testComplex = '{"a":"yellow"{"b":"blue",{"c":"green"},"d":"red"}}';
my $testComplexExp = '{"a":"yellow"(omit)}';

##############################################################################
print "Tests:\n";
my $DEBUG = 1;

foreach my $testInput (sort keys %tests) {
  Advent::test($testInput, solve($testInput), $tests{$testInput});
}
foreach my $testInput (sort keys %testsRed) {
  Advent::test("$testInput (No red)", solveRed($testInput), $testsRed{$testInput});
}
Advent::test("removeComplex", removeRedBlockComplex($testComplex),$testComplexExp);

$DEBUG = 0;
print "\n";
##############################################################################

my $input = Advent::readBlock('12-input.txt');
Advent::solution(solve($input));
Advent::solution(solveRed($input),"no red blocks");

sub solve {
  my ($input) = @_;

  my @numbers = split(/[^-0-9]+/,$input);
  # print "$input -> @numbers\n" if $DEBUG;

  if (scalar(@numbers) == 0) { return 0; }
  return sum(@numbers);
}

## Well this complicates things!
##
## Any set of curly-braces with /".+":"red"/ inside it will be discarded -- including
## the contents of any nested braces {} or [], an outer block will be otherwise
## unaffected.
sub solveRed {
  my ($input) = @_;

  $input = removeRedBlocksSimple($input);
  while (hasRedObj($input)) {
    $input = removeRedBlockComplex($input);
  }

  return solve($input);
}

##############################################################################

sub removeRedBlocksSimple {
  my ($input) = @_;
  while ($input =~ /{$ncb$redObj$ncb}/) {
    $input =~ s/{$ncb$redObj$ncb}/(omit)/g;
  }
  return $input;
}

sub hasRedObj {
  my ($input) = @_;
  if ($input =~ /$redObj/) {
    return 1;
  }
  return 0;
}

sub removeRedBlockComplex {
  my ($input) = @_;
  if ($input =~ /^(.+)($redObj)(.+)$/) {
    my ($prefix,$obj,$suffix) = ($1,$2,$3);
    my ($subBlock,$i,$found);

    # Find opening containing brace
    $subBlock = 0;
    $i = length($prefix)-1;
    $found = 0;
    while (!$found) {
      my $ch = substr($prefix,$i,1);
      if ($ch eq '}') { 
        $subBlock++;
      } elsif ($ch eq '{') {
        $subBlock--;
        if ($subBlock < 0) { $found = 1; }
      }
      $i--;
      if ($i < 0) { print "OUT OF BOUNDS too short"; exit 7; }
    }
    my $omitPrefix = substr($prefix,$i+1);
    $prefix = substr($prefix,0,$i+1);

    # Find opening containing brace
    $subBlock = 0;
    $i = 0;
    $found = 0;
    while (!$found) {
      my $ch = substr($suffix,$i,1);
      if ($ch eq '{') { 
        $subBlock++;
      } elsif ($ch eq '}') {
        $subBlock--;
        if ($subBlock < 0) { $found = 1; }
      }
      $i++;
      if ($i > length($suffix)) { print "OUT OF BOUNDS too long"; exit 7; }
    }
    my $omitSuffix = substr($suffix,0,$i);
    $suffix = substr($suffix,$i);

    return "$prefix(omit)$suffix";
  }
return $input;
}
