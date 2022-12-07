## *
##  @file htcs.h
##  @brief HTC sockets (htcs) service IPC wrapper. Please use <<TODO>> instead.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

const
  HTCS_PEER_NAME_MAX* = 32
  HTCS_PORT_NAME_MAX* = 32
  HTCS_SESSION_COUNT_MAX* = 0x10
  HTCS_SOCKET_COUNT_MAX* = 40
  HTCS_FD_SET_SIZE* = Htcs_Socket_Count_Max

type
  HtcsAddressFamilyType* = uint16
  HtcsPeerName* {.bycopy.} = object
    name*: array[Htcs_Peer_Name_Max, char]

  HtcsPortName* {.bycopy.} = object
    name*: array[Htcs_Port_Name_Max, char]

  HtcsSockAddr* {.bycopy.} = object
    family*: HtcsAddressFamilyType
    peerName*: HtcsPeerName
    portName*: HtcsPortName

  HtcsTimeVal* {.bycopy.} = object
    tvSec*: S64
    tvUsec*: S64

  HtcsFdSet* {.bycopy.} = object
    fds*: array[Htcs_Fd_Set_Size, cint]

  HtcsSocketError* = enum
    HTCS_ENONE = 0, HTCS_EACCES = 2, HTCS_EADDRINUSE = 3, HTCS_EADDRNOTAVAIL = 4,
    HTCS_EAGAIN = 6, HTCS_EALREADY = 7, HTCS_EBADF = 8, HTCS_EBUSY = 10,
    HTCS_ECONNABORTED = 13, HTCS_ECONNREFUSED = 14, HTCS_ECONNRESET = 15,
    HTCS_EDESTADDRREQ = 17, HTCS_EFAULT = 21, HTCS_EINPROGRESS = 26, HTCS_EINTR = 27,
    HTCS_EINVAL = 28, HTCS_EIO = 29, HTCS_EISCONN = 30, HTCS_EMFILE = 33,
    HTCS_EMSGSIZE = 35, HTCS_ENETDOWN = 38, HTCS_ENETRESET = 39, HTCS_ENOBUFS = 42,
    HTCS_ENOMEM = 49, HTCS_ENOTCONN = 56, HTCS_ETIMEDOUT = 76, HTCS_EUNKNOWN = 79,
  HtcsMessageFlag* = enum
    HTCS_MSG_PEEK = 1, HTCS_MSG_WAITALL = 2
  HtcsShutdownType* = enum
    HTCS_SHUT_RD = 0, HTCS_SHUT_WR = 1, HTCS_SHUT_RDWR = 2
  HtcsFcntlOperation* = enum
    HTCS_F_GETFL = 3, HTCS_F_SETFL = 4
  HtcsFcntlFlag* = enum
    HTCS_O_NONBLOCK = 4
  HtcsAddressFamily* = enum
    HTCS_AF_HTCS = 0
  HtcsSocket* {.bycopy.} = object
    s*: Service


const HTCS_EWOULDBLOCK* = Htcs_Eagain







proc htcsInitialize*(numSessions: U32): Result {.cdecl, importc: "htcsInitialize".}
## / Initialize the HTCS service.

proc htcsExit*() {.cdecl, importc: "htcsExit".}
## / Exit the HTCS service.

proc htcsGetManagerServiceSession*(): ptr Service {.cdecl,
    importc: "htcsGetManagerServiceSession".}
## / Gets the Service object for the actual HTCS manager service session.

proc htcsGetMonitorServiceSession*(): ptr Service {.cdecl,
    importc: "htcsGetMonitorServiceSession".}
## / Gets the Service object for the actual HTCS monitor service session.

proc htcsGetPeerNameAny*(`out`: ptr HtcsPeerName): Result {.cdecl,
    importc: "htcsGetPeerNameAny".}
## / Manager functionality.
proc htcsGetDefaultHostName*(`out`: ptr HtcsPeerName): Result {.cdecl,
    importc: "htcsGetDefaultHostName".}
proc htcsCreateSocket*(outErr: ptr S32; `out`: ptr HtcsSocket;
                      enableDisconnectionEmulation: bool): Result {.cdecl,
    importc: "htcsCreateSocket".}
proc htcsStartSelect*(outTaskId: ptr U32; outEventHandle: ptr Handle; read: ptr S32;
                     numRead: csize_t; write: ptr S32; numWrite: csize_t;
                     `except`: ptr S32; numExcept: csize_t; tvSec: S64; tvUsec: S64): Result {.
    cdecl, importc: "htcsStartSelect".}
