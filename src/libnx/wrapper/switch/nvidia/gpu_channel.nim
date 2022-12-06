import
  ../kernel/event, channel, fence, ../types, types as t, ioctl, address_space

const
  GPFIFO_QUEUE_SIZE* = 0x800
  GPFIFO_ENTRY_NOT_MAIN* = bit(9)
  GPFIFO_ENTRY_NO_PREFETCH* = bit(31)

type
  NvGpuChannel* {.bycopy.} = object
    base*: NvChannel
    errorEvent*: Event
    objectId*: U64
    fence*: NvFence
    fenceIncr*: U32
    entries*: array[Gpfifo_Queue_Size, NvioctlGpfifoEntry]
    numEntries*: U32


proc nvGpuChannelCreate*(c: ptr NvGpuChannel; `as`: ptr NvAddressSpace;
                        prio: NvChannelPriority): Result {.cdecl,
    importc: "nvGpuChannelCreate".}
proc nvGpuChannelClose*(c: ptr NvGpuChannel) {.cdecl, importc: "nvGpuChannelClose".}
proc nvGpuChannelZcullBind*(c: ptr NvGpuChannel; iova: IovaT): Result {.cdecl,
    importc: "nvGpuChannelZcullBind".}
proc nvGpuChannelAppendEntry*(c: ptr NvGpuChannel; start: IovaT; numCmds: csize_t;
                             flags: U32; flushThreshold: U32): Result {.cdecl,
    importc: "nvGpuChannelAppendEntry".}
proc nvGpuChannelKickoff*(c: ptr NvGpuChannel): Result {.cdecl,
    importc: "nvGpuChannelKickoff".}
proc nvGpuChannelGetErrorNotification*(c: ptr NvGpuChannel;
                                      notif: ptr NvNotification): Result {.cdecl,
    importc: "nvGpuChannelGetErrorNotification".}
proc nvGpuChannelGetErrorInfo*(c: ptr NvGpuChannel; error: ptr NvError): Result {.cdecl,
    importc: "nvGpuChannelGetErrorInfo".}
proc nvGpuChannelGetSyncpointId*(c: ptr NvGpuChannel): U32 {.inline, cdecl,
    importc: "nvGpuChannelGetSyncpointId".} =
  return c.fence.id

proc nvGpuChannelGetFence*(c: ptr NvGpuChannel; fenceOut: ptr NvFence) {.inline, cdecl,
    importc: "nvGpuChannelGetFence".} =
  fenceOut.id = c.fence.id
  fenceOut.value = c.fence.value + c.fenceIncr

proc nvGpuChannelIncrFence*(c: ptr NvGpuChannel) {.inline, cdecl,
    importc: "nvGpuChannelIncrFence".} =
  inc(c.fenceIncr)
