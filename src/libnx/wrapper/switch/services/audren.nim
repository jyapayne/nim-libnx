## *
##  @file audren.h
##  @brief Audio renderer service.
##  @author fincs
##  @copyright libnx Authors
##

import
  ../types, ../audio/audio, ../sf/service

const
  AUDREN_TIMER_FREQ_HZ* = 200.0f
  AUDREN_TIMER_PERIOD_MS* = 5.0f
  AUDREN_SAMPLES_PER_FRAME_32KHZ* = 160
  AUDREN_SAMPLES_PER_FRAME_48KHZ* = 240
  AUDREN_INPUT_PARAM_ALIGNMENT* = 0x1000
  AUDREN_OUTPUT_PARAM_ALIGNMENT* = 0x10
  AUDREN_MEMPOOL_ALIGNMENT* = 0x1000
  AUDREN_BUFFER_ALIGNMENT* = 0x40
  AUDREN_REVISION_1* = 0x31564552 ## REV1 [1.0.0+]
  AUDREN_REVISION_2* = 0x32564552 ## REV2 [2.0.0+]
  AUDREN_REVISION_3* = 0x33564552 ## REV3 [3.0.0+]
  AUDREN_REVISION_4* = 0x34564552 ## REV4 [4.0.0+]
  AUDREN_REVISION_5* = 0x35564552 ## REV5 [6.0.0+]
  AUDREN_REVISION_6* = 0x36564552 ## REV6 [6.1.0+]

template audren_Nodeid*(a, b, c: untyped): untyped =
  ((((u32)(a) and 0xF) shl 28) or (((u32)(b) and 0xFFF) shl 16) or ((u32)(c) and 0xFFFF))

const
  AUDREN_FINAL_MIX_ID* = 0
  AUDREN_UNUSED_MIX_ID* = 0x7FFFFFFF
  AUDREN_UNUSED_SPLITTER_ID* = 0xFFFFFFFF
  AUDREN_DEFAULT_DEVICE_NAME* = "MainAudioOut"

type
  AudioRendererOutputRate* = enum
    AudioRendererOutputRate32kHz, AudioRendererOutputRate48kHz
  AudioRendererConfig* {.bycopy.} = object
    outputRate*: AudioRendererOutputRate
    numVoices*: cint
    numEffects*: cint
    numSinks*: cint
    numMixObjs*: cint
    numMixBuffers*: cint



##
## Input buffer layout:
##
## AudioRendererUpdateDataHeader
## AudioRendererBehaviorInfoIn
## AudioRendererMemPoolInfoIn * mempool_count
## AudioRendererChannelInfoIn * channel_count
## AudioRendererVoiceInfoIn * voice_count
## (effects would go here)
## (splitters would go here)
## AudioRendererMixInfoIn * mix_count (i.e. submix_count+1)
## AudioRendererSinkInfoIn * sink_count
## AudioRendererPerformanceBufferInfoIn
##
##
## Output buffer layout:
##
## AudioRendererUpdateDataHeader
## AudioRendererMemPoolInfoOut * mempool_count
## AudioRendererVoiceInfoOut * voice_count
## (effects would go here)
## AudioRendererSinkInfoOut * sink_count
## AudioRendererPerformanceBufferInfoOut
## AudioRendererBehaviorInfoOut
##

