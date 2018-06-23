import strutils
import ospaths
const headercsrng = currentSourcePath().splitPath().head & "/nx/include/switch/services/csrng.h"
import libnx/wrapper/types
proc csrngInitialize*(): Result {.cdecl, importc: "csrngInitialize",
                               header: headercsrng.}
proc csrngExit*() {.cdecl, importc: "csrngExit", header: headercsrng.}
proc csrngGetRandomBytes*(`out`: pointer; out_size: csize): Result {.cdecl,
    importc: "csrngGetRandomBytes", header: headercsrng.}