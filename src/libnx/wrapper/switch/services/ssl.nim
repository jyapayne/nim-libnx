## *
##  @file fs.h
##  @brief SSL service IPC wrapper, for using client-mode TLS. See also: https://switchbrew.org/wiki/SSL_services
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / CaCertificateId

type
  SslCaCertificateId* = enum
    SslCaCertificateIdAll = -1, ## /< [3.0.0+] All
    SslCaCertificateIdNintendoCAG3 = 1, ## /< NintendoCAG3
    SslCaCertificateIdNintendoClass2CAG3 = 2, ## /< NintendoClass2CAG3
    SslCaCertificateIdAmazonRootCA1 = 1000, ## /< AmazonRootCA1
    SslCaCertificateIdStarfieldServicesRootCertificateAuthorityG2 = 1001, ## /< StarfieldServicesRootCertificateAuthorityG2
    SslCaCertificateIdAddTrustExternalCARoot = 1002, ## /< AddTrustExternalCARoot
    SslCaCertificateIdCOMODOCertificationAuthority = 1003, ## /< COMODOCertificationAuthority
    SslCaCertificateIdUTNDATACorpSGC = 1004, ## /< UTNDATACorpSGC
    SslCaCertificateIdUTNUSERFirstHardware = 1005, ## /< UTNUSERFirstHardware
    SslCaCertificateIdBaltimoreCyberTrustRoot = 1006, ## /< BaltimoreCyberTrustRoot
    SslCaCertificateIdCybertrustGlobalRoot = 1007, ## /< CybertrustGlobalRoot
    SslCaCertificateIdVerizonGlobalRootCA = 1008, ## /< VerizonGlobalRootCA
    SslCaCertificateIdDigiCertAssuredIDRootCA = 1009, ## /< DigiCertAssuredIDRootCA
    SslCaCertificateIdDigiCertAssuredIDRootG2 = 1010, ## /< DigiCertAssuredIDRootG2
    SslCaCertificateIdDigiCertGlobalRootCA = 1011, ## /< DigiCertGlobalRootCA
    SslCaCertificateIdDigiCertGlobalRootG2 = 1012, ## /< DigiCertGlobalRootG2
    SslCaCertificateIdDigiCertHighAssuranceEVRootCA = 1013, ## /< DigiCertHighAssuranceEVRootCA
    SslCaCertificateIdEntrustnetCertificationAuthority2048 = 1014, ## /< EntrustnetCertificationAuthority2048
    SslCaCertificateIdEntrustRootCertificationAuthority = 1015, ## /< EntrustRootCertificationAuthority
    SslCaCertificateIdEntrustRootCertificationAuthorityG2 = 1016, ## /< EntrustRootCertificationAuthorityG2
    SslCaCertificateIdGeoTrustGlobalCA2 = 1017, ## /< GeoTrustGlobalCA2 ([8.0.0+] ::SslTrustedCertStatus is ::SslTrustedCertStatus_EnabledNotTrusted)
    SslCaCertificateIdGeoTrustGlobalCA = 1018, ## /< GeoTrustGlobalCA ([8.0.0+] ::SslTrustedCertStatus is ::SslTrustedCertStatus_EnabledNotTrusted)
    SslCaCertificateIdGeoTrustPrimaryCertificationAuthorityG3 = 1019, ## /< GeoTrustPrimaryCertificationAuthorityG3 ([8.0.0+] ::SslTrustedCertStatus is ::SslTrustedCertStatus_EnabledNotTrusted)
    SslCaCertificateIdGeoTrustPrimaryCertificationAuthority = 1020, ## /< GeoTrustPrimaryCertificationAuthority ([8.0.0+] ::SslTrustedCertStatus is ::SslTrustedCertStatus_EnabledNotTrusted)
    SslCaCertificateIdGlobalSignRootCA = 1021, ## /< GlobalSignRootCA
    SslCaCertificateIdGlobalSignRootCAR2 = 1022, ## /< GlobalSignRootCAR2
    SslCaCertificateIdGlobalSignRootCAR3 = 1023, ## /< GlobalSignRootCAR3
    SslCaCertificateIdGoDaddyClass2CertificationAuthority = 1024, ## /< GoDaddyClass2CertificationAuthority
    SslCaCertificateIdGoDaddyRootCertificateAuthorityG2 = 1025, ## /< GoDaddyRootCertificateAuthorityG2
    SslCaCertificateIdStarfieldClass2CertificationAuthority = 1026, ## /< StarfieldClass2CertificationAuthority
    SslCaCertificateIdStarfieldRootCertificateAuthorityG2 = 1027, ## /< StarfieldRootCertificateAuthorityG2
    SslCaCertificateIdThawtePrimaryRootCAG3 = 1028, ## /< thawtePrimaryRootCAG3 ([8.0.0+] ::SslTrustedCertStatus is ::SslTrustedCertStatus_EnabledNotTrusted)
    SslCaCertificateIdThawtePrimaryRootCA = 1029, ## /< thawtePrimaryRootCA ([8.0.0+] ::SslTrustedCertStatus is ::SslTrustedCertStatus_EnabledNotTrusted)
    SslCaCertificateIdVeriSignClass3PublicPrimaryCertificationAuthorityG3 = 1030, ## /< VeriSignClass3PublicPrimaryCertificationAuthorityG3 ([8.0.0+] ::SslTrustedCertStatus is ::SslTrustedCertStatus_EnabledNotTrusted)
    SslCaCertificateIdVeriSignClass3PublicPrimaryCertificationAuthorityG5 = 1031, ## /< VeriSignClass3PublicPrimaryCertificationAuthorityG5 ([8.0.0+] ::SslTrustedCertStatus is ::SslTrustedCertStatus_EnabledNotTrusted)
    SslCaCertificateIdVeriSignUniversalRootCertificationAuthority = 1032, ## /< VeriSignUniversalRootCertificationAuthority ([8.0.0+] ::SslTrustedCertStatus is ::SslTrustedCertStatus_EnabledNotTrusted)
    SslCaCertificateIdDSTRootCAX3 = 1033 ## /< [6.0.0+] DSTRootCAX3


