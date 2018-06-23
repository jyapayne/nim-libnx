import strutils
import ospaths
const headernv = currentSourcePath().splitPath().head & "/nx/include/switch/services/nv.h"
import libnx/wrapper/types
type
  nvServiceType* {.size: sizeof(cint).} = enum
    NVSERVTYPE_Default = -1, NVSERVTYPE_Application = 0, NVSERVTYPE_Applet = 1,
    NVSERVTYPE_Sysmodule = 2, NVSERVTYPE_T = 3


proc nvInitialize*(servicetype: nvServiceType; sharedmem_size: csize): Result {.
    cdecl, importc: "nvInitialize", header: headernv.}
proc nvExit*() {.cdecl, importc: "nvExit", header: headernv.}
proc nvOpen*(fd: ptr uint32; devicepath: cstring): Result {.cdecl, importc: "nvOpen",
    header: headernv.}
proc nvIoctl*(fd: uint32; request: uint32; argp: pointer): Result {.cdecl,
    importc: "nvIoctl", header: headernv.}
proc nvClose*(fd: uint32): Result {.cdecl, importc: "nvClose", header: headernv.}
proc nvQueryEvent*(fd: uint32; event_id: uint32; handle_out: ptr Handle): Result {.cdecl,
    importc: "nvQueryEvent", header: headernv.}
proc nvConvertError*(rc: cint): Result {.cdecl, importc: "nvConvertError",
                                     header: headernv.}