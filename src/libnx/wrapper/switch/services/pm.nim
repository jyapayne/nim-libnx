## *
##  @file pm.h
##  @brief Process management (pm*) service IPC wrapper.
##  @author plutoo
##  @author yellows8
##  @author mdbell
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../sf/service, ../services/ncm_types

## / LaunchFlag

type
  PmLaunchFlag* = enum
    PmLaunchFlagNone = 0,       ## /< PmLaunchFlag_* should be used on [5.0.0+].
    PmLaunchFlagSignalOnExit = (1 shl 0),
    PmLaunchFlagSignalOnStart = (1 shl 1),
    PmLaunchFlagSignalOnCrash = (1 shl 2),
    PmLaunchFlagSignalOnDebug = (1 shl 3),
    PmLaunchFlagStartSuspended = (1 shl 4),
    PmLaunchFlagDisableAslr = (1 shl 5), ## /< PmLaunchFlagOld_* should be used on [1.0.0-4.1.0].

  PmLaunchFlagOld* = enum
    PmLaunchFlagOldSignalOnExit = (1 shl 0),
    PmLaunchFlagOldStartSuspended = (1 shl 1),
    PmLaunchFlagOldSignalOnCrash = (1 shl 2),
    PmLaunchFlagOldDisableAslr = (1 shl 3),
    PmLaunchFlagOldSignalOnDebug = (1 shl 4),               ## /< PmLaunchFlagOld_SignalOnStart is only available on [2.0.0+].
    PmLaunchFlagOldSignalOnStart = (1 shl 5)


## / ProcessEvent

type
  PmProcessEvent* = enum
    PmProcessEventNone = 0, PmProcessEventExit = 1, PmProcessEventStart = 2,
    PmProcessEventCrash = 3, PmProcessEventDebugStart = 4,
    PmProcessEventDebugBreak = 5


## / ProcessEventInfo

type
  PmProcessEventInfo* {.bycopy.} = object
    event*: PmProcessEvent
    processId*: U64


## / BootMode

type
  PmBootMode* = enum
    PmBootModeNormal = 0,       ## /< Normal
    PmBootModeMaintenance = 1,  ## /< Maintenance
    PmBootModeSafeMode = 2      ## /< SafeMode


## / ResourceLimitValues

type
  PmResourceLimitValues* {.bycopy.} = object
    physicalMemory*: U64
    threadCount*: U32
    eventCount*: U32
    transferMemoryCount*: U32
    sessionCount*: U32

proc pmdmntInitialize*(): Result {.cdecl, importc: "pmdmntInitialize".}
## / Initialize pm:dmnt.
proc pmdmntExit*() {.cdecl, importc: "pmdmntExit".}
## / Exit pm:dmnt.
proc pmdmntGetServiceSession*(): ptr Service {.cdecl,
    importc: "pmdmntGetServiceSession".}
## / Gets the Service object for the actual pm:dmnt service session.
proc pminfoInitialize*(): Result {.cdecl, importc: "pminfoInitialize".}
## / Initialize pm:info.
proc pminfoExit*() {.cdecl, importc: "pminfoExit".}
## / Exit pm:info.
proc pminfoGetServiceSession*(): ptr Service {.cdecl,
    importc: "pminfoGetServiceSession".}
## / Gets the Service object for the actual pm:info service session.
proc pmshellInitialize*(): Result {.cdecl, importc: "pmshellInitialize".}
## / Initialize pm:shell.
proc pmshellExit*() {.cdecl, importc: "pmshellExit".}
## / Exit pm:shell.
proc pmshellGetServiceSession*(): ptr Service {.cdecl,
    importc: "pmshellGetServiceSession".}
## / Gets the Service object for the actual pm:shell service session.
proc pmbmInitialize*(): Result {.cdecl, importc: "pmbmInitialize".}
## / Initialize pm:bm.
proc pmbmExit*() {.cdecl, importc: "pmbmExit".}
## / Exit pm:bm.
proc pmbmGetServiceSession*(): ptr Service {.cdecl, importc: "pmbmGetServiceSession".}
## / Gets the Service object for the actual pm:bm service session.
proc pmbmGetBootMode*(`out`: ptr PmBootMode): Result {.cdecl,
    importc: "pmbmGetBootMode".}