## / TrustedCertStatus

type
  SslTrustedCertStatus* = enum
    SslTrustedCertStatusInvalid = -1, ## /< Invalid
    SslTrustedCertStatusRemoved = 0, ## /< Removed
    SslTrustedCertStatusEnabledTrusted = 1, ## /< EnabledTrusted
    SslTrustedCertStatusEnabledNotTrusted = 2, ## /< EnabledNotTrusted
    SslTrustedCertStatusRevoked = 3 ## /< Revoked


## / FlushSessionCacheOptionType

type
  SslFlushSessionCacheOptionType* = enum
    SslFlushSessionCacheOptionTypeSingleHost = 0, ## /< SingleHost. Uses the input string.
    SslFlushSessionCacheOptionTypeAllHosts = 1 ## /< AllHosts. Doesn't use the input string.


## / DebugOptionType

type
  SslDebugOptionType* = enum
    SslDebugOptionTypeAllowDisableVerifyOption = 0 ## /< AllowDisableVerifyOption


## / SslVersion. This is a bitmask which controls the min/max TLS versions to use, depending on which lowest/highest bits are set (if Auto* isn't set).

type
  SslVersion* = enum
    SslVersionAuto = bit(0),    ## /< TLS version min = 1.0, max = 1.2.
    SslVersionTlsV10 = bit(3),  ## /< TLS 1.0.
    SslVersionTlsV11 = bit(4),  ## /< TLS 1.1.
    SslVersionTlsV12 = bit(5),  ## /< TLS 1.2.
    SslVersionTlsV13 = bit(6),  ## /< [11.0.0+] TLS 1.3.
    SslVersionAuto24 = bit(24)  ## /< [11.0.0+] Same as Auto.


## / CertificateFormat

type
  SslCertificateFormat* = enum
    SslCertificateFormatPem = 1, ## /< Pem
    SslCertificateFormatDer = 2 ## /< Der


## / InternalPki

type
  SslInternalPki* = enum
    SslInternalPkiDeviceClientCertDefault = 1 ## /< DeviceClientCertDefault. Enables using the DeviceCert.


## / ContextOption

type
  SslContextOption* = enum
    SslContextOptionCrlImportDateCheckEnable = 1 ## /< CrlImportDateCheckEnable. The default value at the time of \ref sslCreateContext is value 1.


## / VerifyOption. The default bitmask value at the time of \ref sslContextCreateConnection is ::SslVerifyOption_PeerCa | ::SslVerifyOption_HostName.
## / [5.0.0+] \ref sslConnectionSetVerifyOption: (::SslVerifyOption_PeerCa | ::SslVerifyOption_HostName) must be set, unless: ::SslOptionType_SkipDefaultVerify is set, or [9.0.0+] ::SslDebugOptionType_AllowDisableVerifyOption is set.
## / [6.0.0+] \ref sslConnectionSetVerifyOption: Following that, if ::SslVerifyOption_EvPolicyOid is set, then the following options must be set (besides the previously mentioned one): ::SslVerifyOption_PeerCa and ::SslVerifyOption_DateCheck.

