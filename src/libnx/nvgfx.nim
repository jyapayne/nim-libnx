import strutils
import ospaths
const headernvgfx = currentSourcePath().splitPath().head & "/nx/include/switch/gfx/nvgfx.h"
import libnx/types
proc nvgfxInitialize*(): Result {.cdecl, importc: "nvgfxInitialize",
                               header: headernvgfx.}
proc nvgfxExit*() {.cdecl, importc: "nvgfxExit", header: headernvgfx.}
proc nvgfxEventWait*(syncpt_id: uint32; threshold: uint32; timeout: s32): Result {.cdecl,
    importc: "nvgfxEventWait", header: headernvgfx.}
proc nvgfxSubmitGpfifo*(): Result {.cdecl, importc: "nvgfxSubmitGpfifo",
                                 header: headernvgfx.}
proc nvgfxGetFramebuffer*(buffer: ptr ptr uint8; size: ptr csize): Result {.cdecl,
    importc: "nvgfxGetFramebuffer", header: headernvgfx.}