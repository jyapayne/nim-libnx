## *
##  @file btmu.h
##  @brief btm:u (btm user) service IPC wrapper.
##  @note Only available on [5.0.0+].
##  @note See also btdev.
##  @note See also: https://switchbrew.org/wiki/BTM_services
##  @author yellows8
##

import
  ../types, ../kernel/event, ../services/btdrv_types, ../services/btm_types, ../sf/service
proc btmuInitialize*(): Result {.cdecl, importc: "btmuInitialize".}
## / Initialize btm:u.

proc btmuExit*() {.cdecl, importc: "btmuExit".}
## / Exit btm:u.

proc btmuGetServiceSession*(srvOut: ptr Service): Result {.cdecl,
    importc: "btmuGetServiceSession".}
## / Gets the Service object for the actual btm:u service session. This object must be closed by the user once finished using cmds with this.

proc btmuGetServiceSessionIBtmUserCore*(): ptr Service {.cdecl,
    importc: "btmuGetServiceSession_IBtmUserCore".}
## / Gets the Service object for IBtmUserCore.

proc btmuAcquireBleScanEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmuAcquireBleScanEvent".}
## *
##  @brief AcquireBleScanEvent
##  @note This is similar to \ref btmAcquireBleScanEvent.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmuGetBleScanFilterParameter*(parameterId: U16;
                                   `out`: ptr BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btmuGetBleScanFilterParameter".}
## *
##  @brief GetBleScanFilterParameter
##  @note This is the same as \ref btmGetBleScanParameterGeneral.
##  @param[in] parameter_id Must be value 0x1 or 0xFFFF.
##  @param[out] out \ref BtdrvBleAdvertisePacketParameter
##

