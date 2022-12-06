## *
##  @file ldn.h
##  @brief LDN (local network communications) IPC wrapper. See also: https://switchbrew.org/wiki/LDN_services
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../kernel/event

type
  LdnServiceType* = enum
    LdnServiceTypeUser = 0,     ## /< Initializes ldn:u.
    LdnServiceTypeSystem = 1    ## /< Initializes ldn:s.


## / State loaded by \ref ldnmGetStateForMonitor / \ref ldnGetState.

type
  LdnState* = enum
    LdnStateNone = 0,           ## /< None
    LdnStateInitialized = 1,    ## /< Initialized
    LdnStateAccessPointOpened = 2, ## /< AccessPointOpened (\ref ldnOpenAccessPoint)
    LdnStateAccessPointCreated = 3, ## /< AccessPointCreated (\ref ldnCreateNetwork / \ref ldnCreateNetworkPrivate)
    LdnStateStationOpened = 4,  ## /< StationOpened (\ref ldnOpenStation)
    LdnStateStationConnected = 5, ## /< StationConnected (\ref ldnConnect / \ref ldnConnectPrivate)
    LdnStateError = 6           ## /< Error


## / DisconnectReason loaded by \ref ldnGetDisconnectReason.

type
  LdnDisconnectReason* = enum
    LdnDisconnectReasonNone = 0, ## /< None
    LdnDisconnectReasonUser = 1, ## /< User
    LdnDisconnectReasonSystemRequest = 2, ## /< SystemRequest
    LdnDisconnectReasonDestroyedByAdmin = 3, ## /< DestroyedByAdmin
    LdnDisconnectReasonDestroyedBySystemRequest = 4, ## /< DestroyedBySystemRequest
    LdnDisconnectReasonAdmin = 5, ## /< Admin
    LdnDisconnectReasonSignalLost = 6 ## /< SignalLost


## / ScanFilterFlags

type
  LdnScanFilterFlags* = enum
    LdnScanFilterFlagsLocalCommunicationId = bit(0), ## /< When set, enables using LdnScanFilter::local_communication_id.
    LdnScanFilterFlagsNetworkId = bit(1), ## /< When set, enables using LdnScanFilter::network_id.
    LdnScanFilterFlagsUnknown2 = bit(2), ## /< When set, enables using LdnScanFilter::unk_x20.
    LdnScanFilterFlagsMacAddr = bit(3), ## /< When set, enables using LdnScanFilter::mac_addr. Only available with \ref ldnScanPrivate.
    LdnScanFilterFlagsSsid = bit(4), ## /< When set, enables using the LdnScanFilter::ssid.
    LdnScanFilterFlagsUserData = bit(5) ## /< When set, enables using LdnScanFilter::userdata_filter.


## / AcceptPolicy

type
  LdnAcceptPolicy* = enum
    LdnAcceptPolicyAllowAll = 0, ## /< Allow all.
    LdnAcceptPolicyDenyAll = 1, ## /< Deny all.
    LdnAcceptPolicyBlacklist = 2, ## /< Blacklist, addresses in the list (\ref ldnAddAcceptFilterEntry) are not allowed.
    LdnAcceptPolicyWhitelist = 3 ## /< Whitelist, only addresses in the list (\ref ldnAddAcceptFilterEntry) are allowed.


## / OperationMode

type
  LdnOperationMode* = enum
    LdnOperationModeUnknown0 = 0, ## /< Unknown
    LdnOperationModeUnknown1 = 1 ## /< Unknown


## / WirelessControllerRestriction

type
  LdnWirelessControllerRestriction* = enum
    LdnWirelessControllerRestrictionUnknown0 = 0, ## /< Unknown
    LdnWirelessControllerRestrictionUnknown1 = 1 ## /< Unknown


## / Ipv4Address. This is essentially the same as struct in_addr - hence this can be used with standard sockets (byteswap required).

type
  LdnIpv4Address* {.bycopy.} = object
    `addr`*: U32               ## /< Address


## / SubnetMask. This is essentially the same as struct in_addr - hence this can be used with standard sockets (byteswap required).

