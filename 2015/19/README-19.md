# Day 19: Medicine for Rudolph

## Part One

Rudolph the Red-Nosed Reindeer is sick! His nose isn't shining very brightly, and he needs medicine.

Red-Nosed Reindeer biology isn't similar to regular reindeer biology; Rudolph is going to need custom-made medicine. Unfortunately, Red-Nosed Reindeer chemistry isn't similar to regular reindeer chemistry, either.

The North Pole is equipped with a Red-Nosed Reindeer nuclear fusion/fission plant, capable of constructing any Red-Nosed Reindeer molecule you need. It works by starting with some input molecule and then doing a series of replacements, **one per step**, until it has the right molecule.

However, the machine has to be calibrated before it can be used. Calibration involves determining the number of molecules that can be generated in one step from a given starting point.

For example, imagine a simpler machine that supports only the following replacements:

- `H => HO`
- `H => OH`
- `O => HH`

Given the replacements above and starting with `HOH`, the following molecules could be generated:

- `HOOH` (via H => HO on the first H).
- `HOHO` (via H => HO on the second H).
- `OHOH` (via H => OH on the first H).
- `HOOH` (via H => OH on the second H).
- `HHHH` (via O => HH).

So, in the example above, there are 4 distinct molecules (not five, because HOOH appears twice) after one replacement from HOH. Santa's favorite molecule, `HOHOHO`, can become 7 distinct molecules (over nine replacements: six from H, and three from O).

The machine replaces without regard for the surrounding characters. For example, given the string H2O, the transition H => OO would result in OO2O.

Your puzzle input describes all of the possible replacements and, at the bottom, the medicine molecule for which you need to calibrate the machine. How many distinct molecules can be created after all the different ways you can do one replacement on the medicine molecule?

## Part Two

Now that the machine is calibrated, you're ready to begin molecule fabrication.

Molecule fabrication always begins with just a single electron, e, and applying replacements one at a time, just like the ones during calibration.

For example, suppose you have the following replacements:

```txt
e => H
e => O
H => HO
H => OH
O => HH
```

If you'd like to make HOH, you start with e, and then make the following replacements:

e => O to get O
O => HH to get HH
H => OH (on the second H) to get HOH

So, you could make HOH after 3 steps. Santa's favorite molecule, HOHOHO, can be made in 6 steps.

How long will it take to make the medicine? Given the available replacements and the medicine molecule in your puzzle input, what is the fewest number of steps to go from e to the medicine molecule?

### Brute Force Approach

After 10 steps we had 31 million possible starting points. Given that our target molecule has a length of 285 elements, and at most we can add 7-8 elements per step, we need at least 35 steps to approach our answer. The brute force approach would almost certainly crash long before then.

What is of interest is that there are more target elements than source elements. That is, some target elements, once they lock into place, will never be changed. We may be able to use this to split our target molecule into smaller sub-molecules, by a little pattern analysis.

Analysis shows the following elements do not change once set: Ar, C, Rn, Y

Further examination of the input data shows the following:

- `C` is always the FIRST element of a target sequence.
- `Rn` is always the second element of a target sequence.
  - Often preceded by `C` but not always. May be preceded by `Th`, `Ti`, `P`, `Si`, `N`, `O`
  - The sequences `CRn`, `NRn`, `ORn` are fixed because no target sequence ends in `C`, `N`, `O`
- `Ar` is always the LAST element of a target sequence.
- `Y` is always in the middle of a target sequence, and is surrounded only by `F` or `Mg`.
  - An `F` or `Mg` before a `Y` is still open to change.
  - An `F` or `Mg` **after** a `Y` is locked in place, because no target sequence begins with an `F` or `Mg`!

The following sequences are fixed: `Ar`,`C`,`Rn`,`Y`; `CRn`,`NRn`,`ORn`,`YF`,`YMg`;

### Deconstruction

What if we work backward?

If we find every possible replacement target, transform it back to its source molecule, one transform per step ... is that guaranteed to return us to our starting point? Or will there be various return paths generated? Based on the HOH sample data, there will definitely be multiple possibilities -- (HO)H and H(OH) both transform back to HH -- but ultimately that brings us back to our starting electron! Will the same be true of our more complex puzzle data? And do multiple routes have multiple step count results?

I guess there's only one way to find out. Code it up.

## Solution Part Two

Deconstruction is the solution.

And I actually kinda love this puzzle for teaching me that there is often a better way. Simulating all possible paths forward while searching for one target solution among millions is, in this instance, one of those "heat death of the universe" brute force tasks. Running it backwards was practically instant. This may not always be the case, of course, but it's definitely worth remembering!

(If the test in line 134 had actually been triggered -- so that multiple return paths were possible -- we may have had the same problem in both directions!)