type
  SslVerifyOption* = enum
    SslVerifyOptionPeerCa = bit(0), ## /< PeerCa
    SslVerifyOptionHostName = bit(1), ## /< HostName
    SslVerifyOptionDateCheck = bit(2), ## /< DateCheck
    SslVerifyOptionEvCertPartial = bit(3), ## /< EvCertPartial
    SslVerifyOptionEvPolicyOid = bit(4), ## /< [6.0.0+] EvPolicyOid
    SslVerifyOptionEvCertFingerprint = bit(5) ## /< [6.0.0+] EvCertFingerprint


## / IoMode. The default value at the time of \ref sslContextCreateConnection is ::SslIoMode_Blocking.
## / The socket non-blocking flag is always set regardless of this field, this is only used internally for calculating the timeout used by various cmds.

type
  SslIoMode* = enum
    SslIoModeBlocking = 1,      ## /< Blocking. Timeout = 5 minutes.
    SslIoModeNonBlocking = 2    ## /< NonBlocking. Timeout = 0.


## / PollEvent

type
  SslPollEvent* = enum
    SslPollEventRead = bit(0),  ## /< Read
    SslPollEventWrite = bit(1), ## /< Write
    SslPollEventExcept = bit(2) ## /< Except


## / SessionCacheMode

type
  SslSessionCacheMode* = enum
    SslSessionCacheModeNone = 0, ## /< None
    SslSessionCacheModeSessionId = 1, ## /< SessionId
    SslSessionCacheModeSessionTicket = 2 ## /< SessionTicket


## / RenegotiationMode

type
  SslRenegotiationMode* = enum
    SslRenegotiationModeNone = 0, ## /< None
    SslRenegotiationModeSecure = 1 ## /< Secure


## / OptionType. The default bool flags value for these at the time of \ref sslContextCreateConnection is cleared.

type
  SslOptionType* = enum
    SslOptionTypeDoNotCloseSocket = 0, ## /< DoNotCloseSocket. See \ref sslConnectionSetSocketDescriptor. This is only available if \ref sslConnectionSetSocketDescriptor wasn't used yet.
    SslOptionTypeGetServerCertChain = 1, ## /< [3.0.0+] GetServerCertChain. See \ref sslConnectionDoHandshake.
    SslOptionTypeSkipDefaultVerify = 2, ## /< [5.0.0+] SkipDefaultVerify. Checked by \ref sslConnectionSetVerifyOption, see \ref SslVerifyOption.
    SslOptionTypeEnableAlpn = 3 ## /< [9.0.0+] EnableAlpn. Only available with \ref sslConnectionSetOption. \ref sslConnectionSetSocketDescriptor should have been used prior to this - this will optionally use state setup by that, without throwing an error if that cmd wasn't used.


## / AlpnProtoState

type
  SslAlpnProtoState* = enum
    SslAlpnProtoStateNoSupport = 0, ## /< NoSupport
    SslAlpnProtoStateNegotiated = 1, ## /< Negotiated
    SslAlpnProtoStateNoOverlap = 2, ## /< NoOverlap
    SslAlpnProtoStateSelected = 3, ## /< Selected
    SslAlpnProtoStateEarlyValue = 4 ## /< EarlyValue


## / SslContext

type
  SslContext* {.bycopy.} = object
    s*: Service                ## /< ISslContext


## / SslConnection

type
  SslConnection* {.bycopy.} = object
    s*: Service                ## /< ISslConnection


## / BuiltInCertificateInfo

type
  SslBuiltInCertificateInfo* {.bycopy.} = object
    certId*: U32               ## /< \ref SslCaCertificateId
    status*: U32               ## /< \ref SslTrustedCertStatus
    certSize*: U64             ## /< CertificateSize
    certData*: ptr U8           ## /< CertificateData (converted from an offset to a ptr), in DER format.


## / SslServerCertDetailHeader

type
  SslServerCertDetailHeader* {.bycopy.} = object
    magicnum*: U64             ## /< Magicnum.
    certTotal*: U32            ## /< Total certs.
    pad*: U32                  ## /< Padding.


