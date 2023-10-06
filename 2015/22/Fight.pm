package Fight;

{

my %heroHP = ();
my %heroAC = ();
my %heroMana = ();
my %heroManaSpent = ();

my %bossHP = ();
my %bossDmg = ();

my %fightSpells = ();

sub new {
  my $class = shift;
  my $self = bless \do{my $anon}, $class;
  return $self;
}

sub addHero {
  my $self = shift;
}

sub addBoss {
  my $self = shift;
}

sub bestFight {
  my $self = shift;
}

sub manaSpent {
  my $self = shift;
  return 0;
}

}

1;
