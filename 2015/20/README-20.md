# Day 20: Infinite Elves and Infinite Houses

## Part One

To keep the Elves busy, Santa has them deliver some presents by hand, door-to-door. He sends them down a street with infinite houses numbered sequentially: 1, 2, 3, 4, 5, and so on.

Each Elf is assigned a number, too, and delivers presents to houses based on that number:

The first Elf (number 1) delivers presents to every house: 1, 2, 3, 4, 5, ....
The second Elf (number 2) delivers presents to every second house: 2, 4, 6, 8, 10, ....
Elf number 3 delivers presents to every third house: 3, 6, 9, 12, 15, ....
There are infinitely many Elves, numbered starting with 1. Each Elf delivers presents equal to ten times his or her number at each house.

So, the first nine houses on the street end up like this:

```txt
House 1 got 10 presents.
House 2 got 30 presents.
House 3 got 40 presents.
House 4 got 70 presents.
House 5 got 60 presents.
House 6 got 120 presents.
House 7 got 80 presents.
House 8 got 150 presents.
House 9 got 130 presents.
```

The first house gets 10 presents: it is visited only by Elf 1, which delivers 1 \* 10 = 10 presents. The fourth house gets 70 presents, because it is visited by Elves 1, 2, and 4, for a total of 10 + 20 + 40 = 70 presents.

What is the lowest house number of the house to get at least as many presents as the number in your puzzle input?

### Comments

**P2**: I sense a Prime Number question coming in Part Two!

The number of presents to house _n_ is the sum of the factors of _n_, times 10

- `1` => (`1`) x 10
- `2` => (`1` + `2`) x 10
- `3` => (`1` + `3`) x 10
- `4` => (`1` + `2` + `4`) x 10
- `5` => (`1` + `5`) x 10
- etc

Therefore, we are looking for the lowest number whose `sum(factorials) >= 3310000` -- which I'd imagine is quite a large (but non-prime) number.

**P2**: If Part Two asks us for the _highest_ number house which receives that number of presents **or greater**, _then_ we are looking for a Prime number (and unless 3309999 is a prime, we're looking for the first prime greater than 3310000!)

For Part One, the sum of the factors of `n` will always be > `n`, so the maximum number we need to step to is our target house number (-1, but let's just include it anyway!)

## Part Two

The Elves decide they don't want to visit an infinite number of houses. Instead, each Elf will stop after delivering presents to 50 houses. To make up for it, they decide to deliver presents equal to eleven times their number at each house.

With these changes, what is the new lowest house number of the house to get at least as many presents as the number in your puzzle input?

### Comments 2

Of course, when I opt to take a mathematical approach rather than simulating the puzzle, they flip my thoughts on their head. Now I have to simulate. I think.

- Elf 1 delivers to 1,2,3,4,5,6 .. 50 and delivers 11 to each
- Elf 2 delivers to 2,4,6,8,10 .. 100 and delivers 22 to each
- Elf 3 delivers to 3,6,9,12,15 .. 150 and delivers 33 to each

Given the limited range, the delivery is much sparser,

- Elf 3009090 delivers 33009990 to houses 3009090, etc...
- Elf 3009091 delivers 33100001 (more than our target amount) to houses 3009091, etc

Deliveries to the first 100 houses look like this:

1 => 11
2 => 33
3 => 44
4 => 77
5 => 66
6 => 132
7 => 88
8 => 165
9 => 143
10 => 198
11 => 132
12 => 308
13 => 154
14 => 264
15 => 264
16 => 341
17 => 198
18 => 429
19 => 220
20 => 462
21 => 352
22 => 396
23 => 264
24 => 660
25 => 341
26 => 462
27 => 440
28 => 616
29 => 330
30 => 792
31 => 352
32 => 693
33 => 528
34 => 594
35 => 528
36 => 1001
37 => 418
38 => 660
39 => 616
40 => 990
41 => 462
42 => 1056
43 => 484
44 => 924
45 => 858
46 => 792
47 => 528
48 => 1364
49 => 627
50 => 1023
51 => 781
52 => 1067
53 => 583
54 => 1309
55 => 781
56 => 1309
57 => 869
58 => 979
59 => 649
60 => 1837
61 => 671
62 => 1045
63 => 1133
64 => 1386
65 => 913
66 => 1573
67 => 737
68 => 1375
69 => 1045
70 => 1573
71 => 781
72 => 2134
73 => 803
74 => 1243
75 => 1353
76 => 1529
77 => 1045
78 => 1837
79 => 869
80 => 2035
81 => 1320
82 => 1375
83 => 913
84 => 2453
85 => 1177
86 => 1441
87 => 1309
88 => 1969
89 => 979
90 => 2563
91 => 1221
92 => 1837
93 => 1397
94 => 1573
95 => 1309
96 => 2761
97 => 1067
98 => 1870
99 => 1705
100 => 2376
