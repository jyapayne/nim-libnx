import macros, strutils, sets
import libnx/wrapper/hid
from libnx/wrapper/types import BIT
import libnx/utils
import libnx/results
import libnx/service
import libnx/results

niceify(HidMouseButton, "Hid:MOUSE_")
niceify(HidKeyboardModifier, "Hid:KBD_MOD_")
niceify(HidKeyboardScancode, "HidKeyboardScancode:KeyboardKey:KBD_:")
niceify(HidControllerType, "Hid:TYPE_")
niceify(HidControllerLayoutType, "Hid:LAYOUT_")
niceify(HidControllerColorDescription, "Hid:COLORS_")
niceify(HidControllerKeys, "HidControllerKeys:ControllerKey:KEY_:")
niceify(HidControllerJoystick, "Hid:JOYSTICK_")
niceify(HidControllerID, "HidControllerID:Controller:CONTROLLER_:")

export TouchPosition, JoystickPosition, MousePosition
export JOYSTICK_MAX, JOYSTICK_MIN

type
  InputError* = object of Exception
  ControllerSelectError* = object of InputError

  TouchScreenHeader* = ref object
    timestampTicks*: uint64
    numEntries*: uint64
    latestEntry*: uint64
    maxEntryIndex*: uint64
    timestamp*: uint64

  TouchScreenEntryHeader* = ref object
    timestamp*: uint64
    numTouches*: uint64

  TouchScreenEntryTouch* = ref object
    timestamp*: uint64
    padding*: uint32
    touchIndex*: uint32
    x*: uint32
    y*: uint32
    diameterX*: uint32
    diameterY*: uint32
    angle*: uint32
    padding2*: uint32

  TouchScreenEntry* = ref object
    header*: TouchScreenEntryHeader
    touches*: Buffer[HidTouchScreenEntryTouch]
    unk*: uint64

  TouchScreen* = ref object
    header*: TouchScreenHeader
    entries*: Buffer[HidTouchScreenEntry]
    padding*: Buffer[uint8]

  MouseHeader* = ref object
    timestampTicks*: uint64
    numEntries*: uint64
    latestEntry*: uint64
    maxEntryIndex*: uint64


type
  MouseEntry* = ref object
    timestamp*: uint64
    timestamp2*: uint64
    position*: MousePosition
    buttons*: uint64


type
  Mouse* = ref object
    header*: MouseHeader
    entries*: Buffer[MouseEntry]
    padding*: Buffer[uint8]

  KeyboardHeader* = ref object
    timestampTicks*: uint64
    numEntries*: uint64
    latestEntry*: uint64
    maxEntryIndex*: uint64

  KeyboardEntry* = ref object
    timestamp*: uint64
    timestamp2*: uint64
    modifier*: uint64
    keys*: Buffer[uint32]


  KeyboardSection* = ref object
    header*: KeyboardHeader
    entries*: array[17, KeyboardEntry]
    padding*: array[0x00000028, uint8]

  ControllerMAC* = object
    timestamp*: uint64
    mac*: array[0x00000008, uint8]
    unk*: uint64
    timestamp2*: uint64

  ControllerHeader* = object
    `type`* {.importc: "type".}: uint32
    isHalf* {.importc: "isHalf".}: uint32
    singleColorsDescriptor* {.importc: "singleColorsDescriptor".}: uint32
    singleColorBody* {.importc: "singleColorBody".}: uint32
    singleColorButtons* {.importc: "singleColorButtons".}: uint32
    splitColorsDescriptor* {.importc: "splitColorsDescriptor".}: uint32
    leftColorBody* {.importc: "leftColorBody".}: uint32
    leftColorButtons* {.importc: "leftColorButtons".}: uint32
    rightColorBody* {.importc: "rightColorBody".}: uint32
    rightColorbuttons* {.importc: "rightColorbuttons".}: uint32


  ControllerLayoutHeader* = object
    timestampTicks* {.importc: "timestampTicks".}: uint64
    numEntries* {.importc: "numEntries".}: uint64
    latestEntry* {.importc: "latestEntry".}: uint64
    maxEntryIndex* {.importc: "maxEntryIndex".}: uint64


  HidControllerInputEntry* = object
    timestamp* {.importc: "timestamp".}: uint64
    timestamp_2* {.importc: "timestamp_2".}: uint64
    buttons* {.importc: "buttons".}: uint64
    joysticks* {.importc: "joysticks".}: array[JOYSTICK_NUM_STICKS, JoystickPosition]
    connectionState* {.importc: "connectionState".}: uint64


  ControllerLayoutSection* = ref object
    header*: ControllerLayoutHeader
    entries* {.importc: "entries".}: array[17, HidControllerInputEntry]


  ControllerSection* = ref object
    header* {.importc: "header".}: ControllerHeader
    layouts* {.importc: "layouts".}: Buffer[ControllerLayoutSection]
    unk_1*: Buffer[uint8]
    macLeft*: HidControllerMAC
    macRight*: HidControllerMAC
    unk_2* {.importc: "unk_2".}: array[0x00000DF8, uint8]


  InputSharedMemory* = ref object
    header*: Buffer[uint8]
    touchscreen*: TouchScreen
    mouse*: Mouse
    keyboard*: KeyboardSection
    controllerSerials*: Buffer[uint8]
    controllers*: Buffer[ControllerSection]

  VibrationDeviceInfo* = ref object
    unk_x0*: uint32
    unk_x4*: uint32 ## /< 0x1 for left-joycon, 0x2 for right-joycon.

  VibrationValue* = ref object
    ampLow*: float ## /< Low Band amplitude. 1.0f: Max amplitude.
    freqLow*: float ## /< Low Band frequency in Hz.
    ampHigh*: float ## /< High Band amplitude. 1.0f: Max amplitude.
    freqHigh*: float ## /< High Band frequency in Hz.


