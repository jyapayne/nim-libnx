## *
##  @file btm_types.h
##  @brief btm service types.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, btdrv_types

## / BtmState

type
  BtmState* = enum
    BtmStateNotInitialized = 0, ## /< NotInitialized
    BtmStateRadioOff = 1,       ## /< RadioOff
    BtmStateMinorSlept = 2,     ## /< MinorSlept
    BtmStateRadioOffMinorSlept = 3, ## /< RadioOffMinorSlept
    BtmStateSlept = 4,          ## /< Slept
    BtmStateRadioOffSlept = 5,  ## /< RadioOffSlept
    BtmStateInitialized = 6,    ## /< Initialized
    BtmStateWorking = 7         ## /< Working


## / BluetoothMode

type
  BtmBluetoothMode* = enum
    BtmBluetoothModeDynamic2Slot = 0, ## /< Dynamic2Slot
    BtmBluetoothModeStaticJoy = 1 ## /< StaticJoy


## / WlanMode

type
  BtmWlanMode* = enum
    BtmWlanModeLocal4 = 0,      ## /< Local4
    BtmWlanModeLocal8 = 1,      ## /< Local8
    BtmWlanModeNone = 2         ## /< None


## / TsiMode

type
  BtmTsiMode* = enum
    BtmTsiMode0Fd3Td3Si10 = 0,  ## /< 0Fd3Td3Si10
    BtmTsiMode1Fd1Td1Si5 = 1,   ## /< 1Fd1Td1Si5
    BtmTsiMode2Fd1Td3Si10 = 2,  ## /< 2Fd1Td3Si10
    BtmTsiMode3Fd1Td5Si15 = 3,  ## /< 3Fd1Td5Si15
    BtmTsiMode4Fd3Td1Si10 = 4,  ## /< 4Fd3Td1Si10
    BtmTsiMode5Fd3Td3Si15 = 5,  ## /< 5Fd3Td3Si15
    BtmTsiMode6Fd5Td1Si15 = 6,  ## /< 6Fd5Td1Si15
    BtmTsiMode7Fd1Td3Si15 = 7,  ## /< 7Fd1Td3Si15
    BtmTsiMode8Fd3Td1Si15 = 8,  ## /< 8Fd3Td1Si15
    BtmTsiMode9Fd1Td1Si10 = 9,  ## /< 9Fd1Td1Si10
    BtmTsiMode10Fd1Td1Si15 = 10, ## /< 10Fd1Td1Si15
    BtmTsiModeActive = 255      ## /< Active


## / SlotMode

type
  BtmSlotMode* = enum
    BtmSlotMode2 = 0,           ## /< 2
    BtmSlotMode4 = 1,           ## /< 4
    BtmSlotMode6 = 2,           ## /< 6
    BtmSlotModeActive = 3       ## /< Active


## / Profile

type
  BtmProfile* = enum
    BtmProfileNone = 0,         ## /< None
    BtmProfileHid = 1           ## /< Hid


## / BdName

type
  BtmBdName* {.bycopy.} = object
    name*: array[0x20, char]    ## /< Name string.


## / ClassOfDevice

type
  BtmClassOfDevice* {.bycopy.} = object
    classOfDevice*: array[0x3, U8] ## /< ClassOfDevice


## / LinkKey

type
  BtmLinkKey* {.bycopy.} = object
    linkKey*: array[0x10, U8]   ## /< LinkKey


## / HidDeviceInfo

type
  BtmHidDeviceInfo* {.bycopy.} = object
    vid*: U16                  ## /< Vid
    pid*: U16                  ## /< Pid


## / HostDeviceProperty

type
  INNER_C_STRUCT_btm_types_5* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Same as BtdrvAdapterProperty::addr.
    classOfDevice*: BtmClassOfDevice ## /< Same as BtdrvAdapterProperty::class_of_device.
    name*: BtmBdName           ## /< Same as BtdrvAdapterProperty::name (except the last byte which is always zero).
    featureSet*: U8            ## /< Same as BtdrvAdapterProperty::feature_set.

  INNER_C_STRUCT_btm_types_6* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Same as BtdrvAdapterProperty::addr.
    classOfDevice*: BtmClassOfDevice ## /< Same as BtdrvAdapterProperty::class_of_device.
    name*: array[0xF9, char]    ## /< Same as BtdrvAdapterProperty::name (except the last byte which is always zero).
    featureSet*: U8            ## /< Same as BtdrvAdapterProperty::feature_set.

  INNER_C_UNION_btm_types_4* {.bycopy, union.} = object
    v1*: INNER_C_STRUCT_btm_types_5 ## /< [1.0.0-12.1.0]
    v13*: INNER_C_STRUCT_btm_types_6 ## /< [13.0.0+]

  BtmHostDeviceProperty* {.bycopy.} = object
    anoBtmTypes7*: INNER_C_UNION_btm_types_4