type
  LdnSubnetMask* {.bycopy.} = object
    mask*: U32                 ## /< Mask


## / MacAddress

type
  LdnMacAddress* {.bycopy.} = object
    `addr`*: array[6, U8]       ## /< Address


## / Ssid

type
  LdnSsid* {.bycopy.} = object
    len*: U8                   ## /< Length excluding NUL-terminator, must be 0x1-0x20.
    str*: array[0x21, char]     ## /< SSID string including NUL-terminator, str[len_field] must be 0. The chars in this string must be be in the range of 0x20-0x7F, for when the Ssid is converted to a string (otherwise the byte written to the string will be 0).


## / NodeLatestUpdate

type
  LdnNodeLatestUpdate* {.bycopy.} = object
    val*: U8                   ## /< The field in state is reset to zero by \ref ldnGetNetworkInfoLatestUpdate after loading it.
    reserved*: array[0x7, U8]   ## /< Not initialized with \ref ldnGetNetworkInfoLatestUpdate.


## / AddressEntry

type
  LdnAddressEntry* {.bycopy.} = object
    ipAddr*: LdnIpv4Address    ## /< \ref LdnIpv4Address
    macAddr*: LdnMacAddress    ## /< \ref LdnMacAddress
    pad*: array[0x2, U8]        ## /< Padding


## / NodeInfo

type
  LdnNodeInfo* {.bycopy.} = object
    ipAddr*: LdnIpv4Address    ## /< \ref LdnIpv4Address
    macAddr*: LdnMacAddress    ## /< \ref LdnMacAddress
    id*: S8                    ## /< ID / index
    isConnected*: U8           ## /< IsConnected flag
    nickname*: array[0x20, char] ## /< LdnUserConfig::nickname
    reservedX2C*: array[0x2, U8] ## /< Reserved
    localCommunicationVersion*: S16 ## /< LocalCommunicationVersion
    reservedX30*: array[0x10, U8] ## /< Reserved


## / UserConfig. The input struct is copied to a tmp struct, which is then used with the cmd.

type
  LdnUserConfig* {.bycopy.} = object
    nickname*: array[0x20, char] ## /< NUL-terminated string for the user nickname.
    reserved*: array[0x10, U8]  ## /< Cleared to zero for the tmp struct.


## / NetworkInfo

type
  LdnNetworkInfo* {.bycopy.} = object
    localCommunicationId*: U64 ## /< LocalCommunicationId
    reservedX8*: array[0x2, U8] ## /< Reserved
    userdataFilter*: U16       ## /< Arbitrary user data which can be used for filtering with \ref LdnScanFilter.
    reservedXC*: array[0x4, U8] ## /< Reserved
    networkId*: array[0x10, U8] ## /< LdnSecurityParameter::network_id. NetworkId which is used to generate/overwrite the ssid. With \ref ldnScan / \ref ldnScanPrivate, this is only done after filtering when unk_x4B is value 0x2.
    macAddr*: LdnMacAddress    ## /< \ref LdnMacAddress
    ssid*: LdnSsid             ## /< \ref LdnSsid
    networkChannel*: S16       ## /< NetworkChannel
    linkLevel*: S8             ## /< LinkLevel
    unkX4B*: U8                ## /< Unknown. Set to hard-coded value 0x2 with output structs, except with \ref ldnScan / \ref ldnScanPrivate which can also set value 0x1 in certain cases.
    padX4C*: array[0x4, U8]     ## /< Padding
    secParamData*: array[0x10, U8] ## /< LdnSecurityParameter::data
    secType*: U16              ## /< LdnSecurityConfig::type
    acceptPolicy*: U8          ## /< \ref LdnAcceptPolicy
    unkX63*: U8                ## /< Only set with \ref ldnScan / \ref ldnScanPrivate, when unk_x4B is value 0x2.
    padX64*: array[0x2, U8]     ## /< Padding
    participantMax*: S8        ## /< Maximum participants, for nodes.
    participantNum*: U8        ## /< ParticipantNum, number of set entries in nodes. If unk_x4B is not 0x2, ParticipantNum should be handled as if it's 0.
    nodes*: array[8, LdnNodeInfo] ## /< Array of \ref LdnNodeInfo, starting with the AccessPoint node.
    reservedX268*: array[0x2, U8] ## /< Reserved
    advertiseDataSize*: U16    ## /< AdvertiseData size (\ref ldnSetAdvertiseData)
    advertiseData*: array[0x180, U8] ## /< AdvertiseData (\ref ldnSetAdvertiseData)
    reservedX3EC*: array[0x8C, U8] ## /< Reserved
    authId*: U64               ## /< Random AuthenticationId.


