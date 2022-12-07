## *
##  @file driver.h
##  @brief Audio driver (audren wrapper).
##  @author fincs
##  @copyright libnx Authors
##

import
  ../services/audren, ../result, audio

type
  AudioDriverEtc* = object
  AudioDriver* {.bycopy.} = object
    etc*: ptr AudioDriverEtc
    config*: AudioRendererConfig
    inMempools*: ptr AudioRendererMemPoolInfoIn
    inChannels*: ptr AudioRendererChannelInfoIn
    inVoices*: ptr AudioRendererVoiceInfoIn
    inMixes*: ptr AudioRendererMixInfoIn
    inSinks*: ptr AudioRendererSinkInfoIn


proc audrvCreate*(d: ptr AudioDriver; config: ptr AudioRendererConfig;
                 numFinalMixChannels: cint): Result {.cdecl, importc: "audrvCreate".}
proc audrvUpdate*(d: ptr AudioDriver): Result {.cdecl, importc: "audrvUpdate".}
proc audrvClose*(d: ptr AudioDriver) {.cdecl, importc: "audrvClose".}
## -----------------------------------------------------------------------------

proc audrvMemPoolAdd*(d: ptr AudioDriver; buffer: pointer; size: csize_t): cint {.cdecl,
    importc: "audrvMemPoolAdd".}
proc audrvMemPoolRemove*(d: ptr AudioDriver; id: cint): bool {.cdecl,
    importc: "audrvMemPoolRemove".}
proc audrvMemPoolAttach*(d: ptr AudioDriver; id: cint): bool {.cdecl,
    importc: "audrvMemPoolAttach".}
proc audrvMemPoolDetach*(d: ptr AudioDriver; id: cint): bool {.cdecl,
    importc: "audrvMemPoolDetach".}
## -----------------------------------------------------------------------------

type
  AudioDriverWaveBufState* = enum
    AudioDriverWaveBufStateFree, AudioDriverWaveBufStateWaiting,
    AudioDriverWaveBufStateQueued, AudioDriverWaveBufStatePlaying,
    AudioDriverWaveBufStateDone


type
  INNER_C_UNION_driver_0* {.bycopy, union.} = object
    dataPcm16*: ptr S16
    dataAdpcm*: ptr U8
    dataRaw*: pointer

  AudioDriverWaveBuf* {.bycopy.} = object
    anoDriver1*: INNER_C_UNION_driver_0
    size*: U64
    startSampleOffset*: S32
    endSampleOffset*: S32
    contextAddr*: pointer
    contextSz*: U64
    state* {.bitsize: 8.}: AudioDriverWaveBufState
    isLooping*: bool
    sequenceId*: U32
    next*: ptr AudioDriverWaveBuf


proc audrvVoiceInit*(d: ptr AudioDriver; id: cint; numChannels: cint; format: PcmFormat;
                    sampleRate: cint): bool {.cdecl, importc: "audrvVoiceInit".}
proc audrvVoiceDrop*(d: ptr AudioDriver; id: cint) {.cdecl, importc: "audrvVoiceDrop".}
proc audrvVoiceStop*(d: ptr AudioDriver; id: cint) {.cdecl, importc: "audrvVoiceStop".}
proc audrvVoiceIsPaused*(d: ptr AudioDriver; id: cint): bool {.cdecl,
    importc: "audrvVoiceIsPaused".}
proc audrvVoiceIsPlaying*(d: ptr AudioDriver; id: cint): bool {.cdecl,
    importc: "audrvVoiceIsPlaying".}
proc audrvVoiceAddWaveBuf*(d: ptr AudioDriver; id: cint;
                          wavebuf: ptr AudioDriverWaveBuf): bool {.cdecl,
    importc: "audrvVoiceAddWaveBuf".}
proc audrvVoiceGetWaveBufSeq*(d: ptr AudioDriver; id: cint): U32 {.cdecl,
    importc: "audrvVoiceGetWaveBufSeq".}
proc audrvVoiceGetPlayedSampleCount*(d: ptr AudioDriver; id: cint): U32 {.cdecl,
    importc: "audrvVoiceGetPlayedSampleCount".}
