import ioctl, ../types

type
  NvChannel* {.bycopy.} = object
    fd*: U32
    hasInit*: bool


proc nvChannelCreate*(c: ptr NvChannel; dev: cstring): Result {.cdecl,
    importc: "nvChannelCreate".}
proc nvChannelClose*(c: ptr NvChannel) {.cdecl, importc: "nvChannelClose".}
proc nvChannelSetPriority*(c: ptr NvChannel; prio: NvChannelPriority): Result {.cdecl,
    importc: "nvChannelSetPriority".}
proc nvChannelSetTimeout*(c: ptr NvChannel; timeout: U32): Result {.cdecl,
    importc: "nvChannelSetTimeout".}
