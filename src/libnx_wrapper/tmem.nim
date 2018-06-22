import strutils
import ospaths
const headertmem = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/tmem.h"
import libnx_wrapper/types
import libnx_wrapper/svc
type
  TransferMemory* {.importc: "TransferMemory", header: headertmem, bycopy.} = object
    handle* {.importc: "handle".}: Handle
    size* {.importc: "size".}: csize
    perm* {.importc: "perm".}: Permission
    src_addr* {.importc: "src_addr".}: pointer
    map_addr* {.importc: "map_addr".}: pointer


proc tmemCreate*(t: ptr TransferMemory; size: csize; perm: Permission): Result {.cdecl,
    importc: "tmemCreate", header: headertmem.}
proc tmemLoadRemote*(t: ptr TransferMemory; handle: Handle; size: csize;
                    perm: Permission) {.cdecl, importc: "tmemLoadRemote",
                                      header: headertmem.}
proc tmemMap*(t: ptr TransferMemory): Result {.cdecl, importc: "tmemMap",
    header: headertmem.}
proc tmemUnmap*(t: ptr TransferMemory): Result {.cdecl, importc: "tmemUnmap",
    header: headertmem.}
proc tmemGetAddr*(t: ptr TransferMemory): pointer {.inline, cdecl.} =
  return t.map_addr

proc tmemClose*(t: ptr TransferMemory): Result {.cdecl, importc: "tmemClose",
    header: headertmem.}