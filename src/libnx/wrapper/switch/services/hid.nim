## *
##  @file hid.h
##  @brief Human input device (hid) service IPC wrapper.
##  @author shinyquagsire23
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../services/btdrv_types, ../sf/service

##  Begin enums and output structs
## / HidDebugPadButton

type
  HidDebugPadButton* = enum
    HidDebugPadButtonA = bit(0), ## /< A button
    HidDebugPadButtonB = bit(1), ## /< B button
    HidDebugPadButtonX = bit(2), ## /< X button
    HidDebugPadButtonY = bit(3), ## /< Y button
    HidDebugPadButtonL = bit(4), ## /< L button
    HidDebugPadButtonR = bit(5), ## /< R button
    HidDebugPadButtonZL = bit(6), ## /< ZL button
    HidDebugPadButtonZR = bit(7), ## /< ZR button
    HidDebugPadButtonStart = bit(8), ## /< Start button
    HidDebugPadButtonSelect = bit(9), ## /< Select button
    HidDebugPadButtonLeft = bit(10), ## /< D-Pad Left button
    HidDebugPadButtonUp = bit(11), ## /< D-Pad Up button
    HidDebugPadButtonRight = bit(12), ## /< D-Pad Right button
    HidDebugPadButtonDown = bit(13) ## /< D-Pad Down button


## / HidTouchScreenModeForNx

type
  HidTouchScreenModeForNx* = enum
    HidTouchScreenModeForNxUseSystemSetting = 0, ## /< UseSystemSetting
    HidTouchScreenModeForNxFinger = 1, ## /< Finger
    HidTouchScreenModeForNxHeat2 = 2 ## /< Heat2


## / HidMouseButton

type
  HidMouseButton* = enum
    HidMouseButtonLeft = bit(0), HidMouseButtonRight = bit(1),
    HidMouseButtonMiddle = bit(2), HidMouseButtonForward = bit(3),
    HidMouseButtonBack = bit(4)


## / HidKeyboardKey

type
  HidKeyboardKey* = enum
    HidKeyboardKeyA = 4, HidKeyboardKeyB = 5, HidKeyboardKeyC = 6, HidKeyboardKeyD = 7,
    HidKeyboardKeyE = 8, HidKeyboardKeyF = 9, HidKeyboardKeyG = 10, HidKeyboardKeyH = 11,
    HidKeyboardKeyI = 12, HidKeyboardKeyJ = 13, HidKeyboardKeyK = 14,
    HidKeyboardKeyL = 15, HidKeyboardKeyM = 16, HidKeyboardKeyN = 17,
    HidKeyboardKeyO = 18, HidKeyboardKeyP = 19, HidKeyboardKeyQ = 20,
    HidKeyboardKeyR = 21, HidKeyboardKeyS = 22, HidKeyboardKeyT = 23,
    HidKeyboardKeyU = 24, HidKeyboardKeyV = 25, HidKeyboardKeyW = 26,
    HidKeyboardKeyX = 27, HidKeyboardKeyY = 28, HidKeyboardKeyZ = 29,
    HidKeyboardKeyD1 = 30, HidKeyboardKeyD2 = 31, HidKeyboardKeyD3 = 32,
    HidKeyboardKeyD4 = 33, HidKeyboardKeyD5 = 34, HidKeyboardKeyD6 = 35,
    HidKeyboardKeyD7 = 36, HidKeyboardKeyD8 = 37, HidKeyboardKeyD9 = 38,
    HidKeyboardKeyD0 = 39, HidKeyboardKeyReturn = 40, HidKeyboardKeyEscape = 41,
    HidKeyboardKeyBackspace = 42, HidKeyboardKeyTab = 43, HidKeyboardKeySpace = 44,
    HidKeyboardKeyMinus = 45, HidKeyboardKeyPlus = 46, HidKeyboardKeyOpenBracket = 47,
    HidKeyboardKeyCloseBracket = 48, HidKeyboardKeyPipe = 49,
    HidKeyboardKeyTilde = 50, HidKeyboardKeySemicolon = 51, HidKeyboardKeyQuote = 52,
    HidKeyboardKeyBackquote = 53, HidKeyboardKeyComma = 54, HidKeyboardKeyPeriod = 55,
    HidKeyboardKeySlash = 56, HidKeyboardKeyCapsLock = 57, HidKeyboardKeyF1 = 58,
    HidKeyboardKeyF2 = 59, HidKeyboardKeyF3 = 60, HidKeyboardKeyF4 = 61,
    HidKeyboardKeyF5 = 62, HidKeyboardKeyF6 = 63, HidKeyboardKeyF7 = 64,
    HidKeyboardKeyF8 = 65, HidKeyboardKeyF9 = 66, HidKeyboardKeyF10 = 67,
    HidKeyboardKeyF11 = 68, HidKeyboardKeyF12 = 69, HidKeyboardKeyPrintScreen = 70,
    HidKeyboardKeyScrollLock = 71, HidKeyboardKeyPause = 72,
    HidKeyboardKeyInsert = 73, HidKeyboardKeyHome = 74, HidKeyboardKeyPageUp = 75,
    HidKeyboardKeyDelete = 76, HidKeyboardKeyEnd = 77, HidKeyboardKeyPageDown = 78,
    HidKeyboardKeyRightArrow = 79, HidKeyboardKeyLeftArrow = 80,
    HidKeyboardKeyDownArrow = 81, HidKeyboardKeyUpArrow = 82,
    HidKeyboardKeyNumLock = 83, HidKeyboardKeyNumPadDivide = 84,
    HidKeyboardKeyNumPadMultiply = 85, HidKeyboardKeyNumPadSubtract = 86,
    HidKeyboardKeyNumPadAdd = 87, HidKeyboardKeyNumPadEnter = 88,
    HidKeyboardKeyNumPad1 = 89, HidKeyboardKeyNumPad2 = 90,
    HidKeyboardKeyNumPad3 = 91, HidKeyboardKeyNumPad4 = 92,
    HidKeyboardKeyNumPad5 = 93, HidKeyboardKeyNumPad6 = 94,
    HidKeyboardKeyNumPad7 = 95, HidKeyboardKeyNumPad8 = 96,
    HidKeyboardKeyNumPad9 = 97, HidKeyboardKeyNumPad0 = 98,
    HidKeyboardKeyNumPadDot = 99, HidKeyboardKeyBackslash = 100,
    HidKeyboardKeyApplication = 101, HidKeyboardKeyPower = 102,
    HidKeyboardKeyNumPadEquals = 103, HidKeyboardKeyF13 = 104,
    HidKeyboardKeyF14 = 105, HidKeyboardKeyF15 = 106, HidKeyboardKeyF16 = 107,
    HidKeyboardKeyF17 = 108, HidKeyboardKeyF18 = 109, HidKeyboardKeyF19 = 110,
    HidKeyboardKeyF20 = 111, HidKeyboardKeyF21 = 112, HidKeyboardKeyF22 = 113,
    HidKeyboardKeyF23 = 114, HidKeyboardKeyF24 = 115, HidKeyboardKeyNumPadComma = 133,
    HidKeyboardKeyRo = 135, HidKeyboardKeyKatakanaHiragana = 136,
    HidKeyboardKeyYen = 137, HidKeyboardKeyHenkan = 138, HidKeyboardKeyMuhenkan = 139,
    HidKeyboardKeyNumPadCommaPc98 = 140, HidKeyboardKeyHangulEnglish = 144,
    HidKeyboardKeyHanja = 145, HidKeyboardKeyKatakana = 146,
    HidKeyboardKeyHiragana = 147, HidKeyboardKeyZenkakuHankaku = 148,
    HidKeyboardKeyLeftControl = 224, HidKeyboardKeyLeftShift = 225,
    HidKeyboardKeyLeftAlt = 226, HidKeyboardKeyLeftGui = 227,
    HidKeyboardKeyRightControl = 228, HidKeyboardKeyRightShift = 229,
    HidKeyboardKeyRightAlt = 230, HidKeyboardKeyRightGui = 231


## / HidKeyboardModifier

type
  HidKeyboardModifier* = enum
    HidKeyboardModifierControl = bit(0), HidKeyboardModifierShift = bit(1),
    HidKeyboardModifierLeftAlt = bit(2), HidKeyboardModifierRightAlt = bit(3),
    HidKeyboardModifierGui = bit(4), HidKeyboardModifierCapsLock = bit(8),
    HidKeyboardModifierScrollLock = bit(9), HidKeyboardModifierNumLock = bit(10),
    HidKeyboardModifierKatakana = bit(11), HidKeyboardModifierHiragana = bit(12)


## / KeyboardLockKeyEvent

type
  HidKeyboardLockKeyEvent* = enum
    HidKeyboardLockKeyEventNumLockOn = bit(0), ## /< NumLockOn
    HidKeyboardLockKeyEventNumLockOff = bit(1), ## /< NumLockOff
    HidKeyboardLockKeyEventNumLockToggle = bit(2), ## /< NumLockToggle
    HidKeyboardLockKeyEventCapsLockOn = bit(3), ## /< CapsLockOn
    HidKeyboardLockKeyEventCapsLockOff = bit(4), ## /< CapsLockOff
    HidKeyboardLockKeyEventCapsLockToggle = bit(5), ## /< CapsLockToggle
    HidKeyboardLockKeyEventScrollLockOn = bit(6), ## /< ScrollLockOn
    HidKeyboardLockKeyEventScrollLockOff = bit(7), ## /< ScrollLockOff
    HidKeyboardLockKeyEventScrollLockToggle = bit(8) ## /< ScrollLockToggle


## / HID controller IDs

type
  HidNpadIdType* = enum
    HidNpadIdTypeNo1 = 0,       ## /< Player 1 controller
    HidNpadIdTypeNo2 = 1,       ## /< Player 2 controller
    HidNpadIdTypeNo3 = 2,       ## /< Player 3 controller
    HidNpadIdTypeNo4 = 3,       ## /< Player 4 controller
    HidNpadIdTypeNo5 = 4,       ## /< Player 5 controller
    HidNpadIdTypeNo6 = 5,       ## /< Player 6 controller
    HidNpadIdTypeNo7 = 6,       ## /< Player 7 controller
    HidNpadIdTypeNo8 = 7,       ## /< Player 8 controller
    HidNpadIdTypeOther = 0x10,  ## /< Other controller
    HidNpadIdTypeHandheld = 0x20 ## /< Handheld mode controls


## / HID controller styles

type
  HidNpadStyleTag* = enum
    HidNpadStyleTagNpadFullKey = bit(0), ## /< Pro Controller
    HidNpadStyleTagNpadHandheld = bit(1), ## /< Joy-Con controller in handheld mode
    HidNpadStyleTagNpadJoyDual = bit(2), ## /< Joy-Con controller in dual mode
    HidNpadStyleSetNpadFullCtrl = HidNpadStyleTagNpadFullKey.int or
        HidNpadStyleTagNpadHandheld.int or HidNpadStyleTagNpadJoyDual.int, ## /< Style set comprising Npad styles containing the full set of controls {FullKey, Handheld, JoyDual}
    HidNpadStyleTagNpadJoyLeft = bit(3), ## /< Joy-Con left controller in single mode
    HidNpadStyleTagNpadJoyRight = bit(4), ## /< Joy-Con right controller in single mode
    HidNpadStyleSetNpadStandard = HidNpadStyleSetNpadFullCtrl.int or
        HidNpadStyleTagNpadJoyLeft.int or HidNpadStyleTagNpadJoyRight.int ## /< Style set comprising all standard Npad styles {FullKey, Handheld, JoyDual, JoyLeft, JoyRight}
    HidNpadStyleTagNpadGc = bit(5), ## /< GameCube controller
    HidNpadStyleTagNpadPalma = bit(6), ## /< Poké Ball Plus controller
    HidNpadStyleTagNpadLark = bit(7), ## /< NES/Famicom controller
    HidNpadStyleTagNpadHandheldLark = bit(8), ## /< NES/Famicom controller in handheld mode
    HidNpadStyleTagNpadLucia = bit(9), ## /< SNES controller
    HidNpadStyleTagNpadLagon = bit(10), ## /< N64 controller
    HidNpadStyleTagNpadLager = bit(11), ## /< Sega Genesis controller
    HidNpadStyleTagNpadSystemExt = bit(29), ## /< Generic external controller
    HidNpadStyleTagNpadSystem = bit(30), ## /< Generic controller


## / HidColorAttribute

type
  HidColorAttribute* = enum
    HidColorAttributeOk = 0,    ## /< Ok
    HidColorAttributeReadError = 1, ## /< ReadError
    HidColorAttributeNoController = 2 ## /< NoController


## / HidNpadButton

