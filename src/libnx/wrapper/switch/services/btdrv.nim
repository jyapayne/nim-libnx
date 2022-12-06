## *
##  @file btdrv.h
##  @brief Bluetooth driver (btdrv) service IPC wrapper.
##  @author yellows8, ndeadly
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../services/btdrv_types, ../services/set, ../sf/service, ../kernel/mutex

## / Data for \ref btdrvGetEventInfo. The data stored here depends on the \ref BtdrvEventType.

type
  INNER_C_STRUCT_btdrv_32* {.bycopy.} = object
    val*: U32                  ## /< Value

  INNER_C_STRUCT_btdrv_35* {.bycopy.} = object
    name*: array[0xF9, char]    ## /< Device name, NUL-terminated string.
    `addr`*: BtdrvAddress      ## /< Device address.
    reservedXFF*: array[0x10, U8] ## /< Reserved
    classOfDevice*: BtdrvClassOfDevice ## /< Class of Device.
    unkX112*: array[0x4, U8]    ## /< Set to fixed value u32 0x1.
    reservedX116*: array[0xFA, U8] ## /< Reserved
    reservedX210*: array[0x5C, U8] ## /< Reserved
    name2*: array[0xF9, char]   ## /< Device name, NUL-terminated string. Same as name above, except starting at index 1.
    rssi*: array[0x4, U8]       ## /< s32 RSSI
    name3*: array[0x4, U8]      ## /< Two bytes which are the same as name[11-12].
    reservedX36D*: array[0x10, U8] ## /< Reserved

  INNER_C_STRUCT_btdrv_36* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    name*: array[0xF9, char]    ## /< Device name, NUL-terminated string.
    classOfDevice*: BtdrvClassOfDevice ## /< Class of Device.
    reserved*: array[0x6, U8]   ## /< Reserved

  INNER_C_UNION_btdrv_34* {.bycopy, union.} = object
    v1*: INNER_C_STRUCT_btdrv_35 ## /< [1.0.0-11.0.1]
    v12*: INNER_C_STRUCT_btdrv_36 ## /< [12.0.0+]

  INNER_C_STRUCT_btdrv_33* {.bycopy.} = object
    anoBtdrv37*: INNER_C_UNION_btdrv_34

  INNER_C_STRUCT_btdrv_40* {.bycopy.} = object
    status*: BtdrvInquiryStatus ## /< \ref BtdrvInquiryStatus

  INNER_C_STRUCT_btdrv_41* {.bycopy.} = object
    status*: U8                ## /< \ref BtdrvInquiryStatus
    pad*: array[3, U8]          ## /< Padding
    serviceMask*: U32          ## /< Services value from \ref btdrvStartInquiry when starting, otherwise this is value 0.

  INNER_C_UNION_btdrv_39* {.bycopy, union.} = object
    v1*: INNER_C_STRUCT_btdrv_40 ## /< [1.0.0-11.0.1]
    v12*: INNER_C_STRUCT_btdrv_41 ## /< [12.0.0+]

  INNER_C_STRUCT_btdrv_38* {.bycopy.} = object
    anoBtdrv42*: INNER_C_UNION_btdrv_39

  INNER_C_STRUCT_btdrv_43* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    name*: array[0xF9, char]    ## /< Device name, NUL-terminated string.
    classOfDevice*: BtdrvClassOfDevice ## /< Class of Device.

  INNER_C_STRUCT_btdrv_46* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    name*: array[0xF9, char]    ## /< Device name, NUL-terminated string.
    classOfDevice*: BtdrvClassOfDevice ## /< Class of Device.
    pad*: array[2, U8]          ## /< Padding
    `type`*: U32               ## /< 0 = SSP confirm request, 3 = SSP passkey notification.
    passkey*: S32              ## /< Passkey, only set when the above field is value 3.

  INNER_C_STRUCT_btdrv_47* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    name*: array[0xF9, char]    ## /< Device name, NUL-terminated string.
    classOfDevice*: BtdrvClassOfDevice ## /< Class of Device.
    flag*: U8                  ## /< bool flag for Just Works. With SSP passkey notification this is always 0.
    pad*: U8                   ## /< Padding
    passkey*: S32              ## /< Passkey

  INNER_C_UNION_btdrv_45* {.bycopy, union.} = object
    v1*: INNER_C_STRUCT_btdrv_46 ## /< [1.0.0-11.0.1]
    v12*: INNER_C_STRUCT_btdrv_47 ## /< [12.0.0+]

  INNER_C_STRUCT_btdrv_44* {.bycopy.} = object
    anoBtdrv48*: INNER_C_UNION_btdrv_45

  INNER_C_STRUCT_btdrv_51* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    pad*: array[2, U8]          ## /< Padding
    status*: U32               ## /< Status, always 0 except with ::BtdrvConnectionEventType_Status: 2 = ACL Link is now Resumed, 9 = connection failed (pairing/authentication failed, or opening the hid connection failed).
    `type`*: U32               ## /< \ref BtdrvConnectionEventType

  INNER_C_STRUCT_btdrv_52* {.bycopy.} = object
    status*: U32               ## /< Status, always 0 except with ::BtdrvConnectionEventType_Status: 2 = ACL Link is now Resumed, 9 = connection failed (pairing/authentication failed, or opening the hid connection failed).
    `addr`*: BtdrvAddress      ## /< Device address.
    pad*: array[2, U8]          ## /< Padding
    `type`*: U32               ## /< \ref BtdrvConnectionEventType

  INNER_C_STRUCT_btdrv_53* {.bycopy.} = object
    `type`*: U32               ## /< \ref BtdrvConnectionEventType
    `addr`*: BtdrvAddress      ## /< Device address.
    reserved*: array[0xfe, U8]  ## /< Reserved

  INNER_C_UNION_btdrv_50* {.bycopy, union.} = object
    v1*: INNER_C_STRUCT_btdrv_51 ## /< [1.0.0-8.1.1]
    v9*: INNER_C_STRUCT_btdrv_52 ## /< [9.0.0-11.0.1]
    v12*: INNER_C_STRUCT_btdrv_53 ## /< [12.0.0+]

  INNER_C_STRUCT_btdrv_49* {.bycopy.} = object
    anoBtdrv54*: INNER_C_UNION_btdrv_50

  INNER_C_STRUCT_btdrv_55* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    status*: U8                ## /< Status flag: 1 = success, 0 = failure.
    value*: U8                 ## /< Tsi value, when the above indicates success.

  INNER_C_STRUCT_btdrv_56* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    status*: U8                ## /< Status flag: 1 = success, 0 = failure.
    value*: U8                 ## /< Input bool value from \ref btdrvEnableBurstMode, when the above indicates success.

  INNER_C_STRUCT_btdrv_57* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    status*: U8                ## /< Status flag: 1 = success, 0 = failure.
    flag*: U8                  ## /< Bool flag, when the above indicates success.

  INNER_C_STRUCT_btdrv_58* {.bycopy.} = object
    status*: U8                ## /< Status flag: 1 = success, 0 = failure.
    pad*: array[0x3, U8]        ## /< Padding
    count*: U32                ## /< Count value.

  INNER_C_STRUCT_btdrv_59* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    status*: U8                ## /< Status flag: 1 = success, 0 = failure.

  INNER_C_STRUCT_btdrv_60* {.bycopy.} = object
    reason*: U16               ## /< \ref BtdrvFatalReason

  INNER_C_UNION_btdrv_31* {.bycopy, union.} = object
    data*: array[0x400, U8]     ## /< Raw data.
    type0*: INNER_C_STRUCT_btdrv_32 ## /< ::BtdrvEventTypeOld_Unknown0
    inquiryDevice*: INNER_C_STRUCT_btdrv_33 ## /< ::BtdrvEventType_InquiryDevice
    inquiryStatus*: INNER_C_STRUCT_btdrv_38 ## /< ::BtdrvEventType_InquiryStatus
    pairingPinCodeRequest*: INNER_C_STRUCT_btdrv_43 ## /< ::BtdrvEventType_PairingPinCodeRequest
    sspRequest*: INNER_C_STRUCT_btdrv_44 ## /< ::BtdrvEventType_SspRequest
    connection*: INNER_C_STRUCT_btdrv_49 ## /< ::BtdrvEventType_Connection
    tsi*: INNER_C_STRUCT_btdrv_55 ## /< ::BtdrvEventType_Tsi
    burstMode*: INNER_C_STRUCT_btdrv_56 ## /< ::BtdrvEventType_BurstMode
    setZeroRetransmission*: INNER_C_STRUCT_btdrv_57 ## /< ::BtdrvEventType_SetZeroRetransmission
    pendingConnections*: INNER_C_STRUCT_btdrv_58 ## /< ::BtdrvEventType_PendingConnections
    moveToSecondaryPiconet*: INNER_C_STRUCT_btdrv_59 ## /< ::BtdrvEventType_MoveToSecondaryPiconet
    bluetoothCrash*: INNER_C_STRUCT_btdrv_60 ## /< ::BtdrvEventType_BluetoothCrash

  BtdrvEventInfo* {.bycopy.} = object
    anoBtdrv61*: INNER_C_UNION_btdrv_31


