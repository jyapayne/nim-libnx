## *
##  @file btdrv_types.h
##  @brief Bluetooth driver (btdrv) service types (see btdrv.h for the rest).
##  @author yellows8, ndeadly
##  @copyright libnx Authors
##

import
  ../types

## / BluetoothPropertyType [1.0.0-11.0.1]

type
  BtdrvBluetoothPropertyType* = enum
    BtdrvBluetoothPropertyTypeName = 1, ## /< Name. String, max length 0xF8 excluding NUL-terminator.
    BtdrvBluetoothPropertyTypeAddress = 2, ## /< \ref BtdrvAddress
    BtdrvBluetoothPropertyTypeUnknown3 = 3, ## /< Only available with \ref btdrvSetAdapterProperty. Unknown, \ref BtdrvAddress.
    BtdrvBluetoothPropertyTypeClassOfDevice = 5, ## /< 3-bytes, Class of Device.
    BtdrvBluetoothPropertyTypeFeatureSet = 6 ## /< 1-byte, FeatureSet. The default is value 0x68.


## / AdapterPropertyType [12.0.0+]

type
  BtdrvAdapterPropertyType* = enum
    BtdrvAdapterPropertyTypeAddress = 0, ## /< \ref BtdrvAddress
    BtdrvAdapterPropertyTypeName = 1, ## /< Name. String, max length 0xF8 excluding NUL-terminator.
    BtdrvAdapterPropertyTypeClassOfDevice = 2, ## /< 3-bytes, Class of Device.
    BtdrvAdapterPropertyTypeUnknown3 = 3 ## /< Only available with \ref btdrvSetAdapterProperty. Unknown, \ref BtdrvAddress.


## / EventType

type                          ## /< BtdrvEventType_* should be used on [12.0.0+]
  BtdrvEventType* = enum
    BtdrvEventTypeInquiryDevice = 0, ## /< Device found during Inquiry.
    BtdrvEventTypeInquiryStatus = 1, ## /< Inquiry status changed.
    BtdrvEventTypePairingPinCodeRequest = 2, ## /< Pairing PIN code request.
    BtdrvEventTypeSspRequest = 3, ## /< SSP confirm request / SSP passkey notification.
    BtdrvEventTypeConnection = 4, ## /< Connection
    BtdrvEventTypeTsi = 5,      ## /< SetTsi (\ref btdrvSetTsi)
    BtdrvEventTypeBurstMode = 6, ## /< SetBurstMode (\ref btdrvEnableBurstMode)
    BtdrvEventTypeSetZeroRetransmission = 7, ## /< \ref btdrvSetZeroRetransmission
    BtdrvEventTypePendingConnections = 8, ## /< \ref btdrvGetPendingConnections
    BtdrvEventTypeMoveToSecondaryPiconet = 9, ## /< \ref btdrvMoveToSecondaryPiconet
    BtdrvEventTypeBluetoothCrash = 10, ## /< BluetoothCrash
                                    ## /< BtdrvEventTypeOld_* should be used on [1.0.0-11.0.1]
    BtdrvEventTypeOldBluetoothCrash = 13 ## /< BluetoothCrash

const
  BtdrvEventTypeOldUnknown0* = BtdrvEventTypeInquiryDevice
  BtdrvEventTypeOldInquiryDevice* = BtdrvEventTypeSspRequest
  BtdrvEventTypeOldInquiryStatus* = BtdrvEventTypeConnection
  BtdrvEventTypeOldPairingPinCodeRequest* = BtdrvEventTypeTsi
  BtdrvEventTypeOldSspRequest* = BtdrvEventTypeBurstMode
  BtdrvEventTypeOldConnection* = BtdrvEventTypeSetZeroRetransmission

## / BtdrvInquiryStatus

type
  BtdrvInquiryStatus* = enum
    BtdrvInquiryStatusStopped = 0, ## /< Inquiry stopped.
    BtdrvInquiryStatusStarted = 1 ## /< Inquiry started.


## / ConnectionEventType

type
  BtdrvConnectionEventType* = enum
    BtdrvConnectionEventTypeStatus = 0, ## /< BtdrvEventInfo::connection::status
    BtdrvConnectionEventTypeSspConfirmRequest = 1, ## /< SSP confirm request.
    BtdrvConnectionEventTypeSuspended = 2 ## /< ACL Link is now Suspended.


## / ExtEventType [1.0.0-11.0.1]

