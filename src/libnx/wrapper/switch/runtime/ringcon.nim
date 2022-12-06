## *
##  @file ringcon.h
##  @brief Wrapper for using the Ring-Con attached to a Joy-Con, with hidbus. See also: https://switchbrew.org/wiki/Ring-Con
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../services/hidbus, ../services/hid

const
  RINGCON_CAL_MAGIC* = -0x3502 ## 0xCAFE

## / Whether the output data is valid.

type
  RingConDataValid* = enum
    RingConDataValidOk = 0,     ## /< Valid.
    RingConDataValidCRC = 1,    ## /< Bad CRC.
    RingConDataValidCal = 2     ## /< Only used with \ref ringconReadUserCal. Calibration is needed via \ref ringconUpdateUserCal.
  RingConErrorFlag* = enum
    RingConErrorFlagBadUserCalUpdate = 0, ## /< The output from \ref ringconReadUserCal doesn't match the input used with \ref ringconWriteUserCal, or the \ref RingConDataValid is not ::RingConDataValid_Ok.
    RingConErrorFlagBadFlag = 4, ## /< The output flag from \ref ringconCmdx00020105 when successful is invalid.
    RingConErrorFlagBadUserCal = 5, ## /< BadUserCal
    RingConErrorFlagBadManuCal = 6 ## /< BadManuCal



## / Ring-Con firmware version.

type
  RingConFwVersion* {.bycopy.} = object
    fwMainVer*: U8             ## /< Main firmware version.
    fwSubVer*: U8              ## /< Sub firmware version.


## / Ring-Con manufacturer calibration.

type
  RingConManuCal* {.bycopy.} = object
    osMax*: S16                ## /< (manu_)os_max
    hkMax*: S16                ## /< (manu_)hk_max
    zeroMin*: S16              ## /< (manu_)zero_min
    zeroMax*: S16              ## /< (manu_)zero_max


## / Ring-Con user calibration.

type
  RingConUserCal* {.bycopy.} = object
    osMax*: S16                ## /< (user_)os_max
    hkMax*: S16                ## /< (user_)hk_max
    zero*: S16                 ## /< (user_)zero
    dataValid*: RingConDataValid ## /< \ref RingConDataValid


## / Polling data extracted from \ref HidbusJoyPollingReceivedData.

type
  RingConPollingData* {.bycopy.} = object
    data*: S16                 ## /< Sensor state data.
    samplingNumber*: U64       ## /< SamplingNumber


## / Ring-Con state object.

type
  RingCon* {.bycopy.} = object
    busInitialized*: bool
    handle*: HidbusBusHandle
    workbuf*: pointer
    workbufSize*: csize_t
    pollingLastSamplingNumber*: U64
    errorFlags*: U32
    idL*: U64
    idH*: U64
    fwVer*: RingConFwVersion
    flag*: U32
    unkCal*: S16
    totalPushCount*: S32
    manuCal*: RingConManuCal
    userCal*: RingConUserCal

proc ringconCreate*(c: ptr RingCon; id: HidNpadIdType): Result {.cdecl,
    importc: "ringconCreate".}
## *
##  @brief Creates a \ref RingCon object, and handles the various initialization for it.
##  @param c \ref RingCon
##  @param[in] id \ref HidNpadIdType. A Ring-Con must be attached to this controller.
##

proc ringconClose*(c: ptr RingCon) {.cdecl, importc: "ringconClose".}
## *
##  @brief Close a \ref RingCon.
##  @param c \ref RingCon
##

proc ringconGetErrorFlags*(c: ptr RingCon): U32 {.inline, cdecl.} =
  ## *
  ##  @brief Gets the error flags field.
  ##  @param c \ref RingCon
  ##

  return c.errorFlags

proc ringconGetErrorFlag*(c: ptr RingCon; flag: RingConErrorFlag): bool {.inline, cdecl.} =
  ## *
  ##  @brief Gets the value of an error flag, set by \ref ringconSetErrorFlag.
  ##  @param c \ref RingCon
  ##  @param[in] flag \ref RingConErrorFlag
  ##

  return (c.errorFlags and bit(flag)) != 0

proc ringconGetFwVersion*(c: ptr RingCon): RingConFwVersion {.inline, cdecl.} =
  ## *
  ##  @brief Gets the \ref RingConFwVersion previously loaded by \ref ringconCreate.
  ##  @param c \ref RingCon
  ##  @param[out] out \ref RingConFwVersion
  ##

  return c.fwVer

proc ringconGetId*(c: ptr RingCon; idL: ptr U64; idH: ptr U64) {.inline, cdecl.} =
  ## *
  ##  @brief Gets the Id previously loaded by \ref ringconCreate.
  ##  @param c \ref RingCon
  ##  @param[out] id_l Id low.
  ##  @param[out] id_h Id high.
  ##

  idL[] = c.idL
  idH[] = c.idH

proc ringconGetUnkCal*(c: ptr RingCon): S16 {.inline, cdecl.} =
  ## *
  ##  @brief Gets the unk_cal previously loaded by \ref ringconCreate with \ref ringconReadUnkCal. Only valid when the output flag from \ref ringconCmdx00020105 is valid.
  ##  @param c \ref RingCon
  ##

  return c.unkCal

proc ringconGetTotalPushCount*(c: ptr RingCon): S32 {.inline, cdecl.} =
  ## *
  ##  @brief Gets the total-push-count previously loaded by \ref ringconCreate.
  ##  @param c \ref RingCon
  ##  @param[out] out total_push_count
  ##

  return c.totalPushCount

proc ringconGetManuCal*(c: ptr RingCon; `out`: ptr RingConManuCal) {.inline, cdecl.} =
  ## *
  ##  @brief Gets the \ref RingConManuCal previously loaded by \ref ringconCreate.
  ##  @param c \ref RingCon
  ##  @param[out] out \ref RingConManuCal
  ##

  `out`[] = c.manuCal

