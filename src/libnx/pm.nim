import strutils
import ospaths
const headerpm = currentSourcePath().splitPath().head & "/nx/include/switch/services/pm.h"
import libnx/types
proc pmdmntInitialize*(): Result {.cdecl, importc: "pmdmntInitialize",
                                header: headerpm.}
proc pmdmntExit*() {.cdecl, importc: "pmdmntExit", header: headerpm.}
proc pminfoInitialize*(): Result {.cdecl, importc: "pminfoInitialize",
                                header: headerpm.}
proc pminfoExit*() {.cdecl, importc: "pminfoExit", header: headerpm.}
proc pmshellInitialize*(): Result {.cdecl, importc: "pmshellInitialize",
                                 header: headerpm.}
proc pmshellExit*() {.cdecl, importc: "pmshellExit", header: headerpm.}
proc pmdmntStartProcess*(pid: uint64): Result {.cdecl, importc: "pmdmntStartProcess",
    header: headerpm.}
proc pmdmntGetTitlePid*(pid_out: ptr uint64; title_id: uint64): Result {.cdecl,
    importc: "pmdmntGetTitlePid", header: headerpm.}
proc pmdmntEnableDebugForTitleId*(handle_out: ptr Handle; title_id: uint64): Result {.
    cdecl, importc: "pmdmntEnableDebugForTitleId", header: headerpm.}
proc pmdmntGetApplicationPid*(pid_out: ptr uint64): Result {.cdecl,
    importc: "pmdmntGetApplicationPid", header: headerpm.}
proc pmdmntEnableDebugForApplication*(handle_out: ptr Handle): Result {.cdecl,
    importc: "pmdmntEnableDebugForApplication", header: headerpm.}
proc pminfoGetTitleId*(title_id_out: ptr uint64; pid: uint64): Result {.cdecl,
    importc: "pminfoGetTitleId", header: headerpm.}
proc pmshellLaunchProcess*(launch_flags: uint32; titleID: uint64; storageID: uint64;
                          pid: ptr uint64): Result {.cdecl,
    importc: "pmshellLaunchProcess", header: headerpm.}
proc pmshellTerminateProcessByTitleId*(titleID: uint64): Result {.cdecl,
    importc: "pmshellTerminateProcessByTitleId", header: headerpm.}