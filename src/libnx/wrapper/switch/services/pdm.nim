## *
##  @file pdm.h
##  @brief PDM (pdm:*) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/acc, ../kernel/event

## / PlayEventType

type
  PdmPlayEventType* = enum
    PdmPlayEventTypeApplet = 0, ## /< Applet
    PdmPlayEventTypeAccount = 1, ## /< Account
    PdmPlayEventTypePowerStateChange = 2, ## /< PowerStateChange
    PdmPlayEventTypeOperationModeChange = 3, ## /< OperationModeChange
    PdmPlayEventTypeInitialize = 4 ## /< Initialize. Used for the very first PlayEvent entry in the log.


## / AppletEventType

type
  PdmAppletEventType* = enum
    PdmAppletEventTypeLaunch = 0, ## /< "launch"
    PdmAppletEventTypeExit = 1, ## /< "exit"
    PdmAppletEventTypeInFocus = 2, ## /< "in_focus"
    PdmAppletEventTypeOutOfFocus = 3, ## /< "out_of_focus"
    PdmAppletEventTypeOutOfFocus4 = 4, ## /< "out_of_focus"
    PdmAppletEventTypeExit5 = 5, ## /< "exit"
    PdmAppletEventTypeExit6 = 6 ## /< "exit"


## / PlayLogPolicy

type
  PdmPlayLogPolicy* = enum
    PdmPlayLogPolicyAll = 0,    ## /< All pdm:qry commands which require ::PdmPlayEventType_Applet and AppletId = Application will only return the entry when PlayLogPolicy matches this value.
    PdmPlayLogPolicyLogOnly = 1, ## /< The above commands will filter out the entry with this.
    PdmPlayLogPolicyNone = 2,   ## /< The pdm:ntfy commands which handle ::PdmPlayEventType_Applet logging will immediately return 0 when the input param matches this value.
    PdmPlayLogPolicyUnknown3 = 3 ## /< [10.0.0+] The cmds which require ::PdmPlayLogPolicy_All, now also allow value 3 if the cmd input flag is set.


## / AppletEvent.
## / Timestamp format, converted from PosixTime: total minutes since epoch UTC 1999/12/31 00:00:00.
## / See \ref pdmPlayTimestampToPosix.

type
  PdmAppletEvent* {.bycopy.} = object
    programId*: U64            ## /< ProgramId.
    entryIndex*: U32           ## /< Entry index.
    timestampUser*: U32        ## /< See PdmPlayEvent::timestampUser, with the above timestamp format.
    timestampNetwork*: U32     ## /< See PdmPlayEvent::timestampNetwork, with the above timestamp format.
    eventType*: U8             ## /< \ref PdmAppletEventType
    pad*: array[3, U8]          ## /< Padding.


## / PlayStatistics

type
  PdmPlayStatistics* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId.
    firstEntryIndex*: U32      ## /< Entry index for the first time the application was played.
    firstTimestampUser*: U32   ## /< See PdmAppletEvent::timestampUser. This is for the first time the application was played.
    firstTimestampNetwork*: U32 ## /< See PdmAppletEvent::timestampNetwork. This is for the first time the application was played.
    lastEntryIndex*: U32       ## /< Entry index for the last time the application was played.
    lastTimestampUser*: U32    ## /< See PdmAppletEvent::timestampUser. This is for the last time the application was played.
    lastTimestampNetwork*: U32 ## /< See PdmAppletEvent::timestampNetwork. This is for the last time the application was played.
    playtimeMinutes*: U32      ## /< Total play-time in minutes.
    totalLaunches*: U32        ## /< Total times the application was launched.


## / LastPlayTime.
## / This contains data from the last time the application was played.

type
  PdmLastPlayTime* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId.
    timestampUser*: U32        ## /< See PdmAppletEvent::timestampUser.
    timestampNetwork*: U32     ## /< See PdmAppletEvent::timestampNetwork.
    lastPlayedMinutes*: U32    ## /< Total minutes since the application was last played.
    flag*: U8                  ## /< Flag indicating whether the above field is set.
    pad*: array[3, U8]          ## /< Padding.


