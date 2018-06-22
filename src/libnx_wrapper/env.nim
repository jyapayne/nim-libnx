import strutils
import ospaths
const headerenv = currentSourcePath().splitPath().head & "/nx/include/switch/runtime/env.h"
import libnx_wrapper/types
type
  ConfigEntry* {.importc: "ConfigEntry", header: headerenv, bycopy.} = object
    Key* {.importc: "Key".}: uint32
    Flags* {.importc: "Flags".}: uint32
    Value* {.importc: "Value".}: array[2, uint64]


const
  EntryFlag_IsMandatory* = (1 shl (0))

const
  EntryType_EndOfList* = 0
  EntryType_MainThreadHandle* = 1
  EntryType_NextLoadPath* = 2
  EntryType_OverrideHeap* = 3
  EntryType_OverrideService* = 4
  EntryType_Argv* = 5
  EntryType_SyscallAvailableHint* = 6
  EntryType_AppletType* = 7
  EntryType_AppletWorkaround* = 8
  EntryType_StdioSockets* = 9
  EntryType_ProcessHandle* = 10
  EntryType_LastLoadResult* = 11

type
  LoaderReturnFn* = proc (result_code: cint) {.cdecl.}

proc envSetup*(ctx: pointer; main_thread: Handle; saved_lr: LoaderReturnFn) {.cdecl,
    importc: "envSetup", header: headerenv.}
proc envGetMainThreadHandle*(): Handle {.cdecl, importc: "envGetMainThreadHandle",
                                      header: headerenv.}
proc envIsNso*(): bool {.cdecl, importc: "envIsNso", header: headerenv.}
proc envHasHeapOverride*(): bool {.cdecl, importc: "envHasHeapOverride",
                                 header: headerenv.}
proc envGetHeapOverrideAddr*(): pointer {.cdecl,
                                       importc: "envGetHeapOverrideAddr",
                                       header: headerenv.}
proc envGetHeapOverrideSize*(): uint64 {.cdecl, importc: "envGetHeapOverrideSize",
                                   header: headerenv.}
proc envHasArgv*(): bool {.cdecl, importc: "envHasArgv", header: headerenv.}
proc envGetArgv*(): pointer {.cdecl, importc: "envGetArgv", header: headerenv.}
proc envIsSyscallHinted*(svc: uint8): bool {.cdecl, importc: "envIsSyscallHinted",
                                       header: headerenv.}
proc envGetOwnProcessHandle*(): Handle {.cdecl, importc: "envGetOwnProcessHandle",
                                      header: headerenv.}
proc envGetExitFuncPtr*(): LoaderReturnFn {.cdecl, importc: "envGetExitFuncPtr",
    header: headerenv.}
proc envSetNextLoad*(path: cstring; argv: cstring): Result {.cdecl,
    importc: "envSetNextLoad", header: headerenv.}
proc envHasNextLoad*(): bool {.cdecl, importc: "envHasNextLoad", header: headerenv.}
proc envGetLastLoadResult*(): Result {.cdecl, importc: "envGetLastLoadResult",
                                    header: headerenv.}