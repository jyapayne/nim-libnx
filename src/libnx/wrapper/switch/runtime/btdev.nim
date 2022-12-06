## *
##  @file btdev.h
##  @brief Wrapper around the bt/btmu services for using bluetooth BLE.
##  @note Only available on [5.0.0+].
##  @note See also: https://switchbrew.org/wiki/BTM_services
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../services/btdrv_types

## / GattAttribute

type
  BtdevGattAttribute* {.bycopy.} = object
    `type`*: U8                ## /< Type
    uuid*: BtdrvGattAttributeUuid ## /< \ref BtdrvGattAttributeUuid
    handle*: U16               ## /< Handle
    connectionHandle*: U32     ## /< ConnectionHandle


## / GattService

type
  BtdevGattService* {.bycopy.} = object
    attr*: BtdevGattAttribute  ## /< \ref BtdevGattAttribute
    instanceId*: U16           ## /< InstanceId
    endGroupHandle*: U16       ## /< EndGroupHandle
    primaryService*: bool      ## /< PrimaryService


## / GattCharacteristic

type
  BtdevGattCharacteristic* {.bycopy.} = object
    attr*: BtdevGattAttribute  ## /< \ref BtdevGattAttribute
    instanceId*: U16           ## /< InstanceId
    properties*: U8            ## /< Properties
    valueSize*: U64            ## /< Size of value.
    value*: array[0x200, U8]    ## /< Value


## / GattDescriptor

type
  BtdevGattDescriptor* {.bycopy.} = object
    attr*: BtdevGattAttribute  ## /< \ref BtdevGattAttribute
    valueSize*: U64            ## /< Size of value.
    value*: array[0x200, U8]    ## /< Value

proc btdevInitialize*(): Result {.cdecl, importc: "btdevInitialize".}
## / Initialize bt/btmu.

proc btdevExit*() {.cdecl, importc: "btdevExit".}
## / Exit bt/btmu.

proc btdevGattAttributeUuidIsSame*(a: ptr BtdrvGattAttributeUuid;
                                  b: ptr BtdrvGattAttributeUuid): bool {.cdecl,
    importc: "btdevGattAttributeUuidIsSame".}
## / Compares two \ref BtdrvGattAttributeUuid, returning whether these match.

proc btdevAcquireBleScanEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdevAcquireBleScanEvent".}
## / Wrapper for \ref btmuAcquireBleScanEvent.

