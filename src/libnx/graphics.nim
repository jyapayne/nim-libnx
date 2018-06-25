import strutils
import
  libnx/wrapper/types,
  libnx/wrapper/gfx,
  libnx/utils

type
  GraphicsError* = object of Exception
  InitResolutionError* = object of GraphicsError
  CropBoundsError* = object of GraphicsError

  RGBA8* = ref object
    red*: int
    green*: int
    blue*: int
    alpha*: int

  Framebuffer* = ref object
    width*: uint32
    height*: uint32
    data*: Buffer[uint8]

  BufferTransform* {.pure, size: sizeof(cint).} = enum
    FlipHorizontal = 0x1
    FlipVertical = 0x2
    Rotate180 = 0x3
    Rotate90 = 0x4
    Rotate270 = 0x7

## / Converts red, green, blue, and alpha components to packed RGBA8.
proc packed*(rgba: RGBA8): int =
  gfx.RGBA8(rgba.red, rgba.green, rgba.blue, rgba.alpha)

## / Same as \ref RGBA8 except with alpha=0xff.
proc maxAlpha*(r, g, b: int): RGBA8 =
  RGBA8(red:r, green:g, blue:b, alpha:0xFF)

## / GfxMode set by \ref gfxSetMode. The default is GfxMode_LinearDouble. Note that the
## text-console (see console.h) sets this to GfxMode_TiledDouble.
type
  GfxMode* {.size: sizeof(cint), pure.} = enum
    TiledSingle,  ## /< Single-buffering with raw tiled (block-linear) framebuffer.
    TiledDouble,  ## /< Double-buffering with raw tiled (block-linear) framebuffer.
    LinearDouble  ## /< Double-buffering with linear framebuffer, which is
                  ## transferred to the actual framebuffer by \ref gfxFlushBuffers().

var enabled = false

## / Framebuffer pixel-format is RGBA8888, there's no known way to change this.
## *
##  @brief Initializes the graphics subsystem.
##  @warning Do not use \ref viInitialize when using this function.
##
proc initDefault*() =
  if not enabled:
    gfxInitDefault()
  enabled = true

## *
##  @brief Uninitializes the graphics subsystem.
##  @warning Do not use \ref viExit when using this function.
##
proc exit*() =
  if enabled:
    gfxExit()
    enabled = false

## / Get the framebuffer width/height without crop.
proc getFramebufferResolution*(): tuple[width: uint32, height: uint32] =
  var
    width: uint32
    height: uint32
  gfxGetFramebufferResolution(width.addr, height.addr)
  return (width: width, height: height)

## *
##  @brief Sets the resolution to be used when initializing the graphics subsystem.
##  @param[in] width Horizontal resolution, in pixels.
##  @param[in] height Vertical resolution, in pixels.
##  @note The default resolution is 720p.
##  @note This can only be used before calling \ref gfxInitDefault, this will use \ref
##  fatalSimple otherwise. If the input is 0, the default resolution will be used during
##  \ref gfxInitDefault. This sets the maximum resolution for the framebuffer, used
##  during \ref gfxInitDefault. This is also used as the current resolution when crop
##  isn't set. The width/height are reset to the default when \ref gfxExit is used.
##  @note Normally you should only use this when you need a maximum resolution larger
##  than the default, see above.
##  @note The width and height are aligned to 4.
##
proc initResolution*(width: uint32; height: uint32) =
  if not enabled:
    gfxInitResolution(width, height)
  else:
    raiseEx(InitResolutionError, "Cannot init resolution after graphics.initDefault!")

## / Wrapper for \ref gfxInitResolution with resolution=1080p. Use this if you want to
## support 1080p or >720p in docked-mode.
proc initResolution1080p*() =
  if not enabled:
    gfxInitResolutionDefault()
  else:
    raiseEx(InitResolutionError, "Cannot init resolution after graphics.initDefault!")

proc cropBoundsValid(left, top, right, bottom: uint32, width, height: uint32): bool =

  if left < right and top > bottom:
    if left <= width and right <= width:
      if top <= height and bottom <= height:
        return true
  return false

