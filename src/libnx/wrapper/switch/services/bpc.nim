## *
##  @file bpc.h
##  @brief Board power control (bpc) service IPC wrapper.
##  @author XorTroll, SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

type
  BpcSleepButtonState* = enum
    BpcSleepButtonStateHeld = 0, BpcSleepButtonStateReleased = 1


## / Initialize bpc.

proc bpcInitialize*(): Result {.cdecl, importc: "bpcInitialize".}
## / Exit bpc.

proc bpcExit*() {.cdecl, importc: "bpcExit".}
## / Gets the Service object for the actual bpc service session.

proc bpcGetServiceSession*(): ptr Service {.cdecl, importc: "bpcGetServiceSession".}
proc bpcShutdownSystem*(): Result {.cdecl, importc: "bpcShutdownSystem".}
proc bpcRebootSystem*(): Result {.cdecl, importc: "bpcRebootSystem".}
proc bpcGetSleepButtonState*(`out`: ptr BpcSleepButtonState): Result {.cdecl,
    importc: "bpcGetSleepButtonState".}
## /< [2.0.0-13.2.1]

proc bpcGetPowerButton*(outIsPushed: ptr bool): Result {.cdecl,
    importc: "bpcGetPowerButton".}
## /< [6.0.0+]
