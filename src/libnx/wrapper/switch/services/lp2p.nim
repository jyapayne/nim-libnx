## *
##  @file lp2p.h
##  @brief lp2p service IPC wrapper, for local-WLAN communications with accessories. See also: https://switchbrew.org/wiki/LDN_services
##  @note Only available on [9.1.0+].
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../kernel/event

type
  Lp2pServiceType* = enum
    Lp2pServiceTypeApp = 0,     ## /< Initializes lp2p:app.
    Lp2pServiceTypeSystem = 1   ## /< Initializes lp2p:sys.


## / MacAddress

type
  Lp2pMacAddress* {.bycopy.} = object
    `addr`*: array[6, U8]       ## /< Address


## / GroupId

type
  Lp2pGroupId* {.bycopy.} = object
    id*: array[0x6, U8]         ## /< BSSID


## / GroupInfo
## / \ref lp2pScan only uses the following fields for the cmd input struct: supported_platform/priority, frequency/channel, and preshared_key_binary_size/preshared_key.

type
  Lp2pGroupInfo* {.bycopy.} = object
    unkX0*: array[0x10, U8]     ## /< When zero, this is set to randomly-generated data. Used during key derivation.
    localCommunicationId*: U64 ## /< LocalCommunicationId. When zero, the value from the user-process control.nacp is loaded. This is later validated by \ref lp2pJoin / \ref lp2pCreateGroup the same way as LdnNetworkConfig::local_communication_id. Used during key derivation.
    groupId*: Lp2pGroupId      ## /< Should be all-zero for the input struct so that the default is used.
    serviceName*: array[0x21, char] ## /< ServiceName. NUL-terminated string for the SSID. These characters must be '-' or alphanumeric (lowercase/uppercase). '_' must not be used, unless you generate valid data for that. The data for '_' will be automatically generated if it's not present.
    flagsCount*: S8            ## /< Must be <=0x3F.
    flags*: array[0x40, S8]     ## /< Array of s8 with the above count. Each entry value must be <=0x3F. Each entry is an array index used to load a set of flags from a global array with the specified index.
    supportedPlatform*: U8     ## /< SupportedPlatform. Must match value 1. 0 is PlatformIdNX, 1 is PlatformIdFuji.
    memberCountMax*: S8        ## /< MemberCountMax. Must be <=0x8. If zero during group-creation, a default of value 1 is used for the value passed to a service-cmd.
    unkX82*: U8                ## /< Unknown
    unkX83*: U8                ## /< Unknown
    frequency*: U16            ## /< Wifi frequency: 24 = 2.4GHz, 50 = 5GHz.
    channel*: S16              ## /< Wifi channel number. 0 = use default, otherwise this must be one of the following depending on the frequency field. 24: 1, 6, 11. 50: 36, 40, 44, 48.
    networkMode*: U8           ## /< NetworkMode
    performanceRequirement*: U8 ## /< PerformanceRequirement
    securityType*: U8          ## /< Security type, used during key derivation. 0 = use defaults, 1 = plaintext, 2 = encrypted. [11.0.0+] 3: Standard WPA2-PSK.
    staticAesKeyIndex*: S8     ## /< StaticAesKeyIndex. Used as the array-index for selecting the KeySource used with GenerateAesKek during key derivation. Should be 1-2, otherwise GenerateAesKek is skipped and zeros are used for the AccessKey instead.
    unkX8C*: U8                ## /< Unknown
    priority*: U8              ## /< Priority. Must match one of the following, depending on the used service (doesn't apply to \ref lp2pJoin): 55 = SystemPriority (lp2p:sys), 90 = ApplicationPriority (lp2p:app and lp2p:sys).
    stealthEnabled*: U8        ## /< StealthEnabled. Bool flag, controls whether the SSID is hidden.
    unkX8F*: U8                ## /< If zero, a default value of 0x20 is used.
    unkX90*: array[0x130, U8]   ## /< Unknown
    presharedKeyBinarySize*: U8 ## /< PresharedKeyBinarySize
    presharedKey*: array[0x3F, U8] ## /< PresharedKey. Used during key derivation.


## / ScanResult

type
  Lp2pScanResult* {.bycopy.} = object
    groupInfo*: Lp2pGroupInfo  ## /< \ref Lp2pGroupInfo
    unkX200*: U8               ## /< Unknown
    unkX201*: array[0x5, U8]    ## /< Unknown
    advertiseDataSize*: U16    ## /< Size of the following AdvertiseData.
    advertiseData*: array[0x80, U8] ## /< AdvertiseData, with the above size. This originates from \ref lp2pSetAdvertiseData.
    unkX288*: array[0x78, U8]   ## /< Unknown


## / NodeInfo