## / ScanFilter. The input struct is copied to a tmp struct, which is then used with the cmd (\ref ldnScan and \ref ldnScanPrivate).

type
  LdnScanFilter* {.bycopy.} = object
    localCommunicationId*: S64 ## /< See ::LdnScanFilterFlags_LocalCommunicationId. When enabled, this will be overwritten if it's -1 (written data is from the user-process control.nacp, with value 0 used instead if loading fails). During filtering if enabled, LdnNetworkInfo::unk_x4B must match 0x2, and this ScanFilter field must match LdnNetworkInfo::local_communication_id.
    padX8*: array[0x2, U8]      ## /< Padding
    userdataFilter*: U16       ## /< See ::LdnScanFilterFlags_UserData. During filtering if enabled, LdnNetworkInfo::unk_x4B must match 0x2, and this ScanFilter field must match LdnNetworkInfo::userdata_filter.
    padXC*: array[0x4, U8]      ## /< Padding
    networkId*: array[0x10, U8] ## /< See ::LdnScanFilterFlags_NetworkId. During filtering if enabled, LdnNetworkInfo::unk_x4B must match 0x2, and this ScanFilter data must match LdnNetworkInfo::network_id.
    unkX20*: U32               ## /< See ::LdnScanFilterFlags_Unknown2. When enabled, this must be <=0x3, and during filtering must match LdnNetworkInfo::unk_x4B.
    macAddr*: LdnMacAddress    ## /< \ref LdnMacAddress (::LdnScanFilterFlags_MacAddr, during filtering if enabled this must match LdnNetworkInfo::mac_addr)
    ssid*: LdnSsid             ## /< \ref LdnSsid (::LdnScanFilterFlags_Ssid, during filtering if enabled this must match LdnNetworkInfo::ssid)
    reserved*: array[0x10, U8]  ## /< Cleared to zero for the tmp struct.
    flags*: U32                ## /< Bitmask for \ref LdnScanFilterFlags. Masked with value 0x37 for \ref ldnScan, with \ref ldnScanPrivate this is masked with 0x3F.


## / SecurityConfig

type
  LdnSecurityConfig* {.bycopy.} = object
    `type`*: U16               ## /< Type, a default of value 0x1 can be used here. Overwritten by \ref ldnCreateNetwork, \ref ldnCreateNetworkPrivate, \ref ldnConnect, \ref ldnConnectPrivate.
    dataSize*: U16             ## /< Data size. Must be 0x10-0x40.
    data*: array[0x40, U8]      ## /< Data, used with key derivation.


## / SecurityParameter. The struct used by \ref ldnCreateNetwork internally is randomly-generated.

type
  LdnSecurityParameter* {.bycopy.} = object
    data*: array[0x10, U8]      ## /< Data, used with the same key derivation as \ref LdnSecurityConfig.
    networkId*: array[0x10, U8] ## /< LdnNetworkInfo::network_id


## / NetworkConfig. The input struct is copied to a tmp struct, which is then used with the cmd (\ref ldnCreateNetwork, \ref ldnCreateNetworkPrivate, \ref ldnConnectPrivate).

