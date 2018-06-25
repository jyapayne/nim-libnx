import strutils
import ospaths
const headerhid = currentSourcePath().splitPath().head & "/nx/include/switch/services/hid.h"
## *
##  @file hid.h
##  @brief Human input device (hid) service IPC wrapper.
##  @author shinyquagsire23
##  @author yellows8
##  @copyright libnx Authors
## 

import
  libnx/wrapper/types, libnx/wrapper/sm

##  Begin enums and output structs

type
  HidMouseButton* {.size: sizeof(cint).} = enum
    MOUSE_LEFT = BIT(0), MOUSE_RIGHT = BIT(1), MOUSE_MIDDLE = BIT(2),
    MOUSE_FORWARD = BIT(3), MOUSE_BACK = BIT(4)
  HidKeyboardModifier* {.size: sizeof(cint).} = enum
    KBD_MOD_LCTRL = BIT(0), KBD_MOD_LSHIFT = BIT(1), KBD_MOD_LALT = BIT(2),
    KBD_MOD_LMETA = BIT(3), KBD_MOD_RCTRL = BIT(4), KBD_MOD_RSHIFT = BIT(5),
    KBD_MOD_RALT = BIT(6), KBD_MOD_RMETA = BIT(7), KBD_MOD_CAPSLOCK = BIT(8),
    KBD_MOD_SCROLLLOCK = BIT(9), KBD_MOD_NUMLOCK = BIT(10)
  HidKeyboardScancode* {.size: sizeof(cint).} = enum
    KBD_NONE = 0x00000000, KBD_ERR_OVF = 0x00000001, KBD_A = 0x00000004,
    KBD_B = 0x00000005, KBD_C = 0x00000006, KBD_D = 0x00000007, KBD_E = 0x00000008,
    KBD_F = 0x00000009, KBD_G = 0x0000000A, KBD_H = 0x0000000B, KBD_I = 0x0000000C,
    KBD_J = 0x0000000D, KBD_K = 0x0000000E, KBD_L = 0x0000000F, KBD_M = 0x00000010,
    KBD_N = 0x00000011, KBD_O = 0x00000012, KBD_P = 0x00000013, KBD_Q = 0x00000014,
    KBD_R = 0x00000015, KBD_S = 0x00000016, KBD_T = 0x00000017, KBD_U = 0x00000018,
    KBD_V = 0x00000019, KBD_W = 0x0000001A, KBD_X = 0x0000001B, KBD_Y = 0x0000001C,
    KBD_Z = 0x0000001D, KBD_1 = 0x0000001E, KBD_2 = 0x0000001F, KBD_3 = 0x00000020,
    KBD_4 = 0x00000021, KBD_5 = 0x00000022, KBD_6 = 0x00000023, KBD_7 = 0x00000024,
    KBD_8 = 0x00000025, KBD_9 = 0x00000026, KBD_0 = 0x00000027, KBD_ENTER = 0x00000028,
    KBD_ESC = 0x00000029, KBD_BACKSPACE = 0x0000002A, KBD_TAB = 0x0000002B,
    KBD_SPACE = 0x0000002C, KBD_MINUS = 0x0000002D, KBD_EQUAL = 0x0000002E,
    KBD_LEFTBRACE = 0x0000002F, KBD_RIGHTBRACE = 0x00000030,
    KBD_BACKSLASH = 0x00000031, KBD_HASHTILDE = 0x00000032,
    KBD_SEMICOLON = 0x00000033, KBD_APOSTROPHE = 0x00000034, KBD_GRAVE = 0x00000035,
    KBD_COMMA = 0x00000036, KBD_DOT = 0x00000037, KBD_SLASH = 0x00000038,
    KBD_CAPSLOCK = 0x00000039, KBD_F1 = 0x0000003A, KBD_F2 = 0x0000003B,
    KBD_F3 = 0x0000003C, KBD_F4 = 0x0000003D, KBD_F5 = 0x0000003E, KBD_F6 = 0x0000003F,
    KBD_F7 = 0x00000040, KBD_F8 = 0x00000041, KBD_F9 = 0x00000042, KBD_F10 = 0x00000043,
    KBD_F11 = 0x00000044, KBD_F12 = 0x00000045, KBD_SYSRQ = 0x00000046,
    KBD_SCROLLLOCK = 0x00000047, KBD_PAUSE = 0x00000048, KBD_INSERT = 0x00000049,
    KBD_HOME = 0x0000004A, KBD_PAGEUP = 0x0000004B, KBD_DELETE = 0x0000004C,
    KBD_END = 0x0000004D, KBD_PAGEDOWN = 0x0000004E, KBD_RIGHT = 0x0000004F,
    KBD_LEFT = 0x00000050, KBD_DOWN = 0x00000051, KBD_UP = 0x00000052,
    KBD_NUMLOCK = 0x00000053, KBD_KPSLASH = 0x00000054, KBD_KPASTERISK = 0x00000055,
    KBD_KPMINUS = 0x00000056, KBD_KPPLUS = 0x00000057, KBD_KPENTER = 0x00000058,
    KBD_KP1 = 0x00000059, KBD_KP2 = 0x0000005A, KBD_KP3 = 0x0000005B,
    KBD_KP4 = 0x0000005C, KBD_KP5 = 0x0000005D, KBD_KP6 = 0x0000005E,
    KBD_KP7 = 0x0000005F, KBD_KP8 = 0x00000060, KBD_KP9 = 0x00000061,
    KBD_KP0 = 0x00000062, KBD_KPDOT = 0x00000063, KBD_102ND = 0x00000064,
    KBD_COMPOSE = 0x00000065, KBD_POWER = 0x00000066, KBD_KPEQUAL = 0x00000067,
    KBD_F13 = 0x00000068, KBD_F14 = 0x00000069, KBD_F15 = 0x0000006A,
    KBD_F16 = 0x0000006B, KBD_F17 = 0x0000006C, KBD_F18 = 0x0000006D,
    KBD_F19 = 0x0000006E, KBD_F20 = 0x0000006F, KBD_F21 = 0x00000070,
    KBD_F22 = 0x00000071, KBD_F23 = 0x00000072, KBD_F24 = 0x00000073,
    KBD_OPEN = 0x00000074, KBD_HELP = 0x00000075, KBD_PROPS = 0x00000076,
    KBD_FRONT = 0x00000077, KBD_STOP = 0x00000078, KBD_AGAIN = 0x00000079,
    KBD_UNDO = 0x0000007A, KBD_CUT = 0x0000007B, KBD_COPY = 0x0000007C,
    KBD_PASTE = 0x0000007D, KBD_FIND = 0x0000007E, KBD_MUTE = 0x0000007F,
    KBD_VOLUMEUP = 0x00000080, KBD_VOLUMEDOWN = 0x00000081,
    KBD_CAPSLOCK_ACTIVE = 0x00000082, KBD_NUMLOCK_ACTIVE = 0x00000083,
    KBD_SCROLLLOCK_ACTIVE = 0x00000084, KBD_KPCOMMA = 0x00000085,
    KBD_KPLEFTPAREN = 0x000000B6, KBD_KPRIGHTPAREN = 0x000000B7,
    KBD_LEFTCTRL = 0x000000E0, KBD_LEFTSHIFT = 0x000000E1, KBD_LEFTALT = 0x000000E2,
    KBD_LEFTMETA = 0x000000E3, KBD_RIGHTCTRL = 0x000000E4,
    KBD_RIGHTSHIFT = 0x000000E5, KBD_RIGHTALT = 0x000000E6,
    KBD_RIGHTMETA = 0x000000E7, KBD_MEDIA_PLAYPAUSE = 0x000000E8,
    KBD_MEDIA_STOPCD = 0x000000E9, KBD_MEDIA_PREVIOUSSONG = 0x000000EA,
    KBD_MEDIA_NEXTSONG = 0x000000EB, KBD_MEDIA_EJECTCD = 0x000000EC,
    KBD_MEDIA_VOLUMEUP = 0x000000ED, KBD_MEDIA_VOLUMEDOWN = 0x000000EE,
    KBD_MEDIA_MUTE = 0x000000EF, KBD_MEDIA_WWW = 0x000000F0,
    KBD_MEDIA_BACK = 0x000000F1, KBD_MEDIA_FORWARD = 0x000000F2,
    KBD_MEDIA_STOP = 0x000000F3, KBD_MEDIA_FIND = 0x000000F4,
    KBD_MEDIA_SCROLLUP = 0x000000F5, KBD_MEDIA_SCROLLDOWN = 0x000000F6,
    KBD_MEDIA_EDIT = 0x000000F7, KBD_MEDIA_SLEEP = 0x000000F8,
    KBD_MEDIA_COFFEE = 0x000000F9, KBD_MEDIA_REFRESH = 0x000000FA,
    KBD_MEDIA_CALC = 0x000000FB
  HidControllerType* {.size: sizeof(cint).} = enum
    TYPE_PROCONTROLLER = BIT(0), TYPE_HANDHELD = BIT(1), TYPE_JOYCON_PAIR = BIT(2),
    TYPE_JOYCON_LEFT = BIT(3), TYPE_JOYCON_RIGHT = BIT(4)
  HidControllerLayoutType* {.size: sizeof(cint).} = enum
    LAYOUT_PROCONTROLLER = 0,   ##  Pro Controller or Hid gamepad
    LAYOUT_HANDHELD = 1,        ##  Two Joy-Con docked to rails
    LAYOUT_SINGLE = 2,          ##  Horizontal single Joy-Con or pair of Joy-Con, adjusted for orientation
    LAYOUT_LEFT = 3,            ##  Only raw left Joy-Con state, no orientation adjustment
    LAYOUT_RIGHT = 4,           ##  Only raw right Joy-Con state, no orientation adjustment
    LAYOUT_DEFAULT_DIGITAL = 5, ##  Same as next, but sticks have 8-direction values only
    LAYOUT_DEFAULT = 6          ##  Safe default, single Joy-Con have buttons/sticks rotated for orientation
  HidControllerColorDescription* {.size: sizeof(cint).} = enum
    COLORS_NONEXISTENT = BIT(1)
  HidControllerKeys* {.size: sizeof(cint).} = enum
    KEY_A = BIT(0),             ## /< A
    KEY_B = BIT(1),             ## /< B
    KEY_X = BIT(2),             ## /< X
    KEY_Y = BIT(3),             ## /< Y
    KEY_LSTICK = BIT(4),        ## /< Left Stick Button
    KEY_RSTICK = BIT(5),        ## /< Right Stick Button
    KEY_L = BIT(6),             ## /< L
    KEY_R = BIT(7),             ## /< R
    KEY_ZL = BIT(8),            ## /< ZL
    KEY_ZR = BIT(9),            ## /< ZR
    KEY_PLUS = BIT(10),         ## /< Plus
    KEY_MINUS = BIT(11),        ## /< Minus
    KEY_DLEFT = BIT(12),        ## /< D-Pad Left
    KEY_DUP = BIT(13),          ## /< D-Pad Up
    KEY_DRIGHT = BIT(14),       ## /< D-Pad Right
    KEY_DDOWN = BIT(15),        ## /< D-Pad Down
    KEY_LSTICK_LEFT = BIT(16),  ## /< Left Stick Left
    KEY_LSTICK_UP = BIT(17),    ## /< Left Stick Up
    KEY_LSTICK_RIGHT = BIT(18), ## /< Left Stick Right
    KEY_LSTICK_DOWN = BIT(19),  ## /< Left Stick Down
    KEY_RSTICK_LEFT = BIT(20),  ## /< Right Stick Left
    KEY_LEFT = KEY_DLEFT.int or KEY_LSTICK_LEFT.int or KEY_RSTICK_LEFT.int, ## /< D-Pad Left or Sticks Left
    KEY_RSTICK_UP = BIT(21),    ## /< Right Stick Up
    KEY_UP = KEY_DUP.int or KEY_LSTICK_UP.int or KEY_RSTICK_UP.int, ## /< D-Pad Up or Sticks Up
    KEY_RSTICK_RIGHT = BIT(22), ## /< Right Stick Right
    KEY_RIGHT = KEY_DRIGHT.int or KEY_LSTICK_RIGHT.int or KEY_RSTICK_RIGHT.int, ## /< D-Pad Right or Sticks Right
    KEY_RSTICK_DOWN = BIT(23),  ## /< Right Stick Down
    KEY_DOWN = KEY_DDOWN.int or KEY_LSTICK_DOWN.int or KEY_RSTICK_DOWN.int, ## /< D-Pad Down or Sticks Down
    KEY_SL = BIT(24),           ## /< SL
    KEY_SR = BIT(25),           ## /< SR
                   ##  Pseudo-key for at least one finger on the touch screen
    KEY_TOUCH = BIT(26),        ##  Buttons by orientation (for single Joy-Con), also works with Joy-Con pairs, Pro Controller
                   ##  Generic catch-all directions, also works for single Joy-Con


    

  HidControllerJoystick* {.size: sizeof(cint).} = enum
    JOYSTICK_LEFT = 0, JOYSTICK_RIGHT = 1, JOYSTICK_NUM_STICKS = 2
  HidControllerConnectionState* {.size: sizeof(cint).} = enum
    CONTROLLER_STATE_CONNECTED = BIT(0), CONTROLLER_STATE_WIRED = BIT(1)
  HidControllerID* {.size: sizeof(cint).} = enum
    CONTROLLER_PLAYER_1 = 0, CONTROLLER_PLAYER_2 = 1, CONTROLLER_PLAYER_3 = 2,
    CONTROLLER_PLAYER_4 = 3, CONTROLLER_PLAYER_5 = 4, CONTROLLER_PLAYER_6 = 5,
    CONTROLLER_PLAYER_7 = 6, CONTROLLER_PLAYER_8 = 7, CONTROLLER_HANDHELD = 8,
    CONTROLLER_UNKNOWN = 9, CONTROLLER_P1_AUTO = 10 ## / Not an actual HID-sysmodule ID. Only for hidKeys*()/hidJoystickRead(). Automatically uses CONTROLLER_PLAYER_1 when connected, otherwise uses CONTROLLER_HANDHELD.
  touchPosition* {.importc: "touchPosition", header: headerhid, bycopy.} = object
    px* {.importc: "px".}: uint32
    py* {.importc: "py".}: uint32
    dx* {.importc: "dx".}: uint32
    dy* {.importc: "dy".}: uint32
    angle* {.importc: "angle".}: uint32

  JoystickPosition* {.importc: "JoystickPosition", header: headerhid, bycopy.} = object
    dx* {.importc: "dx".}: s32
    dy* {.importc: "dy".}: s32

  MousePosition* {.importc: "MousePosition", header: headerhid, bycopy.} = object
    x* {.importc: "x".}: uint32
    y* {.importc: "y".}: uint32
    velocityX* {.importc: "velocityX".}: uint32
    velocityY* {.importc: "velocityY".}: uint32
    scrollVelocityX* {.importc: "scrollVelocityX".}: uint32
    scrollVelocityY* {.importc: "scrollVelocityY".}: uint32












