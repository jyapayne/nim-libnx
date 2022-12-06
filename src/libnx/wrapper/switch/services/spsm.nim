## *
##  @file spsm.h
##  @brief SPSM service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / Initialize spsm.

proc spsmInitialize*(): Result {.cdecl, importc: "spsmInitialize".}
## / Exit spsm.

proc spsmExit*() {.cdecl, importc: "spsmExit".}
## / Gets the Service object for the actual spsm service session.

proc spsmGetServiceSession*(): ptr Service {.cdecl, importc: "spsmGetServiceSession".}
proc spsmShutdown*(reboot: bool): Result {.cdecl, importc: "spsmShutdown".}
proc spsmPutErrorState*(): Result {.cdecl, importc: "spsmPutErrorState".}