## / Data for \ref btdrvGetHidEventInfo. The data stored here depends on the \ref BtdrvHidEventType.

type
  INNER_C_STRUCT_btdrv_82* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< Device address.
    pad*: array[2, U8]          ## /< Padding
    status*: BtdrvHidConnectionStatus ## /< \ref BtdrvHidConnectionStatus

  INNER_C_STRUCT_btdrv_83* {.bycopy.} = object
    status*: BtdrvHidConnectionStatus ## /< \ref BtdrvHidConnectionStatus
    `addr`*: BtdrvAddress      ## /< Device address.

  INNER_C_UNION_btdrv_81* {.bycopy, union.} = object
    v1*: INNER_C_STRUCT_btdrv_82 ## /< [1.0.0-11.0.1]
    v12*: INNER_C_STRUCT_btdrv_83 ## /< [12.0.0+]

  INNER_C_STRUCT_btdrv_80* {.bycopy.} = object
    anoBtdrv84*: INNER_C_UNION_btdrv_81

  INNER_C_STRUCT_btdrv_87* {.bycopy.} = object
    status*: U32               ## /< 0 for success, non-zero for error.
    `addr`*: BtdrvAddress      ## /< Device address.

  INNER_C_STRUCT_btdrv_88* {.bycopy.} = object
    status*: U32               ## /< 0 for success, non-zero for error.
    `addr`*: BtdrvAddress      ## /< Device address.

  INNER_C_STRUCT_btdrv_89* {.bycopy.} = object
    status*: U32               ## /< 0 for success, non-zero for error.
    `addr`*: BtdrvAddress      ## /< Device address.

  INNER_C_STRUCT_btdrv_90* {.bycopy.} = object
    status*: U32               ## /< 0 for success, non-zero for error.
    `addr`*: BtdrvAddress      ## /< Device address.

  INNER_C_STRUCT_btdrv_91* {.bycopy.} = object
    status*: U32               ## /< 0 for success, non-zero for error.
    `addr`*: BtdrvAddress      ## /< Device address.
    pad*: array[2, U8]          ## /< Padding
    flag*: U8                  ## /< Flag

  INNER_C_STRUCT_btdrv_92* {.bycopy.} = object
    status*: U32               ## /< 0 for success, non-zero for error.
    `addr`*: BtdrvAddress      ## /< Unused
    pad*: array[2, U8]          ## /< Padding
    count*: U32                ## /< Count value.

  INNER_C_STRUCT_btdrv_93* {.bycopy.} = object
    status*: U32               ## /< 0 for success, non-zero for error.
    `addr`*: BtdrvAddress      ## /< Device address.

  INNER_C_UNION_btdrv_86* {.bycopy, union.} = object
    setTsi*: INNER_C_STRUCT_btdrv_87 ## /< ::BtdrvExtEventType_SetTsi
    exitTsi*: INNER_C_STRUCT_btdrv_88 ## /< ::BtdrvExtEventType_ExitTsi
    setBurstMode*: INNER_C_STRUCT_btdrv_89 ## /< ::BtdrvExtEventType_SetBurstMode
    exitBurstMode*: INNER_C_STRUCT_btdrv_90 ## /< ::BtdrvExtEventType_ExitBurstMode
    setZeroRetransmission*: INNER_C_STRUCT_btdrv_91 ## /< ::BtdrvExtEventType_SetZeroRetransmission
    pendingConnections*: INNER_C_STRUCT_btdrv_92 ## /< ::BtdrvExtEventType_PendingConnections
    moveToSecondaryPiconet*: INNER_C_STRUCT_btdrv_93 ## /< ::BtdrvExtEventType_MoveToSecondaryPiconet

  INNER_C_STRUCT_btdrv_85* {.bycopy.} = object
    `type`*: U32               ## /< \ref BtdrvExtEventType, controls which data is stored below.
    anoBtdrv94*: INNER_C_UNION_btdrv_86

  INNER_C_UNION_btdrv_79* {.bycopy, union.} = object
    data*: array[0x480, U8]     ## /< Raw data.
    connection*: INNER_C_STRUCT_btdrv_80 ## /< ::BtdrvHidEventType_Connection
    ext*: INNER_C_STRUCT_btdrv_85 ## /< ::BtdrvHidEventType_Ext [1.0.0-11.0.1]

  BtdrvHidEventInfo* {.bycopy.} = object
    anoBtdrv95*: INNER_C_UNION_btdrv_79


## / Data for \ref btdrvGetHidReportEventInfo. The data stored here depends on the \ref BtdrvHidEventType.

type
  INNER_C_STRUCT_btdrv_123* {.bycopy.} = object
    `addr`*: BtdrvAddress
    pad*: array[2, U8]
    res*: U32
    size*: U32

  INNER_C_STRUCT_btdrv_122* {.bycopy.} = object
    hdr*: INNER_C_STRUCT_btdrv_123
    unused*: array[0x3, U8]     ## /< Unused
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    unused2*: array[0x3, U8]    ## /< Unused
    report*: BtdrvHidData

  INNER_C_STRUCT_btdrv_124* {.bycopy.} = object
    unused*: array[0x3, U8]     ## /< Unused
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    unused2*: array[0x3, U8]    ## /< Unused
    report*: BtdrvHidData

  INNER_C_STRUCT_btdrv_125* {.bycopy.} = object
    res*: U32                  ## /< Always 0.
    unkX4*: U8                 ## /< Always 0.
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    pad*: U8                   ## /< Padding
    report*: BtdrvHidReport

  INNER_C_UNION_btdrv_121* {.bycopy, union.} = object
    v1*: INNER_C_STRUCT_btdrv_122 ## /< [1.0.0-6.2.0]
    v7*: INNER_C_STRUCT_btdrv_124 ## /< [7.0.0-8.1.1]
    v9*: INNER_C_STRUCT_btdrv_125 ## /< [9.0.0+]

  INNER_C_STRUCT_btdrv_120* {.bycopy.} = object
    anoBtdrv126*: INNER_C_UNION_btdrv_121

  INNER_C_STRUCT_btdrv_129* {.bycopy.} = object
    res*: U32                  ## /< 0 = success, non-zero = error.
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    pad*: array[2, U8]          ## /< Padding

  INNER_C_UNION_btdrv_128* {.bycopy, union.} = object
    rawdata*: array[0xC, U8]    ## /< Raw data.
    anoBtdrv130*: INNER_C_STRUCT_btdrv_129

  INNER_C_STRUCT_btdrv_127* {.bycopy.} = object
    anoBtdrv131*: INNER_C_UNION_btdrv_128

  INNER_C_STRUCT_btdrv_135* {.bycopy.} = object
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    pad*: array[2, U8]          ## /< Padding
    res*: U32                  ## /< Unknown. hid-sysmodule only uses the below data when this field is 0.
    report*: BtdrvHidData      ## /< \ref BtdrvHidData
    pad2*: array[2, U8]         ## /< Padding

  INNER_C_UNION_btdrv_134* {.bycopy, union.} = object
    rawdata*: array[0x290, U8]  ## /< Raw data.
    anoBtdrv136*: INNER_C_STRUCT_btdrv_135

  INNER_C_STRUCT_btdrv_138* {.bycopy.} = object
    res*: U32                  ## /< Unknown. hid-sysmodule only uses the below report when this field is 0.
    `addr`*: BtdrvAddress      ## /< \ref BtdrvAddress
    report*: BtdrvHidReport    ## /< \ref BtdrvHidReport

  INNER_C_UNION_btdrv_137* {.bycopy, union.} = object
    rawdata*: array[0x2C8, U8]  ## /< Raw data.
    anoBtdrv139*: INNER_C_STRUCT_btdrv_138

  INNER_C_UNION_btdrv_133* {.bycopy, union.} = object
    v1*: INNER_C_UNION_btdrv_134 ## /< [1.0.0-8.1.1]
    v9*: INNER_C_UNION_btdrv_137 ## /< [9.0.0+]

  INNER_C_STRUCT_btdrv_132* {.bycopy.} = object
    anoBtdrv140*: INNER_C_UNION_btdrv_133

  INNER_C_UNION_btdrv_119* {.bycopy, union.} = object
    data*: array[0x480, U8]     ## /< Raw data.
    dataReport*: INNER_C_STRUCT_btdrv_120 ## /< ::BtdrvHidEventType_DataReport
    setReport*: INNER_C_STRUCT_btdrv_127 ## /< ::BtdrvHidEventType_SetReport
    getReport*: INNER_C_STRUCT_btdrv_132 ## /< ::BtdrvHidEventType_GetReport

  BtdrvHidReportEventInfo* {.bycopy.} = object
    anoBtdrv141*: INNER_C_UNION_btdrv_119


