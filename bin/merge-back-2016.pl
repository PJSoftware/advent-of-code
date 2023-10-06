#!/bin/perl

use strict;

use lib 'C:/_lib/perl';
use Git;

my $cb = Git::branch_current();
system("git checkout 2016");
system("git merge --no-ff $cb");
