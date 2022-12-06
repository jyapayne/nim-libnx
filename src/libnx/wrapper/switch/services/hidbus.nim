## *
##  @file hidbus.h
##  @brief hidbus service IPC wrapper, for using external devices attached to HID controllers. See also: https://switchbrew.org/wiki/HID_services#hidbus
##  @note Only available on [5.0.0+].
##  @author yellows8
##

import
  ../types, ../services/hid, ../sf/service

## / BusType

type
  HidbusBusType* = enum
    HidbusBusTypeLeftJoyRail = 0, ## /< LeftJoyRail
    HidbusBusTypeRightJoyRail = 1, ## /< RightJoyRail
    HidbusBusTypeRightLarkRail = 2 ## /< [6.0.0+] RightLarkRail (for microphone).


## / JoyPollingMode

type
  HidbusJoyPollingMode* = enum
    HidbusJoyPollingModeSixAxisSensorDisable = 0, ## /< SixAxisSensorDisable
    HidbusJoyPollingModeSixAxisSensorEnable = 1, ## /< JoyEnableSixAxisPollingData
    HidbusJoyPollingModeButtonOnly = 2 ## /< [6.0.0+] ButtonOnly


## / BusHandle

type
  HidbusBusHandle* {.bycopy.} = object
    abstractedPadId*: U32      ## /< AbstractedPadId
    internalIndex*: U8         ## /< InternalIndex
    playerNumber*: U8          ## /< PlayerNumber
    busTypeId*: U8             ## /< BusTypeId
    isValid*: U8               ## /< IsValid


## / JoyPollingReceivedData

type
  HidbusJoyPollingReceivedData* {.bycopy.} = object
    data*: array[0x30, U8]      ## /< Data.
    outSize*: U64              ## /< Size of data.
    samplingNumber*: U64       ## /< SamplingNumber


## / HidbusDataAccessorHeader

type
  HidbusDataAccessorHeader* {.bycopy.} = object
    res*: Result               ## /< Result.
    pad*: U32                  ## /< Padding.
    unused*: array[0x18, U8]    ## /< Initialized sysmodule-side, not used by sdknso.
    latestEntry*: U64          ## /< Latest entry.
    totalEntries*: U64         ## /< Total entries.


## / HidbusJoyDisableSixAxisPollingDataAccessorEntryData

type
  HidbusJoyDisableSixAxisPollingDataAccessorEntryData* {.bycopy.} = object
    data*: array[0x26, U8]      ## /< Data.
    outSize*: U8               ## /< Size of data.
    pad*: U8                   ## /< Padding.
    samplingNumber*: U64       ## /< SamplingNumber


## / HidbusJoyDisableSixAxisPollingDataAccessorEntry

type
  HidbusJoyDisableSixAxisPollingDataAccessorEntry* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    data*: HidbusJoyDisableSixAxisPollingDataAccessorEntryData ## /< \ref HidbusJoyDisableSixAxisPollingDataAccessorEntryData


## / HidbusJoyEnableSixAxisPollingDataAccessorEntryData

type
  HidbusJoyEnableSixAxisPollingDataAccessorEntryData* {.bycopy.} = object
    data*: array[0x8, U8]       ## /< Data.
    outSize*: U8               ## /< Size of data.
    pad*: array[7, U8]          ## /< Padding.
    samplingNumber*: U64       ## /< SamplingNumber


## / HidbusJoyEnableSixAxisPollingDataAccessorEntry

type
  HidbusJoyEnableSixAxisPollingDataAccessorEntry* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    data*: HidbusJoyEnableSixAxisPollingDataAccessorEntryData ## /< \ref HidbusJoyEnableSixAxisPollingDataAccessorEntryData


## / HidbusJoyButtonOnlyPollingDataAccessorEntryData

type
  HidbusJoyButtonOnlyPollingDataAccessorEntryData* {.bycopy.} = object
    data*: array[0x2c, U8]      ## /< Data.
    outSize*: U8               ## /< Size of data.
    pad*: array[3, U8]          ## /< Padding.
    samplingNumber*: U64       ## /< SamplingNumber


## / HidbusJoyButtonOnlyPollingDataAccessorEntry

