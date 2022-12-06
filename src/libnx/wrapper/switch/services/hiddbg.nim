## *
##  @file hiddbg.h
##  @brief hid:dbg service IPC wrapper.
##  @author yellows8
##

import
  ../types, ../services/hid, ../services/hidsys, ../sf/service, ../kernel/event

## / HiddbgNpadButton. For the remaining buttons, see \ref HidNpadButton.

type
  HiddbgNpadButton* = enum
    HiddbgNpadButtonHome = bit(18), ## /< HOME button
    HiddbgNpadButtonCapture = bit(19) ## /< Capture button


## / HdlsAttribute

type
  HiddbgHdlsAttribute* = enum
    HiddbgHdlsAttributeHasVirtualSixAxisSensorAcceleration = bit(0), ## /< HasVirtualSixAxisSensorAcceleration
    HiddbgHdlsAttributeHasVirtualSixAxisSensorAngle = bit(1) ## /< HasVirtualSixAxisSensorAngle


## / State for overriding \ref HidDebugPadState.

type
  HiddbgDebugPadAutoPilotState* {.bycopy.} = object
    attributes*: U32           ## /< Bitfield of \ref HidDebugPadAttribute.
    buttons*: U32              ## /< Bitfield of \ref HidDebugPadButton.
    analogStickL*: HidAnalogStickState ## /< AnalogStickL
    analogStickR*: HidAnalogStickState ## /< AnalogStickR


## / State for overriding \ref HidMouseState.

type
  HiddbgMouseAutoPilotState* {.bycopy.} = object
    x*: S32                    ## /< X
    y*: S32                    ## /< Y
    deltaX*: S32               ## /< DeltaX
    deltaY*: S32               ## /< DeltaY
    wheelDelta*: S32           ## /< WheelDelta
    buttons*: U32              ## /< Bitfield of \ref HidMouseButton.
    attributes*: U32           ## /< Bitfield of \ref HidMouseAttribute.


## / State for overriding \ref HidKeyboardState.

type
  HiddbgKeyboardAutoPilotState* {.bycopy.} = object
    modifiers*: U64            ## /< Bitfield of \ref HidKeyboardModifier.
    keys*: array[4, U64]


## / State for overriding SleepButtonState.

type
  HiddbgSleepButtonAutoPilotState* {.bycopy.} = object
    buttons*: U64              ## /< Bitfield of buttons, only bit0 is used.


## / HdlsHandle

type
  HiddbgHdlsHandle* {.bycopy.} = object
    handle*: U64               ## /< Handle


## / HdlsSessionId, returned by \ref hiddbgAttachHdlsWorkBuffer.

type
  HiddbgHdlsSessionId* {.bycopy.} = object
    id*: U64                   ## /< Id


## / HdlsDeviceInfo, for [7.0.0-8.1.0].

type
  HiddbgHdlsDeviceInfoV7* {.bycopy.} = object
    deviceTypeInternal*: U32   ## /< Only one bit can be set. BIT(N*4+0) = Pro-Controller, BIT(N*4+1) = Joy-Con Left, BIT(N*4+2) = Joy-Con Right, BIT(N*4+3) = invalid. Where N is 0-1. BIT(8-10) = Pro-Controller, BIT(11) = Famicom-Controller, BIT(12) = Famicom-Controller II with microphone, BIT(13) = NES-Controller(DeviceType=0x200), BIT(14) = NES-Controller(DeviceType=0x400), BIT(15-16) = invalid, BIT(17) = unknown(DeviceType=0x8000), BIT(18-20) = invalid, BIT(21-23) = unknown(DeviceType=0x80000000).
    singleColorBody*: U32      ## /< RGBA Single Body Color.
    singleColorButtons*: U32   ## /< RGBA Single Buttons Color.
    npadInterfaceType*: U8     ## /< \ref HidNpadInterfaceType. Additional type field used with the above type field (only applies to type bit0-bit2 and bit21), if the value doesn't match one of the following a default is used. Type Pro-Controller: value 0x3 indicates that the controller is connected via USB. Type BIT(21): value 0x3 = unknown. When value is 0x2, state is merged with an existing controller (when the type value is compatible with this). Otherwise, it's a dedicated controller.
    pad*: array[0x3, U8]        ## /< Padding.


