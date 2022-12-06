## *
##  @file ro.h
##  @brief Relocatable Objects (ro) service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/ldr

## / Initialize ldr:ro.

proc ldrRoInitialize*(): Result {.cdecl, importc: "ldrRoInitialize".}
## / Exit ldr:ro.

proc ldrRoExit*() {.cdecl, importc: "ldrRoExit".}
## / Gets the Service object for the actual ldr:ro service session.

proc ldrRoGetServiceSession*(): ptr Service {.cdecl,
    importc: "ldrRoGetServiceSession".}
## / Initialize ro:1. Only available with [7.0.0+].

proc ro1Initialize*(): Result {.cdecl, importc: "ro1Initialize".}
## / Exit ro:1.

proc ro1Exit*() {.cdecl, importc: "ro1Exit".}
## / Gets the Service object for the actual ro:1 service session.

proc ro1GetServiceSession*(): ptr Service {.cdecl, importc: "ro1GetServiceSession".}
## / Initialize ro:dmnt. Only available with [3.0.0+].

proc roDmntInitialize*(): Result {.cdecl, importc: "roDmntInitialize".}
## / Exit ro:dmnt.

proc roDmntExit*() {.cdecl, importc: "roDmntExit".}
## / Gets the Service object for the actual ro:dmnt service session.

proc roDmntGetServiceSession*(): ptr Service {.cdecl,
    importc: "roDmntGetServiceSession".}
proc ldrRoLoadNro*(outAddress: ptr U64; nroAddress: U64; nroSize: U64; bssAddress: U64;
                  bssSize: U64): Result {.cdecl, importc: "ldrRoLoadNro".}
proc ldrRoUnloadNro*(nroAddress: U64): Result {.cdecl, importc: "ldrRoUnloadNro".}
proc ldrRoLoadNrr*(nrrAddress: U64; nrrSize: U64): Result {.cdecl,
    importc: "ldrRoLoadNrr".}
proc ldrRoUnloadNrr*(nrrAddress: U64): Result {.cdecl, importc: "ldrRoUnloadNrr".}
proc ldrRoLoadNrrEx*(nrrAddress: U64; nrrSize: U64): Result {.cdecl,
    importc: "ldrRoLoadNrrEx".}
proc ro1LoadNro*(outAddress: ptr U64; nroAddress: U64; nroSize: U64; bssAddress: U64;
                bssSize: U64): Result {.cdecl, importc: "ro1LoadNro".}
proc ro1UnloadNro*(nroAddress: U64): Result {.cdecl, importc: "ro1UnloadNro".}
proc ro1LoadNrr*(nrrAddress: U64; nrrSize: U64): Result {.cdecl, importc: "ro1LoadNrr".}
proc ro1UnloadNrr*(nrrAddress: U64): Result {.cdecl, importc: "ro1UnloadNrr".}
proc ro1LoadNrrEx*(nrrAddress: U64; nrrSize: U64): Result {.cdecl,
    importc: "ro1LoadNrrEx".}
proc roDmntGetProcessModuleInfo*(pid: U64; outModuleInfos: ptr LoaderModuleInfo;
                                maxOutModules: csize_t; numOut: ptr S32): Result {.
    cdecl, importc: "roDmntGetProcessModuleInfo".}