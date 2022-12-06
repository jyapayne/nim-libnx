## *
##  @file time.h
##  @brief Time services IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / Values for __nx_time_service_type.

type
  TimeServiceType* = enum
    TimeServiceTypeUser = 0,    ## /< Default. Initializes time:u.
    TimeServiceTypeMenu = 1,    ## /< Initializes time:a
    TimeServiceTypeSystem = 2,  ## /< Initializes time:s.
    TimeServiceTypeRepair = 3,  ## /< Initializes time:r. Only available with [9.0.0+].
    TimeServiceTypeSystemUser = 4 ## /< Initializes time:su. Only available with [9.0.0+].


## / Time clock type.

type
  TimeType* = enum
    TimeTypeUserSystemClock, TimeTypeNetworkSystemClock, TimeTypeLocalSystemClock,

  TimeCalendarTime* {.bycopy.} = object
    year*: U16
    month*: U8
    day*: U8
    hour*: U8
    minute*: U8
    second*: U8
    pad*: U8

  TimeCalendarAdditionalInfo* {.bycopy.} = object
    wday*: U32                 ## /< 0-based day-of-week.
    yday*: U32                 ## /< 0-based day-of-year.
    timezoneName*: array[8, char] ## /< Timezone name string.
    dst*: U32                  ## /< 0 = no DST, 1 = DST.
    offset*: S32               ## /< Seconds relative to UTC for this timezone.

  TimeZoneRule* {.bycopy.} = object
    data*: array[0x4000, U8]

  TimeLocationName* {.bycopy.} = object
    name*: array[0x24, char]

  TimeSteadyClockTimePoint* {.bycopy.} = object
    timePoint*: S64            ## /< Monotonic count in seconds.
    sourceId*: Uuid            ## /< An ID representing the clock source.

  TimeStandardSteadyClockTimePointType* {.bycopy.} = object
    baseTime*: S64
    sourceId*: Uuid

  TimeSystemClockContext* {.bycopy.} = object
    offset*: S64
    timestamp*: TimeSteadyClockTimePoint

const TimeTypeDefault* = TimeTypeUserSystemClock

proc timeInitialize*(): Result {.cdecl, importc: "timeInitialize".}
## / Initialize time. Used automatically during app startup.

proc timeExit*() {.cdecl, importc: "timeExit".}
## / Exit time. Used automatically during app startup.

proc timeGetServiceSession*(): ptr Service {.cdecl, importc: "timeGetServiceSession".}
## / Gets the Service object for the actual time service session.

proc timeGetServiceSessionSystemClock*(`type`: TimeType): ptr Service {.cdecl,
    importc: "timeGetServiceSession_SystemClock".}
## / Gets the Service object for ISystemClock with the specified \ref TimeType. This will return NULL when the type is invalid.

proc timeGetServiceSessionSteadyClock*(): ptr Service {.cdecl,
    importc: "timeGetServiceSession_SteadyClock".}
## / Gets the Service object for ISteadyClock.

proc timeGetServiceSessionTimeZoneService*(): ptr Service {.cdecl,
    importc: "timeGetServiceSession_TimeZoneService".}
## / Gets the Service object for ITimeZoneService.

proc timeGetSharedmemAddr*(): pointer {.cdecl, importc: "timeGetSharedmemAddr".}
## / [6.0.0+] Gets the address of the SharedMemory.

proc timeGetStandardSteadyClockTimePoint*(`out`: ptr TimeSteadyClockTimePoint): Result {.
    cdecl, importc: "timeGetStandardSteadyClockTimePoint".}
## *
##  @brief Gets the timepoint for the standard steady clock.
##  @param[out] out Output timepoint (see \ref TimeSteadyClockTimePoint)
##  @remark The standard steady clock counts time since the RTC was configured (usually this happens during manufacturing).
##  @return Result code.
##

proc timeGetStandardSteadyClockInternalOffset*(`out`: ptr S64): Result {.cdecl,
    importc: "timeGetStandardSteadyClockInternalOffset".}
## *
##  @brief [3.0.0+] Gets the internal offset for the standard steady clock.
##  @param[out] out Output internal offset.
##  @return Result code.
##

proc timeGetCurrentTime*(`type`: TimeType; timestamp: ptr U64): Result {.cdecl,
    importc: "timeGetCurrentTime".}
## *
##  @brief Gets the time for the specified clock.
##  @param[in] type Clock to use.
##  @param[out] timestamp POSIX UTC timestamp.
##  @return Result code.
##

proc timeSetCurrentTime*(`type`: TimeType; timestamp: U64): Result {.cdecl,
    importc: "timeSetCurrentTime".}
## *
##  @brief Sets the time for the specified clock.
##  @param[in] type Clock to use.
##  @param[in] timestamp POSIX UTC timestamp.
##  @return Result code.
##

proc timeGetDeviceLocationName*(name: ptr TimeLocationName): Result {.cdecl,
    importc: "timeGetDeviceLocationName".}
proc timeSetDeviceLocationName*(name: ptr TimeLocationName): Result {.cdecl,
    importc: "timeSetDeviceLocationName".}
proc timeGetTotalLocationNameCount*(totalLocationNameCount: ptr S32): Result {.cdecl,
    importc: "timeGetTotalLocationNameCount".}
proc timeLoadLocationNameList*(index: S32; locationNameArray: ptr TimeLocationName;
                              locationNameMax: S32; locationNameCount: ptr S32): Result {.
    cdecl, importc: "timeLoadLocationNameList".}
proc timeLoadTimeZoneRule*(name: ptr TimeLocationName; rule: ptr TimeZoneRule): Result {.
    cdecl, importc: "timeLoadTimeZoneRule".}
proc timeToCalendarTime*(rule: ptr TimeZoneRule; timestamp: U64;
                        caltime: ptr TimeCalendarTime;
                        info: ptr TimeCalendarAdditionalInfo): Result {.cdecl,
    importc: "timeToCalendarTime".}
proc timeToCalendarTimeWithMyRule*(timestamp: U64; caltime: ptr TimeCalendarTime;
                                  info: ptr TimeCalendarAdditionalInfo): Result {.
    cdecl, importc: "timeToCalendarTimeWithMyRule".}
proc timeToPosixTime*(rule: ptr TimeZoneRule; caltime: ptr TimeCalendarTime;
                     timestampList: ptr U64; timestampListCount: S32;
                     timestampCount: ptr S32): Result {.cdecl,
    importc: "timeToPosixTime".}
proc timeToPosixTimeWithMyRule*(caltime: ptr TimeCalendarTime;
                               timestampList: ptr U64; timestampListCount: S32;
                               timestampCount: ptr S32): Result {.cdecl,
    importc: "timeToPosixTimeWithMyRule".}
