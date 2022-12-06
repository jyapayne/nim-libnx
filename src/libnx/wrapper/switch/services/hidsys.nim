## *
##  @file hidsys.h
##  @brief hid:sys service IPC wrapper.
##  @author exelix, yellows8, ndeadly
##

import
  ../types, ../kernel/event, ../services/hid, ../services/btdrv_types, ../sf/service

## / Selects what button to map to.

type
  HidcfgDigitalButtonAssignment* = enum
    HidcfgDigitalButtonAssignmentA = 0, ## /< A
    HidcfgDigitalButtonAssignmentB = 1, ## /< B
    HidcfgDigitalButtonAssignmentX = 2, ## /< X
    HidcfgDigitalButtonAssignmentY = 3, ## /< Y
    HidcfgDigitalButtonAssignmentStickL = 4, ## /< Left Stick Button
    HidcfgDigitalButtonAssignmentStickR = 5, ## /< Right Stick Button
    HidcfgDigitalButtonAssignmentL = 6, ## /< L
    HidcfgDigitalButtonAssignmentR = 7, ## /< R
    HidcfgDigitalButtonAssignmentZL = 8, ## /< ZL
    HidcfgDigitalButtonAssignmentZR = 9, ## /< ZR
    HidcfgDigitalButtonAssignmentSelect = 10, ## /< Select / Minus
    HidcfgDigitalButtonAssignmentStart = 11, ## /< Start / Plus
    HidcfgDigitalButtonAssignmentLeft = 12, ## /< Left
    HidcfgDigitalButtonAssignmentUp = 13, ## /< Up
    HidcfgDigitalButtonAssignmentRight = 14, ## /< Right
    HidcfgDigitalButtonAssignmentDown = 15, ## /< Down
    HidcfgDigitalButtonAssignmentLeftSL = 16, ## /< SL on Left controller.
    HidcfgDigitalButtonAssignmentLeftSR = 17, ## /< SR on Left controller.
    HidcfgDigitalButtonAssignmentRightSL = 18, ## /< SL on Right controller.
    HidcfgDigitalButtonAssignmentRightSR = 19, ## /< SR on Right controller.
    HidcfgDigitalButtonAssignmentHomeButton = 20, ## /< HomeButton
    HidcfgDigitalButtonAssignmentCaptureButton = 21, ## /< CaptureButton
    HidcfgDigitalButtonAssignmentInvalid = 22 ## /< Invalid / Disabled


## / AnalogStickRotation

type
  HidcfgAnalogStickRotation* = enum
    HidcfgAnalogStickRotationNone = 0, ## /< None
    HidcfgAnalogStickRotationClockwise90 = 1, ## /< Clockwise90
    HidcfgAnalogStickRotationAnticlockwise90 = 2 ## /< Anticlockwise90


## / UniquePadType

type
  HidsysUniquePadType* = enum
    HidsysUniquePadTypeEmbedded = 0, ## /< Embedded
    HidsysUniquePadTypeFullKeyController = 1, ## /< FullKeyController
    HidsysUniquePadTypeRightController = 2, ## /< RightController
    HidsysUniquePadTypeLeftController = 3, ## /< LeftController
    HidsysUniquePadTypeDebugPadController = 4 ## /< DebugPadController


## / UniquePadId for a controller.

type
  HidsysUniquePadId* {.bycopy.} = object
    id*: U64                   ## /< UniquePadId


## / UniquePadSerialNumber

type
  HidsysUniquePadSerialNumber* {.bycopy.} = object
    serialNumber*: array[0x10, char] ## /< SerialNumber


## / Mini Cycle struct for \ref HidsysNotificationLedPattern.

type
  HidsysNotificationLedPatternCycle* {.bycopy.} = object
    ledIntensity*: U8          ## /< Mini Cycle X LED Intensity.
    transitionSteps*: U8       ## /< Fading Transition Steps to Mini Cycle X (Uses PWM). Value 0x0: Instant. Each step duration is based on HidsysNotificationLedPattern::baseMiniCycleDuration.
    finalStepDuration*: U8     ## /< Final Step Duration Multiplier of Mini Cycle X. Value 0x0: 12.5ms, 0x1 - xF: 1x - 15x. Value is a Multiplier of HidsysNotificationLedPattern::baseMiniCycleDuration.
    pad*: U8


## / Structure for \ref hidsysSetNotificationLedPattern.
## / See also: https://switchbrew.org/wiki/HID_services#NotificationLedPattern
## / Only the low 4bits of each used byte in this struct is used.

type
  HidsysNotificationLedPattern* {.bycopy.} = object
    baseMiniCycleDuration*: U8 ## /< Mini Cycle Base Duration. Value 0x1-0xF: 12.5ms - 187.5ms. Value 0x0 = 0ms/OFF.
    totalMiniCycles*: U8       ## /< Number of Mini Cycles + 1. Value 0x0-0xF: 1 - 16 mini cycles.
    totalFullCycles*: U8       ## /< Number of Full Cycles. Value 0x1-0xF: 1 - 15 full cycles. Value 0x0 is repeat forever, but if baseMiniCycleDuration is set to 0x0, it does the 1st Mini Cycle with a 12.5ms step duration and then the LED stays on with startIntensity.
    startIntensity*: U8        ## /< LED Start Intensity. Value 0x0=0% - 0xF=100%.
    miniCycles*: array[16, HidsysNotificationLedPatternCycle] ## /< Mini Cycles
    unkX44*: array[0x2, U8]     ## /< Unknown
    padX46*: array[0x2, U8]     ## /< Padding


## / ButtonConfigEmbedded

type
  HidsysButtonConfigEmbedded* {.bycopy.} = object
    unkX0*: array[0x2C8, U8]


## / ButtonConfigFull

type
  HidsysButtonConfigFull* {.bycopy.} = object
    unkX0*: array[0x2C8, U8]


## / ButtonConfigLeft

type
  HidsysButtonConfigLeft* {.bycopy.} = object
    unkX0*: array[0x1C8, U8]


