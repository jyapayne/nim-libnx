## *
##  @file fspr.h
##  @brief FilesystemProxy-ProgramRegistry (fsp-pr) service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/ncm_types


proc fsprInitialize*(): Result {.cdecl, importc: "fsprInitialize".}
## / Initialize fsp-pr.

proc fsprExit*() {.cdecl, importc: "fsprExit".}
## / Exit fsp-pr.

proc fsprGetServiceSession*(): ptr Service {.cdecl, importc: "fsprGetServiceSession".}
## / Gets the Service object for the actual fsp-pr service session.
proc fsprRegisterProgram*(pid: U64; tid: U64; sid: NcmStorageId;
                         fsAccessHeader: pointer; fahSize: csize_t;
                         fsAccessControl: pointer; facSize: csize_t): Result {.cdecl,
    importc: "fsprRegisterProgram".}
proc fsprUnregisterProgram*(pid: U64): Result {.cdecl,
    importc: "fsprUnregisterProgram".}
proc fsprSetCurrentProcess*(): Result {.cdecl, importc: "fsprSetCurrentProcess".}
proc fsprSetEnabledProgramVerification*(enabled: bool): Result {.cdecl,
    importc: "fsprSetEnabledProgramVerification".}
