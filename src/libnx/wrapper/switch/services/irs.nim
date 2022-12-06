## *
##  @file irs.h
##  @brief HID IR sensor (irs) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/hid

const
  IRS_MAX_CAMERAS* = 0x9

## / IrCameraStatus

type
  IrsIrCameraStatus* = enum
    IrsIrCameraStatusAvailable = 0, ## /< Available
    IrsIrCameraStatusUnsupported = 1, ## /< Unsupported
    IrsIrCameraStatusUnconnected = 2 ## /< Unconnected


## / IrCameraInternalStatus

type
  IrsIrCameraInternalStatus* = enum
    IrsIrCameraInternalStatusStopped = 0, ## /< Stopped
    IrsIrCameraInternalStatusFirmwareUpdateNeeded = 1, ## /< FirmwareUpdateNeeded
    IrsIrCameraInternalStatusUnknown2 = 2, ## /< Unknown
    IrsIrCameraInternalStatusUnknown3 = 3, ## /< Unknown
    IrsIrCameraInternalStatusUnknown4 = 4, ## /< Unknown
    IrsIrCameraInternalStatusFirmwareVersionRequested = 5, ## /< FirmwareVersionRequested
    IrsIrCameraInternalStatusFirmwareVersionIsInvalid = 6, ## /< FirmwareVersionIsInvalid
    IrsIrCameraInternalStatusReady = 7, ## /< [4.0.0+] Ready
    IrsIrCameraInternalStatusSetting = 8 ## /< [4.0.0+] Setting


## / IrSensorMode

type
  IrsIrSensorMode* = enum
    IrsIrSensorModeNone = 0,    ## /< None
    IrsIrSensorModeMomentProcessor = 1, ## /< MomentProcessor
    IrsIrSensorModeClusteringProcessor = 2, ## /< ClusteringProcessor
    IrsIrSensorModeImageTransferProcessor = 3, ## /< ImageTransferProcessor
    IrsIrSensorModePointingProcessor = 4, ## /< PointingProcessor
    IrsIrSensorModeTeraPluginProcessor = 5, ## /< TeraPluginProcessor
    IrsIrSensorModeIrLedProcessor = 6 ## /< IrLedProcessor (doesn't apply to IrsDeviceFormat::ir_sensor_mode)


## / ImageProcessorStatus

type
  IrsImageProcessorStatus* = enum
    IrsImageProcessorStatusStopped = 0, ## /< Stopped
    IrsImageProcessorStatusRunning = 1 ## /< Running


## / ImageTransferProcessorFormat. IR Sensor image resolution.

type
  IrsImageTransferProcessorFormat* = enum
    IrsImageTransferProcessorFormat320x240 = 0, ## /< 320x240
    IrsImageTransferProcessorFormat160x120 = 1, ## /< 160x120
    IrsImageTransferProcessorFormat80x60 = 2, ## /< 80x60
    IrsImageTransferProcessorFormat40x30 = 3, ## /< [4.0.0+] 40x30
    IrsImageTransferProcessorFormat20x15 = 4 ## /< [4.0.0+] 20x15


## / AdaptiveClusteringMode

type
  IrsAdaptiveClusteringMode* = enum
    IrsAdaptiveClusteringModeStaticFov = 0, ## /< StaticFov
    IrsAdaptiveClusteringModeDynamicFov = 1 ## /< DynamicFov


## / AdaptiveClusteringTargetDistance

type
  IrsAdaptiveClusteringTargetDistance* = enum
    IrsAdaptiveClusteringTargetDistanceNear = 0, ## /< Near
    IrsAdaptiveClusteringTargetDistanceMiddle = 1, ## /< Middle
    IrsAdaptiveClusteringTargetDistanceFar = 2 ## /< Far


## / HandAnalysisMode