const
  JOYSTICK_MAX* = (0x00008000)
  JOYSTICK_MIN* = (-0x00008000)

##  End enums and output structs
##  Begin HidTouchScreen

type
  HidTouchScreenHeader* {.importc: "HidTouchScreenHeader", header: headerhid, bycopy.} = object
    timestampTicks* {.importc: "timestampTicks".}: uint64
    numEntries* {.importc: "numEntries".}: uint64
    latestEntry* {.importc: "latestEntry".}: uint64
    maxEntryIndex* {.importc: "maxEntryIndex".}: uint64
    timestamp* {.importc: "timestamp".}: uint64


##  static_assert(sizeof(HidTouchScreenHeader) == 0x28, "Hid touch screen header structure has incorrect size");

type
  HidTouchScreenEntryHeader* {.importc: "HidTouchScreenEntryHeader",
                              header: headerhid, bycopy.} = object
    timestamp* {.importc: "timestamp".}: uint64
    numTouches* {.importc: "numTouches".}: uint64


##  static_assert(sizeof(HidTouchScreenEntryHeader) == 0x10, "Hid touch screen entry header structure has incorrect size");

type
  HidTouchScreenEntryTouch* {.importc: "HidTouchScreenEntryTouch",
                             header: headerhid, bycopy.} = object
    timestamp* {.importc: "timestamp".}: uint64
    padding* {.importc: "padding".}: uint32
    touchIndex* {.importc: "touchIndex".}: uint32
    x* {.importc: "x".}: uint32
    y* {.importc: "y".}: uint32
    diameterX* {.importc: "diameterX".}: uint32
    diameterY* {.importc: "diameterY".}: uint32
    angle* {.importc: "angle".}: uint32
    padding_2* {.importc: "padding_2".}: uint32


