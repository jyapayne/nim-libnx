import strutils
import ospaths
const headerusb_comms = currentSourcePath().splitPath().head & "/nx/include/switch/runtime/devices/usb_comms.h"
import libnx/types
proc usbCommsInitialize*(): Result {.cdecl, importc: "usbCommsInitialize",
                                  header: headerusb_comms.}
proc usbCommsExit*() {.cdecl, importc: "usbCommsExit", header: headerusb_comms.}
proc usbCommsInitializeEx*(`interface`: ptr uint32; bInterfaceClass: uint8;
                          bInterfaceSubClass: uint8; bInterfaceProtocol: uint8): Result {.
    cdecl, importc: "usbCommsInitializeEx", header: headerusb_comms.}
proc usbCommsExitEx*(`interface`: uint32) {.cdecl, importc: "usbCommsExitEx",
                                      header: headerusb_comms.}
proc usbCommsRead*(buffer: pointer; size: csize): csize {.cdecl,
    importc: "usbCommsRead", header: headerusb_comms.}
proc usbCommsWrite*(buffer: pointer; size: csize): csize {.cdecl,
    importc: "usbCommsWrite", header: headerusb_comms.}
proc usbCommsReadEx*(buffer: pointer; size: csize; `interface`: uint32): csize {.cdecl,
    importc: "usbCommsReadEx", header: headerusb_comms.}
proc usbCommsWriteEx*(buffer: pointer; size: csize; `interface`: uint32): csize {.cdecl,
    importc: "usbCommsWriteEx", header: headerusb_comms.}