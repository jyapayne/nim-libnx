## *
##  @file nifm.h
##  @brief Network interface service IPC wrapper.
##  @author shadowninja108, shibboleet, exelix, yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../kernel/event

type
  NifmServiceType* = enum
    NifmServiceTypeUser = 0,    ## /< Initializes nifm:u.
    NifmServiceTypeSystem = 1,  ## /< Initializes nifm:s.
    NifmServiceTypeAdmin = 2    ## /< Initializes nifm:a.
  NifmInternetConnectionType* = enum
    NifmInternetConnectionTypeWiFi = 1, ## /< Wi-Fi connection is used.
    NifmInternetConnectionTypeEthernet = 2 ## /< Ethernet connection is used.
  NifmInternetConnectionStatus* = enum
    NifmInternetConnectionStatusConnectingUnknown1 = 0, ## /< Unknown internet connection status 1.
    NifmInternetConnectionStatusConnectingUnknown2 = 1, ## /< Unknown internet connection status 2.
    NifmInternetConnectionStatusConnectingUnknown3 = 2, ## /< Unknown internet connection status 3 (conntest?).
    NifmInternetConnectionStatusConnectingUnknown4 = 3, ## /< Unknown internet connection status 4.
    NifmInternetConnectionStatusConnected = 4 ## /< Internet is connected.
  NifmRequestState* = enum
    NifmRequestStateInvalid = 0, ## /< Error.
    NifmRequestStateUnknown1 = 1, ## /< Not yet submitted or error.
    NifmRequestStateOnHold = 2, ## /< OnHold
    NifmRequestStateAvailable = 3, ## /< Available
    NifmRequestStateUnknown4 = 4, ## /< Unknown
    NifmRequestStateUnknown5 = 5 ## /< Unknown





## / Request

type
  NifmRequest* {.bycopy.} = object
    s*: Service                ## /< IRequest
    eventRequestState*: Event  ## /< First Event from cmd GetSystemEventReadableHandles, autoclear=true. Signaled when the RequestState changes.
    event1*: Event             ## /< Second Event from cmd GetSystemEventReadableHandles.
    requestState*: NifmRequestState ## /< \ref NifmRequestState from the GetRequestState cmd.
    res*: Result               ## /< Result from the GetResult cmd.


## / ClientId

type
  NifmClientId* {.bycopy.} = object
    id*: U32                   ## /< ClientId


## / IpV4Address

type
  NifmIpV4Address* {.bycopy.} = object
    `addr`*: array[4, U8]       ## /< IPv4 address, aka struct in_addr.


## / IpAddressSetting

type
  NifmIpAddressSetting* {.bycopy.} = object
    isAutomatic*: U8           ## /< Whether this setting is automatic. Ignored by \ref nifmGetCurrentIpConfigInfo.
    currentAddr*: NifmIpV4Address ## /< Current address.
    subnetMask*: NifmIpV4Address ## /< Subnet Mask.
    gateway*: NifmIpV4Address  ## /< Gateway.


## / DnsSetting

type
  NifmDnsSetting* {.bycopy.} = object
    isAutomatic*: U8           ## /< Whether this setting is automatic. Ignored by \ref nifmGetCurrentIpConfigInfo.
    primaryDnsServer*: NifmIpV4Address ## /< Primary DNS server.
    secondaryDnsServer*: NifmIpV4Address ## /< Secondary DNS server.


## / ProxySetting

type
  NifmProxySetting* {.bycopy.} = object
    enabled*: U8               ## /< Enables using the proxy when set.
    pad*: U8                   ## /< Padding
    port*: U16                 ## /< Port
    server*: array[0x64, char]  ## /< Server string, NUL-terminated.
    autoAuthEnabled*: U8       ## /< Enables auto-authentication when set, which uses the following two strings.
    user*: array[0x20, char]    ## /< User string, NUL-terminated.
    password*: array[0x20, char] ## /< Password string, NUL-terminated.
    pad2*: U8                  ## /< Padding


## / IpSettingData

