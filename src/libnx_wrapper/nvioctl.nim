import strutils
import ospaths
const headernvioctl = currentSourcePath().splitPath().head & "/nx/include/switch/gfx/nvioctl.h"
import libnx_wrapper/types
type
  gpu_characteristics* {.importc: "gpu_characteristics", header: headernvioctl,
                        bycopy.} = object
    arch* {.importc: "arch".}: uint32
    impl* {.importc: "impl".}: uint32
    rev* {.importc: "rev".}: uint32
    num_gpc* {.importc: "num_gpc".}: uint32
    L2_cache_size* {.importc: "L2_cache_size".}: uint64
    on_board_video_memory_size* {.importc: "on_board_video_memory_size".}: uint64
    num_tpc_per_gpc* {.importc: "num_tpc_per_gpc".}: uint32
    bus_type* {.importc: "bus_type".}: uint32
    big_page_size* {.importc: "big_page_size".}: uint32
    compression_page_size* {.importc: "compression_page_size".}: uint32
    pde_coverage_bit_count* {.importc: "pde_coverage_bit_count".}: uint32
    available_big_page_sizes* {.importc: "available_big_page_sizes".}: uint32
    gpc_mask* {.importc: "gpc_mask".}: uint32
    sm_arch_sm_version* {.importc: "sm_arch_sm_version".}: uint32
    sm_arch_spa_version* {.importc: "sm_arch_spa_version".}: uint32
    sm_arch_warp_count* {.importc: "sm_arch_warp_count".}: uint32
    gpu_va_bit_count* {.importc: "gpu_va_bit_count".}: uint32
    reserved* {.importc: "reserved".}: uint32
    flags* {.importc: "flags".}: uint64
    twod_class* {.importc: "twod_class".}: uint32
    threed_class* {.importc: "threed_class".}: uint32
    compute_class* {.importc: "compute_class".}: uint32
    gpfifo_class* {.importc: "gpfifo_class".}: uint32
    inline_to_memory_class* {.importc: "inline_to_memory_class".}: uint32
    dma_copy_class* {.importc: "dma_copy_class".}: uint32
    max_fbps_count* {.importc: "max_fbps_count".}: uint32
    fbp_en_mask* {.importc: "fbp_en_mask".}: uint32
    max_ltc_per_fbp* {.importc: "max_ltc_per_fbp".}: uint32
    max_lts_per_ltc* {.importc: "max_lts_per_ltc".}: uint32
    max_tex_per_tpc* {.importc: "max_tex_per_tpc".}: uint32
    max_gpc_count* {.importc: "max_gpc_count".}: uint32
    rop_l2_en_mask_0* {.importc: "rop_l2_en_mask_0".}: uint32
    rop_l2_en_mask_1* {.importc: "rop_l2_en_mask_1".}: uint32
    chipname* {.importc: "chipname".}: uint64
    gr_compbit_store_base_hw* {.importc: "gr_compbit_store_base_hw".}: uint64

  nvioctl_va_region* {.importc: "nvioctl_va_region", header: headernvioctl, bycopy.} = object
    offset* {.importc: "offset".}: uint64
    page_size* {.importc: "page_size".}: uint32
    pad* {.importc: "pad".}: uint32
    pages* {.importc: "pages".}: uint64

  nvioctl_l2_state* {.importc: "nvioctl_l2_state", header: headernvioctl, bycopy.} = object
    mask* {.importc: "mask".}: uint32
    flush* {.importc: "flush".}: uint32

  nvioctl_fence* {.importc: "nvioctl_fence", header: headernvioctl, bycopy.} = object
    id* {.importc: "id".}: uint32
    value* {.importc: "value".}: uint32

  nvioctl_gpfifo_entry* {.importc: "nvioctl_gpfifo_entry", header: headernvioctl,
                         bycopy.} = object
    entry0* {.importc: "entry0".}: uint32
    entry1* {.importc: "entry1".}: uint32

  nvioctl_channel_obj_classnum* {.size: sizeof(cint).} = enum
    NvChannelObjClassNum_2D = 0x0000902D, NvChannelObjClassNum_Kepler = 0x0000A140,
    NvChannelObjClassNum_ChannelGpfifo = 0x0000B06F,
    NvChannelObjClassNum_DMA = 0x0000B0B5, NvChannelObjClassNum_3D = 0x0000B197,
    NvChannelObjClassNum_Compute = 0x0000B1C0


type
  nvioctl_channel_priority* {.size: sizeof(cint).} = enum
    NvChannelPriority_Low = 0x00000032, NvChannelPriority_Medium = 0x00000064,
    NvChannelPriority_High = 0x00000096


proc nvioctlNvhostCtrl_EventSignal*(fd: uint32; event_id: uint32): Result {.cdecl,
    importc: "nvioctlNvhostCtrl_EventSignal", header: headernvioctl.}
proc nvioctlNvhostCtrl_EventWait*(fd: uint32; syncpt_id: uint32; threshold: uint32;
                                 timeout: s32; event_id: uint32; `out`: ptr uint32): Result {.
    cdecl, importc: "nvioctlNvhostCtrl_EventWait", header: headernvioctl.}
proc nvioctlNvhostCtrl_EventRegister*(fd: uint32; event_id: uint32): Result {.cdecl,
    importc: "nvioctlNvhostCtrl_EventRegister", header: headernvioctl.}
proc nvioctlNvhostCtrlGpu_ZCullGetCtxSize*(fd: uint32; `out`: ptr uint32): Result {.cdecl,
    importc: "nvioctlNvhostCtrlGpu_ZCullGetCtxSize", header: headernvioctl.}