## / HdlsDeviceInfo, for [9.0.0+]. Converted to/from \ref HiddbgHdlsDeviceInfoV7 on prior sysvers.

type
  HiddbgHdlsDeviceInfo* {.bycopy.} = object
    deviceType*: U8            ## /< \ref HidDeviceType
    npadInterfaceType*: U8     ## /< \ref HidNpadInterfaceType. Additional type field used with the above type field (only applies to ::HidDeviceType_JoyRight1, ::HidDeviceType_JoyLeft2, ::HidDeviceType_FullKey3, and ::HidDeviceType_System19), if the value doesn't match one of the following a default is used. ::HidDeviceType_FullKey3: ::HidNpadInterfaceType_USB indicates that the controller is connected via USB. :::HidDeviceType_System19: ::HidNpadInterfaceType_USB = unknown. When value is ::HidNpadInterfaceType_Rail, state is merged with an existing controller (with ::HidDeviceType_JoyRight1 / ::HidDeviceType_JoyLeft2). Otherwise, it's a dedicated controller.
    pad*: array[0x2, U8]        ## /< Padding.
    singleColorBody*: U32      ## /< RGBA Single Body Color.
    singleColorButtons*: U32   ## /< RGBA Single Buttons Color.
    colorLeftGrip*: U32        ## /< [9.0.0+] RGBA Left Grip Color.
    colorRightGrip*: U32       ## /< [9.0.0+] RGBA Right Grip Color.


## / HdlsState, for [7.0.0-8.1.0].

type
  HiddbgHdlsStateV7* {.bycopy.} = object
    isPowered*: U8             ## /< IsPowered for the main PowerInfo, see \ref HidNpadSystemProperties.
    flags*: U8                 ## /< ORRed with IsPowered to set the value of the first byte for \ref HidNpadSystemProperties. For example, value 1 here will set IsCharging for the main PowerInfo.
    unkX2*: array[0x6, U8]      ## /< Unknown
    batteryLevel*: U32         ## /< BatteryLevel for the main PowerInfo, see \ref HidPowerInfo.
    buttons*: U32              ## /< See \ref HiddbgNpadButton.
    analogStickL*: HidAnalogStickState ## /< AnalogStickL
    analogStickR*: HidAnalogStickState ## /< AnalogStickR
    indicator*: U8             ## /< Indicator. Unused for input. Set with output from \ref hiddbgDumpHdlsStates. Not set by \ref hiddbgGetAbstractedPadsState.
    padding*: array[0x3, U8]    ## /< Padding


## / HdlsState, for [9.0.0-11.0.1].

type
  HiddbgHdlsStateV9* {.bycopy.} = object
    batteryLevel*: U32         ## /< BatteryLevel for the main PowerInfo, see \ref HidPowerInfo.
    flags*: U32                ## /< Used to set the main PowerInfo for \ref HidNpadSystemProperties. BIT(0) -> IsPowered, BIT(1) -> IsCharging.
    buttons*: U64              ## /< See \ref HiddbgNpadButton. [9.0.0+] Masked with 0xfffffffff00fffff.
    analogStickL*: HidAnalogStickState ## /< AnalogStickL
    analogStickR*: HidAnalogStickState ## /< AnalogStickR
    indicator*: U8             ## /< Indicator. Unused for input. Set with output from \ref hiddbgDumpHdlsStates.
    padding*: array[0x3, U8]    ## /< Padding


## / HdlsState, for [12.0.0+].

type
  HiddbgHdlsState* {.bycopy.} = object
    batteryLevel*: U32         ## /< BatteryLevel for the main PowerInfo, see \ref HidPowerInfo.
    flags*: U32                ## /< Used to set the main PowerInfo for \ref HidNpadSystemProperties. BIT(0) -> IsPowered, BIT(1) -> IsCharging.
    buttons*: U64              ## /< See \ref HiddbgNpadButton. [9.0.0+] Masked with 0xfffffffff00fffff.
    analogStickL*: HidAnalogStickState ## /< AnalogStickL
    analogStickR*: HidAnalogStickState ## /< AnalogStickR
    sixAxisSensorAcceleration*: HidVector ## /< VirtualSixAxisSensorAcceleration
    sixAxisSensorAngle*: HidVector ## /< VirtualSixAxisSensorAngle
    attribute*: U32            ## /< Bitfield of \ref HiddbgHdlsAttribute.
    indicator*: U8             ## /< Indicator. Unused for input.
    padding*: array[0x3, U8]    ## /< Padding


