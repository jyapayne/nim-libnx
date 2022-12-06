import
  types as t, ../types

type
  NvAddressSpace* {.bycopy.} = object
    fd*: U32
    pageSize*: U32
    hasInit*: bool


proc nvAddressSpaceCreate*(a: ptr NvAddressSpace; pageSize: U32): Result {.cdecl,
    importc: "nvAddressSpaceCreate".}
proc nvAddressSpaceClose*(a: ptr NvAddressSpace) {.cdecl,
    importc: "nvAddressSpaceClose".}
proc nvAddressSpaceAlloc*(a: ptr NvAddressSpace; sparse: bool; size: U64;
                         iovaOut: ptr IovaT): Result {.cdecl,
    importc: "nvAddressSpaceAlloc".}
proc nvAddressSpaceAllocFixed*(a: ptr NvAddressSpace; sparse: bool; size: U64;
                              iova: IovaT): Result {.cdecl,
    importc: "nvAddressSpaceAllocFixed".}
proc nvAddressSpaceFree*(a: ptr NvAddressSpace; iova: IovaT; size: U64): Result {.cdecl,
    importc: "nvAddressSpaceFree".}
proc nvAddressSpaceMap*(a: ptr NvAddressSpace; nvmapHandle: U32; isGpuCacheable: bool;
                       kind: NvKind; iovaOut: ptr IovaT): Result {.cdecl,
    importc: "nvAddressSpaceMap".}
proc nvAddressSpaceMapFixed*(a: ptr NvAddressSpace; nvmapHandle: U32;
                            isGpuCacheable: bool; kind: NvKind; iova: IovaT): Result {.
    cdecl, importc: "nvAddressSpaceMapFixed".}
proc nvAddressSpaceModify*(a: ptr NvAddressSpace; iova: IovaT; offset: U64; size: U64;
                          kind: NvKind): Result {.cdecl,
    importc: "nvAddressSpaceModify".}
proc nvAddressSpaceUnmap*(a: ptr NvAddressSpace; iova: IovaT): Result {.cdecl,
    importc: "nvAddressSpaceUnmap".}