type
  BtdrvExtEventType* = enum
    BtdrvExtEventTypeSetTsi = 0, ## /< SetTsi (\ref btdrvSetTsi)
    BtdrvExtEventTypeExitTsi = 1, ## /< ExitTsi (\ref btdrvSetTsi)
    BtdrvExtEventTypeSetBurstMode = 2, ## /< SetBurstMode (\ref btdrvEnableBurstMode)
    BtdrvExtEventTypeExitBurstMode = 3, ## /< ExitBurstMode (\ref btdrvEnableBurstMode)
    BtdrvExtEventTypeSetZeroRetransmission = 4, ## /< \ref btdrvSetZeroRetransmission
    BtdrvExtEventTypePendingConnections = 5, ## /< \ref btdrvGetPendingConnections
    BtdrvExtEventTypeMoveToSecondaryPiconet = 6 ## /< \ref btdrvMoveToSecondaryPiconet


## / BluetoothHhReportType
## / Bit0-1 directly control the HID bluetooth transaction report-type value.
## / Bit2-3: these directly control the Parameter Reserved field for SetReport, for GetReport these control the Parameter Reserved and Size bits.

type
  BtdrvBluetoothHhReportType* = enum
    BtdrvBluetoothHhReportTypeOther = 0, ## /< Other
    BtdrvBluetoothHhReportTypeInput = 1, ## /< Input
    BtdrvBluetoothHhReportTypeOutput = 2, ## /< Output
    BtdrvBluetoothHhReportTypeFeature = 3 ## /< Feature


## / HidEventType

type                          ## /< BtdrvHidEventType_* should be used on [12.0.0+]
  BtdrvHidEventType* = enum
    BtdrvHidEventTypeConnection = 0, ## /< Connection. Only used with \ref btdrvGetHidEventInfo.
    BtdrvHidEventTypeData = 1,  ## /< DATA report on the Interrupt channel.
    BtdrvHidEventTypeSetReport = 2, ## /< Response to SET_REPORT.
    BtdrvHidEventTypeGetReport = 3, ## /< Response to GET_REPORT.
                                 ## /< BtdrvHidEventTypeOld_* should be used on [1.0.0-11.0.1]
    BtdrvHidEventTypeOldData = 4, ## /< DATA report on the Interrupt channel.
    BtdrvHidEventTypeOldExt = 7, ## /< Response for extensions. Only used with \ref btdrvGetHidEventInfo.
    BtdrvHidEventTypeOldSetReport = 8, ## /< Response to SET_REPORT.
    BtdrvHidEventTypeOldGetReport = 9 ## /< Response to GET_REPORT.

const
  BtdrvHidEventTypeOldConnection* = BtdrvHidEventTypeConnection

## / HidConnectionStatus [12.0.0+]

type                          ## /< BtdrvHidConnectionStatus_* should be used on [12.0.0+]
  BtdrvHidConnectionStatus* = enum
    BtdrvHidConnectionStatusClosed = 0, BtdrvHidConnectionStatusOpened = 1, BtdrvHidConnectionStatusFailed = 2, ## /< BtdrvHidConnectionStatusOld_* should be used on [1.0.0-11.0.1]
    BtdrvHidConnectionStatusOldFailed = 8

const
  BtdrvHidConnectionStatusOldOpened* = BtdrvHidConnectionStatusClosed
  BtdrvHidConnectionStatusOldClosed* = BtdrvHidConnectionStatusFailed

## / This determines the u16 data to write into a CircularBuffer.

type
  BtdrvFatalReason* = enum
    BtdrvFatalReasonInvalid = 0, ## /< Only for \ref BtdrvEventInfo: invalid.
    BtdrvFatalReasonUnknown1 = 1, ## /< Can only be triggered by \ref btdrvEmulateBluetoothCrash, not triggered by the sysmodule otherwise.
    BtdrvFatalReasonCommandTimeout = 2, ## /< HCI command timeout.
    BtdrvFatalReasonHardwareError = 3, ## /< HCI event HCI_Hardware_Error occurred.
    BtdrvFatalReasonEnable = 7, ## /< Only for \ref BtdrvEventInfo: triggered after enabling bluetooth, depending on the value of a global state field.
    BtdrvFatalReasonAudio = 9   ## /< [12.0.0+] Only for \ref BtdrvEventInfo: triggered by Audio cmds in some cases.


## / BleEventType

type
  BtdrvBleEventType* = enum
    BtdrvBleEventTypeUnknown0 = 0, ## /< Unknown.
    BtdrvBleEventTypeUnknown1 = 1, ## /< Unknown.
    BtdrvBleEventTypeUnknown2 = 2, ## /< Unknown.
    BtdrvBleEventTypeUnknown3 = 3, ## /< Unknown.
    BtdrvBleEventTypeUnknown4 = 4, ## /< Unknown.
    BtdrvBleEventTypeUnknown5 = 5, ## /< Unknown.
    BtdrvBleEventTypeUnknown6 = 6, ## /< Unknown.
    BtdrvBleEventTypeUnknown7 = 7, ## /< Unknown.
    BtdrvBleEventTypeUnknown8 = 8, ## /< Unknown.
    BtdrvBleEventTypeUnknown9 = 9, ## /< Unknown.
    BtdrvBleEventTypeUnknown10 = 10, ## /< Unknown.
    BtdrvBleEventTypeUnknown11 = 11, ## /< Unknown.
    BtdrvBleEventTypeUnknown12 = 12, ## /< Unknown.
    BtdrvBleEventTypeUnknown13 = 13 ## /< Unknown.