## / HdlsNpadAssignmentEntry

type
  HiddbgHdlsNpadAssignmentEntry* {.bycopy.} = object
    handle*: HiddbgHdlsHandle  ## /< \ref HiddbgHdlsHandle
    unkX8*: U32                ## /< Unknown
    unkXc*: U32                ## /< Unknown
    unkX10*: U64               ## /< Unknown
    unkX18*: U8                ## /< Unknown
    pad*: array[0x7, U8]        ## /< Padding


## / HdlsNpadAssignment. Same controllers as \ref HiddbgHdlsStateList, with different entry data.

type
  HiddbgHdlsNpadAssignment* {.bycopy.} = object
    totalEntries*: S32         ## /< Total entries for the below entries.
    pad*: U32                  ## /< Padding
    entries*: array[0x10, HiddbgHdlsNpadAssignmentEntry] ## /< \ref HiddbgHdlsNpadAssignmentEntry


## / HdlsStateListEntryV7, for [7.0.0-8.1.0].

type
  HiddbgHdlsStateListEntryV7* {.bycopy.} = object
    handle*: HiddbgHdlsHandle  ## /< \ref HiddbgHdlsHandle
    device*: HiddbgHdlsDeviceInfoV7 ## /< \ref HiddbgHdlsDeviceInfoV7. With \ref hiddbgApplyHdlsStateList this is only used when creating new devices.
    state*: HiddbgHdlsStateV7  ## /< \ref HiddbgHdlsStateV7


## / HdlsStateListV7, for [7.0.0-8.1.0]. This contains a list of all controllers, including non-virtual controllers.

type
  HiddbgHdlsStateListV7* {.bycopy.} = object
    totalEntries*: S32         ## /< Total entries for the below entries.
    pad*: U32                  ## /< Padding
    entries*: array[0x10, HiddbgHdlsStateListEntryV7] ## /< \ref HiddbgHdlsStateListEntryV7


## / HdlsStateListEntry, for [9.0.0-11.0.1].

type
  HiddbgHdlsStateListEntryV9* {.bycopy.} = object
    handle*: HiddbgHdlsHandle  ## /< \ref HiddbgHdlsHandle
    device*: HiddbgHdlsDeviceInfo ## /< \ref HiddbgHdlsDeviceInfo. With \ref hiddbgApplyHdlsStateList this is only used when creating new devices.
    state*: HiddbgHdlsStateV9  ## /< \ref HiddbgHdlsStateV9


## / HdlsStateList, for [9.0.0-11.0.1].

type
  HiddbgHdlsStateListV9* {.bycopy.} = object
    totalEntries*: S32         ## /< Total entries for the below entries.
    pad*: U32                  ## /< Padding
    entries*: array[0x10, HiddbgHdlsStateListEntryV9] ## /< \ref HiddbgHdlsStateListEntryV9


## / HdlsStateListEntry, for [12.0.0+].

type
  HiddbgHdlsStateListEntry* {.bycopy.} = object
    handle*: HiddbgHdlsHandle  ## /< \ref HiddbgHdlsHandle
    device*: HiddbgHdlsDeviceInfo ## /< \ref HiddbgHdlsDeviceInfo. With \ref hiddbgApplyHdlsStateList this is only used when creating new devices.
    state*: HiddbgHdlsState    ## /< \ref HiddbgHdlsState


## / HdlsStateList, for [12.0.0+].
## / This contains a list of all controllers, including non-virtual controllers.

type
  HiddbgHdlsStateList* {.bycopy.} = object
    totalEntries*: S32         ## /< Total entries for the below entries.
    pad*: U32                  ## /< Padding
    entries*: array[0x10, HiddbgHdlsStateListEntry] ## /< \ref HiddbgHdlsStateListEntry


## / AbstractedPadHandle

type
  HiddbgAbstractedPadHandle* {.bycopy.} = object
    handle*: U64               ## /< Handle


## / AbstractedPadState

