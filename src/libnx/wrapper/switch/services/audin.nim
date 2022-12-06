## *
##  @file audin.h
##  @brief Audio input service.
##  @author hexkyz
##  @copyright libnx Authors
##

import
  ../types, ../audio/audio, ../sf/service

type
  AudioInState* = enum
    AudioInStateStarted = 0, AudioInStateStopped = 1


## / Audio input buffer format

type
  AudioInBuffer* {.bycopy.} = object
    next*: ptr AudioInBuffer    ## /< Next buffer. (Unused)
    buffer*: pointer           ## /< Sample buffer (aligned to 0x1000 bytes).
    bufferSize*: U64           ## /< Sample buffer size (aligned to 0x1000 bytes).
    dataSize*: U64             ## /< Size of data inside the buffer.
    dataOffset*: U64           ## /< Offset of data inside the buffer. (Unused?)

proc audinInitialize*(): Result {.cdecl, importc: "audinInitialize".}
## / Initialize audin.

proc audinExit*() {.cdecl, importc: "audinExit".}
## / Exit audin.

proc audinGetServiceSession*(): ptr Service {.cdecl,
    importc: "audinGetServiceSession".}
## / Gets the Service object for the actual audin service session.

proc audinGetServiceSessionAudioIn*(): ptr Service {.cdecl,
    importc: "audinGetServiceSession_AudioIn".}
## / Gets the Service object for IAudioIn.

proc audinListAudioIns*(deviceNames: cstring; count: S32; deviceNamesCount: ptr U32): Result {.
    cdecl, importc: "audinListAudioIns".}
##

proc audinOpenAudioIn*(deviceNameIn: cstring; deviceNameOut: cstring;
                      sampleRateIn: U32; channelCountIn: U32;
                      sampleRateOut: ptr U32; channelCountOut: ptr U32;
                      format: ptr PcmFormat; state: ptr AudioInState): Result {.cdecl,
    importc: "audinOpenAudioIn".}
##

proc audinGetAudioInState*(state: ptr AudioInState): Result {.cdecl,
    importc: "audinGetAudioInState".}
##

proc audinStartAudioIn*(): Result {.cdecl, importc: "audinStartAudioIn".}
##

proc audinStopAudioIn*(): Result {.cdecl, importc: "audinStopAudioIn".}
##

proc audinAppendAudioInBuffer*(buffer: ptr AudioInBuffer): Result {.cdecl,
    importc: "audinAppendAudioInBuffer".}
## / Submits an \ref AudioInBuffer for capturing.

proc audinGetReleasedAudioInBuffer*(buffer: ptr ptr AudioInBuffer;
                                   releasedBuffersCount: ptr U32): Result {.cdecl,
    importc: "audinGetReleasedAudioInBuffer".}
##

proc audinContainsAudioInBuffer*(buffer: ptr AudioInBuffer; containsBuffer: ptr bool): Result {.
    cdecl, importc: "audinContainsAudioInBuffer".}
##

proc audinCaptureBuffer*(source: ptr AudioInBuffer; released: ptr ptr AudioInBuffer): Result {.
    cdecl, importc: "audinCaptureBuffer".}
## *
##  @brief Submits an audio sample data buffer for capturing and waits for it to finish capturing.
##  @brief Uses \ref audinAppendAudioInBuffer and \ref audinWaitCaptureFinish internally.
##  @param source AudioInBuffer containing the buffer to hold the captured sample data.
##  @param released AudioInBuffer to receive the captured buffer after being released.
##

proc audinWaitCaptureFinish*(released: ptr ptr AudioInBuffer; releasedCount: ptr U32;
                            timeout: U64): Result {.cdecl,
    importc: "audinWaitCaptureFinish".}
## *
##  @brief Waits for audio capture to finish.
##  @param released AudioInBuffer to receive the first captured buffer after being released.
##  @param released_count Pointer to receive the number of captured buffers.
##  @param timeout Timeout value, use UINT64_MAX to wait until all finished.
##


## / These return the state associated with the currently active audio input device.

proc audinGetSampleRate*(): U32 {.cdecl, importc: "audinGetSampleRate".}
## /< Supported sample rate (48000Hz).

proc audinGetChannelCount*(): U32 {.cdecl, importc: "audinGetChannelCount".}
## /< Supported channel count (2 channels).

proc audinGetPcmFormat*(): PcmFormat {.cdecl, importc: "audinGetPcmFormat".}
## /< Supported PCM format (Int16).

proc audinGetDeviceState*(): AudioInState {.cdecl, importc: "audinGetDeviceState".}
## /< Initial device state (stopped).
