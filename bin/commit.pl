#!/bin/perl

use strict;

use lib "./bin/lib";
use Git;

my $cb = Git::branch_current();
if ($cb !~ m{^day\d\d$}) {
  print "Skipping; commit script only applies to dayNN branch!\n";
  exit(2);
}

my $arg = $ARGV[0] // "";
if ($arg && !defined($ARGV[1])) {
  print "Usage: must specify both DAY and ANSWER!\n";
  exit(1);
}

my $answer = $ARGV[1];


$cb =~ s{(\D+)(\d+)}{$1 $2};
system(qq{git add .});

if ($arg == "") {
  system(qq{git commit -m "$cb puzzle, tests, framework added"});

} elsif ($arg == "1" || $arg == "2") {
  system(qq{git commit -m "$cb, part $arg -> $answer"});

} else {
  print "Unrecognised argument '$arg'; please specify part '1' or '2'\n";
}