type
  HidNpadButton*{.size: sizeof(uint64).} = enum
    HidNpadButtonA = bitl(0),   ## /< A button / Right face button
    HidNpadButtonB = bitl(1),   ## /< B button / Down face button
    HidNpadButtonX = bitl(2),   ## /< X button / Up face button
    HidNpadButtonY = bitl(3),   ## /< Y button / Left face button
    HidNpadButtonStickL = bitl(4), ## /< Left Stick button
    HidNpadButtonStickR = bitl(5), ## /< Right Stick button
    HidNpadButtonL = bitl(6),   ## /< L button
    HidNpadButtonR = bitl(7),   ## /< R button
    HidNpadButtonZL = bitl(8),  ## /< ZL button
    HidNpadButtonZR = bitl(9),  ## /< ZR button
    HidNpadButtonPlus = bitl(10), ## /< Plus button
    HidNpadButtonMinus = bitl(11), ## /< Minus button
    HidNpadButtonLeft = bitl(12), ## /< D-Pad Left button
    HidNpadButtonUp = bitl(13), ## /< D-Pad Up button
    HidNpadButtonRight = bitl(14), ## /< D-Pad Right button
    HidNpadButtonDown = bitl(15), ## /< D-Pad Down button
    HidNpadButtonStickLLeft = bitl(16), ## /< Left Stick pseudo-button when moved Left
    HidNpadButtonStickLUp = bitl(17), ## /< Left Stick pseudo-button when moved Up
    HidNpadButtonStickLRight = bitl(18), ## /< Left Stick pseudo-button when moved Right
    HidNpadButtonStickLDown = bitl(19), ## /< Left Stick pseudo-button when moved Down
    HidNpadButtonStickRLeft = bitl(20), ## /< Right Stick pseudo-button when moved Left
    HidNpadButtonAnyLeft = HidNpadButtonLeft.cint or HidNpadButtonStickLLeft.cint or
        HidNpadButtonStickRLeft.cint, ## /< Bitmask containing all buttons that are considered Left (D-Pad, Sticks)
    HidNpadButtonStickRUp = bitl(21), ## /< Right Stick pseudo-button when moved Up
    HidNpadButtonAnyUp = HidNpadButtonUp.cint or HidNpadButtonStickLUp.cint or
        HidNpadButtonStickRUp.cint, ## /< Bitmask containing all buttons that are considered Up (D-Pad, Sticks)
    HidNpadButtonStickRRight = bitl(22), ## /< Right Stick pseudo-button when moved Right
    HidNpadButtonAnyRight = HidNpadButtonRight.cint or HidNpadButtonStickLRight.cint or
        HidNpadButtonStickRRight.cint, ## /< Bitmask containing all buttons that are considered Right (D-Pad, Sticks)
    HidNpadButtonStickRDown = bitl(23), ## /< Right Stick pseudo-button when moved Left
    HidNpadButtonAnyDown = HidNpadButtonDown.cint or HidNpadButtonStickLDown.cint or
        HidNpadButtonStickRDown.cint, ## /< Bitmask containing all buttons that are considered Down (D-Pad, Sticks)
    HidNpadButtonLeftSL = bitl(24), ## /< SL button on Left Joy-Con
    HidNpadButtonLeftSR = bitl(25), ## /< SR button on Left Joy-Con
    HidNpadButtonRightSL = bitl(26), ## /< SL button on Right Joy-Con
    HidNpadButtonAnySL = HidNpadButtonLeftSL.cint or HidNpadButtonRightSL.cint, ## /< Bitmask containing SL buttons on both Joy-Cons (Left/Right)
    HidNpadButtonRightSR = bitl(27), ## /< SR button on Right Joy-Con
    HidNpadButtonAnySR = HidNpadButtonLeftSR.cint or HidNpadButtonRightSR.cint ## /< Bitmask containing SR buttons on both Joy-Cons (Left/Right)
    HidNpadButtonPalma = bitl(28), ## /< Top button on Poké Ball Plus (Palma) controller
    HidNpadButtonVerification = bitl(29), ## /< Verification
    HidNpadButtonHandheldLeftB = bitl(30), ## /< B button on Left NES/HVC controller in Handheld mode
    HidNpadButtonLagonCLeft = bitl(31), ## /< Left C button in N64 controller
    HidNpadButtonLagonCUp = bitl(32), ## /< Up C button in N64 controller
    HidNpadButtonLagonCRight = bitl(33), ## /< Right C button in N64 controller
    HidNpadButtonLagonCDown = bitl(34), ## /< Down C button in N64 controller


## / HidDebugPadAttribute

type
  HidDebugPadAttribute* = enum
    HidDebugPadAttributeIsConnected = bit(0) ## /< IsConnected


## / HidTouchAttribute

type
  HidTouchAttribute* = enum
    HidTouchAttributeStart = bit(0), ## /< Start
    HidTouchAttributeEnd = bit(1) ## /< End


## / HidMouseAttribute

type
  HidMouseAttribute* = enum
    HidMouseAttributeTransferable = bit(0), ## /< Transferable
    HidMouseAttributeIsConnected = bit(1) ## /< IsConnected


## / HidNpadAttribute

type
  HidNpadAttribute* = enum
    HidNpadAttributeIsConnected = bit(0), ## /< IsConnected
    HidNpadAttributeIsWired = bit(1), ## /< IsWired
    HidNpadAttributeIsLeftConnected = bit(2), ## /< IsLeftConnected
    HidNpadAttributeIsLeftWired = bit(3), ## /< IsLeftWired
    HidNpadAttributeIsRightConnected = bit(4), ## /< IsRightConnected
    HidNpadAttributeIsRightWired = bit(5) ## /< IsRightWired


## / HidSixAxisSensorAttribute

type
  HidSixAxisSensorAttribute* = enum
    HidSixAxisSensorAttributeIsConnected = bit(0), ## /< IsConnected
    HidSixAxisSensorAttributeIsInterpolated = bit(1) ## /< IsInterpolated


## / HidGestureAttribute

type
  HidGestureAttribute* = enum
    HidGestureAttributeIsNewTouch = bit(4), ## /< IsNewTouch
    HidGestureAttributeIsDoubleTap = bit(8) ## /< IsDoubleTap


## / HidGestureDirection

type
  HidGestureDirection* = enum
    HidGestureDirectionNone = 0, ## /< None
    HidGestureDirectionLeft = 1, ## /< Left
    HidGestureDirectionUp = 2,  ## /< Up
    HidGestureDirectionRight = 3, ## /< Right
    HidGestureDirectionDown = 4 ## /< Down


## / HidGestureType

type
  HidGestureType* = enum
    HidGestureTypeIdle = 0,     ## /< Idle
    HidGestureTypeComplete = 1, ## /< Complete
    HidGestureTypeCancel = 2,   ## /< Cancel
    HidGestureTypeTouch = 3,    ## /< Touch
    HidGestureTypePress = 4,    ## /< Press
    HidGestureTypeTap = 5,      ## /< Tap
    HidGestureTypePan = 6,      ## /< Pan
    HidGestureTypeSwipe = 7,    ## /< Swipe
    HidGestureTypePinch = 8,    ## /< Pinch
    HidGestureTypeRotate = 9    ## /< Rotate


## / GyroscopeZeroDriftMode

type
  HidGyroscopeZeroDriftMode* = enum
    HidGyroscopeZeroDriftModeLoose = 0, ## /< Loose
    HidGyroscopeZeroDriftModeStandard = 1, ## /< Standard
    HidGyroscopeZeroDriftModeTight = 2 ## /< Tight


## / NpadJoyHoldType

type
  HidNpadJoyHoldType* = enum
    HidNpadJoyHoldTypeVertical = 0, ## /< Default / Joy-Con held vertically.
    HidNpadJoyHoldTypeHorizontal = 1 ## /< Joy-Con held horizontally.


## / NpadJoyDeviceType

type
  HidNpadJoyDeviceType* = enum
    HidNpadJoyDeviceTypeLeft = 0, ## /< Left
    HidNpadJoyDeviceTypeRight = 1 ## /< Right


## / This controls how many Joy-Cons must be attached for handheld-mode to be activated.

type
  HidNpadHandheldActivationMode* = enum
    HidNpadHandheldActivationModeDual = 0, ## /< Dual (2 Joy-Cons)
    HidNpadHandheldActivationModeSingle = 1, ## /< Single (1 Joy-Con)
    HidNpadHandheldActivationModeNone = 2 ## /< None (0 Joy-Cons)


## / NpadJoyAssignmentMode

type
  HidNpadJoyAssignmentMode* = enum
    HidNpadJoyAssignmentModeDual = 0, ## /< Dual (Set by \ref hidSetNpadJoyAssignmentModeDual)
    HidNpadJoyAssignmentModeSingle = 1 ## /< Single (Set by hidSetNpadJoyAssignmentModeSingle*())


## / NpadCommunicationMode

type
  HidNpadCommunicationMode* = enum
    HidNpadCommunicationMode5ms = 0, ## /< 5ms
    HidNpadCommunicationMode10ms = 1, ## /< 10ms
    HidNpadCommunicationMode15ms = 2, ## /< 15ms
    HidNpadCommunicationModeDefault = 3 ## /< Default


## / DeviceType (system)

type
  HidDeviceTypeBits* = enum
    HidDeviceTypeBitsFullKey = bit(0), ## /< Pro Controller and Gc controller.
    HidDeviceTypeBitsDebugPad = bit(1), ## /< DebugPad
    HidDeviceTypeBitsHandheldLeft = bit(2), ## /< Joy-Con/Famicom/NES left controller in handheld mode.
    HidDeviceTypeBitsHandheldRight = bit(3), ## /< Joy-Con/Famicom/NES right controller in handheld mode.
    HidDeviceTypeBitsJoyLeft = bit(4), ## /< Joy-Con left controller.
    HidDeviceTypeBitsJoyRight = bit(5), ## /< Joy-Con right controller.
    HidDeviceTypeBitsPalma = bit(6), ## /< Poké Ball Plus controller.
    HidDeviceTypeBitsLarkHvcLeft = bit(7), ## /< Famicom left controller.
    HidDeviceTypeBitsLarkHvcRight = bit(8), ## /< Famicom right controller (with microphone).
    HidDeviceTypeBitsLarkNesLeft = bit(9), ## /< NES left controller.
    HidDeviceTypeBitsLarkNesRight = bit(10), ## /< NES right controller.
    HidDeviceTypeBitsHandheldLarkHvcLeft = bit(11), ## /< Famicom left controller in handheld mode.
    HidDeviceTypeBitsHandheldLarkHvcRight = bit(12), ## /< Famicom right controller (with microphone) in handheld mode.
    HidDeviceTypeBitsHandheldLarkNesLeft = bit(13), ## /< NES left controller in handheld mode.
    HidDeviceTypeBitsHandheldLarkNesRight = bit(14), ## /< NES right controller in handheld mode.
    HidDeviceTypeBitsLucia = bit(15), ## /< SNES controller
    HidDeviceTypeBitsLagon = bit(16), ## /< N64 controller
    HidDeviceTypeBitsLager = bit(17), ## /< Sega Genesis controller
    HidDeviceTypeBitsSystem = bit(31) ## /< Generic controller.


## / Internal DeviceType for [9.0.0+]. Converted to/from the pre-9.0.0 version of this by the hiddbg funcs.

type
  HidDeviceType* = enum
    HidDeviceTypeJoyRight1 = 1, ## /< ::HidDeviceTypeBits_JoyRight
    HidDeviceTypeJoyLeft2 = 2,  ## /< ::HidDeviceTypeBits_JoyLeft
    HidDeviceTypeFullKey3 = 3,  ## /< ::HidDeviceTypeBits_FullKey
    HidDeviceTypeJoyLeft4 = 4,  ## /< ::HidDeviceTypeBits_JoyLeft
    HidDeviceTypeJoyRight5 = 5, ## /< ::HidDeviceTypeBits_JoyRight
    HidDeviceTypeFullKey6 = 6,  ## /< ::HidDeviceTypeBits_FullKey
    HidDeviceTypeLarkHvcLeft = 7, ## /< ::HidDeviceTypeBits_LarkHvcLeft, ::HidDeviceTypeBits_HandheldLarkHvcLeft
    HidDeviceTypeLarkHvcRight = 8, ## /< ::HidDeviceTypeBits_LarkHvcRight, ::HidDeviceTypeBits_HandheldLarkHvcRight
    HidDeviceTypeLarkNesLeft = 9, ## /< ::HidDeviceTypeBits_LarkNesLeft, ::HidDeviceTypeBits_HandheldLarkNesLeft
    HidDeviceTypeLarkNesRight = 10, ## /< ::HidDeviceTypeBits_LarkNesRight, ::HidDeviceTypeBits_HandheldLarkNesRight
    HidDeviceTypeLucia = 11,    ## /< ::HidDeviceTypeBits_Lucia
    HidDeviceTypePalma = 12,    ## /< [9.0.0+] ::HidDeviceTypeBits_Palma
    HidDeviceTypeFullKey13 = 13, ## /< ::HidDeviceTypeBits_FullKey
    HidDeviceTypeFullKey15 = 15, ## /< ::HidDeviceTypeBits_FullKey
    HidDeviceTypeDebugPad = 17, ## /< ::HidDeviceTypeBits_DebugPad
    HidDeviceTypeSystem19 = 19, ## /< ::HidDeviceTypeBits_System with \ref HidNpadStyleTag |= ::HidNpadStyleTag_NpadFullKey.
    HidDeviceTypeSystem20 = 20, ## /< ::HidDeviceTypeBits_System with \ref HidNpadStyleTag |= ::HidNpadStyleTag_NpadJoyDual.
    HidDeviceTypeSystem21 = 21, ## /< ::HidDeviceTypeBits_System with \ref HidNpadStyleTag |= ::HidNpadStyleTag_NpadJoyDual.
    HidDeviceTypeLagon = 22,    ## /< ::HidDeviceTypeBits_Lagon
    HidDeviceTypeLager = 28     ## /< ::HidDeviceTypeBits_Lager


## / AppletFooterUiType (system)

