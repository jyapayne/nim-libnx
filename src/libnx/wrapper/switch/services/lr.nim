## *
##  @file lr.h
##  @brief Location Resolver (lr) service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/ncm_types

type
  LrLocationResolver* {.bycopy.} = object
    s*: Service

  LrRegisteredLocationResolver* {.bycopy.} = object
    s*: Service



proc lrInitialize*(): Result {.cdecl, importc: "lrInitialize".}
## / Initialize lr.

proc lrExit*() {.cdecl, importc: "lrExit".}
## / Exit lr.

proc lrGetServiceSession*(): ptr Service {.cdecl, importc: "lrGetServiceSession".}
## / Gets the Service object for the actual lr service session.
proc lrOpenLocationResolver*(storage: NcmStorageId; `out`: ptr LrLocationResolver): Result {.
    cdecl, importc: "lrOpenLocationResolver".}
proc lrOpenRegisteredLocationResolver*(`out`: ptr LrRegisteredLocationResolver): Result {.
    cdecl, importc: "lrOpenRegisteredLocationResolver".}

##  TODO: Other ILocationResolverManager commands
##  ILocationResolver

proc lrLrResolveProgramPath*(lr: ptr LrLocationResolver; tid: U64; `out`: cstring): Result {.
    cdecl, importc: "lrLrResolveProgramPath".}
proc lrLrRedirectProgramPath*(lr: ptr LrLocationResolver; tid: U64; path: cstring): Result {.
    cdecl, importc: "lrLrRedirectProgramPath".}
proc lrLrResolveApplicationControlPath*(lr: ptr LrLocationResolver; tid: U64;
                                       `out`: cstring): Result {.cdecl,
    importc: "lrLrResolveApplicationControlPath".}
proc lrLrResolveApplicationHtmlDocumentPath*(lr: ptr LrLocationResolver; tid: U64;
    `out`: cstring): Result {.cdecl,
                           importc: "lrLrResolveApplicationHtmlDocumentPath".}
proc lrLrResolveDataPath*(lr: ptr LrLocationResolver; tid: U64; `out`: cstring): Result {.
    cdecl, importc: "lrLrResolveDataPath".}
proc lrLrRedirectApplicationControlPath*(lr: ptr LrLocationResolver; tid: U64;
                                        tid2: U64; path: cstring): Result {.cdecl,
    importc: "lrLrRedirectApplicationControlPath".}
proc lrLrRedirectApplicationHtmlDocumentPath*(lr: ptr LrLocationResolver; tid: U64;
    tid2: U64; path: cstring): Result {.cdecl, importc: "lrLrRedirectApplicationHtmlDocumentPath".}
proc lrLrResolveApplicationLegalInformationPath*(lr: ptr LrLocationResolver;
    tid: U64; `out`: cstring): Result {.cdecl, importc: "lrLrResolveApplicationLegalInformationPath".}
proc lrLrRedirectApplicationLegalInformationPath*(lr: ptr LrLocationResolver;
    tid: U64; tid2: U64; path: cstring): Result {.cdecl,
    importc: "lrLrRedirectApplicationLegalInformationPath".}
proc lrLrRefresh*(lr: ptr LrLocationResolver): Result {.cdecl, importc: "lrLrRefresh".}

proc lrLrEraseProgramRedirection*(lr: ptr LrLocationResolver; tid: U64): Result {.
    cdecl, importc: "lrLrEraseProgramRedirection".}
## / Only available on [5.0.0+].

##  IRegisteredLocationResolver

proc lrRegLrResolveProgramPath*(reg: ptr LrRegisteredLocationResolver; tid: U64;
                               `out`: cstring): Result {.cdecl,
    importc: "lrRegLrResolveProgramPath".}

##  TODO: Other IRegisteredLocationResolver commands
