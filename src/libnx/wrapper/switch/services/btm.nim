## *
##  @file btm.h
##  @brief btm service IPC wrapper.
##  @note See also: https://switchbrew.org/wiki/BTM_services
##  @author yellows8
##

import
  ../types, ../kernel/event, ../services/btdrv_types, ../services/btm_types,
  ../sf/service
proc btmInitialize*(): Result {.cdecl, importc: "btmInitialize".}
## / Initialize btm.

proc btmExit*() {.cdecl, importc: "btmExit".}
## / Exit btm.

proc btmGetServiceSession*(): ptr Service {.cdecl, importc: "btmGetServiceSession".}
## / Gets the Service object for the actual btm service session.

proc btmGetState*(`out`: ptr BtmState): Result {.cdecl, importc: "btmGetState".}
## *
##  @brief GetState
##  @param[out] out \ref BtmState
##

proc btmGetHostDeviceProperty*(`out`: ptr BtmHostDeviceProperty): Result {.cdecl,
    importc: "btmGetHostDeviceProperty".}
## *
##  @brief GetHostDeviceProperty
##  @param[out] out \ref BtmHostDeviceProperty
##

proc btmAcquireDeviceConditionEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmAcquireDeviceConditionEvent".}
## *
##  @brief AcquireDeviceConditionEvent
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmLegacyGetDeviceCondition*(`out`: ptr BtmDeviceCondition): Result {.cdecl,
    importc: "btmLegacyGetDeviceCondition".}
## *
##  @brief GetDeviceCondition [1.0.0-12.1.0]
##  @param[out] out \ref BtmDeviceCondition
##

proc btmGetDeviceCondition*(profile: BtmProfile; `out`: ptr BtmConnectedDeviceV13;
                           count: csize_t; totalOut: ptr S32): Result {.cdecl,
    importc: "btmGetDeviceCondition".}
## *
##  @brief GetDeviceCondition [13.0.0+]
##  @param[in] profile \ref BtmProfile, when not ::BtmProfile_None entries are only returned which match this profile.
##  @param[out] out \ref BtmConnectedDeviceV13
##  @param[in] count Size of the out array in entries.
##  @param[out] total_out Total output entries.
##

proc btmSetBurstMode*(`addr`: BtdrvAddress; flag: bool): Result {.cdecl,
    importc: "btmSetBurstMode".}
## *
##  @brief SetBurstMode
##  @param[in] addr \ref BtdrvAddress
##  @param[in] flag Flag
##

proc btmSetSlotMode*(list: ptr BtmDeviceSlotModeList): Result {.cdecl,
    importc: "btmSetSlotMode".}
## *
##  @brief SetSlotMode
##  @param[in] list \ref BtmDeviceSlotModeList
##

proc btmSetBluetoothMode*(mode: BtmBluetoothMode): Result {.cdecl,
    importc: "btmSetBluetoothMode".}
## *
##  @brief SetBluetoothMode
##  @note Only available on pre-9.0.0.
##  @param[in] mode \ref BtmBluetoothMode
##

proc btmSetWlanMode*(mode: BtmWlanMode): Result {.cdecl, importc: "btmSetWlanMode".}
## *
##  @brief SetWlanMode
##  @param[in] mode \ref BtmWlanMode
##

proc btmAcquireDeviceInfoEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmAcquireDeviceInfoEvent".}
## *
##  @brief AcquireDeviceInfoEvent
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmLegacyGetDeviceInfo*(`out`: ptr BtmDeviceInfoList): Result {.cdecl,
    importc: "btmLegacyGetDeviceInfo".}
## *
##  @brief GetDeviceInfo [1.0.0-12.1.0]
##  @param[out] out \ref BtmDeviceInfoList
##

proc btmGetDeviceInfo*(profile: BtmProfile; `out`: ptr BtmDeviceInfoV13;
                      count: csize_t; totalOut: ptr S32): Result {.cdecl,
    importc: "btmGetDeviceInfo".}
