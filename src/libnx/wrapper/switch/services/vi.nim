## *
##  @file vi.h
##  @brief Display (vi:*) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../sf/service

type
  ViDisplayName* {.bycopy.} = object
    data*: array[0x40, char]

  ViDisplay* {.bycopy.} = object
    displayId*: U64
    displayName*: ViDisplayName
    initialized*: bool

  ViLayer* {.bycopy.} = object
    layerId*: U64
    igbpBinderObjId*: U32
    initialized* {.bitsize: 1.}: bool
    strayLayer* {.bitsize: 1.}: bool

  ViServiceType* = enum
    ViServiceTypeDefault = -1, ViServiceTypeApplication = 0, ViServiceTypeSystem = 1,
    ViServiceTypeManager = 2


## / Used by viCreateLayer when CreateStrayLayer is used internally.

type
  ViLayerFlags* = enum
    ViLayerFlagsDefault = 0x1


## / Used with viSetLayerScalingMode.

type
  ViScalingMode* = enum
    ViScalingModeNone = 0x0, ViScalingModeFitToLayer = 0x2,
    ViScalingModePreserveAspectRatio = 0x4,

const ViScalingModeDefault* = ViScalingModeFitToLayer


## / Used with viSetDisplayPowerState.

type
  ViPowerState* = enum
    ViPowerStateOff = 0,        ## /< Screen is off.
    ViPowerStateNotScanning = 1, ## /< [3.0.0+] Screen is on, but not scanning content.
    ViPowerStateOn = 2          ## /< [3.0.0+] Screen is on.

const
  ViPowerStateOnDeprecated* = ViPowerStateNotScanning

## / Used as argument to many capture functions.

type
  ViLayerStack* = enum
    ViLayerStackDefault = 0,    ## /< Default layer stack, includes all layers.
    ViLayerStackLcd = 1,        ## /< Includes only layers for the LCD.
    ViLayerStackScreenshot = 2, ## /< Includes only layers for user screenshots.
    ViLayerStackRecording = 3,  ## /< Includes only layers for recording videos.
    ViLayerStackLastFrame = 4,  ## /< Includes only layers for the last applet-transition frame.
    ViLayerStackArbitrary = 5,  ## /< Captures some arbitrary layer. This is normally only for am.
    ViLayerStackApplicationForDebug = 6, ## /< Captures layers for the current application. This is normally used by creport/debugging tools.
    ViLayerStackNull = 10       ## /< Layer stack for the empty display.


proc viInitialize*(serviceType: ViServiceType): Result {.cdecl,
    importc: "viInitialize".}
proc viExit*() {.cdecl, importc: "viExit".}
proc viGetSessionIApplicationDisplayService*(): ptr Service {.cdecl,
    importc: "viGetSession_IApplicationDisplayService".}
proc viGetSessionIHOSBinderDriverRelay*(): ptr Service {.cdecl,
    importc: "viGetSession_IHOSBinderDriverRelay".}
proc viGetSessionISystemDisplayService*(): ptr Service {.cdecl,
    importc: "viGetSession_ISystemDisplayService".}
proc viGetSessionIManagerDisplayService*(): ptr Service {.cdecl,
    importc: "viGetSession_IManagerDisplayService".}
proc viGetSessionIHOSBinderDriverIndirect*(): ptr Service {.cdecl,
    importc: "viGetSession_IHOSBinderDriverIndirect".}

##  Misc functions

proc viSetContentVisibility*(v: bool): Result {.cdecl,
    importc: "viSetContentVisibility".}

##  Display functions

proc viOpenDisplay*(displayName: cstring; display: ptr ViDisplay): Result {.cdecl,
    importc: "viOpenDisplay".}
proc viCloseDisplay*(display: ptr ViDisplay): Result {.cdecl,
    importc: "viCloseDisplay".}
proc viOpenDefaultDisplay*(display: ptr ViDisplay): Result {.inline, cdecl.} =
  return viOpenDisplay("Default", display)

proc viGetDisplayResolution*(display: ptr ViDisplay; width: ptr S32; height: ptr S32): Result {.
    cdecl, importc: "viGetDisplayResolution".}
proc viGetDisplayLogicalResolution*(display: ptr ViDisplay; width: ptr S32;
                                   height: ptr S32): Result {.cdecl,
    importc: "viGetDisplayLogicalResolution".}

proc viSetDisplayMagnification*(display: ptr ViDisplay; x: S32; y: S32; width: S32;
                               height: S32): Result {.cdecl,
    importc: "viSetDisplayMagnification".}
## / Only available on [3.0.0+].
proc viGetDisplayVsyncEvent*(display: ptr ViDisplay; eventOut: ptr Event): Result {.
    cdecl, importc: "viGetDisplayVsyncEvent".}
proc viSetDisplayPowerState*(display: ptr ViDisplay; state: ViPowerState): Result {.
    cdecl, importc: "viSetDisplayPowerState".}
proc viSetDisplayAlpha*(display: ptr ViDisplay; alpha: cfloat): Result {.cdecl,
    importc: "viSetDisplayAlpha".}
proc viGetZOrderCountMin*(display: ptr ViDisplay; z: ptr S32): Result {.cdecl,
    importc: "viGetZOrderCountMin".}
proc viGetZOrderCountMax*(display: ptr ViDisplay; z: ptr S32): Result {.cdecl,
    importc: "viGetZOrderCountMax".}

##  Layer functions

proc viCreateLayer*(display: ptr ViDisplay; layer: ptr ViLayer): Result {.cdecl,
    importc: "viCreateLayer".}
proc viCreateManagedLayer*(display: ptr ViDisplay; layerFlags: ViLayerFlags;
                          aruid: U64; layerId: ptr U64): Result {.cdecl,
    importc: "viCreateManagedLayer".}
proc viSetLayerSize*(layer: ptr ViLayer; width: S32; height: S32): Result {.cdecl,
    importc: "viSetLayerSize".}
proc viSetLayerZ*(layer: ptr ViLayer; z: S32): Result {.cdecl, importc: "viSetLayerZ".}
proc viSetLayerPosition*(layer: ptr ViLayer; x: cfloat; y: cfloat): Result {.cdecl,
    importc: "viSetLayerPosition".}
proc viCloseLayer*(layer: ptr ViLayer): Result {.cdecl, importc: "viCloseLayer".}
proc viDestroyManagedLayer*(layer: ptr ViLayer): Result {.cdecl,
    importc: "viDestroyManagedLayer".}
proc viSetLayerScalingMode*(layer: ptr ViLayer; scalingMode: ViScalingMode): Result {.
    cdecl, importc: "viSetLayerScalingMode".}

##  IndirectLayer functions

proc viGetIndirectLayerImageMap*(buffer: pointer; size: csize_t; width: S32;
                                height: S32; indirectLayerConsumerHandle: U64;
                                outSize: ptr U64; outStride: ptr U64): Result {.cdecl,
    importc: "viGetIndirectLayerImageMap".}
proc viGetIndirectLayerImageRequiredMemoryInfo*(width: S32; height: S32;
    outSize: ptr U64; outAlignment: ptr U64): Result {.cdecl,
    importc: "viGetIndirectLayerImageRequiredMemoryInfo".}
