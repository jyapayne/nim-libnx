import strutils
import ospaths
const headernifm = currentSourcePath().splitPath().head & "/nx/include/switch/services/nifm.h"
import libnx/wrapper/types
import libnx/wrapper/ipc
import libnx/wrapper/detect
import libnx/wrapper/sm
proc nifmInitialize*(): Result {.cdecl, importc: "nifmInitialize",
                              header: headernifm.}
proc nifmExit*() {.cdecl, importc: "nifmExit", header: headernifm.}
proc nifmGetCurrentIpAddress*(`out`: ptr uint32): Result {.cdecl,
    importc: "nifmGetCurrentIpAddress", header: headernifm.}