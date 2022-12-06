## *
##  @file notif.h
##  @brief Alarm notification (notif:*) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../services/applet, ../services/acc, ../sf/service

## / ServiceType for \ref notifInitialize.

type
  NotifServiceType* = enum
    NotifServiceTypeApplication = 0, ## /< Initializes notif:a, for Application.
    NotifServiceTypeSystem = 1  ## /< Initializes notif:s, for System.


## / Data extracted from NotifWeeklyScheduleAlarmSetting::settings. This uses local-time.

type
  NotifAlarmTime* {.bycopy.} = object
    hour*: S32                 ## /< Hour.
    minute*: S32               ## /< Minute.


## / WeeklyScheduleAlarmSetting

type
  NotifWeeklyScheduleAlarmSetting* {.bycopy.} = object
    unkX0*: array[0xa, U8]      ## /< Unknown.
    settings*: array[7, S16]    ## /< Schedule settings for each day of the week, Sun-Sat. High byte is the hour, low byte is the minute. This uses local-time.


## / AlarmSetting

type
  NotifAlarmSetting* {.bycopy.} = object
    alarmSettingId*: U16       ## /< AlarmSettingId
    kind*: U8                  ## /< Kind: 0 = WeeklySchedule.
    muted*: U8                 ## /< u8 bool flag for whether this AlarmSetting is muted (non-zero = AlarmSetting turned off, zero = on).
    pad*: array[4, U8]          ## /< Padding.
    uid*: AccountUid           ## /< \ref AccountUid. User account associated with this AlarmSetting. Used for the preselected_user (\ref accountGetPreselectedUser) when launching the Application when the system was previously in sleep-mode, instead of launching the applet for selecting the user.
    applicationId*: U64        ## /< ApplicationId
    unkX20*: U64               ## /< Unknown.
    schedule*: NotifWeeklyScheduleAlarmSetting ## /< \ref NotifWeeklyScheduleAlarmSetting


## / Maximum alarms that can be registered at the same time by the host Application.

const
  NOTIF_MAX_ALARMS* = 8
proc notifInitialize*(serviceType: NotifServiceType): Result {.cdecl,
    importc: "notifInitialize".}
## / Initialize notif. Only available on [9.0.0+].

proc notifExit*() {.cdecl, importc: "notifExit".}
## / Exit notif.

proc notifGetServiceSession*(): ptr Service {.cdecl,
    importc: "notifGetServiceSession".}
## / Gets the Service object for the actual notif:* service session.

proc notifAlarmSettingCreate*(alarmSetting: ptr NotifAlarmSetting) {.cdecl,
    importc: "notifAlarmSettingCreate".}
## *
##  @brief Creates a \ref NotifAlarmSetting.
##  @note This clears the struct, with all schedule settings set the same as \ref notifAlarmSettingDisable.
##  @param[out] alarm_setting \ref NotifAlarmSetting
##

proc notifAlarmSettingSetIsMuted*(alarmSetting: ptr NotifAlarmSetting; flag: bool) {.
    inline, cdecl.} =
  ## *
  ##  @brief Sets whether the \ref NotifAlarmSetting is muted.
  ##  @note By default (\ref notifAlarmSettingCreate) this is false.
  ##  @param alarm_setting \ref NotifAlarmSetting
  ##  @param[in] flag Whether the alarm is muted (true = Alarm turned off, false = on).
  ##

  alarmSetting.muted = flag.U8

proc notifAlarmSettingSetUid*(alarmSetting: ptr NotifAlarmSetting; uid: AccountUid) {.
    inline, cdecl, importc: "notifAlarmSettingSetUid".} =
  ## *
  ##  @brief Sets the \ref AccountUid for the \ref NotifAlarmSetting, see NotifAlarmSetting::uid.
  ##  @param alarm_setting \ref NotifAlarmSetting
  ##  @param[in] uid \ref AccountUid. If want to clear the uid after it was previously set, you can use an all-zero uid to reset to the default (\ref notifAlarmSettingCreate).
  ##

  alarmSetting.uid = uid

proc notifAlarmSettingIsEnabled*(alarmSetting: ptr NotifAlarmSetting;
                                dayOfWeek: U32; `out`: ptr bool): Result {.cdecl,
    importc: "notifAlarmSettingIsEnabled".}
## *
##  @brief Gets whether the schedule setting for the specified day_of_week is enabled, for the \ref NotifAlarmSetting.
##  @param alarm_setting \ref NotifAlarmSetting
##  @param[in] day_of_week Day-of-week, must be 0-6 (Sun-Sat).
##  @param[out] out Whether the setting is enabled.
##

proc notifAlarmSettingGet*(alarmSetting: ptr NotifAlarmSetting; dayOfWeek: U32;
                          `out`: ptr NotifAlarmTime): Result {.cdecl,
    importc: "notifAlarmSettingGet".}
## *
##  @brief Gets the schedule setting for the specified day_of_week, for the \ref NotifAlarmSetting.
##  @note Should not be used if the output from \ref notifAlarmSettingIsEnabled is false.
##  @param alarm_setting \ref NotifAlarmSetting
##  @param[in] day_of_week Day-of-week, must be 0-6 (Sun-Sat).
##  @param[out] out \ref NotifAlarmTime
##

