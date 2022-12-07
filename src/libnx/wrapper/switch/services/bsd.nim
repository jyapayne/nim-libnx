## *
##  @file bsd.h
##  @brief BSD sockets (bsd:u/s) service IPC wrapper. Please use the standard <sys/socket.h> interface instead.
##  @author plutoo
##  @author TuxSH
##  @copyright libnx Authors
##

import
  ../types, ../kernel/tmem, ../sf/service

## / Configuration structure for bsdInitalize

type
  BsdInitConfig* {.bycopy.} = object
    version*: U32              ## /< Observed 1 on [2.0.0+] LibAppletWeb, 2 on [3.0.0+].
    tmemBuffer*: pointer       ## /< User-provided buffer to use as backing for transfer memory. If NULL, a buffer will be allocated automatically. Must be large enough and page-aligned.
    tmemBufferSize*: csize_t   ## /< Size of the user-provided transfer memory backing buffer. Must be large enough and page-aligned.
    tcpTxBufSize*: U32         ## /< Size of the TCP transfer (send) buffer (initial or fixed).
    tcpRxBufSize*: U32         ## /< Size of the TCP receive buffer (initial or fixed).
    tcpTxBufMaxSize*: U32      ## /< Maximum size of the TCP transfer (send) buffer. If it is 0, the size of the buffer is fixed to its initial value.
    tcpRxBufMaxSize*: U32      ## /< Maximum size of the TCP receive buffer. If it is 0, the size of the buffer is fixed to its initial value.
    udpTxBufSize*: U32         ## /< Size of the UDP transfer (send) buffer (typically 0x2400 bytes).
    udpRxBufSize*: U32         ## /< Size of the UDP receive buffer (typically 0xA500 bytes).
    sbEfficiency*: U32         ## /< Number of buffers for each socket (standard values range from 1 to 8).

type
  SockAddr* = object
  FdSet* = object
  TimeVal* = object
  NfdsT* = uint
  PollFd* = object
  SockLenT* = uint32
  TimeSpec* = object
    tv_sec: clong
    tv_nsec: clong

var gBsdResult* {.importc: "g_bsdResult".}: Result

## /< Last Switch "result", per-thread

var gBsdErrno* {.importc: "g_bsdErrno".}: cint

## /< Last errno, per-thread
## / Fetch the default configuration for bsdInitialize.

proc bsdGetDefaultInitConfig*(): ptr BsdInitConfig {.cdecl,
    importc: "bsdGetDefaultInitConfig".}
## / Initialize the BSD service.

proc bsdInitialize*(config: ptr BsdInitConfig; numSessions: U32; serviceType: U32): Result {.
    cdecl, importc: "bsdInitialize".}
## / Exit the BSD service.

proc bsdExit*() {.cdecl, importc: "bsdExit".}
## / Gets the Service object for the actual BSD service session.

proc bsdGetServiceSession*(): ptr Service {.cdecl, importc: "bsdGetServiceSession".}
## / Creates a socket.

proc bsdSocket*(domain: cint; `type`: cint; protocol: cint): cint {.cdecl,
    importc: "bsdSocket".}
## / Like @ref bsdSocket but the newly created socket is immediately shut down.

proc bsdSocketExempt*(domain: cint; `type`: cint; protocol: cint): cint {.cdecl,
    importc: "bsdSocketExempt".}
proc bsdOpen*(pathname: cstring; flags: cint): cint {.cdecl, importc: "bsdOpen".}
proc bsdSelect*(nfds: cint; readfds: ptr FdSet; writefds: ptr FdSet;
               exceptfds: ptr FdSet; timeout: ptr Timeval): cint {.cdecl,
    importc: "bsdSelect".}
proc bsdPoll*(fds: ptr Pollfd; nfds: NfdsT; timeout: cint): cint {.cdecl,
    importc: "bsdPoll".}
proc bsdSysctl*(name: ptr cint; namelen: cuint; oldp: pointer; oldlenp: ptr csize_t;
               newp: pointer; newlen: csize_t): cint {.cdecl, importc: "bsdSysctl".}
