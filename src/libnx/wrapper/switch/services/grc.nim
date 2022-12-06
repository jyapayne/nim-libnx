## *
##  @file grc.h
##  @brief GRC Game Recording (grc:*) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/caps, ../kernel/event, ../kernel/tmem,
  ../display/native_window

## / Stream type values for \ref grcdTransfer.

type
  GrcStream* = enum
    GrcStreamVideo = 0,         ## /< Video stream with H.264 NAL units. Official sw uses buffer size 0x32000.
    GrcStreamAudio = 1          ## /< Audio stream with PcmFormat_Int16, 2 channels, and samplerate = 48000Hz. Official sw uses buffer size 0x1000.


## / GameMovieTrimmer

type
  GrcGameMovieTrimmer* {.bycopy.} = object
    s*: Service                ## /< IGameMovieTrimmer
    tmem*: TransferMemory      ## /< TransferMemory


## / IMovieMaker

type
  GrcMovieMaker* {.bycopy.} = object
    a*: Service                ## /< applet IMovieMaker
    s*: Service                ## /< grc IMovieMaker
    videoProxy*: Service       ## /< IHOSBinderDriver VideoProxy
    recordingEvent*: Event     ## /< Output Event from GetOffscreenLayerRecordingFinishReadyEvent with autoclear=false.
    audioEvent*: Event         ## /< Output Event from GetOffscreenLayerAudioEncodeReadyEvent with autoclear=false.
    tmem*: TransferMemory      ## /< TransferMemory
    win*: NWindow              ## /< \ref NWindow
    layerHandle*: U64          ## /< LayerHandle
    layerOpen*: bool           ## /< Whether OpenOffscreenLayer was used successfully, indicating that CloseOffscreenLayer should be used during \ref grcMovieMakerClose.
    startedFlag*: bool         ## /< Whether \ref grcMovieMakerStart was used successfully. This is also used by \ref grcMovieMakerAbort.


## / GameMovieId

type
  GrcGameMovieId* {.bycopy.} = object
    fileId*: CapsAlbumFileId   ## /< \ref CapsAlbumFileId
    reserved*: array[0x28, U8]  ## /< Unused, always zero.


## / OffscreenRecordingParameter

type
  GrcOffscreenRecordingParameter* {.bycopy.} = object
    unkX0*: array[0x10, U8]     ## /< Unknown. Default value is 0.
    unkX10*: U32               ## /< Unknown. Must match value 0x103, which is the default value.
    videoBitrate*: S32         ## /< VideoBitRate, 0 is invalid. Default value is 8000000.
    videoWidth*: S32           ## /< VideoWidth, must match 1280 or 1920. Default value is 1280.
    videoHeight*: S32          ## /< VideoHeight, must match 720 or 1080. Default value is 720.
    videoFramerate*: S32       ## /< VideoFrameRate, must match 30 or 60. Default value is 30.
    videoKeyFrameInterval*: S32 ## /< VideoKeyFrameInterval, 0 is invalid. Default value is 30.
    audioBitrate*: S32         ## /< AudioBitRate. Default value is 128000 ([5.0.0-5.1.0] 1536000).
    audioSamplerate*: S32      ## /< AudioSampleRate, 0 is invalid. Default value is 48000.
    audioChannelCount*: S32    ## /< AudioChannelCount. Must match 2, which is the default value.
    audioSampleFormat*: S32    ## /< \ref PcmFormat AudioSampleFormat. Must match PcmFormat_Int16, which is the default value.
    videoImageOrientation*: S32 ## /< \ref AlbumImageOrientation VideoImageOrientation. Default value is ::AlbumImageOrientation_Unknown0.
    unkX3c*: array[0x44, U8]    ## /< Unknown. Default value is 0.


## / Default size for \ref grcCreateMovieMaker, this is the size used by official sw.

const
  GRC_MOVIEMAKER_WORKMEMORY_SIZE_DEFAULT* = 0x6000000
proc grcTrimGameMovie*(dstMovieid: ptr GrcGameMovieId;
                      srcMovieid: ptr GrcGameMovieId; tmemSize: csize_t;
                      thumbnail: pointer; start: S32; `end`: S32): Result {.cdecl,
    importc: "grcTrimGameMovie".}
## /@name Trimming
## /@{
## *
##  @brief Creates a \ref GrcGameMovieTrimmer using \ref appletCreateGameMovieTrimmer, uses the cmds from it to trim the specified video, then closes it.
##  @note See \ref appletCreateGameMovieTrimmer for the requirements for using this.
##  @note This will block until video trimming finishes.
##  @param[out] dst_movieid \ref GrcGameMovieId for the output video.
##  @param[in] src_movieid \ref GrcGameMovieId for the input video.
##  @param[in] tmem_size TransferMemory size. Official sw uses size 0x2000000.
##  @param[in] thumbnail Optional, can be NULL. RGBA8 1280x720 thumbnail image data.
##  @param[in] start Start timestamp in 0.5s units.
##  @param[in] end End timestamp in 0.5s units.
##

proc grcCreateOffscreenRecordingParameter*(
    param: ptr GrcOffscreenRecordingParameter) {.cdecl,
    importc: "grcCreateOffscreenRecordingParameter".}
## /@}
## /@name IMovieMaker
## /@{
## *
##  @brief Creates a \ref GrcOffscreenRecordingParameter with the default values, see \ref GrcOffscreenRecordingParameter for the default values.
##  @param[out] param \ref GrcOffscreenRecordingParameter
##

