package Advent;

sub readBlock {
  my $fn = shift;
  open (my $IN, '<', $fn);
  my $input = '';
  foreach my $line (<$IN>) {
    $line =~ s{[\r\n]+$}{};
    $input = $line;
  }
  close $IN;

  return $input;
}

sub readArray {
  my $fn = shift;
  open (my $IN, '<', $fn);
  my @input = ();
  foreach my $line (<$IN>) {
    $line =~ s{[\r\n]+$}{};
    push(@input, $line);
  }
  close $IN;

  return @input;
}

sub test {
  my ($input, $got, $exp) = @_;
  if ($got eq $exp) {
    print "OK '$input' => $got (exp: $exp)\n";
  } else {
    print "** FAIL for '$input':\n";
    print "  - got $got, exp $exp\n";
    exit 3;
  }
}

sub solution {
  my ($solution, $id) = @_;
  print "Solution";
  print " ($id)" if $id;
  print ": $solution\n";
}

1;
