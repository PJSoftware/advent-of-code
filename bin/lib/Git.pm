package Git;

use 5.10.0;
use version; our $VERSION = 'v0.0.2';

use Cwd qw{ cwd };

sub branch_current {
  my @branchList = `git branch`;
  foreach my $branch (@branchList) {
    $branch =~ s{[\r\n]+$}{};
    if ($branch =~ m{^[*] (.+)}) {
      return $1;
    }
  }
  return "dunno";
}

sub findRepos {
  my $parent = shift;
  my @repos = ();

  my $cwd = cwd();
  chdir($parent);

  foreach my $repo (<*>) {
    next unless -d $repo;
    next unless -d "$repo/.git";
    push(@repos,$repo);
  }

  chdir($cwd);
  return(@repos);
}

1;
