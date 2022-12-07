## *
##  @file usb_comms.h
##  @brief USB comms.
##  @author yellows8
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../../types

type
  UsbCommsInterfaceInfo* {.bycopy.} = object
    bInterfaceClass*: U8
    bInterfaceSubClass*: U8
    bInterfaceProtocol*: U8


## / Initializes usbComms with the default number of interfaces (1)

proc usbCommsInitialize*(): Result {.cdecl, importc: "usbCommsInitialize".}
## / Initializes usbComms with a specific number of interfaces.

proc usbCommsInitializeEx*(numInterfaces: U32; infos: ptr UsbCommsInterfaceInfo): Result {.
    cdecl, importc: "usbCommsInitializeEx".}
## / Exits usbComms.

proc usbCommsExit*() {.cdecl, importc: "usbCommsExit".}
## / Sets whether to throw a fatal error in usbComms{Read/Write}* on failure, or just return the transferred size. By default (false) the latter is used.

proc usbCommsSetErrorHandling*(flag: bool) {.cdecl,
    importc: "usbCommsSetErrorHandling".}
## / Read data with the default interface.

proc usbCommsRead*(buffer: pointer; size: csize_t): csize_t {.cdecl,
    importc: "usbCommsRead".}
## / Write data with the default interface.

proc usbCommsWrite*(buffer: pointer; size: csize_t): csize_t {.cdecl,
    importc: "usbCommsWrite".}
## / Same as usbCommsRead except with the specified interface.

proc usbCommsReadEx*(buffer: pointer; size: csize_t; `interface`: U32): csize_t {.cdecl,
    importc: "usbCommsReadEx".}
## / Same as usbCommsWrite except with the specified interface.

proc usbCommsWriteEx*(buffer: pointer; size: csize_t; `interface`: U32): csize_t {.
    cdecl, importc: "usbCommsWriteEx".}
