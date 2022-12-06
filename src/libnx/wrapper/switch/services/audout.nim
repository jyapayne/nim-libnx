## *
##  @file audout.h
##  @brief Audio output service.
##  @author hexkyz
##  @copyright libnx Authors
##

import
  ../types, ../audio/audio, ../sf/service

type
  AudioOutState* = enum
    AudioOutStateStarted = 0, AudioOutStateStopped = 1


## / Audio output buffer format

type
  AudioOutBuffer* {.bycopy.} = object
    next*: ptr AudioOutBuffer   ## /< Next buffer. (Unused)
    buffer*: pointer           ## /< Sample buffer (aligned to 0x1000 bytes).
    bufferSize*: U64           ## /< Sample buffer size (aligned to 0x1000 bytes).
    dataSize*: U64             ## /< Size of data inside the buffer.
    dataOffset*: U64           ## /< Offset of data inside the buffer. (Unused?)

proc audoutInitialize*(): Result {.cdecl, importc: "audoutInitialize".}
## / Initialize audout.

proc audoutExit*() {.cdecl, importc: "audoutExit".}
## / Exit audout.

proc audoutGetServiceSession*(): ptr Service {.cdecl,
    importc: "audoutGetServiceSession".}
## / Gets the Service object for the actual audout service session.

proc audoutGetServiceSessionAudioOut*(): ptr Service {.cdecl,
    importc: "audoutGetServiceSession_AudioOut".}
## / Gets the Service object for IAudioOut.

proc audoutListAudioOuts*(deviceNames: cstring; count: S32; deviceNamesCount: ptr U32): Result {.
    cdecl, importc: "audoutListAudioOuts".}
##

proc audoutOpenAudioOut*(deviceNameIn: cstring; deviceNameOut: cstring;
                        sampleRateIn: U32; channelCountIn: U32;
                        sampleRateOut: ptr U32; channelCountOut: ptr U32;
                        format: ptr PcmFormat; state: ptr AudioOutState): Result {.
    cdecl, importc: "audoutOpenAudioOut".}
##

proc audoutGetAudioOutState*(state: ptr AudioOutState): Result {.cdecl,
    importc: "audoutGetAudioOutState".}
##

proc audoutStartAudioOut*(): Result {.cdecl, importc: "audoutStartAudioOut".}
##

proc audoutStopAudioOut*(): Result {.cdecl, importc: "audoutStopAudioOut".}
##

proc audoutAppendAudioOutBuffer*(buffer: ptr AudioOutBuffer): Result {.cdecl,
    importc: "audoutAppendAudioOutBuffer".}
## / Submits an \ref AudioOutBuffer for playing.

proc audoutGetReleasedAudioOutBuffer*(buffer: ptr ptr AudioOutBuffer;
                                     releasedBuffersCount: ptr U32): Result {.cdecl,
    importc: "audoutGetReleasedAudioOutBuffer".}
##

proc audoutContainsAudioOutBuffer*(buffer: ptr AudioOutBuffer;
                                  containsBuffer: ptr bool): Result {.cdecl,
    importc: "audoutContainsAudioOutBuffer".}
##

proc audoutGetAudioOutBufferCount*(count: ptr U32): Result {.cdecl,
    importc: "audoutGetAudioOutBufferCount".}
## / Only available with [4.0.0+].

proc audoutGetAudioOutPlayedSampleCount*(count: ptr U64): Result {.cdecl,
    importc: "audoutGetAudioOutPlayedSampleCount".}
## / Only available with [4.0.0+].

proc audoutFlushAudioOutBuffers*(flushed: ptr bool): Result {.cdecl,
    importc: "audoutFlushAudioOutBuffers".}
## / Only available with [4.0.0+].

proc audoutSetAudioOutVolume*(volume: cfloat): Result {.cdecl,
    importc: "audoutSetAudioOutVolume".}
## / Only available with [6.0.0+].

proc audoutGetAudioOutVolume*(volume: ptr cfloat): Result {.cdecl,
    importc: "audoutGetAudioOutVolume".}
## / Only available with [6.0.0+].

proc audoutPlayBuffer*(source: ptr AudioOutBuffer; released: ptr ptr AudioOutBuffer): Result {.
    cdecl, importc: "audoutPlayBuffer".}
## *
##  @brief Submits an audio sample data buffer for playing and waits for it to finish playing.
##  @brief Uses \ref audoutAppendAudioOutBuffer and \ref audoutWaitPlayFinish internally.
##  @param source AudioOutBuffer containing the source sample data to be played.
##  @param released AudioOutBuffer to receive the played buffer after being released.
##

proc audoutWaitPlayFinish*(released: ptr ptr AudioOutBuffer; releasedCount: ptr U32;
                          timeout: U64): Result {.cdecl,
    importc: "audoutWaitPlayFinish".}
## *
##  @brief Waits for audio playback to finish.
##  @param released AudioOutBuffer to receive the first played buffer after being released.
##  @param released_count Pointer to receive the number of played buffers.
##  @param timeout Timeout value, use UINT64_MAX to wait until all finished.
##


## / These return the state associated with the currently active audio output device.

proc audoutGetSampleRate*(): U32 {.cdecl, importc: "audoutGetSampleRate".}
## /< Supported sample rate (48000Hz).

proc audoutGetChannelCount*(): U32 {.cdecl, importc: "audoutGetChannelCount".}
## /< Supported channel count (2 channels).

proc audoutGetPcmFormat*(): PcmFormat {.cdecl, importc: "audoutGetPcmFormat".}
## /< Supported PCM format (Int16).

proc audoutGetDeviceState*(): AudioOutState {.cdecl, importc: "audoutGetDeviceState".}
## /< Initial device state (stopped).