type
  IrsHandAnalysisMode* = enum
    IrsHandAnalysisModeSilhouette = 1, ## /< Silhouette
    IrsHandAnalysisModeImage = 2, ## /< Image
    IrsHandAnalysisModeSilhouetteAndImage = 3, ## /< SilhouetteAndImage
    IrsHandAnalysisModeSilhouetteOnly = 4 ## /< [4.0.0+] SilhouetteOnly


## / Internal validation callblack.

type
  IrsValidationCb* = proc (userdata: pointer; arg: pointer): bool {.cdecl.}

## / IrCameraHandle

type
  IrsIrCameraHandle* {.bycopy.} = object
    playerNumber*: U8          ## /< PlayerNumber
    deviceType*: U8            ## /< DeviceType
    reserved*: array[0x2, U8]   ## /< Reserved


## / PackedMcuVersion

type
  IrsPackedMcuVersion* {.bycopy.} = object
    majorVersion*: U16         ## /< MajorVersion
    minorVersion*: U16         ## /< MinorVersion


## / PackedFunctionLevel

type
  IrsPackedFunctionLevel* {.bycopy.} = object
    irSensorFunctionLevel*: U8 ## /< IrSensorFunctionLevel
    reserved*: array[0x3, U8]   ## /< Reserved


## / Rect

type
  IrsRect* {.bycopy.} = object
    x*: S16                    ## /< X
    y*: S16                    ## /< Y
    width*: S16                ## /< Width
    height*: S16               ## /< Height


## / IrsMomentProcessorConfig

type
  IrsMomentProcessorConfig* {.bycopy.} = object
    exposureTime*: U64         ## /< IR Sensor exposure time in nanoseconds.
    lightTarget*: U32          ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.
    gain*: U32                 ## /< IR sensor signal's digital gain.
    isNegativeImageUsed*: U8   ## /< Inverts the colors of the captured image. 0: Normal image, 1: Negative image.
    reserved*: array[0x7, U8]   ## /< Reserved.
    windowOfInterest*: IrsRect ## /< WindowOfInterest
    preprocess*: U32           ## /< Preprocess
    preprocessIntensityThreshold*: U32 ## /< PreprocessIntensityThreshold


## / PackedMomentProcessorConfig

type
  IrsPackedMomentProcessorConfig* {.bycopy.} = object
    exposureTime*: U64         ## /< IR Sensor exposure time in nanoseconds.
    lightTarget*: U8           ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.
    gain*: U8                  ## /< IR sensor signal's digital gain.
    isNegativeImageUsed*: U8   ## /< Inverts the colors of the captured image. 0: Normal image, 1: Negative image.
    reserved*: array[0x5, U8]   ## /< Reserved.
    windowOfInterest*: IrsRect ## /< WindowOfInterest
    requiredMcuVersion*: IrsPackedMcuVersion ## /< RequiredMcuVersion
    preprocess*: U8            ## /< Preprocess
    preprocessIntensityThreshold*: U8 ## /< PreprocessIntensityThreshold
    reserved2*: array[0x2, U8]  ## /< Reserved.


## / ClusteringProcessorConfig

type
  IrsClusteringProcessorConfig* {.bycopy.} = object
    exposureTime*: U64         ## /< IR Sensor exposure time in nanoseconds.
    lightTarget*: U32          ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.
    gain*: U32                 ## /< IR sensor signal's digital gain.
    isNegativeImageUsed*: U8   ## /< Inverts the colors of the captured image. 0: Normal image, 1: Negative image.
    reserved*: array[0x7, U8]   ## /< Reserved.
    windowOfInterest*: IrsRect ## /< WindowOfInterest
    objectPixelCountMin*: U32  ## /< ObjectPixelCountMin
    objectPixelCountMax*: U32  ## /< ObjectPixelCountMax
    objectIntensityMin*: U32   ## /< ObjectIntensityMin
    isExternalLightFilterEnabled*: U8 ## /< IsExternalLightFilterEnabled


## / PackedClusteringProcessorConfig