proc audrvVoiceGetVoiceDropsCount*(d: ptr AudioDriver; id: cint): U32 {.cdecl,
    importc: "audrvVoiceGetVoiceDropsCount".}
proc audrvVoiceSetBiquadFilter*(d: ptr AudioDriver; id: cint; biquadId: cint;
                               a0: cfloat; a1: cfloat; a2: cfloat; b0: cfloat;
                               b1: cfloat; b2: cfloat) {.cdecl,
    importc: "audrvVoiceSetBiquadFilter".}
proc audrvVoiceSetExtraParams*(d: ptr AudioDriver; id: cint; params: pointer;
                              paramsSize: csize_t) {.inline, cdecl.} =
  d.inVoices[id].extraParamsPtr = params
  d.inVoices[id].extraParamsSz = paramsSize

proc audrvVoiceSetDestinationMix*(d: ptr AudioDriver; id: cint; mixId: cint) {.inline, cdecl.} =
  d.inVoices[id].destMixId = mixId.U32
  d.inVoices[id].destSplitterId = Audren_Unused_Splitter_Id.U32

proc audrvVoiceSetMixFactor*(d: ptr AudioDriver; id: cint; factor: cfloat;
                            srcChannelId: cint; destChannelId: cint) {.inline, cdecl.} =
  var channelId = d.inVoices[id].channelIds[srcChannelId]
  d.inChannels[channelId].mix[destChannelId] = factor

proc audrvVoiceSetVolume*(d: ptr AudioDriver; id: cint; volume: cfloat) {.inline, cdecl.} =
  d.inVoices[id].volume = volume

proc audrvVoiceSetPitch*(d: ptr AudioDriver; id: cint; pitch: cfloat) {.inline, cdecl.} =
  d.inVoices[id].pitch = pitch

proc audrvVoiceSetPriority*(d: ptr AudioDriver; id: cint; priority: cint) {.inline, cdecl.} =
  d.inVoices[id].priority = priority.U32

proc audrvVoiceClearBiquadFilter*(d: ptr AudioDriver; id: cint; biquadId: cint) {.
    inline, cdecl.} =
  d.inVoices[id].biquads[biquadId].enable = false

proc audrvVoiceSetPaused*(d: ptr AudioDriver; id: cint; paused: bool) {.inline, cdecl.} =
  d.inVoices[id].state = if paused: AudioRendererVoicePlayStatePaused else: AudioRendererVoicePlayStateStarted

proc audrvVoiceStart*(d: ptr AudioDriver; id: cint) {.inline, cdecl.} =
  audrvVoiceSetPaused(d, id, false)

## -----------------------------------------------------------------------------

proc audrvMixAdd*(d: ptr AudioDriver; sampleRate: cint; numChannels: cint): cint {.cdecl,
    importc: "audrvMixAdd".}
proc audrvMixRemove*(d: ptr AudioDriver; id: cint) {.cdecl, importc: "audrvMixRemove".}
proc audrvMixSetDestinationMix*(d: ptr AudioDriver; id: cint; mixId: cint) {.inline, cdecl.} =
  d.inMixes[id].destMixId = mixId.U32
  d.inMixes[id].destSplitterId = Audren_Unused_Splitter_Id.U32

proc audrvMixSetMixFactor*(d: ptr AudioDriver; id: cint; factor: cfloat;
                          srcChannelId: cint; destChannelId: cint) {.inline, cdecl.} =
  d.inMixes[id].mix[srcChannelId][destChannelId] = factor

proc audrvMixSetVolume*(d: ptr AudioDriver; id: cint; volume: cfloat) {.inline, cdecl.} =
  d.inMixes[id].volume = volume

## -----------------------------------------------------------------------------

proc audrvDeviceSinkAdd*(d: ptr AudioDriver; deviceName: cstring; numChannels: cint;
                        channelIds: ptr U8): cint {.cdecl,
    importc: "audrvDeviceSinkAdd".}
proc audrvSinkRemove*(d: ptr AudioDriver; id: cint) {.cdecl, importc: "audrvSinkRemove".}