## *
##  @brief GetDeviceInfo [13.0.0+]
##  @param[in] profile \ref BtmProfile, when not ::BtmProfile_None entries are only returned which match this profile.
##  @param[out] out \ref BtmDeviceInfoV13
##  @param[in] count Size of the out array in entries.
##  @param[out] total_out Total output entries.
##

proc btmAddDeviceInfo*(info: ptr BtmDeviceInfo): Result {.cdecl,
    importc: "btmAddDeviceInfo".}
## *
##  @brief AddDeviceInfo
##  @param[in] info \ref BtmDeviceInfo
##

proc btmRemoveDeviceInfo*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btmRemoveDeviceInfo".}
## *
##  @brief RemoveDeviceInfo
##  @param[in] addr \ref BtdrvAddress
##

proc btmIncreaseDeviceInfoOrder*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btmIncreaseDeviceInfoOrder".}
## *
##  @brief IncreaseDeviceInfoOrder
##  @param[in] addr \ref BtdrvAddress
##

proc btmLlrNotify*(`addr`: BtdrvAddress; unk: S32): Result {.cdecl,
    importc: "btmLlrNotify".}
## *
##  @brief LlrNotify
##  @param[in] addr \ref BtdrvAddress
##  @param[in] unk [9.0.0+] Unknown
##

proc btmEnableRadio*(): Result {.cdecl, importc: "btmEnableRadio".}
## *
##  @brief EnableRadio
##

proc btmDisableRadio*(): Result {.cdecl, importc: "btmDisableRadio".}
## *
##  @brief DisableRadio
##

proc btmHidDisconnect*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btmHidDisconnect".}
## *
##  @brief HidDisconnect
##  @param[in] addr \ref BtdrvAddress
##

proc btmHidSetRetransmissionMode*(`addr`: BtdrvAddress;
                                 list: ptr BtmZeroRetransmissionList): Result {.
    cdecl, importc: "btmHidSetRetransmissionMode".}
## *
##  @brief HidSetRetransmissionMode
##  @param[in] addr \ref BtdrvAddress
##  @param[in] list \ref BtmZeroRetransmissionList
##

proc btmAcquireAwakeReqEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmAcquireAwakeReqEvent".}
## *
##  @brief AcquireAwakeReqEvent
##  @note Only available on [2.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmAcquireLlrStateEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmAcquireLlrStateEvent".}
## *
##  @brief AcquireLlrStateEvent
##  @note Only available on [4.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmIsLlrStarted*(`out`: ptr bool): Result {.cdecl, importc: "btmIsLlrStarted".}
## *
##  @brief IsLlrStarted
##  @note Only available on [4.0.0+].
##  @param[out] out Output flag.
##

proc btmEnableSlotSaving*(flag: bool): Result {.cdecl, importc: "btmEnableSlotSaving".}
## *
##  @brief EnableSlotSaving
##  @note Only available on [4.0.0+].
##  @param[in] flag Flag
##

proc btmProtectDeviceInfo*(`addr`: BtdrvAddress; flag: bool): Result {.cdecl,
    importc: "btmProtectDeviceInfo".}
## *
##  @brief ProtectDeviceInfo
##  @note Only available on [5.0.0+].
##  @param[in] addr \ref BtdrvAddress
##  @param[in] flag Flag
##

proc btmAcquireBleScanEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmAcquireBleScanEvent".}
## *
##  @brief AcquireBleScanEvent
##  @note Only available on [5.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmGetBleScanParameterGeneral*(parameterId: U16;
                                   `out`: ptr BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btmGetBleScanParameterGeneral".}
## *
##  @brief GetBleScanParameterGeneral
##  @note Only available on [5.1.0+].
##  @param[in] parameter_id Must be value 0x1 or 0xFFFF.
##  @param[out] out \ref BtdrvBleAdvertisePacketParameter
##

