#!/bin/perl

use strict;

use lib "../lib";
use Advent;

use lib '.';
use Ingredients;

my @testIngredients = (
  'Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8',
  'Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3',
);
my $testPerfectScore = 62842880;
my $testPerfectLowCal = 57600000;
##############################################################################
print "Tests:\n";
my $DEBUG = 1;

Advent::test("test batch", perfectCookies(0, @testIngredients), $testPerfectScore);
Advent::test("test batch", perfectCookies(500, @testIngredients), $testPerfectLowCal);

$DEBUG = 0;
print "\n";
##############################################################################

my @ingredients = Advent::readArray('15-input.txt');
Advent::solution(perfectCookies(0,@ingredients),"perfect");
Advent::solution(perfectCookies(500,@ingredients),"low cal");

sub perfectCookies {
  my ($maxCalories, @ingredientData) = @_;

  my @ingredients = ();
  foreach my $data (@ingredientData) {
    push(@ingredients, Ingredients->new($data));
  }

  my $numIngredients = scalar(@ingredients);
  my @allRecipes = allPossibleRecipes($numIngredients,100);

  my $bestScore = 0;
  my $bestRecipe = 0;
  foreach my $recipe (@allRecipes) {
    my ($c,$d,$f,$t) = (0,0,0,0);
    my $cal = 0;
    foreach my $index (0 .. $numIngredients-1) {
      $c += $recipe->[$index] * $ingredients[$index]->capacity();
      $d += $recipe->[$index] * $ingredients[$index]->durability();
      $f += $recipe->[$index] * $ingredients[$index]->flavor();
      $t += $recipe->[$index] * $ingredients[$index]->texture();
      $cal += $recipe->[$index] * $ingredients[$index]->calories();
      # print $recipe->[$index] . " " . $ingredients[$index]->ingredient() . ";";
    }
    my $score = $c*$d*$f*$t;
    if ($c <0 || $d < 0 || $f < 0 || $t < 0) {
      $score = 0;
    }
    if ($maxCalories) {
      if ($cal != $maxCalories) {
        $score = 0;
      }
    }
    if ($score > $bestScore) {
      $bestScore = $score;
      $bestRecipe = $recipe;
    }
    # print " => $score\n";
  }

  return $bestScore;
}

sub allPossibleRecipes {
  my ($num,$totalSpoons) = @_;
  my @rv = ();

  if ($num == 1) {
    my @recipe = ( $totalSpoons );
    push(@rv,\@recipe);
    return @rv;
  };

  foreach my $spoons (1..$totalSpoons-$num+1) {
    my @subRecipes = allPossibleRecipes($num-1,$totalSpoons-$spoons);
    foreach my $subRecipe (@subRecipes) {
      my @recipe = ();
      push(@recipe,$spoons);
      foreach my $amt (@{$subRecipe}) {
        push(@recipe, $amt);
      }
      push(@rv,\@recipe);
    }
  }
  return @rv;
}