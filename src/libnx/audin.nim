import libnx/types
import strutils
import ospaths
const headeraudin = currentSourcePath().splitPath().head & "/nx/include/switch/services/audin.h"
import libnx/audio
type
  AudioInState* {.size: sizeof(cint).} = enum
    AudioInState_Started = 0, AudioInState_Stopped = 1


type
  AudioInBuffer* {.importc: "AudioInBuffer", header: headeraudin, bycopy.} = object
    next* {.importc: "next".}: ptr AudioInBuffer
    buffer* {.importc: "buffer".}: pointer
    buffer_size* {.importc: "buffer_size".}: uint64
    data_size* {.importc: "data_size".}: uint64
    data_offset* {.importc: "data_offset".}: uint64


proc audinInitialize*(): Result {.cdecl, importc: "audinInitialize",
                               header: headeraudin.}
proc audinExit*() {.cdecl, importc: "audinExit", header: headeraudin.}
proc audinListAudioIns*(DeviceNames: cstring; DeviceNamesCount: ptr uint32): Result {.
    cdecl, importc: "audinListAudioIns", header: headeraudin.}
proc audinOpenAudioIn*(DeviceNameIn: cstring; DeviceNameOut: cstring;
                      SampleRateIn: uint32; ChannelCountIn: uint32;
                      SampleRateOut: ptr uint32; ChannelCountOut: ptr uint32;
                      Format: ptr PcmFormat; State: ptr AudioInState): Result {.
    cdecl, importc: "audinOpenAudioIn", header: headeraudin.}
proc audinGetAudioInState*(State: ptr AudioInState): Result {.cdecl,
    importc: "audinGetAudioInState", header: headeraudin.}
proc audinStartAudioIn*(): Result {.cdecl, importc: "audinStartAudioIn",
                                 header: headeraudin.}
proc audinStopAudioIn*(): Result {.cdecl, importc: "audinStopAudioIn",
                                header: headeraudin.}
proc audinAppendAudioInBuffer*(Buffer: ptr AudioInBuffer): Result {.cdecl,
    importc: "audinAppendAudioInBuffer", header: headeraudin.}
proc audinGetReleasedAudioInBuffer*(Buffer: ptr ptr AudioInBuffer;
                                   ReleasedBuffersCount: ptr uint32): Result {.cdecl,
    importc: "audinGetReleasedAudioInBuffer", header: headeraudin.}
proc audinContainsAudioInBuffer*(Buffer: ptr AudioInBuffer;
                                ContainsBuffer: ptr bool): Result {.cdecl,
    importc: "audinContainsAudioInBuffer", header: headeraudin.}
proc audinCaptureBuffer*(source: ptr AudioInBuffer; released: ptr ptr AudioInBuffer): Result {.
    cdecl, importc: "audinCaptureBuffer", header: headeraudin.}
proc audinWaitCaptureFinish*(released: ptr ptr AudioInBuffer;
                            released_count: ptr uint32; timeout: uint64): Result {.cdecl,
    importc: "audinWaitCaptureFinish", header: headeraudin.}
proc audinGetSampleRate*(): uint32 {.cdecl, importc: "audinGetSampleRate",
                               header: headeraudin.}
proc audinGetChannelCount*(): uint32 {.cdecl, importc: "audinGetChannelCount",
                                 header: headeraudin.}
proc audinGetPcmFormat*(): PcmFormat {.cdecl, importc: "audinGetPcmFormat",
                                    header: headeraudin.}
proc audinGetDeviceState*(): AudioInState {.cdecl, importc: "audinGetDeviceState",
    header: headeraudin.}