##  static_assert(sizeof(HidTouchScreenEntryTouch) == 0x28, "Hid touch screen touch structure has incorrect size");

type
  HidTouchScreenEntry* {.importc: "HidTouchScreenEntry", header: headerhid, bycopy.} = object
    header* {.importc: "header".}: HidTouchScreenEntryHeader
    touches* {.importc: "touches".}: array[16, HidTouchScreenEntryTouch]
    unk* {.importc: "unk".}: uint64


##  static_assert(sizeof(HidTouchScreenEntry) == 0x298, "Hid touch screen entry structure has incorrect size");

type
  HidTouchScreen* {.importc: "HidTouchScreen", header: headerhid, bycopy.} = object
    header* {.importc: "header".}: HidTouchScreenHeader
    entries* {.importc: "entries".}: array[17, HidTouchScreenEntry]
    padding* {.importc: "padding".}: array[0x000003C0, uint8]


##  static_assert(sizeof(HidTouchScreen) == 0x3000, "Hid touch screen structure has incorrect size");
##  End HidTouchScreen
##  Begin HidMouse

type
  HidMouseHeader* {.importc: "HidMouseHeader", header: headerhid, bycopy.} = object
    timestampTicks* {.importc: "timestampTicks".}: uint64
    numEntries* {.importc: "numEntries".}: uint64
    latestEntry* {.importc: "latestEntry".}: uint64
    maxEntryIndex* {.importc: "maxEntryIndex".}: uint64


