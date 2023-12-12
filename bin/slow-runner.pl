#!/bin/perl

print "Warning: this task takes a long time to run!\n\n";
print "Do you want to run it anyway? (y/N)\n";

my $cont = <STDIN>;
chomp $cont;

if ($cont =~ m{^y}i) {
  exit 0;
}

exit 1;
