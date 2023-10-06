package Advent;

##### Common code for reading data

sub readBlock {
  my $fn = shift;
  print "Reading block of characters: ";
  die "File '$fn' not found" unless -f $fn;

  open (my $IN, '<', $fn);
  my $input = '';
  foreach my $line (<$IN>) {
    $line =~ s{[\r\n]+$}{};
    $input = $line;
  }
  close $IN;

  print length($input)." characters read\n";
  return $input;
}

sub readArray {
  my $fn = shift;
  print "Reading individual lines: ";
  die "File '$fn' not found" unless -f $fn;

  open (my $IN, '<', $fn);
  my @input = ();
  foreach my $line (<$IN>) {
    $line =~ s{[\r\n]+$}{};
    push(@input, $line);
  }
  close $IN;

  print scalar(@input)." lines read\n";
  return @input;
}

sub readHash {
  my $fn = shift;
  print "Reading individual lines: ";
  die "File '$fn' not found" unless -f $fn;

  open (my $IN, '<', $fn);
  my %input = ();
  foreach my $line (<$IN>) {
    $line =~ s{[\r\n]+$}{};
    if ($line =~ /^(\S.*\S)\s*[:=]\s*(\S.*)/) {
      $input{$1} = $2;
    } else {
      print "Line does not match pattern: '$line'\n";
      exit 1;
    }
  }
  close $IN;

  print scalar(keys %input)." lines read\n";
  return %input;
}

##### Common code for running tests

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

# Generate all possible combinations given an array of items
#
# Note that this returns an array of array references. The returned result will
# every possible combination, both forward and backward. So for two items,
# "A" and "B", it will return ("A" "B") and ("B" "A"). 

sub generateCombinations {
  my (@items) = @_;
  my @rv = ();

  if (scalar(@items) == 1) {
    push(@rv,\@items);
    return @rv;
  }

  foreach my $item (@items) {
    my @remainder = allExcept($item,@items);
    my @combos = generateCombinations(@remainder);
    foreach my $combo (@combos) {
      my @result = ($item);
      push(@result,@{$combo});
      push(@rv,\@result);
    }
  }
  return @rv;
}

# Returns array of array references, where each sub-array adds up to target
sub generateCombinationsWithTarget {
  my ($target, @items) = @_;
  my @rv = ();

  while (my $item = shift(@items)) {
    next if $item > $target;
    if ($item == $target) {
      push(@rv,wrap($item));
    } else {
      my @combos = generateCombinationsWithTarget($target-$item, @items);
      foreach my $combo (@combos) {
        my @result = ($item);
        push(@result,@{$combo});
        push(@rv,\@result);
      }
    }
  }
  return @rv;
}

# Wrap a scalar in an array, return array reference
sub wrap {
  my ($item) = @_;
  my @rv = ($item);
  return \@rv;
}

# Returns an array with specified value removed; expecting unique values!
sub allExcept {
  my ($value, @array) = @_;
  my @rv = ();
  foreach my $item (@array) {
    push(@rv, $item) unless $item eq $value;
  }
  return @rv;
}

1;