##  static_assert(sizeof(HidMouseHeader) == 0x20, "Hid mouse header structure has incorrect size");

type
  HidMouseEntry* {.importc: "HidMouseEntry", header: headerhid, bycopy.} = object
    timestamp* {.importc: "timestamp".}: uint64
    timestamp_2* {.importc: "timestamp_2".}: uint64
    position* {.importc: "position".}: MousePosition
    buttons* {.importc: "buttons".}: uint64


##  static_assert(sizeof(HidMouseEntry) == 0x30, "Hid mouse entry structure has incorrect size");

type
  HidMouse* {.importc: "HidMouse", header: headerhid, bycopy.} = object
    header* {.importc: "header".}: HidMouseHeader
    entries* {.importc: "entries".}: array[17, HidMouseEntry]
    padding* {.importc: "padding".}: array[0x000000B0, uint8]


##  static_assert(sizeof(HidMouse) == 0x400, "Hid mouse structure has incorrect size");
##  End HidMouse
##  Begin HidKeyboard

type
  HidKeyboardHeader* {.importc: "HidKeyboardHeader", header: headerhid, bycopy.} = object
    timestampTicks* {.importc: "timestampTicks".}: uint64
    numEntries* {.importc: "numEntries".}: uint64
    latestEntry* {.importc: "latestEntry".}: uint64
    maxEntryIndex* {.importc: "maxEntryIndex".}: uint64