type
  LdnNetworkConfig* {.bycopy.} = object
    localCommunicationId*: S64 ## /< LdnNetworkInfo::local_communication_id. \ref ldnCreateNetwork, \ref ldnCreateNetworkPrivate, \ref ldnConnect, \ref ldnConnectPrivate: When -1, this is overwritten with the first LocalCommunicationId from the user-process control.nacp, if loading fails value 0 is written instead. Otherwise when not -1, if control.nacp loading is successful, this field must match one of the LocalCommunicationIds from there.
    reservedX8*: array[2, U8]   ## /< Cleared to zero for the tmp struct.
    userdataFilter*: U16       ## /< LdnNetworkInfo::userdata_filter
    reservedXC*: array[4, U8]   ## /< Cleared to zero for the tmp struct.
    networkChannel*: S16       ## /< LdnNetworkInfo::network_channel. Channel, can be zero. Overwritten internally by \ref ldnCreateNetwork.
    participantMax*: S8        ## /< LdnNetworkInfo::participant_max. \ref ldnCreateNetwork / \ref ldnCreateNetworkPrivate: Must be 0x1-0x8.
    reservedX13*: U8           ## /< Cleared to zero for the tmp struct.
    localCommunicationVersion*: S16 ## /< LdnNodeInfo::local_communication_version, for the first entry in LdnNetworkInfo::nodes. Must not be negative.
    reservedX16*: array[0xA, U8] ## /< Cleared to zero for the tmp struct.


## /@name ldn:m
## /@{
## / Initialize ldn:m.

proc ldnmInitialize*(): Result {.cdecl, importc: "ldnmInitialize".}
## / Exit ldn:m.

proc ldnmExit*() {.cdecl, importc: "ldnmExit".}
## / Gets the Service object for IMonitorService.

proc ldnmGetServiceSessionMonitorService*(): ptr Service {.cdecl,
    importc: "ldnmGetServiceSession_MonitorService".}
## *
##  @brief GetStateForMonitor
##  @param[out] out \ref LdnState
##

proc ldnmGetStateForMonitor*(`out`: ptr LdnState): Result {.cdecl,
    importc: "ldnmGetStateForMonitor".}
## *
##  @brief GetNetworkInfoForMonitor
##  @param[out] out \ref LdnNetworkInfo
##

proc ldnmGetNetworkInfoForMonitor*(`out`: ptr LdnNetworkInfo): Result {.cdecl,
    importc: "ldnmGetNetworkInfoForMonitor".}
## *
##  @brief GetIpv4AddressForMonitor
##  @param[out] addr \ref LdnIpv4Address
##  @param[out] mask \ref LdnSubnetMask
##

proc ldnmGetIpv4AddressForMonitor*(`addr`: ptr LdnIpv4Address;
                                  mask: ptr LdnSubnetMask): Result {.cdecl,
    importc: "ldnmGetIpv4AddressForMonitor".}
## *
##  @brief GetSecurityParameterForMonitor
##  @note Not exposed by official sw.
##  @param[out] out \ref LdnSecurityParameter
##

proc ldnmGetSecurityParameterForMonitor*(`out`: ptr LdnSecurityParameter): Result {.
    cdecl, importc: "ldnmGetSecurityParameterForMonitor".}
## *
##  @brief GetNetworkConfigForMonitor
##  @note Not exposed by official sw.
##  @param[out] out \ref LdnNetworkConfig
##

proc ldnmGetNetworkConfigForMonitor*(`out`: ptr LdnNetworkConfig): Result {.cdecl,
    importc: "ldnmGetNetworkConfigForMonitor".}
## /@}
## /@name ldn
## /@{
## / Initialize ldn.

proc ldnInitialize*(serviceType: LdnServiceType): Result {.cdecl,
    importc: "ldnInitialize".}
## / Exit ldn.

proc ldnExit*() {.cdecl, importc: "ldnExit".}
## / Gets the Service object for IUserLocalCommunicationService/ISystemLocalCommunicationService.

proc ldnGetServiceSessionLocalCommunicationService*(): ptr Service {.cdecl,
    importc: "ldnGetServiceSession_LocalCommunicationService".}
## *
##  @brief GetState
##  @param[out] out \ref LdnState
##

proc ldnGetState*(`out`: ptr LdnState): Result {.cdecl, importc: "ldnGetState".}
## *
##  @brief GetNetworkInfo
##  @param[out] out \ref LdnNetworkInfo
##

proc ldnGetNetworkInfo*(`out`: ptr LdnNetworkInfo): Result {.cdecl,
    importc: "ldnGetNetworkInfo".}
