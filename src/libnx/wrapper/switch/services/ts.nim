## *
##  @file ts.h
##  @brief Temperature measurement (ts) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / Location

type
  TsLocation* = enum
    TsLocationInternal = 0,     ## /< TMP451 Internal: PCB
    TsLocationExternal = 1      ## /< TMP451 External: SoC


## / Initialize ts.

proc tsInitialize*(): Result {.cdecl, importc: "tsInitialize".}
## / Exit ts.

proc tsExit*() {.cdecl, importc: "tsExit".}
## / Gets the Service for ts.

proc tsGetServiceSession*(): ptr Service {.cdecl, importc: "tsGetServiceSession".}
## *
##  @brief Gets the min/max temperature for the specified \ref TsLocation.
##  @param[in] location \ref TsLocation
##  @param[out] min_temperature Output minimum temperature in Celsius.
##  @param[out] max_temperature Output maximum temperature in Celsius.
##

proc tsGetTemperatureRange*(location: TsLocation; minTemperature: ptr S32;
                           maxTemperature: ptr S32): Result {.cdecl,
    importc: "tsGetTemperatureRange".}
## *
##  @brief Gets the temperature for the specified \ref TsLocation.
##  @param[in] location \ref TsLocation
##  @param[out] temperature Output temperature in Celsius.
##

proc tsGetTemperature*(location: TsLocation; temperature: ptr S32): Result {.cdecl,
    importc: "tsGetTemperature".}
## *
##  @brief Gets the temperature for the specified \ref TsLocation, in MilliC. [1.0.0-13.2.1]
##  @param[in] location \ref TsLocation
##  @param[out] temperature Output temperature in MilliC.
##

proc tsGetTemperatureMilliC*(location: TsLocation; temperature: ptr S32): Result {.
    cdecl, importc: "tsGetTemperatureMilliC".}