type
  NifmIpSettingData* {.bycopy.} = object
    ipAddressSetting*: NifmIpAddressSetting ## /< \ref NifmIpAddressSetting
    dnsSetting*: NifmDnsSetting ## /< \ref NifmDnsSetting
    proxySetting*: NifmProxySetting ## /< \ref NifmProxySetting
    mtu*: U16                  ## /< MTU


## / WirelessSettingData

type
  NifmWirelessSettingData* {.bycopy.} = object
    ssidLen*: U8               ## /< NifmSfWirelessSettingData::ssid_len
    ssid*: array[0x21, char]    ## /< NifmSfWirelessSettingData::ssid
    unkX22*: U8                ## /< NifmSfWirelessSettingData::unk_x21
    pad*: U8                   ## /< Padding
    unkX24*: U32               ## /< NifmSfWirelessSettingData::unk_x22
    unkX28*: U32               ## /< NifmSfWirelessSettingData::unk_x23
    passphrase*: array[0x41, U8] ## /< NifmSfWirelessSettingData::passphrase
    pad2*: array[0x3, U8]       ## /< Padding


## / SfWirelessSettingData

type
  NifmSfWirelessSettingData* {.bycopy.} = object
    ssidLen*: U8               ## /< SSID length.
    ssid*: array[0x20, char]    ## /< SSID string.
    unkX21*: U8                ## /< Unknown
    unkX22*: U8                ## /< Unknown
    unkX23*: U8                ## /< Unknown
    passphrase*: array[0x41, U8] ## /< Passphrase


## / SfNetworkProfileData. Converted to/from \ref NifmNetworkProfileData.

type
  NifmSfNetworkProfileData* {.bycopy.} = object
    ipSettingData*: NifmIpSettingData ## /< \ref NifmIpSettingData
    uuid*: Uuid                ## /< Uuid
    networkName*: array[0x40, char] ## /< NUL-terminated Network Name string.
    unkX112*: U8               ## /< Unknown
    unkX113*: U8               ## /< Unknown
    unkX114*: U8               ## /< Unknown
    unkX115*: U8               ## /< Unknown
    wirelessSettingData*: NifmSfWirelessSettingData ## /< \ref NifmSfWirelessSettingData
    pad*: U8                   ## /< Padding


## / NetworkProfileData. Converted from/to \ref NifmSfNetworkProfileData.

type
  NifmNetworkProfileData* {.bycopy.} = object
    uuid*: Uuid                ## /< NifmSfNetworkProfileData::uuid
    networkName*: array[0x40, char] ## /< NifmSfNetworkProfileData::network_name
    unkX50*: U32               ## /< NifmSfNetworkProfileData::unk_x112
    unkX54*: U32               ## /< NifmSfNetworkProfileData::unk_x113
    unkX58*: U8                ## /< NifmSfNetworkProfileData::unk_x114
    unkX59*: U8                ## /< NifmSfNetworkProfileData::unk_x115
    pad*: array[2, U8]          ## /< Padding
    wirelessSettingData*: NifmWirelessSettingData ## /< \ref NifmWirelessSettingData
    ipSettingData*: NifmIpSettingData ## /< \ref NifmIpSettingData


## / Initialize nifm. This is used automatically by gethostid().

proc nifmInitialize*(serviceType: NifmServiceType): Result {.cdecl,
    importc: "nifmInitialize".}
## / Exit nifm. This is used automatically by gethostid().

proc nifmExit*() {.cdecl, importc: "nifmExit".}
## / Gets the Service object for the actual nifm:* service session.

proc nifmGetServiceSessionStaticService*(): ptr Service {.cdecl,
    importc: "nifmGetServiceSession_StaticService".}
## / Gets the Service object for IGeneralService.

proc nifmGetServiceSessionGeneralService*(): ptr Service {.cdecl,
    importc: "nifmGetServiceSession_GeneralService".}
## *
##  @brief GetClientId
##

proc nifmGetClientId*(): NifmClientId {.cdecl, importc: "nifmGetClientId".}
## *
##  @brief CreateRequest
##  @param[out] r \ref NifmRequest
##  @param[in] autoclear Event autoclear to use for NifmRequest::event1, a default of true can be used for this.
##