type
  IrsPackedClusteringProcessorConfig* {.bycopy.} = object
    exposureTime*: U64         ## /< IR Sensor exposure time in nanoseconds.
    lightTarget*: U8           ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.
    gain*: U8                  ## /< IR sensor signal's digital gain.
    isNegativeImageUsed*: U8   ## /< Inverts the colors of the captured image. 0: Normal image, 1: Negative image.
    reserved*: array[0x5, U8]   ## /< Reserved.
    windowOfInterest*: IrsRect ## /< WindowOfInterest
    requiredMcuVersion*: IrsPackedMcuVersion ## /< RequiredMcuVersion
    objectPixelCountMin*: U32  ## /< ObjectPixelCountMin
    objectPixelCountMax*: U32  ## /< ObjectPixelCountMax
    objectIntensityMin*: U8    ## /< ObjectIntensityMin
    isExternalLightFilterEnabled*: U8 ## /< IsExternalLightFilterEnabled
    reserved2*: array[0x2, U8]  ## /< Reserved.


## / ImageTransferProcessorConfig

type
  IrsImageTransferProcessorConfig* {.bycopy.} = object
    exposureTime*: U64         ## /< IR Sensor exposure time in nanoseconds.
    lightTarget*: U32          ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.
    gain*: U32                 ## /< IR sensor signal's digital gain.
    isNegativeImageUsed*: U8   ## /< Inverts the colors of the captured image. 0: Normal image, 1: Negative image.
    reserved*: array[0x7, U8]   ## /< Reserved.
    format*: U32               ## /< \ref IrsImageTransferProcessorFormat


## / ImageTransferProcessorExConfig

type
  IrsImageTransferProcessorExConfig* {.bycopy.} = object
    exposureTime*: U64         ## /< IR Sensor exposure time in nanoseconds.
    lightTarget*: U32          ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.
    gain*: U32                 ## /< IR sensor signal's digital gain.
    isNegativeImageUsed*: U8   ## /< Inverts the colors of the captured image. 0: Normal image, 1: Negative image.
    reserved*: array[0x7, U8]   ## /< Reserved.
    origFormat*: U32           ## /< OrigFormat \ref IrsImageTransferProcessorFormat
    trimmingFormat*: U32       ## /< TrimmingFormat \ref IrsImageTransferProcessorFormat
    trimmingStartX*: U16       ## /< TrimmingStartX
    trimmingStartY*: U16       ## /< TrimmingStartY
    isExternalLightFilterEnabled*: U8 ## /< IsExternalLightFilterEnabled


## / PackedImageTransferProcessorConfig

type
  IrsPackedImageTransferProcessorConfig* {.bycopy.} = object
    exposureTime*: U64         ## /< IR Sensor exposure time in nanoseconds.
    lightTarget*: U8           ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.
    gain*: U8                  ## /< IR sensor signal's digital gain.
    isNegativeImageUsed*: U8   ## /< Inverts the colors of the captured image. 0: Normal image, 1: Negative image.
    reserved*: array[0x5, U8]   ## /< Reserved.
    requiredMcuVersion*: IrsPackedMcuVersion ## /< RequiredMcuVersion
    format*: U8                ## /< \ref IrsImageTransferProcessorFormat
    reserved2*: array[0x3, U8]  ## /< Reserved.


## / PackedImageTransferProcessorExConfig

type
  IrsPackedImageTransferProcessorExConfig* {.bycopy.} = object
    exposureTime*: U64         ## /< IR Sensor exposure time in nanoseconds.
    lightTarget*: U8           ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.
    gain*: U8                  ## /< IR sensor signal's digital gain.
    isNegativeImageUsed*: U8   ## /< Inverts the colors of the captured image. 0: Normal image, 1: Negative image.
    reserved*: array[0x5, U8]   ## /< Reserved.
    requiredMcuVersion*: IrsPackedMcuVersion ## /< RequiredMcuVersion
    origFormat*: U8            ## /< OrigFormat \ref IrsImageTransferProcessorFormat
    trimmingFormat*: U8        ## /< TrimmingFormat \ref IrsImageTransferProcessorFormat
    trimmingStartX*: U16       ## /< TrimmingStartX
    trimmingStartY*: U16       ## /< TrimmingStartY
    isExternalLightFilterEnabled*: U8 ## /< IsExternalLightFilterEnabled
    reserved2*: array[0x5, U8]  ## /< Reserved.


