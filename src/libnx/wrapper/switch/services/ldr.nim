## *
##  @file ldr.h
##  @brief Loader (ldr*) service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/ncm_types

type
  LoaderProgramInfo* {.bycopy.} = object
    mainThreadPriority*: U8
    defaultCpuId*: U8
    applicationType*: U16
    mainThreadStackSize*: U32
    programId*: U64
    acidSacSize*: U32
    aci0SacSize*: U32
    acidFacSize*: U32
    aci0FahSize*: U32
    acBuffer*: array[0x3E0, U8]

  LoaderModuleInfo* {.bycopy.} = object
    buildId*: array[0x20, U8]
    baseAddress*: U64
    size*: U64

proc ldrShellInitialize*(): Result {.cdecl, importc: "ldrShellInitialize".}
## / Initialize ldr:shel.
proc ldrShellExit*() {.cdecl, importc: "ldrShellExit".}
## / Exit ldr:shel.
proc ldrShellGetServiceSession*(): ptr Service {.cdecl,
    importc: "ldrShellGetServiceSession".}
## / Gets the Service object for the actual ldr:shel service session.
proc ldrDmntInitialize*(): Result {.cdecl, importc: "ldrDmntInitialize".}
## / Initialize ldr:dmnt.
proc ldrDmntExit*() {.cdecl, importc: "ldrDmntExit".}
## / Exit ldr:dmnt.
proc ldrDmntGetServiceSession*(): ptr Service {.cdecl,
    importc: "ldrDmntGetServiceSession".}
## / Gets the Service object for the actual ldr:dmnt service session.
proc ldrPmInitialize*(): Result {.cdecl, importc: "ldrPmInitialize".}
## / Initialize ldr:pm.
proc ldrPmExit*() {.cdecl, importc: "ldrPmExit".}
## / Exit ldr:pm.
proc ldrPmGetServiceSession*(): ptr Service {.cdecl,
    importc: "ldrPmGetServiceSession".}
## / Gets the Service object for the actual ldr:pm service session.

proc ldrShellSetProgramArguments*(programId: U64; args: pointer; argsSize: csize_t): Result {.
    cdecl, importc: "ldrShellSetProgramArguments".}
proc ldrShellFlushArguments*(): Result {.cdecl, importc: "ldrShellFlushArguments".}
proc ldrDmntSetProgramArguments*(programId: U64; args: pointer; argsSize: csize_t): Result {.
    cdecl, importc: "ldrDmntSetProgramArguments".}
proc ldrDmntFlushArguments*(): Result {.cdecl, importc: "ldrDmntFlushArguments".}
proc ldrDmntGetProcessModuleInfo*(pid: U64; outModuleInfos: ptr LoaderModuleInfo;
                                 maxOutModules: csize_t; numOut: ptr S32): Result {.
    cdecl, importc: "ldrDmntGetProcessModuleInfo".}
proc ldrPmCreateProcess*(pinId: U64; flags: U32; reslimitH: Handle;
                        outProcessH: ptr Handle): Result {.cdecl,
    importc: "ldrPmCreateProcess".}
proc ldrPmGetProgramInfo*(loc: ptr NcmProgramLocation;
                         outProgramInfo: ptr LoaderProgramInfo): Result {.cdecl,
    importc: "ldrPmGetProgramInfo".}
proc ldrPmPinProgram*(loc: ptr NcmProgramLocation; outPinId: ptr U64): Result {.cdecl,
    importc: "ldrPmPinProgram".}
proc ldrPmUnpinProgram*(pinId: U64): Result {.cdecl, importc: "ldrPmUnpinProgram".}
proc ldrPmSetEnabledProgramVerification*(enabled: bool): Result {.cdecl,
    importc: "ldrPmSetEnabledProgramVerification".}
## /< [10.0.0+]
