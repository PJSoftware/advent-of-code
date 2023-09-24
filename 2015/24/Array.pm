package Array;

my %array = ();

sub new {
  my ($class, @values) = @_;
  my $self = bless \do{my $anon}, $class;
  
  @{$array{$self}} = @values;
  return $self;
}

sub Push {
  my $self = shift;
  my ($value) = @_;
  push(@{$array{$self}},$value);
}

sub Sum {
  my $self = shift;

  my $sum = 0;
  foreach my $value (@{$array{$self}}) {
    $sum += $value;
  }

  return $sum;
}

sub Mult {
  my $self = shift;

  my $mult = 1;
  foreach my $value (@{$array{$self}}) {
    $mult *= $value;
  }

  return $mult;
}

1;