## / ImageTransferProcessorState

type
  IrsImageTransferProcessorState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    ambientNoiseLevel*: U32    ## /< AmbientNoiseLevel
    reserved*: array[0x4, U8]   ## /< Reserved


## / PackedPointingProcessorConfig

type
  IrsPackedPointingProcessorConfig* {.bycopy.} = object
    windowOfInterest*: IrsRect ## /< WindowOfInterest
    requiredMcuVersion*: IrsPackedMcuVersion ## /< RequiredMcuVersion


## / TeraPluginProcessorConfig

type
  IrsTeraPluginProcessorConfig* {.bycopy.} = object
    mode*: U8                  ## /< Mode
    unkX1*: U8                 ## /< [6.0.0+] Unknown
    unkX2*: U8                 ## /< [6.0.0+] Unknown
    unkX3*: U8                 ## /< [6.0.0+] Unknown


## / PackedTeraPluginProcessorConfig

type
  IrsPackedTeraPluginProcessorConfig* {.bycopy.} = object
    requiredMcuVersion*: IrsPackedMcuVersion ## /< RequiredMcuVersion
    mode*: U8                  ## /< Mode
    unkX5*: U8                 ## /< [6.0.0+] This is set to 0x2 | (IrsTeraPluginProcessorConfig::unk_x1 << 7).
    unkX6*: U8                 ## /< [6.0.0+] IrsTeraPluginProcessorConfig::unk_x2
    unkX7*: U8                 ## /< [6.0.0+] IrsTeraPluginProcessorConfig::unk_x3


## / IrLedProcessorConfig

type
  IrsIrLedProcessorConfig* {.bycopy.} = object
    lightTarget*: U32          ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.


## / PackedIrLedProcessorConfig

type
  IrsPackedIrLedProcessorConfig* {.bycopy.} = object
    requiredMcuVersion*: IrsPackedMcuVersion ## /< RequiredMcuVersion
    lightTarget*: U8           ## /< Controls the IR leds. 0: All leds, 1: Bright group, 2: Dim group, 3: None.
    pad*: array[0x3, U8]        ## /< Padding


## / AdaptiveClusteringProcessorConfig

type
  IrsAdaptiveClusteringProcessorConfig* {.bycopy.} = object
    mode*: U32                 ## /< \ref IrsAdaptiveClusteringMode
    targetDistance*: U32       ## /< [6.0.0+] \ref IrsAdaptiveClusteringTargetDistance


## / HandAnalysisConfig

type
  IrsHandAnalysisConfig* {.bycopy.} = object
    mode*: U32                 ## /< \ref IrsHandAnalysisMode


## / MomentStatistic

type
  IrsMomentStatistic* {.bycopy.} = object
    averageIntensity*: cfloat  ## /< AverageIntensity
    centroidX*: cfloat         ## /< CentroidX
    centroidY*: cfloat         ## /< CentroidY


## / MomentProcessorState

type
  IrsMomentProcessorState* {.bycopy.} = object
    samplingNumber*: S64       ## /< SamplingNumber
    timestamp*: U64            ## /< TimeStamp
    ambientNoiseLevel*: U32    ## /< AmbientNoiseLevel
    reserved*: array[0x4, U8]   ## /< Reserved
    statistic*: array[0x30, IrsMomentStatistic] ## /< \ref IrsMomentStatistic


## / ClusteringData