proc nifmCreateRequest*(r: ptr NifmRequest; autoclear: bool): Result {.cdecl,
    importc: "nifmCreateRequest".}
## *
##  @brief GetCurrentNetworkProfile
##  @param[out] profile \ref NifmNetworkProfileData
##

proc nifmGetCurrentNetworkProfile*(profile: ptr NifmNetworkProfileData): Result {.
    cdecl, importc: "nifmGetCurrentNetworkProfile".}
## *
##  @brief GetNetworkProfile
##  @param[in] uuid Uuid
##  @param[out] profile \ref NifmNetworkProfileData
##

proc nifmGetNetworkProfile*(uuid: Uuid; profile: ptr NifmNetworkProfileData): Result {.
    cdecl, importc: "nifmGetNetworkProfile".}
## *
##  @brief SetNetworkProfile
##  @note Only available with ::NifmServiceType_Admin.
##  @param[in] profile \ref NifmNetworkProfileData
##  @param[out] uuid Uuid
##

proc nifmSetNetworkProfile*(profile: ptr NifmNetworkProfileData; uuid: ptr Uuid): Result {.
    cdecl, importc: "nifmSetNetworkProfile".}
## *
##  @brief GetCurrentIpAddress
##  @param[out] out IPv4 address (struct in_addr).
##

proc nifmGetCurrentIpAddress*(`out`: ptr U32): Result {.cdecl,
    importc: "nifmGetCurrentIpAddress".}
## *
##  @brief GetCurrentIpConfigInfo
##  @param[out] current_addr Same as \ref nifmGetCurrentIpAddress output.
##  @param[out] subnet_mask Subnet Mask (struct in_addr).
##  @param[out] gateway Gateway (struct in_addr).
##  @param[out] primary_dns_server Primary DNS server IPv4 address (struct in_addr).
##  @param[out] secondary_dns_server Secondary DNS server IPv4 address (struct in_addr).
##

proc nifmGetCurrentIpConfigInfo*(currentAddr: ptr U32; subnetMask: ptr U32;
                                gateway: ptr U32; primaryDnsServer: ptr U32;
                                secondaryDnsServer: ptr U32): Result {.cdecl,
    importc: "nifmGetCurrentIpConfigInfo".}
## *
##  @note Works only if called from nifm:a or nifm:s.
##

proc nifmSetWirelessCommunicationEnabled*(enable: bool): Result {.cdecl,
    importc: "nifmSetWirelessCommunicationEnabled".}
proc nifmIsWirelessCommunicationEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "nifmIsWirelessCommunicationEnabled".}
## *
##  @note Will fail with 0xd46ed if Internet is neither connecting or connected (airplane mode or no known network in reach).
##  @param wifiStrength Strength of the Wi-Fi signal in number of bars from 0 to 3.
##

proc nifmGetInternetConnectionStatus*(connectionType: ptr NifmInternetConnectionType;
                                     wifiStrength: ptr U32; connectionStatus: ptr NifmInternetConnectionStatus): Result {.
    cdecl, importc: "nifmGetInternetConnectionStatus".}
proc nifmIsEthernetCommunicationEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "nifmIsEthernetCommunicationEnabled".}
## *
##  @brief IsAnyInternetRequestAccepted
##  @param[in] id \ref NifmClientId
##

proc nifmIsAnyInternetRequestAccepted*(id: NifmClientId): bool {.cdecl,
    importc: "nifmIsAnyInternetRequestAccepted".}
proc nifmIsAnyForegroundRequestAccepted*(`out`: ptr bool): Result {.cdecl,
    importc: "nifmIsAnyForegroundRequestAccepted".}
proc nifmPutToSleep*(): Result {.cdecl, importc: "nifmPutToSleep".}
proc nifmWakeUp*(): Result {.cdecl, importc: "nifmWakeUp".}
## *
##  @brief SetWowlDelayedWakeTime
##  @note Only available with ::NifmServiceType_System or ::NifmServiceType_Admin.
##  @note Only available on [9.0.0+].
##  @param[in] val Input value.
##