##  static_assert(sizeof(HidKeyboardHeader) == 0x20, "Hid keyboard header structure has incorrect size");

type
  HidKeyboardEntry* {.importc: "HidKeyboardEntry", header: headerhid, bycopy.} = object
    timestamp* {.importc: "timestamp".}: uint64
    timestamp_2* {.importc: "timestamp_2".}: uint64
    modifier* {.importc: "modifier".}: uint64
    keys* {.importc: "keys".}: array[8, uint32]


##  static_assert(sizeof(HidKeyboardEntry) == 0x38, "Hid keyboard entry structure has incorrect size");

type
  HidKeyboard* {.importc: "HidKeyboard", header: headerhid, bycopy.} = object
    header* {.importc: "header".}: HidKeyboardHeader
    entries* {.importc: "entries".}: array[17, HidKeyboardEntry]
    padding* {.importc: "padding".}: array[0x00000028, uint8]


##  static_assert(sizeof(HidKeyboard) == 0x400, "Hid keyboard structure has incorrect size");
##  End HidKeyboard
##  Begin HidController

type
  HidControllerMAC* {.importc: "HidControllerMAC", header: headerhid, bycopy.} = object
    timestamp* {.importc: "timestamp".}: uint64
    mac* {.importc: "mac".}: array[0x00000008, uint8]
    unk* {.importc: "unk".}: uint64
    timestamp_2* {.importc: "timestamp_2".}: uint64


