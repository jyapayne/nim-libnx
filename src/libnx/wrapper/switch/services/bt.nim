## *
##  @file bt.h
##  @brief Bluetooth user (bt) service IPC wrapper.
##  @note See also btdev.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../sf/service, ../services/btdrv_types

proc btInitialize*(): Result {.cdecl, importc: "btInitialize".}
## / Initialize bt. Only available on [5.0.0+].

proc btExit*() {.cdecl, importc: "btExit".}
## / Exit bt.

proc btGetServiceSession*(): ptr Service {.cdecl, importc: "btGetServiceSession".}
## / Gets the Service object for the actual bt service session.

proc btLeClientReadCharacteristic*(connectionHandle: U32; primaryService: bool;
                                  id0: ptr BtdrvGattId; id1: ptr BtdrvGattId; unk: U8): Result {.
    cdecl, importc: "btLeClientReadCharacteristic".}
## *
##  @brief LeClientReadCharacteristic
##  @note This is essentially the same as \ref btdrvReadGattCharacteristic.
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] unk Unknown
##

proc btLeClientReadDescriptor*(connectionHandle: U32; primaryService: bool;
                              id0: ptr BtdrvGattId; id1: ptr BtdrvGattId;
                              id2: ptr BtdrvGattId; unk: U8): Result {.cdecl,
    importc: "btLeClientReadDescriptor".}
## *
##  @brief LeClientReadDescriptor
##  @note This is essentially the same as \ref btdrvReadGattDescriptor.
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] id2 \ref BtdrvGattId
##  @param[in] unk Unknown
##

proc btLeClientWriteCharacteristic*(connectionHandle: U32; primaryService: bool;
                                   id0: ptr BtdrvGattId; id1: ptr BtdrvGattId;
                                   buffer: pointer; size: csize_t; unk: U8; flag: bool): Result {.
    cdecl, importc: "btLeClientWriteCharacteristic".}
## *
##  @brief LeClientWriteCharacteristic
##  @note This is essentially the same as \ref btdrvWriteGattCharacteristic.
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size, must be <=0x258.
##  @param[in] unk Unknown
##  @param[in] flag Flag
##

proc btLeClientWriteDescriptor*(connectionHandle: U32; primaryService: bool;
                               id0: ptr BtdrvGattId; id1: ptr BtdrvGattId;
                               id2: ptr BtdrvGattId; buffer: pointer; size: csize_t;
                               unk: U8): Result {.cdecl,
    importc: "btLeClientWriteDescriptor".}
## *
##  @brief LeClientWriteDescriptor
##  @note This is essentially the same as \ref btdrvWriteGattDescriptor.
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##  @param[in] id2 \ref BtdrvGattId
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size, must be <=0x258.
##  @param[in] unk Unknown
##

proc btLeClientRegisterNotification*(connectionHandle: U32; primaryService: bool;
                                    id0: ptr BtdrvGattId; id1: ptr BtdrvGattId): Result {.
    cdecl, importc: "btLeClientRegisterNotification".}
## *
##  @brief LeClientRegisterNotification
##  @note This is essentially the same as \ref btdrvRegisterGattNotification.
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##

proc btLeClientDeregisterNotification*(connectionHandle: U32; primaryService: bool;
                                      id0: ptr BtdrvGattId; id1: ptr BtdrvGattId): Result {.
    cdecl, importc: "btLeClientDeregisterNotification".}
## *
##  @brief LeClientDeregisterNotification
##  @note This is essentially the same as \ref btdrvUnregisterGattNotification.
##  @param[in] connection_handle ConnectionHandle
##  @param[in] primary_service PrimaryService
##  @param[in] id0 \ref BtdrvGattId
##  @param[in] id1 \ref BtdrvGattId
##

proc btSetLeResponse*(unk: U8; uuid0: ptr BtdrvGattAttributeUuid;
                     uuid1: ptr BtdrvGattAttributeUuid; buffer: pointer;
                     size: csize_t): Result {.cdecl, importc: "btSetLeResponse".}
## *
##  @brief SetLeResponse
##  @param[in] unk Unknown
##  @param[in] uuid0 \ref BtdrvGattAttributeUuid
##  @param[in] uuid1 \ref BtdrvGattAttributeUuid
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size, must be <=0x258.
##

proc btLeSendIndication*(unk: U8; uuid0: ptr BtdrvGattAttributeUuid;
                        uuid1: ptr BtdrvGattAttributeUuid; buffer: pointer;
                        size: csize_t; flag: bool): Result {.cdecl,
    importc: "btLeSendIndication".}
## *
##  @brief LeSendIndication
##  @param[in] unk Unknown
##  @param[in] uuid0 \ref BtdrvGattAttributeUuid
##  @param[in] uuid1 \ref BtdrvGattAttributeUuid
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size, clamped to max size 0x258.
##  @param[in] flag Flag
##

proc btGetLeEventInfo*(buffer: pointer; size: csize_t; `type`: ptr U32): Result {.cdecl,
    importc: "btGetLeEventInfo".}
## *
##  @brief GetLeEventInfo
##  @note This is identical to \ref btdrvGetLeHidEventInfo except different state is used.
##  @note The state used by this is reset after writing the data to output.
##  @param[in] buffer Output buffer. 0x400-bytes from state is written here. See \ref BtdrvLeEventInfo.
##  @param[in] size Output buffer size.
##  @param[out] type Output BleEventType.
##

proc btRegisterBleEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btRegisterBleEvent".}
## *
##  @brief RegisterBleEvent
##  @note This is identical to \ref btdrvRegisterBleHidEvent except different state is used.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