type
  HidAppletFooterUiType* = enum
    HidAppletFooterUiTypeNone = 0, ## /< None
    HidAppletFooterUiTypeHandheldNone = 1, ## /< HandheldNone
    HidAppletFooterUiTypeHandheldJoyConLeftOnly = 2, ## /< HandheldJoyConLeftOnly
    HidAppletFooterUiTypeHandheldJoyConRightOnly = 3, ## /< HandheldJoyConRightOnly
    HidAppletFooterUiTypeHandheldJoyConLeftJoyConRight = 4, ## /< HandheldJoyConLeftJoyConRight
    HidAppletFooterUiTypeJoyDual = 5, ## /< JoyDual
    HidAppletFooterUiTypeJoyDualLeftOnly = 6, ## /< JoyDualLeftOnly
    HidAppletFooterUiTypeJoyDualRightOnly = 7, ## /< JoyDualRightOnly
    HidAppletFooterUiTypeJoyLeftHorizontal = 8, ## /< JoyLeftHorizontal
    HidAppletFooterUiTypeJoyLeftVertical = 9, ## /< JoyLeftVertical
    HidAppletFooterUiTypeJoyRightHorizontal = 10, ## /< JoyRightHorizontal
    HidAppletFooterUiTypeJoyRightVertical = 11, ## /< JoyRightVertical
    HidAppletFooterUiTypeSwitchProController = 12, ## /< SwitchProController
    HidAppletFooterUiTypeCompatibleProController = 13, ## /< CompatibleProController
    HidAppletFooterUiTypeCompatibleJoyCon = 14, ## /< CompatibleJoyCon
    HidAppletFooterUiTypeLarkHvc1 = 15, ## /< LarkHvc1
    HidAppletFooterUiTypeLarkHvc2 = 16, ## /< LarkHvc2
    HidAppletFooterUiTypeLarkNesLeft = 17, ## /< LarkNesLeft
    HidAppletFooterUiTypeLarkNesRight = 18, ## /< LarkNesRight
    HidAppletFooterUiTypeLucia = 19, ## /< Lucia
    HidAppletFooterUiTypeVerification = 20, ## /< Verification
    HidAppletFooterUiTypeLagon = 21 ## /< [13.0.0+] Lagon


## / NpadInterfaceType (system)

type
  HidNpadInterfaceType* = enum
    HidNpadInterfaceTypeBluetooth = 1, ## /< Bluetooth.
    HidNpadInterfaceTypeRail = 2, ## /< Rail.
    HidNpadInterfaceTypeUSB = 3, ## /< USB.
    HidNpadInterfaceTypeUnknown4 = 4 ## /< Unknown.


## / XcdInterfaceType

type
  XcdInterfaceType* = enum
    XcdInterfaceTypeBluetooth = bit(0), XcdInterfaceTypeUart = bit(1),
    XcdInterfaceTypeUsb = bit(2), XcdInterfaceTypeFieldSet = bit(7)


## / NpadLarkType

type
  HidNpadLarkType* = enum
    HidNpadLarkTypeInvalid = 0, ## /< Invalid
    HidNpadLarkTypeH1 = 1,      ## /< H1
    HidNpadLarkTypeH2 = 2,      ## /< H2
    HidNpadLarkTypeNL = 3,      ## /< NL
    HidNpadLarkTypeNR = 4       ## /< NR


## / NpadLuciaType

type
  HidNpadLuciaType* = enum
    HidNpadLuciaTypeInvalid = 0, ## /< Invalid
    HidNpadLuciaTypeJ = 1,      ## /< J
    HidNpadLuciaTypeE = 2,      ## /< E
    HidNpadLuciaTypeU = 3       ## /< U


## / NpadLagerType

type
  HidNpadLagerType* = enum
    HidNpadLagerTypeInvalid = 0, ## /< Invalid
    HidNpadLagerTypeJ = 1,      ## /< J
    HidNpadLagerTypeE = 2,      ## /< E
    HidNpadLagerTypeU = 3       ## /< U


## / Type values for HidVibrationDeviceInfo::type.

type
  HidVibrationDeviceType* = enum
    HidVibrationDeviceTypeUnknown = 0, ## /< Unknown
    HidVibrationDeviceTypeLinearResonantActuator = 1, ## /< LinearResonantActuator
    HidVibrationDeviceTypeGcErm = 2 ## /< GcErm (::HidNpadStyleTag_NpadGc)


## / VibrationDevicePosition

type
  HidVibrationDevicePosition* = enum
    HidVibrationDevicePositionNone = 0, ## /< None
    HidVibrationDevicePositionLeft = 1, ## /< Left
    HidVibrationDevicePositionRight = 2 ## /< Right


## / VibrationGcErmCommand

type
  HidVibrationGcErmCommand* = enum
    HidVibrationGcErmCommandStop = 0, ## /< Stops the vibration with a decay phase.
    HidVibrationGcErmCommandStart = 1, ## /< Starts the vibration.
    HidVibrationGcErmCommandStopHard = 2 ## /< Stops the vibration immediately, with no decay phase.


## / PalmaOperationType

type
  HidPalmaOperationType* = enum
    HidPalmaOperationTypePlayActivity = 0, ## /< PlayActivity
    HidPalmaOperationTypeSetFrModeType = 1, ## /< SetFrModeType
    HidPalmaOperationTypeReadStep = 2, ## /< ReadStep
    HidPalmaOperationTypeEnableStep = 3, ## /< EnableStep
    HidPalmaOperationTypeResetStep = 4, ## /< ResetStep
    HidPalmaOperationTypeReadApplicationSection = 5, ## /< ReadApplicationSection
    HidPalmaOperationTypeWriteApplicationSection = 6, ## /< WriteApplicationSection
    HidPalmaOperationTypeReadUniqueCode = 7, ## /< ReadUniqueCode
    HidPalmaOperationTypeSetUniqueCodeInvalid = 8, ## /< SetUniqueCodeInvalid
    HidPalmaOperationTypeWriteActivityEntry = 9, ## /< WriteActivityEntry
    HidPalmaOperationTypeWriteRgbLedPatternEntry = 10, ## /< WriteRgbLedPatternEntry
    HidPalmaOperationTypeWriteWaveEntry = 11, ## /< WriteWaveEntry
    HidPalmaOperationTypeReadDataBaseIdentificationVersion = 12, ## /< ReadDataBaseIdentificationVersion
    HidPalmaOperationTypeWriteDataBaseIdentificationVersion = 13, ## /< WriteDataBaseIdentificationVersion
    HidPalmaOperationTypeSuspendFeature = 14, ## /< SuspendFeature
    HidPalmaOperationTypeReadPlayLog = 15, ## /< [5.1.0+] ReadPlayLog
    HidPalmaOperationTypeResetPlayLog = 16 ## /< [5.1.0+] ResetPlayLog


## / PalmaFrModeType

type
  HidPalmaFrModeType* = enum
    HidPalmaFrModeTypeOff = 0,  ## /< Off
    HidPalmaFrModeTypeB01 = 1,  ## /< B01
    HidPalmaFrModeTypeB02 = 2,  ## /< B02
    HidPalmaFrModeTypeB03 = 3,  ## /< B03
    HidPalmaFrModeTypeDownloaded = 4 ## /< Downloaded


## / PalmaWaveSet

type
  HidPalmaWaveSet* = enum
    HidPalmaWaveSetSmall = 0,   ## /< Small
    HidPalmaWaveSetMedium = 1,  ## /< Medium
    HidPalmaWaveSetLarge = 2    ## /< Large


## / PalmaFeature

type
  HidPalmaFeature* = enum
    HidPalmaFeatureFrMode = bit(0), ## /< FrMode
    HidPalmaFeatureRumbleFeedback = bit(1), ## /< RumbleFeedback
    HidPalmaFeatureStep = bit(2), ## /< Step
    HidPalmaFeatureMuteSwitch = bit(3) ## /< MuteSwitch


## / HidAnalogStickState

type
  HidAnalogStickState* {.bycopy.} = object
    x*: S32                    ## /< X
    y*: S32                    ## /< Y


## / HidVector

type
  HidVector* {.bycopy.} = object
    x*: cfloat
    y*: cfloat
    z*: cfloat


## / HidDirectionState

type
  HidDirectionState* {.bycopy.} = object
    direction*: array[3, array[3, cfloat]] ## /< 3x3 matrix


const
  JOYSTICK_MAX* = (0x7FFF)
  JOYSTICK_MIN* = (-0x7FFF)

##  End enums and output structs
## / HidCommonLifoHeader

type
  HidCommonLifoHeader* {.bycopy.} = object
    unused*: U64               ## /< Unused
    bufferCount*: U64          ## /< BufferCount
    tail*: U64                 ## /< Tail
    count*: U64                ## /< Count


##  Begin HidDebugPad
## / HidDebugPadState

type
  HidDebugPadState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    attributes*: U32           ## /< Bitfield of \ref HidDebugPadAttribute.
    buttons*: U32              ## /< Bitfield of \ref HidDebugPadButton.
    analogStickR*: HidAnalogStickState ## /< AnalogStickR
    analogStickL*: HidAnalogStickState ## /< AnalogStickL


## / HidDebugPadStateAtomicStorage

type
  HidDebugPadStateAtomicStorage* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    state*: HidDebugPadState   ## /< \ref HidDebugPadState


## / HidDebugPadLifo

type
  HidDebugPadLifo* {.bycopy.} = object
    header*: HidCommonLifoHeader ## /< \ref HidCommonLifoHeader
    storage*: array[17, HidDebugPadStateAtomicStorage] ## /< \ref HidDebugPadStateAtomicStorage


## / HidDebugPadSharedMemoryFormat

type
  HidDebugPadSharedMemoryFormat* {.bycopy.} = object
    lifo*: HidDebugPadLifo
    padding*: array[0x138, U8]


##  End HidDebugPad
##  Begin HidTouchScreen
## / HidTouchState

type
  HidTouchState* {.bycopy.} = object
    deltaTime*: U64            ## /< DeltaTime
    attributes*: U32           ## /< Bitfield of \ref HidTouchAttribute.
    fingerId*: U32             ## /< FingerId
    x*: U32                    ## /< X
    y*: U32                    ## /< Y
    diameterX*: U32            ## /< DiameterX
    diameterY*: U32            ## /< DiameterY
    rotationAngle*: U32        ## /< RotationAngle
    reserved*: U32             ## /< Reserved


## / HidTouchScreenState

type
  HidTouchScreenState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    count*: S32                ## /< Number of entries in the touches array.
    reserved*: U32             ## /< Reserved
    touches*: array[16, HidTouchState] ## /< Array of \ref HidTouchState, with the above count.


## / HidTouchScreenStateAtomicStorage

type
  HidTouchScreenStateAtomicStorage* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    state*: HidTouchScreenState ## /< \ref HidTouchScreenState


## / HidTouchScreenLifo

type
  HidTouchScreenLifo* {.bycopy.} = object
    header*: HidCommonLifoHeader ## /< \ref HidCommonLifoHeader
    storage*: array[17, HidTouchScreenStateAtomicStorage] ## /< \ref HidTouchScreenStateAtomicStorage


## / HidTouchScreenSharedMemoryFormat

type
  HidTouchScreenSharedMemoryFormat* {.bycopy.} = object
    lifo*: HidTouchScreenLifo
    padding*: array[0x3c8, U8]


## / HidTouchScreenConfigurationForNx

type
  HidTouchScreenConfigurationForNx* {.bycopy.} = object
    mode*: U8                  ## /< \ref HidTouchScreenModeForNx
    reserved*: array[0xF, U8]   ## /< Reserved


##  End HidTouchScreen
##  Begin HidMouse
## / HidMouseState

type
  HidMouseState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    x*: S32                    ## /< X
    y*: S32                    ## /< Y
    deltaX*: S32               ## /< DeltaX
    deltaY*: S32               ## /< DeltaY
    wheelDeltaX*: S32          ## /< WheelDeltaX
    wheelDeltaY*: S32          ## /< WheelDeltaY
    buttons*: U32              ## /< Bitfield of \ref HidMouseButton.
    attributes*: U32           ## /< Bitfield of \ref HidMouseAttribute.


## / HidMouseStateAtomicStorage

type
  HidMouseStateAtomicStorage* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    state*: HidMouseState


## / HidMouseLifo

type
  HidMouseLifo* {.bycopy.} = object
    header*: HidCommonLifoHeader
    storage*: array[17, HidMouseStateAtomicStorage]


## / HidMouseSharedMemoryFormat

type
  HidMouseSharedMemoryFormat* {.bycopy.} = object
    lifo*: HidMouseLifo
    padding*: array[0xB0, U8]


##  End HidMouse
##  Begin HidKeyboard
## / HidKeyboardState

type
  HidKeyboardState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    modifiers*: U64            ## /< Bitfield of \ref HidKeyboardModifier.
    keys*: array[4, U64]


## / HidKeyboardStateAtomicStorage

type
  HidKeyboardStateAtomicStorage* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    state*: HidKeyboardState


## / HidKeyboardLifo

type
  HidKeyboardLifo* {.bycopy.} = object
    header*: HidCommonLifoHeader
    storage*: array[17, HidKeyboardStateAtomicStorage]


## / HidKeyboardSharedMemoryFormat

type
  HidKeyboardSharedMemoryFormat* {.bycopy.} = object
    lifo*: HidKeyboardLifo
    padding*: array[0x28, U8]


##  End HidKeyboard
##  Begin HidNpad
## / Npad colors.
## / Color fields are zero when not set.

type
  HidNpadControllerColor* {.bycopy.} = object
    main*: U32                 ## /< RGBA Body Color
    sub*: U32                  ## /< RGBA Buttons Color


## / HidNpadFullKeyColorState

type
  HidNpadFullKeyColorState* {.bycopy.} = object
    attribute*: U32            ## /< \ref HidColorAttribute
    fullKey*: HidNpadControllerColor ## /< \ref HidNpadControllerColor FullKey


## / HidNpadJoyColorState

type
  HidNpadJoyColorState* {.bycopy.} = object
    attribute*: U32            ## /< \ref HidColorAttribute
    left*: HidNpadControllerColor ## /< \ref HidNpadControllerColor Left
    right*: HidNpadControllerColor ## /< \ref HidNpadControllerColor Right


## / HidNpadCommonState