##  static_assert(sizeof(HidControllerMAC) == 0x20, "Hid controller MAC structure has incorrect size");

type
  HidControllerHeader* {.importc: "HidControllerHeader", header: headerhid, bycopy.} = object
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


##  static_assert(sizeof(HidControllerHeader) == 0x28, "Hid controller header structure has incorrect size");

type
  HidControllerLayoutHeader* {.importc: "HidControllerLayoutHeader",
                              header: headerhid, bycopy.} = object
    timestampTicks* {.importc: "timestampTicks".}: uint64
    numEntries* {.importc: "numEntries".}: uint64
    latestEntry* {.importc: "latestEntry".}: uint64
    maxEntryIndex* {.importc: "maxEntryIndex".}: uint64


##  static_assert(sizeof(HidControllerLayoutHeader) == 0x20, "Hid controller layout header structure has incorrect size");

type
  HidControllerInputEntry* {.importc: "HidControllerInputEntry", header: headerhid,
                            bycopy.} = object
    timestamp* {.importc: "timestamp".}: uint64
    timestamp_2* {.importc: "timestamp_2".}: uint64
    buttons* {.importc: "buttons".}: uint64
    joysticks* {.importc: "joysticks".}: array[JOYSTICK_NUM_STICKS, JoystickPosition]
    connectionState* {.importc: "connectionState".}: uint64


##  static_assert(sizeof(HidControllerInputEntry) == 0x30, "Hid controller input entry structure has incorrect size");

type
  HidControllerLayout* {.importc: "HidControllerLayout", header: headerhid, bycopy.} = object
    header* {.importc: "header".}: HidControllerLayoutHeader
    entries* {.importc: "entries".}: array[17, HidControllerInputEntry]


##  static_assert(sizeof(HidControllerLayout) == 0x350, "Hid controller layout structure has incorrect size");

type
  HidController* {.importc: "HidController", header: headerhid, bycopy.} = object
    header* {.importc: "header".}: HidControllerHeader
    layouts* {.importc: "layouts".}: array[7, HidControllerLayout]
    unk_1* {.importc: "unk_1".}: array[0x00002A70, uint8]
    macLeft* {.importc: "macLeft".}: HidControllerMAC
    macRight* {.importc: "macRight".}: HidControllerMAC
    unk_2* {.importc: "unk_2".}: array[0x00000DF8, uint8]


##  static_assert(sizeof(HidController) == 0x5000, "Hid controller structure has incorrect size");
##  End HidController

type
  HidSharedMemory* {.importc: "HidSharedMemory", header: headerhid, bycopy.} = object
    header* {.importc: "header".}: array[0x00000400, uint8]
    touchscreen* {.importc: "touchscreen".}: HidTouchScreen
    mouse* {.importc: "mouse".}: HidMouse
    keyboard* {.importc: "keyboard".}: HidKeyboard
    unkSection1* {.importc: "unkSection1".}: array[0x00000400, uint8]
    unkSection2* {.importc: "unkSection2".}: array[0x00000400, uint8]
    unkSection3* {.importc: "unkSection3".}: array[0x00000400, uint8]
    unkSection4* {.importc: "unkSection4".}: array[0x00000400, uint8]
    unkSection5* {.importc: "unkSection5".}: array[0x00000200, uint8]
    unkSection6* {.importc: "unkSection6".}: array[0x00000200, uint8]
    unkSection7* {.importc: "unkSection7".}: array[0x00000200, uint8]
    unkSection8* {.importc: "unkSection8".}: array[0x00000800, uint8]
    controllerSerials* {.importc: "controllerSerials".}: array[0x00004000, uint8]
    controllers* {.importc: "controllers".}: array[10, HidController]
    unkSection9* {.importc: "unkSection9".}: array[0x00004600, uint8]


##  static_assert(sizeof(HidSharedMemory) == 0x40000, "Hid Shared Memory structure has incorrect size");