proc bsdRecv*(sockfd: cint; buf: pointer; len: csize_t; flags: cint): SsizeT {.cdecl,
    importc: "bsdRecv".}
proc bsdRecvFrom*(sockfd: cint; buf: pointer; len: csize_t; flags: cint;
                 srcAddr: ptr Sockaddr; addrlen: ptr SocklenT): SsizeT {.cdecl,
    importc: "bsdRecvFrom".}
proc bsdSend*(sockfd: cint; buf: pointer; len: csize_t; flags: cint): SsizeT {.cdecl,
    importc: "bsdSend".}
proc bsdSendTo*(sockfd: cint; buf: pointer; len: csize_t; flags: cint;
               destAddr: ptr Sockaddr; addrlen: SocklenT): SsizeT {.cdecl,
    importc: "bsdSendTo".}
proc bsdAccept*(sockfd: cint; `addr`: ptr Sockaddr; addrlen: ptr SocklenT): cint {.cdecl,
    importc: "bsdAccept".}
proc bsdBind*(sockfd: cint; `addr`: ptr Sockaddr; addrlen: SocklenT): cint {.cdecl,
    importc: "bsdBind".}
proc bsdConnect*(sockfd: cint; `addr`: ptr Sockaddr; addrlen: SocklenT): cint {.cdecl,
    importc: "bsdConnect".}
proc bsdGetPeerName*(sockfd: cint; `addr`: ptr Sockaddr; addrlen: ptr SocklenT): cint {.
    cdecl, importc: "bsdGetPeerName".}
proc bsdGetSockName*(sockfd: cint; `addr`: ptr Sockaddr; addrlen: ptr SocklenT): cint {.
    cdecl, importc: "bsdGetSockName".}
proc bsdGetSockOpt*(sockfd: cint; level: cint; optname: cint; optval: pointer;
                   optlen: ptr SocklenT): cint {.cdecl, importc: "bsdGetSockOpt".}
proc bsdListen*(sockfd: cint; backlog: cint): cint {.cdecl, importc: "bsdListen".}
## / Made non-variadic for convenience.

proc bsdIoctl*(fd: cint; request: cint; data: pointer): cint {.cdecl, importc: "bsdIoctl".}
## / Made non-variadic for convenience.

proc bsdFcntl*(fd: cint; cmd: cint; flags: cint): cint {.cdecl, importc: "bsdFcntl".}
proc bsdSetSockOpt*(sockfd: cint; level: cint; optname: cint; optval: pointer;
                   optlen: SocklenT): cint {.cdecl, importc: "bsdSetSockOpt".}
proc bsdShutdown*(sockfd: cint; how: cint): cint {.cdecl, importc: "bsdShutdown".}
proc bsdShutdownAllSockets*(how: cint): cint {.cdecl,
    importc: "bsdShutdownAllSockets".}
proc bsdWrite*(fd: cint; buf: pointer; count: csize_t): SsizeT {.cdecl,
    importc: "bsdWrite".}
proc bsdRead*(fd: cint; buf: pointer; count: csize_t): SsizeT {.cdecl, importc: "bsdRead".}
proc bsdClose*(fd: cint): cint {.cdecl, importc: "bsdClose".}
## / Duplicate a socket (bsd:s).

proc bsdDuplicateSocket*(sockfd: cint): cint {.cdecl, importc: "bsdDuplicateSocket".}
proc bsdRecvMMsg*(sockfd: cint; buf: pointer; size: csize_t; vlen: cuint; flags: cint;
                 timeout: ptr Timespec): cint {.cdecl, importc: "bsdRecvMMsg".}
proc bsdSendMMsg*(sockfd: cint; buf: pointer; size: csize_t; vlen: cuint; flags: cint): cint {.
    cdecl, importc: "bsdSendMMsg".}
##  TODO: Reverse-engineer GetResourceStatistics.