type
  HidNpadCommonState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    buttons*: U64              ## /< Bitfield of \ref HidNpadButton.
    analogStickL*: HidAnalogStickState ## /< AnalogStickL
    analogStickR*: HidAnalogStickState ## /< AnalogStickR
    attributes*: U32           ## /< Bitfield of \ref HidNpadAttribute.
    reserved*: U32             ## /< Reserved

  HidNpadFullKeyState* = HidNpadCommonState

## /< State for ::HidNpadStyleTag_NpadFullKey.

type
  HidNpadHandheldState* = HidNpadCommonState

## /< State for ::HidNpadStyleTag_NpadHandheld.

type
  HidNpadJoyDualState* = HidNpadCommonState

## /< State for ::HidNpadStyleTag_NpadJoyDual.

type
  HidNpadJoyLeftState* = HidNpadCommonState

## /< State for ::HidNpadStyleTag_NpadJoyLeft.

type
  HidNpadJoyRightState* = HidNpadCommonState

## /< State for ::HidNpadStyleTag_NpadJoyRight.
## / State for ::HidNpadStyleTag_NpadGc. Loaded from the same lifo as \ref HidNpadFullKeyState, with the additional trigger_l/trigger_r loaded from elsewhere.

type
  HidNpadGcState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    buttons*: U64              ## /< Bitfield of \ref HidNpadButton.
    analogStickL*: HidAnalogStickState ## /< AnalogStickL
    analogStickR*: HidAnalogStickState ## /< AnalogStickR
    attributes*: U32           ## /< Bitfield of \ref HidNpadAttribute.
    triggerL*: U32             ## /< L analog trigger. Valid range: 0x0-0x7FFF.
    triggerR*: U32             ## /< R analog trigger. Valid range: 0x0-0x7FFF.
    pad*: U32

  HidNpadPalmaState* = HidNpadCommonState

## /< State for ::HidNpadStyleTag_NpadPalma.
## / State for ::HidNpadStyleTag_NpadLark. The base state is loaded from the same lifo as \ref HidNpadFullKeyState.

type
  HidNpadLarkState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    buttons*: U64              ## /< Bitfield of \ref HidNpadButton.
    analogStickL*: HidAnalogStickState ## /< This is always zero.
    analogStickR*: HidAnalogStickState ## /< This is always zero.
    attributes*: U32           ## /< Bitfield of \ref HidNpadAttribute.
    larkTypeLAndMain*: HidNpadLarkType ## /< \ref HidNpadLarkType LarkTypeLAndMain


## / State for ::HidNpadStyleTag_NpadHandheldLark. The base state is loaded from the same lifo as \ref HidNpadHandheldState.

type
  HidNpadHandheldLarkState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    buttons*: U64              ## /< Bitfield of \ref HidNpadButton.
    analogStickL*: HidAnalogStickState ## /< AnalogStickL
    analogStickR*: HidAnalogStickState ## /< AnalogStickR
    attributes*: U32           ## /< Bitfield of \ref HidNpadAttribute.
    larkTypeLAndMain*: HidNpadLarkType ## /< \ref HidNpadLarkType LarkTypeLAndMain
    larkTypeR*: HidNpadLarkType ## /< \ref HidNpadLarkType LarkTypeR
    pad*: U32


## / State for ::HidNpadStyleTag_NpadLucia. The base state is loaded from the same lifo as \ref HidNpadFullKeyState.

type
  HidNpadLuciaState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    buttons*: U64              ## /< Bitfield of \ref HidNpadButton.
    analogStickL*: HidAnalogStickState ## /< This is always zero.
    analogStickR*: HidAnalogStickState ## /< This is always zero.
    attributes*: U32           ## /< Bitfield of \ref HidNpadAttribute.
    luciaType*: HidNpadLuciaType ## /< \ref HidNpadLuciaType

  HidNpadLagerState* = HidNpadCommonState

## /< State for ::HidNpadStyleTag_NpadLager. Analog-sticks state are always zero.

type
  HidNpadSystemExtState* = HidNpadCommonState

## /< State for ::HidNpadStyleTag_NpadSystemExt.

type
  HidNpadSystemState* = HidNpadCommonState

## /< State for ::HidNpadStyleTag_NpadSystem. Analog-sticks state are always zero. Only the following button bits are available: HidNpadButton_A, HidNpadButton_B, HidNpadButton_X, HidNpadButton_Y, HidNpadButton_Left, HidNpadButton_Up, HidNpadButton_Right, HidNpadButton_Down, HidNpadButton_L, HidNpadButton_R.
## / HidNpadCommonStateAtomicStorage

type
  HidNpadCommonStateAtomicStorage* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    state*: HidNpadCommonState


## / HidNpadCommonLifo

type
  HidNpadCommonLifo* {.bycopy.} = object
    header*: HidCommonLifoHeader
    storage*: array[17, HidNpadCommonStateAtomicStorage]


## / HidNpadGcTriggerState

type
  HidNpadGcTriggerState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    triggerL*: U32
    triggerR*: U32


## / HidNpadGcTriggerStateAtomicStorage

type
  HidNpadGcTriggerStateAtomicStorage* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    state*: HidNpadGcTriggerState


## / HidNpadGcTriggerLifo

type
  HidNpadGcTriggerLifo* {.bycopy.} = object
    header*: HidCommonLifoHeader
    storage*: array[17, HidNpadGcTriggerStateAtomicStorage]


## / HidSixAxisSensorState

type
  HidSixAxisSensorState* {.bycopy.} = object
    deltaTime*: U64            ## /< DeltaTime
    samplingNumber*: U64       ## /< SamplingNumber
    acceleration*: HidVector   ## /< Acceleration
    angularVelocity*: HidVector ## /< AngularVelocity
    angle*: HidVector          ## /< Angle
    direction*: HidDirectionState ## /< Direction
    attributes*: U32           ## /< Bitfield of \ref HidSixAxisSensorAttribute.
    reserved*: U32             ## /< Reserved


## / HidSixAxisSensorStateAtomicStorage

type
  HidSixAxisSensorStateAtomicStorage* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    state*: HidSixAxisSensorState


## / HidNpadSixAxisSensorLifo

type
  HidNpadSixAxisSensorLifo* {.bycopy.} = object
    header*: HidCommonLifoHeader
    storage*: array[17, HidSixAxisSensorStateAtomicStorage]


## / NpadSystemProperties

type
  HidNpadSystemProperties* {.bycopy.} = object
    isCharging* {.bitsize: 3.}: U64 ## /< Use \ref hidGetNpadPowerInfoSingle / \ref hidGetNpadPowerInfoSplit instead of accessing this directly.
    isPowered* {.bitsize: 3.}: U64 ## /< Use \ref hidGetNpadPowerInfoSingle / \ref hidGetNpadPowerInfoSplit instead of accessing this directly.
    bit6* {.bitsize: 1.}: U64    ## /< Unused
    bit7* {.bitsize: 1.}: U64    ## /< Unused
    bit8* {.bitsize: 1.}: U64    ## /< Unused
    isUnsupportedButtonPressedOnNpadSystem* {.bitsize: 1.}: U64 ## /< IsUnsupportedButtonPressedOnNpadSystem
    isUnsupportedButtonPressedOnNpadSystemExt* {.bitsize: 1.}: U64 ## /< IsUnsupportedButtonPressedOnNpadSystemExt
    isAbxyButtonOriented* {.bitsize: 1.}: U64 ## /< IsAbxyButtonOriented
    isSlSrButtonOriented* {.bitsize: 1.}: U64 ## /< IsSlSrButtonOriented
    isPlusAvailable* {.bitsize: 1.}: U64 ## /< [4.0.0+] IsPlusAvailable
    isMinusAvailable* {.bitsize: 1.}: U64 ## /< [4.0.0+] IsMinusAvailable
    isDirectionalButtonsAvailable* {.bitsize: 1.}: U64 ## /< [8.0.0+] IsDirectionalButtonsAvailable
    unused* {.bitsize: 48.}: U64 ## /< Unused


## / NpadSystemButtonProperties

type
  HidNpadSystemButtonProperties* {.bycopy.} = object
    isUnintendedHomeButtonInputProtectionEnabled* {.bitsize: 1.}: U32 ## /< IsUnintendedHomeButtonInputProtectionEnabled


## / HidPowerInfo (system)

type
  HidPowerInfo* {.bycopy.} = object
    isPowered*: bool           ## /< IsPowered
    isCharging*: bool          ## /< IsCharging
    reserved*: array[6, U8]     ## /< Reserved
    batteryLevel*: U32         ## /< BatteryLevel, always 0-4.


## / XcdDeviceHandle

type
  XcdDeviceHandle* {.bycopy.} = object
    handle*: U64


## / HidNfcXcdDeviceHandleStateImpl

type
  HidNfcXcdDeviceHandleStateImpl* {.bycopy.} = object
    handle*: XcdDeviceHandle
    isAvailable*: U8
    isActivated*: U8
    reserved*: array[6, U8]
    samplingNumber*: U64       ## /< SamplingNumber


## / HidNfcXcdDeviceHandleStateImplAtomicStorage

type
  HidNfcXcdDeviceHandleStateImplAtomicStorage* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    state*: HidNfcXcdDeviceHandleStateImpl ## /< \ref HidNfcXcdDeviceHandleStateImpl


## / HidNfcXcdDeviceHandleState

type
  HidNfcXcdDeviceHandleState* {.bycopy.} = object
    header*: HidCommonLifoHeader
    storage*: array[2, HidNfcXcdDeviceHandleStateImplAtomicStorage]


## / HidNpadInternalState

type
  INNER_C_STRUCT_hid_7* {.bycopy.} = object
    nfcXcdDeviceHandle*: HidNfcXcdDeviceHandleState ##  [1.0.0-3.0.2]

  INNER_C_STRUCT_hid_9* {.bycopy.} = object
    appletFooterUiAttribute*: U32 ## /< Bitfield of AppletFooterUiAttribute.
    appletFooterUiType*: U8    ## /< \ref HidAppletFooterUiType
    reservedX41AD*: array[0x5B, U8]

  INNER_C_UNION_hid_6* {.bycopy, union.} = object
    anoHid8*: INNER_C_STRUCT_hid_7
    anoHid10*: INNER_C_STRUCT_hid_9

  HidNpadInternalState* {.bycopy.} = object
    styleSet*: U32             ## /< Bitfield of \ref HidNpadStyleTag.
    joyAssignmentMode*: U32    ## /< \ref HidNpadJoyAssignmentMode
    fullKeyColor*: HidNpadFullKeyColorState ## /< \ref HidNpadFullKeyColorState
    joyColor*: HidNpadJoyColorState ## /< \ref HidNpadJoyColorState
    fullKeyLifo*: HidNpadCommonLifo ## /< FullKeyLifo
    handheldLifo*: HidNpadCommonLifo ## /< HandheldLifo
    joyDualLifo*: HidNpadCommonLifo ## /< JoyDualLifo
    joyLeftLifo*: HidNpadCommonLifo ## /< JoyLeftLifo
    joyRightLifo*: HidNpadCommonLifo ## /< JoyRightLifo
    palmaLifo*: HidNpadCommonLifo ## /< PalmaLifo
    systemExtLifo*: HidNpadCommonLifo ## /< SystemExtLifo
    fullKeySixAxisSensorLifo*: HidNpadSixAxisSensorLifo ## /< FullKeySixAxisSensorLifo
    handheldSixAxisSensorLifo*: HidNpadSixAxisSensorLifo ## /< HandheldSixAxisSensorLifo
    joyDualLeftSixAxisSensorLifo*: HidNpadSixAxisSensorLifo ## /< JoyDualLeftSixAxisSensorLifo
    joyDualRightSixAxisSensorLifo*: HidNpadSixAxisSensorLifo ## /< JoyDualRightSixAxisSensorLifo
    joyLeftSixAxisSensorLifo*: HidNpadSixAxisSensorLifo ## /< JoyLeftSixAxisSensorLifo
    joyRightSixAxisSensorLifo*: HidNpadSixAxisSensorLifo ## /< JoyRightSixAxisSensorLifo
    deviceType*: U32           ## /< Bitfield of \ref HidDeviceTypeBits.
    reserved*: U32             ## /< Reserved
    systemProperties*: HidNpadSystemProperties
    systemButtonProperties*: HidNpadSystemButtonProperties
    batteryLevel*: array[3, U32]
    anoHid11*: INNER_C_UNION_hid_6
    reservedX4208*: array[0x20, U8] ## /< Mutex on pre-10.0.0.
    gcTriggerLifo*: HidNpadGcTriggerLifo
    larkTypeLAndMain*: U32     ## /< \ref HidNpadLarkType
    larkTypeR*: U32            ## /< \ref HidNpadLarkType
    luciaType*: U32            ## /< \ref HidNpadLuciaType
    lagerType*: U32            ## /< \ref HidNpadLagerType


## / HidNpadSharedMemoryEntry

type
  HidNpadSharedMemoryEntry* {.bycopy.} = object
    internalState*: HidNpadInternalState
    pad*: array[0xC10, U8]


## / HidNpadSharedMemoryFormat

type
  HidNpadSharedMemoryFormat* {.bycopy.} = object
    entries*: array[10, HidNpadSharedMemoryEntry]


##  End HidNpad
##  Begin HidGesture
## / HidGesturePoint

type
  HidGesturePoint* {.bycopy.} = object
    x*: U32                    ## /< X
    y*: U32                    ## /< Y


## / HidGestureState