## / BtmConnectedDevice [1.0.0-12.1.0]

type
  BtmConnectedDeviceV1* {.bycopy.} = object
    address*: BtdrvAddress
    pad*: array[2, U8]
    unkX8*: U32
    name*: array[0x20, char]
    unkX2C*: array[0x1C, U8]
    vid*: U16
    pid*: U16
    unkX4C*: array[0x20, U8]


## / BtmConnectedDevice [13.0.0+]

type
  BtmConnectedDeviceV13* {.bycopy.} = object
    address*: BtdrvAddress
    pad*: array[2, U8]
    profile*: U32              ## /< \ref BtmProfile
    unkXC*: array[0x40, U8]
    name*: array[0x20, char]
    unkX6C*: array[0xD9, U8]
    pad2*: array[3, U8]


## / DeviceCondition [1.0.0-5.0.2]

type
  BtmDeviceConditionV100* {.bycopy.} = object
    unkX0*: U32
    unkX4*: U32
    unkX8*: U8
    unkX9*: U8
    maxCount*: U8
    connectedCount*: U8
    devices*: array[8, BtmConnectedDeviceV1]


## / DeviceCondition [5.1.0-7.0.1]

type
  BtmDeviceConditionV510* {.bycopy.} = object
    unkX0*: U32
    unkX4*: U32
    unkX8*: U8
    unkX9*: array[2, U8]
    maxCount*: U8
    connectedCount*: U8
    pad*: array[3, U8]
    devices*: array[8, BtmConnectedDeviceV1]


## / DeviceCondition [8.0.0-8.1.1]

type
  BtmDeviceConditionV800* {.bycopy.} = object
    unkX0*: U32
    unkX4*: U32
    unkX8*: U8
    unkX9*: U8
    maxCount*: U8
    connectedCount*: U8
    devices*: array[8, BtmConnectedDeviceV1]


## / DeviceCondition [9.0.0-12.1.0]

type
  BtmDeviceConditionV900* {.bycopy.} = object
    unkX0*: U32
    unkX4*: U8
    unkX5*: U8
    maxCount*: U8
    connectedCount*: U8
    devices*: array[8, BtmConnectedDeviceV1]


## / DeviceCondition [1.0.0-12.1.0]

type
  BtmDeviceCondition* {.bycopy, union.} = object
    v100*: BtmDeviceConditionV100
    v510*: BtmDeviceConditionV510
    v800*: BtmDeviceConditionV800
    v900*: BtmDeviceConditionV900


## / DeviceSlotMode

type
  BtmDeviceSlotMode* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    reserved*: array[2, U8]     ## /< Reserved
    slotMode*: U32             ## /< \ref BtmSlotMode


## / DeviceSlotModeList

type
  BtmDeviceSlotModeList* {.bycopy.} = object
    deviceCount*: U8           ## /< DeviceCount
    reserved*: array[3, U8]     ## /< Reserved
    devices*: array[8, BtmDeviceSlotMode] ## /< Array of \ref BtmDeviceSlotMode with the above count.


## / DeviceInfo [1.0.0-12.1.0]

type
  INNER_C_UNION_btm_types_9* {.bycopy, union.} = object
    data*: array[0x4, U8]       ## /< Empty (Profile = None)
    hidDeviceInfo*: BtmHidDeviceInfo ## /< \ref BtmHidDeviceInfo (Profile = Hid)

  BtmDeviceInfoV1* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    classOfDevice*: BtmClassOfDevice ## /< ClassOfDevice
    name*: BtmBdName           ## /< BdName
    linkKey*: BtmLinkKey       ## /< LinkKey
    reserved*: array[3, U8]     ## /< Reserved
    profile*: U32              ## /< \ref BtmProfile
    profileInfo*: INNER_C_UNION_btm_types_9
    reserved2*: array[0x1C, U8] ## /< Reserved