type
  HiddbgAbstractedPadState* {.bycopy.} = object
    `type`*: U32               ## /< Type. Converted to HiddbgHdlsDeviceInfoV7::type internally by \ref hiddbgSetAutoPilotVirtualPadState. BIT(0) -> BIT(0), BIT(1) -> BIT(15), BIT(2-3) -> BIT(1-2), BIT(4-5) -> BIT(1-2), BIT(6) -> BIT(3). BIT(7-11) -> BIT(11-15), BIT(12-14) -> BIT(12-14), BIT(15) -> BIT(17), BIT(31) -> BIT(21).
    flags*: U8                 ## /< Flags. Only bit0 is used by \ref hiddbgSetAutoPilotVirtualPadState, when clear it will skip using the rest of the input and run \ref hiddbgUnsetAutoPilotVirtualPadState internally.
    pad*: array[0x3, U8]        ## /< Padding
    singleColorBody*: U32      ## /< RGBA Single Body Color
    singleColorButtons*: U32   ## /< RGBA Single Buttons Color
    npadInterfaceType*: U8     ## /< See HiddbgHdlsDeviceInfo::npadInterfaceType.
    pad2*: array[0x3, U8]       ## /< Padding
    state*: HiddbgHdlsStateV7  ## /< State
    unused*: array[0x60, U8]    ## /< Unused with \ref hiddbgSetAutoPilotVirtualPadState. Not set by \ref hiddbgGetAbstractedPadsState.

proc hiddbgInitialize*(): Result {.cdecl, importc: "hiddbgInitialize".}
## / Initialize hiddbg.

proc hiddbgExit*() {.cdecl, importc: "hiddbgExit".}
## / Exit hiddbg.

proc hiddbgGetServiceSession*(): ptr Service {.cdecl,
    importc: "hiddbgGetServiceSession".}
## / Gets the Service object for the actual hiddbg service session.

proc hiddbgSetDebugPadAutoPilotState*(state: ptr HiddbgDebugPadAutoPilotState): Result {.
    cdecl, importc: "hiddbgSetDebugPadAutoPilotState".}
## *
##  @brief SetDebugPadAutoPilotState
##  @param[in] state \ref HiddbgDebugPadAutoPilotState
##

proc hiddbgUnsetDebugPadAutoPilotState*(): Result {.cdecl,
    importc: "hiddbgUnsetDebugPadAutoPilotState".}
## *
##  @brief UnsetDebugPadAutoPilotState
##

proc hiddbgSetTouchScreenAutoPilotState*(states: ptr HidTouchState; count: S32): Result {.
    cdecl, importc: "hiddbgSetTouchScreenAutoPilotState".}
## *
##  @brief SetTouchScreenAutoPilotState
##  @param[in] states Input array of \ref HiddbgMouseAutoPilotState.
##  @param[in] count Total entries in the states array. Max is 16.
##

proc hiddbgUnsetTouchScreenAutoPilotState*(): Result {.cdecl,
    importc: "hiddbgUnsetTouchScreenAutoPilotState".}
## *
##  @brief UnsetTouchScreenAutoPilotState
##

proc hiddbgSetMouseAutoPilotState*(state: ptr HiddbgMouseAutoPilotState): Result {.
    cdecl, importc: "hiddbgSetMouseAutoPilotState".}
## *
##  @brief SetMouseAutoPilotState
##  @param[in] state \ref HiddbgMouseAutoPilotState
##

proc hiddbgUnsetMouseAutoPilotState*(): Result {.cdecl,
    importc: "hiddbgUnsetMouseAutoPilotState".}
## *
##  @brief UnsetMouseAutoPilotState
##

proc hiddbgSetKeyboardAutoPilotState*(state: ptr HiddbgKeyboardAutoPilotState): Result {.
    cdecl, importc: "hiddbgSetKeyboardAutoPilotState".}
## *
##  @brief SetKeyboardAutoPilotState
##  @param[in] state \ref HiddbgKeyboardAutoPilotState
##

proc hiddbgUnsetKeyboardAutoPilotState*(): Result {.cdecl,
    importc: "hiddbgUnsetKeyboardAutoPilotState".}
## *
##  @brief UnsetKeyboardAutoPilotState
##

proc hiddbgDeactivateHomeButton*(): Result {.cdecl,
    importc: "hiddbgDeactivateHomeButton".}
## *
##  @brief Deactivates the HomeButton.
##

proc hiddbgSetSleepButtonAutoPilotState*(state: ptr HiddbgSleepButtonAutoPilotState): Result {.
    cdecl, importc: "hiddbgSetSleepButtonAutoPilotState".}