## / PlayEvent.
## / This is the raw entry struct directly read from FS, without any entry filtering.

type
  INNER_C_STRUCT_pdm_11* {.bycopy.} = object
    version*: U32              ## /< Application version.

  INNER_C_STRUCT_pdm_12* {.bycopy.} = object
    flag*: U8                  ## /< Set to 0x1 by pdm:ntfy cmd8, indicating that the below field is set to an input param.
    mode*: U8                  ## /< Input value from pdm:ntfy cmd8, see \ref LibAppletMode.
    pad*: array[2, U8]          ## /< Padding.

  INNER_C_UNION_pdm_10* {.bycopy, union.} = object
    application*: INNER_C_STRUCT_pdm_11 ## /< For AppletId == ::AppletId_application.
    applet*: INNER_C_STRUCT_pdm_12 ## /< For AppletId != ::AppletId_application.
    data*: U32

  INNER_C_STRUCT_pdm_9* {.bycopy.} = object
    programId*: array[2, U32]   ## /< ProgramId.
    unkX8*: INNER_C_UNION_pdm_10
    appletId*: U8              ## /< \ref AppletId
    storageId*: U8             ## /< \ref NcmStorageId
    logPolicy*: U8             ## /< \ref PdmPlayLogPolicy
    eventType*: U8             ## /< \ref PdmAppletEventType
    unused*: array[0xc, U8]     ## /< Unused.

  INNER_C_STRUCT_pdm_13* {.bycopy.} = object
    uid*: array[4, U32]         ## /< userId.
    applicationId*: array[2, U32] ## /< ApplicationId, see below.
    `type`*: U8                ## /< 0-1 to be listed by \ref pdmqryQueryAccountEvent, or 2 to include the above ApplicationId.

  INNER_C_STRUCT_pdm_14* {.bycopy.} = object
    value*: U8                 ## /< Input value from the pdm:ntfy command.
    unused*: array[0x1b, U8]    ## /< Unused.

  INNER_C_STRUCT_pdm_15* {.bycopy.} = object
    value*: U8                 ## /< Input value from the pdm:ntfy command.
    unused*: array[0x1b, U8]    ## /< Unused.

  INNER_C_UNION_pdm_8* {.bycopy, union.} = object
    applet*: INNER_C_STRUCT_pdm_9
    account*: INNER_C_STRUCT_pdm_13
    powerStateChange*: INNER_C_STRUCT_pdm_14
    operationModeChange*: INNER_C_STRUCT_pdm_15
    data*: array[0x1c, U8]

  PdmPlayEvent* {.bycopy.} = object
    eventData*: INNER_C_UNION_pdm_8 ## /< ProgramId/ApplicationId/userId stored within here have the u32 low/high swapped in each u64.
    playEventType*: U8         ## /< \ref PdmPlayEventType. Controls which struct in the above eventData is used. ::PdmPlayEventType_Initialize doesn't use eventData.
    pad*: array[3, U8]          ## /< Padding.
    timestampUser*: U64        ## /< PosixTime timestamp from StandardUserSystemClock.
    timestampNetwork*: U64     ## /< PosixTime timestamp from StandardNetworkSystemClock.
    timestampSteady*: U64      ## /< Timestamp in seconds derived from StandardSteadyClock.


## / AccountEvent

type
  PdmAccountEvent* {.bycopy.} = object
    uid*: AccountUid           ## /< \ref AccountUid
    entryIndex*: U32           ## /< Entry index.
    pad*: array[4, U8]          ## /< Padding.
    timestampUser*: U64        ## /< See PdmPlayEvent::timestampUser.
    timestampNetwork*: U64     ## /< See PdmPlayEvent::timestampNetwork.
    timestampSteady*: U64      ## /< See PdmPlayEvent::timestampSteady.
    `type`*: U8                ## /< See PdmPlayEvent::eventData::account::type.
    padX31*: array[7, U8]       ## /< Padding.


## / AccountPlayEvent.
## / This is the raw entry struct directly read from FS, without any entry filtering. This is separate from \ref PdmPlayEvent.

