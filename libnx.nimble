# Package

version       = "0.2.2"
author        = "Joey Payne"
description   = "Nintendo Switch library libnx for Nim."
license       = "The Unlicense"

srcDir = "src"

import distros

var prefix = ""
var username = getEnv("USER")
if detectOs(Windows):
  prefix = "cmd /c "
  username = getEnv("USERNAME")

# Deps
requires "nim >= 1.6.6"
requires "switch_build >= 0.1.3"

task buildExamples, "Build switch examples":
  if detectOs(Windows):
    let devkitPath = getEnv("DEVKITPRO")
    if devkitPath == "" or not dirExists(devkitPath):
      echo "You must set the DEVKITPRO environment variable to something valid!"
    else:
      exec prefix & "switch_build --libnxPath=\"" & devkitPath & "/libnx/\" --author=\"" & username & "\" --version=\"1.0.0\" examples/helloworld/helloworld.nim"
      exec prefix & "switch_build --libnxPath=\"" & devkitPath & "/libnx/\" --author=\"" & username & "\" --version=\"1.0.0\" examples/accounts/account_ex.nim"
  else:
    exec prefix & "switch_build --libnxPath=\"" & thisDir() & "/src/libnx/wrapper/nx/\" --author=\"" & username & "\" --version=\"1.0.0\" examples/helloworld/helloworld.nim"
    exec prefix & "switch_build --libnxPath=\"" & thisDir() & "/src/libnx/wrapper/nx/\" --author=\"" & username & "\" --version=\"1.0.0\" examples/accounts/account_ex.nim"

before install:
  setupTask()

task test, "Run tests":
  discard
# no tests because code needs to run on the Switch :(
#  exec "nim c -r tests/test.nim"