## / SslServerCertDetailEntry

type
  SslServerCertDetailEntry* {.bycopy.} = object
    size*: U32                 ## /< Size.
    offset*: U32               ## /< Offset.


## / CipherInfo

type
  SslCipherInfo* {.bycopy.} = object
    cipher*: array[0x40, char]  ## /< Cipher string.
    protocolVersion*: array[0x8, char] ## /< Protocol version string.


## / Initialize ssl. A default value of 0x3 can be used for num_sessions. This must be 0x1-0x4.

proc sslInitialize*(numSessions: U32): Result {.cdecl, importc: "sslInitialize".}
## / Exit ssl.

proc sslExit*() {.cdecl, importc: "sslExit".}
## / Gets the Service object for the actual ssl service session.

proc sslGetServiceSession*(): ptr Service {.cdecl, importc: "sslGetServiceSession".}
## *
##  @brief CreateContext
##  @note The CertStore is used automatically, regardless of what cmds are used.
##  @param[out] c \ref SslContext
##  @param[in] ssl_version \ref SslVersion
##

proc sslCreateContext*(c: ptr SslContext; sslVersion: U32): Result {.cdecl,
    importc: "sslCreateContext".}
## *
##  @brief GetContextCount
##  @note Not used by official sw.
##  @param[out] out Output value.
##

proc sslGetContextCount*(`out`: ptr U32): Result {.cdecl,
    importc: "sslGetContextCount".}
## *
##  @brief GetCertificates
##  @param[in] buffer Output buffer. The start of this buffer is an array of \ref SslBuiltInCertificateInfo, with the specified count. The cert data (SslBuiltInCertificateInfo::data) is located after this array.
##  @param[in] size Output buffer size, this should be the size from \ref sslGetCertificateBufSize.
##  @param[in] ca_cert_ids Input array of \ref SslCaCertificateId.
##  @param[in] count Size of the ca_cert_ids array in entries.
##  @param[out] total_out [3.0.0+] Total output entries. Will always match count on pre-3.0.0. This will differ from count when ::SslCaCertificateId_All is used.
##

proc sslGetCertificates*(buffer: pointer; size: U32; caCertIds: ptr U32; count: U32;
                        totalOut: ptr U32): Result {.cdecl,
    importc: "sslGetCertificates".}
## *
##  @brief GetCertificateBufSize
##  @param[in] ca_cert_ids Input array of \ref SslCaCertificateId.
##  @param[in] count Size of the ca_cert_ids array in entries.
##  @param[out] out Output size.
##

proc sslGetCertificateBufSize*(caCertIds: ptr U32; count: U32; `out`: ptr U32): Result {.
    cdecl, importc: "sslGetCertificateBufSize".}
## *
##  @brief FlushSessionCache
##  @note Only available on [5.0.0+].
##  @param[in] str Input string. Must be NULL with ::SslFlushSessionCacheOptionType_AllHosts.
##  @param[in] str_bufsize String buffer size, excluding NUL-terminator. Hence, this should be actual_bufsize-1. This must be 0 with ::SslFlushSessionCacheOptionType_AllHosts.
##  @param[in] type \ref SslFlushSessionCacheOptionType
##  @param[out] out Output value.
##

proc sslFlushSessionCache*(str: cstring; strBufsize: csize_t;
                          `type`: SslFlushSessionCacheOptionType; `out`: ptr U32): Result {.
    cdecl, importc: "sslFlushSessionCache".}
## *
##  @brief SetDebugOption
##  @note Only available on [6.0.0+].
##  @note The official impl of this doesn't actually use the cmd.
##  @param[in] buffer Input buffer, must not be NULL. The u8 from here is copied to state.
##  @param[in] size Buffer size, must not be 0.
##  @param[in] type \ref SslDebugOptionType
##

proc sslSetDebugOption*(buffer: pointer; size: csize_t; `type`: SslDebugOptionType): Result {.
    cdecl, importc: "sslSetDebugOption".}
## *
##  @brief GetDebugOption
##  @note Only available on [6.0.0+].
##  @param[out] buffer Output buffer, must not be NULL. An u8 is written here loaded from state.
##  @param[in] size Buffer size, must not be 0.
##  @param[in] type \ref SslDebugOptionType
##

proc sslGetDebugOption*(buffer: pointer; size: csize_t; `type`: SslDebugOptionType): Result {.
    cdecl, importc: "sslGetDebugOption".}
