import strutils
import ospaths
const headerbuffer_producer = currentSourcePath().splitPath().head & "/nx/include/switch/gfx/buffer_producer.h"
import libnx/types
import libnx/binder
import libnx/nvioctl
type
  INNER_C_STRUCT_3208597589* {.importc: "no_name", header: headerbuffer_producer,
                              bycopy.} = object
    unk_x0* {.importc: "unk_x0".}: uint32
    nvmap_handle0* {.importc: "nvmap_handle0".}: uint32
    unk_x8* {.importc: "unk_x8".}: uint32
    unk_xc* {.importc: "unk_xc".}: uint32
    unk_x10* {.importc: "unk_x10".}: uint32
    unk_x14* {.importc: "unk_x14".}: uint32
    unk_x18* {.importc: "unk_x18".}: uint32
    unk_x1c* {.importc: "unk_x1c".}: uint32
    unk_x20* {.importc: "unk_x20".}: uint32
    width_unk0* {.importc: "width_unk0".}: uint32
    buffer_size0* {.importc: "buffer_size0".}: uint32
    unk_x2c* {.importc: "unk_x2c".}: uint32
    unk_x30* {.importc: "unk_x30".}: uint32
    width_unk1* {.importc: "width_unk1".}: uint32
    height_unk* {.importc: "height_unk".}: uint32
    flags* {.importc: "flags".}: uint32
    unk_x40* {.importc: "unk_x40".}: uint32
    unk_x44* {.importc: "unk_x44".}: uint32
    byte_stride* {.importc: "byte_stride".}: uint32
    nvmap_handle1* {.importc: "nvmap_handle1".}: uint32
    buffer_offset* {.importc: "buffer_offset".}: uint32
    unk_x54* {.importc: "unk_x54".}: uint32
    unk_x58* {.importc: "unk_x58".}: uint32
    unk_x5c* {.importc: "unk_x5c".}: uint32
    unk_x60* {.importc: "unk_x60".}: uint32
    unk_x64* {.importc: "unk_x64".}: uint32
    unk_x68* {.importc: "unk_x68".}: uint32
    buffer_size1* {.importc: "buffer_size1".}: uint32
    unk_x70* {.importc: "unk_x70".}: array[0x00000033, uint32]
    timestamp* {.importc: "timestamp".}: uint64

  bufferProducerFence* {.importc: "bufferProducerFence",
                        header: headerbuffer_producer, bycopy.} = object
    is_valid* {.importc: "is_valid".}: uint32
    nv_fences* {.importc: "nv_fences".}: array[4, nvioctl_fence]

  bufferProducerRect* {.importc: "bufferProducerRect",
                       header: headerbuffer_producer, bycopy.} = object
    left* {.importc: "left".}: s32
    top* {.importc: "top".}: s32
    right* {.importc: "right".}: s32
    bottom* {.importc: "bottom".}: s32

  bufferProducerQueueBufferInput* {.importc: "bufferProducerQueueBufferInput",
                                   header: headerbuffer_producer, bycopy.} = object
    timestamp* {.importc: "timestamp".}: s64
    isAutoTimestamp* {.importc: "isAutoTimestamp".}: s32
    crop* {.importc: "crop".}: bufferProducerRect
    scalingMode* {.importc: "scalingMode".}: s32
    transform* {.importc: "transform".}: uint32
    stickyTransform* {.importc: "stickyTransform".}: uint32
    unk* {.importc: "unk".}: array[2, uint32]
    fence* {.importc: "fence".}: bufferProducerFence

  bufferProducerQueueBufferOutput* {.importc: "bufferProducerQueueBufferOutput",
                                    header: headerbuffer_producer, bycopy.} = object
    width* {.importc: "width".}: uint32
    height* {.importc: "height".}: uint32
    transformHint* {.importc: "transformHint".}: uint32
    numPendingBuffers* {.importc: "numPendingBuffers".}: uint32

  bufferProducerGraphicBuffer* {.importc: "bufferProducerGraphicBuffer",
                                header: headerbuffer_producer, bycopy.} = object
    magic* {.importc: "magic".}: uint32
    width* {.importc: "width".}: uint32
    height* {.importc: "height".}: uint32
    stride* {.importc: "stride".}: uint32
    format* {.importc: "format".}: uint32
    usage* {.importc: "usage".}: uint32
    pid* {.importc: "pid".}: uint32
    refcount* {.importc: "refcount".}: uint32
    numFds* {.importc: "numFds".}: uint32
    numInts* {.importc: "numInts".}: uint32
    data* {.importc: "data".}: INNER_C_STRUCT_3208597589


