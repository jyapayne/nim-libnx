## *
##  @file pad.h
##  @brief Simple wrapper for the HID Npad API.
##  @author fincs
##  @copyright libnx Authors
##

import
  ../types, ../services/hid

## / Mask including all existing controller IDs.

const
  PAD_ANY_ID_MASK* = 0x1000100FF'u

## / Pad state object.

type
  PadState* {.bycopy.} = object
    idMask*: U8
    activeIdMask*: U8
    readHandheld*: bool
    activeHandheld*: bool
    styleSet*: U32
    attributes*: U32
    buttonsCur*: U64
    buttonsOld*: U64
    sticks*: array[2, HidAnalogStickState]
    gcTriggers*: array[2, U32]


## / Pad button repeater state object.

type
  PadRepeater* {.bycopy.} = object
    buttonMask*: U64
    counter*: S32
    delay*: U16
    repeat*: U16


## *
##  @brief Configures the input layout supported by the application.
##  @param[in] max_players The maximum supported number of players (1 to 8).
##  @param[in] style_set Bitfield of supported controller styles (see \ref HidNpadStyleTag).
##

proc padConfigureInput*(maxPlayers: U32; styleSet: U32) {.cdecl,
    importc: "padConfigureInput".}
## *
##  @brief Initializes a \ref PadState object to read input from one or more controller input sources.
##  @param[in] _pad Pointer to \ref PadState.
##  @remarks This is a variadic macro, pass the \ref HidNpadIdType value of each controller to add to the set.
##


##  @brief Same as \ref padInitialize, but taking a bitfield of controller IDs directly.
##  @param[in] pad Pointer to \ref PadState.
##  @param[in] mask Bitfield of controller IDs (each bit's position indicates a different \ref HidNpadIdType value).
proc padInitializeWithMask*(pad: ptr PadState, mask: U64) {.inline, cdecl, importc: "padInitializeWithMask".}