## / ButtonConfigRight

type
  HidsysButtonConfigRight* {.bycopy.} = object
    unkX0*: array[0x1A0, U8]


## / AnalogStickAssignment

type
  HidcfgAnalogStickAssignment* {.bycopy.} = object
    rotation*: U32             ## /< \ref HidcfgAnalogStickRotation
    isPairedStickAssigned*: U8 ## /< IsPairedStickAssigned
    reserved*: array[3, U8]     ## /< Reserved


## / ButtonConfigEmbedded

type
  HidcfgButtonConfigEmbedded* {.bycopy.} = object
    hardwareButtonLeft*: U32   ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonLeft
    hardwareButtonUp*: U32     ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonUp
    hardwareButtonRight*: U32  ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonRight
    hardwareButtonDown*: U32   ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonDown
    hardwareButtonA*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonA
    hardwareButtonB*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonB
    hardwareButtonX*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonX
    hardwareButtonY*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonY
    hardwareButtonStickL*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonStickL
    hardwareButtonStickR*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonStickR
    hardwareButtonL*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonL
    hardwareButtonR*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonR
    hardwareButtonZl*: U32     ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonZL
    hardwareButtonZr*: U32     ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonZR
    hardwareButtonSelect*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonSelect
    hardwareButtonStart*: U32  ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonStart
    hardwareButtonCapture*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonCapture
    hardwareStickL*: HidcfgAnalogStickAssignment ## /< HardwareStickL
    hardwareStickR*: HidcfgAnalogStickAssignment ## /< HardwareStickR


## / ButtonConfigFull

type
  HidcfgButtonConfigFull* {.bycopy.} = object
    hardwareButtonLeft*: U32   ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonLeft
    hardwareButtonUp*: U32     ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonUp
    hardwareButtonRight*: U32  ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonRight
    hardwareButtonDown*: U32   ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonDown
    hardwareButtonA*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonA
    hardwareButtonB*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonB
    hardwareButtonX*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonX
    hardwareButtonY*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonY
    hardwareButtonStickL*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonStickL
    hardwareButtonStickR*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonStickR
    hardwareButtonL*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonL
    hardwareButtonR*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonR
    hardwareButtonZl*: U32     ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonZL
    hardwareButtonZr*: U32     ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonZR
    hardwareButtonSelect*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonSelect
    hardwareButtonStart*: U32  ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonStart
    hardwareButtonCapture*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonCapture
    hardwareStickL*: HidcfgAnalogStickAssignment ## /< HardwareStickL
    hardwareStickR*: HidcfgAnalogStickAssignment ## /< HardwareStickR


## / ButtonConfigLeft

type
  HidcfgButtonConfigLeft* {.bycopy.} = object
    hardwareButtonLeft*: U32   ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonLeft
    hardwareButtonUp*: U32     ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonUp
    hardwareButtonRight*: U32  ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonRight
    hardwareButtonDown*: U32   ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonDown
    hardwareButtonStickL*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonStickL
    hardwareButtonL*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonL
    hardwareButtonZl*: U32     ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonZL
    hardwareButtonSelect*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonSelect
    hardwareButtonLeftSl*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonLeftSL
    hardwareButtonLeftSr*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonLeftSR
    hardwareButtonCapture*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonCapture
    hardwareStickL*: HidcfgAnalogStickAssignment ## /< HardwareStickL


## / ButtonConfigRight

type
  HidcfgButtonConfigRight* {.bycopy.} = object
    hardwareButtonA*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonA
    hardwareButtonB*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonB
    hardwareButtonX*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonX
    hardwareButtonY*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonY
    hardwareButtonStickR*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonStickR
    hardwareButtonR*: U32      ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonR
    hardwareButtonZr*: U32     ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonZR
    hardwareButtonStart*: U32  ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonStart
    hardwareButtonRightSl*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonRightSL
    hardwareButtonRightSr*: U32 ## /< \ref HidcfgDigitalButtonAssignment HardwareButtonRightSR
    hardwareStickR*: HidcfgAnalogStickAssignment ## /< HardwareStickR


## / StorageName

type
  HidcfgStorageName* {.bycopy.} = object
    name*: array[0x81, U8]      ## /< UTF-8 NUL-terminated name string.

proc hidsysInitialize*(): Result {.cdecl, importc: "hidsysInitialize".}
## / Initialize hidsys.

proc hidsysExit*() {.cdecl, importc: "hidsysExit".}
## / Exit hidsys.

proc hidsysGetServiceSession*(): ptr Service {.cdecl,
    importc: "hidsysGetServiceSession".}
## / Gets the Service object for the actual hidsys service session.

proc hidsysSendKeyboardLockKeyEvent*(events: U32): Result {.cdecl,
    importc: "hidsysSendKeyboardLockKeyEvent".}
## *
##  @brief SendKeyboardLockKeyEvent
##  @param[in] events Bitfield of \ref HidKeyboardLockKeyEvent.
##

proc hidsysAcquireHomeButtonEventHandle*(outEvent: ptr Event; autoclear: bool): Result {.
    cdecl, importc: "hidsysAcquireHomeButtonEventHandle".}
## *
##  @brief Gets an Event which is signaled when HidHomeButtonState is updated.
##  @note The Event must be closed by the user once finished with it.
##  @note This generally shouldn't be used, since AM-sysmodule uses it internally.
##  @param[out] out_event Output Event.
##  @param[in] Event autoclear.
##

proc hidsysActivateHomeButton*(): Result {.cdecl,
                                        importc: "hidsysActivateHomeButton".}
## *
##  @brief Activates the HomeButton sharedmem.
##  @note This generally shouldn't be used, since AM-sysmodule uses it internally.
##

proc hidsysAcquireSleepButtonEventHandle*(outEvent: ptr Event; autoclear: bool): Result {.
    cdecl, importc: "hidsysAcquireSleepButtonEventHandle".}
## *
##  @brief Gets an Event which is signaled when HidSleepButtonState is updated.
##  @note The Event must be closed by the user once finished with it.
##  @note This generally shouldn't be used, since AM-sysmodule uses it internally.
##  @param[out] out_event Output Event.
##  @param[in] Event autoclear.
##