type
  INNER_C_UNION_audren_2* {.bycopy, union.} = object
    deviceSink*: AudioRendererDeviceSinkInfoIn
    circularBufferSink*: AudioRendererCircularBufferSinkInfoIn

  AudioRendererUpdateDataHeader* {.bycopy.} = object
    revision*: U32
    behaviorSz*: U32
    mempoolsSz*: U32
    voicesSz*: U32
    channelsSz*: U32
    effectsSz*: U32
    mixesSz*: U32
    sinksSz*: U32
    perfmgrSz*: U32
    padding*: array[6, U32]
    totalSz*: U32

  AudioRendererBehaviorInfoIn* {.bycopy.} = object
    revision*: U32
    padding1*: U32
    flags*: U64

  AudioRendererBehaviorInfoOut* {.bycopy.} = object
    unknown*: array[20, U64]
    padding1*: array[2, U64]

  AudioRendererMemPoolState* = enum
    AudioRendererMemPoolStateInvalid, AudioRendererMemPoolStateNew,
    AudioRendererMemPoolStateRequestDetach, AudioRendererMemPoolStateDetached,
    AudioRendererMemPoolStateRequestAttach, AudioRendererMemPoolStateAttached,
    AudioRendererMemPoolStateReleased
  AudioRendererMemPoolInfoIn* {.bycopy.} = object
    address*: pointer
    size*: U64
    state*: AudioRendererMemPoolState
    padding2*: array[3, U32]

  AudioRendererMemPoolInfoOut* {.bycopy.} = object
    newState*: AudioRendererMemPoolState
    padding2*: array[3, U32]

  AudioRendererChannelInfoIn* {.bycopy.} = object
    id*: U32
    mix*: array[24, cfloat]
    isUsed*: bool
    padding1*: array[11, U8]

  AudioRendererBiquadFilter* {.bycopy.} = object
    enable*: bool
    padding*: U8
    numerator*: array[3, S16]
    denominator*: array[2, S16]

  AudioRendererAdpcmParameters* {.bycopy.} = object
    coefficients*: array[16, U16]

  AudioRendererAdpcmContext* {.bycopy.} = object
    index*: U16
    history0*: S16
    history1*: S16

  AudioRendererWaveBuf* {.bycopy.} = object
    address*: pointer
    size*: U64
    startSampleOffset*: S32
    endSampleOffset*: S32
    isLooping*: bool
    endOfStream*: bool
    sentToServer*: bool
    padding1*: array[5, U8]
    contextAddr*: pointer
    contextSz*: U64
    padding2*: U64

  AudioRendererVoicePlayState* = enum
    AudioRendererVoicePlayStateStarted, AudioRendererVoicePlayStateStopped,
    AudioRendererVoicePlayStatePaused
  AudioRendererVoiceInfoIn* {.bycopy.} = object
    id*: U32
    nodeId*: U32
    isNew*: bool
    isUsed*: bool
    state* {.bitsize: 8.}: AudioRendererVoicePlayState
    sampleFormat* {.bitsize: 8.}: PcmFormat
    sampleRate*: U32
    priority*: U32
    sortingOrder*: U32
    channelCount*: U32
    pitch*: cfloat
    volume*: cfloat
    biquads*: array[2, AudioRendererBiquadFilter]
    wavebufCount*: U32
    wavebufHead*: S16
    padding1*: U16
    padding2*: U32
    extraParamsPtr*: pointer
    extraParamsSz*: U64
    destMixId*: U32
    destSplitterId*: U32
    wavebufs*: array[4, AudioRendererWaveBuf]
    channelIds*: array[6, U32]
    padding3*: array[24, U8]

  AudioRendererVoiceInfoOut* {.bycopy.} = object
    playedSampleCount*: U64
    numWavebufsConsumed*: U32
    voiceDropsCount*: U32

  AudioRendererMixInfoIn* {.bycopy.} = object
    volume*: cfloat
    sampleRate*: U32
    bufferCount*: U32
    isUsed*: bool
    padding1*: array[3, U8]
    mixId*: U32
    padding2*: U32
    nodeId*: U32
    padding3*: array[2, U32]
    mix*: array[24, array[24, cfloat]] ##  [src_index][dest_index]
    destMixId*: U32
    destSplitterId*: U32
    padding4*: U32

  AudioRendererDownMixParameters* {.bycopy.} = object
    coefficients*: array[16, U8]

  AudioRendererSinkType* = enum
    AudioRendererSinkTypeInvalid, AudioRendererSinkTypeDevice,
    AudioRendererSinkTypeCircularBuffer
  AudioRendererDeviceSinkInfoIn* {.bycopy.} = object
    name*: array[255, char]
    padding1*: U8
    inputCount*: U32
    inputs*: array[6, U8]
    padding2*: U8
    downmixParamsEnabled*: bool
    downmixParams*: AudioRendererDownMixParameters

  AudioRendererCircularBufferSinkInfoIn* {.bycopy.} = object
    bufferPtr*: pointer
    bufferSz*: U32
    inputCount*: U32
    sampleCount*: U32
    lastReadOffset*: U32
    sampleFormat*: PcmFormat
    inputs*: array[6, U8]
    padding2*: array[6, U8]

  AudioRendererSinkInfoIn* {.bycopy.} = object
    `type`* {.bitsize: 8.}: AudioRendererSinkType
    isUsed*: bool
    padding1*: array[2, U8]
    nodeId*: U32
    padding2*: array[3, U64]
    anoAudren3*: INNER_C_UNION_audren_2

  AudioRendererSinkInfoOut* {.bycopy.} = object
    lastWrittenOffset*: U32
    unk1*: U32
    unk2*: U64
    padding1*: array[2, U64]

  AudioRendererPerformanceBufferInfoIn* {.bycopy.} = object
    detailTarget*: U32
    padding1*: array[3, U32]

  AudioRendererPerformanceBufferInfoOut* {.bycopy.} = object
    writtenSz*: U32
    padding1*: array[3, U32]





