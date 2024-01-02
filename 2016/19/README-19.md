# Day 19: An Elephant Named Joseph

## Part One

The Elves contact you over a highly secure emergency channel. Back at the North Pole, the Elves are busy misunderstanding [White Elephant parties](https://en.wikipedia.org/wiki/White_elephant_gift_exchange).

Each Elf brings a present. They all sit in a circle, numbered starting with position 1. Then, starting with the first Elf, they take turns stealing all the presents from the Elf to their left. An Elf with no presents is removed from the circle and does not take turns.

For example, with five Elves (numbered 1 to 5):

```txt
  1
5   2
 4 3
```

- Elf 1 takes Elf 2's present.
- Elf 2 has no presents and is skipped.
- Elf 3 takes Elf 4's present.
- Elf 4 has no presents and is also skipped.
- Elf 5 takes Elf 1's two presents.
- Neither Elf 1 nor Elf 2 have any presents, so both are skipped.
- Elf 3 takes Elf 5's three presents.

So, with five Elves, the Elf that sits starting in position 3 gets all the presents.

With the number of Elves given in your puzzle input, which Elf gets all the presents?

## Part Two

Realizing the folly of their present-exchange rules, the Elves agree to instead steal presents from the Elf directly across the circle. If two Elves are across the circle, the one on the left (from the perspective of the stealer) is stolen from. The other rules remain unchanged: Elves with no presents are removed from the circle entirely, and the other elves move in slightly to keep the circle evenly spaced.

For example, with five Elves (again numbered 1 to 5):

The Elves sit in a circle; Elf 1 goes first:

```txt
  1
5   2
 4 3
```

Elves 3 and 4 are across the circle; Elf 3's present is stolen, being the one to the left. Elf 3 leaves the circle, and the rest of the Elves move in:

```txt
  1           1
5   2  -->  5   2
 4 -          4
```

Elf 2 steals from the Elf directly across the circle, Elf 5:

```txt
  1         1 
-   2  -->     2
  4         4 
```

Next is Elf 4 who, choosing between Elves 1 and 2, steals from Elf 1:

```txt
 -          2  
    2  -->
 4          4
```

Finally, Elf 2 steals from Elf 4:

```txt
 2
    -->  2  
 -
```

So, with five Elves, the Elf that sits starting in position 2 gets all the presents.

With the number of Elves given in your puzzle input, which Elf now gets all the presents?

### Shortcut Solution?

[This helped](https://www.reddit.com/r/adventofcode/comments/5j4lp1/2016_day_19_solutions/)!

```txt
Solution 2 (n = 1): 1
Solution 2 (n = 2): 1
Solution 2 (n = 3): 3
Solution 2 (n = 4): 1
Solution 2 (n = 5): 2
Solution 2 (n = 6): 3
Solution 2 (n = 7): 5
Solution 2 (n = 8): 7
Solution 2 (n = 9): 9
Solution 2 (n = 10): 1
Solution 2 (n = 11): 2
Solution 2 (n = 12): 3
Solution 2 (n = 13): 4
Solution 2 (n = 14): 5
Solution 2 (n = 15): 6
Solution 2 (n = 16): 7
Solution 2 (n = 17): 8
Solution 2 (n = 18): 9
Solution 2 (n = 19): 11
Solution 2 (n = 20): 13
Solution 2 (n = 21): 15
Solution 2 (n = 22): 17
Solution 2 (n = 23): 19
Solution 2 (n = 24): 21
Solution 2 (n = 25): 23
Solution 2 (n = 26): 25
Solution 2 (n = 27): 27
Solution 2 (n = 28): 1
Solution 2 (n = 29): 2
Solution 2 (n = 30): 3
Solution 2 (n = 31): 4
Solution 2 (n = 32): 5
Solution 2 (n = 33): 6
Solution 2 (n = 34): 7
Solution 2 (n = 35): 8
Solution 2 (n = 36): 9
Solution 2 (n = 37): 10
Solution 2 (n = 38): 11
Solution 2 (n = 39): 12
Solution 2 (n = 40): 13
Solution 2 (n = 41): 14
Solution 2 (n = 42): 15
Solution 2 (n = 43): 16
Solution 2 (n = 44): 17
Solution 2 (n = 45): 18
Solution 2 (n = 46): 19
Solution 2 (n = 47): 20
Solution 2 (n = 48): 21
Solution 2 (n = 49): 22
Solution 2 (n = 50): 23
Solution 2 (n = 51): 24
Solution 2 (n = 52): 25
Solution 2 (n = 53): 26
Solution 2 (n = 54): 27
Solution 2 (n = 55): 29
Solution 2 (n = 56): 31
Solution 2 (n = 57): 33
Solution 2 (n = 58): 35
Solution 2 (n = 59): 37
Solution 2 (n = 60): 39
Solution 2 (n = 61): 41
Solution 2 (n = 62): 43
Solution 2 (n = 63): 45
Solution 2 (n = 64): 47
Solution 2 (n = 65): 49
Solution 2 (n = 66): 51
Solution 2 (n = 67): 53
Solution 2 (n = 68): 55
Solution 2 (n = 69): 57
Solution 2 (n = 70): 59
Solution 2 (n = 71): 61
Solution 2 (n = 72): 63
Solution 2 (n = 73): 65
Solution 2 (n = 74): 67
Solution 2 (n = 75): 69
Solution 2 (n = 76): 71
Solution 2 (n = 77): 73
Solution 2 (n = 78): 75
Solution 2 (n = 79): 77
Solution 2 (n = 80): 79
Solution 2 (n = 81): 81
Solution 2 (n = 82): 1
Solution 2 (n = 83): 2
Solution 2 (n = 84): 3
Solution 2 (n = 85): 4
Solution 2 (n = 86): 5
Solution 2 (n = 87): 6
Solution 2 (n = 88): 7
Solution 2 (n = 89): 8
Solution 2 (n = 90): 9
Solution 2 (n = 91): 10
Solution 2 (n = 92): 11
Solution 2 (n = 93): 12
Solution 2 (n = 94): 13
Solution 2 (n = 95): 14
Solution 2 (n = 96): 15
Solution 2 (n = 97): 16
Solution 2 (n = 98): 17
Solution 2 (n = 99): 18
Solution 2 (n = 100): 19
```

```txt
n = 243 => 243

if n = 3^x, w = 3^x
if n = 2*(3^x), w = 3^x

x = 0 -> 3^0 -> 1

```