proc btmGetBleScanParameterSmartDevice*(parameterId: U16;
                                       `out`: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btmGetBleScanParameterSmartDevice".}
## *
##  @brief GetBleScanParameterSmartDevice
##  @note Only available on [5.1.0+].
##  @param[in] parameter_id Must be value 0x2.
##  @param[out] out \ref BtdrvGattAttributeUuid. The first 4-bytes is always 0.
##

proc btmStartBleScanForGeneral*(param: BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btmStartBleScanForGeneral".}
## *
##  @brief StartBleScanForGeneral
##  @note Only available on [5.1.0+].
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmStopBleScanForGeneral*(): Result {.cdecl,
                                        importc: "btmStopBleScanForGeneral".}
## *
##  @brief StopBleScanForGeneral
##  @note Only available on [5.1.0+].
##

proc btmGetBleScanResultsForGeneral*(results: ptr BtdrvBleScanResult; count: U8;
                                    totalOut: ptr U8): Result {.cdecl,
    importc: "btmGetBleScanResultsForGeneral".}
## *
##  @brief GetBleScanResultsForGeneral
##  @note Only available on [5.1.0+].
##  @param[out] results Output array of \ref BtdrvBleScanResult.
##  @param[in] count Size of the results array in entries. The max is 10.
##  @param[out] total_out Total output entries.
##

proc btmStartBleScanForPaired*(param: BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btmStartBleScanForPaired".}
## *
##  @brief StartBleScanForPaired
##  @note Only available on [5.1.0+].
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmStopBleScanForPaired*(): Result {.cdecl, importc: "btmStopBleScanForPaired".}
## *
##  @brief StopBleScanForPaired
##  @note Only available on [5.1.0+].
##

proc btmStartBleScanForSmartDevice*(uuid: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btmStartBleScanForSmartDevice".}
## *
##  @brief StartBleScanForSmartDevice
##  @note Only available on [5.1.0+].
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btmStopBleScanForSmartDevice*(): Result {.cdecl,
    importc: "btmStopBleScanForSmartDevice".}
## *
##  @brief StopBleScanForSmartDevice
##  @note Only available on [5.1.0+].
##

proc btmGetBleScanResultsForSmartDevice*(results: ptr BtdrvBleScanResult; count: U8;
                                        totalOut: ptr U8): Result {.cdecl,
    importc: "btmGetBleScanResultsForSmartDevice".}
## *
##  @brief GetBleScanResultsForSmartDevice
##  @note Only available on [5.1.0+].
##  @param[out] results Output array of \ref BtdrvBleScanResult.
##  @param[in] count Size of the results array in entries. The max is 10.
##  @param[out] total_out Total output entries.
##

proc btmAcquireBleConnectionEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmAcquireBleConnectionEvent".}
## *
##  @brief AcquireBleConnectionEvent
##  @note Only available on [5.1.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmBleConnect*(`addr`: BtdrvAddress): Result {.cdecl, importc: "btmBleConnect".}
## *
##  @brief BleConnect
##  @note Only available on [5.0.0+].
##  @note The \ref BtdrvAddress must not be already connected. A maximum of 4 devices can be connected.
##  @param[in] addr \ref BtdrvAddress
##

proc btmBleOverrideConnection*(id: U32): Result {.cdecl,
    importc: "btmBleOverrideConnection".}
## *
##  @brief BleOverrideConnection
##  @note Only available on [5.1.0+].
##  @param[in] id Same as \ref btmBleDisconnect.
##

proc btmBleDisconnect*(connectionHandle: U32): Result {.cdecl,
    importc: "btmBleDisconnect".}
## *
##  @brief BleDisconnect
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle This must match a BtdrvBleConnectionInfo::id from \ref btmBleGetConnectionState. [5.1.0+] 0xFFFFFFFF is invalid.
##

proc btmBleGetConnectionState*(info: ptr BtdrvBleConnectionInfo; count: U8;
                              totalOut: ptr U8): Result {.cdecl,
    importc: "btmBleGetConnectionState".}
## *
##  @brief BleGetConnectionState
##  @note Only available on [5.0.0+].
##  @param[out] info Output array of \ref BtdrvBleConnectionInfo.
##  @param[in] count Size of the info array in entries. Other cmds which use this internally use count=4.
##  @param[out] total_out Total output entries.
##

proc btmBleGetGattClientConditionList*(list: ptr BtmGattClientConditionList): Result {.
    cdecl, importc: "btmBleGetGattClientConditionList".}
## *
##  @brief BleGetGattClientConditionList
##  @note Only available on [5.0.0+].
##  @param[out] list \ref BtmGattClientConditionList
##

proc btmAcquireBlePairingEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmAcquireBlePairingEvent".}
## *
##  @brief AcquireBlePairingEvent
##  @note Only available on [5.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmBlePairDevice*(connectionHandle: U32;
                      param: BtdrvBleAdvertisePacketParameter): Result {.cdecl,
    importc: "btmBlePairDevice".}
## *
##  @brief BlePairDevice
##  @note Only available on [5.1.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmBleUnpairDeviceOnBoth*(connectionHandle: U32;
                              param: BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btmBleUnpairDeviceOnBoth".}
## *
##  @brief BleUnpairDeviceOnBoth
##  @note Only available on [5.1.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmBleUnPairDevice*(`addr`: BtdrvAddress;
                        param: BtdrvBleAdvertisePacketParameter): Result {.cdecl,
    importc: "btmBleUnPairDevice".}
## *
##  @brief BleUnPairDevice
##  @note Only available on [5.1.0+].
##  @param[in] addr \ref BtdrvAddress
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmBleGetPairedAddresses*(param: BtdrvBleAdvertisePacketParameter;
                              addrs: ptr BtdrvAddress; count: U8; totalOut: ptr U8): Result {.
    cdecl, importc: "btmBleGetPairedAddresses".}
## *
##  @brief BleGetPairedAddresses
##  @note Only available on [5.1.0+].
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##  @param[out] addrs Output array of \ref BtdrvAddress.
##  @param[in] count Size of the addrs array in entries.
##  @param[out] total_out Total output entries. The max is 10.
##

proc btmAcquireBleServiceDiscoveryEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmAcquireBleServiceDiscoveryEvent".}
## *
##  @brief AcquireBleServiceDiscoveryEvent
##  @note Only available on [5.1.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmGetGattServices*(connectionHandle: U32; services: ptr BtmGattService;
                        count: U8; totalOut: ptr U8): Result {.cdecl,
    importc: "btmGetGattServices".}
## *
##  @brief GetGattServices
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[out] services Output array of \ref BtmGattService.
##  @param[in] count Size of the services array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btmGetGattService*(connectionHandle: U32; uuid: ptr BtdrvGattAttributeUuid;
                       service: ptr BtmGattService; flag: ptr bool): Result {.cdecl,
    importc: "btmGetGattService".}
