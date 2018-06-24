# Package

version       = "0.1.0"
author        = "Joey Payne"
description   = "Nintendo Switch library libnx for Nim."
license       = "The Unlicense"

srcDir = "src"

# Deps
requires "nim >= 0.18.1", "https://github.com/jyapayne/nimgenEx#head"
requires "https://github.com/jyapayne/switch-build#head"

task setup, "Download and generate bindings":
  exec "nimgen libnxGen.cfg"

task buildExamples, "Build switch examples":
  exec "switch_build --author='jyapayne' --version='1.0.0' examples/helloworld/helloworld.nim"
  exec "switch_build --author='jyapayne' --version='1.0.0' examples/accounts/account_ex.nim"

#before install:
#  setupTask()

task test, "Run tests":
  exec "nim c -r tests/test.nim"