type
  IrsClusteringData* {.bycopy.} = object
    averageIntensity*: cfloat  ## /< AverageIntensity
    centroidX*: cfloat         ## /< CentroidX
    centroidY*: cfloat         ## /< CentroidY
    pixelCount*: U32           ## /< PixelCount
    boundX*: U16               ## /< BoundX
    boundY*: U16               ## /< BoundY
    boundtWidth*: U16          ## /< BoundtWidth
    boundHeight*: U16          ## /< BoundHeight


## / ClusteringProcessorState

type
  IrsClusteringProcessorState* {.bycopy.} = object
    samplingNumber*: S64       ## /< SamplingNumber
    timestamp*: U64            ## /< TimeStamp
    objectCount*: U8           ## /< ObjectCount
    reserved*: array[0x3, U8]   ## /< Reserved
    ambientNoiseLevel*: U32    ## /< AmbientNoiseLevel
    data*: array[0x10, IrsClusteringData] ## /< \ref IrsClusteringData


## / PointingProcessorMarkerState

type
  INNER_C_STRUCT_irs_1* {.bycopy.} = object
    pointingStatus*: U8        ## /< PointingStatus
    reserved*: array[0x3, U8]   ## /< Reserved
    unkX4*: array[0x4, U8]      ## /< Unknown
    unkX8*: cfloat             ## /< Unknown
    positionX*: cfloat         ## /< PositionX
    positionY*: cfloat         ## /< PositionY
    unkX14*: cfloat            ## /< Unknown
    windowOfInterest*: IrsRect ## /< WindowOfInterest

  IrsPointingProcessorMarkerState* {.bycopy.} = object
    samplingNumber*: S64       ## /< SamplingNumber
    timestamp*: U64            ## /< TimeStamp
    data*: array[3, INNER_C_STRUCT_irs_1]


## / PointingProcessorState

type
  IrsPointingProcessorState* {.bycopy.} = object
    samplingNumber*: S64       ## /< SamplingNumber
    timestamp*: U64            ## /< TimeStamp
    pointingStatus*: U32       ## /< PointingStatus
    positionX*: cfloat         ## /< PositionX
    positionY*: cfloat         ## /< PositionY
    reserved*: array[0x4, U8]   ## /< Reserved


## / TeraPluginProcessorState

type
  IrsTeraPluginProcessorState* {.bycopy.} = object
    samplingNumber*: S64       ## /< SamplingNumber
    timestamp*: U64            ## /< TimeStamp
    ambientNoiseLevel*: U32    ## /< AmbientNoiseLevel
    pluginData*: array[0x12c, U8] ## /< PluginData


## / ProcessorState

type
  IrsProcessorState* {.bycopy.} = object
    start*: S64                ## /< Start
    count*: U32                ## /< Count
    pad*: U32                  ## /< Padding
    data*: array[0xe10, U8]     ## /< Contains an array of *ProcessorState, depending on IrsDeviceFormat::ir_sensor_mode.


## / DeviceFormat

type
  IrsDeviceFormat* {.bycopy.} = object
    irCameraStatus*: U32       ## /< \ref IrsIrCameraStatus
    irCameraInternalStatus*: U32 ## /< \ref IrsIrCameraInternalStatus
    irSensorMode*: U32         ## /< \ref IrsIrSensorMode
    pad*: U32                  ## /< Padding
    processorState*: IrsProcessorState ## /< \ref IrsProcessorState


## / AruidFormat

type
  IrsAruidFormat* {.bycopy.} = object
    irSensorAruid*: U64        ## /< IrSensorAruid
    irSensorAruidStatus*: U32  ## /< IrSensorAruidStatus
    pad*: U32                  ## /< Padding


## / StatusManager

type
  IrsStatusManager* {.bycopy.} = object
    deviceFormat*: array[Irs_Max_Cameras, IrsDeviceFormat]
    aruidFormat*: array[0x5, IrsAruidFormat]