## *
##  @brief SetSleepButtonAutoPilotState
##  @param[in] state \ref HiddbgSleepButtonAutoPilotState
##

proc hiddbgUnsetSleepButtonAutoPilotState*(): Result {.cdecl,
    importc: "hiddbgUnsetSleepButtonAutoPilotState".}
## *
##  @brief UnsetSleepButtonAutoPilotState
##

proc hiddbgUpdateControllerColor*(colorBody: U32; colorButtons: U32;
                                 uniquePadId: HidsysUniquePadId): Result {.cdecl,
    importc: "hiddbgUpdateControllerColor".}
## *
##  @brief Writes the input RGB colors to the spi-flash for the specified UniquePad (offset 0x6050 size 0x6).
##  @note Only available with [3.0.0+].
##  @param[in] colorBody RGB body color.
##  @param[in] colorButtons RGB buttons color.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##

proc hiddbgUpdateDesignInfo*(colorBody: U32; colorButtons: U32; colorLeftGrip: U32;
                            colorRightGrip: U32; inval: U8;
                            uniquePadId: HidsysUniquePadId): Result {.cdecl,
    importc: "hiddbgUpdateDesignInfo".}
## *
##  @brief Writes the input RGB colors followed by inval to the spi-flash for the specified UniquePad (offset 0x6050 size 0xD).
##  @note Only available with [5.0.0+].
##  @param[in] colorBody RGB body color.
##  @param[in] colorButtons RGB buttons color.
##  @param[in] colorLeftGrip RGB left grip color.
##  @param[in] colorRightGrip RGB right grip color.
##  @param[in] inval Input value.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##

proc hiddbgAcquireOperationEventHandle*(outEvent: ptr Event; autoclear: bool;
                                       uniquePadId: HidsysUniquePadId): Result {.
    cdecl, importc: "hiddbgAcquireOperationEventHandle".}
## *
##  @brief Get the OperationEvent for the specified UniquePad.
##  @note The Event must be closed by the user once finished with it.
##  @note Only available with [6.0.0+].
##  @param[out] out_event Output Event.
##  @param[in] autoclear The autoclear for the Event.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##

proc hiddbgReadSerialFlash*(offset: U32; buffer: pointer; size: csize_t;
                           uniquePadId: HidsysUniquePadId): Result {.cdecl,
    importc: "hiddbgReadSerialFlash".}
## *
##  @brief Reads spi-flash for the specified UniquePad.
##  @note This also uses \ref hiddbgAcquireOperationEventHandle to wait for the operation to finish, then \ref hiddbgGetOperationResult is used.
##  @note Only available with [6.0.0+].
##  @param[in] offset Offset in spi-flash.
##  @param[out] buffer Output buffer.
##  @param[in] size Output buffer size.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##

proc hiddbgWriteSerialFlash*(offset: U32; buffer: pointer; tmemSize: csize_t;
                            size: csize_t; uniquePadId: HidsysUniquePadId): Result {.
    cdecl, importc: "hiddbgWriteSerialFlash".}
## *
##  @brief Writes spi-flash for the specified UniquePad.
##  @note This also uses \ref hiddbgAcquireOperationEventHandle to wait for the operation to finish, then \ref hiddbgGetOperationResult is used.
##  @note Only available with [6.0.0+].
##  @param[in] offset Offset in spi-flash.
##  @param[in] buffer Input buffer, must be 0x1000-byte aligned.
##  @param[in] tmem_size Size of the buffer, must be 0x1000-byte aligned.
##  @param[in] size Actual transfer size.
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##

proc hiddbgGetOperationResult*(uniquePadId: HidsysUniquePadId): Result {.cdecl,
    importc: "hiddbgGetOperationResult".}
## *
##  @brief Get the Result for the Operation and handles cleanup, for the specified UniquePad.
##  @note Only available with [6.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##

proc hiddbgGetUniquePadDeviceTypeSetInternal*(uniquePadId: HidsysUniquePadId;
    `out`: ptr U32): Result {.cdecl,
                          importc: "hiddbgGetUniquePadDeviceTypeSetInternal".}
## *
##  @brief Gets the internal DeviceType for the specified controller.
##  @note Only available with [6.0.0+].
##  @param[in] unique_pad_id \ref HidsysUniquePadId
##  @param[out] out Pre-9.0.0 this is an u32, with [9.0.0+] it's an u8.
##

