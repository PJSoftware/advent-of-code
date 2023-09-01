#!/bin/perl

use strict;

my $YEAR = '2015';

if (!defined $ARGV[0]) {
  print "No advent day specified!\n";
  exit 1;
}

my $DAY = $ARGV[0];

if (-d "$YEAR/$DAY") {
  print "$YEAR/$DAY already exists; skipping!\n";
  exit 2;
}

mkdir($YEAR) unless -d $YEAR;
mkdir("$YEAR/$DAY");

gen_input($DAY);
gen_md($DAY);
gen_code($DAY);
append_task($DAY);

sub gen_input {
  my $day = shift;
  open my $FILE,'>',"$YEAR/$day/$day-input.txt";
  close $FILE;
}

sub gen_md {
  my $day = shift;
  open my $FILE,'>',"$YEAR/$day/$day.md";
  close $FILE;
}

sub gen_code {
  my $day = shift;
  open my $FILE,'>',"$YEAR/$day/$day.pl";
  close $FILE;
}

sub append_task {
  my $day = shift;
  open my $FILE,'>>',"Taskfile.yaml";
  print $FILE "\n";
  print $FILE "  $day:\n";
  print $FILE "    dir: ./2015/$day\n";
  print $FILE "    cmds:\n";
  print $FILE "      - perl ./$day.pl\n";
  close $FILE;
}