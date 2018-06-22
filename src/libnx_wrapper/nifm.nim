import strutils
import ospaths
const headernifm = currentSourcePath().splitPath().head & "/nx/include/switch/services/nifm.h"
import libnx_wrapper/types
import libnx_wrapper/ipc
import libnx_wrapper/detect
import libnx_wrapper/sm
proc nifmInitialize*(): Result {.cdecl, importc: "nifmInitialize",
                              header: headernifm.}
proc nifmExit*() {.cdecl, importc: "nifmExit", header: headernifm.}
proc nifmGetCurrentIpAddress*(`out`: ptr uint32): Result {.cdecl,
    importc: "nifmGetCurrentIpAddress", header: headernifm.}