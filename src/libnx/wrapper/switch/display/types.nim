## *
##  @file display/types.h
##  @brief Definitions for Android-related types and enumerations.
##  @copyright libnx Authors
##

##  From Android PixelFormat.h & graphics-base-v1.0.h.

const
  PIXEL_FORMAT_RGBA_8888* = 1'u
  PIXEL_FORMAT_RGBX_8888* = 2'u
  PIXEL_FORMAT_RGB_888* = 3'u
  PIXEL_FORMAT_RGB_565* = 4'u
  PIXEL_FORMAT_BGRA_8888* = 5'u
  PIXEL_FORMAT_RGBA_5551* = 6'u
  PIXEL_FORMAT_RGBA_4444* = 7'u
  PIXEL_FORMAT_YCRCB_420_SP* = 17'u
  PIXEL_FORMAT_RAW16* = 32'u
  PIXEL_FORMAT_BLOB* = 33'u
  PIXEL_FORMAT_IMPLEMENTATION_DEFINED* = 34'u
  PIXEL_FORMAT_YCBCR_420_888* = 35'u
  PIXEL_FORMAT_Y8* = 0x20203859
  PIXEL_FORMAT_Y16* = 0x20363159
  PIXEL_FORMAT_YV12* = 0x32315659

##  From Android gralloc.h.

const                         ##  buffer is never read in software
  GRALLOC_USAGE_SW_READ_NEVER* = 0x00000000 ##  buffer is rarely read in software
  GRALLOC_USAGE_SW_READ_RARELY* = 0x00000002 ##  buffer is often read in software
  GRALLOC_USAGE_SW_READ_OFTEN* = 0x00000003 ##  mask for the software read values
  GRALLOC_USAGE_SW_READ_MASK* = 0x0000000F ##  buffer is never written in software
  GRALLOC_USAGE_SW_WRITE_NEVER* = 0x00000000 ##  buffer is rarely written in software
  GRALLOC_USAGE_SW_WRITE_RARELY* = 0x00000020 ##  buffer is often written in software
  GRALLOC_USAGE_SW_WRITE_OFTEN* = 0x00000030 ##  mask for the software write values
  GRALLOC_USAGE_SW_WRITE_MASK* = 0x000000F0 ##  buffer will be used as an OpenGL ES texture
  GRALLOC_USAGE_HW_TEXTURE* = 0x00000100 ##  buffer will be used as an OpenGL ES render target
  GRALLOC_USAGE_HW_RENDER* = 0x00000200 ##  buffer will be used by the 2D hardware blitter
  GRALLOC_USAGE_HW_2D* = 0x00000400 ##  buffer will be used by the HWComposer HAL module
  GRALLOC_USAGE_HW_COMPOSER* = 0x00000800 ##  buffer will be used with the framebuffer device
  GRALLOC_USAGE_HW_FB* = 0x00001000 ##  buffer should be displayed full-screen on an external display when
                                 ##  possible
  GRALLOC_USAGE_EXTERNAL_DISP* = 0x00002000 ##  Must have a hardware-protected path to external display sink for
                                         ##  this buffer.  If a hardware-protected path is not available, then
                                         ##  either don't composite only this buffer (preferred) to the
                                         ##  external sink, or (less desirable) do not route the entire
                                         ##  composition to the external sink.
  GRALLOC_USAGE_PROTECTED* = 0x00004000 ##  buffer may be used as a cursor
  GRALLOC_USAGE_CURSOR* = 0x00008000 ##  buffer will be used with the HW video encoder
  GRALLOC_USAGE_HW_VIDEO_ENCODER* = 0x00010000 ##  buffer will be written by the HW camera pipeline
  GRALLOC_USAGE_HW_CAMERA_WRITE* = 0x00020000 ##  buffer will be read by the HW camera pipeline
  GRALLOC_USAGE_HW_CAMERA_READ* = 0x00040000 ##  buffer will be used as part of zero-shutter-lag queue
  GRALLOC_USAGE_HW_CAMERA_ZSL* = 0x00060000 ##  mask for the camera access values
  GRALLOC_USAGE_HW_CAMERA_MASK* = 0x00060000 ##  mask for the software usage bit-mask
  GRALLOC_USAGE_HW_MASK* = 0x00071F00 ##  buffer will be used as a RenderScript Allocation
  GRALLOC_USAGE_RENDERSCRIPT* = 0x00100000

##  From Android window.h.
##  attributes queriable with query()

const
  NATIVE_WINDOW_WIDTH* = 0
  NATIVE_WINDOW_HEIGHT* = 1
  NATIVE_WINDOW_FORMAT* = 2 ## ...
                         ##     NATIVE_WINDOW_DEFAULT_WIDTH = 6, //These two return invalid data.
                         ##     NATIVE_WINDOW_DEFAULT_HEIGHT = 7,

##  From Android window.h.
##  parameter for NATIVE_WINDOW_[API_][DIS]CONNECT

const ## ...
     ##  Buffers will be queued after being filled using the CPU
     ##
  NATIVE_WINDOW_API_CPU* = 2    ## ...

##  From Android hardware.h.
## *
##  Transformation definitions
##
##  IMPORTANT NOTE:
##  HAL_TRANSFORM_ROT_90 is applied CLOCKWISE and AFTER HAL_TRANSFORM_FLIP_{H|V}.
##
##

const                         ##  flip source image horizontally (around the vertical axis)
  HAL_TRANSFORM_FLIP_H* = 0x01  ##  flip source image vertically (around the horizontal axis)
  HAL_TRANSFORM_FLIP_V* = 0x02  ##  rotate source image 90 degrees clockwise
  HAL_TRANSFORM_ROT_90* = 0x04  ##  rotate source image 180 degrees
  HAL_TRANSFORM_ROT_180* = 0x03 ##  rotate source image 270 degrees clockwise
  HAL_TRANSFORM_ROT_270* = 0x07

##  From Android window.h.
##  parameter for NATIVE_WINDOW_SET_BUFFERS_TRANSFORM

const                         ##  flip source image horizontally
  NATIVE_WINDOW_TRANSFORM_FLIP_H* = HAL_TRANSFORM_FLIP_H ##  flip source image vertically
  NATIVE_WINDOW_TRANSFORM_FLIP_V* = HAL_TRANSFORM_FLIP_V ##  rotate source image 90 degrees clock-wise
  NATIVE_WINDOW_TRANSFORM_ROT_90* = HAL_TRANSFORM_ROT_90 ##  rotate source image 180 degrees
  NATIVE_WINDOW_TRANSFORM_ROT_180* = HAL_TRANSFORM_ROT_180 ##  rotate source image 270 degrees clock-wise
  NATIVE_WINDOW_TRANSFORM_ROT_270* = HAL_TRANSFORM_ROT_270

##  From Android native_handle.h.

type
  NativeHandle* {.bycopy.} = object
    version*: cint
    numFds*: cint
    numInts*: cint