## *
##  @brief GetIpv4Address
##  @param[out] addr \ref LdnIpv4Address
##  @param[out] mask \ref LdnSubnetMask
##

proc ldnGetIpv4Address*(`addr`: ptr LdnIpv4Address; mask: ptr LdnSubnetMask): Result {.
    cdecl, importc: "ldnGetIpv4Address".}
## *
##  @brief GetDisconnectReason
##  @param[out] out \ref LdnDisconnectReason
##

proc ldnGetDisconnectReason*(`out`: ptr LdnDisconnectReason): Result {.cdecl,
    importc: "ldnGetDisconnectReason".}
## *
##  @brief GetSecurityParameter
##  @param[out] out \ref LdnSecurityParameter
##

proc ldnGetSecurityParameter*(`out`: ptr LdnSecurityParameter): Result {.cdecl,
    importc: "ldnGetSecurityParameter".}
## *
##  @brief GetNetworkConfig
##  @param[out] out \ref LdnNetworkConfig
##

proc ldnGetNetworkConfig*(`out`: ptr LdnNetworkConfig): Result {.cdecl,
    importc: "ldnGetNetworkConfig".}
## *
##  @brief AttachStateChangeEvent
##  @note The Event must be closed by the user once finished with it.
##  @note This is signaled when the data returned by \ref ldnGetNetworkInfo / \ref ldnGetNetworkInfoLatestUpdate is updated.
##  @param[out] out_event Output Event with autoclear=true.
##

proc ldnAttachStateChangeEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "ldnAttachStateChangeEvent".}
## *
##  @brief GetNetworkInfoLatestUpdate
##  @param[out] network_info \ref LdnNetworkInfo
##  @param[out] nodes Output array of \ref LdnNodeLatestUpdate.
##  @param[in] count Size of the nodes array in entries, must be 8.
##

proc ldnGetNetworkInfoLatestUpdate*(networkInfo: ptr LdnNetworkInfo;
                                   nodes: ptr LdnNodeLatestUpdate; count: S32): Result {.
    cdecl, importc: "ldnGetNetworkInfoLatestUpdate".}
## *
##  @brief Scan
##  @note \ref LdnState must be ::LdnState_AccessPointCreated, ::LdnState_StationOpened, or ::LdnState_StationConnected.
##  @note This is the same as \ref ldnScanPrivate (minus the masking for LdnScanFilter::flags), except this has the same channel-override functionality as \ref ldnCreateNetwork.
##  @param[in] channel Channel, value 0 can be used for this.
##  @param[in] filter \ref LdnScanFilter
##  @param[out] network_info Output array of \ref LdnNetworkInfo.
##  @param[in] count Size of the network_info array in entries. Must be at least 1, this is clamped to a maximum of 0x18 internally.
##  @param[out] total_out Total output entries.
##

proc ldnScan*(channel: S32; filter: ptr LdnScanFilter;
             networkInfo: ptr LdnNetworkInfo; count: S32; totalOut: ptr S32): Result {.
    cdecl, importc: "ldnScan".}
## *
##  @brief ScanPrivate
##  @note \ref LdnState must be ::LdnState_AccessPointCreated, ::LdnState_StationOpened, or ::LdnState_StationConnected.
##  @note See \ref ldnScan.
##  @param[in] channel Channel, value 0 can be used for this.
##  @param[in] filter \ref LdnScanFilter
##  @param[out] network_info Output array of \ref LdnNetworkInfo.
##  @param[in] count Size of the network_info array in entries. Must be at least 1, this is clamped to a maximum of 0x18 internally.
##  @param[out] total_out Total output entries.
##

proc ldnScanPrivate*(channel: S32; filter: ptr LdnScanFilter;
                    networkInfo: ptr LdnNetworkInfo; count: S32; totalOut: ptr S32): Result {.
    cdecl, importc: "ldnScanPrivate".}
## *
##  @brief SetWirelessControllerRestriction
##  @note Only available on [5.0.0+].
##  @note \ref LdnState must be ::LdnState_Initialized.
##  @param[in] restriction \ref LdnWirelessControllerRestriction
##