## *
##  @brief Gets the \ref PmBootMode.
##  @param[out] out \ref PmBootMode
##
proc pmbmSetMaintenanceBoot*(): Result {.cdecl, importc: "pmbmSetMaintenanceBoot".}
## *
##  @brief Sets the \ref PmBootMode to ::PmBootMode_Maintenance.
##

proc pmdmntGetJitDebugProcessIdList*(outCount: ptr U32; outPids: ptr U64;
                                    maxPids: csize_t): Result {.cdecl,
    importc: "pmdmntGetJitDebugProcessIdList".}
proc pmdmntStartProcess*(pid: U64): Result {.cdecl, importc: "pmdmntStartProcess".}
proc pmdmntGetProcessId*(pidOut: ptr U64; programId: U64): Result {.cdecl,
    importc: "pmdmntGetProcessId".}
proc pmdmntHookToCreateProcess*(`out`: ptr Event; programId: U64): Result {.cdecl,
    importc: "pmdmntHookToCreateProcess".}
proc pmdmntGetApplicationProcessId*(pidOut: ptr U64): Result {.cdecl,
    importc: "pmdmntGetApplicationProcessId".}
proc pmdmntHookToCreateApplicationProcess*(`out`: ptr Event): Result {.cdecl,
    importc: "pmdmntHookToCreateApplicationProcess".}
proc pmdmntClearHook*(which: U32): Result {.cdecl, importc: "pmdmntClearHook".}
proc pmdmntGetProgramId*(programIdOut: ptr U64; pid: U64): Result {.cdecl,
    importc: "pmdmntGetProgramId".}
proc pminfoGetProgramId*(programIdOut: ptr U64; pid: U64): Result {.cdecl,
    importc: "pminfoGetProgramId".}
proc pminfoGetAppletCurrentResourceLimitValues*(`out`: ptr PmResourceLimitValues): Result {.
    cdecl, importc: "pminfoGetAppletCurrentResourceLimitValues".}
proc pminfoGetAppletPeakResourceLimitValues*(`out`: ptr PmResourceLimitValues): Result {.
    cdecl, importc: "pminfoGetAppletPeakResourceLimitValues".}
proc pmshellLaunchProgram*(launchFlags: U32; location: ptr NcmProgramLocation;
                          pid: ptr U64): Result {.cdecl,
    importc: "pmshellLaunchProgram".}
proc pmshellTerminateProcess*(processID: U64): Result {.cdecl,
    importc: "pmshellTerminateProcess".}
proc pmshellTerminateProgram*(programId: U64): Result {.cdecl,
    importc: "pmshellTerminateProgram".}
proc pmshellGetProcessEventHandle*(`out`: ptr Event): Result {.cdecl,
    importc: "pmshellGetProcessEventHandle".}

proc pmshellGetProcessEventInfo*(`out`: ptr PmProcessEventInfo): Result {.cdecl,
    importc: "pmshellGetProcessEventInfo".}
##  Autoclear for pmshellProcessEvent is always true.
proc pmshellCleanupProcess*(pid: U64): Result {.cdecl,
    importc: "pmshellCleanupProcess".}
proc pmshellClearJitDebugOccured*(pid: U64): Result {.cdecl,
    importc: "pmshellClearJitDebugOccured".}
proc pmshellNotifyBootFinished*(): Result {.cdecl,
    importc: "pmshellNotifyBootFinished".}
proc pmshellGetApplicationProcessIdForShell*(pidOut: ptr U64): Result {.cdecl,
    importc: "pmshellGetApplicationProcessIdForShell".}
proc pmshellBoostSystemMemoryResourceLimit*(boostSize: U64): Result {.cdecl,
    importc: "pmshellBoostSystemMemoryResourceLimit".}
proc pmshellBoostApplicationThreadResourceLimit*(): Result {.cdecl,
    importc: "pmshellBoostApplicationThreadResourceLimit".}
proc pmshellBoostSystemThreadResourceLimit*(): Result {.cdecl,
    importc: "pmshellBoostSystemThreadResourceLimit".}