proc hiddbgGetAbstractedPadHandles*(handles: ptr HiddbgAbstractedPadHandle;
                                   count: S32; totalOut: ptr S32): Result {.cdecl,
    importc: "hiddbgGetAbstractedPadHandles".}
## * @name AbstractedPad
##   This is for virtual HID controllers. Only use this on pre-7.0.0, Hdls should be used otherwise.
##
## /@{
## *
##  @brief Gets a list of \ref HiddbgAbstractedPadHandle.
##  @note Only available with [5.0.0-8.1.0].
##  @param[out] handles Output array of \ref HiddbgAbstractedPadHandle.
##  @param[in] count Max number of entries for the handles array.
##  @param[out] total_out Total output entries.
##

proc hiddbgGetAbstractedPadState*(handle: HiddbgAbstractedPadHandle;
                                 state: ptr HiddbgAbstractedPadState): Result {.
    cdecl, importc: "hiddbgGetAbstractedPadState".}
## *
##  @brief Gets the state for the specified \ref HiddbgAbstractedPadHandle.
##  @note Only available with [5.0.0-8.1.0].
##  @param[in] handle \ref HiddbgAbstractedPadHandle
##  @param[out] state \ref HiddbgAbstractedPadState
##

proc hiddbgGetAbstractedPadsState*(handles: ptr HiddbgAbstractedPadHandle;
                                  states: ptr HiddbgAbstractedPadState; count: S32;
                                  totalOut: ptr S32): Result {.cdecl,
    importc: "hiddbgGetAbstractedPadsState".}
## *
##  @brief Similar to \ref hiddbgGetAbstractedPadHandles except this also returns the state for each pad in output array states.
##  @note Only available with [5.0.0-8.1.0].
##  @param[out] handles Output array of \ref HiddbgAbstractedPadHandle.
##  @param[out] states Output array of \ref HiddbgAbstractedPadState.
##  @param[in] count Max number of entries for the handles/states arrays.
##  @param[out] total_out Total output entries.
##

proc hiddbgSetAutoPilotVirtualPadState*(abstractedVirtualPadId: S8;
                                       state: ptr HiddbgAbstractedPadState): Result {.
    cdecl, importc: "hiddbgSetAutoPilotVirtualPadState".}
## *
##  @brief Sets AutoPilot state for the specified pad.
##  @note Only available with [5.0.0-8.1.0].
##  @param[in] AbstractedVirtualPadId This can be any unique value as long as it's within bounds. For example, 0-7 is usable.
##  @param[in] state \ref HiddbgAbstractedPadState
##

proc hiddbgUnsetAutoPilotVirtualPadState*(abstractedVirtualPadId: S8): Result {.
    cdecl, importc: "hiddbgUnsetAutoPilotVirtualPadState".}
## *
##  @brief Clears AutoPilot state for the specified pad set by \ref hiddbgSetAutoPilotVirtualPadState.
##  @note Only available with [5.0.0-8.1.0].
##  @param[in] AbstractedVirtualPadId Id from \ref hiddbgSetAutoPilotVirtualPadState.
##

proc hiddbgUnsetAllAutoPilotVirtualPadState*(): Result {.cdecl,
    importc: "hiddbgUnsetAllAutoPilotVirtualPadState".}
## *
##  @brief Clears AutoPilot state for all pads set by \ref hiddbgSetAutoPilotVirtualPadState.
##

proc hiddbgAttachHdlsWorkBuffer*(sessionId: ptr HiddbgHdlsSessionId): Result {.cdecl,
    importc: "hiddbgAttachHdlsWorkBuffer".}
## /@}
## * @name Hdls
##   This is for virtual HID controllers.
##
## /@{
## *
##  @brief Initialize Hdls.
##  @note Only available with [7.0.0+].
##  @param[out] session_id [13.0.0+] \ref HiddbgHdlsSessionId
##

proc hiddbgReleaseHdlsWorkBuffer*(sessionId: HiddbgHdlsSessionId): Result {.cdecl,
    importc: "hiddbgReleaseHdlsWorkBuffer".}
## *
##  @brief Exit Hdls, must be called at some point prior to \ref hiddbgExit.
##  @note Only available with [7.0.0+].
##  @param[in] session_id [13.0.0+] \ref HiddbgHdlsSessionId
##