type
  HidGestureState* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    contextNumber*: U64        ## /< ContextNumber
    `type`*: U32               ## /< \ref HidGestureType
    direction*: U32            ## /< \ref HidGestureDirection
    x*: U32                    ## /< X
    y*: U32                    ## /< Y
    deltaX*: S32               ## /< DeltaX
    deltaY*: S32               ## /< DeltaY
    velocityX*: cfloat         ## /< VelocityX
    velocityY*: cfloat         ## /< VelocityY
    attributes*: U32           ## /< Bitfield of \ref HidGestureAttribute.
    scale*: cfloat             ## /< Scale
    rotationAngle*: cfloat     ## /< RotationAngle
    pointCount*: S32           ## /< Number of entries in the points array.
    points*: array[4, HidGesturePoint] ## /< Array of \ref HidGesturePoint with the above count.


## / HidGestureDummyStateAtomicStorage

type
  HidGestureDummyStateAtomicStorage* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    state*: HidGestureState


## / HidGestureLifo

type
  HidGestureLifo* {.bycopy.} = object
    header*: HidCommonLifoHeader
    storage*: array[17, HidGestureDummyStateAtomicStorage]


## / HidGestureSharedMemoryFormat

type
  HidGestureSharedMemoryFormat* {.bycopy.} = object
    lifo*: HidGestureLifo
    pad*: array[0xF8, U8]


##  End HidGesture
## / HidConsoleSixAxisSensor

type
  HidConsoleSixAxisSensor* {.bycopy.} = object
    samplingNumber*: U64       ## /< SamplingNumber
    isSevenSixAxisSensorAtRest*: U8 ## /< IsSevenSixAxisSensorAtRest
    pad*: array[0x3, U8]        ## /< Padding
    verticalizationError*: cfloat ## /< VerticalizationError
    gyroBias*: UtilFloat3      ## /< GyroBias
    pad2*: array[0x4, U8]       ## /< Padding


## / HidSharedMemory

type
  HidSharedMemory* {.bycopy.} = object
    debugPad*: HidDebugPadSharedMemoryFormat
    touchscreen*: HidTouchScreenSharedMemoryFormat
    mouse*: HidMouseSharedMemoryFormat
    keyboard*: HidKeyboardSharedMemoryFormat
    digitizer*: array[0x1000, U8] ## /< [10.0.0+] Digitizer [1.0.0-9.2.0] BasicXpad
    homeButton*: array[0x200, U8]
    sleepButton*: array[0x200, U8]
    captureButton*: array[0x200, U8]
    inputDetector*: array[0x800, U8]
    uniquePad*: array[0x4000, U8] ## /< [1.0.0-4.1.0] UniquePad
    npad*: HidNpadSharedMemoryFormat
    gesture*: HidGestureSharedMemoryFormat
    consoleSixAxisSensor*: HidConsoleSixAxisSensor ## /< [5.0.0+] ConsoleSixAxisSensor
    unkX3C220*: array[0x3DE0, U8]


## / HidSevenSixAxisSensorState

type
  HidSevenSixAxisSensorState* {.bycopy.} = object
    timestamp0*: U64
    samplingNumber*: U64
    unkX10*: U64
    unkX18*: array[10, cfloat]


## / HidSevenSixAxisSensorStateEntry

type
  HidSevenSixAxisSensorStateEntry* {.bycopy.} = object
    samplingNumber*: U64
    unused*: U64
    state*: HidSevenSixAxisSensorState


## / HidSevenSixAxisSensorStates

type
  HidSevenSixAxisSensorStates* {.bycopy.} = object
    header*: HidCommonLifoHeader
    storage*: array[0x21, HidSevenSixAxisSensorStateEntry]


## / HidSixAxisSensorHandle

type
  INNER_C_STRUCT_hid_14* {.bycopy.} = object
    npadStyleIndex* {.bitsize: 8.}: U32 ## /< NpadStyleIndex
    playerNumber* {.bitsize: 8.}: U32 ## /< PlayerNumber
    deviceIdx* {.bitsize: 8.}: U32 ## /< DeviceIdx
    pad* {.bitsize: 8.}: U32     ## /< Padding

  HidSixAxisSensorHandle* {.bycopy, union.} = object
    typeValue*: U32            ## /< TypeValue
    anoHid15*: INNER_C_STRUCT_hid_14


## / HidVibrationDeviceHandle

type
  INNER_C_STRUCT_hid_18* {.bycopy.} = object
    npadStyleIndex* {.bitsize: 8.}: U32 ## /< NpadStyleIndex
    playerNumber* {.bitsize: 8.}: U32 ## /< PlayerNumber
    deviceIdx* {.bitsize: 8.}: U32 ## /< DeviceIdx
    pad* {.bitsize: 8.}: U32     ## /< Padding

  HidVibrationDeviceHandle* {.bycopy, union.} = object
    typeValue*: U32            ## /< TypeValue
    anoHid19*: INNER_C_STRUCT_hid_18


## / HidVibrationDeviceInfo

type
  HidVibrationDeviceInfo* {.bycopy.} = object
    `type`*: U32               ## /< \ref HidVibrationDeviceType
    position*: U32             ## /< \ref HidVibrationDevicePosition


## / HidVibrationValue

type
  HidVibrationValue* {.bycopy.} = object
    ampLow*: cfloat            ## /< Low Band amplitude. 1.0f: Max amplitude.
    freqLow*: cfloat           ## /< Low Band frequency in Hz.
    ampHigh*: cfloat           ## /< High Band amplitude. 1.0f: Max amplitude.
    freqHigh*: cfloat          ## /< High Band frequency in Hz.


## / PalmaConnectionHandle

type
  HidPalmaConnectionHandle* {.bycopy.} = object
    handle*: U64               ## /< Handle


## / PalmaOperationInfo

type
  HidPalmaOperationInfo* {.bycopy.} = object
    `type`*: U32               ## /< \ref HidPalmaOperationType
    res*: Result               ## /< Result
    data*: array[0x140, U8]     ## /< Data


## / PalmaApplicationSectionAccessBuffer

type
  HidPalmaApplicationSectionAccessBuffer* {.bycopy.} = object
    data*: array[0x100, U8]     ## /< Application data.


## / PalmaActivityEntry

type
  HidPalmaActivityEntry* {.bycopy.} = object
    rgbLedPatternIndex*: U16   ## /< RgbLedPatternIndex
    pad*: U16                  ## /< Padding
    waveSet*: U32              ## /< \ref HidPalmaWaveSet
    waveIndex*: U16            ## /< WaveIndex

proc hidInitialize*(): Result {.cdecl, importc: "hidInitialize".}
## / Initialize hid. Called automatically during app startup.

proc hidExit*() {.cdecl, importc: "hidExit".}
## / Exit hid. Called automatically during app exit.

proc hidGetServiceSession*(): ptr Service {.cdecl, importc: "hidGetServiceSession".}
## / Gets the Service object for the actual hid service session.

proc hidGetSharedmemAddr*(): pointer {.cdecl, importc: "hidGetSharedmemAddr".}
## / Gets the address of the SharedMemory.

proc hidInitializeTouchScreen*() {.cdecl, importc: "hidInitializeTouchScreen".}
## /@name TouchScreen
## /@{
## / Initialize TouchScreen. Must be called when TouchScreen is being used. Used automatically by \ref hidScanInput when required.

proc hidGetTouchScreenStates*(states: ptr HidTouchScreenState; count: csize_t): csize_t {.
    cdecl, importc: "hidGetTouchScreenStates".}
## *
##  @brief Gets \ref HidTouchScreenState.
##  @param[out] states Output array of \ref HidTouchScreenState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidInitializeMouse*() {.cdecl, importc: "hidInitializeMouse".}
## /@}
## /@name Mouse
## /@{
## / Initialize Mouse. Must be called when Mouse is being used. Used automatically by \ref hidScanInput when required.

proc hidGetMouseStates*(states: ptr HidMouseState; count: csize_t): csize_t {.cdecl,
    importc: "hidGetMouseStates".}
## *
##  @brief Gets \ref HidMouseState.
##  @param[out] states Output array of \ref HidMouseState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidInitializeKeyboard*() {.cdecl, importc: "hidInitializeKeyboard".}
## /@}
## /@name Keyboard
## /@{
## / Initialize Keyboard. Must be called when Keyboard is being used. Used automatically by \ref hidScanInput when required.

proc hidGetKeyboardStates*(states: ptr HidKeyboardState; count: csize_t): csize_t {.
    cdecl, importc: "hidGetKeyboardStates".}
## *
##  @brief Gets \ref HidKeyboardState.
##  @param[out] states Output array of \ref HidKeyboardState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidKeyboardStateGetKey*(state: ptr HidKeyboardState; key: HidKeyboardKey): bool {.
    inline, cdecl.} =
  ## *
  ##  @brief Gets the state of a key in a \ref HidKeyboardState.
  ##  @param[in] state \ref HidKeyboardState.
  ##  @param[in] key \ref HidKeyboardKey.
  ##  @return true if the key is pressed, false if not.
  ##
  return (state.keys[key.uint64 div 64] and (1'u32 shl (key.uint64 and 63))) != 0

proc hidInitializeNpad*() {.cdecl, importc: "hidInitializeNpad".}
## /@}
## /@name Npad
## /@{
## / Initialize Npad. Must be called when Npad is being used. Used automatically by \ref hidScanInput when required.

proc hidGetNpadStyleSet*(id: HidNpadIdType): U32 {.cdecl,
    importc: "hidGetNpadStyleSet".}
## *
##  @brief Gets the StyleSet for the specified Npad.
##  @param[in] id \ref HidNpadIdType
##  @return Bitfield of \ref HidNpadStyleTag.
##

proc hidGetNpadJoyAssignment*(id: HidNpadIdType): HidNpadJoyAssignmentMode {.cdecl,
    importc: "hidGetNpadJoyAssignment".}
## *
##  @brief Gets the \ref HidNpadJoyAssignmentMode for the specified Npad.
##  @param[in] id \ref HidNpadIdType
##  @return \ref HidNpadJoyAssignmentMode
##

proc hidGetNpadControllerColorSingle*(id: HidNpadIdType;
                                     color: ptr HidNpadControllerColor): Result {.
    cdecl, importc: "hidGetNpadControllerColorSingle".}
## *
##  @brief Gets the main \ref HidNpadControllerColor for the specified Npad.
##  @param[in] id \ref HidNpadIdType
##  @param[out] color \ref HidNpadControllerColor
##

proc hidGetNpadControllerColorSplit*(id: HidNpadIdType;
                                    colorLeft: ptr HidNpadControllerColor;
                                    colorRight: ptr HidNpadControllerColor): Result {.
    cdecl, importc: "hidGetNpadControllerColorSplit".}
## *
##  @brief Gets the left/right \ref HidNpadControllerColor for the specified Npad (Joy-Con pair in dual mode).
##  @param[in] id \ref HidNpadIdType
##  @param[out] color_left \ref HidNpadControllerColor
##  @param[out] color_right \ref HidNpadControllerColor
##

proc hidGetNpadDeviceType*(id: HidNpadIdType): U32 {.cdecl,
    importc: "hidGetNpadDeviceType".}
## *
##  @brief Gets the DeviceType for the specified Npad.
##  @param[in] id \ref HidNpadIdType
##  @return Bitfield of \ref HidDeviceTypeBits.
##

proc hidGetNpadSystemProperties*(id: HidNpadIdType;
                                `out`: ptr HidNpadSystemProperties) {.cdecl,
    importc: "hidGetNpadSystemProperties".}
## *
##  @brief Gets the \ref HidNpadSystemProperties for the specified Npad.
##  @param[in] id \ref HidNpadIdType
##  @param[out] out \ref HidNpadSystemProperties
##

proc hidGetNpadSystemButtonProperties*(id: HidNpadIdType;
                                      `out`: ptr HidNpadSystemButtonProperties) {.
    cdecl, importc: "hidGetNpadSystemButtonProperties".}
## *
##  @brief Gets the \ref HidNpadSystemButtonProperties for the specified Npad.
##  @param[in] id \ref HidNpadIdType
##  @param[out] out \ref HidNpadSystemButtonProperties
##

proc hidGetNpadPowerInfoSingle*(id: HidNpadIdType; info: ptr HidPowerInfo) {.cdecl,
    importc: "hidGetNpadPowerInfoSingle".}
## *
##  @brief Gets the main \ref HidPowerInfo for the specified Npad.
##  @param[in] id \ref HidNpadIdType
##  @param[out] info \ref HidPowerInfo
##

proc hidGetNpadPowerInfoSplit*(id: HidNpadIdType; infoLeft: ptr HidPowerInfo;
                              infoRight: ptr HidPowerInfo) {.cdecl,
    importc: "hidGetNpadPowerInfoSplit".}
## *
##  @brief Gets the left/right \ref HidPowerInfo for the specified Npad (Joy-Con pair in dual mode).
##  @param[in] id \ref HidNpadIdType
##  @param[out] info_left \ref HidPowerInfo
##  @param[out] info_right \ref HidPowerInfo
##

proc hidGetAppletFooterUiAttributesSet*(id: HidNpadIdType): U32 {.cdecl,
    importc: "hidGetAppletFooterUiAttributesSet".}
## *
##  @brief Gets the AppletFooterUiAttributesSet for the specified Npad.
##  @note Only available on [9.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @return Bitfield of AppletFooterUiAttribute (system).
##

proc hidGetAppletFooterUiTypes*(id: HidNpadIdType): HidAppletFooterUiType {.cdecl,
    importc: "hidGetAppletFooterUiTypes".}
## *
##  @brief Gets \ref HidAppletFooterUiType for the specified Npad.
##  @note Only available on [9.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @return \ref HidAppletFooterUiType
##

proc hidGetNpadLagerType*(id: HidNpadIdType): HidNpadLagerType {.cdecl,
    importc: "hidGetNpadLagerType".}
## *
##  @brief Gets \ref HidNpadLagerType for the specified Npad.
##  @param[in] id \ref HidNpadIdType
##  @return \ref HidNpadLagerType
##

proc hidGetNpadStatesFullKey*(id: HidNpadIdType; states: ptr HidNpadFullKeyState;
                             count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesFullKey".}
## *
##  @brief Gets \ref HidNpadFullKeyState.
##  @param[out] states Output array of \ref HidNpadFullKeyState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesHandheld*(id: HidNpadIdType; states: ptr HidNpadHandheldState;
                              count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesHandheld".}
## *
##  @brief Gets \ref HidNpadHandheldState.
##  @param[out] states Output array of \ref HidNpadHandheldState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesJoyDual*(id: HidNpadIdType; states: ptr HidNpadJoyDualState;
                             count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesJoyDual".}
## *
##  @brief Gets \ref HidNpadJoyDualState.
##  @param[out] states Output array of \ref HidNpadJoyDualState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesJoyLeft*(id: HidNpadIdType; states: ptr HidNpadJoyLeftState;
                             count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesJoyLeft".}
## *
##  @brief Gets \ref HidNpadJoyLeftState.
##  @param[out] states Output array of \ref HidNpadJoyLeftState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesJoyRight*(id: HidNpadIdType; states: ptr HidNpadJoyRightState;
                              count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesJoyRight".}
## *
##  @brief Gets \ref HidNpadJoyRightState.
##  @param[out] states Output array of \ref HidNpadJoyRightState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesGc*(id: HidNpadIdType; states: ptr HidNpadGcState; count: csize_t): csize_t {.
    cdecl, importc: "hidGetNpadStatesGc".}
## *
##  @brief Gets \ref HidNpadGcState.
##  @param[out] states Output array of \ref HidNpadGcState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesPalma*(id: HidNpadIdType; states: ptr HidNpadPalmaState;
                           count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesPalma".}
## *
##  @brief Gets \ref HidNpadPalmaState.
##  @param[out] states Output array of \ref HidNpadPalmaState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesLark*(id: HidNpadIdType; states: ptr HidNpadLarkState;
                          count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesLark".}
## *
##  @brief Gets \ref HidNpadLarkState.
##  @param[out] states Output array of \ref HidNpadLarkState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesHandheldLark*(id: HidNpadIdType;
                                  states: ptr HidNpadHandheldLarkState;
                                  count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesHandheldLark".}
## *
##  @brief Gets \ref HidNpadHandheldLarkState.
##  @param[out] states Output array of \ref HidNpadHandheldLarkState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesLucia*(id: HidNpadIdType; states: ptr HidNpadLuciaState;
                           count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesLucia".}
## *
##  @brief Gets \ref HidNpadLuciaState.
##  @param[out] states Output array of \ref HidNpadLuciaState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesLager*(id: HidNpadIdType; states: ptr HidNpadLagerState;
                           count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesLager".}
## *
##  @brief Gets \ref HidNpadLagerState.
##  @param[out] states Output array of \ref HidNpadLagerState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesSystemExt*(id: HidNpadIdType;
                               states: ptr HidNpadSystemExtState; count: csize_t): csize_t {.
    cdecl, importc: "hidGetNpadStatesSystemExt".}
## *
##  @brief Gets \ref HidNpadSystemExtState.
##  @param[out] states Output array of \ref HidNpadSystemExtState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetNpadStatesSystem*(id: HidNpadIdType; states: ptr HidNpadSystemState;
                            count: csize_t): csize_t {.cdecl,
    importc: "hidGetNpadStatesSystem".}
