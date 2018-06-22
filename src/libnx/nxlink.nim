import strutils
import ospaths
const headernxlink = currentSourcePath().splitPath().head & "/nx/include/switch/runtime/nxlink.h"
const
  NXLINK_SERVER_PORT* = 28280
  NXLINK_CLIENT_PORT* = 28771

type
  in_addr* {.importc: "in_addr", header: headernxlink, bycopy.} = object
  

var DUnxlink_host* {.importc: "__nxlink_host", header: headernxlink.}: in_addr

proc nxlinkStdio*(): cint {.cdecl, importc: "nxlinkStdio", header: headernxlink.}