## /@name ISslContext
## /@{
## *
##  @brief Closes a Context object.
##  @param c \ref SslContext
##

proc sslContextClose*(c: ptr SslContext) {.cdecl, importc: "sslContextClose".}
## *
##  @brief SetOption
##  @note Prior to 4.x this is stubbed.
##  @param c \ref SslContext
##  @param[in] option \ref SslContextOption
##  @param[in] value Value to set. With ::SslContextOption_CrlImportDateCheckEnable, this must be 0 or 1.
##

proc sslContextSetOption*(c: ptr SslContext; option: SslContextOption; value: S32): Result {.
    cdecl, importc: "sslContextSetOption".}
## *
##  @brief GetOption
##  @note Prior to 4.x this is stubbed.
##  @param c \ref SslContext
##  @param[in] option \ref SslContextOption
##  @param[out] out Output value.
##

proc sslContextGetOption*(c: ptr SslContext; option: SslContextOption; `out`: ptr S32): Result {.
    cdecl, importc: "sslContextGetOption".}
## *
##  @brief CreateConnection
##  @param c \ref SslContext
##  @param[out] conn Output \ref SslConnection.
##

proc sslContextCreateConnection*(c: ptr SslContext; conn: ptr SslConnection): Result {.
    cdecl, importc: "sslContextCreateConnection".}
## *
##  @brief GetConnectionCount
##  @note Not exposed by official sw.
##  @param c \ref SslContext
##  @param[out] out Output value.
##

proc sslContextGetConnectionCount*(c: ptr SslContext; `out`: ptr U32): Result {.cdecl,
    importc: "sslContextGetConnectionCount".}
## *
##  @brief ImportServerPki
##  @note A maximum of 71 ServerPki objects (associated with the output Id) can be imported.
##  @param c \ref SslContext
##  @param[in] buffer Input buffer containing the cert data, must not be NULL. This can contain multiple certs. The certs can be CAs or server certs (no pubkeys).
##  @param[in] size Input buffer size.
##  @param[in] format \ref SslCertificateFormat
##  @param[out] id Output Id. Optional, can be NULL.
##

proc sslContextImportServerPki*(c: ptr SslContext; buffer: pointer; size: U32;
                               format: SslCertificateFormat; id: ptr U64): Result {.
    cdecl, importc: "sslContextImportServerPki".}
## *
##  @brief ImportClientPki
##  @note An error is thrown internally if this cmd or \ref sslContextRegisterInternalPki was already used previously.
##  @param c \ref SslContext
##  @param[in] pkcs12 PKCS#12 input buffer, must not be NULL.
##  @param[in] pkcs12_size pkcs12 buffer size.
##  @param[in] pw ASCII password string buffer, this can only be NULL if pw_size is 0. This will be internally copied to another buffer which was allocated with size=pw_size+1, for NUL-termination.
##  @param[in] pw_size Password buffer size, this can only be 0 if pw is NULL.
##  @param[out] id Output Id. Optional, can be NULL.
##

proc sslContextImportClientPki*(c: ptr SslContext; pkcs12: pointer; pkcs12Size: U32;
                               pw: cstring; pwSize: U32; id: ptr U64): Result {.cdecl,
    importc: "sslContextImportClientPki".}
## *
##  @brief Remove the specified *Pki, or on [3.0.0+] Crl.
##  @param c \ref SslContext
##  @param[in] id Id
##

proc sslContextRemovePki*(c: ptr SslContext; id: U64): Result {.cdecl,
    importc: "sslContextRemovePki".}
## *
##  @brief RegisterInternalPki
##  @note An error is thrown internally if this cmd or \ref sslContextImportClientPki was already used previously.
##  @param c \ref SslContext
##  @param[in] internal_pki \ref SslInternalPki
##  @param[out] id Output Id. Optional, can be NULL.
##

proc sslContextRegisterInternalPki*(c: ptr SslContext; internalPki: SslInternalPki;
                                   id: ptr U64): Result {.cdecl,
    importc: "sslContextRegisterInternalPki".}
## *
##  @brief AddPolicyOid
##  @param c \ref SslContext
##  @param[in] str Input string.
##  @param[in] str_bufsize String buffer size, excluding NUL-terminator (must not match the string length). Hence, this should be actual_bufsize-1. This must not be >0xff.
##

proc sslContextAddPolicyOid*(c: ptr SslContext; str: cstring; strBufsize: U32): Result {.
    cdecl, importc: "sslContextAddPolicyOid".}