type
  PdmAccountPlayEvent* {.bycopy.} = object
    unkX0*: array[4, U8]        ## /< Unknown.
    applicationId*: array[2, U32] ## /< ApplicationId, with the u32 low/high words swapped.
    unkXc*: array[0xc, U8]      ## /< Unknown.
    timestamp0*: U64           ## /< POSIX timestamp.
    timestamp1*: U64           ## /< POSIX timestamp.


## / ApplicationPlayStatistics

type
  PdmApplicationPlayStatistics* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId.
    totalPlayTime*: U64        ## /< Total play-time in nanoseconds.
    totalLaunches*: U64        ## /< Total times the application was launched.


## / Initialize pdm:qry.

proc pdmqryInitialize*(): Result {.cdecl, importc: "pdmqryInitialize".}
## / Exit pdm:qry.

proc pdmqryExit*() {.cdecl, importc: "pdmqryExit".}
## / Gets the Service object for the actual pdm:qry service session.

proc pdmqryGetServiceSession*(): ptr Service {.cdecl,
    importc: "pdmqryGetServiceSession".}
## *
##  @brief Gets a list of \ref PdmAppletEvent.
##  @param[in] entry_index Start entry index.
##  @param[in] flag [10.0.0+] Whether to additionally allow using entries with ::PdmPlayLogPolicy_Unknown3.
##  @param[out] events Output \ref PdmAppletEvent array.
##  @param[in] count Max entries in the output array.
##  @param[out] total_out Total output entries.
##

proc pdmqryQueryAppletEvent*(entryIndex: S32; flag: bool; events: ptr PdmAppletEvent;
                            count: S32; totalOut: ptr S32): Result {.cdecl,
    importc: "pdmqryQueryAppletEvent".}
## *
##  @brief Gets \ref PdmPlayStatistics for the specified ApplicationId.
##  @param[in] application_id ApplicationId
##  @param[in] flag [10.0.0+] Whether to additionally allow using entries with ::PdmPlayLogPolicy_Unknown3.
##  @param[out] stats \ref PdmPlayStatistics
##

proc pdmqryQueryPlayStatisticsByApplicationId*(applicationId: U64; flag: bool;
    stats: ptr PdmPlayStatistics): Result {.cdecl, importc: "pdmqryQueryPlayStatisticsByApplicationId".}
## *
##  @brief Gets \ref PdmPlayStatistics for the specified ApplicationId and account userId.
##  @param[in] application_id ApplicationId
##  @param[in] uid \ref AccountUid
##  @param[in] flag [10.0.0+] Whether to additionally allow using entries with ::PdmPlayLogPolicy_Unknown3.
##  @param[out] stats \ref PdmPlayStatistics
##

proc pdmqryQueryPlayStatisticsByApplicationIdAndUserAccountId*(
    applicationId: U64; uid: AccountUid; flag: bool; stats: ptr PdmPlayStatistics): Result {.
    cdecl, importc: "pdmqryQueryPlayStatisticsByApplicationIdAndUserAccountId".}
## *
##  @brief Gets \ref PdmLastPlayTime for the specified applications.
##  @param[in] flag [10.0.0+] Whether to additionally allow using entries with ::PdmPlayLogPolicy_Unknown3.
##  @param[out] playtimes Output \ref PdmLastPlayTime array.
##  @param[in] application_ids Input ApplicationIds array.
##  @param[in] count Total entries in the input/output arrays.
##  @param[out] total_out Total output entries.
##

proc pdmqryQueryLastPlayTime*(flag: bool; playtimes: ptr PdmLastPlayTime;
                             applicationIds: ptr U64; count: S32; totalOut: ptr S32): Result {.
    cdecl, importc: "pdmqryQueryLastPlayTime".}
## *
##  @brief Gets a list of \ref PdmPlayEvent.
##  @param[in] entry_index Start entry index.
##  @param[out] events Output \ref PdmPlayEvent array.
##  @param[in] count Max entries in the output array.
##  @param[out] total_out Total output entries.
##