proc hidsysActivateSleepButton*(): Result {.cdecl,
    importc: "hidsysActivateSleepButton".}
## *
##  @brief Activates the SleepButton sharedmem.
##  @note This generally shouldn't be used, since AM-sysmodule uses it internally.
##

proc hidsysAcquireCaptureButtonEventHandle*(outEvent: ptr Event; autoclear: bool): Result {.
    cdecl, importc: "hidsysAcquireCaptureButtonEventHandle".}
## *
##  @brief Gets an Event which is signaled when HidCaptureButtonState is updated.
##  @note The Event must be closed by the user once finished with it.
##  @note This generally shouldn't be used, since AM-sysmodule uses it internally.
##  @param[out] out_event Output Event.
##  @param[in] Event autoclear.
##

proc hidsysActivateCaptureButton*(): Result {.cdecl,
    importc: "hidsysActivateCaptureButton".}
## *
##  @brief Activates the CaptureButton sharedmem.
##  @note This generally shouldn't be used, since AM-sysmodule uses it internally.
##

proc hidsysGetSupportedNpadStyleSetOfCallerApplet*(`out`: ptr U32): Result {.cdecl,
    importc: "hidsysGetSupportedNpadStyleSetOfCallerApplet".}
## *
##  @brief Gets the SupportedNpadStyleSet for the CallerApplet. applet must be initialized in order to use this (uses \ref appletGetAppletResourceUserIdOfCallerApplet).
##  @note Only available on [6.0.0+].
##  @param[out] out Bitmask of \ref HidNpadStyleTag.
##

proc hidsysGetNpadInterfaceType*(id: HidNpadIdType; `out`: ptr U8): Result {.cdecl,
    importc: "hidsysGetNpadInterfaceType".}
## *
##  @brief Gets the \ref HidNpadInterfaceType for the specified controller.
##  @note Only available on [10.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @param[out] out \ref HidNpadInterfaceType
##

proc hidsysGetNpadLeftRightInterfaceType*(id: HidNpadIdType; out0: ptr U8;
    out1: ptr U8): Result {.cdecl, importc: "hidsysGetNpadLeftRightInterfaceType".}
## *
##  @brief GetNpadLeftRightInterfaceType
##  @note Only available on [10.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @param[out] out0 \ref HidNpadInterfaceType
##  @param[out] out1 \ref HidNpadInterfaceType
##

proc hidsysHasBattery*(id: HidNpadIdType; `out`: ptr bool): Result {.cdecl,
    importc: "hidsysHasBattery".}
## *
##  @brief HasBattery
##  @note Only available on [10.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @param[out] out Output flag.
##

proc hidsysHasLeftRightBattery*(id: HidNpadIdType; out0: ptr bool; out1: ptr bool): Result {.
    cdecl, importc: "hidsysHasLeftRightBattery".}
## *
##  @brief HasLeftRightBattery
##  @note Only available on [10.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @param[out] out0 Output flag.
##  @param[out] out1 Output flag.
##

proc hidsysGetUniquePadsFromNpad*(id: HidNpadIdType;
                                 uniquePadIds: ptr HidsysUniquePadId; count: S32;
                                 totalOut: ptr S32): Result {.cdecl,
    importc: "hidsysGetUniquePadsFromNpad".}
## *
##  @brief Gets the UniquePadIds for the specified controller.
##  @note Only available on [3.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @param[out] unique_pad_ids Output array of \ref HidsysUniquePadId.
##  @param[in] count Max number of entries for the unique_pad_ids array.
##  @param[out] total_out Total output array entries. Optional, can be NULL.
##

proc hidsysEnableAppletToGetInput*(enable: bool): Result {.cdecl,
    importc: "hidsysEnableAppletToGetInput".}
## *
##  @brief EnableAppletToGetInput
##  @param[in] enable Input flag.
##

proc hidsysAcquireUniquePadConnectionEventHandle*(outEvent: ptr Event): Result {.
    cdecl, importc: "hidsysAcquireUniquePadConnectionEventHandle".}
## *
##  @brief AcquireUniquePadConnectionEventHandle
##  @param[out] out_event Output Event.
##

proc hidsysGetUniquePadIds*(uniquePadIds: ptr HidsysUniquePadId; count: S32;
                           totalOut: ptr S32): Result {.cdecl,
    importc: "hidsysGetUniquePadIds".}
## *
##  @brief Gets a list of all UniquePadIds.
##  @param[out] unique_pad_ids Output array of \ref HidsysUniquePadId.
##  @param[in] count Max number of entries for the unique_pad_ids array.
##  @param[out] total_out Total output array entries. Optional, can be NULL.
##

proc hidsysGetUniquePadBluetoothAddress*(uniquePadId: HidsysUniquePadId;
                                        address: ptr BtdrvAddress): Result {.cdecl,
    importc: "hidsysGetUniquePadBluetoothAddress".}
## *
##  @brief GetUniquePadBluetoothAddress
##  @note Only available on [3.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] address \ref BtdrvAddress
##

proc hidsysDisconnectUniquePad*(uniquePadId: HidsysUniquePadId): Result {.cdecl,
    importc: "hidsysDisconnectUniquePad".}
## *
##  @brief DisconnectUniquePad
##  @note Only available on [3.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##

proc hidsysGetUniquePadType*(uniquePadId: HidsysUniquePadId;
                            padType: ptr HidsysUniquePadType): Result {.cdecl,
    importc: "hidsysGetUniquePadType".}
## *
##  @brief GetUniquePadType
##  @note Only available on [5.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] pad_type \ref HidsysUniquePadType
##

proc hidsysGetUniquePadInterface*(uniquePadId: HidsysUniquePadId;
                                 `interface`: ptr HidNpadInterfaceType): Result {.
    cdecl, importc: "hidsysGetUniquePadInterface".}
## *
##  @brief GetUniquePadInterface
##  @note Only available on [5.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] interface \ref HidNpadInterfaceType
##