type
  Lp2pNodeInfo* {.bycopy.} = object
    ipAddr*: array[0x20, U8]    ## /< struct sockaddr for the IP address.
    unkX20*: array[0x4, U8]     ## /< Unknown
    macAddr*: Lp2pMacAddress   ## /< \ref Lp2pMacAddress
    unkX2A*: array[0x56, U8]    ## /< Unknown


## / IpConfig. Only contains IPv4 addresses.

type
  Lp2pIpConfig* {.bycopy.} = object
    unkX0*: array[0x20, U8]     ## /< Always zeros.
    ipAddr*: array[0x20, U8]    ## /< struct sockaddr for the IP address.
    subnetMask*: array[0x20, U8] ## /< struct sockaddr for the subnet-mask.
    gateway*: array[0x20, U8]   ## /< struct sockaddr for the gateway(?).
    unkX80*: array[0x80, U8]    ## /< Always zeros.

proc lp2pInitialize*(serviceType: Lp2pServiceType): Result {.cdecl,
    importc: "lp2pInitialize".}
## / Initialize lp2p.

proc lp2pExit*() {.cdecl, importc: "lp2pExit".}
## / Exit lp2p.

proc lp2pGetServiceSessionINetworkService*(): ptr Service {.cdecl,
    importc: "lp2pGetServiceSession_INetworkService".}
## / Gets the Service object for INetworkService.

proc lp2pGetServiceSessionINetworkServiceMonitor*(): ptr Service {.cdecl,
    importc: "lp2pGetServiceSession_INetworkServiceMonitor".}
## / Gets the Service object for INetworkServiceMonitor.

proc lp2pCreateGroupInfo*(info: ptr Lp2pGroupInfo) {.cdecl,
    importc: "lp2pCreateGroupInfo".}
## *
##  @brief Creates a default \ref Lp2pGroupInfo for use with \ref lp2pCreateGroup / \ref lp2pJoin.
##  @param info \ref Lp2pGroupInfo
##

proc lp2pCreateGroupInfoScan*(info: ptr Lp2pGroupInfo) {.cdecl,
    importc: "lp2pCreateGroupInfoScan".}
## *
##  @brief Creates a default \ref Lp2pGroupInfo for use with \ref lp2pScan.
##  @param info \ref Lp2pGroupInfo
##

proc lp2pGroupInfoSetServiceName*(info: ptr Lp2pGroupInfo; name: cstring) {.cdecl,
    importc: "lp2pGroupInfoSetServiceName".}
## *
##  @brief Sets Lp2pGroupInfo::service_name.
##  @param info \ref Lp2pGroupInfo
##  @param[in] name ServiceName / SSID.
##

proc lp2pGroupInfoSetFlags*(info: ptr Lp2pGroupInfo; flags: ptr S8; count: csize_t) {.
    cdecl, importc: "lp2pGroupInfoSetFlags".}
## *
##  @brief Sets Lp2pGroupInfo::flags_count and Lp2pGroupInfo::flags.
##  @note The default is count=1 flags[0]=1, which is used by \ref lp2pCreateGroupInfo. [11.0.0+] To use standard WPA2-PSK, you can use flags[0]=0.
##  @param info \ref Lp2pGroupInfo
##  @param[in] flags Lp2pGroupInfo::flags
##  @param[in] count Lp2pGroupInfo::flags_count
##

proc lp2pGroupInfoSetMemberCountMax*(info: ptr Lp2pGroupInfo; count: csize_t) {.
    inline, cdecl.} =
  ## *
  ##  @brief Sets Lp2pGroupInfo::member_count_max.
  ##  @param info \ref Lp2pGroupInfo
  ##  @param[in] count MemberCountMax
  ##

  info.memberCountMax = count.int8

proc lp2pGroupInfoSetFrequencyChannel*(info: ptr Lp2pGroupInfo; frequency: U16;
                                      channel: S16) {.inline, cdecl.} =
  ## *
  ##  @brief Sets Lp2pGroupInfo::frequency and Lp2pGroupInfo::channel.
  ##  @param info \ref Lp2pGroupInfo
  ##  @param[in] frequency Lp2pGroupInfo::frequency
  ##  @param[in] channel Lp2pGroupInfo::channel
  ##

  info.frequency = frequency
  info.channel = channel

proc lp2pGroupInfoSetStealthEnabled*(info: ptr Lp2pGroupInfo; flag: bool) {.inline,
    cdecl.} =
  ## *
  ##  @brief Sets Lp2pGroupInfo::stealth_enabled.
  ##  @param info \ref Lp2pGroupInfo
  ##  @param[in] flag Lp2pGroupInfo::stealth_enabled
  ##

  info.stealthEnabled = flag.U8

proc lp2pGroupInfoSetPresharedKey*(info: ptr Lp2pGroupInfo; key: pointer;
                                  size: csize_t) {.cdecl,
    importc: "lp2pGroupInfoSetPresharedKey".}