type
  HidVibrationDeviceInfo* {.importc: "HidVibrationDeviceInfo", header: headerhid,
                           bycopy.} = object
    unk_x0* {.importc: "unk_x0".}: uint32
    unk_x4* {.importc: "unk_x4".}: uint32 ## /< 0x1 for left-joycon, 0x2 for right-joycon.
  

##  static_assert(sizeof(HidVibrationDeviceInfo) == 0x8, "Hid VibrationDeviceInfo structure has incorrect size");

type
  HidVibrationValue* {.importc: "HidVibrationValue", header: headerhid, bycopy.} = object
    amp_low* {.importc: "amp_low".}: cfloat ## /< Low Band amplitude. 1.0f: Max amplitude.
    freq_low* {.importc: "freq_low".}: cfloat ## /< Low Band frequency in Hz.
    amp_high* {.importc: "amp_high".}: cfloat ## /< High Band amplitude. 1.0f: Max amplitude.
    freq_high* {.importc: "freq_high".}: cfloat ## /< High Band frequency in Hz.
  

##  static_assert(sizeof(HidVibrationValue) == 0x10, "Hid VibrationValue structure has incorrect size");

proc hidInitialize*(): Result {.cdecl, importc: "hidInitialize", header: headerhid.}
proc hidExit*() {.cdecl, importc: "hidExit", header: headerhid.}
proc hidReset*() {.cdecl, importc: "hidReset", header: headerhid.}
proc hidGetSessionService*(): ptr Service {.cdecl, importc: "hidGetSessionService",
                                        header: headerhid.}
proc hidGetSharedmemAddr*(): pointer {.cdecl, importc: "hidGetSharedmemAddr",
                                    header: headerhid.}
proc hidSetControllerLayout*(id: HidControllerID;
                            layoutType: HidControllerLayoutType) {.cdecl,
    importc: "hidSetControllerLayout", header: headerhid.}
proc hidGetControllerLayout*(id: HidControllerID): HidControllerLayoutType {.
    cdecl, importc: "hidGetControllerLayout", header: headerhid.}
proc hidScanInput*() {.cdecl, importc: "hidScanInput", header: headerhid.}
proc hidKeysHeld*(id: HidControllerID): uint64 {.cdecl, importc: "hidKeysHeld",
    header: headerhid.}
proc hidKeysDown*(id: HidControllerID): uint64 {.cdecl, importc: "hidKeysDown",
    header: headerhid.}
proc hidKeysUp*(id: HidControllerID): uint64 {.cdecl, importc: "hidKeysUp",
                                        header: headerhid.}
proc hidMouseButtonsHeld*(): uint64 {.cdecl, importc: "hidMouseButtonsHeld",
                                header: headerhid.}
proc hidMouseButtonsDown*(): uint64 {.cdecl, importc: "hidMouseButtonsDown",
                                header: headerhid.}
proc hidMouseButtonsUp*(): uint64 {.cdecl, importc: "hidMouseButtonsUp",
                              header: headerhid.}
proc hidMouseRead*(pos: ptr MousePosition) {.cdecl, importc: "hidMouseRead",
    header: headerhid.}
proc hidKeyboardModifierHeld*(modifier: HidKeyboardModifier): bool {.cdecl,
    importc: "hidKeyboardModifierHeld", header: headerhid.}
proc hidKeyboardModifierDown*(modifier: HidKeyboardModifier): bool {.cdecl,
    importc: "hidKeyboardModifierDown", header: headerhid.}
proc hidKeyboardModifierUp*(modifier: HidKeyboardModifier): bool {.cdecl,
    importc: "hidKeyboardModifierUp", header: headerhid.}
proc hidKeyboardHeld*(key: HidKeyboardScancode): bool {.cdecl,
    importc: "hidKeyboardHeld", header: headerhid.}
proc hidKeyboardDown*(key: HidKeyboardScancode): bool {.cdecl,
    importc: "hidKeyboardDown", header: headerhid.}
proc hidKeyboardUp*(key: HidKeyboardScancode): bool {.cdecl,
    importc: "hidKeyboardUp", header: headerhid.}
proc hidTouchCount*(): uint32 {.cdecl, importc: "hidTouchCount", header: headerhid.}
proc hidTouchRead*(pos: ptr touchPosition; point_id: uint32) {.cdecl,
    importc: "hidTouchRead", header: headerhid.}