proc btmuGetBleScanFilterParameter2*(parameterId: U16;
                                    `out`: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btmuGetBleScanFilterParameter2".}
## *
##  @brief GetBleScanFilterParameter2
##  @note This is the same as \ref btmGetBleScanParameterSmartDevice.
##  @param[in] parameter_id Must be value 0x2.
##  @param[out] out \ref BtdrvGattAttributeUuid. The first 4-bytes is always 0.
##

proc btmuStartBleScanForGeneral*(param: BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btmuStartBleScanForGeneral".}
## *
##  @brief StartBleScanForGeneral
##  @note This is similar to \ref btmStartBleScanForGeneral.
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmuStopBleScanForGeneral*(): Result {.cdecl,
    importc: "btmuStopBleScanForGeneral".}
## *
##  @brief StopBleScanForGeneral
##  @note This is similar to \ref btmStopBleScanForGeneral.
##

proc btmuGetBleScanResultsForGeneral*(results: ptr BtdrvBleScanResult; count: U8;
                                     totalOut: ptr U8): Result {.cdecl,
    importc: "btmuGetBleScanResultsForGeneral".}
## *
##  @brief GetBleScanResultsForGeneral
##  @note This is similar to \ref btmGetBleScanResultsForGeneral.
##  @param[out] results Output array of \ref BtdrvBleScanResult.
##  @param[in] count Size of the results array in entries. The max is 10.
##  @param[out] total_out Total output entries.
##

proc btmuStartBleScanForPaired*(param: BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btmuStartBleScanForPaired".}
## *
##  @brief StartBleScanForPaired
##  @note This is similar to \ref btmStartBleScanForPaired.
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmuStopBleScanForPaired*(): Result {.cdecl,
                                        importc: "btmuStopBleScanForPaired".}
## *
##  @brief StopBleScanForPaired
##  @note This is similar to \ref btmStopBleScanForPaired.
##

proc btmuStartBleScanForSmartDevice*(uuid: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btmuStartBleScanForSmartDevice".}
## *
##  @brief StartBleScanForSmartDevice
##  @note This is similar to \ref btmStartBleScanForSmartDevice.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btmuStopBleScanForSmartDevice*(): Result {.cdecl,
    importc: "btmuStopBleScanForSmartDevice".}
## *
##  @brief StopBleScanForSmartDevice
##  @note This is similar to \ref btmStopBleScanForSmartDevice.
##

proc btmuGetBleScanResultsForSmartDevice*(results: ptr BtdrvBleScanResult;
    count: U8; totalOut: ptr U8): Result {.cdecl, importc: "btmuGetBleScanResultsForSmartDevice".}
## *
##  @brief GetBleScanResultsForSmartDevice
##  @note This is similar to \ref btmGetBleScanResultsForSmartDevice.
##  @param[out] results Output array of \ref BtdrvBleScanResult.
##  @param[in] count Size of the results array in entries. The max is 10.
##  @param[out] total_out Total output entries.
##

proc btmuAcquireBleConnectionEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmuAcquireBleConnectionEvent".}
## *
##  @brief AcquireBleConnectionEvent
##  @note This is similar to \ref btmAcquireBleConnectionEvent.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmuBleConnect*(`addr`: BtdrvAddress): Result {.cdecl, importc: "btmuBleConnect".}
## *
##  @brief BleConnect
##  @note This is similar to \ref btmBleConnect.
##  @param[in] addr \ref BtdrvAddress
##

proc btmuBleDisconnect*(connectionHandle: U32): Result {.cdecl,
    importc: "btmuBleDisconnect".}
## *
##  @brief BleDisconnect
##  @note This is similar to \ref btmBleDisconnect.
##  @param[in] connection_handle This must match a BtdrvBleConnectionInfo::connection_handle from \ref btmuBleGetConnectionState. [5.1.0+] 0xFFFFFFFF is invalid.
##

proc btmuBleGetConnectionState*(info: ptr BtdrvBleConnectionInfo; count: U8;
                               totalOut: ptr U8): Result {.cdecl,
    importc: "btmuBleGetConnectionState".}
## *
##  @brief BleGetConnectionState
##  @note This is similar to \ref btmBleGetConnectionState.
##  @param[out] info Output array of \ref BtdrvBleConnectionInfo.
##  @param[in] count Size of the info array in entries. Other cmds which use this internally use count=4.
##  @param[out] total_out Total output entries.
##

proc btmuAcquireBlePairingEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmuAcquireBlePairingEvent".}
## *
##  @brief AcquireBlePairingEvent
##  @note This is similar to \ref btmAcquireBlePairingEvent.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmuBlePairDevice*(connectionHandle: U32;
                       param: BtdrvBleAdvertisePacketParameter): Result {.cdecl,
    importc: "btmuBlePairDevice".}
## *
##  @brief BlePairDevice
##  @note This is similar to \ref btmBlePairDevice.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmuBleUnPairDevice*(connectionHandle: U32;
                         param: BtdrvBleAdvertisePacketParameter): Result {.cdecl,
    importc: "btmuBleUnPairDevice".}
## *
##  @brief BleUnPairDevice
##  @note This is similar to \ref btmBleUnpairDeviceOnBoth.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmuBleUnPairDevice2*(`addr`: BtdrvAddress;
                          param: BtdrvBleAdvertisePacketParameter): Result {.cdecl,
    importc: "btmuBleUnPairDevice2".}
## *
##  @brief BleUnPairDevice2
##  @note This is similar to \ref btmBleUnPairDevice.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##

proc btmuBleGetPairedDevices*(param: BtdrvBleAdvertisePacketParameter;
                             addrs: ptr BtdrvAddress; count: U8; totalOut: ptr U8): Result {.
    cdecl, importc: "btmuBleGetPairedDevices".}
## *
##  @brief BleGetPairedDevices
##  @note This is similar to \ref btmBleGetPairedAddresses.
##  @param[in] param \ref BtdrvBleAdvertisePacketParameter
##  @param[out] addrs Output array of \ref BtdrvAddress.
##  @param[in] count Size of the addrs array in entries.
##  @param[out] total_out Total output entries. The max is 10.
##

proc btmuAcquireBleServiceDiscoveryEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmuAcquireBleServiceDiscoveryEvent".}
## *
##  @brief AcquireBleServiceDiscoveryEvent
##  @note This is similar to \ref btmAcquireBleServiceDiscoveryEvent.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmuGetGattServices*(connectionHandle: U32; services: ptr BtmGattService;
                         count: U8; totalOut: ptr U8): Result {.cdecl,
    importc: "btmuGetGattServices".}
## *
##  @brief GetGattServices
##  @note This is similar to \ref btmGetGattServices.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[out] services Output array of \ref BtmGattService.
##  @param[in] count Size of the services array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btmuGetGattService*(connectionHandle: U32; uuid: ptr BtdrvGattAttributeUuid;
                        service: ptr BtmGattService; flag: ptr bool): Result {.cdecl,
    importc: "btmuGetGattService".}
