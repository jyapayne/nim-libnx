import strutils
import ospaths
const headerfatal = currentSourcePath().splitPath().head & "/nx/include/switch/services/fatal.h"
import libnx/types
proc fatalSimple*(err: Result) {.cdecl, importc: "fatalSimple", header: headerfatal.}