## *
##  @brief ImportCrl
##  @note Only available on [3.0.0+].
##  @param c \ref SslContext
##  @param[in] buffer Input buffer, must not be NULL. This contains the DER CRL.
##  @param[in] size Input buffer size.
##  @param[out] id Output Id. Optional, can be NULL.
##

proc sslContextImportCrl*(c: ptr SslContext; buffer: pointer; size: U32; id: ptr U64): Result {.
    cdecl, importc: "sslContextImportCrl".}
## /@}
## /@name ISslConnection
## /@{
## *
##  @brief Closes a Connection object.
##  @param c \ref SslConnection
##

proc sslConnectionClose*(c: ptr SslConnection) {.cdecl, importc: "sslConnectionClose".}
## *
##  @brief SetSocketDescriptor. Do not use directly, use \ref socketSslConnectionSetSocketDescriptor instead.
##  @note An error is thrown if this was used previously.
##  @param c \ref SslConnection
##  @param[in] sockfd sockfd
##  @param[out] out_sockfd sockfd. Prior to using \ref sslConnectionClose, this must be closed if it's not negative (it will be -1 if ::SslOptionType_DoNotCloseSocket is set).
##

proc sslConnectionSetSocketDescriptor*(c: ptr SslConnection; sockfd: cint;
                                      outSockfd: ptr cint): Result {.cdecl,
    importc: "sslConnectionSetSocketDescriptor".}
## *
##  @brief SetHostName
##  @param c \ref SslConnection
##  @param[in] str Input string.
##  @param[in] str_bufsize String buffer size. This must not be >0xff.
##

proc sslConnectionSetHostName*(c: ptr SslConnection; str: cstring; strBufsize: U32): Result {.
    cdecl, importc: "sslConnectionSetHostName".}
## *
##  @brief SetVerifyOption
##  @param c \ref SslConnection
##  @param[in] verify_option Input bitmask of \ref SslVerifyOption.
##

proc sslConnectionSetVerifyOption*(c: ptr SslConnection; verifyOption: U32): Result {.
    cdecl, importc: "sslConnectionSetVerifyOption".}
## *
##  @brief SetIoMode
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[in] mode \ref SslIoMode
##

proc sslConnectionSetIoMode*(c: ptr SslConnection; mode: SslIoMode): Result {.cdecl,
    importc: "sslConnectionSetIoMode".}
## *
##  @brief GetSocketDescriptor. Do not use directly, use \ref socketSslConnectionGetSocketDescriptor instead.
##  @note This gets the input sockfd which was previously saved in state by \ref sslConnectionSetSocketDescriptor.
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[out] sockfd Output sockfd.
##

proc sslConnectionGetSocketDescriptor*(c: ptr SslConnection; sockfd: ptr cint): Result {.
    cdecl, importc: "sslConnectionGetSocketDescriptor".}
## *
##  @brief GetHostName
##  @param c \ref SslConnection
##  @param[out] str Output string buffer.
##  @param[in] str_bufsize String buffer size, must be large enough for the entire output string.
##  @param[out] out Output string length.
##

proc sslConnectionGetHostName*(c: ptr SslConnection; str: cstring; strBufsize: U32;
                              `out`: ptr U32): Result {.cdecl,
    importc: "sslConnectionGetHostName".}
## *
##  @brief GetVerifyOption
##  @param c \ref SslConnection
##  @param[out] out Output bitmask of \ref SslVerifyOption.
##

proc sslConnectionGetVerifyOption*(c: ptr SslConnection; `out`: ptr U32): Result {.
    cdecl, importc: "sslConnectionGetVerifyOption".}
## *
##  @brief GetIoMode
##  @param c \ref SslConnection
##  @param[out] out \ref SslIoMode
##

proc sslConnectionGetIoMode*(c: ptr SslConnection; `out`: ptr SslIoMode): Result {.
    cdecl, importc: "sslConnectionGetIoMode".}