type
  HidbusJoyButtonOnlyPollingDataAccessorEntry* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    data*: HidbusJoyButtonOnlyPollingDataAccessorEntryData ## /< \ref HidbusJoyEnableSixAxisPollingDataAccessorEntryData


## / HidbusJoyDisableSixAxisPollingDataAccessor

type
  HidbusJoyDisableSixAxisPollingDataAccessor* {.bycopy.} = object
    hdr*: HidbusDataAccessorHeader ## /< \ref HidbusDataAccessorHeader
    entries*: array[0xb, HidbusJoyDisableSixAxisPollingDataAccessorEntry] ## /< \ref HidbusJoyDisableSixAxisPollingDataAccessorEntry


## / HidbusJoyEnableSixAxisPollingDataAccessor

type
  HidbusJoyEnableSixAxisPollingDataAccessor* {.bycopy.} = object
    hdr*: HidbusDataAccessorHeader ## /< \ref HidbusDataAccessorHeader
    entries*: array[0xb, HidbusJoyEnableSixAxisPollingDataAccessorEntry] ## /< \ref HidbusJoyEnableSixAxisPollingDataAccessorEntry


## / HidbusJoyButtonOnlyPollingDataAccessor

type
  HidbusJoyButtonOnlyPollingDataAccessor* {.bycopy.} = object
    hdr*: HidbusDataAccessorHeader ## /< \ref HidbusDataAccessorHeader
    entries*: array[0xb, HidbusJoyButtonOnlyPollingDataAccessorEntry] ## /< \ref HidbusJoyButtonOnlyPollingDataAccessorEntry


## / Common data for HidbusStatusManagerEntry*.

type
  HidbusStatusManagerEntryCommon* {.bycopy.} = object
    isConnected*: U8           ## /< IsConnected
    pad*: array[3, U8]          ## /< Padding.
    isConnectedResult*: Result ## /< IsConnectedResult
    isEnabled*: U8             ## /< Flag indicating whether a device is enabled (\ref hidbusEnableExternalDevice).
    isInFocus*: U8             ## /< Flag indicating whether this entry is valid.
    isPollingMode*: U8         ## /< Flag indicating whether polling is enabled (\ref hidbusEnableJoyPollingReceiveMode).
    reserved*: U8              ## /< Reserved
    pollingMode*: U32          ## /< \ref HidbusJoyPollingMode


## / HidbusStatusManagerEntry on 5.x.

type
  HidbusStatusManagerEntryV5* {.bycopy.} = object
    common*: HidbusStatusManagerEntryCommon ## /< \ref HidbusStatusManagerEntryCommon
    unkX10*: array[0xf0, U8]    ## /< Ignored by official sw.


## / HidbusStatusManagerEntry

type
  HidbusStatusManagerEntry* {.bycopy.} = object
    common*: HidbusStatusManagerEntryCommon ## /< \ref HidbusStatusManagerEntryCommon
    unkX10*: array[0x70, U8]    ## /< Ignored by official sw.


## / StatusManager on 5.x.

type
  HidbusStatusManagerV5* {.bycopy.} = object
    entries*: array[0x10, HidbusStatusManagerEntryV5] ## /< \ref HidbusStatusManagerEntryV5


## / StatusManager

type
  HidbusStatusManager* {.bycopy.} = object
    entries*: array[0x13, HidbusStatusManagerEntry] ## /< \ref HidbusStatusManagerEntry
    unused*: array[0x680, U8]   ## /< Unused.


## / Gets the Service object for the actual hidbus service session. This object must be closed by the user once finished using cmds with this.

proc hidbusGetServiceSession*(srvOut: ptr Service): Result {.cdecl,
    importc: "hidbusGetServiceSession".}
## / Gets the SharedMemory addr (\ref HidbusStatusManagerV5 on 5.x, otherwise \ref HidbusStatusManager). Only valid when at least one BusHandle is currently initialized (\ref hidbusInitialize).

