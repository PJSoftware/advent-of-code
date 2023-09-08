package Ingredients;

use strict;

{

my %ingredient = ();
my %capacity = ();
my %durability = ();
my %flavor = ();
my %texture = ();
my %calories = ();

# Constructor

sub new {
    my ($class, $data) = @_;
    my $this = bless \do{my $anon}, $class;

    if ($data =~ /(\S+): capacity ([-0-9]+), durability ([-0-9]+), flavor ([-0-9]+), texture ([-0-9]+), calories ([-0-9]+)/) {
        $ingredient{$this} = $1;
        $capacity{$this} =$2;
        $durability{$this} =$3;
        $flavor{$this} =$4;
        $texture{$this} =$5;
        $calories{$this} =$6;
        return $this;
    }

    die "poorly formatted input to constructor: '$data'";
}

# Methods

sub ingredient {
    my ($this) = @_;
    return $ingredient{$this};
}

sub capacity {
    my ($this) = @_;
    return $capacity{$this};
}

sub durability {
    my ($this) = @_;
    return $durability{$this};
}

sub flavor {
    my ($this) = @_;
    return $flavor{$this};
}

sub texture {
    my ($this) = @_;
    return $texture{$this};
}

sub calories {
    my ($this) = @_;
    return $calories{$this};
}


# Class subroutines

}


1;