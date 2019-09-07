# nim-libnx
Libnx ported to the Nim programming language. You will need a Nim compiler with Nintendo switch support which can be found in the latest devel branch of the Nim compiler.

You also must have DevkitPro and switch (libnx) libraries for [Mac and Linux](https://github.com/devkitPro/pacman/releases) or [Windows](https://github.com/devkitPro/installer/releases) installed.

From dkp-pacman, the switch libraries can be installed with:

```
dkp-pacman -Syu
dkp-pacman -S switch-dev
## When it asks for installation options, choose the default which will install everything
```

The DEVKITPRO environment variable must also exist and point to a directory with the following structure:

- `DEVKITPRO/libnx/lib`
- `DEVKITPRO/libnx/include`

OR you must specify a valid libnx path and/or devkitpro path to the `switch_build` utility:

```bash
switch_build --libnxPath:"C:\devkitPro\libnx" --author:"Joey" --version:"1.0.0" .\examples\accounts\account_ex.nim
# OR
switch_build --devkitProPath:"C:\devkitPro" --author:"Joey" --version:"1.0.0" .\examples\accounts\account_ex.nim
```

## Install

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