proc hidsysGetUniquePadSerialNumber*(uniquePadId: HidsysUniquePadId;
                                    serial: ptr HidsysUniquePadSerialNumber): Result {.
    cdecl, importc: "hidsysGetUniquePadSerialNumber".}
## *
##  @brief Gets the \ref HidsysUniquePadSerialNumber.
##  @note Only available on [5.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] serial \ref HidsysUniquePadSerialNumber
##

proc hidsysGetUniquePadControllerNumber*(uniquePadId: HidsysUniquePadId;
                                        number: ptr U64): Result {.cdecl,
    importc: "hidsysGetUniquePadControllerNumber".}
## *
##  @brief GetUniquePadControllerNumber
##  @note Only available on [5.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] number Controller number.
##

proc hidsysSetNotificationLedPattern*(pattern: ptr HidsysNotificationLedPattern;
                                     uniquePadId: HidsysUniquePadId): Result {.
    cdecl, importc: "hidsysSetNotificationLedPattern".}
## *
##  @brief Sets the HOME-button notification LED pattern, for the specified controller.
##  @note Generally this should only be used if \ref hidsysSetNotificationLedPatternWithTimeout is not usable.
##  @note Only available on [7.0.0+].
##  @param[in] pattern \ref HidsysNotificationLedPattern
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##

proc hidsysSetNotificationLedPatternWithTimeout*(
    pattern: ptr HidsysNotificationLedPattern; uniquePadId: HidsysUniquePadId;
    timeout: U64): Result {.cdecl,
                         importc: "hidsysSetNotificationLedPatternWithTimeout".}
## *
##  @brief Sets the HOME-button notification LED pattern, for the specified controller. The LED will automatically be disabled once the specified timeout occurs.
##  @note Only available on [9.0.0+], and with controllers which have the [9.0.0+] firmware installed.
##  @param[in] pattern \ref HidsysNotificationLedPattern
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] timeout Timeout in nanoseconds.
##

proc hidsysIsUsbFullKeyControllerEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "hidsysIsUsbFullKeyControllerEnabled".}
## *
##  @brief IsUsbFullKeyControllerEnabled
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc hidsysEnableUsbFullKeyController*(flag: bool): Result {.cdecl,
    importc: "hidsysEnableUsbFullKeyController".}
## *
##  @brief EnableUsbFullKeyController
##  @note Only available on [3.0.0+].
##  @param[in] flag Flag
##

proc hidsysIsUsbConnected*(uniquePadId: HidsysUniquePadId; `out`: ptr bool): Result {.
    cdecl, importc: "hidsysIsUsbConnected".}
## *
##  @brief IsUsbConnected
##  @note Only available on [3.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] out Output flag.
##

proc hidsysIsFirmwareUpdateNeededForNotification*(uniquePadId: HidsysUniquePadId;
    `out`: ptr bool): Result {.cdecl, importc: "hidsysIsFirmwareUpdateNeededForNotification".}
## *
##  @brief IsFirmwareUpdateNeededForNotification
##  @note Only available on [9.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] out Output flag.
##

proc hidsysLegacyIsButtonConfigSupported*(uniquePadId: HidsysUniquePadId;
    `out`: ptr bool): Result {.cdecl, importc: "hidsysLegacyIsButtonConfigSupported".}
## *
##  @brief Legacy IsButtonConfigSupported.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysIsButtonConfigSupported instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] out Output bool flag.
##

proc hidsysIsButtonConfigSupported*(`addr`: BtdrvAddress; `out`: ptr bool): Result {.
    cdecl, importc: "hidsysIsButtonConfigSupported".}
## *
##  @brief IsButtonConfigSupported
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacyIsButtonConfigSupported instead.
##  @param[in] addr \ref BtdrvAddress
##  @param[out] out Output bool flag.
##

proc hidsysIsButtonConfigEmbeddedSupported*(`out`: ptr bool): Result {.cdecl,
    importc: "hidsysIsButtonConfigEmbeddedSupported".}
## *
##  @brief IsButtonConfigEmbeddedSupported
##  @note Only available on [11.0.0+].
##  @param[out] out Output bool flag.
##

proc hidsysLegacyDeleteButtonConfig*(uniquePadId: HidsysUniquePadId): Result {.
    cdecl, importc: "hidsysLegacyDeleteButtonConfig".}
## *
##  @brief Legacy DeleteButtonConfig.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysDeleteButtonConfig instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##

proc hidsysDeleteButtonConfig*(`addr`: BtdrvAddress): Result {.cdecl,
    importc: "hidsysDeleteButtonConfig".}
## *
##  @brief DeleteButtonConfig
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacyDeleteButtonConfig instead.
##  @param[in] addr \ref BtdrvAddress
##

proc hidsysDeleteButtonConfigEmbedded*(): Result {.cdecl,
    importc: "hidsysDeleteButtonConfigEmbedded".}
## *
##  @brief DeleteButtonConfigEmbedded
##  @note Only available on [11.0.0+].
##

proc hidsysLegacySetButtonConfigEnabled*(uniquePadId: HidsysUniquePadId; flag: bool): Result {.
    cdecl, importc: "hidsysLegacySetButtonConfigEnabled".}
## *
##  @brief Legacy SetButtonConfigEnabled.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysSetButtonConfigEnabled instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] flag Input flag.
##

proc hidsysSetButtonConfigEnabled*(`addr`: BtdrvAddress; flag: bool): Result {.cdecl,
    importc: "hidsysSetButtonConfigEnabled".}
## *
##  @brief SetButtonConfigEnabled
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacySetButtonConfigEnabled instead.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] flag Input flag.
##

proc hidsysSetButtonConfigEmbeddedEnabled*(flag: bool): Result {.cdecl,
    importc: "hidsysSetButtonConfigEmbeddedEnabled".}
## *
##  @brief SetButtonConfigEmbeddedEnabled
##  @note Only available on [11.0.0+].
##  @param[in] flag Input flag.
##

