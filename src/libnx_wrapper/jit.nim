import strutils
import ospaths
const headerjit = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/jit.h"
import libnx_wrapper/types
type
  JitType* {.size: sizeof(cint).} = enum
    JitType_CodeMemory, JitType_JitMemory
  Jit* {.importc: "Jit", header: headerjit, bycopy.} = object
    `type`* {.importc: "type".}: JitType
    size* {.importc: "size".}: csize
    src_addr* {.importc: "src_addr".}: pointer
    rx_addr* {.importc: "rx_addr".}: pointer
    rw_addr* {.importc: "rw_addr".}: pointer
    is_executable* {.importc: "is_executable".}: bool
    handle* {.importc: "handle".}: Handle



proc jitCreate*(j: ptr Jit; size: csize): Result {.cdecl, importc: "jitCreate",
    header: headerjit.}
proc jitTransitionToWritable*(j: ptr Jit): Result {.cdecl,
    importc: "jitTransitionToWritable", header: headerjit.}
proc jitTransitionToExecutable*(j: ptr Jit): Result {.cdecl,
    importc: "jitTransitionToExecutable", header: headerjit.}
proc jitClose*(j: ptr Jit): Result {.cdecl, importc: "jitClose", header: headerjit.}
proc jitGetRwAddr*(j: ptr Jit): pointer {.cdecl, importc: "jitGetRwAddr",
                                     header: headerjit.}
proc jitGetRxAddr*(j: ptr Jit): pointer {.cdecl, importc: "jitGetRxAddr",
                                     header: headerjit.}