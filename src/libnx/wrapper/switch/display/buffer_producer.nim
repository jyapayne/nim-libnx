import
  types as t, binder, ../nvidia/fence, ../types

type
  INNER_C_STRUCT_buffer_producer_2* {.bycopy.} = object
    timestamp*: S64

  BqRect* {.bycopy.} = object
    left*: S32
    top*: S32
    right*: S32
    bottom*: S32

  BqBufferInput* {.bycopy.} = object
    anoBufferProducer3*: INNER_C_STRUCT_buffer_producer_2
    isAutoTimestamp*: S32
    crop*: BqRect
    scalingMode*: S32
    transform*: U32            ##  See the NATIVE_WINDOW_TRANSFORM_* enums.
    stickyTransform*: U32
    unk*: U32
    swapInterval*: U32
    fence*: NvMultiFence

  BqBufferOutput* {.bycopy.} = object
    width*: U32
    height*: U32
    transformHint*: U32
    numPendingBuffers*: U32

  BqGraphicBuffer* {.bycopy.} = object
    width*: U32
    height*: U32
    stride*: U32
    format*: U32
    usage*: U32
    nativeHandle*: ptr NativeHandle


proc bqRequestBuffer*(b: ptr Binder; bufferIdx: S32; buf: ptr BqGraphicBuffer): Result {.
    cdecl, importc: "bqRequestBuffer".}
proc bqDequeueBuffer*(b: ptr Binder; async: bool; width: U32; height: U32; format: S32;
                     usage: U32; buf: ptr S32; fence: ptr NvMultiFence): Result {.cdecl,
    importc: "bqDequeueBuffer".}
proc bqDetachBuffer*(b: ptr Binder; slot: S32): Result {.cdecl,
    importc: "bqDetachBuffer".}
proc bqQueueBuffer*(b: ptr Binder; buf: S32; input: ptr BqBufferInput;
                   output: ptr BqBufferOutput): Result {.cdecl,
    importc: "bqQueueBuffer".}
proc bqCancelBuffer*(b: ptr Binder; buf: S32; fence: ptr NvMultiFence): Result {.cdecl,
    importc: "bqCancelBuffer".}
proc bqQuery*(b: ptr Binder; what: S32; value: ptr S32): Result {.cdecl, importc: "bqQuery".}
proc bqConnect*(b: ptr Binder; api: S32; producerControlledByApp: bool;
               output: ptr BqBufferOutput): Result {.cdecl, importc: "bqConnect".}
proc bqDisconnect*(b: ptr Binder; api: S32): Result {.cdecl, importc: "bqDisconnect".}
proc bqSetPreallocatedBuffer*(b: ptr Binder; buf: S32; input: ptr BqGraphicBuffer): Result {.
    cdecl, importc: "bqSetPreallocatedBuffer".}
