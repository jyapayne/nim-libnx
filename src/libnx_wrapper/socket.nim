import strutils
import ospaths
const headersocket = currentSourcePath().splitPath().head & "/nx/include/switch/runtime/devices/socket.h"
import libnx_wrapper/types
type
  SocketInitConfig* {.importc: "SocketInitConfig", header: headersocket, bycopy.} = object
    bsdsockets_version* {.importc: "bsdsockets_version".}: uint32
    tcp_tx_buf_size* {.importc: "tcp_tx_buf_size".}: uint32
    tcp_rx_buf_size* {.importc: "tcp_rx_buf_size".}: uint32
    tcp_tx_buf_max_size* {.importc: "tcp_tx_buf_max_size".}: uint32
    tcp_rx_buf_max_size* {.importc: "tcp_rx_buf_max_size".}: uint32
    udp_tx_buf_size* {.importc: "udp_tx_buf_size".}: uint32
    udp_rx_buf_size* {.importc: "udp_rx_buf_size".}: uint32
    sb_efficiency* {.importc: "sb_efficiency".}: uint32
    serialized_out_addrinfos_max_size* {.importc: "serialized_out_addrinfos_max_size".}: csize
    serialized_out_hostent_max_size* {.importc: "serialized_out_hostent_max_size".}: csize
    bypass_nsd* {.importc: "bypass_nsd".}: bool
    dns_timeout* {.importc: "dns_timeout".}: cint


proc socketGetDefaultInitConfig*(): ptr SocketInitConfig {.cdecl,
    importc: "socketGetDefaultInitConfig", header: headersocket.}
proc socketInitialize*(config: ptr SocketInitConfig): Result {.cdecl,
    importc: "socketInitialize", header: headersocket.}
proc socketGetLastBsdResult*(): Result {.cdecl, importc: "socketGetLastBsdResult",
                                      header: headersocket.}
proc socketGetLastSfdnsresResult*(): Result {.cdecl,
    importc: "socketGetLastSfdnsresResult", header: headersocket.}
proc socketExit*() {.cdecl, importc: "socketExit", header: headersocket.}
proc socketInitializeDefault*(): Result {.inline, cdecl.} =
  return socketInitialize(socketGetDefaultInitConfig())
