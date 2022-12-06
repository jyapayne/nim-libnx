import
  ../../types, ../../services/ssl, ../../services/nifm

## / BSD service type used by the socket driver.

type
  BsdServiceType* = enum
    BsdServiceTypeUser = bit(0), ## /< Uses bsd:u (default).
    BsdServiceTypeSystem = bit(1), ## /< Uses bsd:s.
    BsdServiceTypeAuto = BsdServiceTypeUser.int or BsdServiceTypeSystem.int ## /< Tries to use bsd:s first, and if that fails uses bsd:u (official software behavior).


## / Configuration structure for socketInitalize

type
  SocketInitConfig* {.bycopy.} = object
    bsdsocketsVersion*: U32    ## /< Observed 1 on 2.0 LibAppletWeb, 2 on 3.0.
    tcpTxBufSize*: U32         ## /< Size of the TCP transfer (send) buffer (initial or fixed).
    tcpRxBufSize*: U32         ## /< Size of the TCP receive buffer (initial or fixed).
    tcpTxBufMaxSize*: U32      ## /< Maximum size of the TCP transfer (send) buffer. If it is 0, the size of the buffer is fixed to its initial value.
    tcpRxBufMaxSize*: U32      ## /< Maximum size of the TCP receive buffer. If it is 0, the size of the buffer is fixed to its initial value.
    udpTxBufSize*: U32         ## /< Size of the UDP transfer (send) buffer (typically 0x2400 bytes).
    udpRxBufSize*: U32         ## /< Size of the UDP receive buffer (typically 0xA500 bytes).
    sbEfficiency*: U32         ## /< Number of buffers for each socket (standard values range from 1 to 8).
    numBsdSessions*: U32       ## /< Number of BSD service sessions (typically 3).
    bsdServiceType*: BsdServiceType ## /< BSD service type (typically \ref BsdServiceType_User).

proc socketGetDefaultInitConfig*(): ptr SocketInitConfig {.cdecl,
    importc: "socketGetDefaultInitConfig".}
## / Fetch the default configuration for the socket driver.

proc socketInitialize*(config: ptr SocketInitConfig): Result {.cdecl,
    importc: "socketInitialize".}
## / Initalize the socket driver.

proc socketGetLastResult*(): Result {.cdecl, importc: "socketGetLastResult".}
## / Fetch the last bsd:u/s Switch result code (thread-local).

proc socketExit*() {.cdecl, importc: "socketExit".}
## / Deinitialize the socket driver.

proc socketInitializeDefault*(): Result {.inline, cdecl.} =
  ## / Initalize the socket driver using the default configuration.
  return socketInitialize(nil)

proc socketSslConnectionSetSocketDescriptor*(c: ptr SslConnection; sockfd: cint): cint {.
    cdecl, importc: "socketSslConnectionSetSocketDescriptor".}
## / Wrapper for \ref sslConnectionSetSocketDescriptor. Returns the output sockfd on success and -1 on error. errno==ENOENT indicates that no sockfd was returned, this error must be ignored.

proc socketSslConnectionGetSocketDescriptor*(c: ptr SslConnection): cint {.cdecl,
    importc: "socketSslConnectionGetSocketDescriptor".}
## / Wrapper for \ref sslConnectionGetSocketDescriptor. Returns the output sockfd on success and -1 on error.

proc socketNifmRequestRegisterSocketDescriptor*(r: ptr NifmRequest; sockfd: cint): cint {.
    cdecl, importc: "socketNifmRequestRegisterSocketDescriptor".}
## / Wrapper for \ref nifmRequestRegisterSocketDescriptor. Returns 0 on success and -1 on error.

proc socketNifmRequestUnregisterSocketDescriptor*(r: ptr NifmRequest; sockfd: cint): cint {.
    cdecl, importc: "socketNifmRequestUnregisterSocketDescriptor".}
## / Wrapper for \ref nifmRequestUnregisterSocketDescriptor. Returns 0 on success and -1 on error.

