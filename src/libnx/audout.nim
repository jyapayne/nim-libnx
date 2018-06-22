import libnx/types
import strutils
import ospaths
const headeraudout = currentSourcePath().splitPath().head & "/nx/include/switch/services/audout.h"
import libnx/audio
type
  AudioOutState* {.size: sizeof(cint).} = enum
    AudioOutState_Started = 0, AudioOutState_Stopped = 1


type
  AudioOutBuffer* {.importc: "AudioOutBuffer", header: headeraudout, bycopy.} = object
    next* {.importc: "next".}: ptr AudioOutBuffer
    buffer* {.importc: "buffer".}: pointer
    buffer_size* {.importc: "buffer_size".}: uint64
    data_size* {.importc: "data_size".}: uint64
    data_offset* {.importc: "data_offset".}: uint64


proc audoutInitialize*(): Result {.cdecl, importc: "audoutInitialize",
                                header: headeraudout.}
proc audoutExit*() {.cdecl, importc: "audoutExit", header: headeraudout.}
proc audoutListAudioOuts*(DeviceNames: cstring; DeviceNamesCount: ptr uint32): Result {.
    cdecl, importc: "audoutListAudioOuts", header: headeraudout.}
proc audoutOpenAudioOut*(DeviceNameIn: cstring; DeviceNameOut: cstring;
                        SampleRateIn: uint32; ChannelCountIn: uint32;
                        SampleRateOut: ptr uint32; ChannelCountOut: ptr uint32;
                        Format: ptr PcmFormat; State: ptr AudioOutState): Result {.
    cdecl, importc: "audoutOpenAudioOut", header: headeraudout.}
proc audoutGetAudioOutState*(State: ptr AudioOutState): Result {.cdecl,
    importc: "audoutGetAudioOutState", header: headeraudout.}
proc audoutStartAudioOut*(): Result {.cdecl, importc: "audoutStartAudioOut",
                                   header: headeraudout.}
proc audoutStopAudioOut*(): Result {.cdecl, importc: "audoutStopAudioOut",
                                  header: headeraudout.}
proc audoutAppendAudioOutBuffer*(Buffer: ptr AudioOutBuffer): Result {.cdecl,
    importc: "audoutAppendAudioOutBuffer", header: headeraudout.}
proc audoutGetReleasedAudioOutBuffer*(Buffer: ptr ptr AudioOutBuffer;
                                     ReleasedBuffersCount: ptr uint32): Result {.
    cdecl, importc: "audoutGetReleasedAudioOutBuffer", header: headeraudout.}
proc audoutContainsAudioOutBuffer*(Buffer: ptr AudioOutBuffer;
                                  ContainsBuffer: ptr bool): Result {.cdecl,
    importc: "audoutContainsAudioOutBuffer", header: headeraudout.}
proc audoutPlayBuffer*(source: ptr AudioOutBuffer; released: ptr ptr AudioOutBuffer): Result {.
    cdecl, importc: "audoutPlayBuffer", header: headeraudout.}
proc audoutWaitPlayFinish*(released: ptr ptr AudioOutBuffer; released_count: ptr uint32;
                          timeout: uint64): Result {.cdecl,
    importc: "audoutWaitPlayFinish", header: headeraudout.}
proc audoutGetSampleRate*(): uint32 {.cdecl, importc: "audoutGetSampleRate",
                                header: headeraudout.}
proc audoutGetChannelCount*(): uint32 {.cdecl, importc: "audoutGetChannelCount",
                                  header: headeraudout.}
proc audoutGetPcmFormat*(): PcmFormat {.cdecl, importc: "audoutGetPcmFormat",
                                     header: headeraudout.}
proc audoutGetDeviceState*(): AudioOutState {.cdecl,
    importc: "audoutGetDeviceState", header: headeraudout.}