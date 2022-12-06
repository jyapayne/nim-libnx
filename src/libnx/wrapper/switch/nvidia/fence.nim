import
  ioctl, ../types, ../result

type
  NvFence* = NvioctlFence
  NvMultiFence* {.bycopy.} = object
    numFences*: U32
    fences*: array[4, NvFence]


proc nvFenceInit*(): Result {.cdecl, importc: "nvFenceInit".}
proc nvFenceExit*() {.cdecl, importc: "nvFenceExit".}
proc nvFenceWait*(f: ptr NvFence; timeoutUs: S32): Result {.cdecl,
    importc: "nvFenceWait".}
proc nvMultiFenceCreate*(mf: ptr NvMultiFence; fence: ptr NvFence) {.inline, cdecl,
    importc: "nvMultiFenceCreate".} =
  mf.numFences = 1
  mf.fences[0] = fence[]

proc nvMultiFenceWait*(mf: ptr NvMultiFence; timeoutUs: S32): Result {.cdecl,
    importc: "nvMultiFenceWait".}
