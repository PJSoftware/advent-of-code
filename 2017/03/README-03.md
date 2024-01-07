# Day 3: Spiral Memory

## Part One

You come across an experimental new kind of memory stored on an infinite two-dimensional grid.

Each square on the grid is allocated in a spiral pattern starting at a location marked 1 and then counting up while spiraling outward. For example, the first few squares are allocated like this:

```txt
17 16 15 14 13
18  5  4  3 12
19  6  1  2 11
20  7  8  9 10
21 22 23---> ...
```

While this is very space-efficient (no squares are skipped), requested data must be carried back to square 1 (the location of the only access port for this memory system) by programs that can only move up, down, left, or right. They always take the shortest path: the [Manhattan Distance](https://en.wikipedia.org/wiki/Taxicab_geometry) between the location of the data and square 1.

For example:

- Data from square 1 is carried 0 steps, since it's at the access port.
- Data from square 12 is carried 3 steps, such as: down, left, left.
- Data from square 23 is carried only 2 steps: up twice.
- Data from square 1024 must be carried 31 steps.

How many steps are required to carry the data from the square identified in your puzzle input all the way to the access port?

Your puzzle input is `289326`.

### Part 1 Comments

This spiral arrangement is known as the [Ulam Spiral](https://en.wikipedia.org/wiki/Ulam_spiral) -- which is actually used primarily in conjunction with [Prime Numbers](https://en.wikipedia.org/wiki/Prime_number).

What I notice is that the bottom-right corners of the larger square around **point 1** are 1, 9, 25, 49, etc -- that is, 1^2, 3^2, 5^2, 7^2, etc. (The Manhattan distance of these being 0, 2, 4, 6, etc...) The "even squares", 2^2, 4^2, 6^2, etc, are spaced diagonally up/left from the point above **point 1** -- with a Manhattan distance of 1, 3, 5, etc. In each case, the "square" is one point before the actual corner of the spiral. If **point 1** is at (x=0, y=0), this should give us a good starting point to shortcut any potential simulation of the entire thing! (_Cue required simulation for Part Two!_)

Also possibly useful, the side lengths of the spiral are 1, 1, 2, 2, 3, 3, 4, 4, etc. The side lengths containing the even squares are 2, 4, 6, etc; the side lengths containing the odd squares are 1, 3, 5, etc.

The length of the side containing **n**^2, and the next following side is **n**; the side after that will contain the (**n+1**)^2 number (and hence be **n+1** long!)

## Part Two

As a stress test on the system, the programs here clear the grid and then store the value 1 in square 1. Then, in the same allocation order as shown above, they store the sum of the values in all adjacent squares, including diagonals.

So, the first few squares' values are chosen as follows:

- Square 1 starts with the value 1.
- Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
- Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
- Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
- Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.

Once a square is written, its value does not change. Therefore, the first few squares would receive the following values:

```txt
147  142  133  122   59
304    5    4    2   57
330   10    1    1   54
351   11   23   25   26
362  747  806--->   ...
```

What is the first value written that is larger than your puzzle input?
