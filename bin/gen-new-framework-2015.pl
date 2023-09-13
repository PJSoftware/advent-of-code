#!/bin/perl

use strict;

use File::Copy qw{ copy };

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

print "Enter title for day $DAY puzzle:\n";
my $title = <STDIN>;
$title =~ s{[\r\n]*$}{};

gen_input($DAY);
gen_md($DAY, $title);
gen_code($DAY);
append_task($DAY);
append_entry($DAY,$title);
system("git checkout -b day$DAY");

sub gen_input {
  my $day = shift;
  open my $FILE,'>',"$YEAR/$day/$day-input.txt";
  close $FILE;
}

sub gen_md {
  my ($day,$title) = @_;
  my $dn = $day+0;

  open my $FILE,'>',"$YEAR/$day/README-$day.md";

  print $FILE "# Day $dn: $title\n\n";
  print $FILE "## Part One\n";
  close $FILE;
}

sub gen_code {
  my $day = shift;
  copy("bin/tmpl/$YEAR/script.pl","$YEAR/$day/$day.pl");
}

sub append_task {
  my $day = shift;
  open my $FILE,'>>',"Taskfile.yaml";
  print $FILE "\n";
  print $FILE "  $day:\n";
  print $FILE "    dir: ./$YEAR/$day\n";
  print $FILE "    cmds:\n";
  print $FILE "      - perl ./$day.pl\n";
  close $FILE;
}

sub append_entry {
  my ($day,$title) = @_;
  my $dn = $day+0;

  open my $FILE,'>>',"$YEAR/README.md";
  print $FILE "- [Day $dn](./$day/$day.md) - $title\n";
  close $FILE;
}
