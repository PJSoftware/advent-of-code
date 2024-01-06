# Rust

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

Okay. The whole [Ownership/Borrowing](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html) thing is definitely going to be one of my biggest stumbling blocks until I fully _grok_ it.

Integers (and `float`s, `bool`s, `char`s, etc) are easily copied -- because they are on the stack. But a `String` (not to be confused with a `&str`, which may or may not be similar to a `&String`!) is on the heap, and therefore is slow to copy, so by default copying is disabled, and using a String in your code **moves** it -- or rather, moves ownership of it.

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
