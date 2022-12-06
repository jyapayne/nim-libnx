## *
##  @file audctl.h
##  @brief Audio Control IPC wrapper.
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../kernel/event

type
  AudioTarget* = enum
    AudioTargetInvalid = 0, AudioTargetSpeaker = 1, AudioTargetHeadphone = 2,
    AudioTargetTv = 3, AudioTargetUsbOutputDevice = 4
  AudioOutputMode* = enum
    AudioOutputModeInvalid = 0, AudioOutputModePcm1ch = 1, AudioOutputModePcm2ch = 2,
    AudioOutputModePcm6ch = 3, AudioOutputModePcmAuto = 4
  AudioForceMutePolicy* = enum
    AudioForceMutePolicyDisable = 0,
    AudioForceMutePolicySpeakerMuteOnHeadphoneUnplugged = 1
  AudioHeadphoneOutputLevelMode* = enum
    AudioHeadphoneOutputLevelModeNormal = 0,
    AudioHeadphoneOutputLevelModeHighPower = 1





proc audctlInitialize*(): Result {.cdecl, importc: "audctlInitialize".}
proc audctlExit*() {.cdecl, importc: "audctlExit".}
proc audctlGetServiceSession*(): ptr Service {.cdecl,
    importc: "audctlGetServiceSession".}
proc audctlGetTargetVolume*(volumeOut: ptr cfloat; target: AudioTarget): Result {.
    cdecl, importc: "audctlGetTargetVolume".}
proc audctlSetTargetVolume*(target: AudioTarget; volume: cfloat): Result {.cdecl,
    importc: "audctlSetTargetVolume".}
proc audctlGetTargetVolumeMin*(volumeOut: ptr cfloat): Result {.cdecl,
    importc: "audctlGetTargetVolumeMin".}
proc audctlGetTargetVolumeMax*(volumeOut: ptr cfloat): Result {.cdecl,
    importc: "audctlGetTargetVolumeMax".}
proc audctlIsTargetMute*(muteOut: ptr bool; target: AudioTarget): Result {.cdecl,
    importc: "audctlIsTargetMute".}
proc audctlSetTargetMute*(target: AudioTarget; mute: bool): Result {.cdecl,
    importc: "audctlSetTargetMute".}
proc audctlIsTargetConnected*(connectedOut: ptr bool; target: AudioTarget): Result {.
    cdecl, importc: "audctlIsTargetConnected".}
proc audctlSetDefaultTarget*(target: AudioTarget; fadeInNs: U64; fadeOutNs: U64): Result {.
    cdecl, importc: "audctlSetDefaultTarget".}
proc audctlGetDefaultTarget*(targetOut: ptr AudioTarget): Result {.cdecl,
    importc: "audctlGetDefaultTarget".}
proc audctlGetAudioOutputMode*(modeOut: ptr AudioOutputMode; target: AudioTarget): Result {.
    cdecl, importc: "audctlGetAudioOutputMode".}
proc audctlSetAudioOutputMode*(target: AudioTarget; mode: AudioOutputMode): Result {.
    cdecl, importc: "audctlSetAudioOutputMode".}
proc audctlSetForceMutePolicy*(policy: AudioForceMutePolicy): Result {.cdecl,
    importc: "audctlSetForceMutePolicy".}
proc audctlGetForceMutePolicy*(policyOut: ptr AudioForceMutePolicy): Result {.cdecl,
    importc: "audctlGetForceMutePolicy".}
proc audctlGetOutputModeSetting*(modeOut: ptr AudioOutputMode; target: AudioTarget): Result {.
    cdecl, importc: "audctlGetOutputModeSetting".}
proc audctlSetOutputModeSetting*(target: AudioTarget; mode: AudioOutputMode): Result {.
    cdecl, importc: "audctlSetOutputModeSetting".}
proc audctlSetOutputTarget*(target: AudioTarget): Result {.cdecl,
    importc: "audctlSetOutputTarget".}
proc audctlSetInputTargetForceEnabled*(enable: bool): Result {.cdecl,
    importc: "audctlSetInputTargetForceEnabled".}
proc audctlSetHeadphoneOutputLevelMode*(mode: AudioHeadphoneOutputLevelMode): Result {.
    cdecl, importc: "audctlSetHeadphoneOutputLevelMode".}
## /< [3.0.0+]

proc audctlGetHeadphoneOutputLevelMode*(modeOut: ptr AudioHeadphoneOutputLevelMode): Result {.
    cdecl, importc: "audctlGetHeadphoneOutputLevelMode".}
## /< [3.0.0+]

proc audctlAcquireAudioVolumeUpdateEventForPlayReport*(eventOut: ptr Event): Result {.
    cdecl, importc: "audctlAcquireAudioVolumeUpdateEventForPlayReport".}
## /< [3.0.0+]

proc audctlAcquireAudioOutputDeviceUpdateEventForPlayReport*(eventOut: ptr Event): Result {.
    cdecl, importc: "audctlAcquireAudioOutputDeviceUpdateEventForPlayReport".}
## /< [3.0.0+]

proc audctlGetAudioOutputTargetForPlayReport*(targetOut: ptr AudioTarget): Result {.
    cdecl, importc: "audctlGetAudioOutputTargetForPlayReport".}
## /< [3.0.0+]

proc audctlNotifyHeadphoneVolumeWarningDisplayedEvent*(): Result {.cdecl,
    importc: "audctlNotifyHeadphoneVolumeWarningDisplayedEvent".}
## /< [3.0.0+]

proc audctlSetSystemOutputMasterVolume*(volume: cfloat): Result {.cdecl,
    importc: "audctlSetSystemOutputMasterVolume".}
## /< [4.0.0+]

proc audctlGetSystemOutputMasterVolume*(volumeOut: ptr cfloat): Result {.cdecl,
    importc: "audctlGetSystemOutputMasterVolume".}
## /< [4.0.0+]