## *
##  @brief Gets \ref HidNpadSystemState.
##  @param[out] states Output array of \ref HidNpadSystemState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidGetSixAxisSensorStates*(handle: HidSixAxisSensorHandle;
                               states: ptr HidSixAxisSensorState; count: csize_t): csize_t {.
    cdecl, importc: "hidGetSixAxisSensorStates".}
## *
##  @brief Gets \ref HidSixAxisSensorState for the specified handle.
##  @param[in] handle \ref HidSixAxisSensorHandle
##  @param[out] states Output array of \ref HidSixAxisSensorState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidInitializeGesture*() {.cdecl, importc: "hidInitializeGesture".}
## /@}
## /@name Gesture
## /@{
## / Initialize Gesture. Must be called when Gesture is being used.
proc hidGetGestureStates*(states: ptr HidGestureState; count: csize_t): csize_t {.
    cdecl, importc: "hidGetGestureStates".}
## *
##  @brief Gets \ref HidGestureState.
##  @param[out] states Output array of \ref HidGestureState.
##  @param[in] count Size of the states array in entries.
##  @return Total output entries.
##

proc hidSendKeyboardLockKeyEvent*(events: U32): Result {.cdecl,
    importc: "hidSendKeyboardLockKeyEvent".}
## /@}
## *
##  @brief SendKeyboardLockKeyEvent
##  @note Same as \ref hidsysSendKeyboardLockKeyEvent.
##  @note Only available on [6.0.0+].
##  @param[in] events Bitfield of \ref HidKeyboardLockKeyEvent.
##

proc hidGetSixAxisSensorHandles*(handles: ptr HidSixAxisSensorHandle;
                                totalHandles: S32; id: HidNpadIdType;
                                style: HidNpadStyleTag): Result {.cdecl,
    importc: "hidGetSixAxisSensorHandles".}
## *
##  @brief Gets SixAxisSensorHandles.
##  @note Only ::HidNpadStyleTag_NpadJoyDual supports total_handles==2.
##  @param[out] handles Output array of \ref HidSixAxisSensorHandle.
##  @param[in] total_handles Total handles for the handles array. Must be 1 or 2, if 2 handles aren't supported by the specified style an error is thrown.
##  @param[in] id \ref HidNpadIdType
##  @param[in] style \ref HidNpadStyleTag
##

proc hidStartSixAxisSensor*(handle: HidSixAxisSensorHandle): Result {.cdecl,
    importc: "hidStartSixAxisSensor".}
## *
##  @brief Starts the SixAxisSensor for the specified handle.
##  @param[in] handle \ref HidSixAxisSensorHandle
##

proc hidStopSixAxisSensor*(handle: HidSixAxisSensorHandle): Result {.cdecl,
    importc: "hidStopSixAxisSensor".}
## *
##  @brief Stops the SixAxisSensor for the specified handle.
##  @param[in] handle \ref HidSixAxisSensorHandle
##

proc hidIsSixAxisSensorFusionEnabled*(handle: HidSixAxisSensorHandle;
                                     `out`: ptr bool): Result {.cdecl,
    importc: "hidIsSixAxisSensorFusionEnabled".}
## *
##  @brief IsSixAxisSensorFusionEnabled
##  @param[in] handle \ref HidSixAxisSensorHandle
##  @param[out] out Output flag.
##

proc hidEnableSixAxisSensorFusion*(handle: HidSixAxisSensorHandle; flag: bool): Result {.
    cdecl, importc: "hidEnableSixAxisSensorFusion".}
## *
##  @brief EnableSixAxisSensorFusion
##  @param[in] handle \ref HidSixAxisSensorHandle
##  @param[in] flag Flag
##

proc hidSetSixAxisSensorFusionParameters*(handle: HidSixAxisSensorHandle;
    unk0: cfloat; unk1: cfloat): Result {.cdecl, importc: "hidSetSixAxisSensorFusionParameters".}
## *
##  @brief SetSixAxisSensorFusionParameters
##  @param[in] handle \ref HidSixAxisSensorHandle
##  @param[in] unk0 Must be 0.0f-1.0f.
##  @param[in] unk1 Unknown
##

proc hidGetSixAxisSensorFusionParameters*(handle: HidSixAxisSensorHandle;
    unk0: ptr cfloat; unk1: ptr cfloat): Result {.cdecl,
    importc: "hidGetSixAxisSensorFusionParameters".}
## *
##  @brief GetSixAxisSensorFusionParameters
##  @param[in] handle \ref HidSixAxisSensorHandle
##  @param[out] unk0 Unknown
##  @param[out] unk1 Unknown
##

proc hidResetSixAxisSensorFusionParameters*(handle: HidSixAxisSensorHandle): Result {.
    cdecl, importc: "hidResetSixAxisSensorFusionParameters".}
## *
##  @brief ResetSixAxisSensorFusionParameters
##  @param[in] handle \ref HidSixAxisSensorHandle
##

proc hidSetGyroscopeZeroDriftMode*(handle: HidSixAxisSensorHandle;
                                  mode: HidGyroscopeZeroDriftMode): Result {.cdecl,
    importc: "hidSetGyroscopeZeroDriftMode".}
## *
##  @brief Sets the ::HidGyroscopeZeroDriftMode for the specified SixAxisSensorHandle.
##  @param[in] handle \ref HidSixAxisSensorHandle
##  @param[in] mode \ref HidGyroscopeZeroDriftMode
##

proc hidGetGyroscopeZeroDriftMode*(handle: HidSixAxisSensorHandle;
                                  mode: ptr HidGyroscopeZeroDriftMode): Result {.
    cdecl, importc: "hidGetGyroscopeZeroDriftMode".}
## *
##  @brief Gets the ::HidGyroscopeZeroDriftMode for the specified SixAxisSensorHandle.
##  @param[in] handle \ref HidSixAxisSensorHandle
##  @param[out] mode \ref HidGyroscopeZeroDriftMode
##

proc hidResetGyroscopeZeroDriftMode*(handle: HidSixAxisSensorHandle): Result {.
    cdecl, importc: "hidResetGyroscopeZeroDriftMode".}
## *
##  @brief Resets the ::HidGyroscopeZeroDriftMode for the specified SixAxisSensorHandle to ::HidGyroscopeZeroDriftMode_Standard.
##  @param[in] handle \ref HidSixAxisSensorHandle
##

proc hidIsSixAxisSensorAtRest*(handle: HidSixAxisSensorHandle; `out`: ptr bool): Result {.
    cdecl, importc: "hidIsSixAxisSensorAtRest".}
## *
##  @brief IsSixAxisSensorAtRest
##  @param[in] handle \ref HidSixAxisSensorHandle
##  @param[out] out Output flag.
##

proc hidIsFirmwareUpdateAvailableForSixAxisSensor*(
    handle: HidSixAxisSensorHandle; `out`: ptr bool): Result {.cdecl,
    importc: "hidIsFirmwareUpdateAvailableForSixAxisSensor".}
## *
##  @brief IsFirmwareUpdateAvailableForSixAxisSensor
##  @note Only available on [6.0.0+].
##  @param[in] handle \ref HidSixAxisSensorHandle
##  @param[out] out Output flag.
##

proc hidSetSupportedNpadStyleSet*(styleSet: U32): Result {.cdecl,
    importc: "hidSetSupportedNpadStyleSet".}
## *
##  @brief Sets which controller styles are supported.
##  @note This is automatically called with the needed styles in \ref hidScanInput when required.
##  @param[in] style_set Bitfield of \ref HidNpadStyleTag.
##

proc hidGetSupportedNpadStyleSet*(styleSet: ptr U32): Result {.cdecl,
    importc: "hidGetSupportedNpadStyleSet".}
## *
##  @brief Gets which controller styles are supported.
##  @param[out] style_set Bitfield of \ref HidNpadStyleTag.
##

proc hidSetSupportedNpadIdType*(ids: ptr HidNpadIdType; count: csize_t): Result {.
    cdecl, importc: "hidSetSupportedNpadIdType".}
## *
##  @brief Sets which \ref HidNpadIdType are supported.
##  @note This is automatically called with HidNpadIdType_No{1-8} and HidNpadIdType_Handheld when required in \ref hidScanInput.
##  @param[in] ids Input array of \ref HidNpadIdType.
##  @param[in] count Total entries in the ids array. Must be <=10.
##

proc hidAcquireNpadStyleSetUpdateEventHandle*(id: HidNpadIdType;
    outEvent: ptr Event; autoclear: bool): Result {.cdecl,
    importc: "hidAcquireNpadStyleSetUpdateEventHandle".}
## *
##  @brief Gets an Event which is signaled when the \ref hidGetNpadStyleSet output is updated for the specified controller.
##  @note The Event must be closed by the user once finished with it.
##  @param[in] id \ref HidNpadIdType
##  @param[out] out_event Output Event.
##  @param[in] autoclear The autoclear for the Event.
##

proc hidDisconnectNpad*(id: HidNpadIdType): Result {.cdecl,
    importc: "hidDisconnectNpad".}
## *
##  @brief DisconnectNpad
##  @param[in] id \ref HidNpadIdType
##

proc hidGetPlayerLedPattern*(id: HidNpadIdType; `out`: ptr U8): Result {.cdecl,
    importc: "hidGetPlayerLedPattern".}
## *
##  @brief GetPlayerLedPattern
##  @param[in] id \ref HidNpadIdType
##  @param[out] out Output value.
##

proc hidSetNpadJoyHoldType*(`type`: HidNpadJoyHoldType): Result {.cdecl,
    importc: "hidSetNpadJoyHoldType".}
## *
##  @brief Sets the \ref HidNpadJoyHoldType.
##  @note Used automatically by \ref hidScanInput when required.
##  @param[in] type \ref HidNpadJoyHoldType
##

proc hidGetNpadJoyHoldType*(`type`: ptr HidNpadJoyHoldType): Result {.cdecl,
    importc: "hidGetNpadJoyHoldType".}
## *
##  @brief Gets the \ref HidNpadJoyHoldType.
##  @param[out] type \ref HidNpadJoyHoldType
##

proc hidSetNpadJoyAssignmentModeSingleByDefault*(id: HidNpadIdType): Result {.cdecl,
    importc: "hidSetNpadJoyAssignmentModeSingleByDefault".}
## *
##  @brief This is the same as \ref hidSetNpadJoyAssignmentModeSingle, except ::HidNpadJoyDeviceType_Left is used for the type.
##  @param[in] id \ref HidNpadIdType, must be HidNpadIdType_No*.
##