proc init*(): Result = hidInitialize().newResult
proc exit*() = hidExit()
proc reset*() = hidReset()

proc getSessionService*(): Service =
  newService(hidGetSessionService()[])

proc getSharedMemory*(): ptr HidSharedMemory =
  result = cast[ptr HidSharedMemory](hidGetSharedMemAddr())

proc setControllerLayout*(id: Controller, layoutType: ControllerLayoutType) =
  hidSetControllerLayout(HidControllerID(id), HidControllerLayoutType(layoutType))

proc getControllerLayout*(id: Controller): ControllerLayoutType =
  hidGetControllerLayout(HidControllerID(id)).ControllerLayoutType

proc scanInput*() = scanInput()

proc keysHeld*(id: Controller): HashSet[ControllerKey] =
  result = initSet[ControllerKey]()

  var raw = hidKeysHeld(HidControllerID(id))
  for i in ControllerKey.low.int ..< ControllerKey.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(ControllerKey(BIT(i)))
    raw = raw shr 1

proc keysDown*(id: Controller): HashSet[ControllerKey] =
  result = initSet[ControllerKey]()

  var raw = hidKeysDown(HidControllerID(id))
  for i in ControllerKey.low.int ..< ControllerKey.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(ControllerKey(BIT(i)))
    raw = raw shr 1

proc keysUp*(id: Controller): HashSet[ControllerKey] =
  result = initSet[ControllerKey]()

  var raw = hidKeysUp(HidControllerID(id))
  for i in ControllerKey.low.int ..< ControllerKey.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(ControllerKey(BIT(i)))
    raw = raw shr 1

proc mouseButtonsHeld*(): HashSet[MouseButton] =
  result = initSet[MouseButton]()

  var raw = hidMouseButtonsHeld()
  for i in MouseButton.low.int ..< MouseButton.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(MouseButton(BIT(i)))
    raw = raw shr 1


proc mouseButtonsDown*(): HashSet[MouseButton] =
  result = initSet[MouseButton]()

  var raw = hidMouseButtonsDown()
  for i in MouseButton.low.int ..< MouseButton.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(MouseButton(BIT(i)))
    raw = raw shr 1

proc mouseButtonsUp*(): HashSet[MouseButton] =
  result = initSet[MouseButton]()

  var raw = hidMouseButtonsUp()
  for i in MouseButton.low.int ..< MouseButton.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(MouseButton(BIT(i)))
    raw = raw shr 1

proc mouseRead*(): MousePosition =
  var pos: ptr MousePosition
  hidMouseRead(pos)
  result = pos[]

proc keyboardModifierHeld*(modifier: KeyboardModifier): bool =
  hidKeyboardModifierHeld(modifier.HidKeyboardModifier)

proc keyboardModifierDown*(modifier: KeyboardModifier): bool =
  hidKeyboardModifierDown(modifier.HidKeyboardModifier)

proc keyboardModifierUp*(modifier: KeyboardModifier): bool =
  hidKeyboardModifierUp(modifier.HidKeyboardModifier)