proc padInitialize*(pad: ptr PadState, padIds: varargs[HidNpadIdType]) {.inline, cdecl.} =
  var mask: U64 = 0
  for i in 0..<padIds.len:
    mask = mask or (1'u64 shl padIds[i].uint64)
  padInitializeWithMask(pad, mask)

## *
##  @brief Same as \ref padInitialize, but including every single controller input source.
##  @param[in] pad Pointer to \ref PadState.
##  @remark Use this function if you want to accept input from any controller.
##

proc padInitializeAny*(pad: ptr PadState) {.inline, cdecl, importc: "padInitializeAny".} =
  padInitializeWithMask(pad, Pad_Any_Id_Mask)

## *
##  @brief Same as \ref padInitialize, but including \ref HidNpadIdType_No1 and \ref HidNpadIdType_Handheld.
##  @param[in] pad Pointer to \ref PadState.
##  @remark Use this function if you just want to accept input for a single-player application.
##

proc padInitializeDefault*(pad: ptr PadState) {.inline, cdecl,
    importc: "padInitializeDefault".} =
    padInitialize(pad, HidNpadIdTypeNo1, HidNpadIdTypeHandheld)

## *
##  @brief Updates pad state by reading from the controller input sources specified during initialization.
##  @param[in] pad Pointer to \ref PadState.
##

proc padUpdate*(pad: ptr PadState) {.cdecl, importc: "padUpdate".}
## *
##  @brief Retrieves whether \ref HidNpadIdType_Handheld is an active input source (i.e. it was possible to read from it).
##  @param[in] pad Pointer to \ref PadState.
##  @return Boolean value.
##  @remark \ref padUpdate must have been previously called.
##

proc padIsHandheld*(pad: ptr PadState): bool {.inline, cdecl, importc: "padIsHandheld".} =
  return pad.activeHandheld

## *
##  @brief Retrieves whether the specified controller is an active input source (i.e. it was possible to read from it).
##  @param[in] pad Pointer to \ref PadState.
##  @param[in] id ID of the controller input source (see \ref HidNpadIdType)
##  @return Boolean value.
##  @remark \ref padUpdate must have been previously called.
##

proc padIsNpadActive*(pad: ptr PadState; id: HidNpadIdType): bool {.inline, cdecl,
    importc: "padIsNpadActive".} =
  if id <= HidNpadIdTypeNo8:
    return bool(pad.activeIdMask and (bit(id.uint8)))
  elif id == HidNpadIdTypeHandheld:
    return pad.activeHandheld
  else:
    return false

## *
##  @brief Retrieves the set of input styles supported by the selected controller input sources.
##  @param[in] pad Pointer to \ref PadState.
##  @return Bitfield of \ref HidNpadStyleTag.
##  @remark \ref padUpdate must have been previously called.
##

proc padGetStyleSet*(pad: ptr PadState): U32 {.inline, cdecl, importc: "padGetStyleSet".} =
  return pad.styleSet

## *
##  @brief Retrieves the set of attributes reported by the system for the selected controller input sources.
##  @param[in] pad Pointer to \ref PadState.
##  @return Bitfield of \ref HidNpadAttribute.
##  @remark \ref padUpdate must have been previously called.
##

proc padGetAttributes*(pad: ptr PadState): U32 {.inline, cdecl,
    importc: "padGetAttributes".} =
  return pad.attributes

## *
##  @brief Retrieves whether any of the selected controller input sources is connected.
##  @param[in] pad Pointer to \ref PadState.
##  @return Boolean value.
##  @remark \ref padUpdate must have been previously called.
##

proc padIsConnected*(pad: ptr PadState): bool {.inline, cdecl,
    importc: "padIsConnected".} =
  return bool(pad.attributes and HidNpadAttributeIsConnected.uint32)

## *
##  @brief Retrieves the current set of pressed buttons across all selected controller input sources.
##  @param[in] pad Pointer to \ref PadState.
##  @return Bitfield of \ref HidNpadButton.
##  @remark \ref padUpdate must have been previously called.
##

proc padGetButtons*(pad: ptr PadState): U64 {.inline, cdecl, importc: "padGetButtons".} =
  return pad.buttonsCur

## *
##  @brief Retrieves the set of buttons that are newly pressed.
##  @param[in] pad Pointer to \ref PadState.
##  @return Bitfield of \ref HidNpadButton.
##  @remark \ref padUpdate must have been previously called.
##

proc padGetButtonsDown*(pad: ptr PadState): U64 {.inline, cdecl,
    importc: "padGetButtonsDown".} =
  return not pad.buttonsOld and pad.buttonsCur

## *
##  @brief Retrieves the set of buttons that are newly released.
##  @param[in] pad Pointer to \ref PadState.
##  @return Bitfield of \ref HidNpadButton.
##  @remark \ref padUpdate must have been previously called.
##

proc padGetButtonsUp*(pad: ptr PadState): U64 {.inline, cdecl,
    importc: "padGetButtonsUp".} =
  return pad.buttonsOld and not pad.buttonsCur

## *
##  @brief Retrieves the position of an analog stick in a controller.
##  @param[in] pad Pointer to \ref PadState.
##  @param[in] i ID of the analog stick to read (0=left, 1=right).
##  @return \ref HidAnalogStickState.
##  @remark \ref padUpdate must have been previously called.
##

proc padGetStickPos*(pad: ptr PadState; i: cuint): HidAnalogStickState {.inline, cdecl,
    importc: "padGetStickPos".} =
  return pad.sticks[i]

## *
##  @brief Retrieves the position of an analog trigger in a GameCube controller.
##  @param[in] pad Pointer to \ref PadState.
##  @param[in] i ID of the analog trigger to read (0=left, 1=right).
##  @return Analog trigger position (range is 0 to 0x7fff).
##  @remark \ref padUpdate must have been previously called.
##  @remark \ref HidNpadStyleTag_NpadGc must have been previously configured as a supported style in \ref padConfigureInput for GC trigger data to be readable.
##

proc padGetGcTriggerPos*(pad: ptr PadState; i: cuint): U32 {.inline, cdecl,
    importc: "padGetGcTriggerPos".} =
  return pad.gcTriggers[i]

## *
##  @brief Initializes a \ref PadRepeater object with the specified settings.
##  @param[in] r Pointer to \ref PadRepeater.
##  @param[in] delay Number of input updates between button presses being first detected and them being considered for repeat.
##  @param[in] repeat Number of input updates between autogenerated repeat button presses.
##

proc padRepeaterInitialize*(r: ptr PadRepeater; delay: U16; repeat: U16) {.inline, cdecl,
    importc: "padRepeaterInitialize".} =
  r.buttonMask = 0
  r.counter = 0
  r.delay = delay
  r.repeat = repeat

## *
##  @brief Updates pad repeat state.
##  @param[in] r Pointer to \ref PadRepeater.
##  @param[in] button_mask Bitfield of currently pressed \ref HidNpadButton that will be considered for repeat.
##

proc padRepeaterUpdate*(r: ptr PadRepeater; buttonMask: U64) {.cdecl,
    importc: "padRepeaterUpdate".}
## *
##  @brief Retrieves the set of buttons that are being repeated according to the parameters specified in \ref padRepeaterInitialize.
##  @param[in] r Pointer to \ref PadRepeater.
##  @return Bitfield of \ref HidNpadButton.
##  @remark It is suggested to bitwise-OR the return value of this function with that of \ref padGetButtonsDown.
##

proc padRepeaterGetButtons*(r: ptr PadRepeater): U64 {.inline, cdecl,
    importc: "padRepeaterGetButtons".} =
  return if r.counter == 0: r.buttonMask else: 0