proc pdmqryQueryPlayEvent*(entryIndex: S32; events: ptr PdmPlayEvent; count: S32;
                          totalOut: ptr S32): Result {.cdecl,
    importc: "pdmqryQueryPlayEvent".}
## *
##  @brief Gets range fields which can then be used with the other pdmqry funcs, except for \ref pdmqryQueryAccountPlayEvent.
##  @param[out] total_entries Total entries.
##  @param[out] start_entry_index Start entry index.
##  @param[out] end_entry_index End entry index.
##

proc pdmqryGetAvailablePlayEventRange*(totalEntries: ptr S32;
                                      startEntryIndex: ptr S32;
                                      endEntryIndex: ptr S32): Result {.cdecl,
    importc: "pdmqryGetAvailablePlayEventRange".}
## *
##  @brief Gets a list of \ref PdmAccountEvent.
##  @param[in] entry_index Start entry index.
##  @param[out] events Output \ref PdmAccountEvent array.
##  @param[in] count Max entries in the output array.
##  @param[out] total_out Total output entries.
##

proc pdmqryQueryAccountEvent*(entryIndex: S32; events: ptr PdmAccountEvent;
                             count: S32; totalOut: ptr S32): Result {.cdecl,
    importc: "pdmqryQueryAccountEvent".}
## *
##  @brief Gets a list of \ref PdmAccountPlayEvent.
##  @note Only available with [4.0.0+].
##  @param[in] entry_index Start entry index.
##  @param[in] uid \ref AccountUid
##  @param[out] events Output \ref PdmAccountPlayEvent array.
##  @param[in] count Max entries in the output array.
##  @param[out] total_out Total output entries.
##

proc pdmqryQueryAccountPlayEvent*(entryIndex: S32; uid: AccountUid;
                                 events: ptr PdmAccountPlayEvent; count: S32;
                                 totalOut: ptr S32): Result {.cdecl,
    importc: "pdmqryQueryAccountPlayEvent".}
## *
##  @brief Gets range fields which can then be used with \ref pdmqryQueryAccountPlayEvent.
##  @param[in] uid \ref AccountUid
##  @param[out] total_entries Total entries.
##  @param[out] start_entry_index Start entry index.
##  @param[out] end_entry_index End entry index.
##

proc pdmqryGetAvailableAccountPlayEventRange*(uid: AccountUid;
    totalEntries: ptr S32; startEntryIndex: ptr S32; endEntryIndex: ptr S32): Result {.
    cdecl, importc: "pdmqryGetAvailableAccountPlayEventRange".}
## *
##  @brief Gets a list of applications played by the specified user.
##  @note Only available with [6.0.0-14.1.2].
##  @param[in] uid \ref AccountUid
##  @param[in] flag [10.0.0+] Whether to additionally allow using entries with ::PdmPlayLogPolicy_Unknown3.
##  @param[out] application_ids Output ApplicationIds array.
##  @param[in] count Max entries in the output array.
##  @param[out] total_out Total output entries.
##

proc pdmqryQueryRecentlyPlayedApplication*(uid: AccountUid; flag: bool;
    applicationIds: ptr U64; count: S32; totalOut: ptr S32): Result {.cdecl,
    importc: "pdmqryQueryRecentlyPlayedApplication".}
## *
##  @brief Gets an Event which is signaled when logging a new \ref PdmPlayEvent which would be available via \ref pdmqryQueryAccountEvent, where PdmPlayEvent::eventData::account::type is 0.
##  @note Only available with [6.0.0-14.1.2].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc pdmqryGetRecentlyPlayedApplicationUpdateEvent*(outEvent: ptr Event): Result {.
    cdecl, importc: "pdmqryGetRecentlyPlayedApplicationUpdateEvent".}
## *
##  @brief Helper function which converts a Play timestamp from the Pdm*Event structs to POSIX.
##  @param[in] timestamp Input timestamp.
##

proc pdmPlayTimestampToPosix*(timestamp: U32): U64 {.inline, cdecl.} =
  return (cast[U64](timestamp)) * 60 + 946598400
