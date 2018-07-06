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
  VibrationError* = object of InputError
  VibrationInitError* = object of InputError
  ControllerMergeError* = object of InputError

  ####################### Shared memory data ################################
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

  ####################### END Shared memory data ################################

  VibrationDeviceInfo* = HidVibrationDeviceInfo

  VibrationValue* = HidVibrationValue

  VibrationDevice* = uint32

  JoyconMode {.pure.} = enum
    Single, Dual


proc init*(): Result = hidInitialize().newResult
proc exit*() = hidExit()
proc reset*() = hidReset()


proc getSessionService*(): Service =
  newService(hidGetSessionService()[])


proc getSharedMemory*(): ptr HidSharedMemory =
  result = cast[ptr HidSharedMemory](hidGetSharedMemAddr())


proc `layout=`*(controller: Controller, layoutType: ControllerLayoutType) =
  hidSetControllerLayout(
    HidControllerID(controller),
    HidControllerLayoutType(layoutType)
  )


proc layout*(controller: Controller): ControllerLayoutType =
  hidGetControllerLayout(HidControllerID(controller)).ControllerLayoutType


proc scanInput*() =
  ## Call this once per frame to make the rest of the procs
  ## in here poll controller data
  hidScanInput()


proc keysHeld*(controller: Controller): HashSet[ControllerKey] =
  ## Gets the keys held by the `controller`
  result = initSet[ControllerKey]()

  var raw = hidKeysHeld(HidControllerID(controller))
  for i in 0 ..< ControllerKey.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(ControllerKey(BIT(i)))
    raw = raw shr 1


proc keysDown*(controller: Controller): HashSet[ControllerKey] =
  ## Gets the keys that are pressed at the moment by the `controller`
  result = initSet[ControllerKey]()

  var raw = hidKeysDown(HidControllerID(controller))
  for i in 0 ..< ControllerKey.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(ControllerKey(BIT(i)))
    raw = raw shr 1


proc keysUp*(controller: Controller): HashSet[ControllerKey] =
  ## Gets the keys that are not pressed at the moment by the `controller`
  result = initSet[ControllerKey]()

  var raw = hidKeysUp(HidControllerID(controller))
  for i in 0 ..< ControllerKey.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(ControllerKey(BIT(i)))
    raw = raw shr 1


proc mouseButtonsHeld*(): HashSet[MouseButton] =
  result = initSet[MouseButton]()

  var raw = hidMouseButtonsHeld()
  for i in 0 ..< MouseButton.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(MouseButton(BIT(i)))
    raw = raw shr 1


proc mouseButtonsDown*(): HashSet[MouseButton] =
  result = initSet[MouseButton]()

  var raw = hidMouseButtonsDown()
  for i in 0 ..< MouseButton.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(MouseButton(BIT(i)))
    raw = raw shr 1

proc mouseButtonsUp*(): HashSet[MouseButton] =
  result = initSet[MouseButton]()

  var raw = hidMouseButtonsUp()
  for i in 0 ..< MouseButton.size:
    let bit = raw and 0x1
    if bit == 1:
      result.incl(MouseButton(BIT(i)))
    raw = raw shr 1


proc readMouse*(): MousePosition =
  hidMouseRead(result.addr)


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


proc keyboardKeysDown*(): HashSet[KeyboardKey] =
  ## Get all keyboard keys currently down, excluding modifiers
  result = initSet[KeyboardKey]()

  for i in KeyboardKey.low..KeyboardKey.high:
    let key = KeyboardKey(i)
    if keyboardDown(key):
      result.incl(key)


proc keyboardKeysUp*(): HashSet[KeyboardKey] =
  ## Get all keyboard keys currently up, excluding modifiers
  result = initSet[KeyboardKey]()

  for i in KeyboardKey.low..KeyboardKey.high:
    let key = KeyboardKey(i)
    if keyboardUp(key):
      result.incl(key)


proc keyboardKeysHeld*(): HashSet[KeyboardKey] =
  ## Get all keyboard keys currently held, excluding modifiers
  result = initSet[KeyboardKey]()

  for i in KeyboardKey.low..KeyboardKey.high:
    let key = KeyboardKey(i)
    if keyboardHeld(key):
      result.incl(key)


proc keyboardModifiersHeld*(): HashSet[KeyboardModifier] =
  ## Get all keyboard modifiers currently held
  result = initSet[KeyboardModifier]()

  for i in 0..KeyboardModifier.size:
    let key = KeyboardModifier(BIT(i))
    if keyboardModifierHeld(key):
      result.incl(key)


proc keyboardModifiersDown*(): HashSet[KeyboardModifier] =
  ## Get all keyboard modifiers currently down
  result = initSet[KeyboardModifier]()

  for i in 0..KeyboardModifier.size:
    let key = KeyboardModifier(BIT(i))
    if keyboardModifierDown(key):
      result.incl(key)

proc keyboardModifiersUp*(): HashSet[KeyboardModifier] =
  ## Get all keyboard modifiers currently up
  result = initSet[KeyboardModifier]()

  for i in 0..KeyboardModifier.size:
    let key = KeyboardModifier(BIT(i))
    if keyboardModifierUp(key):
      result.incl(key)


