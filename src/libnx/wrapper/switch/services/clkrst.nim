## *
##  @file clkrst.h
##  @brief Clkrst service IPC wrapper.
##  @author p-sam
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/pcv

type
  ClkrstSession* {.bycopy.} = object
    s*: Service


## / Initialize clkrst. Only available on [8.0.0+].

proc clkrstInitialize*(): Result {.cdecl, importc: "clkrstInitialize".}
## / Exit clkrst.

proc clkrstExit*() {.cdecl, importc: "clkrstExit".}
## / Gets the Service object for the actual clkrst service session.

proc clkrstGetServiceSession*(): ptr Service {.cdecl,
    importc: "clkrstGetServiceSession".}
## / Opens a ClkrstSession for the requested PcvModuleId, unk is set to 3 in official sysmodules.

proc clkrstOpenSession*(sessionOut: ptr ClkrstSession; moduleId: PcvModuleId; unk: U32): Result {.
    cdecl, importc: "clkrstOpenSession".}
proc clkrstCloseSession*(session: ptr ClkrstSession) {.cdecl,
    importc: "clkrstCloseSession".}
proc clkrstSetClockRate*(session: ptr ClkrstSession; hz: U32): Result {.cdecl,
    importc: "clkrstSetClockRate".}
proc clkrstGetClockRate*(session: ptr ClkrstSession; outHz: ptr U32): Result {.cdecl,
    importc: "clkrstGetClockRate".}