## *
##  @file tc.h
##  @brief Temperature control (tc) service IPC wrapper.
##  @author Behemoth
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / Initialize tc.

proc tcInitialize*(): Result {.cdecl, importc: "tcInitialize".}
## / Exit tc.

proc tcExit*() {.cdecl, importc: "tcExit".}
## / Gets the Service for tc.

proc tcGetServiceSession*(): ptr Service {.cdecl, importc: "tcGetServiceSession".}
proc tcEnableFanControl*(): Result {.cdecl, importc: "tcEnableFanControl".}
## / @warning Disabling your fan can damage your system.

proc tcDisableFanControl*(): Result {.cdecl, importc: "tcDisableFanControl".}
proc tcIsFanControlEnabled*(status: ptr bool): Result {.cdecl,
    importc: "tcIsFanControlEnabled".}
## / Only available on [5.0.0+].

proc tcGetSkinTemperatureMilliC*(skinTemp: ptr S32): Result {.cdecl,
    importc: "tcGetSkinTemperatureMilliC".}