import strutils
import ospaths
const headersmm = currentSourcePath().splitPath().head & "/nx/include/switch/services/smm.h"
import libnx/wrapper/types
import libnx/wrapper/sm
import libnx/wrapper/fs
proc smManagerInitialize*(): Result {.cdecl, importc: "smManagerInitialize",
                                   header: headersmm.}
proc smManagerExit*() {.cdecl, importc: "smManagerExit", header: headersmm.}
proc smManagerRegisterProcess*(pid: uint64; acid_sac: pointer; acid_sac_size: csize;
                              aci0_sac: pointer; aci0_sac_size: csize): Result {.
    cdecl, importc: "smManagerRegisterProcess", header: headersmm.}
proc smManagerUnregisterProcess*(pid: uint64): Result {.cdecl,
    importc: "smManagerUnregisterProcess", header: headersmm.}