proc hiddbgIsHdlsVirtualDeviceAttached*(sessionId: HiddbgHdlsSessionId;
                                       handle: HiddbgHdlsHandle; `out`: ptr bool): Result {.
    cdecl, importc: "hiddbgIsHdlsVirtualDeviceAttached".}
## *
##  @brief Checks if the given device is still attached.
##  @note Only available with [7.0.0+].
##  @param[in] session_id [13.0.0+] \ref HiddbgHdlsSessionId
##  @param[in] handle \ref HiddbgHdlsHandle
##  @param[out] out Whether the device is attached.
##

proc hiddbgDumpHdlsNpadAssignmentState*(sessionId: HiddbgHdlsSessionId;
                                       state: ptr HiddbgHdlsNpadAssignment): Result {.
    cdecl, importc: "hiddbgDumpHdlsNpadAssignmentState".}
## *
##  @brief Gets state for \ref HiddbgHdlsNpadAssignment.
##  @note Only available with [7.0.0+].
##  @param[in] session_id [13.0.0+] \ref HiddbgHdlsSessionId
##  @param[out] state \ref HiddbgHdlsNpadAssignment
##

proc hiddbgDumpHdlsStates*(sessionId: HiddbgHdlsSessionId;
                          state: ptr HiddbgHdlsStateList): Result {.cdecl,
    importc: "hiddbgDumpHdlsStates".}
## *
##  @brief Gets state for \ref HiddbgHdlsStateList.
##  @note Only available with [7.0.0+].
##  @param[in] session_id [13.0.0+] \ref HiddbgHdlsSessionId
##  @param[out] state \ref HiddbgHdlsStateList
##

proc hiddbgApplyHdlsNpadAssignmentState*(sessionId: HiddbgHdlsSessionId;
                                        state: ptr HiddbgHdlsNpadAssignment;
                                        flag: bool): Result {.cdecl,
    importc: "hiddbgApplyHdlsNpadAssignmentState".}
## *
##  @brief Sets state for \ref HiddbgHdlsNpadAssignment.
##  @note Only available with [7.0.0+].
##  @param[in] session_id [13.0.0+] \ref HiddbgHdlsSessionId
##  @param[in] state \ref HiddbgHdlsNpadAssignment
##  @param[in] flag Flag
##

proc hiddbgApplyHdlsStateList*(sessionId: HiddbgHdlsSessionId;
                              state: ptr HiddbgHdlsStateList): Result {.cdecl,
    importc: "hiddbgApplyHdlsStateList".}
## *
##  @brief Sets state for \ref HiddbgHdlsStateList.
##  @note The \ref HiddbgHdlsState will be applied for each \ref HiddbgHdlsHandle. If a \ref HiddbgHdlsHandle is not found, code similar to \ref hiddbgAttachHdlsVirtualDevice will run with the \ref HiddbgHdlsDeviceInfo, then it will continue with applying state with the new device.
##  @note Only available with [7.0.0+].
##  @param[in] session_id [13.0.0+] \ref HiddbgHdlsSessionId
##  @param[in] state \ref HiddbgHdlsStateList
##

proc hiddbgAttachHdlsVirtualDevice*(handle: ptr HiddbgHdlsHandle;
                                   info: ptr HiddbgHdlsDeviceInfo): Result {.cdecl,
    importc: "hiddbgAttachHdlsVirtualDevice".}
## *
##  @brief Attach a device with the input info.
##  @note Only available with [7.0.0+].
##  @param[out] handle \ref HiddbgHdlsHandle
##  @param[in] info \ref HiddbgHdlsDeviceInfo
##

proc hiddbgDetachHdlsVirtualDevice*(handle: HiddbgHdlsHandle): Result {.cdecl,
    importc: "hiddbgDetachHdlsVirtualDevice".}
## *
##  @brief Detach the specified device.
##  @note Only available with [7.0.0+].
##  @param[in] handle \ref HiddbgHdlsHandle
##

proc hiddbgSetHdlsState*(handle: HiddbgHdlsHandle; state: ptr HiddbgHdlsState): Result {.
    cdecl, importc: "hiddbgSetHdlsState".}
## *
##  @brief Sets state for the specified device.
##  @note Only available with [7.0.0+].
##  @param[in] handle \ref HiddbgHdlsHandle
##  @param[in] state \ref HiddbgHdlsState
##

## /@}
