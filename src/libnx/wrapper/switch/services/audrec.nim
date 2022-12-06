## *
##  @file audrec.h
##  @brief Audio Recorder IPC wrapper.
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../kernel/event

type
  FinalOutputRecorderBuffer* {.bycopy.} = object
    releasedNs*: U64
    nextBufferPtr*: U64
    sampleBufferPtr*: U64
    sampleBufferCapacity*: U64
    dataSize*: U64
    dataOffset*: U64

  FinalOutputRecorderParameter* {.bycopy.} = object
    sampleRate*: U32
    channelCount*: U32

  FinalOutputRecorderParameterInternal* {.bycopy.} = object
    sampleRate*: U32
    channelCount*: U32
    sampleFormat*: U32
    state*: U32

  AudrecRecorder* {.bycopy.} = object
    s*: Service


proc audrecInitialize*(): Result {.cdecl, importc: "audrecInitialize".}
proc audrecExit*() {.cdecl, importc: "audrecExit".}
proc audrecGetServiceSession*(): ptr Service {.cdecl,
    importc: "audrecGetServiceSession".}
proc audrecOpenFinalOutputRecorder*(recorderOut: ptr AudrecRecorder;
                                   paramIn: ptr FinalOutputRecorderParameter;
                                   aruid: U64; paramOut: ptr FinalOutputRecorderParameterInternal): Result {.
    cdecl, importc: "audrecOpenFinalOutputRecorder".}
proc audrecRecorderStart*(recorder: ptr AudrecRecorder): Result {.cdecl,
    importc: "audrecRecorderStart".}
proc audrecRecorderStop*(recorder: ptr AudrecRecorder): Result {.cdecl,
    importc: "audrecRecorderStop".}
proc audrecRecorderRegisterBufferEvent*(recorder: ptr AudrecRecorder;
                                       outEvent: ptr Event): Result {.cdecl,
    importc: "audrecRecorderRegisterBufferEvent".}
proc audrecRecorderAppendFinalOutputRecorderBuffer*(recorder: ptr AudrecRecorder;
    bufferClientPtr: U64; param: ptr FinalOutputRecorderBuffer): Result {.cdecl,
    importc: "audrecRecorderAppendFinalOutputRecorderBuffer".}
proc audrecRecorderGetReleasedFinalOutputRecorderBuffers*(
    recorder: ptr AudrecRecorder; outBuffers: ptr U64; inoutCount: ptr U64;
    outReleased: ptr U64): Result {.cdecl, importc: "audrecRecorderGetReleasedFinalOutputRecorderBuffers".}
proc audrecRecorderClose*(recorder: ptr AudrecRecorder) {.cdecl,
    importc: "audrecRecorderClose".}