proc ldnSetWirelessControllerRestriction*(
    restriction: LdnWirelessControllerRestriction): Result {.cdecl,
    importc: "ldnSetWirelessControllerRestriction".}
## *
##  @brief OpenAccessPoint
##  @note \ref LdnState must be ::LdnState_Initialized, this eventually sets the State to ::LdnState_AccessPointOpened.
##

proc ldnOpenAccessPoint*(): Result {.cdecl, importc: "ldnOpenAccessPoint".}
## *
##  @brief CloseAccessPoint
##  @note \ref LdnState must be ::LdnState_AccessPointOpened or ::LdnState_AccessPointCreated, this eventually sets the State to ::LdnState_Initialized.
##  @note Used automatically internally by \ref ldnExit if needed.
##

proc ldnCloseAccessPoint*(): Result {.cdecl, importc: "ldnCloseAccessPoint".}
## *
##  @brief CreateNetwork
##  @note \ref LdnState must be ::LdnState_AccessPointOpened, this eventually sets the State to ::LdnState_AccessPointCreated.
##  @param[in] sec_config \ref LdnSecurityConfig
##  @param[in] user_config \ref LdnUserConfig
##  @param[in] network_config \ref LdnNetworkConfig
##

proc ldnCreateNetwork*(secConfig: ptr LdnSecurityConfig;
                      userConfig: ptr LdnUserConfig;
                      networkConfig: ptr LdnNetworkConfig): Result {.cdecl,
    importc: "ldnCreateNetwork".}
## *
##  @brief CreateNetworkPrivate
##  @note \ref LdnState must be ::LdnState_AccessPointOpened, this eventually sets the State to ::LdnState_AccessPointCreated.
##  @note This is the same as \ref ldnCreateNetwork besides the additional user-specified params, and with this cmd LdnNetworkConfig::channel is not overwritten (unlike \ref ldnCreateNetwork).
##  @param[in] sec_config \ref LdnSecurityConfig
##  @param[in] sec_param \ref LdnSecurityParameter
##  @param[in] user_config \ref LdnUserConfig
##  @param[in] network_config \ref LdnNetworkConfig
##  @param[in] addrs Input array of \ref LdnAddressEntry. This can be NULL.
##  @param[in] count Size of the addrs array in entries. This must be <=8. This can be 0, in which case the network will be non-Private like \ref ldnCreateNetwork.
##

proc ldnCreateNetworkPrivate*(secConfig: ptr LdnSecurityConfig;
                             secParam: ptr LdnSecurityParameter;
                             userConfig: ptr LdnUserConfig;
                             networkConfig: ptr LdnNetworkConfig;
                             addrs: ptr LdnAddressEntry; count: S32): Result {.cdecl,
    importc: "ldnCreateNetworkPrivate".}
## *
##  @brief DestroyNetwork
##  @note \ref LdnState must be ::LdnState_AccessPointCreated, this eventually sets the State to ::LdnState_AccessPointOpened.
##

proc ldnDestroyNetwork*(): Result {.cdecl, importc: "ldnDestroyNetwork".}
## *
##  @brief Reject
##  @note \ref LdnState must be ::LdnState_AccessPointCreated.
##  @param[in] addr \ref LdnIpv4Address
##

proc ldnReject*(`addr`: LdnIpv4Address): Result {.cdecl, importc: "ldnReject".}
## *
##  @brief SetAdvertiseData
##  @note An empty buffer (buffer=NULL/size=0) can be used to reset the AdvertiseData size in state to zero.
##  @note \ref LdnState must be ::LdnState_AccessPointOpened or ::LdnState_AccessPointCreated.
##  @param[in] buffer Input buffer containing arbitrary user data.
##  @param[in] size Input buffer size, must be <=0x180. If this isn't enough space, you can for example also periodically use this cmd with different regions of your data with some sequence_number field (or use sockets while connected to the network).
##

proc ldnSetAdvertiseData*(buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "ldnSetAdvertiseData".}
## *
##  @brief SetStationAcceptPolicy
##  @note \ref LdnState must be ::LdnState_AccessPointOpened or ::LdnState_AccessPointCreated.
##  @param[in] policy \ref LdnAcceptPolicy
##

