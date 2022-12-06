## *
##  @file apm.h
##  @brief Performance management (apm) service IPC wrapper. This is used internally by applet with __nx_applet_PerformanceConfiguration, however if you prefer non-init/exit can be used manually. See also: https://switchbrew.org/wiki/PTM_services#apm:am
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / PerformanceMode

type
  ApmPerformanceMode* = enum
    ApmPerformanceModeInvalid = -1, ## /< Invalid
    ApmPerformanceModeNormal = 0, ## /< Normal
    ApmPerformanceModeBoost = 1 ## /< Boost


## / CpuBoostMode. With \ref appletSetCpuBoostMode, only values 0/1 are available. This allows using higher clock rates.

type
  ApmCpuBoostMode* = enum
    ApmCpuBoostModeNormal = 0,  ## /< Default, boost-mode disabled.
    ApmCpuBoostModeFastLoad = 1, ## /< Boost CPU. Additionally, throttle GPU to minimum. Use performance configurations 0x92220009 (Docked) and 0x9222000A (Handheld), or 0x9222000B and 0x9222000C.
    ApmCpuBoostModeType2 = 2    ## /< Conserve power. Only throttle GPU to minimum. Use performance configurations 0x9222000B and 0x9222000C.


## / Initialize apm. Used automatically by \ref appletInitialize with AppletType_Application.

proc apmInitialize*(): Result {.cdecl, importc: "apmInitialize".}
## / Exit apm. Used automatically by \ref appletExit with AppletType_Application.

proc apmExit*() {.cdecl, importc: "apmExit".}
## / Gets the Service object for the actual apm service session.

proc apmGetServiceSession*(): ptr Service {.cdecl, importc: "apmGetServiceSession".}
## / Gets the Service object for ISession.

proc apmGetServiceSessionSession*(): ptr Service {.cdecl,
    importc: "apmGetServiceSession_Session".}
## *
##  @brief Gets the current ApmPerformanceMode.
##  @param[out] out_performanceMode ApmPerformanceMode
##

proc apmGetPerformanceMode*(outPerformanceMode: ptr ApmPerformanceMode): Result {.
    cdecl, importc: "apmGetPerformanceMode".}
## *
##  @brief Sets the PerformanceConfiguration for the specified PerformanceMode.
##  @param[in] PerformanceMode \ref ApmPerformanceMode
##  @param[in] PerformanceConfiguration PerformanceConfiguration
##

proc apmSetPerformanceConfiguration*(performanceMode: ApmPerformanceMode;
                                    performanceConfiguration: U32): Result {.cdecl,
    importc: "apmSetPerformanceConfiguration".}
## *
##  @brief Gets the PerformanceConfiguration for the specified PerformanceMode.
##  @param[in] PerformanceMode \ref ApmPerformanceMode
##  @param[out] PerformanceConfiguration PerformanceConfiguration
##

proc apmGetPerformanceConfiguration*(performanceMode: ApmPerformanceMode;
                                    performanceConfiguration: ptr U32): Result {.
    cdecl, importc: "apmGetPerformanceConfiguration".}