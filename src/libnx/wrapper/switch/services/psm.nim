## *
##  @file psm.h
##  @brief PSM service IPC wrapper.
##  @author XorTroll, endrift, and yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../kernel/event

type
  PsmChargerType* = enum
    PsmChargerTypeUnconnected = 0, ## /< No charger
    PsmChargerTypeEnoughPower = 1, ## /< Full supported power
    PsmChargerTypeLowPower = 2, ## /< Lower power supported USB-PD mode
    PsmChargerTypeNotSupported = 3 ## /< No common supported USB-PD modes
  PsmBatteryVoltageState* = enum
    PsmBatteryVoltageStateNeedsShutdown = 0, ## /< Power state should transition to shutdown
    PsmBatteryVoltageStateNeedsSleep = 1, ## /< Power state should transition to sleep
    PsmBatteryVoltageStateNoPerformanceBoost = 2, ## /< Performance boost modes cannot be entered
    PsmBatteryVoltageStateNormal = 3 ## /< Everything is normal



## / IPsmSession

type
  PsmSession* {.bycopy.} = object
    s*: Service
    stateChangeEvent*: Event   ## /< autoclear=false


## / Initialize psm.

proc psmInitialize*(): Result {.cdecl, importc: "psmInitialize".}
## / Exit psm.

proc psmExit*() {.cdecl, importc: "psmExit".}
## / Gets the Service object for the actual psm service session.

proc psmGetServiceSession*(): ptr Service {.cdecl, importc: "psmGetServiceSession".}
proc psmGetBatteryChargePercentage*(`out`: ptr U32): Result {.cdecl,
    importc: "psmGetBatteryChargePercentage".}
proc psmGetChargerType*(`out`: ptr PsmChargerType): Result {.cdecl,
    importc: "psmGetChargerType".}
proc psmGetBatteryVoltageState*(`out`: ptr PsmBatteryVoltageState): Result {.cdecl,
    importc: "psmGetBatteryVoltageState".}
proc psmGetRawBatteryChargePercentage*(`out`: ptr cdouble): Result {.cdecl,
    importc: "psmGetRawBatteryChargePercentage".}
proc psmIsEnoughPowerSupplied*(`out`: ptr bool): Result {.cdecl,
    importc: "psmIsEnoughPowerSupplied".}
proc psmGetBatteryAgePercentage*(`out`: ptr cdouble): Result {.cdecl,
    importc: "psmGetBatteryAgePercentage".}
## *
##  @brief Wrapper func which opens a PsmSession and handles event setup.
##  @note Uses the actual BindStateChangeEvent cmd internally.
##  @note The event is not signalled on BatteryChargePercentage changes.
##  @param[out] s PsmSession object.
##  @param[in] ChargerType Passed to SetChargerTypeChangeEventEnabled.
##  @param[in] PowerSupply Passed to SetPowerSupplyChangeEventEnabled.
##  @param[in] BatteryVoltage Passed to SetBatteryVoltageStateChangeEventEnabled.
##

proc psmBindStateChangeEvent*(s: ptr PsmSession; chargerType: bool; powerSupply: bool;
                             batteryVoltage: bool): Result {.cdecl,
    importc: "psmBindStateChangeEvent".}
## / Wait on the Event setup by \ref psmBindStateChangeEvent.

proc psmWaitStateChangeEvent*(s: ptr PsmSession; timeout: U64): Result {.cdecl,
    importc: "psmWaitStateChangeEvent".}
## / Cleanup version of \ref psmBindStateChangeEvent. Must be called by the user once the PsmSession is done being used.

proc psmUnbindStateChangeEvent*(s: ptr PsmSession): Result {.cdecl,
    importc: "psmUnbindStateChangeEvent".}