## / The raw sharedmem data for HidReportEventInfo.

type
  INNER_C_STRUCT_btdrv_143* {.bycopy.} = object
    `type`*: U8                ## /< \ref BtdrvHidEventType
    pad*: array[7, U8]
    tick*: U64
    size*: U64

  BtdrvHidReportEventInfoBufferData* {.bycopy.} = object
    hdr*: INNER_C_STRUCT_btdrv_143
    data*: BtdrvHidReportEventInfo


## / Data for \ref btdrvGetAudioEventInfo. The data stored here depends on the \ref BtdrvAudioEventType.

type
  INNER_C_STRUCT_btdrv_145* {.bycopy.} = object
    status*: U32               ## /< Status: 0 = AV connection closed, 1 = AV connection opened, 2 = failed to open AV connection.
    `addr`*: BtdrvAddress      ## /< Device address.
    pad*: array[2, U8]          ## /< Padding

  BtdrvAudioEventInfo* {.bycopy, union.} = object
    connection*: INNER_C_STRUCT_btdrv_145 ## /< ::BtdrvAudioEventType_Connection


## / CircularBuffer

type
  BtdrvCircularBuffer* {.bycopy.} = object
    mutex*: Mutex
    eventType*: pointer        ## /< Not set with sharedmem.
    data*: array[0x2710, U8]
    writeOffset*: S32
    readOffset*: S32
    utilization*: U64
    name*: array[0x11, char]
    initialized*: U8


## / Data for \ref btdrvGetBleManagedEventInfo. The data stored here depends on the \ref BtdrvBleEventType.

type
  INNER_C_STRUCT_btdrv_160* {.bycopy.} = object
    status*: U32
    handle*: U8
    registered*: U8

  INNER_C_STRUCT_btdrv_161* {.bycopy.} = object
    status*: U32
    connId*: U32
    unkX8*: U32
    unkXC*: U32

  INNER_C_STRUCT_btdrv_162* {.bycopy.} = object
    connId*: U32
    minInterval*: U16
    maxInterval*: U16
    slaveLatency*: U16
    timeoutMultiplier*: U16

  INNER_C_STRUCT_btdrv_163* {.bycopy.} = object
    status*: U32
    unkX4*: U8
    unkX5*: U8
    unkX6*: U8
    unkX7*: U8
    connId*: U32
    address*: BtdrvAddress
    unkX12*: U16

  INNER_C_STRUCT_btdrv_164* {.bycopy.} = object
    status*: U32
    unkX4*: U8
    unkX5*: U8
    unkX6*: U8
    address*: BtdrvAddress
    adv*: array[10, BtdrvBleAdvertisementData]
    count*: U8
    unkX144*: U32

  INNER_C_STRUCT_btdrv_165* {.bycopy.} = object
    status*: U32
    connId*: U32

  INNER_C_STRUCT_btdrv_166* {.bycopy.} = object
    status*: U32
    `interface`*: U8
    unkX5*: U8
    unkX6*: U16
    unkX8*: U32
    svcUuid*: BtdrvGattAttributeUuid
    charUuid*: BtdrvGattAttributeUuid
    descrUuid*: BtdrvGattAttributeUuid
    size*: U16
    data*: array[0x202, U8]

  INNER_C_STRUCT_btdrv_167* {.bycopy.} = object
    status*: U32
    connId*: U32
    unkX8*: U32
    unkXC*: array[0x140, U8]

  INNER_C_STRUCT_btdrv_168* {.bycopy.} = object
    status*: U32
    connId*: U32
    unkX8*: array[0x24, U8]
    unkX2C*: U32
    unkX30*: array[0x11c, U8]

  INNER_C_STRUCT_btdrv_169* {.bycopy.} = object
    status*: U32
    connId*: U32
    unkX8*: U16

  INNER_C_STRUCT_btdrv_170* {.bycopy.} = object
    unkX0*: array[0x218, U8]

  INNER_C_UNION_btdrv_159* {.bycopy, union.} = object
    data*: array[0x400, U8]
    type0*: INNER_C_STRUCT_btdrv_160
    type2*: INNER_C_STRUCT_btdrv_161
    type3*: INNER_C_STRUCT_btdrv_162 ## /< Connection params?
    type4*: INNER_C_STRUCT_btdrv_163 ## /< Connection status?
    type6*: INNER_C_STRUCT_btdrv_164 ## /< Scan result?
    type7*: INNER_C_STRUCT_btdrv_165
    type8*: INNER_C_STRUCT_btdrv_166 ## /< Notification?
    type9*: INNER_C_STRUCT_btdrv_167
    type10*: INNER_C_STRUCT_btdrv_168
    type11*: INNER_C_STRUCT_btdrv_169
    type13*: INNER_C_STRUCT_btdrv_170

  BtdrvBleEventInfo* {.bycopy.} = object
    anoBtdrv171*: INNER_C_UNION_btdrv_159

proc btdrvInitialize*(): Result {.cdecl, importc: "btdrvInitialize".}
## / Initialize btdrv.

proc btdrvExit*() {.cdecl, importc: "btdrvExit".}
## / Exit btdrv.

proc btdrvGetServiceSession*(): ptr Service {.cdecl,
    importc: "btdrvGetServiceSession".}
## / Gets the Service object for the actual btdrv service session.

proc btdrvInitializeBluetooth*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdrvInitializeBluetooth".}
## *
##  @brief InitializeBluetooth
##  @note This is used by btm-sysmodule, this should not be used by other processes.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btdrvEnableBluetooth*(): Result {.cdecl, importc: "btdrvEnableBluetooth".}
## *
##  @brief EnableBluetooth
##  @note This is used by btm-sysmodule.
##

proc btdrvDisableBluetooth*(): Result {.cdecl, importc: "btdrvDisableBluetooth".}
## *
##  @brief DisableBluetooth
##  @note This is used by btm-sysmodule.
##

proc btdrvFinalizeBluetooth*(): Result {.cdecl, importc: "btdrvFinalizeBluetooth".}
## *
##  @brief FinalizeBluetooth
##  @note This is not used by btm-sysmodule, this should not be used by other processes.
##

proc btdrvLegacyGetAdapterProperties*(properties: ptr BtdrvAdapterPropertyOld): Result {.
    cdecl, importc: "btdrvLegacyGetAdapterProperties".}
## *
##  @brief GetAdapterProperties [1.0.0-11.0.1]
##  @param[out] properties \ref BtdrvAdapterPropertyOld
##

proc btdrvGetAdapterProperties*(properties: ptr BtdrvAdapterPropertySet): Result {.
    cdecl, importc: "btdrvGetAdapterProperties".}
## *
##  @brief GetAdapterProperties [12.0.0+]
##  @param[out] properties \ref BtdrvAdapterPropertySet
##

proc btdrvLegacyGetAdapterProperty*(`type`: BtdrvBluetoothPropertyType;
                                   buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "btdrvLegacyGetAdapterProperty".}
## *
##  @brief GetAdapterProperty [1.0.0-11.0.1]
##  @param[in] type \ref BtdrvBluetoothPropertyType
##  @param[out] buffer Output buffer, see \ref BtdrvBluetoothPropertyType for the contents.
##  @param[in] size Output buffer size.
##

proc btdrvGetAdapterProperty*(`type`: BtdrvAdapterPropertyType;
                             property: ptr BtdrvAdapterProperty): Result {.cdecl,
    importc: "btdrvGetAdapterProperty".}
## *
##  @brief GetAdapterProperty [12.0.0+]
##  @param[in] type \ref BtdrvAdapterPropertyType
##  @param[in] property \ref BtdrvAdapterProperty
##

proc btdrvLegacySetAdapterProperty*(`type`: BtdrvBluetoothPropertyType;
                                   buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "btdrvLegacySetAdapterProperty".}
## *
##  @brief SetAdapterProperty [1.0.0-11.0.1]
##  @param[in] type \ref BtdrvBluetoothPropertyType
##  @param[in] buffer Input buffer, see \ref BtdrvBluetoothPropertyType for the contents.
##  @param[in] size Input buffer size.
##