proc keyboardHeld*(key: KeyboardKey): bool =
  hidKeyboardHeld(key.HidKeyboardScancode)

proc keyboardDown*(key: KeyboardKey): bool =
  hidKeyboardDown(key.HidKeyboardScancode)

proc keyboardUp*(key: KeyboardKey): bool =
  hidKeyboardUp(key.HidKeyboardScancode)

proc touchCount*(): uint32 =
  hidTouchCount()

proc touchRead*(pointId: uint32): TouchPosition =
  var touch: ptr TouchPosition
  hidTouchRead(touch, pointId)
  result = touch[]

proc joystickRead*(id: Controller, stick: ControllerJoystick): JoystickPosition =
  var pos: ptr JoystickPosition
  hidJoystickRead(pos, id.HidControllerID, stick.HidControllerJoystick)
  result = pos[]

## / This can be used to check what CONTROLLER_P1_AUTO uses.
## / Returns 0 when CONTROLLER_PLAYER_1 is connected, otherwise returns 1 for
## handheld-mode.
proc getHandheldMode*(): bool =
  hidGetHandheldMode()

## / Use this if you want to use a single joy-con as a dedicated CONTROLLER_PLAYER_*.
## / When used, both joy-cons in a pair should be used with this (CONTROLLER_PLAYER_1
## and CONTROLLER_PLAYER_2 for example).
## / id must be CONTROLLER_PLAYER_*.
proc setJoyConModeSingle*(id: Controller): Result =
  if not (id in {Controller.Player1 .. Controller.Player8}):
    raiseEx(ControllerSelectError, "Must be controller 1-8")
  hidSetNpadJoyAssignmentModeSingleByDefault(id.HidControllerId).newResult

## / Use this if you want to use a pair of joy-cons as a single CONTROLLER_PLAYER_*.
## Only necessary if you want to use this mode in your application after \ref
## hidSetNpadJoyAssignmentModeSingleByDefault was used with this pair of joy-cons.
## / Used automatically during app startup/exit for all controllers.
## / When used, both joy-cons in a pair should be used with this (CONTROLLER_PLAYER_1
## and CONTROLLER_PLAYER_2 for example).
## / id must be CONTROLLER_PLAYER_*.
proc setJoyconModeDual*(id: Controller): Result =
  if not (id in {Controller.Player1 .. Controller.Player8}):
    raiseEx(ControllerSelectError, "Must be controller 1-8")
  hidSetNpadJoyAssignmentModeDual(id.HidControllerId).newResult

## / Merge two single joy-cons into a dual-mode controller. Use this after \ref
## hidSetNpadJoyAssignmentModeDual, when \ref hidSetNpadJoyAssignmentModeSingleByDefault
## was previously used (this includes using this manually at application exit).
proc mergeSingleJoyAsDualJoy*(id1: Controller; id2: Controller): Result =
  hidMergeSingleJoyAsDualJoy(id1.HidControllerID, id2.HidControllerId).newResult


proc initializeVibrationDevices*(VibrationDeviceHandles: ptr uint32;
                                   total_handles: csize; id: HidControllerID;
                                   `type`: HidControllerType): Result =
  discard

## / Gets HidVibrationDeviceInfo for the specified VibrationDeviceHandle.
proc getVibrationDeviceInfo*(VibrationDeviceHandle: ptr uint32;
                               VibrationDeviceInfo: ptr HidVibrationDeviceInfo): Result =
  newResult(0)

## / Send the VibrationValue to the specified VibrationDeviceHandle.
proc sendVibrationValue*(VibrationDeviceHandle: ptr uint32;
                           VibrationValue: ptr HidVibrationValue): Result =
  discard

## / Gets the current HidVibrationValue for the specified VibrationDeviceHandle.
proc getActualVibrationValue*(VibrationDeviceHandle: ptr uint32;
                                VibrationValue: ptr HidVibrationValue): Result =
  discard

## / Sets whether vibration is allowed, this also affects the config displayed by
## System Settings.
proc permitVibration*(flag: bool): Result =
  discard

## / Gets whether vibration is allowed.
proc isVibrationPermitted*(flag: ptr bool): Result =
  discard

## / Send VibrationValues[index] to VibrationDeviceHandles[index], where count is the
## number of entries in the VibrationDeviceHandles/VibrationValues arrays.
proc sendVibrationValues*(VibrationDeviceHandles: ptr uint32;
                            VibrationValues: ptr HidVibrationValue; count: csize): Result =
  discard
