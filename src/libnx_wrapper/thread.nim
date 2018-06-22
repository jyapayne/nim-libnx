import strutils
import ospaths
const headerthread = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/thread.h"
import libnx_wrapper/types
type
  Thread* {.importc: "Thread", header: headerthread, bycopy.} = object
    handle* {.importc: "handle".}: Handle
    stack_mem* {.importc: "stack_mem".}: pointer
    stack_mirror* {.importc: "stack_mirror".}: pointer
    stack_sz* {.importc: "stack_sz".}: csize


proc threadCreate*(t: ptr Thread; entry: ThreadFunc; arg: pointer; stack_sz: csize;
                  prio: cint; cpuid: cint): Result {.cdecl, importc: "threadCreate",
    header: headerthread.}
proc threadStart*(t: ptr Thread): Result {.cdecl, importc: "threadStart",
                                      header: headerthread.}
proc threadWaitForExit*(t: ptr Thread): Result {.cdecl,
    importc: "threadWaitForExit", header: headerthread.}
proc threadClose*(t: ptr Thread): Result {.cdecl, importc: "threadClose",
                                      header: headerthread.}
proc threadPause*(t: ptr Thread): Result {.cdecl, importc: "threadPause",
                                      header: headerthread.}
proc threadResume*(t: ptr Thread): Result {.cdecl, importc: "threadResume",
                                       header: headerthread.}