proc ringconGetUserCal*(c: ptr RingCon; `out`: ptr RingConUserCal) {.inline, cdecl.} =
  ## *
  ##  @brief Gets the \ref RingConUserCal previously loaded by \ref ringconCreate.
  ##  @note The Ring-Con UserCal doesn't seem to be calibrated normally?
  ##  @param c \ref RingCon
  ##  @param[out] out \ref RingConUserCal
  ##

  `out`[] = c.userCal

proc ringconUpdateUserCal*(c: ptr RingCon; cal: RingConUserCal): Result {.cdecl,
    importc: "ringconUpdateUserCal".}
## *
##  @brief Updates the \ref RingConUserCal.
##  @note The input \ref RingConUserCal is used with \ref ringconWriteUserCal, and the output from \ref ringconReadUserCal is verified with the input \ref RingConUserCal. This does not update the \ref RingConUserCal returned by \ref ringconGetUserCal.
##  @note The Ring-Con UserCal doesn't seem to be calibrated normally?
##  @param c \ref RingCon
##  @param[in] cal \ref RingConUserCal
##

proc ringconReadFwVersion*(c: ptr RingCon; `out`: ptr RingConFwVersion): Result {.cdecl,
    importc: "ringconReadFwVersion".}
## *
##  @brief Reads the \ref RingConFwVersion.
##  @note This is used internally by \ref ringconCreate. Normally you should use \ref ringconGetFwVersion instead.
##  @param c \ref RingCon
##  @param[out] out \ref RingConFwVersion
##

proc ringconReadId*(c: ptr RingCon; idL: ptr U64; idH: ptr U64): Result {.cdecl,
    importc: "ringconReadId".}
## *
##  @brief Reads the Id.
##  @note This is used internally by \ref ringconCreate. Normally you should use \ref ringconGetId instead.
##  @param c \ref RingCon
##  @param[out] id_l Id low.
##  @param[out] id_h Id high.
##

proc ringconGetPollingData*(c: ptr RingCon; `out`: ptr RingConPollingData; count: S32;
                           totalOut: ptr S32): Result {.cdecl,
    importc: "ringconGetPollingData".}
## *
##  @brief Gets the \ref RingConPollingData. Only returns entries which are new since the last time this was called (or if not previously called, all available entries up to count).
##  @param c \ref RingCon
##  @param[out] out Output array of \ref RingConPollingData. Entry order is newest -> oldest.
##  @param[in] count Total size of the out array in entries, max value is 0x9.
##  @param[out] total_out Total output entries.
##

proc ringconCmdx00020105*(c: ptr RingCon; `out`: ptr U32): Result {.cdecl,
    importc: "ringconCmdx00020105".}
## *
##  @brief Uses cmd 0x00020105.
##  @note Used internally by \ref ringconCreate.
##  @param c \ref RingCon
##  @param[out] out Output value.
##

proc ringconReadManuCal*(c: ptr RingCon; `out`: ptr RingConManuCal): Result {.cdecl,
    importc: "ringconReadManuCal".}
## *
##  @brief Reads the \ref RingConManuCal.
##  @note Used internally by \ref ringconCreate and \ref ringconReadUnkCal.
##  @param c \ref RingCon
##  @param[out] out \ref RingConManuCal
##

proc ringconReadUnkCal*(c: ptr RingCon; `out`: ptr S16): Result {.cdecl,
    importc: "ringconReadUnkCal".}
## *
##  @brief Gets the unknown value derived from the output of cmd 0x00020504 and \ref ringconReadManuCal.
##  @note Used internally by \ref ringconCreate.
##  @param c \ref RingCon
##  @param[out] out Output value.
##

proc ringconReadUserCal*(c: ptr RingCon; `out`: ptr RingConUserCal): Result {.cdecl,
    importc: "ringconReadUserCal".}
## *
##  @brief Reads the \ref RingConUserCal.
##  @note Used internally by \ref ringconCreate and \ref ringconUpdateUserCal.
##  @param c \ref RingCon
##  @param[out] out \ref RingConUserCal
##

proc ringconReadRepCount*(c: ptr RingCon; `out`: ptr S32;
                         dataValid: ptr RingConDataValid): Result {.cdecl,
    importc: "ringconReadRepCount".}
## *
##  @brief Reads the rep-count for Multitask Mode.
##  @param c \ref RingCon
##  @param[out] out Output value. Official sw using this clamps the output to range 0-500.
##  @param[out] data_valid \ref RingConDataValid
##

proc ringconReadTotalPushCount*(c: ptr RingCon; `out`: ptr S32;
                               dataValid: ptr RingConDataValid): Result {.cdecl,
    importc: "ringconReadTotalPushCount".}
## *
##  @brief Reads the total-push-count, for Multitask Mode.
##  @note Used internally by \ref ringconCreate. Normally \ref ringconGetTotalPushCount should be used instead.
##  @param c \ref RingCon
##  @param[out] out Output value.
##  @param[out] data_valid \ref RingConDataValid
##

proc ringconResetRepCount*(c: ptr RingCon): Result {.cdecl,
    importc: "ringconResetRepCount".}
## *
##  @brief This resets the value returned by \ref ringconReadRepCount to 0.
##  @param c \ref RingCon
##

proc ringconWriteUserCal*(c: ptr RingCon; cal: RingConUserCal): Result {.cdecl,
    importc: "ringconWriteUserCal".}
## *
##  @brief Writes the \ref RingConUserCal.
##  @note Used internally by \ref ringconUpdateUserCal.
##  @param c \ref RingCon
##  @param[in] cal \ref RingConUserCal
##

