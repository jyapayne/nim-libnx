import strutils
import ospaths
const headerlr = currentSourcePath().splitPath().head & "/nx/include/switch/services/lr.h"
import libnx/types
import libnx/sm
import libnx/fs
type
  LrLocationResolver* {.importc: "LrLocationResolver", header: headerlr, bycopy.} = object
    s* {.importc: "s".}: Service

  LrRegisteredLocationResolver* {.importc: "LrRegisteredLocationResolver",
                                 header: headerlr, bycopy.} = object
    s* {.importc: "s".}: Service


proc lrInitialize*(): Result {.cdecl, importc: "lrInitialize", header: headerlr.}
proc lrExit*() {.cdecl, importc: "lrExit", header: headerlr.}
proc lrOpenLocationResolver*(storage: FsStorageId; `out`: ptr LrLocationResolver): Result {.
    cdecl, importc: "lrOpenLocationResolver", header: headerlr.}
proc lrOpenRegisteredLocationResolver*(`out`: ptr LrRegisteredLocationResolver): Result {.
    cdecl, importc: "lrOpenRegisteredLocationResolver", header: headerlr.}
proc lrLrResolveProgramPath*(lr: ptr LrLocationResolver; tid: uint64; `out`: cstring): Result {.
    cdecl, importc: "lrLrResolveProgramPath", header: headerlr.}
proc lrLrRedirectProgramPath*(lr: ptr LrLocationResolver; tid: uint64; path: cstring): Result {.
    cdecl, importc: "lrLrRedirectProgramPath", header: headerlr.}
proc lrLrResolveApplicationControlPath*(lr: ptr LrLocationResolver; tid: uint64;
                                       `out`: cstring): Result {.cdecl,
    importc: "lrLrResolveApplicationControlPath", header: headerlr.}
proc lrLrResolveApplicationHtmlDocumentPath*(lr: ptr LrLocationResolver; tid: uint64;
    `out`: cstring): Result {.cdecl,
                           importc: "lrLrResolveApplicationHtmlDocumentPath",
                           header: headerlr.}
proc lrLrResolveDataPath*(lr: ptr LrLocationResolver; tid: uint64; `out`: cstring): Result {.
    cdecl, importc: "lrLrResolveDataPath", header: headerlr.}
proc lrLrRedirectApplicationControlPath*(lr: ptr LrLocationResolver; tid: uint64;
                                        path: cstring): Result {.cdecl,
    importc: "lrLrRedirectApplicationControlPath", header: headerlr.}
proc lrLrRedirectApplicationHtmlDocumentPath*(lr: ptr LrLocationResolver; tid: uint64;
    path: cstring): Result {.cdecl,
                          importc: "lrLrRedirectApplicationHtmlDocumentPath",
                          header: headerlr.}
proc lrLrResolveLegalInformationPath*(lr: ptr LrLocationResolver; tid: uint64;
                                     `out`: cstring): Result {.cdecl,
    importc: "lrLrResolveLegalInformationPath", header: headerlr.}
proc lrLrRedirectLegalInformationPath*(lr: ptr LrLocationResolver; tid: uint64;
                                      path: cstring): Result {.cdecl,
    importc: "lrLrRedirectLegalInformationPath", header: headerlr.}
proc lrLrRefresh*(lr: ptr LrLocationResolver): Result {.cdecl,
    importc: "lrLrRefresh", header: headerlr.}
proc lrRegLrResolveProgramPath*(reg: ptr LrRegisteredLocationResolver; tid: uint64;
                               `out`: cstring): Result {.cdecl,
    importc: "lrRegLrResolveProgramPath", header: headerlr.}