## / AudioEventType

type
  BtdrvAudioEventType* = enum
    BtdrvAudioEventTypeNone = 0, ## /< None
    BtdrvAudioEventTypeConnection = 1 ## /< Connection


## / AudioOutState

type
  BtdrvAudioOutState* = enum
    BtdrvAudioOutStateStopped = 0, ## /< Stopped
    BtdrvAudioOutStateStarted = 1 ## /< Started


## / AudioCodec

type
  BtdrvAudioCodec* = enum
    BtdrvAudioCodecPcm = 0      ## /< Raw PCM


## / Address

type
  BtdrvAddress* {.bycopy.} = object
    address*: array[0x6, U8]    ## /< Address


## / ClassOfDevice

type
  BtdrvClassOfDevice* {.bycopy.} = object
    classOfDevice*: array[0x3, U8] ## /< ClassOfDevice


## / AdapterProperty [1.0.0-11.0.1]

type
  BtdrvAdapterPropertyOld* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Same as the data for ::BtdrvBluetoothPropertyType_Address.
    classOfDevice*: BtdrvClassOfDevice ## /< Same as the data for ::BtdrvBluetoothPropertyType_ClassOfDevice.
    name*: array[0xF9, char]    ## /< Same as the data for ::BtdrvBluetoothPropertyType_Name (last byte is not initialized).
    featureSet*: U8            ## /< Set to hard-coded value 0x68 (same as the data for ::BtdrvBluetoothPropertyType_FeatureSet).


## / AdapterProperty [12.0.0+]

type
  BtdrvAdapterProperty* {.bycopy.} = object
    `type`*: U8                ## /< \ref BtdrvAdapterPropertyType
    size*: U8                  ## /< Data size.
    data*: array[0x100, U8]     ## /< Data (above size), as specified by the type.


## / AdapterPropertySet [12.0.0+]

type
  BtdrvAdapterPropertySet* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Same as the data for ::BtdrvBluetoothPropertyType_Address.
    classOfDevice*: BtdrvClassOfDevice ## /< Same as the data for ::BtdrvBluetoothPropertyType_ClassOfDevice.
    name*: array[0xF9, char]    ## /< Same as the data for ::BtdrvBluetoothPropertyType_Name.


## / BluetoothPinCode [1.0.0-11.0.1]

type
  BtdrvBluetoothPinCode* {.bycopy.} = object
    code*: array[0x10, char]    ## /< PinCode


## / BtdrvPinCode [12.0.0+]

type
  BtdrvPinCode* {.bycopy.} = object
    code*: array[0x10, char]    ## /< PinCode
    length*: U8                ## /< Length


## / HidData [1.0.0-8.1.1]

type
  BtdrvHidData* {.bycopy.} = object
    size*: U16                 ## /< Size of data.
    data*: array[0x280, U8]     ## /< Data


## / HidReport [9.0.0+].

type
  BtdrvHidReport* {.bycopy.} = object
    size*: U16                 ## /< Size of data.
    data*: array[0x2BC, U8]     ## /< Data


## / PlrStatistics

type
  BtdrvPlrStatistics* {.bycopy.} = object
    unkX0*: array[0x84, U8]     ## /< Unknown


## / PlrList

type
  BtdrvPlrList* {.bycopy.} = object
    unkX0*: array[0xA4, U8]     ## /< Unknown


## / ChannelMapList

type
  BtdrvChannelMapList* {.bycopy.} = object
    unkX0*: array[0x88, U8]     ## /< Unknown


## / LeConnectionParams

type
  BtdrvLeConnectionParams* {.bycopy.} = object
    unkX0*: array[0x14, U8]     ## /< Unknown


## / BleConnectionParameter

type
  BtdrvBleConnectionParameter* {.bycopy.} = object
    unkX0*: array[0xC, U8]      ## /< Unknown


## / BtdrvBleAdvertisePacketDataEntry

type
  BtdrvBleAdvertisePacketDataEntry* {.bycopy.} = object
    unkX0*: U16                ## /< Unknown
    unused*: array[0x12, U8]    ## /< Unused


## / BleAdvertisePacketData

