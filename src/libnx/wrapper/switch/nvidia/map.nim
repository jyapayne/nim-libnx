import
  types as t, ../types

type
  NvMap* {.bycopy.} = object
    handle*: U32
    id*: U32
    size*: U32
    cpuAddr*: pointer
    kind*: NvKind
    hasInit*: bool
    isCpuCacheable*: bool


proc nvMapInit*(): Result {.cdecl, importc: "nvMapInit".}
proc nvMapGetFd*(): U32 {.cdecl, importc: "nvMapGetFd".}
proc nvMapExit*() {.cdecl, importc: "nvMapExit".}
proc nvMapCreate*(m: ptr NvMap; cpuAddr: pointer; size: U32; align: U32; kind: NvKind;
                 isCpuCacheable: bool): Result {.cdecl, importc: "nvMapCreate".}
proc nvMapLoadRemote*(m: ptr NvMap; id: U32): Result {.cdecl, importc: "nvMapLoadRemote".}
proc nvMapClose*(m: ptr NvMap) {.cdecl, importc: "nvMapClose".}
proc nvMapGetHandle*(m: ptr NvMap): U32 {.inline, cdecl.} =
  return m.handle

proc nvMapGetId*(m: ptr NvMap): U32 {.inline, cdecl.} =
  return m.id

proc nvMapGetSize*(m: ptr NvMap): U32 {.inline, cdecl.} =
  return m.size

proc nvMapGetCpuAddr*(m: ptr NvMap): pointer {.inline, cdecl.} =
  return m.cpuAddr

proc nvMapIsRemote*(m: ptr NvMap): bool {.inline, cdecl.} =
  return m.cpuAddr == nil

proc nvMapGetKind*(m: ptr NvMap): NvKind {.inline, cdecl.} =
  return m.kind