proc hidSetNpadJoyAssignmentModeSingle*(id: HidNpadIdType;
                                       `type`: HidNpadJoyDeviceType): Result {.
    cdecl, importc: "hidSetNpadJoyAssignmentModeSingle".}
## *
##  @brief This is the same as \ref hidSetNpadJoyAssignmentModeSingleWithDestination, except without the output params.
##  @param[in] id \ref HidNpadIdType, must be HidNpadIdType_No*.
##  @param[in] type \ref HidNpadJoyDeviceType
##

proc hidSetNpadJoyAssignmentModeDual*(id: HidNpadIdType): Result {.cdecl,
    importc: "hidSetNpadJoyAssignmentModeDual".}
## *
##  @brief Use this if you want to use a pair of joy-cons as a single HidNpadIdType_No*. When used, both joy-cons in a pair should be used with this (HidNpadIdType_No1 and HidNpadIdType_No2 for example).
##  @note Used automatically by \ref hidScanInput when required.
##  @param[in] id \ref HidNpadIdType, must be HidNpadIdType_No*.
##

proc hidMergeSingleJoyAsDualJoy*(id0: HidNpadIdType; id1: HidNpadIdType): Result {.
    cdecl, importc: "hidMergeSingleJoyAsDualJoy".}
## *
##  @brief Merge two single joy-cons into a dual-mode controller. Use this after \ref hidSetNpadJoyAssignmentModeDual, when \ref hidSetNpadJoyAssignmentModeSingleByDefault was previously used (this includes using this manually at application exit).
##  @brief To be successful, id0/id1 must correspond to controllers supporting styles HidNpadStyleTag_NpadJoyLeft/Right, or HidNpadStyleTag_NpadJoyRight/Left.
##  @brief If successful, the id of the resulting dual controller is set to id0.
##  @param[in] id0 \ref HidNpadIdType
##  @param[in] id1 \ref HidNpadIdType
##

proc hidStartLrAssignmentMode*(): Result {.cdecl,
                                        importc: "hidStartLrAssignmentMode".}
## *
##  @brief StartLrAssignmentMode
##

proc hidStopLrAssignmentMode*(): Result {.cdecl, importc: "hidStopLrAssignmentMode".}
## *
##  @brief StopLrAssignmentMode
##

proc hidSetNpadHandheldActivationMode*(mode: HidNpadHandheldActivationMode): Result {.
    cdecl, importc: "hidSetNpadHandheldActivationMode".}
## *
##  @brief Sets the \ref HidNpadHandheldActivationMode.
##  @param[in] mode \ref HidNpadHandheldActivationMode
##

proc hidGetNpadHandheldActivationMode*(`out`: ptr HidNpadHandheldActivationMode): Result {.
    cdecl, importc: "hidGetNpadHandheldActivationMode".}
## *
##  @brief Gets the \ref HidNpadHandheldActivationMode.
##  @param[out] out \ref HidNpadHandheldActivationMode
##

proc hidSwapNpadAssignment*(id0: HidNpadIdType; id1: HidNpadIdType): Result {.cdecl,
    importc: "hidSwapNpadAssignment".}
## *
##  @brief SwapNpadAssignment
##  @param[in] id0 \ref HidNpadIdType
##  @param[in] id1 \ref HidNpadIdType
##

proc hidEnableUnintendedHomeButtonInputProtection*(id: HidNpadIdType; flag: bool): Result {.
    cdecl, importc: "hidEnableUnintendedHomeButtonInputProtection".}
## *
##  @brief EnableUnintendedHomeButtonInputProtection
##  @note To get the state of this, use \ref hidGetNpadSystemButtonProperties to access HidNpadSystemButtonProperties::is_unintended_home_button_input_protection_enabled.
##  @param[in] id \ref HidNpadIdType
##  @param[in] flag Whether UnintendedHomeButtonInputProtection is enabled.
##

proc hidSetNpadJoyAssignmentModeSingleWithDestination*(id: HidNpadIdType;
    `type`: HidNpadJoyDeviceType; flag: ptr bool; dest: ptr HidNpadIdType): Result {.
    cdecl, importc: "hidSetNpadJoyAssignmentModeSingleWithDestination".}
## *
##  @brief Use this if you want to use a single joy-con as a dedicated HidNpadIdType_No*. When used, both joy-cons in a pair should be used with this (HidNpadIdType_No1 and HidNpadIdType_No2 for example).
##  @note Only available on [5.0.0+].
##  @param[in] id \ref HidNpadIdType, must be HidNpadIdType_No*.
##  @param[in] type \ref HidNpadJoyDeviceType
##  @param[out] flag Whether the dest output is set.
##  @param[out] dest \ref HidNpadIdType
##

proc hidSetNpadAnalogStickUseCenterClamp*(flag: bool): Result {.cdecl,
    importc: "hidSetNpadAnalogStickUseCenterClamp".}
## *
##  @brief SetNpadAnalogStickUseCenterClamp
##  @note Only available on [6.1.0+].
##  @param[in] flag Flag
##

proc hidSetNpadCaptureButtonAssignment*(style: HidNpadStyleTag; buttons: U64): Result {.
    cdecl, importc: "hidSetNpadCaptureButtonAssignment".}
## *
##  @brief Assigns the button(s) which trigger the CaptureButton.
##  @note Only available on [8.0.0+].
##  @param[in] style \ref HidNpadStyleTag, exactly 1 bit must be set.
##  @param[in] buttons Bitfield of \ref HidNpadButton, multiple bits can be set.
##

proc hidClearNpadCaptureButtonAssignment*(): Result {.cdecl,
    importc: "hidClearNpadCaptureButtonAssignment".}
## *
##  @brief ClearNpadCaptureButtonAssignment
##  @note Only available on [8.0.0+].
##

proc hidInitializeVibrationDevices*(handles: ptr HidVibrationDeviceHandle;
                                   totalHandles: S32; id: HidNpadIdType;
                                   style: HidNpadStyleTag): Result {.cdecl,
    importc: "hidInitializeVibrationDevices".}
## *
##  @brief Gets and initializes vibration handles.
##  @note Only the following styles support total_handles 2: ::HidNpadStyleTag_NpadFullKey, ::HidNpadStyleTag_NpadHandheld, ::HidNpadStyleTag_NpadJoyDual, ::HidNpadStyleTag_NpadHandheldLark, ::HidNpadStyleTag_NpadSystem, ::HidNpadStyleTag_NpadSystemExt.
##  @param[out] handles Output array of \ref HidVibrationDeviceHandle.
##  @param[in] total_handles Total handles for the handles array. Must be 1 or 2, if 2 handles aren't supported by the specified style an error is thrown.
##  @param[in] id \ref HidNpadIdType
##  @param[in] style \ref HidNpadStyleTag
##

proc hidGetVibrationDeviceInfo*(handle: HidVibrationDeviceHandle;
                               `out`: ptr HidVibrationDeviceInfo): Result {.cdecl,
    importc: "hidGetVibrationDeviceInfo".}
## *
##  @brief Gets \ref HidVibrationDeviceInfo for the specified device.
##  @param[in] handle \ref HidVibrationDeviceHandle
##  @param[out] out \ref HidVibrationDeviceInfo
##

proc hidSendVibrationValue*(handle: HidVibrationDeviceHandle;
                           value: ptr HidVibrationValue): Result {.cdecl,
    importc: "hidSendVibrationValue".}
## *
##  @brief Sends the \ref HidVibrationDeviceHandle to the specified device.
##  @note With ::HidVibrationDeviceType_GcErm, use \ref hidSendVibrationGcErmCommand instead.
##  @param[in] handle \ref HidVibrationDeviceHandle
##  @param[in] value \ref HidVibrationValue
##

proc hidGetActualVibrationValue*(handle: HidVibrationDeviceHandle;
                                `out`: ptr HidVibrationValue): Result {.cdecl,
    importc: "hidGetActualVibrationValue".}
## *
##  @brief Gets the current \ref HidVibrationValue for the specified device.
##  @note With ::HidVibrationDeviceType_GcErm, use \ref hidGetActualVibrationGcErmCommand instead.
##  @param[in] handle \ref HidVibrationDeviceHandle
##  @param[out] out \ref HidVibrationValue
##

proc hidPermitVibration*(flag: bool): Result {.cdecl, importc: "hidPermitVibration".}
## *
##  @brief Sets whether vibration is allowed, this also affects the config displayed by System Settings.
##  @param[in] flag Flag
##

proc hidIsVibrationPermitted*(flag: ptr bool): Result {.cdecl,
    importc: "hidIsVibrationPermitted".}
## *
##  @brief Gets whether vibration is allowed.
##  @param[out] flag Flag
##

proc hidSendVibrationValues*(handles: ptr HidVibrationDeviceHandle;
                            values: ptr HidVibrationValue; count: S32): Result {.
    cdecl, importc: "hidSendVibrationValues".}
## *
##  @brief Send vibration values[index] to handles[index].
##  @note With ::HidVibrationDeviceType_GcErm, use \ref hidSendVibrationGcErmCommand instead.
##  @param[in] handles Input array of \ref HidVibrationDeviceHandle.
##  @param[in] values Input array of \ref HidVibrationValue.
##  @param[in] count Total entries in the handles/values arrays.
##

proc hidSendVibrationGcErmCommand*(handle: HidVibrationDeviceHandle;
                                  cmd: HidVibrationGcErmCommand): Result {.cdecl,
    importc: "hidSendVibrationGcErmCommand".}
## *
##  @brief Send \ref HidVibrationGcErmCommand to the specified device, for ::HidVibrationDeviceType_GcErm.
##  @note Only available on [4.0.0+].
##  @param[in] handle \ref HidVibrationDeviceHandle
##  @param[in] cmd \ref HidVibrationGcErmCommand
##

proc hidGetActualVibrationGcErmCommand*(handle: HidVibrationDeviceHandle;
                                       `out`: ptr HidVibrationGcErmCommand): Result {.
    cdecl, importc: "hidGetActualVibrationGcErmCommand".}
## *
##  @brief Get \ref HidVibrationGcErmCommand for the specified device, for ::HidVibrationDeviceType_GcErm.
##  @note Only available on [4.0.0+].
##  @param[in] handle \ref HidVibrationDeviceHandle
##  @param[out] out \ref HidVibrationGcErmCommand
##

proc hidBeginPermitVibrationSession*(): Result {.cdecl,
    importc: "hidBeginPermitVibrationSession".}
## *
##  @brief Begins a forced-permitted vibration session.
##  @note Only available on [4.0.0+].
##

proc hidEndPermitVibrationSession*(): Result {.cdecl,
    importc: "hidEndPermitVibrationSession".}
## *
##  @brief Ends the session started by \ref hidBeginPermitVibrationSession.
##  @note Only available on [4.0.0+].
##

proc hidIsVibrationDeviceMounted*(handle: HidVibrationDeviceHandle; flag: ptr bool): Result {.
    cdecl, importc: "hidIsVibrationDeviceMounted".}
## *
##  @brief Gets whether vibration is available with the specified device.
##  @note Only available on [7.0.0+].
##  @param[in] handle \ref HidVibrationDeviceHandle
##  @param[out] flag Flag
##

proc hidStartSevenSixAxisSensor*(): Result {.cdecl,
    importc: "hidStartSevenSixAxisSensor".}
## *
##  @brief Starts the SevenSixAxisSensor.
##  @note Only available on [5.0.0+].
##

proc hidStopSevenSixAxisSensor*(): Result {.cdecl,
    importc: "hidStopSevenSixAxisSensor".}
## *
##  @brief Stops the SevenSixAxisSensor.
##  @note Only available on [5.0.0+].
##

proc hidInitializeSevenSixAxisSensor*(): Result {.cdecl,
    importc: "hidInitializeSevenSixAxisSensor".}
## *
##  @brief Initializes the SevenSixAxisSensor.
##  @note Only available on [5.0.0+].
##

proc hidFinalizeSevenSixAxisSensor*(): Result {.cdecl,
    importc: "hidFinalizeSevenSixAxisSensor".}
## *
##  @brief Finalizes the SevenSixAxisSensor.
##  @note This must be called before \ref hidExit.
##  @note Only available on [5.0.0+].
##

proc hidSetSevenSixAxisSensorFusionStrength*(strength: cfloat): Result {.cdecl,
    importc: "hidSetSevenSixAxisSensorFusionStrength".}
## *
##  @brief Sets the SevenSixAxisSensor FusionStrength.
##  @note Only available on [5.0.0+].
##  @param[in] strength Strength
##

proc hidGetSevenSixAxisSensorFusionStrength*(strength: ptr cfloat): Result {.cdecl,
    importc: "hidGetSevenSixAxisSensorFusionStrength".}
## *
##  @brief Gets the SevenSixAxisSensor FusionStrength.
##  @note Only available on [5.0.0+].
##  @param[out] strength Strength
##

proc hidResetSevenSixAxisSensorTimestamp*(): Result {.cdecl,
    importc: "hidResetSevenSixAxisSensorTimestamp".}
## *
##  @brief Resets the timestamp for the SevenSixAxisSensor.
##  @note Only available on [6.0.0+].
##

proc hidGetSevenSixAxisSensorStates*(states: ptr HidSevenSixAxisSensorState;
                                    count: csize_t; totalOut: ptr csize_t): Result {.
    cdecl, importc: "hidGetSevenSixAxisSensorStates".}
## *
##  @brief GetSevenSixAxisSensorStates
##  @note Only available when \ref hidInitializeSevenSixAxisSensor was previously used.
##  @param[out] states Output array of \ref HidSevenSixAxisSensorState.
##  @param[in] count Size of the states array in entries.
##  @param[out] total_out Total output entries.
##