proc btdrvSetAdapterProperty*(`type`: BtdrvAdapterPropertyType;
                             property: ptr BtdrvAdapterProperty): Result {.cdecl,
    importc: "btdrvSetAdapterProperty".}
## *
##  @brief SetAdapterProperty [12.0.0+]
##  @param[in] type \ref BtdrvAdapterPropertyType
##  @param[in] property \ref BtdrvAdapterProperty
##

proc btdrvLegacyStartInquiry*(): Result {.cdecl, importc: "btdrvLegacyStartInquiry".}
## *
##  @brief StartInquiry [1.0.0-11.0.1]. This starts Inquiry, the output data will be available via \ref btdrvGetEventInfo. Inquiry will automatically stop in 10.24 seconds.
##  @note This is used by btm-sysmodule.
##

proc btdrvStartInquiry*(services: U32; duration: S64): Result {.cdecl,
    importc: "btdrvStartInquiry".}
## *
##  @brief StartInquiry [12.0.0+]. This starts Inquiry, the output data will be available via \ref btdrvGetEventInfo.
##  @param[in] services Bitfield of allowed services. When -1 the original defaults from pre-12.0.0 are used.
##  @param[in] duration Inquiry duration in nanoseconds.
##  @note This is used by btm-sysmodule.
##

proc btdrvStopInquiry*(): Result {.cdecl, importc: "btdrvStopInquiry".}
## *
##  @brief This stops Inquiry which was started by \ref btdrvStartInquiry, if it's still active.
##  @note This is used by btm-sysmodule.
##

proc btdrvCreateBond*(`addr`: BtdrvAddress; `type`: U32): Result {.cdecl,
    importc: "btdrvCreateBond".}
## *
##  @brief CreateBond
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] type TransportType
##

proc btdrvRemoveBond*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdrvRemoveBond".}
## *
##  @brief RemoveBond
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##

proc btdrvCancelBond*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdrvCancelBond".}
## *
##  @brief CancelBond
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##

proc btdrvLegacyRespondToPinRequest*(`addr`: BtdrvAddress; flag: bool;
                                    pinCode: ptr BtdrvBluetoothPinCode; length: U8): Result {.
    cdecl, importc: "btdrvLegacyRespondToPinRequest".}
## *
##  @brief RespondToPinRequest [1.0.0-11.0.1]
##  @note The official sysmodule only uses the input \ref BtdrvAddress.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] flag Flag
##  @param[in] pin_code \ref BtdrvBluetoothPinCode
##  @param[in] length Length of pin_code
##

proc btdrvRespondToPinRequest*(`addr`: BtdrvAddress; pinCode: ptr BtdrvPinCode): Result {.
    cdecl, importc: "btdrvRespondToPinRequest".}
## *
##  @brief RespondToPinRequest [12.0.0+]
##  @param[in] addr \ref BtdrvAddress
##  @param[in] pin_code \ref BtdrvPinCode
##

proc btdrvRespondToSspRequest*(`addr`: BtdrvAddress; variant: U32; accept: bool;
                              passkey: U32): Result {.cdecl,
    importc: "btdrvRespondToSspRequest".}
## *
##  @brief RespondToSspRequest
##  @note The official sysmodule only uses the input \ref BtdrvAddress and the flag.
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] variant BluetoothSspVariant
##  @param[in] accept Whether the request is accepted.
##  @param[in] passkey Passkey.
##

proc btdrvGetEventInfo*(buffer: pointer; size: csize_t; `type`: ptr BtdrvEventType): Result {.
    cdecl, importc: "btdrvGetEventInfo".}
## *
##  @brief GetEventInfo
##  @note This is used by btm-sysmodule.
##  @param[out] buffer Output buffer, see \ref BtdrvEventInfo.
##  @param[in] size Output buffer size.
##  @param[out] type Output BtdrvEventType.
##

proc btdrvInitializeHid*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdrvInitializeHid".}
## *
##  @brief InitializeHid
##  @note This is used by btm-sysmodule, this should not be used by other processes.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btdrvOpenHidConnection*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdrvOpenHidConnection".}
## *
##  @brief OpenHidConnection
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##

proc btdrvCloseHidConnection*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdrvCloseHidConnection".}
## *
##  @brief CloseHidConnection
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##

proc btdrvWriteHidData*(`addr`: BtdrvAddress; buffer: ptr BtdrvHidReport): Result {.
    cdecl, importc: "btdrvWriteHidData".}
## *
##  @brief This sends a HID DATA transaction packet with report-type Output.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] buffer Input \ref BtdrvHidReport, on pre-9.0.0 this is \ref BtdrvHidData.
##

proc btdrvWriteHidData2*(`addr`: BtdrvAddress; buffer: pointer; size: csize_t): Result {.
    cdecl, importc: "btdrvWriteHidData2".}
## *
##  @brief WriteHidData2
##  @param[in] addr \ref BtdrvAddress
##  @param[in] buffer Input buffer, same as the buffer for \ref btdrvWriteHidData.
##  @param[in] size Input buffer size.
##

proc btdrvSetHidReport*(`addr`: BtdrvAddress; `type`: BtdrvBluetoothHhReportType;
                       buffer: ptr BtdrvHidReport): Result {.cdecl,
    importc: "btdrvSetHidReport".}
## *
##  @brief This sends a HID SET_REPORT transaction packet.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] type \ref BtdrvBluetoothHhReportType
##  @param[in] buffer Input \ref BtdrvHidReport, on pre-9.0.0 this is \ref BtdrvHidData.
##

proc btdrvGetHidReport*(`addr`: BtdrvAddress; reportId: U8;
                       `type`: BtdrvBluetoothHhReportType): Result {.cdecl,
    importc: "btdrvGetHidReport".}
## *
##  @brief This sends a HID GET_REPORT transaction packet.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] report_id This is sent in the packet for the Report Id, when non-zero.
##  @param[in] type \ref BtdrvBluetoothHhReportType
##

proc btdrvTriggerConnection*(`addr`: BtdrvAddress; unk: U16): Result {.cdecl,
    importc: "btdrvTriggerConnection".}
## *
##  @brief TriggerConnection
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] unk [9.0.0+] Unknown
##

proc btdrvAddPairedDeviceInfo*(settings: ptr SetSysBluetoothDevicesSettings): Result {.
    cdecl, importc: "btdrvAddPairedDeviceInfo".}
## *
##  @brief AddPairedDeviceInfo
##  @note This is used by btm-sysmodule.
##  @param[in] settings \ref SetSysBluetoothDevicesSettings
##

proc btdrvGetPairedDeviceInfo*(`addr`: BtdrvAddress;
                              settings: ptr SetSysBluetoothDevicesSettings): Result {.
    cdecl, importc: "btdrvGetPairedDeviceInfo".}
## *
##  @brief GetPairedDeviceInfo
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##  @param[out] settings \ref SetSysBluetoothDevicesSettings
##

proc btdrvFinalizeHid*(): Result {.cdecl, importc: "btdrvFinalizeHid".}
## *
##  @brief FinalizeHid
##  @note This is not used by btm-sysmodule, this should not be used by other processes.
##

proc btdrvGetHidEventInfo*(buffer: pointer; size: csize_t;
                          `type`: ptr BtdrvHidEventType): Result {.cdecl,
    importc: "btdrvGetHidEventInfo".}
## *
##  @brief GetHidEventInfo
##  @note This is used by btm-sysmodule.
##  @param[out] buffer Output buffer, see \ref BtdrvHidEventInfo.
##  @param[in] size Output buffer size.
##  @param[out] type \ref BtdrvHidEventType, always ::BtdrvHidEventType_Connection or ::BtdrvHidEventType_Ext.
##

proc btdrvSetTsi*(`addr`: BtdrvAddress; tsi: U8): Result {.cdecl,
    importc: "btdrvSetTsi".}
## *
##  @brief SetTsi
##  @note The response will be available via \ref btdrvGetHidEventInfo ([12.0.0+] \ref btdrvGetEventInfo).
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] tsi Tsi: non-value-0xFF to Set, value 0xFF to Exit. See also \ref BtmTsiMode.
##

proc btdrvEnableBurstMode*(`addr`: BtdrvAddress; flag: bool): Result {.cdecl,
    importc: "btdrvEnableBurstMode".}
## *
##  @brief EnableBurstMode
##  @note The response will be available via \ref btdrvGetHidEventInfo ([12.0.0+] \ref btdrvGetEventInfo).
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] flag Flag: true = Set, false = Exit.
##

proc btdrvSetZeroRetransmission*(`addr`: BtdrvAddress; reportIds: ptr U8; count: U8): Result {.
    cdecl, importc: "btdrvSetZeroRetransmission".}
