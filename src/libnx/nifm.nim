import strutils
import ospaths
const headernifm = currentSourcePath().splitPath().head & "/nx/include/switch/services/nifm.h"
import libnx/types
import libnx/ipc
import libnx/detect
import libnx/sm
proc nifmInitialize*(): Result {.cdecl, importc: "nifmInitialize",
                              header: headernifm.}
proc nifmExit*() {.cdecl, importc: "nifmExit", header: headernifm.}
proc nifmGetCurrentIpAddress*(`out`: ptr uint32): Result {.cdecl,
    importc: "nifmGetCurrentIpAddress", header: headernifm.}