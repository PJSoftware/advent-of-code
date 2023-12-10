#!/bin/perl

use strict;

use lib 'C:/_lib/perl';
use Git;

my $YEAR = $ARGV[0];
my $cb = Git::branch_current();

print "Checking out '$YEAR' and merging '$cb':\n";

system("git checkout $YEAR");
system("git merge --no-ff $cb");