proc hidbusGetSharedmemAddr*(): pointer {.cdecl, importc: "hidbusGetSharedmemAddr".}
## *
##  @brief GetBusHandle
##  @param[out] handle \ref HidbusBusHandle
##  @param[out] flag Output flag indicating whether the handle is valid.
##  @param[in] id \ref HidNpadIdType
##  @param[in] bus_type \ref HidbusBusType
##

proc hidbusGetBusHandle*(handle: ptr HidbusBusHandle; flag: ptr bool;
                        id: HidNpadIdType; busType: HidbusBusType): Result {.cdecl,
    importc: "hidbusGetBusHandle".}
## *
##  @brief Initialize
##  @param[in] handle \ref HidbusBusHandle
##

proc hidbusInitialize*(handle: HidbusBusHandle): Result {.cdecl,
    importc: "hidbusInitialize".}
## *
##  @brief Finalize
##  @param[in] handle \ref HidbusBusHandle
##

proc hidbusFinalize*(handle: HidbusBusHandle): Result {.cdecl,
    importc: "hidbusFinalize".}
## *
##  @brief EnableExternalDevice
##  @note This uses \ref hidLaShowControllerFirmwareUpdate if needed.
##  @param[in] handle \ref HidbusBusHandle
##  @param[in] flag Whether to enable the device (true = enable, false = disable). When false, this will internally use \ref hidbusDisableJoyPollingReceiveMode if needed.
##  @param[in] device_id ExternalDeviceId which must match the connected device. Only used when flag is set.
##

proc hidbusEnableExternalDevice*(handle: HidbusBusHandle; flag: bool; deviceId: U32): Result {.
    cdecl, importc: "hidbusEnableExternalDevice".}
## *
##  @brief SendAndReceive
##  @param[in] handle \ref HidbusBusHandle
##  @param[in] inbuf Input buffer, containing the command data.
##  @param[in] inbuf_size Input buffer size, must be <0x26.
##  @param[out] outbuf Output buffer, containing the command reply data.
##  @param[in] outbuf_size Output buffer max size.
##  @param[out] out_size Actual output size.
##

proc hidbusSendAndReceive*(handle: HidbusBusHandle; inbuf: pointer;
                          inbufSize: csize_t; outbuf: pointer; outbufSize: csize_t;
                          outSize: ptr U64): Result {.cdecl,
    importc: "hidbusSendAndReceive".}
## *
##  @brief EnableJoyPollingReceiveMode
##  @param[in] handle \ref HidbusBusHandle
##  @param[in] inbuf Input buffer, containing the command data.
##  @param[in] inbuf_size Input buffer size, must be <0x26.
##  @param[out] workbuf TransferMemory buffer, must be 0x1000-byte aligned. This buffer must not be written to until after \ref hidbusDisableJoyPollingReceiveMode is used.
##  @param[in] workbuf_size TransferMemory buffer size, must be 0x1000-byte aligned.
##  @param[in] polling_mode \ref HidbusJoyPollingMode
##

proc hidbusEnableJoyPollingReceiveMode*(handle: HidbusBusHandle; inbuf: pointer;
                                       inbufSize: csize_t; workbuf: pointer;
                                       workbufSize: csize_t;
                                       pollingMode: HidbusJoyPollingMode): Result {.
    cdecl, importc: "hidbusEnableJoyPollingReceiveMode".}
## *
##  @brief DisableJoyPollingReceiveMode
##  @note This can also be used via \ref hidbusEnableExternalDevice with flag=false.
##  @param[in] handle \ref HidbusBusHandle
##

proc hidbusDisableJoyPollingReceiveMode*(handle: HidbusBusHandle): Result {.cdecl,
    importc: "hidbusDisableJoyPollingReceiveMode".}
## *
##  @brief GetJoyPollingReceivedData
##  @param[in] handle \ref HidbusBusHandle
##  @param[out] recv_data Output array of \ref HidbusJoyPollingReceivedData.
##  @param[in] count Total entries for the recv_data array. The maximum is 0xa. Official apps use range 0x1-0x9.
##

proc hidbusGetJoyPollingReceivedData*(handle: HidbusBusHandle; recvData: ptr HidbusJoyPollingReceivedData;
                                     count: S32): Result {.cdecl,
    importc: "hidbusGetJoyPollingReceivedData".}