## *
##  @brief SetZeroRetransmission
##  @note The response will be available via \ref btdrvGetHidEventInfo ([12.0.0+] \ref btdrvGetEventInfo).
##  @note This is used by btm-sysmodule.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] report_ids Input buffer containing an array of u8s.
##  @param[in] count Total u8s in the input buffer. This can be 0, the max is 5.
##

proc btdrvEnableMcMode*(flag: bool): Result {.cdecl, importc: "btdrvEnableMcMode".}
## *
##  @brief EnableMcMode
##  @note This is used by btm-sysmodule.
##  @param[in] flag Flag
##

proc btdrvEnableLlrScan*(): Result {.cdecl, importc: "btdrvEnableLlrScan".}
## *
##  @brief EnableLlrScan
##  @note This is used by btm-sysmodule.
##

proc btdrvDisableLlrScan*(): Result {.cdecl, importc: "btdrvDisableLlrScan".}
## *
##  @brief DisableLlrScan
##  @note This is used by btm-sysmodule.
##

proc btdrvEnableRadio*(flag: bool): Result {.cdecl, importc: "btdrvEnableRadio".}
## *
##  @brief EnableRadio
##  @note This is used by btm-sysmodule.
##  @param[in] flag Flag
##

proc btdrvSetVisibility*(inquiryScan: bool; pageScan: bool): Result {.cdecl,
    importc: "btdrvSetVisibility".}
## *
##  @brief SetVisibility
##  @note This is used by btm-sysmodule.
##  @param[in] inquiry_scan Controls Inquiry Scan, whether the device can be discovered during Inquiry.
##  @param[in] page_scan Controls Page Scan, whether the device accepts connections.
##

proc btdrvEnableTbfcScan*(flag: bool): Result {.cdecl, importc: "btdrvEnableTbfcScan".}
## *
##  @brief EnableTbfcScan
##  @note Only available on [4.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] flag Flag
##

proc btdrvRegisterHidReportEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdrvRegisterHidReportEvent".}
## *
##  @brief RegisterHidReportEvent
##  @note This also does sharedmem init/handling if needed, on [7.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true. This is signaled when data is available with \ref btdrvGetHidReportEventInfo.
##

proc btdrvGetHidReportEventInfo*(buffer: pointer; size: csize_t;
                                `type`: ptr BtdrvHidEventType): Result {.cdecl,
    importc: "btdrvGetHidReportEventInfo".}
## *
##  @brief GetHidReportEventInfo
##  @note \ref btdrvRegisterHidReportEvent must be used before this, on [7.0.0+].
##  @note This is used by hid-sysmodule. When used by other processes, hid/user-process will conflict. No events will be received by that user-process, or it will be corrupted, etc.
##  @note [7.0.0+] When data isn't available, the type is set to ::BtdrvHidEventType_Data, with the buffer cleared to all-zero.
##  @param[out] buffer Output buffer, see \ref BtdrvHidReportEventInfo.
##  @param[in] size Output buffer size.
##  @oaram[out] type \ref BtdrvHidEventType
##

proc btdrvGetHidReportEventInfoSharedmemAddr*(): pointer {.cdecl,
    importc: "btdrvGetHidReportEventInfoSharedmemAddr".}
## / Gets the SharedMemory addr for HidReportEventInfo (\ref BtdrvCircularBuffer), only valid when \ref btdrvRegisterHidReportEvent was previously used, on [7.0.0+].

proc btdrvGetLatestPlr*(`out`: ptr BtdrvPlrList): Result {.cdecl,
    importc: "btdrvGetLatestPlr".}
## *
##  @brief GetLatestPlr
##  @param[out] out Output \ref BtdrvPlrList, on pre-9.0.0 this is \ref BtdrvPlrStatistics.
##

proc btdrvGetPendingConnections*(): Result {.cdecl,
    importc: "btdrvGetPendingConnections".}
## *
##  @brief GetPendingConnections
##  @note The output data will be available via \ref btdrvGetHidEventInfo ([12.0.0+] \ref btdrvGetEventInfo).
##  @note This is used by btm-sysmodule.
##  @note Only available on [3.0.0+].
##

proc btdrvGetChannelMap*(`out`: ptr BtdrvChannelMapList): Result {.cdecl,
    importc: "btdrvGetChannelMap".}
## *
##  @brief GetChannelMap
##  @note Only available on [3.0.0+].
##  @param[out] out \ref BtdrvChannelMapList
##

proc btdrvEnableTxPowerBoostSetting*(flag: bool): Result {.cdecl,
    importc: "btdrvEnableTxPowerBoostSetting".}
## *
##  @brief EnableTxPowerBoostSetting
##  @note Only available on [3.0.0+].
##  @param[in] flag Input flag.
##

proc btdrvIsTxPowerBoostSettingEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "btdrvIsTxPowerBoostSettingEnabled".}
## *
##  @brief IsTxPowerBoostSettingEnabled
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc btdrvEnableAfhSetting*(flag: bool): Result {.cdecl,
    importc: "btdrvEnableAfhSetting".}
## *
##  @brief EnableAfhSetting
##  @note Only available on [3.0.0+].
##  @param[in] flag Input flag.
##

proc btdrvIsAfhSettingEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "btdrvIsAfhSettingEnabled".}
## *
##  @brief IsAfhSettingEnabled
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc btdrvInitializeBle*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdrvInitializeBle".}
## *
##  @brief InitializeBle
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btdrvEnableBle*(): Result {.cdecl, importc: "btdrvEnableBle".}
## *
##  @brief EnableBle
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##

proc btdrvDisableBle*(): Result {.cdecl, importc: "btdrvDisableBle".}
## *
##  @brief DisableBle
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##

proc btdrvFinalizeBle*(): Result {.cdecl, importc: "btdrvFinalizeBle".}
## *
##  @brief FinalizeBle
##  @note Only available on [5.0.0+].
##

proc btdrvSetBleVisibility*(discoverable: bool; connectable: bool): Result {.cdecl,
    importc: "btdrvSetBleVisibility".}
## *
##  @brief SetBleVisibility
##  @note Only available on [5.0.0+].
##  @param[in] discoverable Whether the BLE device is discoverable.
##  @param[in] connectable Whether the BLE device is connectable.
##

proc btdrvSetLeConnectionParameter*(param: ptr BtdrvLeConnectionParams): Result {.
    cdecl, importc: "btdrvSetLeConnectionParameter".}
## *
##  @brief SetLeConnectionParameter
##  @note Only available on [5.0.0-8.1.1]. This is the older version of \ref btdrvSetBleConnectionParameter.
##  @param[in] param \ref BtdrvLeConnectionParams
##

proc btdrvSetBleConnectionParameter*(`addr`: BtdrvAddress;
                                    param: ptr BtdrvBleConnectionParameter;
                                    flag: bool): Result {.cdecl,
    importc: "btdrvSetBleConnectionParameter".}
## *
##  @brief SetBleConnectionParameter
##  @note Only available on [9.0.0+]. This is the newer version of \ref btdrvSetLeConnectionParameter.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] param \ref BtdrvBleConnectionParameter
##  @param[in] flag Flag
##

proc btdrvSetLeDefaultConnectionParameter*(param: ptr BtdrvLeConnectionParams): Result {.
    cdecl, importc: "btdrvSetLeDefaultConnectionParameter".}
## *
##  @brief SetLeDefaultConnectionParameter
##  @note Only available on [5.0.0-8.1.1]. This is the older version of \ref btdrvSetBleDefaultConnectionParameter.
##  @param[in] param \ref BtdrvLeConnectionParams
##

proc btdrvSetBleDefaultConnectionParameter*(
    param: ptr BtdrvBleConnectionParameter): Result {.cdecl,
    importc: "btdrvSetBleDefaultConnectionParameter".}
## *
##  @brief SetBleDefaultConnectionParameter
##  @note Only available on [9.0.0+]. This is the newer version of \ref btdrvSetLeDefaultConnectionParameter.
##  @param[in] param \ref BtdrvBleConnectionParameter
##

proc btdrvSetBleAdvertiseData*(data: ptr BtdrvBleAdvertisePacketData): Result {.
    cdecl, importc: "btdrvSetBleAdvertiseData".}
## *
##  @brief SetBleAdvertiseData
##  @note Only available on [5.0.0+].
##  @param[in] data \ref BtdrvBleAdvertisePacketData
##

proc btdrvSetBleAdvertiseParameter*(`addr`: BtdrvAddress; unk0: U16; unk1: U16): Result {.
    cdecl, importc: "btdrvSetBleAdvertiseParameter".}
