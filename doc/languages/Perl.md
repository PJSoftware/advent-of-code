# Perl

I have been using Perl on an almost daily basis for over 20 years now. I was
programming in Perl before I discovered proper version control (CVS in 2006,
switched to SVN shortly thereafter!)

I came from a background of Lisp, SQL, C++, a mild smattering of others, but in
the very early 2000s I inherited a Perl script that was used at work to perform
a specific task -- that had recently broken because one of the inputs had
changed. I had to fix it.

It didn't take me long to fall in love with the flexibility of Perl, but I think
what I loved most -- especially for many of the tasks I used it for -- was the
regular expressions. So powerful (albeit so potentially confusing) and just
built right in to the language. I'd never actually seen them before, and most of
the other languages I was using at the same time (I branched out into PHP, VBA,
a couple of others) either did not support them, or implemented them via a
bolt-on library which, having started with Perl, just never quite gelled for me.

Eventually, of course, I learned _better_ Perl. I started developing better
habits -- the self-taught programmer, working in a void, can be a frightening
thing, and Perl practically invites bad habits with its
**[TIMTOWTDI](https://perl.fandom.com/wiki/TIMTOWTDI)** and its non-**strict**
default operation. You can write some extremely fast and dirty code with Perl --
which is why, even now, I'll often turn to it for a quick one-off script or a
proof-of-concept -- but it can also produce an illegible confusing mess that you
wouldn't want to attempt to maintain.

Those were heady times. I had Perl installed on every machine in the office I
was supporting. I had Lisp code calling Perl code to run SQL queries, so that
AutoCAD could maintain a database alongside our drawings. I even developed an
internal PHP app to provide access to that database -- and later rewrote it in
Perl mostly as an exercise.

Fun times.

So, of course, when I decided to tackle _Advent of Code_, Perl was my automatic
first choice.

However, getting back into the language after a couple of years playing with
[Go](./Go.md) tended to highlight the shortcomings of what had once been my
favourite language. I think what I missed most was complex data structures. Perl
can simulate pretty much any structure that another language can use -- but
after a while, trying to wrestle with nested nested nested hashes, with no real
protection against doing the wrong thing, started to make my brain hurt. Where
were the `struct`s? Where were the `enum`s? Where was the rigour that kept you
safe? I realised I was missing Go. (Yeah, okay, Go doesn't quite have `enum`s
either!) But I knew that I'd be tackling the [2016](../2016/README.md) puzzles
in Go -- and that was when I realised I was going to attempt subsequent years'
puzzles in different languages!
