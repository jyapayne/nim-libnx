## *
##  @file pgl.h
##  @brief PGL service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../sf/tipc, ../services/ncm_types, ../services/pm, ../kernel/event

## / LaunchFlag

type
  PglLaunchFlag* = enum
    PglLaunchFlagNone = 0, PglLaunchFlagEnableDetailedCrashReport = bit(0),
    PglLaunchFlagEnableCrashReportScreenShotForProduction = bit(1),
    PglLaunchFlagEnableCrashReportScreenShotForDevelop = bit(2)


## / SnapShotDumpType

type
  PglSnapShotDumpType* = enum
    PglSnapShotDumpTypeNone = 0, PglSnapShotDumpTypeAuto = 1,
    PglSnapShotDumpTypeFull = 2
  PglContentMetaInfo* {.bycopy.} = object
    id*: U64                   ## /< Program Id
    version*: U32              ## /< Version
    contentType*: U8           ## /< NcmContentType
    idOffset*: U8              ## /< Id Offset
    reserved0E*: array[2, U8]   ## /< Padding

  PglEventObserver* {.bycopy, union.} = object
    s*: Service
    t*: TipcService




proc pglInitialize*(): Result {.cdecl, importc: "pglInitialize".}
## / Initialize pgl.

proc pglExit*() {.cdecl, importc: "pglExit".}
## / Exit pgl.

proc pglGetServiceSessionCmif*(): ptr Service {.cdecl,
    importc: "pglGetServiceSessionCmif".}
## / Gets the Service object for the actual pgl service session. Requires < 12.0.0

proc pglGetServiceSessionTipc*(): ptr TipcService {.cdecl,
    importc: "pglGetServiceSessionTipc".}
## / Gets the TipcService object for the actual pgl service session. Requires 12.0.0+
proc pglLaunchProgram*(outPid: ptr U64; loc: ptr NcmProgramLocation;
                      pmLaunchFlags: U32; pglLaunchFlags: U8): Result {.cdecl,
    importc: "pglLaunchProgram".}
proc pglTerminateProcess*(pid: U64): Result {.cdecl, importc: "pglTerminateProcess".}
proc pglLaunchProgramFromHost*(outPid: ptr U64; contentPath: cstring;
                              pmLaunchFlags: U32): Result {.cdecl,
    importc: "pglLaunchProgramFromHost".}
proc pglGetHostContentMetaInfo*(`out`: ptr PglContentMetaInfo; contentPath: cstring): Result {.
    cdecl, importc: "pglGetHostContentMetaInfo".}
proc pglGetApplicationProcessId*(`out`: ptr U64): Result {.cdecl,
    importc: "pglGetApplicationProcessId".}
proc pglBoostSystemMemoryResourceLimit*(size: U64): Result {.cdecl,
    importc: "pglBoostSystemMemoryResourceLimit".}
proc pglIsProcessTracked*(`out`: ptr bool; pid: U64): Result {.cdecl,
    importc: "pglIsProcessTracked".}
proc pglEnableApplicationCrashReport*(en: bool): Result {.cdecl,
    importc: "pglEnableApplicationCrashReport".}
proc pglIsApplicationCrashReportEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "pglIsApplicationCrashReportEnabled".}
proc pglEnableApplicationAllThreadDumpOnCrash*(en: bool): Result {.cdecl,
    importc: "pglEnableApplicationAllThreadDumpOnCrash".}
proc pglTriggerApplicationSnapShotDumper*(dumpType: PglSnapShotDumpType;
    arg: cstring): Result {.cdecl, importc: "pglTriggerApplicationSnapShotDumper".}
proc pglGetEventObserver*(`out`: ptr PglEventObserver): Result {.cdecl,
    importc: "pglGetEventObserver".}
proc pglEventObserverGetProcessEvent*(observer: ptr PglEventObserver;
                                     `out`: ptr Event): Result {.cdecl,
    importc: "pglEventObserverGetProcessEvent".}
proc pglEventObserverGetProcessEventInfo*(observer: ptr PglEventObserver;
    `out`: ptr PmProcessEventInfo): Result {.cdecl,
    importc: "pglEventObserverGetProcessEventInfo".}
proc pglEventObserverClose*(observer: ptr PglEventObserver) {.cdecl,
    importc: "pglEventObserverClose".}