## *
##  @brief DoHandshake
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @note \ref sslConnectionSetHostName must have been used previously with a non-empty string when ::SslVerifyOption_HostName is set.
##  @note The DoHandshakeGetServerCert cmd is only used if both server_certbuf/server_certbuf_size are set, otherwise the DoHandshake cmd is used (in which case out_size/total_certs will be left at value 0).
##  @note No certs are returned when ::SslVerifyOption_PeerCa is not set.
##  @param c \ref SslConnection
##  @param[out] out_size Total data size which was written to server_certbuf. Optional, can be NULL.
##  @param[out] total_certs Total certs which were written to server_certbuf, can be NULL.
##  @param[out] server_certbuf Optional output server cert buffer, can be NULL. Normally this just contains the server cert DER, however with ::SslOptionType_GetServerCertChain set this will contain the full chain (\ref sslConnectionGetServerCertDetail can be used to parse that). With ::SslIoMode_NonBlocking this buffer will be only filled in once - when this cmd returns successfully the buffer will generally be empty.
##  @param[in] server_certbuf_size Optional output server cert buffer size, can be 0.
##

proc sslConnectionDoHandshake*(c: ptr SslConnection; outSize: ptr U32;
                              totalCerts: ptr U32; serverCertbuf: pointer;
                              serverCertbufSize: U32): Result {.cdecl,
    importc: "sslConnectionDoHandshake".}
## *
##  @brief Parses the output server_certbuf from \ref sslConnectionDoHandshake where ::SslOptionType_GetServerCertChain is set.
##  @param[in] certbuf server_certbuf from \ref sslConnectionDoHandshake, must not be NULL.
##  @param[in] certbuf_size out_size from \ref sslConnectionDoHandshake.
##  @param[in] cert_index Cert index, must be within the range of certs stored in certbuf.
##  @param[out] cert Ptr for the ouput DER cert, must not be NULL.
##  @param[out] cert_size Size for the ouput cert, must not be NULL.
##

proc sslConnectionGetServerCertDetail*(certbuf: pointer; certbufSize: U32;
                                      certIndex: U32; cert: ptr pointer;
                                      certSize: ptr U32): Result {.cdecl,
    importc: "sslConnectionGetServerCertDetail".}
## *
##  @brief Read
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[out] buffer Output buffer, must not be NULL.
##  @param[in] size Output buffer size, must not be 0.
##  @param[out] out_size Actual transferred size.
##

proc sslConnectionRead*(c: ptr SslConnection; buffer: pointer; size: U32;
                       outSize: ptr U32): Result {.cdecl,
    importc: "sslConnectionRead".}
## *
##  @brief Write
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[in] buffer Input buffer, must not be NULL.
##  @param[in] size Input buffer size, must not be 0.
##  @param[out] out_size Actual transferred size.
##

proc sslConnectionWrite*(c: ptr SslConnection; buffer: pointer; size: U32;
                        outSize: ptr U32): Result {.cdecl,
    importc: "sslConnectionWrite".}
## *
##  @brief Pending
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[out] out Output value.
##

proc sslConnectionPending*(c: ptr SslConnection; `out`: ptr S32): Result {.cdecl,
    importc: "sslConnectionPending".}
## *
##  @brief Peek
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[out] buffer Output buffer, must not be NULL.
##  @param[in] size Output buffer size, must not be 0.
##  @param[out] out_size Output size.
##

proc sslConnectionPeek*(c: ptr SslConnection; buffer: pointer; size: U32;
                       outSize: ptr U32): Result {.cdecl,
    importc: "sslConnectionPeek".}
## *
##  @brief Poll
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[in] in_pollevent Input bitmask of \ref SslPollEvent.
##  @param[out] out_pollevent Output bitmask of \ref SslPollEvent.
##  @param[in] timeout Timeout in milliseconds.
##

proc sslConnectionPoll*(c: ptr SslConnection; inPollevent: U32; outPollevent: ptr U32;
                       timeout: U32): Result {.cdecl, importc: "sslConnectionPoll".}
## *
##  @brief GetVerifyCertError
##  @note The value in state is cleared after loading it.
##  @param c \ref SslConnection
##

proc sslConnectionGetVerifyCertError*(c: ptr SslConnection): Result {.cdecl,
    importc: "sslConnectionGetVerifyCertError".}
## *
##  @brief GetNeededServerCertBufferSize
##  @param c \ref SslConnection
##  @param[out] out Output value.
##

proc sslConnectionGetNeededServerCertBufferSize*(c: ptr SslConnection;
    `out`: ptr U32): Result {.cdecl,
                          importc: "sslConnectionGetNeededServerCertBufferSize".}
## *
##  @brief SetSessionCacheMode
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[in] mode \ref SslSessionCacheMode
##

proc sslConnectionSetSessionCacheMode*(c: ptr SslConnection;
                                      mode: SslSessionCacheMode): Result {.cdecl,
    importc: "sslConnectionSetSessionCacheMode".}
