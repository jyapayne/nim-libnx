## *
##  @file auddev.h
##  @brief IAudioDevice IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../audio/audio, ../sf/service

## / Initialize IAudioDevice.

proc auddevInitialize*(): Result {.cdecl, importc: "auddevInitialize".}
## / Exit IAudioDevice.

proc auddevExit*() {.cdecl, importc: "auddevExit".}
## / Gets the Service object for IAudioDevice.

proc auddevGetServiceSession*(): ptr Service {.cdecl,
    importc: "auddevGetServiceSession".}
proc auddevListAudioDeviceName*(deviceNames: ptr AudioDeviceName; maxNames: S32;
                               totalNames: ptr S32): Result {.cdecl,
    importc: "auddevListAudioDeviceName".}
proc auddevSetAudioDeviceOutputVolume*(deviceName: ptr AudioDeviceName;
                                      volume: cfloat): Result {.cdecl,
    importc: "auddevSetAudioDeviceOutputVolume".}
proc auddevGetAudioDeviceOutputVolume*(deviceName: ptr AudioDeviceName;
                                      volume: ptr cfloat): Result {.cdecl,
    importc: "auddevGetAudioDeviceOutputVolume".}