proc nifmSetWowlDelayedWakeTime*(val: S32): Result {.cdecl,
    importc: "nifmSetWowlDelayedWakeTime".}
## /@name IRequest
## /@{
## *
##  @brief Close a \ref NifmRequest.
##  @param r \ref NifmRequest
##

proc nifmRequestClose*(r: ptr NifmRequest) {.cdecl, importc: "nifmRequestClose".}
## *
##  @brief GetRequestState
##  @param r \ref NifmRequest
##  @param[out] out \ref NifmRequestState
##

proc nifmGetRequestState*(r: ptr NifmRequest; `out`: ptr NifmRequestState): Result {.
    cdecl, importc: "nifmGetRequestState".}
## *
##  @brief GetResult
##  @param r \ref NifmRequest
##

proc nifmGetResult*(r: ptr NifmRequest): Result {.cdecl, importc: "nifmGetResult".}
## *
##  @brief Cancel
##  @param r \ref NifmRequest
##

proc nifmRequestCancel*(r: ptr NifmRequest): Result {.cdecl,
    importc: "nifmRequestCancel".}
## *
##  @brief Submit
##  @param r \ref NifmRequest
##

proc nifmRequestSubmit*(r: ptr NifmRequest): Result {.cdecl,
    importc: "nifmRequestSubmit".}
## *
##  @brief SubmitAndWait
##  @param r \ref NifmRequest
##

proc nifmRequestSubmitAndWait*(r: ptr NifmRequest): Result {.cdecl,
    importc: "nifmRequestSubmitAndWait".}
## *
##  @brief GetAppletInfo
##  @note This is used by \ref nifmLaHandleNetworkRequestResult.
##  @param r \ref NifmRequest
##  @param[in] theme_color ThemeColor
##  @param[out] buffer Output buffer for storage data.
##  @param[in] size Output buffer size.
##  @param[out] applet_id \ref AppletId
##  @param[out] mode \ref LibAppletMode
##  @param[out] out_size Total data size written to the output buffer.
##

proc nifmRequestGetAppletInfo*(r: ptr NifmRequest; themeColor: U32; buffer: pointer;
                              size: csize_t; appletId: ptr U32; mode: ptr U32;
                              outSize: ptr U32): Result {.cdecl,
    importc: "nifmRequestGetAppletInfo".}
## *
##  @brief SetKeptInSleep
##  @note Only available on [3.0.0+].
##  @note ::NifmRequestState must be ::NifmRequestState_Unknown1.
##  @param r \ref NifmRequest
##  @param[in] flag Flag
##

proc nifmRequestSetKeptInSleep*(r: ptr NifmRequest; flag: bool): Result {.cdecl,
    importc: "nifmRequestSetKeptInSleep".}
## *
##  @brief RegisterSocketDescriptor. Only 1 socket can be registered at a time with a NifmRequest. Do not use directly, use \ref socketNifmRequestRegisterSocketDescriptor instead.
##  @note Only available on [3.0.0+].
##  @note ::NifmRequestState must be ::NifmRequestState_Available.
##  @param r \ref NifmRequest
##  @param[in] sockfd Socket fd
##

proc nifmRequestRegisterSocketDescriptor*(r: ptr NifmRequest; sockfd: cint): Result {.
    cdecl, importc: "nifmRequestRegisterSocketDescriptor".}
## *
##  @brief UnregisterSocketDescriptor. Do not use directly, use \ref socketNifmRequestUnregisterSocketDescriptor instead.
##  @note Only available on [3.0.0+].
##  @note ::NifmRequestState must be ::NifmRequestState_Available.
##  @param r \ref NifmRequest
##  @param[in] sockfd Socket fd, must match the fd previously registered with \ref nifmRequestRegisterSocketDescriptor.
##

proc nifmRequestUnregisterSocketDescriptor*(r: ptr NifmRequest; sockfd: cint): Result {.
    cdecl, importc: "nifmRequestUnregisterSocketDescriptor".}
## /@}
