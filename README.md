# nim-libnx
Libnx ported to the Nim programming language. You will need a nim compiler with Nintendo switch support which can be found [here](https://github.com/jyapayne/Nim/tree/nintendo_switch_support) until the PR is accepted.

You also must have DevkitPro and switch (libnx) libraries for [Mac and Linux](https://github.com/devkitPro/pacman/releases) or [Windows](https://github.com/devkitPro/installer/releases) installed. The DEVKITPRO environment variable must also exist and point to a directory with the following structure:

- `DEVKITPRO/portlibs/switch/lib`
- `DEVKITPRO/libnx/lib`
- `DEVKITPRO/portlibs/switch/include`
- `DEVKITPRO/libnx/include`


##Install

Simply run

```bash
# Because of a bug in nimble right now, you must install this first!
nimble install nimgen@#head
nimble install
```

To compile examples:

```bash
nimble buildExamples
```

PRs are welcome for porting other examples or any other changes!