const
  NATIVE_WINDOW_WIDTH* = 0
  NATIVE_WINDOW_HEIGHT* = 1
  NATIVE_WINDOW_FORMAT* = 2

const
  NATIVE_WINDOW_API_CPU* = 2

const
  HAL_TRANSFORM_FLIP_H* = 0x00000001
  HAL_TRANSFORM_FLIP_V* = 0x00000002
  HAL_TRANSFORM_ROT_90* = 0x00000004
  HAL_TRANSFORM_ROT_180* = 0x00000003
  HAL_TRANSFORM_ROT_270* = 0x00000007

const
  NATIVE_WINDOW_TRANSFORM_FLIP_H* = HAL_TRANSFORM_FLIP_H
  NATIVE_WINDOW_TRANSFORM_FLIP_V* = HAL_TRANSFORM_FLIP_V
  NATIVE_WINDOW_TRANSFORM_ROT_90* = HAL_TRANSFORM_ROT_90
  NATIVE_WINDOW_TRANSFORM_ROT_180* = HAL_TRANSFORM_ROT_180
  NATIVE_WINDOW_TRANSFORM_ROT_270* = HAL_TRANSFORM_ROT_270

proc bufferProducerInitialize*(session: ptr Binder): Result {.cdecl,
    importc: "bufferProducerInitialize", header: headerbuffer_producer.}
proc bufferProducerExit*() {.cdecl, importc: "bufferProducerExit",
                           header: headerbuffer_producer.}
proc bufferProducerRequestBuffer*(bufferIdx: s32;
                                 buf: ptr bufferProducerGraphicBuffer): Result {.
    cdecl, importc: "bufferProducerRequestBuffer", header: headerbuffer_producer.}
proc bufferProducerDequeueBuffer*(async: bool; width: uint32; height: uint32; format: s32;
                                 usage: uint32; buf: ptr s32;
                                 fence: ptr bufferProducerFence): Result {.cdecl,
    importc: "bufferProducerDequeueBuffer", header: headerbuffer_producer.}
proc bufferProducerDetachBuffer*(slot: s32): Result {.cdecl,
    importc: "bufferProducerDetachBuffer", header: headerbuffer_producer.}
proc bufferProducerQueueBuffer*(buf: s32;
                               input: ptr bufferProducerQueueBufferInput;
                               output: ptr bufferProducerQueueBufferOutput): Result {.
    cdecl, importc: "bufferProducerQueueBuffer", header: headerbuffer_producer.}
proc bufferProducerQuery*(what: s32; value: ptr s32): Result {.cdecl,
    importc: "bufferProducerQuery", header: headerbuffer_producer.}
proc bufferProducerConnect*(api: s32; producerControlledByApp: bool;
                           output: ptr bufferProducerQueueBufferOutput): Result {.
    cdecl, importc: "bufferProducerConnect", header: headerbuffer_producer.}
proc bufferProducerDisconnect*(api: s32): Result {.cdecl,
    importc: "bufferProducerDisconnect", header: headerbuffer_producer.}
proc bufferProducerGraphicBufferInit*(buf: s32;
                                     input: ptr bufferProducerGraphicBuffer): Result {.
    cdecl, importc: "bufferProducerGraphicBufferInit",
    header: headerbuffer_producer.}