## *
##  @brief GetSessionCacheMode
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[out] out \ref SslSessionCacheMode
##

proc sslConnectionGetSessionCacheMode*(c: ptr SslConnection;
                                      `out`: ptr SslSessionCacheMode): Result {.
    cdecl, importc: "sslConnectionGetSessionCacheMode".}
## *
##  @brief GetSessionCacheMode
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##

proc sslConnectionFlushSessionCache*(c: ptr SslConnection): Result {.cdecl,
    importc: "sslConnectionFlushSessionCache".}
## *
##  @brief SetRenegotiationMode
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[in] mode \ref SslRenegotiationMode
##

proc sslConnectionSetRenegotiationMode*(c: ptr SslConnection;
                                       mode: SslRenegotiationMode): Result {.cdecl,
    importc: "sslConnectionSetRenegotiationMode".}
## *
##  @brief GetRenegotiationMode
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[out] out \ref SslRenegotiationMode
##

proc sslConnectionGetRenegotiationMode*(c: ptr SslConnection;
                                       `out`: ptr SslRenegotiationMode): Result {.
    cdecl, importc: "sslConnectionGetRenegotiationMode".}
## *
##  @brief SetOption
##  @param c \ref SslConnection
##  @param[in] option \ref SslOptionType
##  @param[in] flag Input flag value.
##

proc sslConnectionSetOption*(c: ptr SslConnection; option: SslOptionType; flag: bool): Result {.
    cdecl, importc: "sslConnectionSetOption".}
## *
##  @brief GetOption
##  @param c \ref SslConnection
##  @param[in] option \ref SslOptionType
##  @param[out] out Output flag value.
##

proc sslConnectionGetOption*(c: ptr SslConnection; option: SslOptionType;
                            `out`: ptr bool): Result {.cdecl,
    importc: "sslConnectionGetOption".}
## *
##  @brief GetVerifyCertErrors
##  @note An error is thrown when the cmd is successful, if the two output u32s match.
##  @param[out] out0 First output value, must not be NULL.
##  @param[out] out1 Second output value.
##  @param[out] errors Output array of Result, must not be NULL.
##  @param[in] count Size of the errors array in entries.
##

proc sslConnectionGetVerifyCertErrors*(c: ptr SslConnection; out0: ptr U32;
                                      out1: ptr U32; errors: ptr Result; count: U32): Result {.
    cdecl, importc: "sslConnectionGetVerifyCertErrors".}
## *
##  @brief GetCipherInfo
##  @note Only available on [4.0.0+].
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @param c \ref SslConnection
##  @param[out] out \ref SslCipherInfo
##

proc sslConnectionGetCipherInfo*(c: ptr SslConnection; `out`: ptr SslCipherInfo): Result {.
    cdecl, importc: "sslConnectionGetCipherInfo".}
## *
##  @brief SetNextAlpnProto
##  @note Only available on [9.0.0+].
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @note ::SslOptionType_EnableAlpn should be set at the time of using \ref sslConnectionDoHandshake, otherwise using this cmd will have no affect.
##  @param c \ref SslConnection
##  @param[in] buffer Input buffer, must not be NULL. This contains an array of {u8 size, {data with the specified size}}, which must be within the buffer-size bounds.
##  @param[in] size Input buffer size, must not be 0. Must be at least 0x2.
##

proc sslConnectionSetNextAlpnProto*(c: ptr SslConnection; buffer: ptr U8; size: U32): Result {.
    cdecl, importc: "sslConnectionSetNextAlpnProto".}
## *
##  @brief GetNextAlpnProto
##  @note Only available on [9.0.0+].
##  @note \ref sslConnectionSetSocketDescriptor must have been used prior to this successfully.
##  @note The output will be all-zero/empty if not available - such as when this was used before \ref sslConnectionDoHandshake.
##  @param c \ref SslConnection
##  @param[out] state \ref SslAlpnProtoState
##  @param[out] out Output string length.
##  @param[out] buffer Output string buffer, must not be NULL.
##  @param[in] size Output buffer size, must not be 0.
##

proc sslConnectionGetNextAlpnProto*(c: ptr SslConnection;
                                   state: ptr SslAlpnProtoState; `out`: ptr U32;
                                   buffer: ptr U8; size: U32): Result {.cdecl,
    importc: "sslConnectionGetNextAlpnProto".}
## /@}