proc hidJoystickRead*(pos: ptr JoystickPosition; id: HidControllerID;
                     stick: HidControllerJoystick) {.cdecl,
    importc: "hidJoystickRead", header: headerhid.}
## / This can be used to check what CONTROLLER_P1_AUTO uses.
## / Returns 0 when CONTROLLER_PLAYER_1 is connected, otherwise returns 1 for handheld-mode.

proc hidGetHandheldMode*(): bool {.cdecl, importc: "hidGetHandheldMode",
                                header: headerhid.}
## / Use this if you want to use a single joy-con as a dedicated CONTROLLER_PLAYER_*.
## / When used, both joy-cons in a pair should be used with this (CONTROLLER_PLAYER_1 and CONTROLLER_PLAYER_2 for example).
## / id must be CONTROLLER_PLAYER_*.

proc hidSetNpadJoyAssignmentModeSingleByDefault*(id: HidControllerID): Result {.
    cdecl, importc: "hidSetNpadJoyAssignmentModeSingleByDefault",
    header: headerhid.}
## / Use this if you want to use a pair of joy-cons as a single CONTROLLER_PLAYER_*. Only necessary if you want to use this mode in your application after \ref hidSetNpadJoyAssignmentModeSingleByDefault was used with this pair of joy-cons.
## / Used automatically during app startup/exit for all controllers.
## / When used, both joy-cons in a pair should be used with this (CONTROLLER_PLAYER_1 and CONTROLLER_PLAYER_2 for example).
## / id must be CONTROLLER_PLAYER_*.

proc hidSetNpadJoyAssignmentModeDual*(id: HidControllerID): Result {.cdecl,
    importc: "hidSetNpadJoyAssignmentModeDual", header: headerhid.}
## / Merge two single joy-cons into a dual-mode controller. Use this after \ref hidSetNpadJoyAssignmentModeDual, when \ref hidSetNpadJoyAssignmentModeSingleByDefault was previously used (this includes using this manually at application exit).

proc hidMergeSingleJoyAsDualJoy*(id0: HidControllerID; id1: HidControllerID): Result {.
    cdecl, importc: "hidMergeSingleJoyAsDualJoy", header: headerhid.}
proc hidInitializeVibrationDevices*(VibrationDeviceHandles: ptr uint32;
                                   total_handles: csize; id: HidControllerID;
                                   `type`: HidControllerType): Result {.cdecl,
    importc: "hidInitializeVibrationDevices", header: headerhid.}
## / Gets HidVibrationDeviceInfo for the specified VibrationDeviceHandle.

proc hidGetVibrationDeviceInfo*(VibrationDeviceHandle: ptr uint32;
                               VibrationDeviceInfo: ptr HidVibrationDeviceInfo): Result {.
    cdecl, importc: "hidGetVibrationDeviceInfo", header: headerhid.}
## / Send the VibrationValue to the specified VibrationDeviceHandle.

proc hidSendVibrationValue*(VibrationDeviceHandle: ptr uint32;
                           VibrationValue: ptr HidVibrationValue): Result {.cdecl,
    importc: "hidSendVibrationValue", header: headerhid.}
## / Gets the current HidVibrationValue for the specified VibrationDeviceHandle.

proc hidGetActualVibrationValue*(VibrationDeviceHandle: ptr uint32;
                                VibrationValue: ptr HidVibrationValue): Result {.
    cdecl, importc: "hidGetActualVibrationValue", header: headerhid.}
## / Sets whether vibration is allowed, this also affects the config displayed by System Settings.

proc hidPermitVibration*(flag: bool): Result {.cdecl,
    importc: "hidPermitVibration", header: headerhid.}
## / Gets whether vibration is allowed.

proc hidIsVibrationPermitted*(flag: ptr bool): Result {.cdecl,
    importc: "hidIsVibrationPermitted", header: headerhid.}
## / Send VibrationValues[index] to VibrationDeviceHandles[index], where count is the number of entries in the VibrationDeviceHandles/VibrationValues arrays.

proc hidSendVibrationValues*(VibrationDeviceHandles: ptr uint32;
                            VibrationValues: ptr HidVibrationValue; count: csize): Result {.
    cdecl, importc: "hidSendVibrationValues", header: headerhid.}