proc hidsysLegacyIsButtonConfigEnabled*(uniquePadId: HidsysUniquePadId;
                                       `out`: ptr bool): Result {.cdecl,
    importc: "hidsysLegacyIsButtonConfigEnabled".}
## *
##  @brief Legacy IsButtonConfigEnabled.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysIsButtonConfigEnabled instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] out Output bool flag.
##

proc hidsysIsButtonConfigEnabled*(`addr`: BtdrvAddress; `out`: ptr bool): Result {.
    cdecl, importc: "hidsysIsButtonConfigEnabled".}
## *
##  @brief IsButtonConfigEnabled
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacyIsButtonConfigEnabled instead.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] out Output bool flag.
##

proc hidsysIsButtonConfigEmbeddedEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "hidsysIsButtonConfigEmbeddedEnabled".}
## *
##  @brief IsButtonConfigEmbeddedEnabled
##  @note Only available on [11.0.0+].
##  @param[out] out Output bool flag.
##

proc hidsysLegacySetButtonConfigEmbedded*(uniquePadId: HidsysUniquePadId;
    config: ptr HidsysButtonConfigEmbedded): Result {.cdecl,
    importc: "hidsysLegacySetButtonConfigEmbedded".}
## *
##  @brief Legacy SetButtonConfigEmbedded.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysSetButtonConfigEmbedded instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] config \ref HidsysButtonConfigEmbedded
##

proc hidsysSetButtonConfigEmbedded*(config: ptr HidsysButtonConfigEmbedded): Result {.
    cdecl, importc: "hidsysSetButtonConfigEmbedded".}
## *
##  @brief SetButtonConfigEmbedded
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacySetButtonConfigEmbedded instead.
##  @param[in] config \ref HidsysButtonConfigEmbedded
##

proc hidsysLegacySetButtonConfigFull*(uniquePadId: HidsysUniquePadId;
                                     config: ptr HidsysButtonConfigFull): Result {.
    cdecl, importc: "hidsysLegacySetButtonConfigFull".}
## *
##  @brief Legacy SetButtonConfigFull.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysSetButtonConfigFull instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] config \ref HidsysButtonConfigFull
##

proc hidsysSetButtonConfigFull*(`addr`: BtdrvAddress;
                               config: ptr HidsysButtonConfigFull): Result {.cdecl,
    importc: "hidsysSetButtonConfigFull".}
## *
##  @brief SetButtonConfigFull
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacySetButtonConfigFull instead.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] config \ref HidsysButtonConfigFull
##

proc hidsysLegacySetButtonConfigLeft*(uniquePadId: HidsysUniquePadId;
                                     config: ptr HidsysButtonConfigLeft): Result {.
    cdecl, importc: "hidsysLegacySetButtonConfigLeft".}
## *
##  @brief Legacy SetButtonConfigLeft.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysSetButtonConfigLeft instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] config \ref HidsysButtonConfigLeft
##

proc hidsysSetButtonConfigLeft*(`addr`: BtdrvAddress;
                               config: ptr HidsysButtonConfigLeft): Result {.cdecl,
    importc: "hidsysSetButtonConfigLeft".}
## *
##  @brief SetButtonConfigLeft
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacySetButtonConfigLeft instead.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] config \ref HidsysButtonConfigLeft
##

proc hidsysLegacySetButtonConfigRight*(uniquePadId: HidsysUniquePadId;
                                      config: ptr HidsysButtonConfigRight): Result {.
    cdecl, importc: "hidsysLegacySetButtonConfigRight".}
## *
##  @brief Legacy SetButtonConfigRight.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysSetButtonConfigRight instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] config \ref HidsysButtonConfigRight
##

proc hidsysSetButtonConfigRight*(`addr`: BtdrvAddress;
                                config: ptr HidsysButtonConfigRight): Result {.
    cdecl, importc: "hidsysSetButtonConfigRight".}
## *
##  @brief SetButtonConfigRight
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacySetButtonConfigRight instead.
##  @param[in] addr \ref BtdrvAddress
##  @param[in] config \ref HidsysButtonConfigRight
##

proc hidsysLegacyGetButtonConfigEmbedded*(uniquePadId: HidsysUniquePadId;
    config: ptr HidsysButtonConfigEmbedded): Result {.cdecl,
    importc: "hidsysLegacyGetButtonConfigEmbedded".}
## *
##  @brief Legacy GetButtonConfigEmbedded.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysGetButtonConfigEmbedded instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] config \ref HidsysButtonConfigEmbedded
##

proc hidsysGetButtonConfigEmbedded*(config: ptr HidsysButtonConfigEmbedded): Result {.
    cdecl, importc: "hidsysGetButtonConfigEmbedded".}
## *
##  @brief GetButtonConfigEmbedded
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacyGetButtonConfigEmbedded instead.
##  @param[out] config \ref HidsysButtonConfigEmbedded
##

proc hidsysLegacyGetButtonConfigFull*(uniquePadId: HidsysUniquePadId;
                                     config: ptr HidsysButtonConfigFull): Result {.
    cdecl, importc: "hidsysLegacyGetButtonConfigFull".}
## *
##  @brief Legacy GetButtonConfigFull.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysGetButtonConfigFull instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] config \ref HidsysButtonConfigFull
##

proc hidsysGetButtonConfigFull*(`addr`: BtdrvAddress;
                               config: ptr HidsysButtonConfigFull): Result {.cdecl,
    importc: "hidsysGetButtonConfigFull".}
## *
##  @brief GetButtonConfigFull
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacyGetButtonConfigFull instead.
##  @param[in] addr \ref BtdrvAddress
##  @param[out] config \ref HidsysButtonConfigFull
##

proc hidsysLegacyGetButtonConfigLeft*(uniquePadId: HidsysUniquePadId;
                                     config: ptr HidsysButtonConfigLeft): Result {.
    cdecl, importc: "hidsysLegacyGetButtonConfigLeft".}
## *
##  @brief Legacy GetButtonConfigLeft.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysGetButtonConfigLeft instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] config \ref HidsysButtonConfigLeft
##