## *
##  @brief Sets the PresharedKey for the specified \ref Lp2pGroupInfo.
##  @note Using this is required before using the \ref Lp2pGroupInfo as input for any cmds, so that Lp2pGroupInfo::preshared_key_binary_size gets initialized.
##  @note If standard WPA2-PSK is being used, use \ref lp2pGroupInfoSetPassphrase instead.
##  @param info \ref Lp2pGroupInfo
##  @param[in] key Data for the PresharedKey.
##  @param[in] size Size to copy into the PresharedKey, max is 0x20.
##

proc lp2pGroupInfoSetPassphrase*(info: ptr Lp2pGroupInfo; passphrase: cstring): Result {.
    cdecl, importc: "lp2pGroupInfoSetPassphrase".}
## *
##  @brief Sets the passphrase, for when standard WPA2-PSK is being used.
##  @note Configure standard WPA2-PSK usage via \ref lp2pGroupInfoSetFlags / Lp2pGroupInfo::security_type.
##  @note Only available on [11.0.0+].
##  @param info \ref Lp2pGroupInfo
##  @param[in] passphrase Passphrase string, the required length is 0x8-0x3F.
##

proc lp2pScan*(info: ptr Lp2pGroupInfo; results: ptr Lp2pScanResult; count: S32;
              totalOut: ptr S32): Result {.cdecl, importc: "lp2pScan".}
## /@name INetworkService
## /@{
## *
##  @brief Scan
##  @param[in] info \ref Lp2pGroupInfo
##  @param[out] results Output array of \ref Lp2pScanResult.
##  @param[in] count Size of the results array in entries.
##  @param[out] total_out Total output entries.
##

proc lp2pCreateGroup*(info: ptr Lp2pGroupInfo): Result {.cdecl,
    importc: "lp2pCreateGroup".}
## *
##  @brief CreateGroup
##  @note The role (\ref lp2pGetRole) must be 0. This eventually sets the role to value 1.
##  @param[in] info \ref Lp2pGroupInfo
##

proc lp2pDestroyGroup*(): Result {.cdecl, importc: "lp2pDestroyGroup".}
## *
##  @brief This destroys the previously created group from \ref lp2pCreateGroup.
##  @note If no group was previously created (role from \ref lp2pGetRole is not 1), this just returns 0.
##

proc lp2pSetAdvertiseData*(buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "lp2pSetAdvertiseData".}
## *
##  @brief SetAdvertiseData
##  @note The role (\ref lp2pGetRole) must be <=1.
##  @note An empty buffer (buffer=NULL/size=0) can be used to reset the AdvertiseData size in state to zero.
##  @param[out] buffer Input buffer containing arbitrary user data.
##  @param[in] size Input buffer size, must be <=0x80.
##

proc lp2pSendToOtherGroup*(buffer: pointer; size: csize_t; `addr`: Lp2pMacAddress;
                          groupId: Lp2pGroupId; frequency: S16; channel: S16;
                          flags: U32): Result {.cdecl,
    importc: "lp2pSendToOtherGroup".}
## *
##  @brief This sends an Action frame to the specified \ref Lp2pGroupId, with the specified destination \ref Lp2pMacAddress.
##  @note The role (\ref lp2pGetRole) must be non-zero.
##  @note The error from \ref lp2pGetNetworkInterfaceLastError will be returned if it's set.
##  @note [11.0.0+] Lp2pGroupInfo::security_type must be value 2 (default encryption), otherwise an error is returned.
##  @param[in] buffer Input buffer containing arbitrary user data.
##  @param[in] size Input buffer size, must be <=0x400.
##  @param[in] addr \ref Lp2pMacAddress, this can be a broadcast address. This must be non-zero.
##  @param[in] group_id \ref Lp2pGroupId
##  @param[in] frequency Must be >=1. See Lp2pGroupInfo::frequency.
##  @param[in] channel Must be >=1. See Lp2pGroupInfo::channel.
##  @param[in] flags Only bit0 is used: clear = block until the data can be sent, set = return error when the data can't be sent.
##

proc lp2pRecvFromOtherGroup*(buffer: pointer; size: csize_t; flags: U32;
                            `addr`: ptr Lp2pMacAddress; unk0: ptr U16; unk1: ptr S32;
                            outSize: ptr U64; unk2: ptr S32): Result {.cdecl,
    importc: "lp2pRecvFromOtherGroup".}
## *
##  @brief This receives an Action frame.
##  @note The role (\ref lp2pGetRole) must be non-zero.
##  @note When data is not available, the error from \ref lp2pGetNetworkInterfaceLastError will be returned if it's set.
##  @param[out] buffer Output buffer containing arbitrary user data.
##  @param[in] size Output buffer size.
##  @param[in] flags Only bit0 is used: clear = block until data is available, set = return error when data is not available.
##  @param[in] addr \ref Lp2pMacAddress
##  @param[in] unk0 Unknown
##  @param[in] unk1 Unknown
##  @param[out] out_size This is the original size used for copying to the output buffer, before it's clamped to the output-buffer size.
##  @param[out] unk2 Unknown
##