proc btdevGetBleScanParameter*(parameterId: U16;
                              `out`: ptr BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btdevGetBleScanParameter".}
## / Wrapper for \ref btmuGetBleScanFilterParameter.

proc btdevGetBleScanParameter2*(parameterId: U16; `out`: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btdevGetBleScanParameter2".}
## / Wrapper for \ref btmuGetBleScanFilterParameter2.

proc btdevStartBleScanGeneral*(param: BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btdevStartBleScanGeneral".}
## / Wrapper for \ref btdevStartBleScanGeneral.

proc btdevStopBleScanGeneral*(): Result {.cdecl, importc: "btdevStopBleScanGeneral".}
## / Wrapper for \ref btmuStopBleScanForGeneral.

proc btdevGetBleScanResult*(results: ptr BtdrvBleScanResult; count: U8;
                           totalOut: ptr U8): Result {.cdecl,
    importc: "btdevGetBleScanResult".}
## *
##  @brief Wrapper for \ref btmuGetBleScanResultsForGeneral and \ref btmuGetBleScanResultsForSmartDevice.
##  @param[out] results Output array of \ref BtdrvBleScanResult.
##  @param[in] count Size of the results array in entries.
##  @param[out] total_out Total output entries.
##

proc btdevEnableBleAutoConnection*(param: BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btdevEnableBleAutoConnection".}
## / Wrapper for \ref btmuStartBleScanForPaired.

proc btdevDisableBleAutoConnection*(): Result {.cdecl,
    importc: "btdevDisableBleAutoConnection".}
## / Wrapper for \ref btmuStopBleScanForPaired.

proc btdevStartBleScanSmartDevice*(uuid: ptr BtdrvGattAttributeUuid): Result {.cdecl,
    importc: "btdevStartBleScanSmartDevice".}
## / Wrapper for \ref btmuStartBleScanForSmartDevice.

proc btdevStopBleScanSmartDevice*(): Result {.cdecl,
    importc: "btdevStopBleScanSmartDevice".}
## / Wrapper for \ref btmuStopBleScanForSmartDevice.

proc btdevAcquireBleConnectionStateChangedEvent*(outEvent: ptr Event): Result {.
    cdecl, importc: "btdevAcquireBleConnectionStateChangedEvent".}
## / Wrapper for \ref btmuAcquireBleConnectionEvent.

proc btdevConnectToGattServer*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "btdevConnectToGattServer".}
## / Wrapper for \ref btmuBleConnect.

proc btdevDisconnectFromGattServer*(connectionHandle: U32): Result {.cdecl,
    importc: "btdevDisconnectFromGattServer".}
## / Wrapper for \ref btmuBleDisconnect.

proc btdevGetBleConnectionInfoList*(info: ptr BtdrvBleConnectionInfo; count: U8;
                                   totalOut: ptr U8): Result {.cdecl,
    importc: "btdevGetBleConnectionInfoList".}
## / Wrapper for \ref btmuBleGetConnectionState.

proc btdevAcquireBleServiceDiscoveryEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdevAcquireBleServiceDiscoveryEvent".}
## / Wrapper for \ref btmuAcquireBleServiceDiscoveryEvent.

proc btdevGetGattServices*(connectionHandle: U32; services: ptr BtdevGattService;
                          count: U8; totalOut: ptr U8): Result {.cdecl,
    importc: "btdevGetGattServices".}
## *
##  @brief Wrapper for \ref btmuGetGattServices.
##  @param[in] connection_handle ConnectionHandle
##  @param[out] services Output array of \ref BtdevGattService.
##  @param[in] count Size of the services array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btdevGetGattService*(connectionHandle: U32; uuid: ptr BtdrvGattAttributeUuid;
                         service: ptr BtdevGattService; flag: ptr bool): Result {.
    cdecl, importc: "btdevGetGattService".}
## *
##  @brief Wrapper for \ref btmuGetGattService.
##  @param[in] connection_handle ConnectionHandle
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[out] service \ref BtdevGattService
##  @param[out] flag Whether a \ref BtdevGattService was returned.
##

proc btdevAcquireBlePairingEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdevAcquireBlePairingEvent".}
## / Wrapper for \ref btmuAcquireBlePairingEvent.

proc btdevPairGattServer*(connectionHandle: U32;
                         param: BtdrvBleAdvertisePacketParameter): Result {.cdecl,
    importc: "btdevPairGattServer".}
## / Wrapper for \ref btmuBlePairDevice.

proc btdevUnpairGattServer*(connectionHandle: U32;
                           param: BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btdevUnpairGattServer".}
## / Wrapper for \ref btmuBleUnPairDevice.

proc btdevUnpairGattServer2*(`addr`: BtdrvAddress;
                            param: BtdrvBleAdvertisePacketParameter): Result {.
    cdecl, importc: "btdevUnpairGattServer2".}
## / Wrapper for \ref btmuBleUnPairDevice2.

proc btdevGetPairedGattServerAddress*(param: BtdrvBleAdvertisePacketParameter;
                                     addrs: ptr BtdrvAddress; count: U8;
                                     totalOut: ptr U8): Result {.cdecl,
    importc: "btdevGetPairedGattServerAddress".}
## / Wrapper for \ref btmuBleGetPairedDevices.

proc btdevAcquireBleMtuConfigEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdevAcquireBleMtuConfigEvent".}
## / Wrapper for \ref btmuAcquireBleMtuConfigEvent.

proc btdevConfigureBleMtu*(connectionHandle: U32; mtu: U16): Result {.cdecl,
    importc: "btdevConfigureBleMtu".}
## *
##  @brief Wrapper for \ref btmuConfigureBleMtu.
##  @param[in] connection_handle Same as \ref btmuBleDisconnect.
##  @param[in] mtu MTU, must be 0x18-0x200.
##

proc btdevGetBleMtu*(connectionHandle: U32; `out`: ptr U16): Result {.cdecl,
    importc: "btdevGetBleMtu".}
## / Wrapper for \ref btmuGetBleMtu.

proc btdevAcquireBleGattOperationEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btdevAcquireBleGattOperationEvent".}
## / Wrapper for \ref btRegisterBleEvent.

proc btdevRegisterGattOperationNotification*(uuid: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btdevRegisterGattOperationNotification".}
## *
##  @brief Wrapper for \ref btmuRegisterBleGattDataPath.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdevUnregisterGattOperationNotification*(uuid: ptr BtdrvGattAttributeUuid): Result {.
    cdecl, importc: "btdevUnregisterGattOperationNotification".}
## *
##  @brief Wrapper for \ref btmuUnregisterBleGattDataPath.
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##

proc btdevGetGattOperationResult*(`out`: ptr BtdrvBleClientGattOperationInfo): Result {.
    cdecl, importc: "btdevGetGattOperationResult".}
## *
##  @brief Wrapper for \ref btGetLeEventInfo.
##  @param[out] out \ref BtdrvBleClientGattOperationInfo
##

proc btdevReadGattCharacteristic*(c: ptr BtdevGattCharacteristic): Result {.cdecl,
    importc: "btdevReadGattCharacteristic".}
## *
##  @brief Wrapper for \ref btLeClientReadCharacteristic.
##  @note An error is thrown if the properties from \ref btdevGattCharacteristicGetProperties don't allow using this.
##  @param c \ref BtdevGattCharacteristic
##

proc btdevWriteGattCharacteristic*(c: ptr BtdevGattCharacteristic): Result {.cdecl,
    importc: "btdevWriteGattCharacteristic".}
## *
##  @brief Wrapper for \ref btLeClientWriteCharacteristic.
##  @note An error is thrown if the properties from \ref btdevGattCharacteristicGetProperties don't allow using this.
##  @note This uses the Value from \ref btdevGattCharacteristicSetValue.
##  @param c \ref BtdevGattCharacteristic
##

proc btdevEnableGattCharacteristicNotification*(c: ptr BtdevGattCharacteristic;
    flag: bool): Result {.cdecl,
                       importc: "btdevEnableGattCharacteristicNotification".}
## *
##  @brief Wrapper for \ref btLeClientRegisterNotification / \ref btLeClientDeregisterNotification.
##  @note An error is thrown if the properties from \ref btdevGattCharacteristicGetProperties don't allow using this.
##  @param c \ref BtdevGattCharacteristic
##  @param[in] flag Whether to enable/disable, controls which func to call.
##

proc btdevReadGattDescriptor*(d: ptr BtdevGattDescriptor): Result {.cdecl,
    importc: "btdevReadGattDescriptor".}
## *
##  @brief Wrapper for \ref btLeClientReadDescriptor.
##  @param d \ref BtdevGattDescriptor
##

proc btdevWriteGattDescriptor*(d: ptr BtdevGattDescriptor): Result {.cdecl,
    importc: "btdevWriteGattDescriptor".}
## *
##  @brief Wrapper for \ref btLeClientWriteDescriptor.
##  @note This uses the Value from \ref btdevGattDescriptorSetValue.
##  @param d \ref BtdevGattDescriptor
##

proc btdevGattAttributeCreate*(a: ptr BtdevGattAttribute;
                              uuid: ptr BtdrvGattAttributeUuid; handle: U16;
                              connectionHandle: U32) {.cdecl,
    importc: "btdevGattAttributeCreate".}
## /@name GattAttribute
## /@{
## *
##  @brief Creates a \ref BtdevGattAttribute object. This is intended for internal use.
##  @param a \ref BtdevGattAttribute
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[in] handle Handle
##  @param[in] connection_handle ConnectionHandle
##

proc btdevGattAttributeGetType*(a: ptr BtdevGattAttribute): U8 {.inline, cdecl.} =
  ## *
  ##  @brief Gets the Type.
  ##  @param a \ref BtdevGattAttribute
  ##

  return a.`type`

proc btdevGattAttributeGetUuid*(a: ptr BtdevGattAttribute;
                               `out`: ptr BtdrvGattAttributeUuid) {.inline, cdecl.} =
  ## *
  ##  @brief Gets the Uuid.
  ##  @param a \ref BtdevGattAttribute
  ##  @param[out] out \ref BtdrvGattAttributeUuid
  ##

  `out`[] = a.uuid

proc btdevGattAttributeGetHandle*(a: ptr BtdevGattAttribute): U16 {.inline, cdecl.} =
  ## *
  ##  @brief Gets the Handle.
  ##  @param a \ref BtdevGattAttribute
  ##

  return a.handle

proc btdevGattAttributeGetConnectionHandle*(a: ptr BtdevGattAttribute): U32 {.inline, cdecl.} =
  ## *
  ##  @brief Gets the ConnectionHandle.
  ##  @param a \ref BtdevGattAttribute
  ##

  return a.connectionHandle

proc btdevGattServiceCreate*(s: ptr BtdevGattService;
                            uuid: ptr BtdrvGattAttributeUuid; handle: U16;
                            connectionHandle: U32; instanceId: U16;
                            endGroupHandle: U16; primaryService: bool) {.cdecl,
    importc: "btdevGattServiceCreate".}
## /@}
## /@name GattService
## /@{
## *
##  @brief Creates a \ref BtdevGattService object. This is intended for internal use.
##  @param s \ref BtdevGattService
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[in] handle Handle
##  @param[in] connection_handle ConnectionHandle
##  @param[in] instance_id InstanceId
##  @param[in] end_group_handle EndGroupHandle
##  @param[in] primary_service PrimaryService
##

proc btdevGattServiceGetInstanceId*(s: ptr BtdevGattService): U16 {.inline, cdecl.} =
  ## *
  ##  @brief Gets the InstanceId.
  ##  @param s \ref BtdevGattService
  ##

  return s.instanceId

proc btdevGattServiceGetEndGroupHandle*(s: ptr BtdevGattService): U16 {.inline, cdecl.} =
  ## *
  ##  @brief Gets the EndGroupHandle.
  ##  @param s \ref BtdevGattService
  ##

  return s.endGroupHandle

proc btdevGattServiceIsPrimaryService*(s: ptr BtdevGattService): bool {.inline, cdecl.} =
  ## *
  ##  @brief Gets whether this is the PrimaryService.
  ##  @param s \ref BtdevGattService
  ##

  return s.primaryService

proc btdevGattServiceGetIncludedServices*(s: ptr BtdevGattService;
    services: ptr BtdevGattService; count: U8; totalOut: ptr U8): Result {.cdecl,
    importc: "btdevGattServiceGetIncludedServices".}
## *
##  @brief Wrapper for \ref btmuGetGattIncludedServices.
##  @param s \ref BtdevGattService
##  @param[out] services Output array of \ref BtdevGattService.
##  @param[in] count Size of the services array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btdevGattServiceGetCharacteristics*(s: ptr BtdevGattService; characteristics: ptr BtdevGattCharacteristic;
                                        count: U8; totalOut: ptr U8): Result {.cdecl,
    importc: "btdevGattServiceGetCharacteristics".}
## *
##  @brief Wrapper for \ref btmuGetGattCharacteristics.
##  @param s \ref BtdevGattService
##  @param[out] characteristics Output array of \ref BtdevGattCharacteristic.
##  @param[in] count Size of the characteristics array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btdevGattServiceGetCharacteristic*(s: ptr BtdevGattService;
                                       uuid: ptr BtdrvGattAttributeUuid;
    characteristic: ptr BtdevGattCharacteristic; flag: ptr bool): Result {.cdecl,
    importc: "btdevGattServiceGetCharacteristic".}
## *
##  @brief Same as \ref btdevGattServiceGetCharacteristics except this only returns the \ref BtdevGattCharacteristic which contains a matching \ref BtdrvGattAttributeUuid.
##  @param s \ref BtdevGattService
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[out] characteristic \ref BtdevGattCharacteristic
##  @param[out] flag Whether a \ref BtdevGattService was returned.
##

proc btdevGattCharacteristicCreate*(c: ptr BtdevGattCharacteristic;
                                   uuid: ptr BtdrvGattAttributeUuid; handle: U16;
                                   connectionHandle: U32; instanceId: U16;
                                   properties: U8) {.cdecl,
    importc: "btdevGattCharacteristicCreate".}
## /@}
## /@name GattCharacteristic
## /@{
## *
##  @brief Creates a \ref BtdevGattCharacteristic object. This is intended for internal use.
##  @param c \ref BtdevGattCharacteristic
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[in] handle Handle
##  @param[in] connection_handle ConnectionHandle
##  @param[in] instance_id InstanceId
##  @param[in] properties Properties
##

proc btdevGattCharacteristicGetInstanceId*(c: ptr BtdevGattCharacteristic): U16 {.
    inline, cdecl.} =
  ## *
  ##  @brief Gets the InstanceId.
  ##  @param c \ref BtdevGattCharacteristic
  ##

  return c.instanceId

proc btdevGattCharacteristicGetProperties*(c: ptr BtdevGattCharacteristic): U8 {.
    inline, cdecl.} =
  ## *
  ##  @brief Gets the Properties.
  ##  @param c \ref BtdevGattCharacteristic
  ##

  return c.properties

proc btdevGattCharacteristicGetService*(c: ptr BtdevGattCharacteristic;
                                       service: ptr BtdevGattService): Result {.
    cdecl, importc: "btdevGattCharacteristicGetService".}
## *
##  @brief Wrapper for \ref btmuGetBelongingGattService.
##  @note Gets the \ref BtdevGattService which belongs to this object.
##  @param c \ref BtdevGattCharacteristic.
##  @param[out] service \ref BtdevGattService
##

proc btdevGattCharacteristicGetDescriptors*(c: ptr BtdevGattCharacteristic;
    descriptors: ptr BtdevGattDescriptor; count: U8; totalOut: ptr U8): Result {.cdecl,
    importc: "btdevGattCharacteristicGetDescriptors".}
## *
##  @brief Wrapper for \ref btmuGetGattDescriptors.
##  @note Gets the descriptors which belongs to this object.
##  @param c \ref BtdevGattCharacteristic
##  @param[out] descriptors Output array of \ref BtdevGattDescriptor.
##  @param[in] count Size of the descriptors array in entries. The max is 100.
##  @param[out] total_out Total output entries.
##

proc btdevGattCharacteristicGetDescriptor*(c: ptr BtdevGattCharacteristic;
    uuid: ptr BtdrvGattAttributeUuid; descriptor: ptr BtdevGattDescriptor;
    flag: ptr bool): Result {.cdecl, importc: "btdevGattCharacteristicGetDescriptor".}
## *
##  @brief Same as \ref btdevGattCharacteristicGetDescriptors except this only returns a \ref BtdevGattDescriptor which contains a matching \ref BtdrvGattAttributeUuid.
##  @param c \ref BtdevGattCharacteristic
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[out] descriptor \ref BtdevGattDescriptor
##  @param[out] flag Whether a \ref BtdevGattDescriptor was returned.
##

proc btdevGattCharacteristicSetValue*(c: ptr BtdevGattCharacteristic;
                                     buffer: pointer; size: csize_t) {.cdecl,
    importc: "btdevGattCharacteristicSetValue".}
## *
##  @brief Sets the Value in the object.
##  @note See also \ref btdevWriteGattCharacteristic.
##  @param c \ref BtdevGattCharacteristic
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size, max is 0x200.
##

proc btdevGattCharacteristicGetValue*(c: ptr BtdevGattCharacteristic;
                                     buffer: pointer; size: csize_t): U64 {.cdecl,
    importc: "btdevGattCharacteristicGetValue".}
## *
##  @brief Gets the Value in the object, returns the copied value size.
##  @param c \ref BtdevGattCharacteristic
##  @param[out] buffer Output buffer.
##  @param[in] size Output buffer size, max is 0x200.
##

proc btdevGattDescriptorCreate*(d: ptr BtdevGattDescriptor;
                               uuid: ptr BtdrvGattAttributeUuid; handle: U16;
                               connectionHandle: U32) {.cdecl,
    importc: "btdevGattDescriptorCreate".}
## /@}
## /@name GattDescriptor
## /@{
## *
##  @brief Creates a \ref BtdevGattDescriptor object. This is intended for internal use.
##  @param d \ref BtdevGattDescriptor
##  @param[in] uuid \ref BtdrvGattAttributeUuid
##  @param[in] handle Handle
##  @param[in] connection_handle ConnectionHandle
##

proc btdevGattDescriptorGetService*(d: ptr BtdevGattDescriptor;
                                   service: ptr BtdevGattService): Result {.cdecl,
    importc: "btdevGattDescriptorGetService".}
## *
##  @brief Wrapper for \ref btmuGetBelongingGattService.
##  @note Gets the \ref BtdevGattService which belongs to this object.
##  @param d \ref BtdevGattDescriptor
##  @param[out] service \ref BtdevGattService
##

proc btdevGattDescriptorGetCharacteristic*(d: ptr BtdevGattDescriptor;
    characteristic: ptr BtdevGattCharacteristic): Result {.cdecl,
    importc: "btdevGattDescriptorGetCharacteristic".}
## *
##  @brief Wrapper for \ref btmuGetGattCharacteristics.
##  @note Gets the \ref BtdevGattCharacteristic which belongs to this object.
##  @param d \ref BtdevGattDescriptor
##  @param[out] characteristic \ref BtdevGattCharacteristic
##

proc btdevGattDescriptorSetValue*(d: ptr BtdevGattDescriptor; buffer: pointer;
                                 size: csize_t) {.cdecl,
    importc: "btdevGattDescriptorSetValue".}
## *
##  @brief Sets the Value in the object.
##  @note See also \ref btdevWriteGattDescriptor.
##  @param d \ref BtdevGattDescriptor
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size, max is 0x200.
##

proc btdevGattDescriptorGetValue*(d: ptr BtdevGattDescriptor; buffer: pointer;
                                 size: csize_t): U64 {.cdecl,
    importc: "btdevGattDescriptorGetValue".}
## *
##  @brief Gets the Value in the object, returns the copied value size.
##  @param d \ref BtdevGattDescriptor
##  @param[out] buffer Output buffer.
##  @param[in] size Output buffer size, max is 0x200.
##
