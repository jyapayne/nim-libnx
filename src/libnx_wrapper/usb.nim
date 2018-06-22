import strutils
import ospaths
const headerusb = currentSourcePath().splitPath().head & "/nx/include/switch/services/usb.h"
import libnx_wrapper/types
import libnx_wrapper/sm
const
  USBDS_DEFAULT_InterfaceNumber* = 0x00000004
  USB_DT_INTERFACE_SIZE* = 9
  USB_DT_ENDPOINT_SIZE* = 7

type
  usb_endpoint_descriptor* {.importc: "usb_endpoint_descriptor", header: headerusb,
                            bycopy.} = object
    bLength* {.importc: "bLength".}: uint8_t
    bDescriptorType* {.importc: "bDescriptorType".}: uint8_t
    bEndpointAddress* {.importc: "bEndpointAddress".}: uint8_t
    bmAttributes* {.importc: "bmAttributes".}: uint8_t
    wMaxPacketSize* {.importc: "wMaxPacketSize".}: uint16_t
    bInterval* {.importc: "bInterval".}: uint8_t

  usb_interface_descriptor* {.importc: "usb_interface_descriptor",
                             header: headerusb, bycopy.} = object
    bLength* {.importc: "bLength".}: uint8_t
    bDescriptorType* {.importc: "bDescriptorType".}: uint8_t
    bInterfaceNumber* {.importc: "bInterfaceNumber".}: uint8_t
    bAlternateSetting* {.importc: "bAlternateSetting".}: uint8_t
    bNumEndpoints* {.importc: "bNumEndpoints".}: uint8_t
    bInterfaceClass* {.importc: "bInterfaceClass".}: uint8_t
    bInterfaceSubClass* {.importc: "bInterfaceSubClass".}: uint8_t
    bInterfaceProtocol* {.importc: "bInterfaceProtocol".}: uint8_t
    iInterface* {.importc: "iInterface".}: uint8_t

  UsbDsDeviceInfo* {.importc: "UsbDsDeviceInfo", header: headerusb, bycopy.} = object
    idVendor* {.importc: "idVendor".}: uint16
    idProduct* {.importc: "idProduct".}: uint16
    bcdDevice* {.importc: "bcdDevice".}: uint16
    Manufacturer* {.importc: "Manufacturer".}: array[0x00000020, char]
    Product* {.importc: "Product".}: array[0x00000020, char]
    SerialNumber* {.importc: "SerialNumber".}: array[0x00000020, char]

  UsbDsReportEntry* {.importc: "UsbDsReportEntry", header: headerusb, bycopy.} = object
    id* {.importc: "id".}: uint32
    requestedSize* {.importc: "requestedSize".}: uint32
    transferredSize* {.importc: "transferredSize".}: uint32
    urb_status* {.importc: "urb_status".}: uint32

  UsbDsReportData* {.importc: "UsbDsReportData", header: headerusb, bycopy.} = object
    report* {.importc: "report".}: array[8, UsbDsReportEntry]
    report_count* {.importc: "report_count".}: uint32

  UsbDsInterface* {.importc: "UsbDsInterface", header: headerusb, bycopy.} = object
    initialized* {.importc: "initialized".}: bool
    interface_index* {.importc: "interface_index".}: uint32
    h* {.importc: "h".}: Service
    SetupEvent* {.importc: "SetupEvent".}: Handle
    CtrlInCompletionEvent* {.importc: "CtrlInCompletionEvent".}: Handle
    CtrlOutCompletionEvent* {.importc: "CtrlOutCompletionEvent".}: Handle

  UsbDsEndpoint* {.importc: "UsbDsEndpoint", header: headerusb, bycopy.} = object
    initialized* {.importc: "initialized".}: bool
    h* {.importc: "h".}: Service
    CompletionEvent* {.importc: "CompletionEvent".}: Handle

  UsbComplexId* {.size: sizeof(cint).} = enum
    UsbComplexId_Default = 0x00000002


type
  usb_class_code* {.size: sizeof(cint).} = enum
    USB_CLASS_PER_INTERFACE = 0, USB_CLASS_AUDIO = 1, USB_CLASS_COMM = 2,
    USB_CLASS_HID = 3, USB_CLASS_PHYSICAL = 5, USB_CLASS_PTP = 6, USB_CLASS_PRINTER = 7,
    USB_CLASS_MASS_STORAGE = 8, USB_CLASS_HUB = 9, USB_CLASS_DATA = 10,
    USB_CLASS_SMART_CARD = 0x0000000B, USB_CLASS_CONTENT_SECURITY = 0x0000000D,
    USB_CLASS_VIDEO = 0x0000000E, USB_CLASS_PERSONAL_HEALTHCARE = 0x0000000F,
    USB_CLASS_DIAGNOSTIC_DEVICE = 0x000000DC, USB_CLASS_WIRELESS = 0x000000E0,
    USB_CLASS_APPLICATION = 0x000000FE, USB_CLASS_VENDOR_SPEC = 0x000000FF

const
  USB_CLASS_IMAGE = USB_CLASS_PTP

type
  usb_descriptor_type* {.size: sizeof(cint).} = enum
    USB_DT_DEVICE = 0x00000001, USB_DT_CONFIG = 0x00000002,
    USB_DT_STRING = 0x00000003, USB_DT_INTERFACE = 0x00000004,
    USB_DT_ENDPOINT = 0x00000005, USB_DT_BOS = 0x0000000F,
    USB_DT_DEVICE_CAPABILITY = 0x00000010, USB_DT_HID = 0x00000021,
    USB_DT_REPORT = 0x00000022, USB_DT_PHYSICAL = 0x00000023, USB_DT_HUB = 0x00000029,
    USB_DT_SUPERSPEED_HUB = 0x0000002A, USB_DT_SS_ENDPOINT_COMPANION = 0x00000030


