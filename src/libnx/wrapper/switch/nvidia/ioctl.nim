import
  ../types

##  The below defines are based on Linux kernel ioctl.h.

const
  NV_IOC_NRBITS* = 8
  NV_IOC_TYPEBITS* = 8
  NV_IOC_SIZEBITS* = 14
  NV_IOC_DIRBITS* = 2
  NV_IOC_NRMASK* = ((1 shl Nv_Ioc_Nrbits) - 1)
  NV_IOC_TYPEMASK* = ((1 shl Nv_Ioc_Typebits) - 1)
  NV_IOC_SIZEMASK* = ((1 shl Nv_Ioc_Sizebits) - 1)
  NV_IOC_DIRMASK* = ((1 shl Nv_Ioc_Dirbits) - 1)
  NV_IOC_NRSHIFT* = 0
  NV_IOC_TYPESHIFT* = (Nv_Ioc_Nrshift + Nv_Ioc_Nrbits)
  NV_IOC_SIZESHIFT* = (Nv_Ioc_Typeshift + Nv_Ioc_Typebits)
  NV_IOC_DIRSHIFT* = (Nv_Ioc_Sizeshift + Nv_Ioc_Sizebits)

##  Direction bits.

const
  NV_IOC_NONE* = 0'u
  NV_IOC_WRITE* = 1'u
  NV_IOC_READ* = 2'u

template nv_Ioc*(dir, `type`, nr, size: untyped): untyped =
  (((dir) shl nv_Ioc_Dirshift) or ((`type`) shl nv_Ioc_Typeshift) or
      ((nr) shl nv_Ioc_Nrshift) or ((size) shl nv_Ioc_Sizeshift))

##  used to create numbers

template nv_Io*(`type`, nr: untyped): untyped =
  nv_Ioc(nv_Ioc_None, (`type`), (nr), 0)

template nv_Ior*(`type`, nr, size: untyped): untyped =
  nv_Ioc(nv_Ioc_Read, (`type`), (nr), sizeof((size)))

template nv_Iow*(`type`, nr, size: untyped): untyped =
  nv_Ioc(nv_Ioc_Write, (`type`), (nr), sizeof((size)))

template nv_Iowr*(`type`, nr, size: untyped): untyped =
  nv_Ioc(nv_Ioc_Read or nv_Ioc_Write, (`type`), (nr), sizeof((size)))

##  used to decode ioctl numbers..

template nv_Ioc_Dir*(nr: untyped): untyped =
  (((nr) shr nv_Ioc_Dirshift) and nv_Ioc_Dirmask)

template nv_Ioc_Type*(nr: untyped): untyped =
  (((nr) shr nv_Ioc_Typeshift) and nv_Ioc_Typemask)

template nv_Ioc_Nr*(nr: untyped): untyped =
  (((nr) shr nv_Ioc_Nrshift) and nv_Ioc_Nrmask)

template nv_Ioc_Size*(nr: untyped): untyped =
  (((nr) shr nv_Ioc_Sizeshift) and nv_Ioc_Sizemask)