## / Configure framebuffer crop, by default crop is all-zero. Use all-zero input to
## reset to default. \ref gfxExit resets this to the default.
## / When the input is invalid this returns without changing the crop data, this
## includes the input values being larger than the framebuf width/height.
## / This will update the display width/height returned by \ref gfxGetFramebuffer, with
## that width/height being reset to the default when required.
## / \ref gfxGetFramebufferDisplayOffset uses absolute x/y, it will not adjust for
## non-zero crop left/top.
## / The new crop config will not take affect with double-buffering disabled. When used
## during frame-drawing, this should be called before \ref gfxGetFramebuffer.
## / The right and bottom params are aligned to 4.
proc setCrop*(left, top, right, bottom: uint32) =
  let (width, height) = getFramebufferResolution()
  if not cropBoundsValid(left, top, right, bottom, width, height):
    raiseEx(
      CropBoundsError,
      "The crop bounds are outside the frame buffer limits of w: $#, h:$#" %
      [$width, $height]
    )
  gfxConfigureCrop(left.s32, top.s32, right.s32, bottom.s32)

proc resetCrop*() =
  setCrop(0, 0, 0, 0)

## / Wrapper for \ref gfxConfigureCrop. Use this to set the resolution, within the
## bounds of the maximum resolution. Use all-zero input to reset to default.
proc setCropResolution*(width, height: uint32) =
  gfxConfigureResolution(width.s32, height.s32)

## / If enabled, \ref gfxConfigureResolution will be used with the input resolution for
## the current OperationMode. Then \ref gfxConfigureResolution will automatically be
## used with the specified resolution each time OperationMode changes.
proc setAutoResolution*(enable: bool, handheldWidth,
                        handheldHeight, dockedWidth,
                        dockedHeight: uint32) =
  gfxConfigureAutoResolution(
    enable, handheldWidth.s32, handheldHeight.s32, dockedWidth.s32, dockedHeight.s32
  )

## / Wrapper for \ref gfxConfigureAutoResolution. handheld_resolution=720p,
## docked_resolution={all-zero for using current maximum resolution}.
proc setAutoResolutionDefault*(enable: bool) =
  gfxConfigureAutoResolutionDefault(enable)

## / Waits for vertical sync.
proc waitForVsync*() = gfxWaitForVSync()

## / Swaps the framebuffers (for double-buffering).
proc swapBuffers*() = gfxSwapBuffers()

## / Use this to get the actual byte-size of the framebuffer for use with memset/etc.
proc getFramebufferSize*(): int = gfxGetFramebufferSize().int

## / Get the current framebuffer address, with optional output ptrs for the display
## framebuffer width/height. The display width/height is adjusted by \ref
## gfxConfigureCrop and \ref gfxConfigureResolution.
proc getFramebuffer*(): Framebuffer =
  result = new(Framebuffer)
  let size = getFramebufferSize()
  let frameBuf = gfxGetFrameBuffer(
    result.width.addr,
    result.height.addr
  )
  let arr = cast[ptr UncheckedArray[uint8]](frameBuf)
  result.data = Buffer[uint8](len: size, data: arr)

## / Sets the \ref GfxMode.
proc setMode*(mode: GfxMode) = gfxSetMode(gfx.GfxMode(mode))

## / Controls whether a vertical-flip is done when determining the pixel-offset within
## the actual framebuffer. By default this is enabled.
proc setDrawFlip*(enabled: bool) = gfxSetDrawFlip(enabled)

## / Configures transform. See the NATIVE_WINDOW_TRANSFORM_* enums in buffer_producer.h.
## The default is NATIVE_WINDOW_TRANSFORM_FLIP_V.
proc configureTransform*(transform: BufferTransform) =
  gfxConfigureTransform(transform.uint32)

## / Flushes the framebuffer in the data cache. When \ref GfxMode is
## GfxMode_LinearDouble, this also transfers the linear-framebuffer to the actual
## framebuffer.
proc flushBuffers*() = gfxFlushBuffers()

## / Use this to get the pixel-offset in the framebuffer. Returned value is in pixels,
## not bytes.
## / This implements tegra blocklinear, with hard-coded constants etc.
## / Do not use this when \ref GfxMode is GfxMode_LinearDouble.
proc getFramebufferDisplayOffset*(x: uint32; y: uint32): uint32 =
  gfxGetFrameBufferDisplayOffset(x, y)