proc audrenGetRevision*(): U32 {.inline, cdecl.} =
  var gAudrenRevision: U32
  return gAudrenRevision

proc audrenGetMemPoolCount*(config: ptr AudioRendererConfig): cint {.inline, cdecl.} =
  return config.numEffects + 4 * config.numVoices

proc audrenGetInputParamSize*(config: ptr AudioRendererConfig): csize_t {.inline, cdecl.} =
  var size: csize_t = 0
  inc(size, sizeof((AudioRendererUpdateDataHeader)))
  inc(size, sizeof((AudioRendererBehaviorInfoIn)))
  inc(size, sizeof((AudioRendererMemPoolInfoIn)) *
      audrenGetMemPoolCount(config))
  inc(size, sizeof((AudioRendererChannelInfoIn)) * config.numVoices)
  inc(size, sizeof((AudioRendererVoiceInfoIn)) * config.numVoices)
  ##  todo: effects, splitters
  inc(size, sizeof((AudioRendererMixInfoIn)) * config.numMixObjs)
  inc(size, sizeof((AudioRendererSinkInfoIn)) * config.numSinks)
  inc(size, sizeof((AudioRendererPerformanceBufferInfoIn)))
  return size

proc audrenGetOutputParamSize*(config: ptr AudioRendererConfig): csize_t {.inline, cdecl.} =
  var size: csize_t = 0
  inc(size, sizeof((AudioRendererUpdateDataHeader)))
  inc(size, sizeof((AudioRendererMemPoolInfoOut)) *
      audrenGetMemPoolCount(config))
  inc(size, sizeof((AudioRendererVoiceInfoOut)) * config.numVoices)
  ##  todo: effects
  inc(size, sizeof((AudioRendererSinkInfoOut)) * config.numSinks)
  inc(size, sizeof((AudioRendererPerformanceBufferInfoOut)))
  inc(size, sizeof((AudioRendererBehaviorInfoOut)))
  return size


proc audrenInitialize*(config: ptr AudioRendererConfig): Result {.cdecl,
    importc: "audrenInitialize".}
## / Initialize audren.

proc audrenExit*() {.cdecl, importc: "audrenExit".}
## / Exit audren.

proc audrenGetServiceSessionAudioRenderer*(): ptr Service {.cdecl,
    importc: "audrenGetServiceSession_AudioRenderer".}
## / Gets the Service object for IAudioRenderer.
proc audrenWaitFrame*() {.cdecl, importc: "audrenWaitFrame".}
proc audrenGetState*(outState: ptr U32): Result {.cdecl, importc: "audrenGetState".}
proc audrenRequestUpdateAudioRenderer*(inParamBuf: pointer;
                                      inParamBufSize: csize_t;
                                      outParamBuf: pointer;
                                      outParamBufSize: csize_t; perfBuf: pointer;
                                      perfBufSize: csize_t): Result {.cdecl,
    importc: "audrenRequestUpdateAudioRenderer".}
proc audrenStartAudioRenderer*(): Result {.cdecl,
                                        importc: "audrenStartAudioRenderer".}
proc audrenStopAudioRenderer*(): Result {.cdecl, importc: "audrenStopAudioRenderer".}
proc audrenSetAudioRendererRenderingTimeLimit*(percent: cint): Result {.cdecl,
    importc: "audrenSetAudioRendererRenderingTimeLimit".}
