## *
##  @file capmtp.h
##  @brief capmtp service IPC wrapper.
##  @note Only available on [11.0.0+].
##  @author Behemoth
##

import
  ../types, ../kernel/event, ../sf/service

proc capmtpInitialize*(mem: pointer; size: csize_t; appCount: U32; maxImg: U32;
                      maxVid: U32; otherName: cstring): Result {.cdecl,
    importc: "capmtpInitialize".}
proc capmtpExit*() {.cdecl, importc: "capmtpExit".}
proc capmtpGetRootServiceSession*(): ptr Service {.cdecl,
    importc: "capmtpGetRootServiceSession".}
proc capmtpGetServiceSession*(): ptr Service {.cdecl,
    importc: "capmtpGetServiceSession".}
proc capmtpStartCommandHandler*(): Result {.cdecl,
    importc: "capmtpStartCommandHandler".}
proc capmtpStopCommandHandler*(): Result {.cdecl,
                                        importc: "capmtpStopCommandHandler".}
proc capmtpIsRunning*(): bool {.cdecl, importc: "capmtpIsRunning".}
proc capmtpGetConnectionEvent*(): ptr Event {.cdecl,
    importc: "capmtpGetConnectionEvent".}
proc capmtpIsConnected*(): bool {.cdecl, importc: "capmtpIsConnected".}
proc capmtpGetScanErrorEvent*(): ptr Event {.cdecl,
    importc: "capmtpGetScanErrorEvent".}
proc capmtpGetScanError*(): Result {.cdecl, importc: "capmtpGetScanError".}