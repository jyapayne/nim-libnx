## *
##  @file smm.h
##  @brief ServiceManager-IManager (sm:m) service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../sf/tipc

## / Initialize sm:m.

proc smManagerInitialize*(): Result {.cdecl, importc: "smManagerInitialize".}
## / Exit sm:m.

proc smManagerExit*() {.cdecl, importc: "smManagerExit".}
proc smManagerRegisterProcess*(pid: U64; acidSac: pointer; acidSacSize: csize_t;
                              aci0Sac: pointer; aci0SacSize: csize_t): Result {.
    cdecl, importc: "smManagerRegisterProcess".}
proc smManagerUnregisterProcess*(pid: U64): Result {.cdecl,
    importc: "smManagerUnregisterProcess".}
## / Initialize sm:m exclusively for tipc (requires <12.0.0 and non-Atmosphere).

proc smManagerCmifInitialize*(): Result {.cdecl, importc: "smManagerCmifInitialize".}
## / Exit sm:m exclusively for tipc (requires <12.0.0 and non-Atmosphere).

proc smManagerCmifExit*() {.cdecl, importc: "smManagerCmifExit".}
## / Gets the Service object for the actual sm:m service session (requires <12.0.0 and non-Atmosphere).

proc smManagerCmifGetServiceSession*(): ptr Service {.cdecl,
    importc: "smManagerCmifGetServiceSession".}
proc smManagerCmifRegisterProcess*(pid: U64; acidSac: pointer; acidSacSize: csize_t;
                                  aci0Sac: pointer; aci0SacSize: csize_t): Result {.
    cdecl, importc: "smManagerCmifRegisterProcess".}
proc smManagerCmifUnregisterProcess*(pid: U64): Result {.cdecl,
    importc: "smManagerCmifUnregisterProcess".}
## / Initialize sm:m exclusively for tipc (requires 12.0.0+ or Atmosphere).

proc smManagerTipcInitialize*(): Result {.cdecl, importc: "smManagerTipcInitialize".}
## / Exit sm:m exclusively for tipc (requires 12.0.0+ or Atmosphere).

proc smManagerTipcExit*() {.cdecl, importc: "smManagerTipcExit".}
## / Gets the TipcService object for the actual sm:m service session (requires 12.0.0+ or Atmosphere).

proc smManagerTipcGetServiceSession*(): ptr TipcService {.cdecl,
    importc: "smManagerTipcGetServiceSession".}
proc smManagerTipcRegisterProcess*(pid: U64; acidSac: pointer; acidSacSize: csize_t;
                                  aci0Sac: pointer; aci0SacSize: csize_t): Result {.
    cdecl, importc: "smManagerTipcRegisterProcess".}
proc smManagerTipcUnregisterProcess*(pid: U64): Result {.cdecl,
    importc: "smManagerTipcUnregisterProcess".}