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
> 1) Quick install via the Visual Studio Community installer (free for
>    individuals, academic uses, and open source).
>
> 2) Manually install the prerequisites (for enterprise and advanced users).
>
> 3) Don't install the prerequisites (if you're targeting the GNU ABI).

I chose option 1 (it's too early in the day/year to be thinking _and_ learning a
new language) but _yikes_! It's (almost) enough to make me switch back to
`Linux`!