proc grcCreateMovieMaker*(m: ptr GrcMovieMaker; size: csize_t): Result {.cdecl,
    importc: "grcCreateMovieMaker".}
## *
##  @brief Creates a \ref GrcMovieMaker using \ref appletCreateMovieMaker, and does the required initialization.
##  @note See \ref appletCreateMovieMaker for the requirements for using this.
##  @param[out] m \ref GrcMovieMaker
##  @param[in] size TransferMemory WorkMemory size. See \ref GRC_MOVIEMAKER_WORKMEMORY_SIZE_DEFAULT.
##

proc grcMovieMakerClose*(m: ptr GrcMovieMaker) {.cdecl, importc: "grcMovieMakerClose".}
## *
##  @brief Closes a \ref GrcMovieMaker.
##  @note This also uses \ref grcMovieMakerAbort.
##  @param m \ref GrcMovieMaker
##

proc grcMovieMakerGetNWindow*(m: ptr GrcMovieMaker): ptr NWindow {.inline, cdecl.} =
  ## *
  ##  @brief Gets the \ref NWindow for the specified MovieMaker.
  ##  @param m \ref GrcMovieMaker
  ##
  return addr(m.win)

proc grcMovieMakerAbort*(m: ptr GrcMovieMaker): Result {.cdecl,
    importc: "grcMovieMakerAbort".}
## *
##  @brief Aborts recording with the specified MovieMaker.
##  @note This is used automatically by \ref grcMovieMakerClose.
##  @note This will throw an error if \ref grcMovieMakerStart was not used previously, with the flag used for this being cleared afterwards on success.
##  @param m \ref GrcMovieMaker
##

proc grcMovieMakerStart*(m: ptr GrcMovieMaker;
                        param: ptr GrcOffscreenRecordingParameter): Result {.cdecl,
    importc: "grcMovieMakerStart".}
## *
##  @brief Starts recording with the specified MovieMaker and \ref GrcOffscreenRecordingParameter.
##  @param m \ref GrcMovieMaker
##  @param[in] param \ref GrcOffscreenRecordingParameter
##

proc grcMovieMakerFinish*(m: ptr GrcMovieMaker; width: S32; height: S32;
                         userdata: pointer; userdataSize: csize_t;
                         thumbnail: pointer; thumbnailSize: csize_t;
                         entry: ptr CapsApplicationAlbumEntry): Result {.cdecl,
    importc: "grcMovieMakerFinish".}
## *
##  @brief Finishes recording with the specified MovieMaker.
##  @note This automatically uses \ref grcMovieMakerAbort on error.
##  @note The recorded video will not be accessible via the Album-applet since it's stored separately from other Album data.
##  @param m \ref GrcMovieMaker
##  @param width Width for the thumbnail, must be 1280.
##  @param height Height for the thumbnail, must be 720.
##  @param[in] userdata UserData input buffer for the JPEG thumbnail. Optional, can be NULL.
##  @param[in] userdata_size Size of the UserData input buffer. Optional, can be 0. Must be <=0x400.
##  @param[in] thumbnail RGBA8 image buffer containing the thumbnail. Optional, can be NULL.
##  @param[in] thumbnail_size Size of the thumbnail buffer. Optional, can be 0.
##  @param[out] entry Output \ref CapsApplicationAlbumEntry for the recorded video. Optional, can be NULL. Only available on [7.0.0+], if this is not NULL on pre-7.0.0 an error is thrown.
##

proc grcMovieMakerGetError*(m: ptr GrcMovieMaker): Result {.cdecl,
    importc: "grcMovieMakerGetError".}
## *
##  @brief Gets the recording error with the specified MovieMaker.
##  @param m \ref GrcMovieMaker
##

proc grcMovieMakerEncodeAudioSample*(m: ptr GrcMovieMaker; buffer: pointer;
                                    size: csize_t): Result {.cdecl,
    importc: "grcMovieMakerEncodeAudioSample".}
## *
##  @brief Encodes audio sample data with the specified MovieMaker.
##  @note This waits on the event and uses the cmd repeatedly until the entire input buffer is handled.
##  @note If you don't use this the recorded video will be missing audio.
##  @param m \ref GrcMovieMaker
##  @param[in] buffer Audio buffer.
##  @param[in] size Size of the buffer.
##

proc grcdInitialize*(): Result {.cdecl, importc: "grcdInitialize".}
## /@}
## /@name grc:d
## /@{
## / Initialize grc:d.

proc grcdExit*() {.cdecl, importc: "grcdExit".}
## / Exit grc:d.

proc grcdGetServiceSession*(): ptr Service {.cdecl, importc: "grcdGetServiceSession".}
## / Gets the Service for grc:d.

proc grcdBegin*(): Result {.cdecl, importc: "grcdBegin".}
## / Begins streaming. This must not be called more than once, even from a different service session: otherwise the sysmodule will assert.

proc grcdTransfer*(stream: GrcStream; buffer: pointer; size: csize_t;
                  numFrames: ptr U32; dataSize: ptr U32; startTimestamp: ptr U64): Result {.
    cdecl, importc: "grcdTransfer".}
## *
##  @brief Retrieves stream data from the continuous recorder in use (from the video recording of the currently running application).
##  @note This will block until data is available. This will hang if there is no application running which has video capture enabled.
##  @param[in] stream \ref GrcStream
##  @param[out] buffer Output buffer.
##  @param[in] size Max size of the output buffer.
##  @param[out] num_frames num_frames
##  @param[out] data_size Actual output data size.
##  @param[out] start_timestamp Start timestamp.
##

## /@}