proc hidsysGetButtonConfigLeft*(`addr`: BtdrvAddress;
                               config: ptr HidsysButtonConfigLeft): Result {.cdecl,
    importc: "hidsysGetButtonConfigLeft".}
## *
##  @brief GetButtonConfigLeft
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacyGetButtonConfigLeft instead.
##  @param[in] addr \ref BtdrvAddress
##  @param[out] config \ref HidsysButtonConfigLeft
##

proc hidsysLegacyGetButtonConfigRight*(uniquePadId: HidsysUniquePadId;
                                      config: ptr HidsysButtonConfigRight): Result {.
    cdecl, importc: "hidsysLegacyGetButtonConfigRight".}
## *
##  @brief Legacy GetButtonConfigRight.
##  @note Only available on [10.0.0-10.2.0]. On [11.0.0+], use \ref hidsysGetButtonConfigRight instead.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] config \ref HidsysButtonConfigRight
##

proc hidsysGetButtonConfigRight*(`addr`: BtdrvAddress;
                                config: ptr HidsysButtonConfigRight): Result {.
    cdecl, importc: "hidsysGetButtonConfigRight".}
## *
##  @brief GetButtonConfigRight
##  @note Only available on [11.0.0+]. On [10.0.0-10.2.0], use \ref hidsysLegacyGetButtonConfigRight instead.
##  @param[in] addr \ref BtdrvAddress
##  @param[out] config \ref HidsysButtonConfigRight
##

proc hidsysIsCustomButtonConfigSupported*(uniquePadId: HidsysUniquePadId;
    `out`: ptr bool): Result {.cdecl, importc: "hidsysIsCustomButtonConfigSupported".}
## *
##  @brief IsCustomButtonConfigSupported
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] out Output bool flag.
##

proc hidsysIsDefaultButtonConfigEmbedded*(config: ptr HidcfgButtonConfigEmbedded;
    `out`: ptr bool): Result {.cdecl, importc: "hidsysIsDefaultButtonConfigEmbedded".}
## *
##  @brief IsDefaultButtonConfigEmbedded
##  @note Only available on [10.0.0+].
##  @param[in] config \ref HidcfgButtonConfigEmbedded
##  @param[out] out Output bool flag.
##

proc hidsysIsDefaultButtonConfigFull*(config: ptr HidcfgButtonConfigFull;
                                     `out`: ptr bool): Result {.cdecl,
    importc: "hidsysIsDefaultButtonConfigFull".}
## *
##  @brief IsDefaultButtonConfigFull
##  @note Only available on [10.0.0+].
##  @param[in] config \ref HidcfgButtonConfigFull
##  @param[out] out Output bool flag.
##

proc hidsysIsDefaultButtonConfigLeft*(config: ptr HidcfgButtonConfigLeft;
                                     `out`: ptr bool): Result {.cdecl,
    importc: "hidsysIsDefaultButtonConfigLeft".}
## *
##  @brief IsDefaultButtonConfigLeft
##  @note Only available on [10.0.0+].
##  @param[in] config \ref HidcfgButtonConfigLeft
##  @param[out] out Output bool flag.
##

proc hidsysIsDefaultButtonConfigRight*(config: ptr HidcfgButtonConfigRight;
                                      `out`: ptr bool): Result {.cdecl,
    importc: "hidsysIsDefaultButtonConfigRight".}
## *
##  @brief IsDefaultButtonConfigRight
##  @note Only available on [10.0.0+].
##  @param[in] config \ref HidcfgButtonConfigRight
##  @param[out] out Output bool flag.
##

proc hidsysIsButtonConfigStorageEmbeddedEmpty*(index: S32; `out`: ptr bool): Result {.
    cdecl, importc: "hidsysIsButtonConfigStorageEmbeddedEmpty".}
## *
##  @brief IsButtonConfigStorageEmbeddedEmpty
##  @note Only available on [10.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[out] out Output bool flag.
##

proc hidsysIsButtonConfigStorageFullEmpty*(index: S32; `out`: ptr bool): Result {.
    cdecl, importc: "hidsysIsButtonConfigStorageFullEmpty".}
## *
##  @brief IsButtonConfigStorageFullEmpty
##  @note Only available on [10.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[out] out Output bool flag.
##

proc hidsysIsButtonConfigStorageLeftEmpty*(index: S32; `out`: ptr bool): Result {.
    cdecl, importc: "hidsysIsButtonConfigStorageLeftEmpty".}
## *
##  @brief IsButtonConfigStorageLeftEmpty
##  @note Only available on [10.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[out] out Output bool flag.
##

proc hidsysIsButtonConfigStorageRightEmpty*(index: S32; `out`: ptr bool): Result {.
    cdecl, importc: "hidsysIsButtonConfigStorageRightEmpty".}
## *
##  @brief IsButtonConfigStorageRightEmpty
##  @note Only available on [10.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[out] out Output bool flag.
##

proc hidsysGetButtonConfigStorageEmbeddedDeprecated*(index: S32;
    config: ptr HidcfgButtonConfigEmbedded): Result {.cdecl,
    importc: "hidsysGetButtonConfigStorageEmbeddedDeprecated".}
## *
##  @brief GetButtonConfigStorageEmbeddedDeprecated
##  @note Only available on [10.0.0-12.1.0].
##  @param[in] index Array index, should be 0-4.
##  @param[out] config \ref HidcfgButtonConfigEmbedded
##

proc hidsysGetButtonConfigStorageFullDeprecated*(index: S32;
    config: ptr HidcfgButtonConfigFull): Result {.cdecl,
    importc: "hidsysGetButtonConfigStorageFullDeprecated".}
## *
##  @brief GetButtonConfigStorageFullDeprecated
##  @note Only available on [10.0.0-12.1.0].
##  @param[in] index Array index, should be 0-4.
##  @param[out] config \ref HidcfgButtonConfigFull
##

