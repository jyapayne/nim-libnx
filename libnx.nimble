# Package

version       = "0.1.6"
author        = "Joey Payne"
description   = "Nintendo Switch library libnx for Nim."
license       = "The Unlicense"

srcDir = "src"

# Deps
requires "nim >= 0.18.1", "https://github.com/genotrance/nimgen#head"
requires "switch-build >= 0.1.6"

task setup, "Download and generate bindings":
  echo "Building libnx..."
  exec "nimgen libnxGen.cfg"

task buildExamples, "Build switch examples":
  exec "switch_build --libnxPath='" & thisDir() & "/src/libnx/wrapper/nx/' --author='jyapayne' --version='1.0.0' examples/helloworld/helloworld.nim"
  exec "switch_build --libnxPath='" & thisDir() & "/src/libnx/wrapper/nx/' --author='jyapayne' --version='1.0.0' examples/accounts/account_ex.nim"

before install:
  setupTask()

task test, "Run tests":
  discard
# no tests because code needs to run on the Switch :(
#  exec "nim c -r tests/test.nim"