type
  INNER_C_UNION_ioctl_2* {.bycopy, union.} = object
    desc*: U64
    desc32*: array[2, U32]

  NvioctlZcullInfo* {.bycopy.} = object
    widthAlignPixels*: U32     ##  0x20  (32)
    heightAlignPixels*: U32    ##  0x20  (32)
    pixelSquaresByAliquots*: U32 ##  0x400 (1024)
    aliquotTotal*: U32         ##  0x800 (2048)
    regionByteMultiplier*: U32 ##  0x20  (32)
    regionHeaderSize*: U32     ##  0x20  (32)
    subregionHeaderSize*: U32  ##  0xC0  (192)
    subregionWidthAlignPixels*: U32 ##  0x20  (32)
    subregionHeightAlignPixels*: U32 ##  0x40  (64)
    subregionCount*: U32       ##  0x10  (16)

  NvioctlZbcEntry* {.bycopy.} = object
    colorDs*: array[4, U32]
    colorL2*: array[4, U32]
    depth*: U32
    refCnt*: U32
    format*: U32
    `type`*: U32
    size*: U32

  NvioctlGpuCharacteristics* {.bycopy.} = object
    arch*: U32                 ##  0x120 (NVGPU_GPU_ARCH_GM200)
    impl*: U32                 ##  0xB (NVGPU_GPU_IMPL_GM20B)
    rev*: U32                  ##  0xA1 (Revision A1)
    numGpc*: U32               ##  0x1
    l2CacheSize*: U64          ##  0x40000
    onBoardVideoMemorySize*: U64 ##  0x0 (not used)
    numTpcPerGpc*: U32         ##  0x2
    busType*: U32              ##  0x20 (NVGPU_GPU_BUS_TYPE_AXI)
    bigPageSize*: U32          ##  0x20000
    compressionPageSize*: U32  ##  0x20000
    pdeCoverageBitCount*: U32  ##  0x1B
    availableBigPageSizes*: U32 ##  0x30000
    gpcMask*: U32              ##  0x1
    smArchSmVersion*: U32      ##  0x503 (Maxwell Generation 5.0.3?)
    smArchSpaVersion*: U32     ##  0x503 (Maxwell Generation 5.0.3?)
    smArchWarpCount*: U32      ##  0x80
    gpuVaBitCount*: U32        ##  0x28
    reserved*: U32             ##  NULL
    flags*: U64                ##  0x55
    twodClass*: U32            ##  0x902D (FERMI_TWOD_A)
    threedClass*: U32          ##  0xB197 (MAXWELL_B)
    computeClass*: U32         ##  0xB1C0 (MAXWELL_COMPUTE_B)
    gpfifoClass*: U32          ##  0xB06F (MAXWELL_CHANNEL_GPFIFO_A)
    inlineToMemoryClass*: U32  ##  0xA140 (KEPLER_INLINE_TO_MEMORY_B)
    dmaCopyClass*: U32         ##  0xB0B5 (MAXWELL_DMA_COPY_A)
    maxFbpsCount*: U32         ##  0x1
    fbpEnMask*: U32            ##  0x0 (disabled)
    maxLtcPerFbp*: U32         ##  0x2
    maxLtsPerLtc*: U32         ##  0x1
    maxTexPerTpc*: U32         ##  0x0 (not supported)
    maxGpcCount*: U32          ##  0x1
    ropL2EnMask0*: U32         ##  0x21D70 (fuse_status_opt_rop_l2_fbp_r)
    ropL2EnMask1*: U32         ##  0x0
    chipname*: U64             ##  0x6230326D67 ("gm20b")
    grCompbitStoreBaseHw*: U64 ##  0x0 (not supported)

  NvioctlVaRegion* {.bycopy.} = object
    offset*: U64
    pageSize*: U32
    pad*: U32
    pages*: U64

  NvioctlZbcSlotMask* {.bycopy.} = object
    slot*: U32                 ##  always 0x07 (?)
    mask*: U32

  NvioctlGpuTime* {.bycopy.} = object
    timestamp*: U64
    reserved*: U64

  NvioctlFence* {.bycopy.} = object
    id*: U32
    value*: U32

  NvioctlGpfifoEntry* {.bycopy.} = object
    anoIoctl3*: INNER_C_UNION_ioctl_2

  NvioctlCmdbuf* {.bycopy.} = object
    mem*: U32
    offset*: U32
    words*: U32

  NvioctlReloc* {.bycopy.} = object
    cmdbufMem*: U32
    cmdbufOffset*: U32
    target*: U32
    targetOffset*: U32

  NvioctlRelocShift* {.bycopy.} = object
    shift*: U32

  NvioctlSyncptIncr* {.bycopy.} = object
    syncptId*: U32
    syncptIncrs*: U32

  NvioctlCommandBufferMap* {.bycopy.} = object
    handle*: U32
    iova*: U32


const
  NVGPU_ZBC_TYPE_INVALID* = 0
  NVGPU_ZBC_TYPE_COLOR* = 1
  NVGPU_ZBC_TYPE_DEPTH* = 2

##  Used with nvioctlNvmap_Param().

type
  NvMapParam* = enum
    NvMapParamSize = 1, NvMapParamAlignment = 2, NvMapParamBase = 3, NvMapParamHeap = 4,
    NvMapParamKind = 5


##  Used with nvioctlChannel_AllocObjCtx().