proc irsInitialize*(): Result {.cdecl, importc: "irsInitialize".}
## / Initialize irs.

proc irsExit*() {.cdecl, importc: "irsExit".}
## / Exit irs.

proc irsGetServiceSession*(): ptr Service {.cdecl, importc: "irsGetServiceSession".}
## / Gets the Service object for the actual irs service session.

proc irsGetSharedmemAddr*(): pointer {.cdecl, importc: "irsGetSharedmemAddr".}
## / Gets the address of the SharedMemory (\ref IrsStatusManager).

proc irsGetIrCameraHandle*(handle: ptr IrsIrCameraHandle; id: HidNpadIdType): Result {.
    cdecl, importc: "irsGetIrCameraHandle".}
## / Gets the \ref IrsIrCameraHandle for the specified controller.

proc irsGetIrCameraStatus*(handle: IrsIrCameraHandle; `out`: ptr IrsIrCameraStatus): Result {.
    cdecl, importc: "irsGetIrCameraStatus".}
## / GetIrCameraStatus

proc irsCheckFirmwareUpdateNecessity*(handle: IrsIrCameraHandle; `out`: ptr bool): Result {.
    cdecl, importc: "irsCheckFirmwareUpdateNecessity".}
## / CheckFirmwareUpdateNecessity
## / When successful where the output flag is set, the user should use \ref hidLaShowControllerFirmwareUpdate.
## / Only available on [4.0.0+].

proc irsGetImageProcessorStatus*(handle: IrsIrCameraHandle;
                                `out`: ptr IrsImageProcessorStatus): Result {.cdecl,
    importc: "irsGetImageProcessorStatus".}
## / GetImageProcessorStatus
## / Only available on [4.0.0+].

proc irsStopImageProcessor*(handle: IrsIrCameraHandle): Result {.cdecl,
    importc: "irsStopImageProcessor".}
## / Stop the current Processor.
## / \ref irsExit calls this with all IrCameraHandles which were not already used with \ref irsStopImageProcessor.

proc irsStopImageProcessorAsync*(handle: IrsIrCameraHandle): Result {.cdecl,
    importc: "irsStopImageProcessorAsync".}
## / Stop the current Processor, async.
## / Only available on [4.0.0+].

proc irsRunMomentProcessor*(handle: IrsIrCameraHandle;
                           config: ptr IrsMomentProcessorConfig): Result {.cdecl,
    importc: "irsRunMomentProcessor".}
## *
##  @brief Run the MomentProcessor.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[in] config Input config.
##

proc irsGetMomentProcessorStates*(handle: IrsIrCameraHandle;
                                 states: ptr IrsMomentProcessorState; count: S32;
                                 totalOut: ptr S32): Result {.cdecl,
    importc: "irsGetMomentProcessorStates".}
## *
##  @brief Gets the states for MomentProcessor or IrLedProcessor.
##  @note The official GetIrLedProcessorState is essentially the same as this, except it uses hard-coded count=1 with output-array on stack, without returning that data. Hence we don't implement a seperate func for that.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[out] states Output array of \ref IrsMomentProcessorState.
##  @param[in] count Size of the states array in entries. Must be 1-5.
##  @param[out] total_out Total output entries.
##

proc irsCalculateMomentRegionStatistic*(state: ptr IrsMomentProcessorState;
                                       rect: IrsRect; regionX: S32; regionY: S32;
                                       regionWidth: S32; regionHeight: S32): IrsMomentStatistic {.
    cdecl, importc: "irsCalculateMomentRegionStatistic".}
## *
##  @brief Calculates an \ref IrsMomentStatistic from the specified region in the input \ref IrsMomentProcessorState.
##  @param[in] state \ref IrsMomentProcessorState
##  @param[in] rect \ref IrsRect, containing the image width and height.
##  @param[in] region_x Region x, must be 0-5 (clamped to this range otherwise). region_x = image_x/6.
##  @param[in] region_y Region y, must be 0-7 (clamped to this range otherwise). region_y = image_y/8.
##  @param[in] region_width Region width. region_x+region_width must be <=6 (clamped to this range otherwise).
##  @param[in] region_height Region height.  region_y+region_height must be <=8 (clamped to this range otherwise).
##

