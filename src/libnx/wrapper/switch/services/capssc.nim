## *
##  @file capssc.h
##  @brief Screenshot control (caps:sc) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, vi

const
  CAPSSC_JPEG_BUFFER_SIZE* = 0x80000

## / Initialize caps:sc. Only available on [2.0.0+].

proc capsscInitialize*(): Result {.cdecl, importc: "capsscInitialize".}
## / Exit caps:sc.

proc capsscExit*() {.cdecl, importc: "capsscExit".}
## / Gets the Service for caps:sc.

proc capsscGetServiceSession*(): ptr Service {.cdecl,
    importc: "capsscGetServiceSession".}
## *
##  @brief This takes a screenshot, with the screenshot being written into the output buffer.
##  @note Not available with [5.0.0+] (stubbed).
##  @note buffer_index and buffer_count correspond to buffers with size 0x384000(1280*720*4). These must not be negative.
##  @param buf Output buffer containing the RGBA8 image.
##  @param size Size of buf, should be 0x384000(1280*720*4) * buffer_count.
##  @param layer_stack \ref ViLayerStack
##  @param width Image width, must be 1280.
##  @param height Image height, must be 720.
##  @param buffer_count Total number of output image buffers.
##  @param buffer_index Starting image buffer index. Must be < buffer_count.
##  @param timeout Timeout in nanoseconds. A default value of 100000000 can be used.
##

proc capsscCaptureRawImageWithTimeout*(buf: pointer; size: csize_t;
                                      layerStack: ViLayerStack; width: U64;
                                      height: U64; bufferCount: S64;
                                      bufferIndex: S64; timeout: S64): Result {.
    cdecl, importc: "capsscCaptureRawImageWithTimeout".}
## *
##  @brief This takes a raw screenshot, with the screenshot being held until \ref capsscCloseRawScreenShotReadStream is called.
##  @note Only available on [3.0.0+]. Requires debug mode.
##  @param out_size Pointer to write the size of the captured raw image to. Always 0x384000(1280*720*4).
##  @param out_width Pointer to write the width of the captured raw image to. Always 1280.
##  @param out_height Pointer to write the height of the captured raw image to. Always 720.
##  @param layer_stack \ref ViLayerStack
##  @param timeout Timeout in nanoseconds.
##

proc capsscOpenRawScreenShotReadStream*(outSize: ptr U64; outWidth: ptr U64;
                                       outHeight: ptr U64;
                                       layerStack: ViLayerStack; timeout: S64): Result {.
    cdecl, importc: "capsscOpenRawScreenShotReadStream".}
## *
##  @brief Discards a stream opened by \ref capsscOpenRawScreenShotReadStream.
##  @note Only available on [3.0.0+]. Requires debug mode.
##

proc capsscCloseRawScreenShotReadStream*(): Result {.cdecl,
    importc: "capsscCloseRawScreenShotReadStream".}
## *
##  @brief Reads from a stream opened by \ref capsscOpenRawScreenShotReadStream.
##  @note Only available on [3.0.0+]. Requires debug mode.
##  @param bytes_read Pointer to write the amounts of bytes written to buffer.
##  @param buf Output buffer containing the RGBA8 image.
##  @param size Size of buf.
##  @param offset Offset in image where read should start.
##

proc capsscReadRawScreenShotReadStream*(bytesRead: ptr U64; buf: pointer;
                                       size: csize_t; offset: U64): Result {.cdecl,
    importc: "capsscReadRawScreenShotReadStream".}
## *
##  @brief This takes a screenshot, with the screenshot being written as jpeg into the output buffer.
##  @note Only available on [9.0.0+]. Requires debug mode before [10.0.0].
##  @param out_jpeg_size Pointer to write the size of the captured jpeg to.
##  @param jpeg_buf Output buffer containing the JPEG image.
##  @param jpeg_buf_size Size of jpeg_buf, official software uses 0x80000.
##  @param layer_stack \ref ViLayerStack
##  @param timeout Timeout in nanoseconds.
##

proc capsscCaptureJpegScreenShot*(outJpegSize: ptr U64; jpegBuf: pointer;
                                 jpegBufSize: csize_t; layerStack: ViLayerStack;
                                 timeout: S64): Result {.cdecl,
    importc: "capsscCaptureJpegScreenShot".}