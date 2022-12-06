## *
##  @file framebuffer.h
##  @brief Framebuffer wrapper object, providing support for software rendered graphics.
##  @author fincs
##  @copyright libnx Authors
##

import
  ../nvidia/map, native_window, ../types

## / Converts red/green/blue/alpha components to packed RGBA8 (i.e. \ref PIXEL_FORMAT_RGBA_8888).

template rgba8*(r, g, b, a: untyped): untyped =
  (((r) and 0xff) or (((g) and 0xff) shl 8) or (((b) and 0xff) shl 16) or
      (((a) and 0xff) shl 24))

## / Same as \ref RGBA8 except with alpha=0xff.

template rgba8Maxalpha*(r, g, b: untyped): untyped =
  rgba8((r), (g), (b), 0xff)

## / Converts red/green/blue to packed RGBX8 (i.e. \ref PIXEL_FORMAT_RGBX_8888).

template rgbx8*(r, g, b: untyped): untyped =
  rgba8((r), (g), (b), 0)

## / Converts red/green/blue components to packed RGB565 (i.e. \ref PIXEL_FORMAT_RGB_565)

template rgb565*(r, g, b: untyped): untyped =
  (((b) and 0x1f) or (((g) and 0x3f) shl 5) or (((r) and 0x1f) shl 11))

## / Same as \ref RGB565 but accepting 8-bit components as input instead.

template rgb565From_Rgb8*(r, g, b: untyped): untyped =
  rgb565((r) shr 3, (g) shr 2, (b) shr 3)

## / Converts red/green/blue/alpha components to packed BGR8 (i.e. \ref PIXEL_FORMAT_BGRA_8888).

template bgra8*(r, g, b, a: untyped): untyped =
  rgba8((b), (g), (r), (a))

## / Same as \ref BGRA8 except with alpha=0xff.

template bgra8Maxalpha*(r, g, b: untyped): untyped =
  rgba8((b), (g), (r), 0xff)

## / Converts red/green/blue/alpha components to packed RGBA4 (i.e. \ref PIXEL_FORMAT_RGBA_4444).

template rgba4*(r, g, b, a: untyped): untyped =
  (((r) and 0xf) or (((g) and 0xf) shl 4) or (((b) and 0xf) shl 8) or (((a) and 0xf) shl 12))

## / Same as \ref RGBA4 except with alpha=0xf.

template rgba4Maxalpha*(r, g, b: untyped): untyped =
  rgba4((r), (g), (b), 0xf)

## / Same as \ref RGBA4 but accepting 8-bit components as input instead.

template rgba4From_Rgba8*(r, g, b, a: untyped): untyped =
  rgba4((r) shr 4, (g) shr 4, (b) shr 4, (a) shr 4)

## / Same as \ref RGBA4_MAXALPHA except with alpha=0xff.

template rgba4From_Rgba8Maxalpha*(r, g, b: untyped): untyped =
  rgba4Maxalpha((r) shr 4, (g) shr 4, (b) shr 4)

## / Framebuffer structure.

type
  Framebuffer* {.bycopy.} = object
    win*: ptr NWindow
    map*: NvMap
    buf*: pointer
    bufLinear*: pointer
    stride*: U32
    widthAligned*: U32
    heightAligned*: U32
    numFbs*: U32
    fbSize*: U32
    hasInit*: bool

proc framebufferCreate*(fb: ptr Framebuffer; win: ptr NWindow; width: U32; height: U32;
                       format: U32; numFbs: U32): Result {.cdecl,
    importc: "framebufferCreate".}
## *
##  @brief Creates a \ref Framebuffer object.
##  @param[out] fb Output \ref Framebuffer structure.
##  @param[in] win Pointer to the \ref NWindow to which the \ref Framebuffer will be registered.
##  @param[in] width Desired width of the framebuffer (usually 1280).
##  @param[in] height Desired height of the framebuffer (usually 720).
##  @param[in] format Desired pixel format (see PIXEL_FORMAT_* enum).
##  @param[in] num_fbs Number of buffers to create. Pass 1 for single-buffering, 2 for double-buffering or 3 for triple-buffering.
##  @note Framebuffer images are stored in Tegra block linear format with 16Bx2 sector ordering, read TRM chapter 20.1 for more details.
##        In order to use regular linear layout, consider calling \ref framebufferMakeLinear after the \ref Framebuffer object is created.
##  @note Presently, only the following pixel formats are supported:
##        \ref PIXEL_FORMAT_RGBA_8888
##        \ref PIXEL_FORMAT_RGBX_8888
##        \ref PIXEL_FORMAT_RGB_565
##        \ref PIXEL_FORMAT_BGRA_8888
##        \ref PIXEL_FORMAT_RGBA_4444
##

proc framebufferMakeLinear*(fb: ptr Framebuffer): Result {.cdecl,
    importc: "framebufferMakeLinear".}
## / Enables linear framebuffer mode in a \ref Framebuffer, allocating a shadow buffer in the process.

proc framebufferClose*(fb: ptr Framebuffer) {.cdecl, importc: "framebufferClose".}
## / Closes a \ref Framebuffer object, freeing all resources associated with it.

proc framebufferBegin*(fb: ptr Framebuffer; outStride: ptr U32): pointer {.cdecl,
    importc: "framebufferBegin".}
## *
##  @brief Begins rendering a frame in a \ref Framebuffer.
##  @param[in] fb Pointer to \ref Framebuffer structure.
##  @param[out] out_stride Output variable containing the distance in bytes between rows of pixels in memory.
##  @return Pointer to buffer to which new graphics data should be written to.
##  @note When this function is called, a buffer will be dequeued from the corresponding \ref NWindow.
##  @note This function will return pointers to different buffers, depending on the number of buffers it was initialized with.
##  @note If \ref framebufferMakeLinear was used, this function will instead return a pointer to the shadow linear buffer.
##        In this case, the offset of a pixel is \p y * \p out_stride + \p x * \p bytes_per_pixel.
##  @note Each call to \ref framebufferBegin must be paired with a \ref framebufferEnd call.
##

proc framebufferEnd*(fb: ptr Framebuffer) {.cdecl, importc: "framebufferEnd".}
## *
##  @brief Finishes rendering a frame in a \ref Framebuffer.
##  @param[in] fb Pointer to \ref Framebuffer structure.
##  @note When this function is called, the written image data will be flushed and queued (presented) in the corresponding \ref NWindow.
##  @note If \ref framebufferMakeLinear was used, this function will copy the image from the shadow linear buffer to the actual framebuffer,
##        converting it in the process to the layout expected by the compositor.
##  @note Each call to \ref framebufferBegin must be paired with a \ref framebufferEnd call.
##