proc ldnSetStationAcceptPolicy*(policy: LdnAcceptPolicy): Result {.cdecl,
    importc: "ldnSetStationAcceptPolicy".}
## *
##  @brief AddAcceptFilterEntry
##  @note \ref LdnState must be ::LdnState_AccessPointOpened or ::LdnState_AccessPointCreated.
##  @note See \ref LdnAcceptPolicy.
##  @param[in] addr \ref LdnMacAddress. If you want, you can also pass LdnNodeInfo::mac_addr for this.
##

proc ldnAddAcceptFilterEntry*(`addr`: LdnMacAddress): Result {.cdecl,
    importc: "ldnAddAcceptFilterEntry".}
## *
##  @brief ClearAcceptFilter
##  @note \ref LdnState must be ::LdnState_AccessPointOpened or ::LdnState_AccessPointCreated.
##

proc ldnClearAcceptFilter*(): Result {.cdecl, importc: "ldnClearAcceptFilter".}
## *
##  @brief OpenStation
##  @note \ref LdnState must be ::LdnState_Initialized, this eventually sets the State to ::LdnState_StationOpened.
##

proc ldnOpenStation*(): Result {.cdecl, importc: "ldnOpenStation".}
## *
##  @brief CloseStation
##  @note \ref LdnState must be ::LdnState_StationOpened or ::LdnState_StationConnected, this eventually sets the State to ::LdnState_Initialized.
##  @note Used automatically internally by \ref ldnExit if needed.
##

proc ldnCloseStation*(): Result {.cdecl, importc: "ldnCloseStation".}
## *
##  @brief Connect
##  @note \ref LdnState must be ::LdnState_StationOpened, this eventually sets the State to ::LdnState_StationConnected.
##  @note This is identical to \ref ldnConnectPrivate besides the used params, the code overwriting LdnSecurityConfig::type also differs.
##  @param[in] sec_config \ref LdnSecurityConfig
##  @param[in] user_config \ref LdnUserConfig
##  @param[in] version LocalCommunicationVersion, this must be 0x0-0x7FFF.
##  @param[in] option ConnectOption bitmask, must be <=0x1. You can use value 0 for example here.
##  @param[in] network_info \ref LdnNetworkInfo
##

proc ldnConnect*(secConfig: ptr LdnSecurityConfig; userConfig: ptr LdnUserConfig;
                version: S32; option: U32; networkInfo: ptr LdnNetworkInfo): Result {.
    cdecl, importc: "ldnConnect".}
## *
##  @brief ConnectPrivate
##  @note \ref LdnState must be ::LdnState_StationOpened, this eventually sets the State to ::LdnState_StationConnected.
##  @note See \ref ldnConnect.
##  @param[in] sec_config \ref LdnSecurityConfig
##  @param[in] sec_param \ref LdnSecurityParameter
##  @param[in] user_config \ref LdnUserConfig
##  @param[in] version LocalCommunicationVersion, this must be 0x0-0x7FFF.
##  @param[in] option ConnectOption bitmask, must be <=0x1. You can use value 0 for example here.
##  @param[in] network_config \ref LdnNetworkConfig
##

proc ldnConnectPrivate*(secConfig: ptr LdnSecurityConfig;
                       secParam: ptr LdnSecurityParameter;
                       userConfig: ptr LdnUserConfig; version: S32; option: U32;
                       networkConfig: ptr LdnNetworkConfig): Result {.cdecl,
    importc: "ldnConnectPrivate".}
## *
##  @brief Disconnect
##  @note \ref LdnState must be ::LdnState_StationConnected, this eventually sets the State to ::LdnState_StationOpened.
##

proc ldnDisconnect*(): Result {.cdecl, importc: "ldnDisconnect".}
## *
##  @brief SetOperationMode
##  @note Only available on [4.0.0+].
##  @note Only available with ::LdnServiceType_System.
##  @note \ref LdnState must be ::LdnState_Initialized.
##  @param[in] mode \ref LdnOperationMode
##

proc ldnSetOperationMode*(mode: LdnOperationMode): Result {.cdecl,
    importc: "ldnSetOperationMode".}
## /@}