proc notifAlarmSettingEnable*(alarmSetting: ptr NotifAlarmSetting; dayOfWeek: U32;
                             hour: S32; minute: S32): Result {.cdecl,
    importc: "notifAlarmSettingEnable".}
## *
##  @brief Enables the schedule setting for the specified day_of_week, for the \ref NotifAlarmSetting. This uses local-time.
##  @param alarm_setting \ref NotifAlarmSetting
##  @param[in] day_of_week Day-of-week, must be 0-6 (Sun-Sat).
##  @param[in] hour Hour.
##  @param[in] minute Minute.
##

proc notifAlarmSettingDisable*(alarmSetting: ptr NotifAlarmSetting; dayOfWeek: U32): Result {.
    cdecl, importc: "notifAlarmSettingDisable".}
## *
##  @brief Disables the schedule setting for the specified day_of_week, for the \ref NotifAlarmSetting.
##  @note Schedule settings are disabled by default (\ref notifAlarmSettingCreate).
##  @param alarm_setting \ref NotifAlarmSetting
##  @param[in] day_of_week Day-of-week, must be 0-6 (Sun-Sat).
##

proc notifRegisterAlarmSetting*(alarmSettingId: ptr U16;
                               alarmSetting: ptr NotifAlarmSetting;
                               buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "notifRegisterAlarmSetting".}
## *
##  @brief Registers the specified AlarmSetting.
##  @note See \ref NOTIF_MAX_ALARMS for the maximum alarms.
##  @note When indicated by the output from \ref hidIsFirmwareUpdateNeededForNotification, this will use \ref hidLaShowControllerFirmwareUpdate.
##  @param[out] alarm_setting_id AlarmSettingId
##  @param[in] alarm_setting \ref NotifAlarmSetting
##  @param[in] buffer Input buffer containing the ApplicationParameter. Optional, can be NULL.
##  @param[in] size Input buffer size, must be <=0x400. Optional, can be 0.
##

proc notifUpdateAlarmSetting*(alarmSetting: ptr NotifAlarmSetting; buffer: pointer;
                             size: csize_t): Result {.cdecl,
    importc: "notifUpdateAlarmSetting".}
## *
##  @brief Updates the specified AlarmSetting.
##  @param[in] alarm_setting \ref NotifAlarmSetting
##  @param[in] buffer Input buffer containing the ApplicationParameter. Optional, can be NULL.
##  @param[in] size Input buffer size, must be <=0x400. Optional, can be 0.
##

proc notifListAlarmSettings*(alarmSettings: ptr NotifAlarmSetting; count: S32;
                            totalOut: ptr S32): Result {.cdecl,
    importc: "notifListAlarmSettings".}
## *
##  @brief Gets a listing of AlarmSettings.
##  @param[out] alarm_settings Output \ref NotifAlarmSetting array.
##  @param[in] count Total entries in the alarm_settings array.
##  @param[out] total_out Total output entries.
##

proc notifLoadApplicationParameter*(alarmSettingId: U16; buffer: pointer;
                                   size: csize_t; actualSize: ptr U32): Result {.
    cdecl, importc: "notifLoadApplicationParameter".}
## *
##  @brief Loads the ApplicationParameter for the specified AlarmSetting.
##  @param[in] alarm_setting_id AlarmSettingId
##  @param[out] buffer Output buffer containing the ApplicationParameter.
##  @param[in] size Output buffer size.
##  @param[out] actual_size Actual output size.
##

proc notifDeleteAlarmSetting*(alarmSettingId: U16): Result {.cdecl,
    importc: "notifDeleteAlarmSetting".}
## *
##  @brief Deletes the specified AlarmSetting.
##  @param[in] alarm_setting_id AlarmSettingId
##

proc notifGetNotificationSystemEvent*(outEvent: ptr Event): Result {.inline, cdecl.} =
  ## *
  ##  @brief Gets an Event which is signaled when data is available with \ref notifTryPopNotifiedApplicationParameter.
  ##  @note This is a wrapper for \ref appletGetNotificationStorageChannelEvent, see that for the usage requirements.
  ##  @note Some official apps don't use this.
  ##  @note The Event must be closed by the user once finished with it.
  ##  @param[out] out_event Output Event with autoclear=false.
  ##

  return appletGetNotificationStorageChannelEvent(outEvent)

proc notifTryPopNotifiedApplicationParameter*(buffer: pointer; size: U64;
    outSize: ptr U64): Result {.cdecl,
                            importc: "notifTryPopNotifiedApplicationParameter".}
## *
##  @brief Uses \ref appletTryPopFromNotificationStorageChannel then reads the data from there into the output params.
##  @note This is a wrapper for \ref appletTryPopFromNotificationStorageChannel, see that for the usage requirements.
##  @note The system will only push data for this when launching the Application when the Alarm was triggered, where the system was previously in sleep-mode.
##  @note Some official apps don't use this.
##  @param[out] buffer Output buffer.
##  @param[out] size Output buffer size.
##  @param[out] out_size Size of the data which was written into the output buffer. Optional, can be NULL.
##