proc htcsEndSelect*(outErr: ptr S32; outCount: ptr S32; read: ptr S32; numRead: csize_t;
                   write: ptr S32; numWrite: csize_t; `except`: ptr S32;
                   numExcept: csize_t; taskId: U32): Result {.cdecl,
    importc: "htcsEndSelect".}

## / Socket functionality.

proc htcsSocketClose*(s: ptr HtcsSocket; outErr: ptr S32; outRes: ptr S32): Result {.cdecl,
    importc: "htcsSocketClose".}
proc htcsSocketConnect*(s: ptr HtcsSocket; outErr: ptr S32; outRes: ptr S32;
                       address: ptr HtcsSockAddr): Result {.cdecl,
    importc: "htcsSocketConnect".}
proc htcsSocketBind*(s: ptr HtcsSocket; outErr: ptr S32; outRes: ptr S32;
                    address: ptr HtcsSockAddr): Result {.cdecl,
    importc: "htcsSocketBind".}
proc htcsSocketListen*(s: ptr HtcsSocket; outErr: ptr S32; outRes: ptr S32;
                      backlogCount: S32): Result {.cdecl,
    importc: "htcsSocketListen".}
proc htcsSocketShutdown*(s: ptr HtcsSocket; outErr: ptr S32; outRes: ptr S32; how: S32): Result {.
    cdecl, importc: "htcsSocketShutdown".}
proc htcsSocketFcntl*(s: ptr HtcsSocket; outErr: ptr S32; outRes: ptr S32; command: S32;
                     value: S32): Result {.cdecl, importc: "htcsSocketFcntl".}
proc htcsSocketAcceptStart*(s: ptr HtcsSocket; outTaskId: ptr U32;
                           outEventHandle: ptr Handle): Result {.cdecl,
    importc: "htcsSocketAcceptStart".}
proc htcsSocketAcceptResults*(s: ptr HtcsSocket; outErr: ptr S32;
                             outSocket: ptr HtcsSocket;
                             outAddress: ptr HtcsSockAddr; taskId: U32): Result {.
    cdecl, importc: "htcsSocketAcceptResults".}
proc htcsSocketRecvStart*(s: ptr HtcsSocket; outTaskId: ptr U32;
                         outEventHandle: ptr Handle; memSize: S32; flags: S32): Result {.
    cdecl, importc: "htcsSocketRecvStart".}
proc htcsSocketRecvResults*(s: ptr HtcsSocket; outErr: ptr S32; outSize: ptr S64;
                           buffer: pointer; bufferSize: csize_t; taskId: U32): Result {.
    cdecl, importc: "htcsSocketRecvResults".}
proc htcsSocketSendStart*(s: ptr HtcsSocket; outTaskId: ptr U32;
                         outEventHandle: ptr Handle; buffer: pointer;
                         bufferSize: csize_t; flags: S32): Result {.cdecl,
    importc: "htcsSocketSendStart".}
proc htcsSocketSendResults*(s: ptr HtcsSocket; outErr: ptr S32; outSize: ptr S64;
                           taskId: U32): Result {.cdecl,
    importc: "htcsSocketSendResults".}
proc htcsSocketStartSend*(s: ptr HtcsSocket; outTaskId: ptr U32;
                         outEventHandle: ptr Handle; outMaxSize: ptr S64; size: S64;
                         flags: S32): Result {.cdecl, importc: "htcsSocketStartSend".}
proc htcsSocketContinueSend*(s: ptr HtcsSocket; outSize: ptr S64; outWait: ptr bool;
                            buffer: pointer; bufferSize: csize_t; taskId: U32): Result {.
    cdecl, importc: "htcsSocketContinueSend".}
proc htcsSocketEndSend*(s: ptr HtcsSocket; outErr: ptr S32; outSize: ptr S64; taskId: U32): Result {.
    cdecl, importc: "htcsSocketEndSend".}
proc htcsSocketStartRecv*(s: ptr HtcsSocket; outTaskId: ptr U32;
                         outEventHandle: ptr Handle; size: S64; flags: S32): Result {.
    cdecl, importc: "htcsSocketStartRecv".}
proc htcsSocketEndRecv*(s: ptr HtcsSocket; outErr: ptr S32; outSize: ptr S64;
                       buffer: pointer; bufferSize: csize_t; taskId: U32): Result {.
    cdecl, importc: "htcsSocketEndRecv".}
proc htcsSocketGetPrimitive*(s: ptr HtcsSocket; `out`: ptr S32): Result {.cdecl,
    importc: "htcsSocketGetPrimitive".}
proc htcsCloseSocket*(s: ptr HtcsSocket) {.cdecl, importc: "htcsCloseSocket".}