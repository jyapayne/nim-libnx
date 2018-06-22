import strutils
import ospaths
const headertime = currentSourcePath().splitPath().head & "/nx/include/switch/services/time.h"
import libnx_wrapper/types
import libnx_wrapper/sm
type
  TimeType* {.size: sizeof(cint).} = enum
    TimeType_UserSystemClock, TimeType_NetworkSystemClock,
    TimeType_LocalSystemClock

const
  TimeType_Default = TimeType_NetworkSystemClock

proc timeInitialize*(): Result {.cdecl, importc: "timeInitialize",
                              header: headertime.}
proc timeExit*() {.cdecl, importc: "timeExit", header: headertime.}
proc timeGetSessionService*(): ptr Service {.cdecl,
    importc: "timeGetSessionService", header: headertime.}
proc timeGetCurrentTime*(`type`: TimeType; timestamp: ptr uint64): Result {.cdecl,
    importc: "timeGetCurrentTime", header: headertime.}
proc timeSetCurrentTime*(`type`: TimeType; timestamp: uint64): Result {.cdecl,
    importc: "timeSetCurrentTime", header: headertime.}