proc hidIsSevenSixAxisSensorAtRest*(`out`: ptr bool): Result {.cdecl,
    importc: "hidIsSevenSixAxisSensorAtRest".}
## *
##  @brief IsSevenSixAxisSensorAtRest
##  @note Only available when \ref hidInitializeSevenSixAxisSensor was previously used.
##  @param[out] out Output flag.
##

proc hidGetSensorFusionError*(`out`: ptr cfloat): Result {.cdecl,
    importc: "hidGetSensorFusionError".}
## *
##  @brief GetSensorFusionError
##  @note Only available when \ref hidInitializeSevenSixAxisSensor was previously used.
##  @param[out] out Output data.
##

proc hidGetGyroBias*(`out`: ptr UtilFloat3): Result {.cdecl, importc: "hidGetGyroBias".}
## *
##  @brief GetGyroBias
##  @note Only available when \ref hidInitializeSevenSixAxisSensor was previously used.
##  @param[out] out \ref UtilFloat3
##

proc hidIsUsbFullKeyControllerEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "hidIsUsbFullKeyControllerEnabled".}
## *
##  @brief IsUsbFullKeyControllerEnabled
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc hidEnableUsbFullKeyController*(flag: bool): Result {.cdecl,
    importc: "hidEnableUsbFullKeyController".}
## *
##  @brief EnableUsbFullKeyController
##  @note Only available on [3.0.0+].
##  @param[in] flag Flag
##

proc hidIsUsbFullKeyControllerConnected*(id: HidNpadIdType; `out`: ptr bool): Result {.
    cdecl, importc: "hidIsUsbFullKeyControllerConnected".}
## *
##  @brief IsUsbFullKeyControllerConnected
##  @note Only available on [3.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @param[out] out Output flag.
##

proc hidGetNpadInterfaceType*(id: HidNpadIdType; `out`: ptr U8): Result {.cdecl,
    importc: "hidGetNpadInterfaceType".}
## *
##  @brief Gets the \ref HidNpadInterfaceType for the specified controller.
##  @note When available, \ref hidsysGetNpadInterfaceType should be used instead.
##  @note Only available on [4.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @param[out] out \ref HidNpadInterfaceType
##

proc hidGetNpadOfHighestBatteryLevel*(ids: ptr HidNpadIdType; count: csize_t;
                                     `out`: ptr HidNpadIdType): Result {.cdecl,
    importc: "hidGetNpadOfHighestBatteryLevel".}
## *
##  @brief GetNpadOfHighestBatteryLevel
##  @note Only available on [10.0.0+].
##  @param[in] ids Input array of \ref HidNpadIdType, ::HidNpadIdType_Handheld is ignored.
##  @param[in] count Total entries in the ids array.
##  @param[out] out \ref HidNpadIdType
##

proc hidGetPalmaConnectionHandle*(id: HidNpadIdType;
                                 `out`: ptr HidPalmaConnectionHandle): Result {.
    cdecl, importc: "hidGetPalmaConnectionHandle".}
## /@name Palma, see ::HidNpadStyleTag_NpadPalma.
## /@{
## *
##  @brief GetPalmaConnectionHandle
##  @note Only available on [5.0.0+].
##  @param[in] id \ref HidNpadIdType
##  @param[out] out \ref HidPalmaConnectionHandle
##

proc hidInitializePalma*(handle: HidPalmaConnectionHandle): Result {.cdecl,
    importc: "hidInitializePalma".}
## *
##  @brief InitializePalma
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##

proc hidAcquirePalmaOperationCompleteEvent*(handle: HidPalmaConnectionHandle;
    outEvent: ptr Event; autoclear: bool): Result {.cdecl,
    importc: "hidAcquirePalmaOperationCompleteEvent".}
## *
##  @brief Gets an Event which is signaled when data is available with \ref hidGetPalmaOperationInfo.
##  @note The Event must be closed by the user once finished with it.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[out] out_event Output Event.
##  @param[in] autoclear The autoclear for the Event.
##

proc hidGetPalmaOperationInfo*(handle: HidPalmaConnectionHandle;
                              `out`: ptr HidPalmaOperationInfo): Result {.cdecl,
    importc: "hidGetPalmaOperationInfo".}
## *
##  @brief Gets \ref HidPalmaOperationInfo for a completed operation.
##  @note This must be used at some point following using any of the other Palma cmds which trigger an Operation, once the Event from \ref hidAcquirePalmaOperationCompleteEvent is signaled. Up to 4 Operations can be queued at once, the other cmds will throw an error once there's too many operations.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[out] out \ref HidPalmaOperationInfo
##

proc hidPlayPalmaActivity*(handle: HidPalmaConnectionHandle; val: U16): Result {.
    cdecl, importc: "hidPlayPalmaActivity".}
## *
##  @brief PlayPalmaActivity
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] val Input value.
##

proc hidSetPalmaFrModeType*(handle: HidPalmaConnectionHandle;
                           `type`: HidPalmaFrModeType): Result {.cdecl,
    importc: "hidSetPalmaFrModeType".}
## *
##  @brief SetPalmaFrModeType
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] type \ref HidPalmaFrModeType
##

proc hidReadPalmaStep*(handle: HidPalmaConnectionHandle): Result {.cdecl,
    importc: "hidReadPalmaStep".}
## *
##  @brief ReadPalmaStep
##  @note See \ref hidGetPalmaOperationInfo.
##  @note \ref hidEnablePalmaStep should be used before this.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##

proc hidEnablePalmaStep*(handle: HidPalmaConnectionHandle; flag: bool): Result {.
    cdecl, importc: "hidEnablePalmaStep".}
## *
##  @brief EnablePalmaStep
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] flag Flag
##

proc hidResetPalmaStep*(handle: HidPalmaConnectionHandle): Result {.cdecl,
    importc: "hidResetPalmaStep".}
## *
##  @brief ResetPalmaStep
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##

proc hidReadPalmaApplicationSection*(handle: HidPalmaConnectionHandle; inval0: S32;
                                    size: U64): Result {.cdecl,
    importc: "hidReadPalmaApplicationSection".}
## *
##  @brief ReadPalmaApplicationSection
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] inval0 First input value.
##  @param[in] size This must be within the size of \ref HidPalmaApplicationSectionAccessBuffer.
##

proc hidWritePalmaApplicationSection*(handle: HidPalmaConnectionHandle;
                                     inval0: S32; size: U64; buf: ptr HidPalmaApplicationSectionAccessBuffer): Result {.
    cdecl, importc: "hidWritePalmaApplicationSection".}
## *
##  @brief WritePalmaApplicationSection
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] inval0 First input value.
##  @param[in] size Size of the data in \ref HidPalmaApplicationSectionAccessBuffer.
##  @param[in] buf \ref HidPalmaApplicationSectionAccessBuffer
##

proc hidReadPalmaUniqueCode*(handle: HidPalmaConnectionHandle): Result {.cdecl,
    importc: "hidReadPalmaUniqueCode".}
## *
##  @brief ReadPalmaUniqueCode
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##

proc hidSetPalmaUniqueCodeInvalid*(handle: HidPalmaConnectionHandle): Result {.
    cdecl, importc: "hidSetPalmaUniqueCodeInvalid".}
## *
##  @brief SetPalmaUniqueCodeInvalid
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##

proc hidWritePalmaActivityEntry*(handle: HidPalmaConnectionHandle; unk: U16;
                                entry: ptr HidPalmaActivityEntry): Result {.cdecl,
    importc: "hidWritePalmaActivityEntry".}
## *
##  @brief WritePalmaActivityEntry
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] unk Unknown
##  @param[in] entry \ref HidPalmaActivityEntry
##

proc hidWritePalmaRgbLedPatternEntry*(handle: HidPalmaConnectionHandle; unk: U16;
                                     buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "hidWritePalmaRgbLedPatternEntry".}
## *
##  @brief WritePalmaRgbLedPatternEntry
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] unk Unknown
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size.
##

proc hidWritePalmaWaveEntry*(handle: HidPalmaConnectionHandle;
                            waveSet: HidPalmaWaveSet; unk: U16; buffer: pointer;
                            tmemSize: csize_t; size: csize_t): Result {.cdecl,
    importc: "hidWritePalmaWaveEntry".}
## *
##  @brief WritePalmaWaveEntry
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] wave_set \ref HidPalmaWaveSet
##  @param[in] unk Unknown
##  @param[in] buffer TransferMemory buffer, must be 0x1000-byte aligned.
##  @param[in] tmem_size TransferMemory buffer size, must be 0x1000-byte aligned.
##  @param[in] size Actual size of the data in the buffer.
##

proc hidSetPalmaDataBaseIdentificationVersion*(handle: HidPalmaConnectionHandle;
    version: S32): Result {.cdecl,
                         importc: "hidSetPalmaDataBaseIdentificationVersion".}
## *
##  @brief SetPalmaDataBaseIdentificationVersion
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] version Version
##

proc hidGetPalmaDataBaseIdentificationVersion*(handle: HidPalmaConnectionHandle): Result {.
    cdecl, importc: "hidGetPalmaDataBaseIdentificationVersion".}
## *
##  @brief GetPalmaDataBaseIdentificationVersion
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##

proc hidSuspendPalmaFeature*(handle: HidPalmaConnectionHandle; features: U32): Result {.
    cdecl, importc: "hidSuspendPalmaFeature".}
## *
##  @brief SuspendPalmaFeature
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] features Bitfield of \ref HidPalmaFeature.
##

proc hidReadPalmaPlayLog*(handle: HidPalmaConnectionHandle; unk: U16): Result {.cdecl,
    importc: "hidReadPalmaPlayLog".}
## *
##  @brief ReadPalmaPlayLog
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.1.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] unk Unknown
##

proc hidResetPalmaPlayLog*(handle: HidPalmaConnectionHandle; unk: U16): Result {.
    cdecl, importc: "hidResetPalmaPlayLog".}
## *
##  @brief ResetPalmaPlayLog
##  @note See \ref hidGetPalmaOperationInfo.
##  @note Only available on [5.1.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[in] unk Unknown
##

proc hidSetIsPalmaAllConnectable*(flag: bool): Result {.cdecl,
    importc: "hidSetIsPalmaAllConnectable".}
## *
##  @brief Sets whether any Palma can connect.
##  @note Only available on [5.1.0+].
##  @param[in] flag Flag
##

proc hidSetIsPalmaPairedConnectable*(flag: bool): Result {.cdecl,
    importc: "hidSetIsPalmaPairedConnectable".}
## *
##  @brief Sets whether paired Palma can connect.
##  @note Only available on [5.1.0+].
##  @param[in] flag Flag
##

proc hidPairPalma*(handle: HidPalmaConnectionHandle): Result {.cdecl,
    importc: "hidPairPalma".}
## *
##  @brief PairPalma
##  @note Only available on [5.1.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##

proc hidCancelWritePalmaWaveEntry*(handle: HidPalmaConnectionHandle): Result {.
    cdecl, importc: "hidCancelWritePalmaWaveEntry".}
## *
##  @brief CancelWritePalmaWaveEntry
##  @note Only available on [7.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##

proc hidEnablePalmaBoostMode*(flag: bool): Result {.cdecl,
    importc: "hidEnablePalmaBoostMode".}
## *
##  @brief EnablePalmaBoostMode
##  @note Only available on [5.1.0+]. Uses cmd EnablePalmaBoostMode on [8.0.0+], otherwise cmd SetPalmaBoostMode is used.
##  @param[in] flag Flag
##

proc hidGetPalmaBluetoothAddress*(handle: HidPalmaConnectionHandle;
                                 `out`: ptr BtdrvAddress): Result {.cdecl,
    importc: "hidGetPalmaBluetoothAddress".}
## *
##  @brief GetPalmaBluetoothAddress
##  @note Only available on [8.0.0+].
##  @param[in] handle \ref HidPalmaConnectionHandle
##  @param[out] out \ref BtdrvAddress
##

proc hidSetDisallowedPalmaConnection*(addrs: ptr BtdrvAddress; count: S32): Result {.
    cdecl, importc: "hidSetDisallowedPalmaConnection".}
## *
##  @brief SetDisallowedPalmaConnection
##  @note Only available on [8.0.0+].
##  @param[in] addrs Input array of \ref BtdrvAddress.
##  @param[in] count Total entries in the addrs array.
##

proc hidSetNpadCommunicationMode*(mode: HidNpadCommunicationMode): Result {.cdecl,
    importc: "hidSetNpadCommunicationMode".}
## /@}
## *
##  @brief SetNpadCommunicationMode
##  @note [2.0.0+] Stubbed, just returns 0.
##  @param[in] mode \ref HidNpadCommunicationMode
##

proc hidGetNpadCommunicationMode*(`out`: ptr HidNpadCommunicationMode): Result {.
    cdecl, importc: "hidGetNpadCommunicationMode".}
## *
##  @brief GetNpadCommunicationMode
##  @note [2.0.0+] Stubbed, always returns output mode ::HidNpadCommunicationMode_Default.
##  @param[out] out \ref HidNpadCommunicationMode
##

proc hidSetTouchScreenConfiguration*(config: ptr HidTouchScreenConfigurationForNx): Result {.
    cdecl, importc: "hidSetTouchScreenConfiguration".}
## *
##  @brief SetTouchScreenConfiguration
##  @note Only available on [9.0.0+].
##  @param[in] config \ref HidTouchScreenConfigurationForNx
##

proc hidIsFirmwareUpdateNeededForNotification*(`out`: ptr bool): Result {.cdecl,
    importc: "hidIsFirmwareUpdateNeededForNotification".}
## *
##  @brief IsFirmwareUpdateNeededForNotification
##  @note Only available on [9.0.0+].
##  @param[out] out Output flag.
##