type
  BtdrvBleAdvertisePacketData* {.bycopy.} = object
    unkX0*: U32                ## /< Unknown
    unkX4*: U8                 ## /< Unknown
    size0*: U8                 ## /< Size of the data at unk_x6.
    unkX6*: array[0x1F, U8]     ## /< Unknown, see size0.
    pad*: array[3, U8]          ## /< Padding
    count*: U8                 ## /< Total array entries, see entries.
    pad2*: array[7, U8]         ## /< Padding
    entries*: array[0x5, BtdrvBleAdvertisePacketDataEntry] ## /< \ref BtdrvBleAdvertisePacketDataEntry
    pad3*: array[0x10, U8]      ## /< Padding
    size2*: U8                 ## /< Size of the data at unk_xA8.
    unkXA5*: U8                ## /< Unknown
    pad4*: array[2, U8]         ## /< Padding
    unkXA8*: array[0x1F, U8]    ## /< Unknown, see size2.
    unkXC7*: U8                ## /< Unknown
    unkXC8*: U8                ## /< Unknown
    pad5*: array[3, U8]         ## /< Padding

  BtdrvBleAdvertisementData* {.bycopy.} = object
    length*: U8
    `type`*: U8
    value*: array[0x1d, U8]


## / BleAdvertiseFilter

type
  BtdrvBleAdvertiseFilter* {.bycopy.} = object
    unkX0*: array[0x3E, U8]     ## /< Unknown


## / BleAdvertisePacketParameter

type
  BtdrvBleAdvertisePacketParameter* {.bycopy.} = object
    data*: array[0x8, U8]       ## /< Unknown


## / BleScanResult

type
  BtdrvBleScanResult* {.bycopy.} = object
    unkX0*: U8                 ## /< Unknown
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    unkX7*: array[0x139, U8]    ## /< Unknown
    unkX140*: S32              ## /< Unknown
    unkX144*: S32              ## /< Unknown


## / BleConnectionInfo

type
  BtdrvBleConnectionInfo* {.bycopy.} = object
    connectionHandle*: U32     ## /< ConnectionHandle, 0xFFFFFFFF ([5.0.0-5.0.2] 0xFFFF) is invalid.
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    pad*: array[2, U8]          ## /< Padding


## / GattAttributeUuid

type
  BtdrvGattAttributeUuid* {.bycopy.} = object
    size*: U32                 ## /< UUID size, must be 0x2, 0x4, or 0x10.
    uuid*: array[0x10, U8]      ## /< UUID with the above size.


## / GattId

type
  BtdrvGattId* {.bycopy.} = object
    instanceId*: U8            ## /< InstanceId
    pad*: array[3, U8]          ## /< Padding
    uuid*: BtdrvGattAttributeUuid ## /< \ref BtdrvGattAttributeUuid


## / LeEventInfo

type
  BtdrvLeEventInfo* {.bycopy.} = object
    unkX0*: U32                ## /< Unknown
    unkX4*: U32                ## /< Unknown
    unkX8*: U8                 ## /< Unknown
    pad*: array[3, U8]          ## /< Padding
    uuid0*: BtdrvGattAttributeUuid ## /< \ref BtdrvGattAttributeUuid
    uuid1*: BtdrvGattAttributeUuid ## /< \ref BtdrvGattAttributeUuid
    uuid2*: BtdrvGattAttributeUuid ## /< \ref BtdrvGattAttributeUuid
    size*: U16                 ## /< Size of the below data.
    data*: array[0x3B6, U8]     ## /< Data.


## / BleClientGattOperationInfo

type
  BtdrvBleClientGattOperationInfo* {.bycopy.} = object
    unkX0*: U8                 ## /< Converted from BtdrvLeEventInfo::unk_x0.
    pad*: array[3, U8]          ## /< Padding
    unkX4*: U32                ## /< BtdrvLeEventInfo::unk_x4
    unkX8*: U8                 ## /< BtdrvLeEventInfo::unk_x8
    pad2*: array[3, U8]         ## /< Padding
    uuid0*: BtdrvGattAttributeUuid ## /< BtdrvLeEventInfo::uuid0
    uuid1*: BtdrvGattAttributeUuid ## /< BtdrvLeEventInfo::uuid1
    uuid2*: BtdrvGattAttributeUuid ## /< BtdrvLeEventInfo::uuid2
    size*: U64                 ## /< BtdrvLeEventInfo::size
    data*: array[0x200, U8]     ## /< BtdrvLeEventInfo::data


## / PcmParameter

type
  BtdrvPcmParameter* {.bycopy.} = object
    unkX0*: U32                ## /< Must be 0-3. Controls number of channels: 0 = mono, non-zero = stereo.
    sampleRate*: S32           ## /< Sample rate. Must be one of the following: 16000, 32000, 44100, 48000.
    bitsPerSample*: U32        ## /< Bits per sample. Must be 8 or 16.


## / AudioControlButtonState

type
  BtdrvAudioControlButtonState* {.bycopy.} = object
    unkX0*: array[0x10, U8]     ## /< Unknown