type
  usb_endpoint_direction* {.size: sizeof(cint).} = enum
    USB_ENDPOINT_OUT = 0x00000000, USB_ENDPOINT_IN = 0x00000080


type
  usb_transfer_type* {.size: sizeof(cint).} = enum
    USB_TRANSFER_TYPE_CONTROL = 0, USB_TRANSFER_TYPE_ISOCHRONOUS = 1,
    USB_TRANSFER_TYPE_BULK = 2, USB_TRANSFER_TYPE_INTERRUPT = 3,
    USB_TRANSFER_TYPE_BULK_STREAM = 4


type
  usb_iso_sync_type* {.size: sizeof(cint).} = enum
    USB_ISO_SYNC_TYPE_NONE = 0, USB_ISO_SYNC_TYPE_ASYNC = 1,
    USB_ISO_SYNC_TYPE_ADAPTIVE = 2, USB_ISO_SYNC_TYPE_SYNC = 3


type
  usb_iso_usage_type* {.size: sizeof(cint).} = enum
    USB_ISO_USAGE_TYPE_DATA = 0, USB_ISO_USAGE_TYPE_FEEDBACK = 1,
    USB_ISO_USAGE_TYPE_IMPLICIT = 2


proc usbDsInitialize*(complexId: UsbComplexId; deviceinfo: ptr UsbDsDeviceInfo): Result {.
    cdecl, importc: "usbDsInitialize", header: headerusb.}
proc usbDsExit*() {.cdecl, importc: "usbDsExit", header: headerusb.}
proc usbDsGetServiceSession*(): ptr Service {.cdecl,
    importc: "usbDsGetServiceSession", header: headerusb.}
proc usbDsGetStateChangeEvent*(): Handle {.cdecl,
                                        importc: "usbDsGetStateChangeEvent",
                                        header: headerusb.}
proc usbDsGetState*(`out`: ptr uint32): Result {.cdecl, importc: "usbDsGetState",
    header: headerusb.}
proc usbDsGetDsInterface*(`interface`: ptr ptr UsbDsInterface;
                         descriptor: ptr usb_interface_descriptor;
                         interface_name: cstring): Result {.cdecl,
    importc: "usbDsGetDsInterface", header: headerusb.}
proc usbDsWaitReady*(): Result {.cdecl, importc: "usbDsWaitReady", header: headerusb.}
proc usbDsParseReportData*(reportdata: ptr UsbDsReportData; urbId: uint32;
                          requestedSize: ptr uint32; transferredSize: ptr uint32): Result {.
    cdecl, importc: "usbDsParseReportData", header: headerusb.}
proc usbDsInterface_Close*(`interface`: ptr UsbDsInterface) {.cdecl,
    importc: "usbDsInterface_Close", header: headerusb.}
proc usbDsInterface_GetDsEndpoint*(`interface`: ptr UsbDsInterface;
                                  endpoint: ptr ptr UsbDsEndpoint;
                                  descriptor: ptr usb_endpoint_descriptor): Result {.
    cdecl, importc: "usbDsInterface_GetDsEndpoint", header: headerusb.}
proc usbDsInterface_EnableInterface*(`interface`: ptr UsbDsInterface): Result {.
    cdecl, importc: "usbDsInterface_EnableInterface", header: headerusb.}
proc usbDsInterface_DisableInterface*(`interface`: ptr UsbDsInterface): Result {.
    cdecl, importc: "usbDsInterface_DisableInterface", header: headerusb.}
proc usbDsInterface_CtrlInPostBufferAsync*(`interface`: ptr UsbDsInterface;
    buffer: pointer; size: csize; urbId: ptr uint32): Result {.cdecl,
    importc: "usbDsInterface_CtrlInPostBufferAsync", header: headerusb.}
proc usbDsInterface_CtrlOutPostBufferAsync*(`interface`: ptr UsbDsInterface;
    buffer: pointer; size: csize; urbId: ptr uint32): Result {.cdecl,
    importc: "usbDsInterface_CtrlOutPostBufferAsync", header: headerusb.}
proc usbDsInterface_GetCtrlInReportData*(`interface`: ptr UsbDsInterface;
                                        `out`: ptr UsbDsReportData): Result {.
    cdecl, importc: "usbDsInterface_GetCtrlInReportData", header: headerusb.}
proc usbDsInterface_GetCtrlOutReportData*(`interface`: ptr UsbDsInterface;
    `out`: ptr UsbDsReportData): Result {.cdecl, importc: "usbDsInterface_GetCtrlOutReportData",
                                      header: headerusb.}
proc usbDsInterface_StallCtrl*(`interface`: ptr UsbDsInterface): Result {.cdecl,
    importc: "usbDsInterface_StallCtrl", header: headerusb.}
proc usbDsEndpoint_Close*(endpoint: ptr UsbDsEndpoint) {.cdecl,
    importc: "usbDsEndpoint_Close", header: headerusb.}
proc usbDsEndpoint_PostBufferAsync*(endpoint: ptr UsbDsEndpoint; buffer: pointer;
                                   size: csize; urbId: ptr uint32): Result {.cdecl,
    importc: "usbDsEndpoint_PostBufferAsync", header: headerusb.}
proc usbDsEndpoint_GetReportData*(endpoint: ptr UsbDsEndpoint;
                                 `out`: ptr UsbDsReportData): Result {.cdecl,
    importc: "usbDsEndpoint_GetReportData", header: headerusb.}
proc usbDsEndpoint_StallCtrl*(endpoint: ptr UsbDsEndpoint): Result {.cdecl,
    importc: "usbDsEndpoint_StallCtrl", header: headerusb.}