## *
##  @brief SetBleAdvertiseParameter
##  @note Only available on [5.0.0+].
##  @param[in] addr \ref BtdrvAddress
##  @param[in] unk0 Unknown
##  @param[in] unk1 Unknown
##

proc btdrvStartBleScan*(): Result {.cdecl, importc: "btdrvStartBleScan".}
## *
##  @brief StartBleScan
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##

proc btdrvStopBleScan*(): Result {.cdecl, importc: "btdrvStopBleScan".}
## *
##  @brief StopBleScan
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##

proc btdrvAddBleScanFilterCondition*(filter: ptr BtdrvBleAdvertiseFilter): Result {.
    cdecl, importc: "btdrvAddBleScanFilterCondition".}
## *
##  @brief AddBleScanFilterCondition
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] filter \ref BtdrvBleAdvertiseFilter
##

proc btdrvDeleteBleScanFilterCondition*(filter: ptr BtdrvBleAdvertiseFilter): Result {.
    cdecl, importc: "btdrvDeleteBleScanFilterCondition".}
## *
##  @brief DeleteBleScanFilterCondition
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] filter \ref BtdrvBleAdvertiseFilter
##

proc btdrvDeleteBleScanFilter*(unk: U8): Result {.cdecl,
    importc: "btdrvDeleteBleScanFilter".}
## *
##  @brief DeleteBleScanFilter
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##

proc btdrvClearBleScanFilters*(): Result {.cdecl,
                                        importc: "btdrvClearBleScanFilters".}
## *
##  @brief ClearBleScanFilters
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##

proc btdrvEnableBleScanFilter*(flag: bool): Result {.cdecl,
    importc: "btdrvEnableBleScanFilter".}
## *
##  @brief EnableBleScanFilter
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] flag Flag
##

proc btdrvRegisterGattClient*(uuid: ptr BtdrvGattAttributeUuid): Result {.cdecl,
    importc: "btdrvRegisterGattClient".}
## *
##  @brief RegisterGattClient
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvUnregisterGattClient*(unk: U8): Result {.cdecl,
    importc: "btdrvUnregisterGattClient".}
## *
##  @brief UnregisterGattClient
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##

proc btdrvUnregisterAllGattClients*(): Result {.cdecl,
    importc: "btdrvUnregisterAllGattClients".}
## *
##  @brief UnregisterAllGattClients
##  @note Only available on [5.0.0+].
##

proc btdrvConnectGattServer*(unk: U8; `addr`: BtdrvAddress; flag: bool;
                            appletResourceUserId: U64): Result {.cdecl,
    importc: "btdrvConnectGattServer".}
## *
##  @brief ConnectGattServer
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] unk Unknown
##  @param[in] addr \ref BtdrvAddress
##  @param[in] flag Flag
##  @param[in] AppletResourceUserId AppletResourceUserId
##

proc btdrvCancelConnectGattServer*(unk: U8; `addr`: BtdrvAddress; flag: bool): Result {.
    cdecl, importc: "btdrvCancelConnectGattServer".}
## *
##  @brief CancelConnectGattServer
##  @note Only available on [5.1.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] unk Unknown
##  @param[in] addr \ref BtdrvAddress
##  @param[in] flag Flag
##

proc btdrvDisconnectGattServer*(unk: U32): Result {.cdecl,
    importc: "btdrvDisconnectGattServer".}
## *
##  @brief DisconnectGattServer
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] unk Unknown
##

proc btdrvGetGattAttribute*(`addr`: BtdrvAddress; unk: U32): Result {.cdecl,
    importc: "btdrvGetGattAttribute".}
## *
##  @brief GetGattAttribute
##  @note Only available on [5.0.0+].
##  @param[in] addr \ref BtdrvAddress, only used on pre-9.0.0.
##  @param[in] unk Unknown
##

proc btdrvGetGattService*(unk: U32; uuid: ptr BtdrvGattAttributeUuid): Result {.cdecl,
    importc: "btdrvGetGattService".}
## *
##  @brief GetGattService
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvConfigureAttMtu*(unk: U32; mtu: U16): Result {.cdecl,
    importc: "btdrvConfigureAttMtu".}
## *
##  @brief ConfigureAttMtu
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] unk Unknown
##  @param[in] mtu MTU
##

proc btdrvRegisterGattServer*(uuid: ptr BtdrvGattAttributeUuid): Result {.cdecl,
    importc: "btdrvRegisterGattServer".}
## *
##  @brief RegisterGattServer
##  @note Only available on [5.0.0+].
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvUnregisterGattServer*(unk: U8): Result {.cdecl,
    importc: "btdrvUnregisterGattServer".}
## *
##  @brief UnregisterGattServer
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##

proc btdrvConnectGattClient*(unk: U8; `addr`: BtdrvAddress; flag: bool): Result {.cdecl,
    importc: "btdrvConnectGattClient".}
## *
##  @brief ConnectGattClient
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##  @param[in] addr \ref BtdrvAddress
##  @param[in] flag Flag
##

