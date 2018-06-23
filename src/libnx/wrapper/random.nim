import strutils
import ospaths
const headerrandom = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/random.h"
import libnx/wrapper/types
proc randomGet*(buf: pointer; len: csize) {.cdecl, importc: "randomGet",
                                       header: headerrandom.}
proc randomGet64*(): uint64 {.cdecl, importc: "randomGet64", header: headerrandom.}