## *
##  @brief Same as \ref btmuGetGattServices except this only returns the \ref BtmGattService which matches the input \ref BtdrvGattAttributeUuid.
##  @note This is similar to \ref btmGetGattService.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[out] service \ref BtmGattService
##  @param[out] flag Whether a \ref BtmGattService was returned.
##

proc btmuGetGattIncludedServices*(connectionHandle: U32; serviceHandle: U16;
                                 services: ptr BtmGattService; count: U8;
                                 `out`: ptr U8): Result {.cdecl,
    importc: "btmuGetGattIncludedServices".}
## *
##  @brief Same as \ref btmuGetGattServices except this only returns \ref BtmGattService entries where various checks pass with u16 fields.
##  @note This is similar to \ref btmGetGattIncludedServices.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[in] service_handle ServiceHandle
##  @param[out] services \ref BtmGattService
##  @param[in] count Size of the services array in entries. The max is 100.
##  @param[out] out Output value.
##

proc btmuGetBelongingGattService*(connectionHandle: U32; attributeHandle: U16;
                                 service: ptr BtmGattService; flag: ptr bool): Result {.
    cdecl, importc: "btmuGetBelongingGattService".}
## *
##  @brief This is similar to \ref btmuGetGattIncludedServices except this only returns 1 \ref BtmGattService.
##  @note This is similar to \ref btmGetBelongingService.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[in] attribute_handle AttributeHandle
##  @param[out] service \ref BtmGattService
##  @param[out] flag Whether a \ref BtmGattService was returned.
##

proc btmuGetGattCharacteristics*(connectionHandle: U32; serviceHandle: U16;
                                characteristics: ptr BtmGattCharacteristic;
                                count: U8; totalOut: ptr U8): Result {.cdecl,
    importc: "btmuGetGattCharacteristics".}
## *
##  @brief GetGattCharacteristics
##  @note This is similar to \ref btmGetGattCharacteristics.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[in] service_handle This controls which \ref BtmGattCharacteristic entries to return.
##  @param[out] characteristics \ref BtmGattCharacteristic
##  @param[in] count Size of the characteristics array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btmuGetGattDescriptors*(connectionHandle: U32; charHandle: U16;
                            descriptors: ptr BtmGattDescriptor; count: U8;
                            totalOut: ptr U8): Result {.cdecl,
    importc: "btmuGetGattDescriptors".}
## *
##  @brief GetGattDescriptors
##  @note This is similar to \ref btmGetGattDescriptors.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[in] char_handle Characteristic handle. This controls which \ref BtmGattDescriptor entries to return.
##  @param[out] descriptors \ref BtmGattDescriptor
##  @param[in] count Size of the descriptors array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btmuAcquireBleMtuConfigEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmuAcquireBleMtuConfigEvent".}
## *
##  @brief AcquireBleMtuConfigEvent
##  @note This is similar to \ref btmAcquireBleMtuConfigEvent.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmuConfigureBleMtu*(connectionHandle: U32; mtu: U16): Result {.cdecl,
    importc: "btmuConfigureBleMtu".}
## *
##  @brief ConfigureBleMtu
##  @note This is similar to \ref btmConfigureBleMtu.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[in] mtu MTU
##

proc btmuGetBleMtu*(connectionHandle: U32; `out`: ptr U16): Result {.cdecl,
    importc: "btmuGetBleMtu".}
## *
##  @brief GetBleMtu
##  @note This is similar to \ref btmGetBleMtu.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[out] out Output MTU.
##

proc btmuRegisterBleGattDataPath*(path: ptr BtmBleDataPath): Result {.cdecl,
    importc: "btmuRegisterBleGattDataPath".}
## *
##  @brief RegisterBleGattDataPath
##  @note This is similar to \ref btmRegisterBleGattDataPath.
##  @param[in] path \ref BtmBleDataPath
##

proc btmuUnregisterBleGattDataPath*(path: ptr BtmBleDataPath): Result {.cdecl,
    importc: "btmuUnregisterBleGattDataPath".}
## *
##  @brief UnregisterBleGattDataPath
##  @note This is similar to \ref btmUnregisterBleGattDataPath.
##  @param[in] path \ref BtmBleDataPath
##

