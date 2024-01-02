# Day 13: A Maze of Twisty Little Cubicles

## Part One

You arrive at the first floor of this new building to discover a much less welcoming environment than the shiny atrium of the last one. Instead, you are in a maze of twisty little cubicles, all alike.

Every location in this area is addressed by a pair of non-negative integers (x,y). Each such coordinate is either a wall or an open space. You can't move diagonally. The cube maze starts at 0,0 and seems to extend infinitely toward positive x and y; negative values are invalid, as they represent a location outside the building. You are in a small waiting area at 1,1.

While it seems chaotic, a nearby morale-boosting poster explains, the layout is actually quite logical. You can determine whether a given x,y coordinate will be a wall or an open space using a simple system:

```txt
Find x*x + 3*x + 2*x*y + y + y*y.
Add the office designer's favorite number (your puzzle input).
Find the binary representation of that sum; count the number of bits that are 1.
If the number of bits that are 1 is even, it's an open space.
If the number of bits that are 1 is odd, it's a wall.
```

For example, if the office designer's favorite number were 10, drawing walls as ⬛ and open spaces as ⬜, the corner of the building containing 0,0 would look like this:

```txt
❌0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣
0️⃣⬜⬛⬜⬛⬛⬛⬛⬜⬛⬛
1️⃣⬜🟡⬛⬜⬜⬛⬜⬜⬜⬛
2️⃣⬛⬜⬜⬜⬜⬛⬛⬜⬜⬜
3️⃣⬛⬛⬛⬜⬛⬜⬛⬛⬛⬜
4️⃣⬜⬛⬛⬜⬜⬛⬜🔵⬛⬜
5️⃣⬜⬜⬛⬛⬜⬜⬜⬜⬛⬜
6️⃣⬛⬜⬜⬜⬛⬛⬜⬛⬛⬛
```

Now, suppose you wanted to reach 7,4. The shortest route you could take is marked as 🟢:

```txt
❌0️⃣1️⃣2️⃣3️⃣4️⃣5️⃣6️⃣7️⃣8️⃣9️⃣
0️⃣⬜⬛⬜⬛⬛⬛⬛⬜⬛⬛
1️⃣⬜🟡⬛⬜⬜⬛⬜⬜⬜⬛
2️⃣⬛🟢🟢🟢⬜⬛⬛⬜⬜⬜
3️⃣⬛⬛⬛🟢⬛⬜⬛⬛⬛⬜
4️⃣⬜⬛⬛🟢🟢⬛🟢🔵⬛⬜
5️⃣⬜⬜⬛⬛🟢🟢🟢⬜⬛⬜
6️⃣⬛⬜⬜⬜⬛⬛⬜⬛⬛⬛
```

Thus, reaching 7,4 would take a minimum of 11 steps (starting from your current location, 1,1).

What is the fewest number of steps required for you to reach 31,39?

Your puzzle input is `1358`.

## Part Two

How many locations (distinct x,y coordinates, including your starting location) can you reach in at most 50 steps?
