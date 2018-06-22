import strutils
import ospaths
const headergfx = currentSourcePath().splitPath().head & "/nx/include/switch/gfx/gfx.h"
## *
##  @file gfx.h
##  @brief High-level graphics API.
##  This API exposes a framebuffer (technically speaking, a windowbuffer) to be used for drawing graphics.
##  @author yellows8
##  @copyright libnx Authors
## 

import
  libnx_wrapper/types

## / Converts red, green, blue, and alpha components to packed RGBA8.

template RGBA8*(r, g, b, a: untyped): untyped =
  (((r) and 0x000000FF) or (((g) and 0x000000FF) shl 8) or
      (((b) and 0x000000FF) shl 16) or (((a) and 0x000000FF) shl 24))

## / Same as \ref RGBA8 except with alpha=0xff.

template RGBA8_MAXALPHA*(r, g, b: untyped): untyped =
  RGBA8(r, g, b, 0x000000FF)

## / GfxMode set by \ref gfxSetMode. The default is GfxMode_LinearDouble. Note that the text-console (see console.h) sets this to GfxMode_TiledDouble.

type
  GfxMode* {.size: sizeof(cint).} = enum
    GfxMode_TiledSingle,      ## /< Single-buffering with raw tiled (block-linear) framebuffer.
    GfxMode_TiledDouble,      ## /< Double-buffering with raw tiled (block-linear) framebuffer.
    GfxMode_LinearDouble      ## /< Double-buffering with linear framebuffer, which is transferred to the actual framebuffer by \ref gfxFlushBuffers().


## / Framebuffer pixel-format is RGBA8888, there's no known way to change this.
## *
##  @brief Initializes the graphics subsystem.
##  @warning Do not use \ref viInitialize when using this function.
## 

proc gfxInitDefault*() {.cdecl, importc: "gfxInitDefault", header: headergfx.}
## *
##  @brief Uninitializes the graphics subsystem.
##  @warning Do not use \ref viExit when using this function.
## 

proc gfxExit*() {.cdecl, importc: "gfxExit", header: headergfx.}
## *
##  @brief Sets the resolution to be used when initializing the graphics subsystem.
##  @param[in] width Horizontal resolution, in pixels.
##  @param[in] height Vertical resolution, in pixels.
##  @note The default resolution is 720p.
##  @note This can only be used before calling \ref gfxInitDefault, this will use \ref fatalSimple otherwise. If the input is 0, the default resolution will be used during \ref gfxInitDefault. This sets the maximum resolution for the framebuffer, used during \ref gfxInitDefault. This is also used as the current resolution when crop isn't set. The width/height are reset to the default when \ref gfxExit is used.
##  @note Normally you should only use this when you need a maximum resolution larger than the default, see above.
##  @note The width and height are aligned to 4.
## 

proc gfxInitResolution*(width: uint32; height: uint32) {.cdecl,
    importc: "gfxInitResolution", header: headergfx.}
## / Wrapper for \ref gfxInitResolution with resolution=1080p. Use this if you want to support 1080p or >720p in docked-mode.

proc gfxInitResolutionDefault*() {.cdecl, importc: "gfxInitResolutionDefault",
                                 header: headergfx.}
## / Configure framebuffer crop, by default crop is all-zero. Use all-zero input to reset to default. \ref gfxExit resets this to the default.
## / When the input is invalid this returns without changing the crop data, this includes the input values being larger than the framebuf width/height.
## / This will update the display width/height returned by \ref gfxGetFramebuffer, with that width/height being reset to the default when required.
## / \ref gfxGetFramebufferDisplayOffset uses absolute x/y, it will not adjust for non-zero crop left/top.
## / The new crop config will not take affect with double-buffering disabled. When used during frame-drawing, this should be called before \ref gfxGetFramebuffer.
## / The right and bottom params are aligned to 4.

proc gfxConfigureCrop*(left: s32; top: s32; right: s32; bottom: s32) {.cdecl,
    importc: "gfxConfigureCrop", header: headergfx.}
## / Wrapper for \ref gfxConfigureCrop. Use this to set the resolution, within the bounds of the maximum resolution. Use all-zero input to reset to default.

proc gfxConfigureResolution*(width: s32; height: s32) {.cdecl,
    importc: "gfxConfigureResolution", header: headergfx.}
## / If enabled, \ref gfxConfigureResolution will be used with the input resolution for the current OperationMode. Then \ref gfxConfigureResolution will automatically be used with the specified resolution each time OperationMode changes.

proc gfxConfigureAutoResolution*(enable: bool; handheld_width: s32;
                                handheld_height: s32; docked_width: s32;
                                docked_height: s32) {.cdecl,
    importc: "gfxConfigureAutoResolution", header: headergfx.}
## / Wrapper for \ref gfxConfigureAutoResolution. handheld_resolution=720p, docked_resolution={all-zero for using current maximum resolution}.

proc gfxConfigureAutoResolutionDefault*(enable: bool) {.cdecl,
    importc: "gfxConfigureAutoResolutionDefault", header: headergfx.}
## / Waits for vertical sync.

proc gfxWaitForVsync*() {.cdecl, importc: "gfxWaitForVsync", header: headergfx.}
## / Swaps the framebuffers (for double-buffering).

proc gfxSwapBuffers*() {.cdecl, importc: "gfxSwapBuffers", header: headergfx.}
## / Get the current framebuffer address, with optional output ptrs for the display framebuffer width/height. The display width/height is adjusted by \ref gfxConfigureCrop and \ref gfxConfigureResolution.

proc gfxGetFramebuffer*(width: ptr uint32; height: ptr uint32): ptr uint8 {.cdecl,
    importc: "gfxGetFramebuffer", header: headergfx.}
## / Get the framebuffer width/height without crop.

proc gfxGetFramebufferResolution*(width: ptr uint32; height: ptr uint32) {.cdecl,
    importc: "gfxGetFramebufferResolution", header: headergfx.}
## / Use this to get the actual byte-size of the framebuffer for use with memset/etc.

proc gfxGetFramebufferSize*(): csize {.cdecl, importc: "gfxGetFramebufferSize",
                                    header: headergfx.}
## / Sets the \ref GfxMode.

proc gfxSetMode*(mode: GfxMode) {.cdecl, importc: "gfxSetMode", header: headergfx.}
## / Controls whether a vertical-flip is done when determining the pixel-offset within the actual framebuffer. By default this is enabled.

proc gfxSetDrawFlip*(flip: bool) {.cdecl, importc: "gfxSetDrawFlip",
                                header: headergfx.}
## / Configures transform. See the NATIVE_WINDOW_TRANSFORM_* enums in buffer_producer.h. The default is NATIVE_WINDOW_TRANSFORM_FLIP_V.

proc gfxConfigureTransform*(transform: uint32) {.cdecl,
    importc: "gfxConfigureTransform", header: headergfx.}
## / Flushes the framebuffer in the data cache. When \ref GfxMode is GfxMode_LinearDouble, this also transfers the linear-framebuffer to the actual framebuffer.

proc gfxFlushBuffers*() {.cdecl, importc: "gfxFlushBuffers", header: headergfx.}
## / Use this to get the pixel-offset in the framebuffer. Returned value is in pixels, not bytes.
## / This implements tegra blocklinear, with hard-coded constants etc.
## / Do not use this when \ref GfxMode is GfxMode_LinearDouble.

proc gfxGetFramebufferDisplayOffset*(x: uint32; y: uint32): uint32 {.inline, cdecl,
    importc: "gfxGetFramebufferDisplayOffset", header: headergfx.}