proc lp2pAddAcceptableGroupId*(groupId: Lp2pGroupId): Result {.cdecl,
    importc: "lp2pAddAcceptableGroupId".}
## *
##  @brief AddAcceptableGroupId
##  @param[in] group_id \ref Lp2pGroupId
##

proc lp2pRemoveAcceptableGroupId*(): Result {.cdecl,
    importc: "lp2pRemoveAcceptableGroupId".}
## *
##  @brief RemoveAcceptableGroupId
##

proc lp2pAttachNetworkInterfaceStateChangeEvent*(outEvent: ptr Event): Result {.
    cdecl, importc: "lp2pAttachNetworkInterfaceStateChangeEvent".}
## /@name INetworkServiceMonitor
## /@{
## *
##  @brief AttachNetworkInterfaceStateChangeEvent
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc lp2pGetNetworkInterfaceLastError*(): Result {.cdecl,
    importc: "lp2pGetNetworkInterfaceLastError".}
## *
##  @brief GetNetworkInterfaceLastError
##

proc lp2pGetRole*(`out`: ptr U8): Result {.cdecl, importc: "lp2pGetRole".}
## *
##  @brief GetRole
##  @param[out] out Output Role.
##

proc lp2pGetAdvertiseData*(buffer: pointer; size: csize_t; transferSize: ptr U16;
                          originalSize: ptr U16): Result {.cdecl,
    importc: "lp2pGetAdvertiseData".}
## *
##  @brief GetAdvertiseData
##  @note The role from \ref lp2pGetRole must be value 2.
##  @param[out] buffer Output buffer data.
##  @param[in] size Output buffer size.
##  @param[out] transfer_size Size of the data copied into the buffer.
##  @param[out] original_size Original size from state.
##

proc lp2pGetAdvertiseData2*(buffer: pointer; size: csize_t; transferSize: ptr U16;
                           originalSize: ptr U16): Result {.cdecl,
    importc: "lp2pGetAdvertiseData2".}
## *
##  @brief GetAdvertiseData2
##  @note This is identical to \ref lp2pGetAdvertiseData except this doesn't run the role validation.
##  @param[out] buffer Output buffer data.
##  @param[in] size Output buffer size.
##  @param[out] transfer_size Size of the data copied into the buffer.
##  @param[out] original_size Original size from state.
##

proc lp2pGetGroupInfo*(`out`: ptr Lp2pGroupInfo): Result {.cdecl,
    importc: "lp2pGetGroupInfo".}
## *
##  @brief GetGroupInfo
##  @note The role from \ref lp2pGetRole must be non-zero.
##  @param[out] out \ref Lp2pGroupInfo
##

proc lp2pJoin*(`out`: ptr Lp2pGroupInfo; info: ptr Lp2pGroupInfo): Result {.cdecl,
    importc: "lp2pJoin".}
## *
##  @brief This runs the same code as \ref lp2pCreateGroup to generate the \ref Lp2pGroupInfo for the input struct.
##  @param[out] out \ref Lp2pGroupInfo
##  @param[in] info \ref Lp2pGroupInfo
##

proc lp2pGetGroupOwner*(`out`: ptr Lp2pNodeInfo): Result {.cdecl,
    importc: "lp2pGetGroupOwner".}
## *
##  @brief GetGroupOwner
##  @note The role from \ref lp2pGetRole must be non-zero.
##  @param[out] out \ref Lp2pNodeInfo
##

proc lp2pGetIpConfig*(`out`: ptr Lp2pIpConfig): Result {.cdecl,
    importc: "lp2pGetIpConfig".}
## *
##  @brief GetIpConfig
##  @note The role from \ref lp2pGetRole must be non-zero.
##  @param[out] out \ref Lp2pIpConfig
##

proc lp2pLeave*(`out`: ptr U32): Result {.cdecl, importc: "lp2pLeave".}
## *
##  @brief Leave
##  @param[out] out Output value.
##

proc lp2pAttachJoinEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "lp2pAttachJoinEvent".}
## *
##  @brief AttachJoinEvent
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc lp2pGetMembers*(members: ptr Lp2pNodeInfo; count: S32; totalOut: ptr S32): Result {.
    cdecl, importc: "lp2pGetMembers".}
## *
##  @brief GetMembers
##  @note The role from \ref lp2pGetRole must be value 1.
##  @param[out] members Output array of \ref Lp2pNodeInfo.
##  @param[in] count Size of the members array in entries. A maximum of 8 entries can be returned.
##  @param[out] total_out Total output entries.
##

## /@}
