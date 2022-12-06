import ioctl, ../result, ../types

proc nvGpuInit*(): Result {.cdecl, importc: "nvGpuInit".}
proc nvGpuExit*() {.cdecl, importc: "nvGpuExit".}
proc nvGpuGetCharacteristics*(): ptr NvioctlGpuCharacteristics {.cdecl,
    importc: "nvGpuGetCharacteristics".}
proc nvGpuGetZcullCtxSize*(): U32 {.cdecl, importc: "nvGpuGetZcullCtxSize".}
proc nvGpuGetZcullInfo*(): ptr NvioctlZcullInfo {.cdecl, importc: "nvGpuGetZcullInfo".}
proc nvGpuGetTpcMasks*(numMasksOut: ptr U32): ptr U32 {.cdecl,
    importc: "nvGpuGetTpcMasks".}
proc nvGpuZbcGetActiveSlotMask*(outSlot: ptr U32; outMask: ptr U32): Result {.cdecl,
    importc: "nvGpuZbcGetActiveSlotMask".}
proc nvGpuZbcAddColor*(colorL2: array[4, U32]; colorDs: array[4, U32]; format: U32): Result {.
    cdecl, importc: "nvGpuZbcAddColor".}
proc nvGpuZbcAddDepth*(depth: cfloat): Result {.cdecl, importc: "nvGpuZbcAddDepth".}
proc nvGpuGetTimestamp*(ts: ptr U64): Result {.cdecl, importc: "nvGpuGetTimestamp".}