proc touchCount*(): uint32 =
  hidTouchCount()


proc readTouch*(pointId: uint32): TouchPosition =
  hidTouchRead(result.addr, pointId)


proc readJoystick*(id: Controller, stick: ControllerJoystick): JoystickPosition =
  hidJoystickRead(result.addr, id.HidControllerID, stick.HidControllerJoystick)


proc isHandheldMode*(): bool =
  ## / This can be used to check what CONTROLLER_P1_AUTO uses.
  ## / Returns 0 when CONTROLLER_PLAYER_1 is connected, otherwise returns 1 for
  ## handheld-mode.
  hidGetHandheldMode()


proc `joyconMode=`*(id: Controller, mode: JoyconMode) =
  ## Sets the joycon mode to either single or dual
  if id notin {Controller.Player1 .. Controller.Player8}:
    raiseEx(ControllerSelectError, "Must be controller 1-8")

  var rc: Result

  case mode:
    of JoyconMode.Single:
      rc = hidSetNpadJoyAssignmentModeSingleByDefault(id.HidControllerId).newResult
    of JoyconMode.Dual:
      rc = hidSetNpadJoyAssignmentModeDual(id.HidControllerId).newResult

  if rc.failed:
    raiseEx(ControllerMergeError, "Could not set joycon mode to " & $mode, rc)


proc mergeJoycons*(id1: Controller; id2: Controller) =
  ## / Merge two single joy-cons into a dual-mode controller. Use this after \ref
  ## hidSetNpadJoyAssignmentModeDual, when \ref hidSetNpadJoyAssignmentModeSingleByDefault
  ## was previously used (this includes using this manually at application exit).
  let rc = hidMergeSingleJoyAsDualJoy(
    id1.HidControllerID,
    id2.HidControllerID
  ).newResult

  if rc.failed:
    raiseEx(ControllerMergeError, "Could not merge joycons", rc)


proc initializeVibrationDevices*(
    controller: Controller,
    controllerTypes: openArray[ControllerType]
    ): seq[VibrationDevice] =
  result = @[]

  for ctype in controllerTypes:
    var devs: array[2, VibrationDevice]
    var numDevices = 2

    if ctype == ControllerType.JoyconLeft or ctype == ControllerType.JoyconRight:
      numDevices = 1

    let rc = hidInitializeVibrationDevices(
      devs[0].addr, numDevices, HidControllerID(controller),
      HidControllerType(ctype)
    ).newResult

    if rc.failed:
      raiseEx(
        VibrationInitError,
        "Could not init vibration for controller #$ with type #$" %
        [$controller, $ctype]
      )
    for i in 0 ..< numDevices:
      result.add(devs[i])


proc info*(device: VibrationDevice): VibrationDeviceInfo =
  ## / Gets HidVibrationDeviceInfo for the specified VibrationDeviceHandle.
  let rc = hidGetVibrationDeviceInfo(device.unsafeAddr, result.addr).newResult

  if rc.failed:
    raiseEx(VibrationError, "Could not get vibration device info", rc)

proc `vibration=`*(device: VibrationDevice, value: VibrationValue) =
  ## / Send the value to the specified handle.
  let rc = hidSendVibrationValue(device.unsafeAddr, value.unsafeAddr).newResult

  if rc.failed:
    raiseEx(VibrationError, "Could not send vibration value", rc)

proc vibration*(device: VibrationDevice): VibrationValue =
  ## / Gets the current HidVibrationValue for the specified VibrationDeviceHandle.
  let rc = hidGetActualVibrationValue(device.unsafeAddr, result.addr).newResult

  if rc.failed:
    raiseEx(VibrationError, "Could not get vibration value", rc)

proc permitVibration*(flag: bool) =
  ## / Sets whether vibration is allowed, this also affects the config displayed by
  ## System Settings.
  let rc = hidPermitVibration(flag).newResult

  if rc.failed:
    raiseEx(VibrationError, "Unable to permit vibration", rc)

proc isVibrationPermitted*(): bool =
  ## / Gets whether vibration is allowed.
  let rc = hidIsVibrationPermitted(result.addr).newResult
  if rc.failed:
    raiseEx(VibrationError, "Error getting vibration information", rc)

proc sendVibrationValues*(
    devices: openArray[VibrationDevice],
    values: openArray[VibrationValue]) =
  ## / Send VibrationValues[index] to VibrationDeviceHandles[index], where count is the
  ## number of entries in the VibrationDeviceHandles/VibrationValues arrays.
  let sizeH = len(devices)
  let sizeV = len(values)

  if sizeH != sizeV:
    raiseEx(
      VibrationError,
      "Vibration arrays must be the same size. handles $# != values $#" %
      [$sizeH, $sizeV]
    )

  let rc = hidSendVibrationValues(
    devices[0].unsafeAddr, values[0].unsafeAddr, sizeH
  ).newResult

  if rc.failed:
    raiseEx(VibrationError, "Unable to send vibration error", rc)
