#!/bin/perl

use lib "./bin/lib";
use Git;

my $YEAR = $ARGV[0];
if (!$YEAR) {
  exit(1);
}

my $cb = Git::branch_current();
system("git checkout $YEAR && git merge $cb --no-ff && git push")
