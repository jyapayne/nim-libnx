import strutils
import ospaths
const headervirtmem = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/virtmem.h"
import libnx_wrapper/types
proc virtmemReserve*(size: csize): pointer {.cdecl, importc: "virtmemReserve",
    header: headervirtmem.}
proc virtmemFree*(`addr`: pointer; size: csize) {.cdecl, importc: "virtmemFree",
    header: headervirtmem.}
proc virtmemReserveMap*(size: csize): pointer {.cdecl,
    importc: "virtmemReserveMap", header: headervirtmem.}
proc virtmemFreeMap*(`addr`: pointer; size: csize) {.cdecl,
    importc: "virtmemFreeMap", header: headervirtmem.}