## *
##  @brief Same as \ref btmGetGattServices except this only returns the \ref BtmGattService which matches the input \ref BtdrvGattAttributeUuid.
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[out] service \ref BtmGattService
##  @param[out] flag Whether a \ref BtmGattService was returned.
##

proc btmGetGattIncludedServices*(connectionHandle: U32; serviceHandle: U16;
                                services: ptr BtmGattService; count: U8;
                                `out`: ptr U8): Result {.cdecl,
    importc: "btmGetGattIncludedServices".}
## *
##  @brief Same as \ref btmGetGattServices except this only returns \ref BtmGattService entries where various checks pass with u16 fields.
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[in] service_handle ServiceHandle
##  @param[out] services \ref BtmGattService
##  @param[in] count Size of the services array in entries. The max is 100.
##  @param[out] out Output value.
##

proc btmGetBelongingService*(connectionHandle: U32; attributeHandle: U16;
                            service: ptr BtmGattService; flag: ptr bool): Result {.
    cdecl, importc: "btmGetBelongingService".}
## *
##  @brief This is similar to \ref btmGetGattIncludedServices except this only returns 1 \ref BtmGattService.
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[in] attribute_handle AttributeHandle
##  @param[out] service \ref BtmGattService
##  @param[out] flag Whether a \ref BtmGattService was returned.
##