proc hidsysGetButtonConfigStorageLeftDeprecated*(index: S32;
    config: ptr HidcfgButtonConfigLeft): Result {.cdecl,
    importc: "hidsysGetButtonConfigStorageLeftDeprecated".}
## *
##  @brief GetButtonConfigStorageLeftDeprecated
##  @note Only available on [10.0.0-12.1.0].
##  @param[in] index Array index, should be 0-4.
##  @param[out] config \ref HidcfgButtonConfigLeft
##

proc hidsysGetButtonConfigStorageRightDeprecated*(index: S32;
    config: ptr HidcfgButtonConfigRight): Result {.cdecl,
    importc: "hidsysGetButtonConfigStorageRightDeprecated".}
## *
##  @brief GetButtonConfigStorageRightDeprecated
##  @note Only available on [10.0.0-12.1.0].
##  @param[in] index Array index, should be 0-4.
##  @param[out] config \ref HidcfgButtonConfigRight
##

proc hidsysSetButtonConfigStorageEmbeddedDeprecated*(index: S32;
    config: ptr HidcfgButtonConfigEmbedded): Result {.cdecl,
    importc: "hidsysSetButtonConfigStorageEmbeddedDeprecated".}
## *
##  @brief SetButtonConfigStorageEmbeddedDeprecated
##  @note Only available on [10.0.0-12.1.0].
##  @param[in] index Array index, should be 0-4.
##  @param[in] config \ref HidcfgButtonConfigEmbedded
##

proc hidsysSetButtonConfigStorageFullDeprecated*(index: S32;
    config: ptr HidcfgButtonConfigFull): Result {.cdecl,
    importc: "hidsysSetButtonConfigStorageFullDeprecated".}
## *
##  @brief SetButtonConfigStorageFullDeprecated
##  @note Only available on [10.0.0-12.1.0].
##  @param[in] index Array index, should be 0-4.
##  @param[in] config \ref HidcfgButtonConfigFull
##

proc hidsysSetButtonConfigStorageLeftDeprecated*(index: S32;
    config: ptr HidcfgButtonConfigLeft): Result {.cdecl,
    importc: "hidsysSetButtonConfigStorageLeftDeprecated".}
## *
##  @brief SetButtonConfigStorageLeftDeprecated
##  @note Only available on [10.0.0-12.1.0].
##  @param[in] index Array index, should be 0-4.
##  @param[in] config \ref HidcfgButtonConfigLeft
##

proc hidsysSetButtonConfigStorageRightDeprecated*(index: S32;
    config: ptr HidcfgButtonConfigRight): Result {.cdecl,
    importc: "hidsysSetButtonConfigStorageRightDeprecated".}
## *
##  @brief SetButtonConfigStorageRightDeprecated
##  @note Only available on [10.0.0-12.1.0].
##  @param[in] index Array index, should be 0-4.
##  @param[in] config \ref HidcfgButtonConfigRight
##

proc hidsysDeleteButtonConfigStorageEmbedded*(index: S32): Result {.cdecl,
    importc: "hidsysDeleteButtonConfigStorageEmbedded".}
## *
##  @brief DeleteButtonConfigStorageEmbedded
##  @note Only available on [10.0.0+].
##  @param[in] index Array index, should be 0-4.
##

proc hidsysDeleteButtonConfigStorageFull*(index: S32): Result {.cdecl,
    importc: "hidsysDeleteButtonConfigStorageFull".}
## *
##  @brief DeleteButtonConfigStorageFull
##  @note Only available on [10.0.0+].
##  @param[in] index Array index, should be 0-4.
##

proc hidsysDeleteButtonConfigStorageLeft*(index: S32): Result {.cdecl,
    importc: "hidsysDeleteButtonConfigStorageLeft".}
## *
##  @brief DeleteButtonConfigStorageLeft
##  @note Only available on [10.0.0+].
##  @param[in] index Array index, should be 0-4.
##

proc hidsysDeleteButtonConfigStorageRight*(index: S32): Result {.cdecl,
    importc: "hidsysDeleteButtonConfigStorageRight".}
## *
##  @brief DeleteButtonConfigStorageRight
##  @note Only available on [10.0.0+].
##  @param[in] index Array index, should be 0-4.
##

proc hidsysIsUsingCustomButtonConfig*(uniquePadId: HidsysUniquePadId;
                                     `out`: ptr bool): Result {.cdecl,
    importc: "hidsysIsUsingCustomButtonConfig".}
## *
##  @brief IsUsingCustomButtonConfig
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] out Output bool flag.
##

proc hidsysIsAnyCustomButtonConfigEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "hidsysIsAnyCustomButtonConfigEnabled".}
## *
##  @brief IsAnyCustomButtonConfigEnabled
##  @note Only available on [10.0.0+].
##  @param[out] out Output bool flag.
##

proc hidsysSetAllCustomButtonConfigEnabled*(appletResourceUserId: U64; flag: bool): Result {.
    cdecl, importc: "hidsysSetAllCustomButtonConfigEnabled".}
## *
##  @brief SetAllCustomButtonConfigEnabled
##  @note Only available on [10.0.0+].
##  @param[in] AppletResourceUserId AppletResourceUserId
##  @param[in] flag Input bool flag.
##

proc hidsysSetAllDefaultButtonConfig*(): Result {.cdecl,
    importc: "hidsysSetAllDefaultButtonConfig".}
## *
##  @brief SetAllDefaultButtonConfig
##  @note Only available on [10.0.0+].
##

proc hidsysSetHidButtonConfigEmbedded*(uniquePadId: HidsysUniquePadId;
                                      config: ptr HidcfgButtonConfigEmbedded): Result {.
    cdecl, importc: "hidsysSetHidButtonConfigEmbedded".}
## *
##  @brief SetHidButtonConfigEmbedded
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] config \ref HidcfgButtonConfigEmbedded
##

proc hidsysSetHidButtonConfigFull*(uniquePadId: HidsysUniquePadId;
                                  config: ptr HidcfgButtonConfigFull): Result {.
    cdecl, importc: "hidsysSetHidButtonConfigFull".}