proc nvioctlNvhostCtrlGpu_ZCullGetInfo*(fd: uint32; `out`: array[40 shr 2, uint32]): Result {.
    cdecl, importc: "nvioctlNvhostCtrlGpu_ZCullGetInfo", header: headernvioctl.}
proc nvioctlNvhostCtrlGpu_GetCharacteristics*(fd: uint32;
    `out`: ptr gpu_characteristics): Result {.cdecl,
    importc: "nvioctlNvhostCtrlGpu_GetCharacteristics", header: headernvioctl.}
proc nvioctlNvhostCtrlGpu_GetTpcMasks*(fd: uint32; inval: uint32;
                                      `out`: array[24 shr 2, uint32]): Result {.cdecl,
    importc: "nvioctlNvhostCtrlGpu_GetTpcMasks", header: headernvioctl.}
proc nvioctlNvhostCtrlGpu_GetL2State*(fd: uint32; `out`: ptr nvioctl_l2_state): Result {.
    cdecl, importc: "nvioctlNvhostCtrlGpu_GetL2State", header: headernvioctl.}
proc nvioctlNvhostAsGpu_BindChannel*(fd: uint32; channel_fd: uint32): Result {.cdecl,
    importc: "nvioctlNvhostAsGpu_BindChannel", header: headernvioctl.}
proc nvioctlNvhostAsGpu_AllocSpace*(fd: uint32; pages: uint32; page_size: uint32; flags: uint32;
                                   align: uint64; offset: ptr uint64): Result {.cdecl,
    importc: "nvioctlNvhostAsGpu_AllocSpace", header: headernvioctl.}
proc nvioctlNvhostAsGpu_MapBufferEx*(fd: uint32; flags: uint32; kind: uint32; nvmap_handle: uint32;
                                    page_size: uint32; buffer_offset: uint64;
                                    mapping_size: uint64; input_offset: uint64;
                                    offset: ptr uint64): Result {.cdecl,
    importc: "nvioctlNvhostAsGpu_MapBufferEx", header: headernvioctl.}
proc nvioctlNvhostAsGpu_GetVARegions*(fd: uint32; regions: array[2, nvioctl_va_region]): Result {.
    cdecl, importc: "nvioctlNvhostAsGpu_GetVARegions", header: headernvioctl.}
proc nvioctlNvhostAsGpu_InitializeEx*(fd: uint32; big_page_size: uint32; flags: uint32): Result {.
    cdecl, importc: "nvioctlNvhostAsGpu_InitializeEx", header: headernvioctl.}
proc nvioctlNvmap_Create*(fd: uint32; size: uint32; nvmap_handle: ptr uint32): Result {.cdecl,
    importc: "nvioctlNvmap_Create", header: headernvioctl.}
proc nvioctlNvmap_FromId*(fd: uint32; id: uint32; nvmap_handle: ptr uint32): Result {.cdecl,
    importc: "nvioctlNvmap_FromId", header: headernvioctl.}
proc nvioctlNvmap_Alloc*(fd: uint32; nvmap_handle: uint32; heapmask: uint32; flags: uint32;
                        align: uint32; kind: uint8; `addr`: pointer): Result {.cdecl,
    importc: "nvioctlNvmap_Alloc", header: headernvioctl.}
proc nvioctlNvmap_GetId*(fd: uint32; nvmap_handle: uint32; id: ptr uint32): Result {.cdecl,
    importc: "nvioctlNvmap_GetId", header: headernvioctl.}
proc nvioctlChannel_SetNvmapFd*(fd: uint32; nvmap_fd: uint32): Result {.cdecl,
    importc: "nvioctlChannel_SetNvmapFd", header: headernvioctl.}
proc nvioctlChannel_SubmitGpfifo*(fd: uint32; entries: ptr nvioctl_gpfifo_entry;
                                 num_entries: uint32; flags: uint32;
                                 fence_out: ptr nvioctl_fence): Result {.cdecl,
    importc: "nvioctlChannel_SubmitGpfifo", header: headernvioctl.}
proc nvioctlChannel_AllocObjCtx*(fd: uint32; class_num: uint32; flags: uint32): Result {.cdecl,
    importc: "nvioctlChannel_AllocObjCtx", header: headernvioctl.}
proc nvioctlChannel_ZCullBind*(fd: uint32; gpu_va: uint64; mode: uint32): Result {.cdecl,
    importc: "nvioctlChannel_ZCullBind", header: headernvioctl.}
proc nvioctlChannel_SetErrorNotifier*(fd: uint32; offset: uint64; size: uint64;
                                     nvmap_handle: uint32): Result {.cdecl,
    importc: "nvioctlChannel_SetErrorNotifier", header: headernvioctl.}
proc nvioctlChannel_SetPriority*(fd: uint32; priority: uint32): Result {.cdecl,
    importc: "nvioctlChannel_SetPriority", header: headernvioctl.}
proc nvioctlChannel_AllocGpfifoEx2*(fd: uint32; num_entries: uint32; flags: uint32; unk0: uint32;
                                   unk1: uint32; unk2: uint32; unk3: uint32;
                                   fence_out: ptr nvioctl_fence): Result {.cdecl,
    importc: "nvioctlChannel_AllocGpfifoEx2", header: headernvioctl.}
proc nvioctlChannel_SetUserData*(fd: uint32; `addr`: pointer): Result {.cdecl,
    importc: "nvioctlChannel_SetUserData", header: headernvioctl.}