type
  NvClassNumber* = enum
    NvClassNumber2D = 0x902D, NvClassNumberKepler = 0xA140,
    NvClassNumberChannelGpfifo = 0xB06F, NvClassNumberDMA = 0xB0B5,
    NvClassNumber3D = 0xB197, NvClassNumberCompute = 0xB1C0


##  Used with nvioctlChannel_SetPriority().

type
  NvChannelPriority* = enum
    NvChannelPriorityLow = 50, NvChannelPriorityMedium = 100,
    NvChannelPriorityHigh = 150


##  Used with nvioctlChannel_ZCullBind().

type
  NvZcullConfig* = enum
    NvZcullConfigGlobal = 0, NvZcullConfigNoCtxSwitch = 1,
    NvZcullConfigSeparateBuffer = 2, NvZcullConfigPartOfRegularBuffer = 3


##  Used with nvioctlNvhostAsGpu_AllocSpace().

type
  NvAllocSpaceFlags* = enum
    NvAllocSpaceFlagsFixedOffset = 1, NvAllocSpaceFlagsSparse = 2


##  Used with nvioctlNvhostAsGpu_MapBufferEx().

type
  NvMapBufferFlags* = enum
    NvMapBufferFlagsFixedOffset = 1, NvMapBufferFlagsIsCacheable = 4,
    NvMapBufferFlagsModify = 0x100
  NvNotificationType* = enum
    NvNotificationTypeFifoErrorIdleTimeout = 8,
    NvNotificationTypeGrErrorSwNotify = 13,
    NvNotificationTypeGrSemaphoreTimeout = 24,
    NvNotificationTypeGrIllegalNotify = 25,
    NvNotificationTypeFifoErrorMmuErrFlt = 31, NvNotificationTypePbdmaError = 32,
    NvNotificationTypeResetChannelVerifError = 43,
    NvNotificationTypePbdmaPushbufferCrcMismatch = 80
  NvNotification* {.bycopy.} = object
    timestamp*: U64
    info32*: U32               ##  see NvNotificationType
    info16*: U16
    status*: U16               ##  always -1

  NvError* {.bycopy.} = object
    `type`*: U32
    info*: array[31, U32]




proc nvioctlNvhostCtrlSyncptRead*(fd: U32; id: U32; `out`: ptr U32): Result {.cdecl,
    importc: "nvioctlNvhostCtrl_SyncptRead".}
proc nvioctlNvhostCtrlSyncptIncr*(fd: U32; id: U32): Result {.cdecl,
    importc: "nvioctlNvhostCtrl_SyncptIncr".}
proc nvioctlNvhostCtrlSyncptWait*(fd: U32; id: U32; threshold: U32; timeout: U32): Result {.
    cdecl, importc: "nvioctlNvhostCtrl_SyncptWait".}
proc nvioctlNvhostCtrlEventSignal*(fd: U32; eventId: U32): Result {.cdecl,
    importc: "nvioctlNvhostCtrl_EventSignal".}
proc nvioctlNvhostCtrlEventWait*(fd: U32; syncptId: U32; threshold: U32; timeout: S32;
                                eventId: U32; `out`: ptr U32): Result {.cdecl,
    importc: "nvioctlNvhostCtrl_EventWait".}
proc nvioctlNvhostCtrlEventWaitAsync*(fd: U32; syncptId: U32; threshold: U32;
                                     timeout: S32; eventId: U32): Result {.cdecl,
    importc: "nvioctlNvhostCtrl_EventWaitAsync".}
proc nvioctlNvhostCtrlEventRegister*(fd: U32; eventId: U32): Result {.cdecl,
    importc: "nvioctlNvhostCtrl_EventRegister".}
proc nvioctlNvhostCtrlEventUnregister*(fd: U32; eventId: U32): Result {.cdecl,
    importc: "nvioctlNvhostCtrl_EventUnregister".}
proc nvioctlNvhostCtrlGpuZCullGetCtxSize*(fd: U32; `out`: ptr U32): Result {.cdecl,
    importc: "nvioctlNvhostCtrlGpu_ZCullGetCtxSize".}
proc nvioctlNvhostCtrlGpuZCullGetInfo*(fd: U32; `out`: ptr NvioctlZcullInfo): Result {.
    cdecl, importc: "nvioctlNvhostCtrlGpu_ZCullGetInfo".}