proc btmGetGattCharacteristics*(connectionHandle: U32; serviceHandle: U16;
                               characteristics: ptr BtmGattCharacteristic;
                               count: U8; totalOut: ptr U8): Result {.cdecl,
    importc: "btmGetGattCharacteristics".}
## *
##  @brief GetGattCharacteristics
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[in] service_handle This controls which \ref BtmGattCharacteristic entries to return.
##  @param[out] characteristics \ref BtmGattCharacteristic
##  @param[in] count Size of the characteristics array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btmGetGattDescriptors*(connectionHandle: U32; charHandle: U16;
                           descriptors: ptr BtmGattDescriptor; count: U8;
                           totalOut: ptr U8): Result {.cdecl,
    importc: "btmGetGattDescriptors".}
## *
##  @brief GetGattDescriptors
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[in] char_handle Characteristic handle. This controls which \ref BtmGattDescriptor entries to return.
##  @param[out] descriptors \ref BtmGattDescriptor
##  @param[in] count Size of the descriptors array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btmAcquireBleMtuConfigEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmAcquireBleMtuConfigEvent".}
## *
##  @brief AcquireBleMtuConfigEvent
##  @note Only available on [5.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmConfigureBleMtu*(connectionHandle: U32; mtu: U16): Result {.cdecl,
    importc: "btmConfigureBleMtu".}
## *
##  @brief ConfigureBleMtu
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[in] mtu MTU
##

proc btmGetBleMtu*(connectionHandle: U32; `out`: ptr U16): Result {.cdecl,
    importc: "btmGetBleMtu".}
## *
##  @brief GetBleMtu
##  @note Only available on [5.0.0+].
##  @param[in] connection_handle Same as \ref btmBleDisconnect.
##  @param[out] out Output MTU.
##

proc btmRegisterBleGattDataPath*(path: ptr BtmBleDataPath): Result {.cdecl,
    importc: "btmRegisterBleGattDataPath".}
## *
##  @brief RegisterBleGattDataPath
##  @note Only available on [5.0.0+].
##  @param[in] path \ref BtmBleDataPath
##

proc btmUnregisterBleGattDataPath*(path: ptr BtmBleDataPath): Result {.cdecl,
    importc: "btmUnregisterBleGattDataPath".}
## *
##  @brief UnregisterBleGattDataPath
##  @note Only available on [5.0.0+].
##  @param[in] path \ref BtmBleDataPath
##

proc btmRegisterAppletResourceUserId*(appletResourceUserId: U64; unk: U32): Result {.
    cdecl, importc: "btmRegisterAppletResourceUserId".}
## *
##  @brief RegisterAppletResourceUserId
##  @note Only available on [5.0.0+].
##  @param[in] AppletResourceUserId AppletResourceUserId
##  @param[in] unk Unknown
##

proc btmUnregisterAppletResourceUserId*(appletResourceUserId: U64): Result {.cdecl,
    importc: "btmUnregisterAppletResourceUserId".}
## *
##  @brief UnregisterAppletResourceUserId
##  @note Only available on [5.0.0+].
##  @param[in] AppletResourceUserId AppletResourceUserId
##

proc btmSetAppletResourceUserId*(appletResourceUserId: U64): Result {.cdecl,
    importc: "btmSetAppletResourceUserId".}
## *
##  @brief SetAppletResourceUserId
##  @note Only available on [5.0.0+].
##  @param[in] AppletResourceUserId AppletResourceUserId
##