proc btdrvDisconnectGattClient*(unk: U8; `addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdrvDisconnectGattClient".}
## *
##  @brief DisconnectGattClient
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##  @param[in] addr \ref BtdrvAddress, only used on pre-9.0.0.
##

proc btdrvAddGattService*(unk0: U8; uuid: ptr BtdrvGattAttributeUuid; unk1: U8;
                         flag: bool): Result {.cdecl, importc: "btdrvAddGattService".}
## *
##  @brief AddGattService
##  @note Only available on [5.0.0+].
##  @param[in] unk0 Unknown
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[in] unk1 Unknown
##  @param[in] flag Flag
##

proc btdrvEnableGattService*(unk: U8; uuid: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btdrvEnableGattService".}
## *
##  @brief EnableGattService
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvAddGattCharacteristic*(unk0: U8; uuid0: ptr BtdrvGattAttributeUuid;
                                uuid1: ptr BtdrvGattAttributeUuid; unk1: U8;
                                unk2: U16): Result {.cdecl,
    importc: "btdrvAddGattCharacteristic".}
## *
##  @brief AddGattCharacteristic
##  @note Only available on [5.0.0+].
##  @param[in] unk0 Unknown
##  @param[in] uuid0 \ref BtdrvGattAttributeUuid
##  @param[in] uuid1 \ref BtdrvGattAttributeUuid
##  @param[in] unk1 Unknown
##  @param[in] unk2 Unknown
##

proc btdrvAddGattDescriptor*(unk0: U8; uuid0: ptr BtdrvGattAttributeUuid;
                            uuid1: ptr BtdrvGattAttributeUuid; unk1: U16): Result {.
    cdecl, importc: "btdrvAddGattDescriptor".}
## *
##  @brief AddGattDescriptor
##  @note Only available on [5.0.0+].
##  @param[in] unk0 Unknown
##  @param[in] uuid0 \ref BtdrvGattAttributeUuid
##  @param[in] uuid1 \ref BtdrvGattAttributeUuid
##  @param[in] unk1 Unknown
##

proc btdrvGetBleManagedEventInfo*(buffer: pointer; size: csize_t;
                                 `type`: ptr BtdrvBleEventType): Result {.cdecl,
    importc: "btdrvGetBleManagedEventInfo".}
## *
##  @brief GetBleManagedEventInfo
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[out] buffer Output buffer. 0x400-bytes from state is written here.
##  @param[in] size Output buffer size.
##  @oaram[out] type Output BtdrvBleEventType.
##

proc btdrvGetGattFirstCharacteristic*(unk: U32; id: ptr BtdrvGattId; flag: bool;
                                     uuid: ptr BtdrvGattAttributeUuid;
                                     outProperty: ptr U8;
                                     outCharId: ptr BtdrvGattId): Result {.cdecl,
    importc: "btdrvGetGattFirstCharacteristic".}
## *
##  @brief GetGattFirstCharacteristic
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##  @param[in] id \ref BtdrvGattId
##  @param[in] flag Flag
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[out] out_property Output Property.
##  @param[out] out_char_id Output CharacteristicId \ref BtdrvGattId
##

proc btdrvGetGattNextCharacteristic*(unk: U32; id0: ptr BtdrvGattId; flag: bool;
                                    id1: ptr BtdrvGattId;
                                    uuid: ptr BtdrvGattAttributeUuid;
                                    outProperty: ptr U8; outCharId: ptr BtdrvGattId): Result {.
    cdecl, importc: "btdrvGetGattNextCharacteristic".}
## *
##  @brief GetGattNextCharacteristic
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] flag Flag
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[out] out_property Output Property.
##  @param[out] out_char_id Output CharacteristicId \ref BtdrvGattId
##

proc btdrvGetGattFirstDescriptor*(unk: U32; id0: ptr BtdrvGattId; flag: bool;
                                 id1: ptr BtdrvGattId;
                                 uuid: ptr BtdrvGattAttributeUuid;
                                 outDescId: ptr BtdrvGattId): Result {.cdecl,
    importc: "btdrvGetGattFirstDescriptor".}
## *
##  @brief GetGattFirstDescriptor
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] flag Flag
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[out] out_desc_id Output DescriptorId \ref BtdrvGattId
##

proc btdrvGetGattNextDescriptor*(unk: U32; id0: ptr BtdrvGattId; flag: bool;
                                id1: ptr BtdrvGattId; id2: ptr BtdrvGattId;
                                uuid: ptr BtdrvGattAttributeUuid;
                                outDescId: ptr BtdrvGattId): Result {.cdecl,
    importc: "btdrvGetGattNextDescriptor".}
## *
##  @brief GetGattNextDescriptor
##  @note Only available on [5.0.0+].
##  @param[in] unk Unknown
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] flag Flag
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] id2 \ref BtdrvGattId
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[out] out_desc_id Output DescriptorId \ref BtdrvGattId
##

proc btdrvRegisterGattManagedDataPath*(uuid: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btdrvRegisterGattManagedDataPath".}
## *
##  @brief RegisterGattManagedDataPath
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvUnregisterGattManagedDataPath*(uuid: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btdrvUnregisterGattManagedDataPath".}
## *
##  @brief UnregisterGattManagedDataPath
##  @note Only available on [5.0.0+].
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvRegisterGattHidDataPath*(uuid: ptr BtdrvGattAttributeUuid): Result {.cdecl,
    importc: "btdrvRegisterGattHidDataPath".}
## *
##  @brief RegisterGattHidDataPath
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvUnregisterGattHidDataPath*(uuid: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btdrvUnregisterGattHidDataPath".}
## *
##  @brief UnregisterGattHidDataPath
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvRegisterGattDataPath*(uuid: ptr BtdrvGattAttributeUuid): Result {.cdecl,
    importc: "btdrvRegisterGattDataPath".}
## *
##  @brief RegisterGattDataPath
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvUnregisterGattDataPath*(uuid: ptr BtdrvGattAttributeUuid): Result {.cdecl,
    importc: "btdrvUnregisterGattDataPath".}
## *
##  @brief UnregisterGattDataPath
##  @note Only available on [5.0.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdrvReadGattCharacteristic*(connectionHandle: U32; primaryService: bool;
                                 id0: ptr BtdrvGattId; id1: ptr BtdrvGattId; unk: U8): Result {.
    cdecl, importc: "btdrvReadGattCharacteristic".}
## *
##  @brief ReadGattCharacteristic
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] unk Unknown
##

proc btdrvReadGattDescriptor*(connectionHandle: U32; primaryService: bool;
                             id0: ptr BtdrvGattId; id1: ptr BtdrvGattId;
                             id2: ptr BtdrvGattId; unk: U8): Result {.cdecl,
    importc: "btdrvReadGattDescriptor".}
## *
##  @brief ReadGattDescriptor
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] id2 \ref BtdrvGattId
##  @param[in] unk Unknown
##

proc btdrvWriteGattCharacteristic*(connectionHandle: U32; primaryService: bool;
                                  id0: ptr BtdrvGattId; id1: ptr BtdrvGattId;
                                  buffer: pointer; size: csize_t; unk: U8; flag: bool): Result {.
    cdecl, importc: "btdrvWriteGattCharacteristic".}
## *
##  @brief WriteGattCharacteristic
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size, must be <=0x258.
##  @param[in] unk Unknown
##  @param[in] flag Flag
##

proc btdrvWriteGattDescriptor*(connectionHandle: U32; primaryService: bool;
                              id0: ptr BtdrvGattId; id1: ptr BtdrvGattId;
                              id2: ptr BtdrvGattId; buffer: pointer; size: csize_t;
                              unk: U8): Result {.cdecl,
    importc: "btdrvWriteGattDescriptor".}
## *
##  @brief WriteGattDescriptor
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] id2 \ref BtdrvGattId
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size, must be <=0x258.
##  @param[in] unk Unknown
##

proc btdrvRegisterGattNotification*(connectionHandle: U32; primaryService: bool;
                                   id0: ptr BtdrvGattId; id1: ptr BtdrvGattId): Result {.
    cdecl, importc: "btdrvRegisterGattNotification".}
## *
##  @brief RegisterGattNotification
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##

proc btdrvUnregisterGattNotification*(connectionHandle: U32; primaryService: bool;
                                     id0: ptr BtdrvGattId; id1: ptr BtdrvGattId): Result {.
    cdecl, importc: "btdrvUnregisterGattNotification".}
## *
##  @brief UnregisterGattNotification
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##

proc btdrvGetLeHidEventInfo*(buffer: pointer; size: csize_t; `type`: ptr U32): Result {.
    cdecl, importc: "btdrvGetLeHidEventInfo".}
## *
##  @brief GetLeHidEventInfo
##  @note Only available on [5.0.0+].
##  @note The state used by this is reset after writing the data to output.
##  @param[out] buffer Output buffer. 0x400-bytes from state is written here. See \ref BtdrvLeEventInfo.
##  @param[in] size Output buffer size.
##  @oaram[out] type Output BleEventType.
##

proc btdrvRegisterBleHidEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdrvRegisterBleHidEvent".}
## *
##  @brief RegisterBleHidEvent
##  @note Only available on [5.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btdrvSetBleScanParameter*(unk0: U16; unk1: U16): Result {.cdecl,
    importc: "btdrvSetBleScanParameter".}
## *
##  @brief SetBleScanParameter
##  @note Only available on [5.1.0+].
##  @note This is used by btm-sysmodule.
##  @param[in] unk0 Unknown
##  @param[in] unk1 Unknown
##

proc btdrvMoveToSecondaryPiconet*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdrvMoveToSecondaryPiconet".}
## *
##  @brief MoveToSecondaryPiconet
##  @note The response will be available via \ref btdrvGetHidEventInfo ([12.0.0+] \ref btdrvGetEventInfo).
##  @note Only available on [10.0.0+].
##  @param[in] addr \ref BtdrvAddress
##

proc btdrvIsBluetoothEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "btdrvIsBluetoothEnabled".}
## *
##  @brief IsBluetoothEnabled
##  @note Only available on [12.0.0+].
##  @param[out] out Output flag.
##

proc btdrvAcquireAudioEvent*(outEvent: ptr Event; autoclear: bool): Result {.cdecl,
    importc: "btdrvAcquireAudioEvent".}
## *
##  @brief AcquireAudioEvent
##  @note Only available on [12.0.0+].
##  @param[out] out_event Output Event.
##  @param[in] autoclear Event autoclear.
##

proc btdrvGetAudioEventInfo*(buffer: pointer; size: csize_t;
                            `type`: ptr BtdrvAudioEventType): Result {.cdecl,
    importc: "btdrvGetAudioEventInfo".}
## *
##  @brief GetAudioEventInfo
##  @note Only available on [12.0.0+].
##  @param[out] buffer Output buffer, see \ref BtdrvAudioEventInfo.
##  @param[in] size Output buffer size.
##  @param[out] type \ref BtdrvAudioEventType.
##

proc btdrvOpenAudioConnection*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdrvOpenAudioConnection".}
## *
##  @brief OpenAudioConnection
##  @note Only available on [12.0.0+].
##  @param[in] addr \ref BtdrvAddress
##

proc btdrvCloseAudioConnection*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdrvCloseAudioConnection".}
## *
##  @brief CloseAudioConnection
##  @note Only available on [12.0.0+].
##  @param[in] addr \ref BtdrvAddress
##

proc btdrvOpenAudioOut*(`addr`: BtdrvAddress; audioHandle: ptr U32): Result {.cdecl,
    importc: "btdrvOpenAudioOut".}
## *
##  @brief OpenAudioOut
##  @note Only available on [12.0.0+].
##  @param[in] addr \ref BtdrvAddress
##  @param[out] audio_handle Audio handle.
##

proc btdrvCloseAudioOut*(audioHandle: U32): Result {.cdecl,
    importc: "btdrvCloseAudioOut".}
## *
##  @brief CloseAudioOut
##  @note Only available on [12.0.0+].
##  @param[in] audio_handle Audio handle from \ref btdrvOpenAudioOut.
##

proc btdrvStartAudioOut*(audioHandle: U32; pcmParam: ptr BtdrvPcmParameter;
                        inLatency: S64; outLatency: ptr S64; out1: ptr U64): Result {.
    cdecl, importc: "btdrvStartAudioOut".}
## *
##  @brief StartAudioOut
##  @note Only available on [12.0.0+].
##  @param[in] audio_handle Audio handle from \ref btdrvOpenAudioOut.
##  @param[in] pcm_param \ref BtdrvPcmParameter
##  @param[in] in_latency Input latency in nanoseconds.
##  @param[out] out_latency Output latency in nanoseconds.
##  @param[out] out1 Unknown output.
##

proc btdrvStopAudioOut*(audioHandle: U32): Result {.cdecl,
    importc: "btdrvStopAudioOut".}
## *
##  @brief StopAudioOut
##  @note Only available on [12.0.0+].
##  @param[in] audio_handle Audio handle from \ref btdrvOpenAudioOut.
##

proc btdrvGetAudioOutState*(audioHandle: U32; `out`: ptr BtdrvAudioOutState): Result {.
    cdecl, importc: "btdrvGetAudioOutState".}
## *
##  @brief GetAudioOutState
##  @note Only available on [12.0.0+].
##  @param[in] audio_handle Audio handle from \ref btdrvOpenAudioOut.
##  @param[out] out \ref BtdrvAudioOutState
##

proc btdrvGetAudioOutFeedingCodec*(audioHandle: U32; `out`: ptr BtdrvAudioCodec): Result {.
    cdecl, importc: "btdrvGetAudioOutFeedingCodec".}
## *
##  @brief GetAudioOutFeedingCodec
##  @note Only available on [12.0.0+].
##  @param[in] audio_handle Audio handle from \ref btdrvOpenAudioOut.
##  @param[out] out \ref BtdrvAudioCodec
##

proc btdrvGetAudioOutFeedingParameter*(audioHandle: U32;
                                      `out`: ptr BtdrvPcmParameter): Result {.cdecl,
    importc: "btdrvGetAudioOutFeedingParameter".}
## *
##  @brief GetAudioOutFeedingParameter
##  @note Only available on [12.0.0+].
##  @param[in] audio_handle Audio handle from \ref btdrvOpenAudioOut.
##  @param[out] out \ref BtdrvPcmParameter
##

proc btdrvAcquireAudioOutStateChangedEvent*(audioHandle: U32; outEvent: ptr Event;
    autoclear: bool): Result {.cdecl,
                            importc: "btdrvAcquireAudioOutStateChangedEvent".}
## *
##  @brief AcquireAudioOutStateChangedEvent
##  @note Only available on [12.0.0+].
##  @param[in] audio_handle Audio handle from \ref btdrvOpenAudioOut.
##  @param[out] out_event Output Event.
##  @param[in] autoclear Event autoclear.
##

proc btdrvAcquireAudioOutBufferAvailableEvent*(audioHandle: U32;
    outEvent: ptr Event; autoclear: bool): Result {.cdecl,
    importc: "btdrvAcquireAudioOutBufferAvailableEvent".}
## *
##  @brief AcquireAudioOutBufferAvailableEvent
##  @note Only available on [12.0.0+].
##  @param[in] audio_handle Audio handle from \ref btdrvOpenAudioOut.
##  @param[out] out_event Output Event.
##  @param[in] autoclear Event autoclear.
##

proc btdrvSendAudioData*(audioHandle: U32; buffer: pointer; size: csize_t;
                        transferredSize: ptr U64): Result {.cdecl,
    importc: "btdrvSendAudioData".}
## *
##  @brief SendAudioData
##  @note Only available on [12.0.0+].
##  @param[in] audio_handle Audio handle from \ref btdrvOpenAudioOut.
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size.
##  @param[out] Output transferred size. This is always either 0 (error occured) or the buffer size.
##

proc btdrvAcquireAudioControlInputStateChangedEvent*(outEvent: ptr Event;
    autoclear: bool): Result {.cdecl, importc: "btdrvAcquireAudioControlInputStateChangedEvent".}
## *
##  @brief AcquireAudioControlInputStateChangedEvent
##  @note Only available on [12.0.0+].
##  @param[out] out_event Output Event.
##  @param[in] autoclear Event autoclear.
##

proc btdrvGetAudioControlInputState*(states: ptr BtdrvAudioControlButtonState;
                                    count: S32; totalOut: ptr S32): Result {.cdecl,
    importc: "btdrvGetAudioControlInputState".}
## *
##  @brief GetAudioControlInputState
##  @note Only available on [12.0.0+].
##  @param[out] states Output array of \ref BtdrvAudioControlButtonState.
##  @param[in] count Size of the states array in entries, the maximum is 0xF.
##  @param[out] total_out Total output entries.
##

proc btdrvAcquireAudioConnectionStateChangedEvent*(outEvent: ptr Event;
    autoclear: bool): Result {.cdecl, importc: "btdrvAcquireAudioConnectionStateChangedEvent".}
## *
##  @brief AcquireAudioConnectionStateChangedEvent
##  @note Only available on [12.0.0-13.2.1].
##  @param[out] out_event Output Event.
##  @param[in] autoclear Event autoclear.
##

proc btdrvGetConnectedAudioDevice*(addrs: ptr BtdrvAddress; count: S32;
                                  totalOut: ptr S32): Result {.cdecl,
    importc: "btdrvGetConnectedAudioDevice".}
## *
##  @brief GetConnectedAudioDevice
##  @note Only available on [12.0.0-13.2.1].
##  @param[out] addrs Output array of \ref BtdrvAddress.
##  @param[in] count Size of the addrs array in entries, the maximum is 0x8.
##  @param[out] total_out Total output entries.
##

proc btdrvCloseAudioControlInput*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdrvCloseAudioControlInput".}
## *
##  @brief CloseAudioControlInput
##  @note Only available on [13.0.0+].
##  @param[in] addr \ref BtdrvAddress
##

proc btdrvRegisterAudioControlNotification*(`addr`: BtdrvAddress; eventType: U32): Result {.
    cdecl, importc: "btdrvRegisterAudioControlNotification".}
## *
##  @brief RegisterAudioControlNotification
##  @note Only available on [13.0.0+].
##  @param[in] addr \ref BtdrvAddress
##  @param[in] event_type AvrcEventType
##

proc btdrvSendAudioControlPassthroughCommand*(`addr`: BtdrvAddress; opId: U32;
    stateType: U32): Result {.cdecl,
                           importc: "btdrvSendAudioControlPassthroughCommand".}
## *
##  @brief SendAudioControlPassthroughCommand
##  @note Only available on [13.0.0+].
##  @param[in] addr \ref BtdrvAddress
##  @param[in] op_id AvrcOperationId
##  @param[in] state_type AvrcStateType
##

proc btdrvSendAudioControlSetAbsoluteVolumeCommand*(`addr`: BtdrvAddress; val: S32): Result {.
    cdecl, importc: "btdrvSendAudioControlSetAbsoluteVolumeCommand".}
## *
##  @brief SendAudioControlSetAbsoluteVolumeCommand
##  @note Only available on [13.0.0+].
##  @param[in] addr \ref BtdrvAddress
##  @param[in] val Input value
##

proc btdrvIsManufacturingMode*(`out`: ptr bool): Result {.cdecl,
    importc: "btdrvIsManufacturingMode".}
## *
##  @brief IsManufacturingMode
##  @note Only available on [5.0.0+].
##  @param[out] out Output flag.
##

proc btdrvEmulateBluetoothCrash*(reason: BtdrvFatalReason): Result {.cdecl,
    importc: "btdrvEmulateBluetoothCrash".}
## *
##  @brief EmulateBluetoothCrash
##  @note Only available on [7.0.0+].
##  @param[in] reason \ref BtdrvFatalReason
##

proc btdrvGetBleChannelMap*(`out`: ptr BtdrvChannelMapList): Result {.cdecl,
    importc: "btdrvGetBleChannelMap".}
## *
##  @brief GetBleChannelMap
##  @note Only available on [9.0.0+].
##  @param[out] out \ref BtdrvChannelMapList
##

proc btdrvCircularBufferRead*(c: ptr BtdrvCircularBuffer): pointer {.cdecl,
    importc: "btdrvCircularBufferRead".}
## /@name CircularBuffer
## /@{
## *
##  @brief Read
##  @note Used by \ref btdrvGetHidReportEventInfo on [7.0.0+].
##  @param c \ref BtdrvCircularBuffer
##

proc btdrvCircularBufferFree*(c: ptr BtdrvCircularBuffer): bool {.cdecl,
    importc: "btdrvCircularBufferFree".}
## *
##  @brief Free
##  @note Used by \ref btdrvGetHidReportEventInfo on [7.0.0+].
##  @param c \ref BtdrvCircularBuffer
##

## /@}