proc nvioctlNvhostCtrlGpuZbcSetTable*(fd: U32; colorDs: array[4, U32];
                                     colorL2: array[4, U32]; depth: U32; format: U32;
                                     `type`: U32): Result {.cdecl,
    importc: "nvioctlNvhostCtrlGpu_ZbcSetTable".}
proc nvioctlNvhostCtrlGpuZbcQueryTable*(fd: U32; index: U32;
                                       `out`: ptr NvioctlZbcEntry): Result {.cdecl,
    importc: "nvioctlNvhostCtrlGpu_ZbcQueryTable".}
proc nvioctlNvhostCtrlGpuGetCharacteristics*(fd: U32;
    `out`: ptr NvioctlGpuCharacteristics): Result {.cdecl,
    importc: "nvioctlNvhostCtrlGpu_GetCharacteristics".}
proc nvioctlNvhostCtrlGpuGetTpcMasks*(fd: U32; buffer: pointer; size: csize_t): Result {.
    cdecl, importc: "nvioctlNvhostCtrlGpu_GetTpcMasks".}
proc nvioctlNvhostCtrlGpuZbcGetActiveSlotMask*(fd: U32;
    `out`: ptr NvioctlZbcSlotMask): Result {.cdecl,
    importc: "nvioctlNvhostCtrlGpu_ZbcGetActiveSlotMask".}
proc nvioctlNvhostCtrlGpuGetGpuTime*(fd: U32; `out`: ptr NvioctlGpuTime): Result {.
    cdecl, importc: "nvioctlNvhostCtrlGpu_GetGpuTime".}
proc nvioctlNvhostAsGpuBindChannel*(fd: U32; channelFd: U32): Result {.cdecl,
    importc: "nvioctlNvhostAsGpu_BindChannel".}
proc nvioctlNvhostAsGpuAllocSpace*(fd: U32; pages: U32; pageSize: U32; flags: U32;
                                  alignOrOffset: U64; offset: ptr U64): Result {.
    cdecl, importc: "nvioctlNvhostAsGpu_AllocSpace".}
proc nvioctlNvhostAsGpuFreeSpace*(fd: U32; offset: U64; pages: U32; pageSize: U32): Result {.
    cdecl, importc: "nvioctlNvhostAsGpu_FreeSpace".}
proc nvioctlNvhostAsGpuMapBufferEx*(fd: U32; flags: U32; kind: U32; nvmapHandle: U32;
                                   pageSize: U32; bufferOffset: U64;
                                   mappingSize: U64; inputOffset: U64;
                                   offset: ptr U64): Result {.cdecl,
    importc: "nvioctlNvhostAsGpu_MapBufferEx".}
proc nvioctlNvhostAsGpuUnmapBuffer*(fd: U32; offset: U64): Result {.cdecl,
    importc: "nvioctlNvhostAsGpu_UnmapBuffer".}
proc nvioctlNvhostAsGpuGetVARegions*(fd: U32; regions: array[2, NvioctlVaRegion]): Result {.
    cdecl, importc: "nvioctlNvhostAsGpu_GetVARegions".}
proc nvioctlNvhostAsGpuInitializeEx*(fd: U32; flags: U32; bigPageSize: U32): Result {.
    cdecl, importc: "nvioctlNvhostAsGpu_InitializeEx".}
proc nvioctlNvmapCreate*(fd: U32; size: U32; nvmapHandle: ptr U32): Result {.cdecl,
    importc: "nvioctlNvmap_Create".}
proc nvioctlNvmapFromId*(fd: U32; id: U32; nvmapHandle: ptr U32): Result {.cdecl,
    importc: "nvioctlNvmap_FromId".}
proc nvioctlNvmapAlloc*(fd: U32; nvmapHandle: U32; heapmask: U32; flags: U32; align: U32;
                       kind: U8; `addr`: pointer): Result {.cdecl,
    importc: "nvioctlNvmap_Alloc".}
proc nvioctlNvmapFree*(fd: U32; nvmapHandle: U32): Result {.cdecl,
    importc: "nvioctlNvmap_Free".}