proc irsRunClusteringProcessor*(handle: IrsIrCameraHandle;
                               config: ptr IrsClusteringProcessorConfig): Result {.
    cdecl, importc: "irsRunClusteringProcessor".}
## *
##  @brief Run the ClusteringProcessor.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[in] config Input config.
##

proc irsGetClusteringProcessorStates*(handle: IrsIrCameraHandle;
                                     states: ptr IrsClusteringProcessorState;
                                     count: S32; totalOut: ptr S32): Result {.cdecl,
    importc: "irsGetClusteringProcessorStates".}
## *
##  @brief Gets the states for ClusteringProcessor.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[out] states Output array of \ref IrsClusteringProcessorState.
##  @param[in] count Size of the states array in entries. Must be 1-5.
##  @param[out] total_out Total output entries.
##

proc irsRunImageTransferProcessor*(handle: IrsIrCameraHandle;
                                  config: ptr IrsImageTransferProcessorConfig;
                                  size: csize_t): Result {.cdecl,
    importc: "irsRunImageTransferProcessor".}
## *
##  @brief Run the ImageTransferProcessor.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[in] config Input config.
##  @param[in] size Work-buffer size, must be 0x1000-byte aligned.
##

proc irsRunImageTransferExProcessor*(handle: IrsIrCameraHandle; config: ptr IrsImageTransferProcessorExConfig;
                                    size: csize_t): Result {.cdecl,
    importc: "irsRunImageTransferExProcessor".}
## *
##  @brief Run the ImageTransferExProcessor.
##  @note Only available on [4.0.0+].
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[in] config Input config.
##  @param[in] size Work-buffer size, must be 0x1000-byte aligned.
##

proc irsGetImageTransferProcessorState*(handle: IrsIrCameraHandle; buffer: pointer;
                                       size: csize_t; state: ptr IrsImageTransferProcessorState): Result {.
    cdecl, importc: "irsGetImageTransferProcessorState".}
## / GetImageTransferProcessorState

proc irsRunPointingProcessor*(handle: IrsIrCameraHandle): Result {.cdecl,
    importc: "irsRunPointingProcessor".}
## *
##  @brief Run the PointingProcessor.
##  @param[in] handle \ref IrsIrCameraHandle
##

proc irsGetPointingProcessorMarkerStates*(handle: IrsIrCameraHandle;
    states: ptr IrsPointingProcessorMarkerState; count: S32; totalOut: ptr S32): Result {.
    cdecl, importc: "irsGetPointingProcessorMarkerStates".}
## *
##  @brief Gets the states for PointingProcessor.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[out] states Output array of \ref IrsPointingProcessorMarkerState.
##  @param[in] count Size of the states array in entries. Must be 1-6.
##  @param[out] total_out Total output entries.
##

proc irsGetPointingProcessorStates*(handle: IrsIrCameraHandle;
                                   states: ptr IrsPointingProcessorState;
                                   count: S32; totalOut: ptr S32): Result {.cdecl,
    importc: "irsGetPointingProcessorStates".}
## *
##  @brief Gets the states for \ref IrsPointingProcessorState.
##  @note This uses \ref irsGetPointingProcessorMarkerStates, then converts the output to \ref IrsPointingProcessorState.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[out] states Output array of \ref IrsPointingProcessorState.
##  @param[in] count Size of the states array in entries. Must be 1-6.
##  @param[out] total_out Total output entries.
##

proc irsRunTeraPluginProcessor*(handle: IrsIrCameraHandle;
                               config: ptr IrsTeraPluginProcessorConfig): Result {.
    cdecl, importc: "irsRunTeraPluginProcessor".}
