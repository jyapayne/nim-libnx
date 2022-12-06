## *
##  @file avm.h
##  @brief AVM services IPC wrapper. Only available on [6.0.0+].
##  @author Behemoth
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

type
  AvmVersionListEntry* {.bycopy.} = object
    applicationId*: U64
    version*: U32
    required*: U32

  AvmRequiredVersionEntry* {.bycopy.} = object
    applicationId*: U64
    version*: U32

  AvmVersionListImporter* {.bycopy.} = object
    s*: Service


proc avmInitialize*(): Result {.cdecl, importc: "avmInitialize".}
proc avmExit*() {.cdecl, importc: "avmExit".}
proc avmGetServiceSession*(): ptr Service {.cdecl, importc: "avmGetServiceSession".}
proc avmGetHighestAvailableVersion*(id1: U64; id2: U64; version: ptr U32): Result {.
    cdecl, importc: "avmGetHighestAvailableVersion".}
proc avmGetHighestRequiredVersion*(id1: U64; id2: U64; version: ptr U32): Result {.cdecl,
    importc: "avmGetHighestRequiredVersion".}
proc avmGetVersionListEntry*(applicationId: U64; entry: ptr AvmVersionListEntry): Result {.
    cdecl, importc: "avmGetVersionListEntry".}
proc avmGetVersionListImporter*(`out`: ptr AvmVersionListImporter): Result {.cdecl,
    importc: "avmGetVersionListImporter".}
proc avmGetLaunchRequiredVersion*(applicationId: U64; version: ptr U32): Result {.
    cdecl, importc: "avmGetLaunchRequiredVersion".}
proc avmUpgradeLaunchRequiredVersion*(applicationId: U64; version: U32): Result {.
    cdecl, importc: "avmUpgradeLaunchRequiredVersion".}
proc avmPushLaunchVersion*(applicationId: U64; version: U32): Result {.cdecl,
    importc: "avmPushLaunchVersion".}
proc avmListVersionList*(buffer: ptr AvmVersionListEntry; count: csize_t;
                        `out`: ptr U32): Result {.cdecl,
    importc: "avmListVersionList".}
proc avmListRequiredVersion*(buffer: ptr AvmRequiredVersionEntry; count: csize_t;
                            `out`: ptr U32): Result {.cdecl,
    importc: "avmListRequiredVersion".}
proc avmVersionListImporterClose*(srv: ptr AvmVersionListImporter) {.cdecl,
    importc: "avmVersionListImporterClose".}
proc avmVersionListImporterSetTimestamp*(srv: ptr AvmVersionListImporter;
                                        timestamp: U64): Result {.cdecl,
    importc: "avmVersionListImporterSetTimestamp".}
proc avmVersionListImporterSetData*(srv: ptr AvmVersionListImporter;
                                   entries: ptr AvmVersionListEntry; count: U32): Result {.
    cdecl, importc: "avmVersionListImporterSetData".}
proc avmVersionListImporterFlush*(srv: ptr AvmVersionListImporter): Result {.cdecl,
    importc: "avmVersionListImporterFlush".}