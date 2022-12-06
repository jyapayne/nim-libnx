## *
##  @file native_window.h
##  @brief Native window (NWindow) wrapper object, used for presenting images to the display (or other sinks).
##  @author fincs
##  @copyright libnx Authors
##

import
  ../kernel/mutex, ../kernel/event, ../services/vi, ../nvidia/graphic_buffer, ../types,
  binder, buffer_producer, ../sf/service, ../nvidia/fence

## / Native window structure.

type
  NWindow* {.bycopy.} = object
    magic*: U32
    bq*: Binder
    event*: Event
    mutex*: Mutex
    slotsConfigured*: U64
    slotsRequested*: U64
    curSlot*: S32
    width*: U32
    height*: U32
    format*: U32
    usage*: U32
    crop*: BqRect
    scalingMode*: U32
    transform*: U32
    stickyTransform*: U32
    defaultWidth*: U32
    defaultHeight*: U32
    swapInterval*: U32
    isConnected*: bool
    producerControlledByApp*: bool
    consumerRunningBehind*: bool

proc nwindowIsValid*(nw: ptr NWindow): bool {.cdecl, importc: "nwindowIsValid".}
## /@name Basic functions
## /@{
## / Checks whether a pointer refers to a valid \ref NWindow object.

proc nwindowGetDefault*(): ptr NWindow {.cdecl, importc: "nwindowGetDefault".}
## *
##  @brief Retrieves the default \ref NWindow object.
##  @return Pointer to the default \ref NWindow object.
##  @note When this function is used/referenced, libnx will initialize VI services
##        and create a \ref NWindow object from a \ref ViLayer created on the default \ref ViDisplay;
##        all of this happening automatically during application startup (i.e. before main is called).
##        If creating the default \ref NWindow fails, libnx will throw a LibnxError_BadGfxInit fatal error.
##        Likewise, after main returns (or exit is called) libnx will clean up all resources used by it.
##

proc nwindowCreate*(nw: ptr NWindow; binderSession: ptr Service; binderId: S32;
                   producerControlledByApp: bool): Result {.cdecl,
    importc: "nwindowCreate".}
## *
##  @brief Creates a \ref NWindow.
##  @param[out] nw Output \ref NWindow structure.
##  @param[in] binder_session Service object for the Android IGraphicBufferProducer binder session.
##  @param[in] binder_id Android IGraphicBufferProducer binder session ID.
##  @param[in] producer_controlled_by_app Specifies whether the producer is controlled by the application.
##

proc nwindowCreateFromLayer*(nw: ptr NWindow; layer: ptr ViLayer): Result {.cdecl,
    importc: "nwindowCreateFromLayer".}
## *
##  @brief Creates a \ref NWindow operating on a \ref ViLayer.
##  @param[out] nw Output \ref NWindow structure.
##  @param[in] layer Pointer to \ref ViLayer structure (such as the one returned by \ref viCreateLayer).
##

proc nwindowClose*(nw: ptr NWindow) {.cdecl, importc: "nwindowClose".}
## / Closes a \ref NWindow, freeing all resources associated with it.

proc nwindowGetDimensions*(nw: ptr NWindow; outWidth: ptr U32; outHeight: ptr U32): Result {.
    cdecl, importc: "nwindowGetDimensions".}
## /@}
## /@name Window configuration
## /@{
## *
##  @brief Retrieves the dimensions of a \ref NWindow.
##  @param[in] nw Pointer to \ref NWindow structure.
##  @param[out] out_width Output variable containing the width of the \ref NWindow.
##  @param[out] out_height Output variable containing the height of the \ref NWindow.
##  @note After creation, a \ref NWindow reports a default size (usually 1280x720).
##        This size can be overriden by calling \ref nwindowSetDimensions.
##

proc nwindowSetDimensions*(nw: ptr NWindow; width: U32; height: U32): Result {.cdecl,
    importc: "nwindowSetDimensions".}
## *
##  @brief Sets the dimensions of a \ref NWindow.
##  @param[in] nw Pointer to \ref NWindow structure.
##  @param[in] width Desired width of the \ref NWindow.
##  @param[in] height Desired width of the \ref NWindow.
##  @note This function cannot be called when there are buffers registered with the \ref NWindow.
##

proc nwindowSetCrop*(nw: ptr NWindow; left: S32; top: S32; right: S32; bottom: S32): Result {.
    cdecl, importc: "nwindowSetCrop".}
## *
##  @brief Configures the crop applied to images presented through a \ref NWindow.
##  @param[in] nw Pointer to \ref NWindow structure.
##  @param[in] left X coordinate of the left margin of the crop bounding box.
##  @param[in] top Y coordinate of the top margin of the crop bounding box.
##  @param[in] right X coordinate of the right margin of the crop bounding box.
##  @param[in] bottom Y coordinate of the bottom margin of the crop bounding box.
##  @note Passing zero to all parameters disables the crop functionality. This is also the default.
##  @note The bounding box defined by the parameters will be adjusted to fit within the dimensions of the \ref NWindow.
##  @note \p left must be less or equal than \p right.
##  @note \p top must be less or equal than \p bottom.
##