## *
##  @brief SetHidButtonConfigFull
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] config \ref HidcfgButtonConfigFull
##

proc hidsysSetHidButtonConfigLeft*(uniquePadId: HidsysUniquePadId;
                                  config: ptr HidcfgButtonConfigLeft): Result {.
    cdecl, importc: "hidsysSetHidButtonConfigLeft".}
## *
##  @brief SetHidButtonConfigLeft
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] config \ref HidcfgButtonConfigLeft
##

proc hidsysSetHidButtonConfigRight*(uniquePadId: HidsysUniquePadId;
                                   config: ptr HidcfgButtonConfigRight): Result {.
    cdecl, importc: "hidsysSetHidButtonConfigRight".}
## *
##  @brief SetHidButtonConfigRight
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[in] config \ref HidcfgButtonConfigRight
##

proc hidsysGetHidButtonConfigEmbedded*(uniquePadId: HidsysUniquePadId;
                                      config: ptr HidcfgButtonConfigEmbedded): Result {.
    cdecl, importc: "hidsysGetHidButtonConfigEmbedded".}
## *
##  @brief GetHidButtonConfigEmbedded
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] config \ref HidcfgButtonConfigEmbedded
##

proc hidsysGetHidButtonConfigFull*(uniquePadId: HidsysUniquePadId;
                                  config: ptr HidcfgButtonConfigFull): Result {.
    cdecl, importc: "hidsysGetHidButtonConfigFull".}
## *
##  @brief GetHidButtonConfigFull
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] config \ref HidcfgButtonConfigFull
##

proc hidsysGetHidButtonConfigLeft*(uniquePadId: HidsysUniquePadId;
                                  config: ptr HidcfgButtonConfigLeft): Result {.
    cdecl, importc: "hidsysGetHidButtonConfigLeft".}
## *
##  @brief GetHidButtonConfigLeft
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] config \ref HidcfgButtonConfigLeft
##

proc hidsysGetHidButtonConfigRight*(uniquePadId: HidsysUniquePadId;
                                   config: ptr HidcfgButtonConfigRight): Result {.
    cdecl, importc: "hidsysGetHidButtonConfigRight".}
## *
##  @brief GetHidButtonConfigRight
##  @note Only available on [10.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] config \ref HidcfgButtonConfigRight
##

proc hidsysGetButtonConfigStorageEmbedded*(index: S32;
    config: ptr HidcfgButtonConfigEmbedded; name: ptr HidcfgStorageName): Result {.
    cdecl, importc: "hidsysGetButtonConfigStorageEmbedded".}
## *
##  @brief GetButtonConfigStorageEmbedded
##  @note Only available on [11.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[out] config \ref HidcfgButtonConfigEmbedded
##  @param[out] name \ref HidcfgStorageName
##

proc hidsysGetButtonConfigStorageFull*(index: S32;
                                      config: ptr HidcfgButtonConfigFull;
                                      name: ptr HidcfgStorageName): Result {.cdecl,
    importc: "hidsysGetButtonConfigStorageFull".}
## *
##  @brief GetButtonConfigStorageFull
##  @note Only available on [11.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[out] config \ref HidcfgButtonConfigFull
##  @param[out] name \ref HidcfgStorageName
##

proc hidsysGetButtonConfigStorageLeft*(index: S32;
                                      config: ptr HidcfgButtonConfigLeft;
                                      name: ptr HidcfgStorageName): Result {.cdecl,
    importc: "hidsysGetButtonConfigStorageLeft".}
## *
##  @brief GetButtonConfigStorageLeft
##  @note Only available on [11.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[out] config \ref HidcfgButtonConfigLeft
##  @param[out] name \ref HidcfgStorageName
##

proc hidsysGetButtonConfigStorageRight*(index: S32;
                                       config: ptr HidcfgButtonConfigRight;
                                       name: ptr HidcfgStorageName): Result {.cdecl,
    importc: "hidsysGetButtonConfigStorageRight".}
## *
##  @brief GetButtonConfigStorageRight
##  @note Only available on [11.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[out] config \ref HidcfgButtonConfigRight
##  @param[out] name \ref HidcfgStorageName
##

proc hidsysSetButtonConfigStorageEmbedded*(index: S32;
    config: ptr HidcfgButtonConfigEmbedded; name: ptr HidcfgStorageName): Result {.
    cdecl, importc: "hidsysSetButtonConfigStorageEmbedded".}
## *
##  @brief SetButtonConfigStorageEmbedded
##  @note Only available on [11.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[in] config \ref HidcfgButtonConfigEmbedded
##  @param[in] name \ref HidcfgStorageName
##

proc hidsysSetButtonConfigStorageFull*(index: S32;
                                      config: ptr HidcfgButtonConfigFull;
                                      name: ptr HidcfgStorageName): Result {.cdecl,
    importc: "hidsysSetButtonConfigStorageFull".}
## *
##  @brief SetButtonConfigStorageFull
##  @note Only available on [11.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[in] config \ref HidcfgButtonConfigFull
##  @param[in] name \ref HidcfgStorageName
##

proc hidsysSetButtonConfigStorageLeft*(index: S32;
                                      config: ptr HidcfgButtonConfigLeft;
                                      name: ptr HidcfgStorageName): Result {.cdecl,
    importc: "hidsysSetButtonConfigStorageLeft".}
## *
##  @brief SetButtonConfigStorageLeft
##  @note Only available on [11.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[in] config \ref HidcfgButtonConfigLeft
##  @param[in] name \ref HidcfgStorageName
##

proc hidsysSetButtonConfigStorageRight*(index: S32;
                                       config: ptr HidcfgButtonConfigRight;
                                       name: ptr HidcfgStorageName): Result {.cdecl,
    importc: "hidsysSetButtonConfigStorageRight".}
## *
##  @brief SetButtonConfigStorageRight
##  @note Only available on [11.0.0+].
##  @param[in] index Array index, should be 0-4.
##  @param[in] config \ref HidcfgButtonConfigRight
##  @param[in] name \ref HidcfgStorageName
##

