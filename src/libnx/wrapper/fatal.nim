import strutils
import ospaths
const headerfatal = currentSourcePath().splitPath().head & "/nx/include/switch/services/fatal.h"
import libnx/wrapper/types
type
  FatalType* {.size: sizeof(cint).} = enum
    FatalType_ErrorReportAndErrorScreen = 0, FatalType_ErrorReport = 1,
    FatalType_ErrorScreen = 2


proc fatalSimple*(err: Result) {.cdecl, importc: "fatalSimple", header: headerfatal.}
proc fatalWithType*(err: Result; `type`: FatalType) {.cdecl,
    importc: "fatalWithType", header: headerfatal.}