proc nwindowSetTransform*(nw: ptr NWindow; transform: U32): Result {.cdecl,
    importc: "nwindowSetTransform".}
## *
##  @brief Configures the transformation applied to images presented through a \ref NWindow.
##  @param[in] nw Pointer to \ref NWindow structure.
##  @param[in] transform Android transformation mode (see NATIVE_WINDOW_TRANSFORM_* enum)
##  @note The default transformation is 0 (i.e. no transformation applied)
##

proc nwindowSetSwapInterval*(nw: ptr NWindow; swapInterval: U32): Result {.cdecl,
    importc: "nwindowSetSwapInterval".}
## *
##  @brief Configures the swap interval of a \ref NWindow.
##  @param[in] nw Pointer to \ref NWindow structure.
##  @param[in] swap_interval Value specifying the number of display refreshes (VBlanks) that must occur between presenting images.
##  @note The default swap interval is 1.
##  @note If the \ref NWindow has three or more buffers configured (with \ref nwindowConfigureBuffer), it is possible to pass 0
##        to disable the swap interval feature and present images as fast as allowed by the compositor. Otherwise, the system
##        enforces a minimum of 1 as the swap interval.
##

proc nwindowIsConsumerRunningBehind*(nw: ptr NWindow): bool {.inline, cdecl.} =
  ## / Checks whether the consumer of a \ref NWindow is running behind.
  return nw.consumerRunningBehind

proc nwindowConfigureBuffer*(nw: ptr NWindow; slot: S32; buf: ptr NvGraphicBuffer): Result {.
    cdecl, importc: "nwindowConfigureBuffer".}
## /@}
## /@name Buffer configuration and presentation
## /@{
## *
##  @brief Registers a \ref NvGraphicBuffer with a \ref NWindow.
##  @param[in] nw Pointer to \ref NWindow structure.
##  @param[in] slot ID of the slot to configure (starting from 0).
##  @param[in] buf Pointer to \ref NvGraphicBuffer structure.
##  @note When a buffer is registered, it is added to the internal queue of buffers used for presenting.
##  @note All buffers registered with a \ref NWindow must have the same dimensions, format and usage.
##        If \ref nwindowSetDimensions has not been previously called, the \ref NWindow will automatically
##        adopt the dimensions of the first buffer registered with it. Otherwise, said buffer will need
##        to match the dimensions that were previously configured.
##

proc nwindowDequeueBuffer*(nw: ptr NWindow; outSlot: ptr S32;
                          outFence: ptr NvMultiFence): Result {.cdecl,
    importc: "nwindowDequeueBuffer".}
## *
##  @brief Dequeues a buffer from a \ref NWindow.
##  @param[in] nw Pointer to \ref NWindow structure.
##  @param[out] out_slot Output variable containing the ID of the slot that has been dequeued.
##  @param[out] out_fence Output variable containing a \ref NvMultiFence that will be signalled by
##              the compositor when the buffer is ready to be written to. Pass NULL to wait instead
##              on this fence before this function returns.
##  @note For \p out_fence=NULL to work, \ref nvFenceInit must have been previously called.
##

proc nwindowCancelBuffer*(nw: ptr NWindow; slot: S32; fence: ptr NvMultiFence): Result {.
    cdecl, importc: "nwindowCancelBuffer".}
## *
##  @brief Cancels a buffer previously dequeued with \ref nwindowDequeueBuffer.
##  @param[in] nw Pointer to \ref NWindow structure.
##  @param[in] slot ID of the slot to cancel. This must match the output of the previous \ref nwindowDequeueBuffer call.
##  @param[in] fence Pointer to the \ref NvMultiFence that will be waited on by the compositor before cancelling the buffer.
##                   Pass NULL if there is no such fence.
##

proc nwindowQueueBuffer*(nw: ptr NWindow; slot: S32; fence: ptr NvMultiFence): Result {.
    cdecl, importc: "nwindowQueueBuffer".}
## *
##  @brief Queues a buffer previously dequeued with \ref nwindowDequeueBuffer, making it ready for presentation.
##  @param[in] nw Pointer to \ref NWindow structure.
##  @param[in] slot ID of the slot to queue. This must match the output of the previous \ref nwindowDequeueBuffer call.
##  @param[in] fence Pointer to the \ref NvMultiFence that will be waited on by the compositor before queuing/presenting the buffer.
##                   Pass NULL if there is no such fence.
##

proc nwindowReleaseBuffers*(nw: ptr NWindow): Result {.cdecl,
    importc: "nwindowReleaseBuffers".}
## / Releases all buffers registered with a \ref NWindow.

## /@}