## / DeviceInfo [13.0.0+]

type
  INNER_C_UNION_btm_types_11* {.bycopy, union.} = object
    data*: array[0x4, U8]       ## /< Empty (Profile = None)
    hidDeviceInfo*: BtmHidDeviceInfo ## /< \ref BtmHidDeviceInfo (Profile = Hid)

  BtmDeviceInfoV13* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    classOfDevice*: BtmClassOfDevice ## /< ClassOfDevice
    linkKey*: BtmLinkKey       ## /< LinkKey
    reserved*: array[3, U8]     ## /< Reserved
    profile*: U32              ## /< \ref BtmProfile
    profileInfo*: INNER_C_UNION_btm_types_11
    reserved2*: array[0x1C, U8] ## /< Reserved
    name*: array[0xF9, char]    ## /< Name
    pad*: array[3, U8]          ## /< Padding


## / DeviceInfo [1.0.0-13.0.0]

type
  BtmDeviceInfo* {.bycopy, union.} = object
    v1*: BtmDeviceInfoV1
    v13*: BtmDeviceInfoV13


## / DeviceInfoList

type
  BtmDeviceInfoList* {.bycopy.} = object
    deviceCount*: U8           ## /< DeviceCount
    reserved*: array[3, U8]     ## /< Reserved
    devices*: array[10, BtmDeviceInfoV1] ## /< Array of \ref BtmDeviceInfoV1 with the above count.


## / DeviceProperty

type
  BtmDeviceProperty* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    classOfDevice*: BtmClassOfDevice ## /< ClassOfDevice
    name*: BtmBdName           ## /< BdName


## / DevicePropertyList

type
  BtmDevicePropertyList* {.bycopy.} = object
    deviceCount*: U8           ## /< DeviceCount
    devices*: array[15, BtmDeviceProperty] ## /< Array of \ref BtmDeviceProperty.


## / ZeroRetransmissionList

type
  BtmZeroRetransmissionList* {.bycopy.} = object
    enabledReportIdCount*: U8  ## /< EnabledReportIdCount
    enabledReportId*: array[0x10, U8] ## /< Array of EnabledReportId.


## / GattClientConditionList

type
  BtmGattClientConditionList* {.bycopy.} = object
    unkX0*: array[0x74, U8]     ## /< Unknown


## / GattService

type
  BtmGattService* {.bycopy.} = object
    unkX0*: array[0x4, U8]      ## /< Unknown
    uuid*: BtdrvGattAttributeUuid ## /< \ref BtdrvGattAttributeUuid
    handle*: U16               ## /< Handle
    unkX1A*: array[0x2, U8]     ## /< Unknown
    instanceId*: U16           ## /< InstanceId
    endGroupHandle*: U16       ## /< EndGroupHandle
    primaryService*: U8        ## /< PrimaryService
    pad*: array[3, U8]          ## /< Padding


## / GattCharacteristic

type
  BtmGattCharacteristic* {.bycopy.} = object
    unkX0*: array[0x4, U8]      ## /< Unknown
    uuid*: BtdrvGattAttributeUuid ## /< \ref BtdrvGattAttributeUuid
    handle*: U16               ## /< Handle
    unkX1A*: array[0x2, U8]     ## /< Unknown
    instanceId*: U16           ## /< InstanceId
    properties*: U8            ## /< Properties
    unkX1F*: array[0x5, U8]     ## /< Unknown


## / GattDescriptor

type
  BtmGattDescriptor* {.bycopy.} = object
    unkX0*: array[0x4, U8]      ## /< Unknown
    uuid*: BtdrvGattAttributeUuid ## /< \ref BtdrvGattAttributeUuid
    handle*: U16               ## /< Handle
    unkX1A*: array[0x6, U8]     ## /< Unknown


## / BleDataPath

type
  BtmBleDataPath* {.bycopy.} = object
    unkX0*: U8                 ## /< Unknown
    pad*: array[3, U8]          ## /< Padding
    uuid*: BtdrvGattAttributeUuid ## /< \ref BtdrvGattAttributeUuid

