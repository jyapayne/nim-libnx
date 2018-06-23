import strutils
import ospaths
const headerapm = currentSourcePath().splitPath().head & "/nx/include/switch/services/apm.h"
import libnx/wrapper/types
proc apmInitialize*(): Result {.cdecl, importc: "apmInitialize", header: headerapm.}
proc apmExit*() {.cdecl, importc: "apmExit", header: headerapm.}
proc apmSetPerformanceConfiguration*(PerformanceMode: uint32;
                                    PerformanceConfiguration: uint32): Result {.
    cdecl, importc: "apmSetPerformanceConfiguration", header: headerapm.}
proc apmGetPerformanceConfiguration*(PerformanceMode: uint32;
                                    PerformanceConfiguration: ptr uint32): Result {.
    cdecl, importc: "apmGetPerformanceConfiguration", header: headerapm.}