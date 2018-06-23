import strutils
import ospaths
const headerfspr = currentSourcePath().splitPath().head & "/nx/include/switch/services/fspr.h"
import libnx/wrapper/types
import libnx/wrapper/sm
import libnx/wrapper/fs
proc fsprInitialize*(): Result {.cdecl, importc: "fsprInitialize",
                              header: headerfspr.}
proc fsprExit*() {.cdecl, importc: "fsprExit", header: headerfspr.}
proc fsprRegisterProgram*(pid: uint64; titleID: uint64; storageID: FsStorageId;
                         fs_access_header: pointer; fah_size: csize;
                         fs_access_control: pointer; fac_size: csize): Result {.
    cdecl, importc: "fsprRegisterProgram", header: headerfspr.}
proc fsprUnregisterProgram*(pid: uint64): Result {.cdecl,
    importc: "fsprUnregisterProgram", header: headerfspr.}
proc fsprSetCurrentProcess*(): Result {.cdecl, importc: "fsprSetCurrentProcess",
                                     header: headerfspr.}
proc fsprSetEnabledProgramVerification*(enabled: bool): Result {.cdecl,
    importc: "fsprSetEnabledProgramVerification", header: headerfspr.}