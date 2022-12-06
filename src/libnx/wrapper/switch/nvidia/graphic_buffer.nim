import
  ../display/types as dt, types as t, ../types

type
  NvSurface* {.bycopy.} = object
    width*: U32
    height*: U32
    colorFormat*: NvColorFormat
    layout*: NvLayout
    pitch*: U32
    unused*: U32               ##  usually this field contains the nvmap handle, but it's completely unused/overwritten during marshalling
    offset*: U32
    kind*: NvKind
    blockHeightLog2*: U32
    scan*: NvDisplayScanFormat
    secondFieldOffset*: U32
    flags*: U64
    size*: U64
    unk*: array[6, U32]         ##  compression related

  NvGraphicBuffer* {.bycopy.} = object
    header*: NativeHandle
    unk0*: S32                 ##  -1
    nvmapId*: S32              ##  nvmap object id
    unk2*: U32                 ##  0
    magic*: U32                ##  0xDAFFCAFF
    pid*: U32                  ##  42
    `type`*: U32               ##  ?
    usage*: U32                ##  GRALLOC_USAGE_* bitmask
    format*: U32               ##  PIXEL_FORMAT_*
    extFormat*: U32            ##  copy of the above (in most cases)
    stride*: U32               ##  in pixels!
    totalSize*: U32            ##  in bytes
    numPlanes*: U32            ##  usually 1
    unk12*: U32                ##  0
    planes*: array[3, NvSurface]
    unused*: U64               ##  official sw writes a pointer to bookkeeping data here, but it's otherwise completely unused/overwritten during marshalling

