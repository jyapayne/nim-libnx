## *
##  @file capsdc.h
##  @brief Jpeg Decoder (caps:dc) service IPC wrapper. Only available on [4.0.0+].
##  @note Only holds one session that is occupied by capsrv.
##  @author Behemoth
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/caps

## / Initialize caps:dc

proc capsdcInitialize*(): Result {.cdecl, importc: "capsdcInitialize".}
## / Exit caps:dc.

proc capsdcExit*() {.cdecl, importc: "capsdcExit".}
## / Gets the Service for caps:dc.

proc capsdcGetServiceSession*(): ptr Service {.cdecl,
    importc: "capsdcGetServiceSession".}
## *
##  @brief Decodes a jpeg buffer into RGBX.
##  @param[in] width Image width.
##  @param[in] height Image height.
##  @param[in] opts \ref CapsScreenShotDecodeOption.
##  @param[in] jpeg Jpeg image input buffer.
##  @param[in] jpeg_size Input image buffer size.
##  @param[out] out_image RGBA8 image output buffer.
##  @param[in] out_image_size Output image buffer size, should be at least large enough for RGBA8 width x height.
##

proc capsdcDecodeJpeg*(width: U32; height: U32; opts: ptr CapsScreenShotDecodeOption;
                      jpeg: pointer; jpegSize: csize_t; outImage: pointer;
                      outImageSize: csize_t): Result {.cdecl,
    importc: "capsdcDecodeJpeg".}