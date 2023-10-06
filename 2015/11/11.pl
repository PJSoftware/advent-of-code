#!/bin/perl

use strict;
use lib "../lib";

use Advent;

my ($RULE1,$RULE2,$RULE3);
generateRulePatterns();

my %testValidity = (
  'abcdefg'   => 0,
  'hijklmmn'  => 0,
  'abbceffg'  => 0,
  'hijklmmn'  => 0,
  'abcdffaa'  => 1,
  'ghjaabcc'  => 1,
);
my %testNextPW = (
  'abcdefgh' => 'abcdffaa',
  'ghijklmn' => 'ghjaabcc',
);

##############################################################################
print "Tests:\n";
my $DEBUG = 0; # Tests seem to be passing

foreach my $test (sort keys %testValidity) {
  Advent::test("Validity: $test", isValid($test), $testValidity{$test});
}
foreach my $test (sort keys %testNextPW) {
  Advent::test("Next PW: $test", nextPW($test), $testNextPW{$test});
}

$DEBUG = 0;
print "\n";
##############################################################################

my $input = Advent::readBlock('11-input.txt');

my $next = nextPW($input);
Advent::solution($next,$input);

$input = $next;
$next = nextPW($input);
Advent::solution($next,$input);

sub generateRulePatterns {
  # Rule 1: abc|bcd|cde etc
  my @rule1 = ();
  foreach my $l1 ('a'..'x') {
    my $l2 = $l1;
    my $l3 = $l1;
    $l2++;
    $l3++; $l3++;
    push(@rule1, "$l1$l2$l3");
  }
  $RULE1 = join('|',@rule1);
  
  # Rule 2: no 'i','l','o'
  $RULE2 = '[oil]';
  
  # Rule 3: two different(?), non-overlapping patterns
  $RULE3 = '(.)\1.*(.)\2';
}

sub nextPW {
  my ($password) = @_;
  do {
    $password = incrementPW($password);
  } until isValid($password);
  return $password;
}

sub incrementPW {
  my ($currentPW) = @_;
  $currentPW++; # Sometimes I really love Perl!
  while (length($currentPW) > 8) {
    $currentPW =~ s{^.}{};
  }
  return $currentPW;
}

sub isValid {
  my ($password) = @_;
  print "Testing '$password'\n" if $DEBUG;
  if (length($password) != 8) {
    return 0;
  }

  my $passCount = 0;

  if ($password =~ m{$RULE1}) {
    $passCount++;
  } else {
    print "'$password' failed RULE 1: short straight\n" if $DEBUG;
  }

  if ($password !~ m{$RULE2}) {
    $passCount++;
  } else {
    print "'$password' failed RULE 2: no OIL\n" if $DEBUG;
  }

  if ($password =~ m{$RULE3}) {
    $passCount++;
  } else {
    print "'$password' failed RULE 3: two pairs\n" if $DEBUG;
  }

  return 1 if $passCount == 3;
  return 0;
}
