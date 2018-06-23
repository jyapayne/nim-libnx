import strutils
import ospaths
const headertls = currentSourcePath().splitPath().head & "/nx/include/switch/arm/tls.h"
## *
##  @file tls.h
##  @brief AArch64 thread local storage.
##  @author plutoo
##  @copyright libnx Authors
## 

import
  libnx/wrapper/types

## *
##  @brief Gets the thread local storage buffer.
##  @return The thread local storage buffer.
## 

proc armGetTls*(): pointer {.inline, cdecl, importc: "armGetTls", header: headertls.}