# Package

version       = "0.1.0"
author        = "Joey Payne"
description   = "Nintendo Switch library libnx for Nim."
license       = "MIT"

srcDir = "src"

# Deps
requires "nim >= 0.18.0", "https://github.com/jyapayne/nimgenEx@#head"

task setup, "Download and generate":
  exec "nimgen libnxGen.cfg"

before install:
  setupTask()

task test, "Run tests":
  exec "nim c -r tests/test.nim"