## *
##  @brief Run the TeraPluginProcessor.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[in] config Input config.
##

proc irsGetTeraPluginProcessorStates*(handle: IrsIrCameraHandle;
                                     states: ptr IrsTeraPluginProcessorState;
                                     count: S32; samplingNumber: S64;
                                     prefixData: U32; prefixBitcount: U32;
                                     totalOut: ptr S32): Result {.cdecl,
    importc: "irsGetTeraPluginProcessorStates".}
## *
##  @brief Gets the states for TeraPluginProcessor, filtered using the input params.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[out] states Output array of \ref IrsTeraPluginProcessorState.
##  @param[in] count Size of the states array in entries. Must be 1-5.
##  @param[in] sampling_number Minimum value for IrsTeraPluginProcessorState::sampling_number.
##  @param[in] prefix_data Only used when prefix_bitcount is not 0. The first prefix_bitcount bits from prefix_data must match the first prefix_bitcount bits in IrsTeraPluginProcessorState::plugin_data.
##  @param[in] prefix_bitcount Total bits for prefix_data.
##  @param[out] total_out Total output entries.
##

proc irsRunIrLedProcessor*(handle: IrsIrCameraHandle;
                          config: ptr IrsIrLedProcessorConfig): Result {.cdecl,
    importc: "irsRunIrLedProcessor".}
## *
##  @brief Run the IrLedProcessor.
##  @note Only available on [4.0.0+].
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[in] config Input config.
##

proc irsRunAdaptiveClusteringProcessor*(handle: IrsIrCameraHandle; config: ptr IrsAdaptiveClusteringProcessorConfig): Result {.
    cdecl, importc: "irsRunAdaptiveClusteringProcessor".}
## *
##  @brief Run the AdaptiveClusteringProcessor.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[in] config Input config.
##

proc irsRunHandAnalysis*(handle: IrsIrCameraHandle;
                        config: ptr IrsHandAnalysisConfig): Result {.cdecl,
    importc: "irsRunHandAnalysis".}
## *
##  @brief Run HandAnalysis.
##  @param[in] handle \ref IrsIrCameraHandle
##  @param[in] config Input config.
##

proc irsGetMomentProcessorDefaultConfig*(config: ptr IrsMomentProcessorConfig) {.
    cdecl, importc: "irsGetMomentProcessorDefaultConfig".}
## *
##  Gets the default configuration for MomentProcessor.
##

proc irsGetClusteringProcessorDefaultConfig*(
    config: ptr IrsClusteringProcessorConfig) {.cdecl,
    importc: "irsGetClusteringProcessorDefaultConfig".}
## *
##  Gets the default configuration for ClusteringProcessor.
##

proc irsGetDefaultImageTransferProcessorConfig*(
    config: ptr IrsImageTransferProcessorConfig) {.cdecl,
    importc: "irsGetDefaultImageTransferProcessorConfig".}
## *
##  Gets the default configuration for ImageTransferProcessor.
##  Defaults are exposure 300us, 8x digital gain, the rest is all-zero. Format is ::IrsImageTransferProcessorFormat_320x240.
##

proc irsGetDefaultImageTransferProcessorExConfig*(
    config: ptr IrsImageTransferProcessorExConfig) {.cdecl,
    importc: "irsGetDefaultImageTransferProcessorExConfig".}
## *
##  Gets the default configuration for ImageTransferProcessorEx.
##  Defaults are exposure 300us, 8x digital gain, the rest is all-zero. OrigFormat/TrimmingFormat are ::IrsImageTransferProcessorFormat_320x240.
##

proc irsGetIrLedProcessorDefaultConfig*(config: ptr IrsIrLedProcessorConfig) {.
    inline, cdecl.} =
  ## *
  ##  Gets the default configuration for IrLedProcessor.
  ##
  config.lightTarget = 0
