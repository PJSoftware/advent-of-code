# Rust

## Conclusion

After tackling the Day 01-06 puzzles of [2017](../../2017/README.md), and
wrestling with [Day 07](../../2017/07/README-07.md) for far too long, trying to
do something which should have been easy, I've officially added `Rust` to my
**no thanks** list. It just feels like it has been intentionally made
_difficult_. Given how good the compiler is at reporting on the errors, my
preference would be to simplify the language and have the compiler simply do the
right thing.

Maybe I shall return to it at some point ... or maybe not. Life is too short!

The remaining [2017](../../2017/README.md) puzzles, I shall switch to [Ruby](./Ruby.md).

## Getting Started

Programming in a Windows environment has its own special set of challenges; for
instance, I have several different versions of Perl installed for the several
different development environments I've tinkered with in the last year or so.

FWIW, installing Go was fairly straight-forward, from memory, and now that Go
uses modules, development in any random folder is fairly straight-forward.

But Rust?

I use `VS Code` as my preferred development environment, but I tend to stay away
from `Visual Studio` as much as possible. So when I started installing Rust to
tackle the 2017 challenges, seeing this was quite disheartening:

> Rust Visual C++ prerequisites
>
> Rust requires a linker and Windows API libraries but they don't seem to be
> available.
>
> These components can be acquired through a Visual Studio installer.
>
> 1. Quick install via the Visual Studio Community installer (free for
>    individuals, academic uses, and open source).
>
> 2. Manually install the prerequisites (for enterprise and advanced users).
>
> 3. Don't install the prerequisites (if you're targeting the GNU ABI).

I chose option 1 (it's too early in the day/year to be thinking _and_ learning a
new language) but _yikes_! It's (almost) enough to make me switch back to
`Linux`!

## Borrowing

Okay. The whole
[Ownership/Borrowing](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html)
thing is definitely going to be one of my biggest stumbling blocks until I fully
_grok_ it.

Integers (and `float`s, `bool`s, `char`s, etc) are easily copied -- because they
are on the stack. But a `String` (not to be confused with a `&str`, which may or
may not be similar to a `&String`!) is on the heap, and therefore is slow to
copy, so by default copying is disabled, and using a String in your code
**moves** it -- or rather, moves ownership of it.

All of this means that the following is okay:

```rs
let a = 3;
let b = a;
let c = a;
```

but this is _not_ okay:

```rs
let a = "3";
let b = a;
let c = a;
```

I think...?

## For Loops

In Rust, `for i in 1..5` produces `1,2,3,4`, not `1,2,3,4,5` as you might
expect. I know there are other languages which also do this -- and I hate it in
those languages too!

Of course, I'm used to Perl's `for $i (1..5)` which does produce the expected
`1,2,3,4,5`!

## Linked Lists, Graphs, etc

"_Rust is known to be notorious difficult when it comes to certain data
structures like linked lists, trees, etc. Many of such data structures have in
common the necessity of several variables pointing to one value. For instance in
a graph, two vertices could have a connection to a shared vertex. But when
removing just one of these vertices, the shared vertex should not be dropped. In
other words, none of these vertices can own the shared vertex in the strict
sense._"

## Final Thoughts

I'm really not a fan of Rust.

My understanding is it was developed to solve certain specific problems inherent
in `C`/`C++` -- but in the process it has made itself even more difficult to
manage.

I found this quote somewhere else: "It should be noted that the _authentic_ Rust
learning experience involves writing code, having the compiler scream at you,
and trying to figure out what the heck that means. I will be carefully ensuring
that this occurs as frequently as possible. Learning to read and understand
Rust's generally excellent compiler errors and documentation is _incredibly_
important to being a productive Rust programmer." To some degree this is true of
learning most languages -- and some have decidedly less useful error messages
than `Rust` does -- but I always feel that Rust is yelling at me for not
understanding some bizarre, complicated data management incantation that has
been invented purely to make life more difficult.

TL/DR: I like `Go`; I do not like `Rust`.

I seriously considered switching away from `Rust` to something else on:

- [Day 07](../../2017/07/README-07.md) (linked lists too complicated to use!)

(Spoiler alert: yup. Did it!)
