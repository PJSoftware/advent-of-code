#!/bin/perl

use lib "./bin/lib";
use Git;

my $YEAR = $ARGV[0];
if (!$YEAR) {
  print "Year not specified\n";
  exit(1);
}

my $cb = Git::branch_current();
if ($cb !~ /^day\d\d/) {
  print "Branch $cb is not a dayNN branch!\n";
  exit(2);
}

system("git checkout $YEAR && git merge $cb --no-ff && git push && git branch -d $cb");