proc nvioctlNvmapParam*(fd: U32; nvmapHandle: U32; param: NvMapParam; result: ptr U32): Result {.
    cdecl, importc: "nvioctlNvmap_Param".}
proc nvioctlNvmapGetId*(fd: U32; nvmapHandle: U32; id: ptr U32): Result {.cdecl,
    importc: "nvioctlNvmap_GetId".}
proc nvioctlChannelSetNvmapFd*(fd: U32; nvmapFd: U32): Result {.cdecl,
    importc: "nvioctlChannel_SetNvmapFd".}
proc nvioctlChannelSubmitGpfifo*(fd: U32; entries: ptr NvioctlGpfifoEntry;
                                numEntries: U32; flags: U32;
                                fenceInout: ptr NvioctlFence): Result {.cdecl,
    importc: "nvioctlChannel_SubmitGpfifo".}
proc nvioctlChannelKickoffPb*(fd: U32; entries: ptr NvioctlGpfifoEntry;
                             numEntries: U32; flags: U32;
                             fenceInout: ptr NvioctlFence): Result {.cdecl,
    importc: "nvioctlChannel_KickoffPb".}
proc nvioctlChannelAllocObjCtx*(fd: U32; classNum: U32; flags: U32; idOut: ptr U64): Result {.
    cdecl, importc: "nvioctlChannel_AllocObjCtx".}
proc nvioctlChannelZCullBind*(fd: U32; gpuVa: U64; mode: U32): Result {.cdecl,
    importc: "nvioctlChannel_ZCullBind".}
proc nvioctlChannelSetErrorNotifier*(fd: U32; enable: U32): Result {.cdecl,
    importc: "nvioctlChannel_SetErrorNotifier".}
proc nvioctlChannelGetErrorInfo*(fd: U32; `out`: ptr NvError): Result {.cdecl,
    importc: "nvioctlChannel_GetErrorInfo".}
proc nvioctlChannelGetErrorNotification*(fd: U32; `out`: ptr NvNotification): Result {.
    cdecl, importc: "nvioctlChannel_GetErrorNotification".}
proc nvioctlChannelSetPriority*(fd: U32; priority: U32): Result {.cdecl,
    importc: "nvioctlChannel_SetPriority".}
proc nvioctlChannelSetTimeout*(fd: U32; timeout: U32): Result {.cdecl,
    importc: "nvioctlChannel_SetTimeout".}
proc nvioctlChannelAllocGpfifoEx2*(fd: U32; numEntries: U32; flags: U32; unk0: U32;
                                  unk1: U32; unk2: U32; unk3: U32;
                                  fenceOut: ptr NvioctlFence): Result {.cdecl,
    importc: "nvioctlChannel_AllocGpfifoEx2".}
proc nvioctlChannelSetUserData*(fd: U32; `addr`: pointer): Result {.cdecl,
    importc: "nvioctlChannel_SetUserData".}
proc nvioctlChannelSubmit*(fd: U32; cmdbufs: ptr NvioctlCmdbuf; numCmdbufs: U32;
                          relocs: ptr NvioctlReloc;
                          relocShifts: ptr NvioctlRelocShift; numRelocs: U32;
                          syncptIncrs: ptr NvioctlSyncptIncr; numSyncptIncrs: U32;
                          fences: ptr NvioctlFence; numFences: U32): Result {.cdecl,
    importc: "nvioctlChannel_Submit".}
proc nvioctlChannelGetSyncpt*(fd: U32; moduleId: U32; syncpt: ptr U32): Result {.cdecl,
    importc: "nvioctlChannel_GetSyncpt".}
proc nvioctlChannelGetModuleClockRate*(fd: U32; moduleId: U32; freq: ptr U32): Result {.
    cdecl, importc: "nvioctlChannel_GetModuleClockRate".}
proc nvioctlChannelMapCommandBuffer*(fd: U32; maps: ptr NvioctlCommandBufferMap;
                                    numMaps: U32; compressed: bool): Result {.cdecl,
    importc: "nvioctlChannel_MapCommandBuffer".}
proc nvioctlChannelUnmapCommandBuffer*(fd: U32; maps: ptr NvioctlCommandBufferMap;
                                      numMaps: U32; compressed: bool): Result {.
    cdecl, importc: "nvioctlChannel_UnmapCommandBuffer".}
