## *
##  @file usbds.h
##  @brief USB (usb:ds) service IPC wrapper.
##  @brief Switch-as-device<>host USB comms, see also here: https://switchbrew.org/wiki/USB_services
##  @author SciresM, yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/usb, ../kernel/event

const
  USBDS_DEFAULT_InterfaceNumber* = 0x4

type
  UsbDsInterface* {.bycopy.} = object
    initialized*: bool
    interfaceIndex*: U8
    s*: Service
    setupEvent*: Event
    ctrlInCompletionEvent*: Event
    ctrlOutCompletionEvent*: Event

  UsbDsEndpoint* {.bycopy.} = object
    initialized*: bool
    s*: Service
    completionEvent*: Event

  UsbDsDeviceInfo* {.bycopy.} = object
    idVendor*: U16             ## /< VID
    idProduct*: U16            ## /< PID
    bcdDevice*: U16
    manufacturer*: array[0x20, char]
    product*: array[0x20, char]
    serialNumber*: array[0x20, char]

  UsbDsReportEntry* {.bycopy.} = object
    id*: U32                   ## /< urbId from post-buffer cmds
    requestedSize*: U32
    transferredSize*: U32
    urbStatus*: U32

  UsbDsReportData* {.bycopy.} = object
    report*: array[8, UsbDsReportEntry]
    reportCount*: U32

  UsbComplexId* = enum
    UsbComplexIdDefault = 0x2
  UsbDeviceSpeed* = enum
    UsbDeviceSpeedFull = 0x2,   ## /< USB 1.1 Full Speed
    UsbDeviceSpeedHigh = 0x3,   ## /< USB 2.0 High Speed
    UsbDeviceSpeedSuper = 0x4   ## /< USB 3.0 Super Speed



## / Opens a session with usb:ds.

proc usbDsInitialize*(): Result {.cdecl, importc: "usbDsInitialize".}
## / Closes the usb:ds session. Any interfaces/endpoints which are left open are automatically closed, since otherwise usb-sysmodule won't fully reset usb:ds to defaults.

proc usbDsExit*() {.cdecl, importc: "usbDsExit".}
## / Gets the Service object for the actual usb:ds service session.

proc usbDsGetServiceSession*(): ptr Service {.cdecl,
    importc: "usbDsGetServiceSession".}
## / Helper func.

proc usbDsWaitReady*(timeout: U64): Result {.cdecl, importc: "usbDsWaitReady".}
## / Helper func.

proc usbDsParseReportData*(reportdata: ptr UsbDsReportData; urbId: U32;
                          requestedSize: ptr U32; transferredSize: ptr U32): Result {.
    cdecl, importc: "usbDsParseReportData".}
## /@name IDsService
## /@{

proc usbDsGetStateChangeEvent*(): ptr Event {.cdecl,
    importc: "usbDsGetStateChangeEvent".}
## / Gets the device state. See \ref UsbState.

proc usbDsGetState*(`out`: ptr UsbState): Result {.cdecl, importc: "usbDsGetState".}
## / Removed in [5.0.0+].

proc usbDsGetDsInterface*(`out`: ptr ptr UsbDsInterface;
                         descriptor: ptr UsbInterfaceDescriptor;
                         interfaceName: cstring): Result {.cdecl,
    importc: "usbDsGetDsInterface".}
## / Removed in [5.0.0+].

proc usbDsSetVidPidBcd*(deviceinfo: ptr UsbDsDeviceInfo): Result {.cdecl,
    importc: "usbDsSetVidPidBcd".}
## / Only available on [5.0.0+].

proc usbDsRegisterInterface*(`out`: ptr ptr UsbDsInterface): Result {.cdecl,
    importc: "usbDsRegisterInterface".}
## / Only available on [5.0.0+].

proc usbDsRegisterInterfaceEx*(`out`: ptr ptr UsbDsInterface; intfNum: U8): Result {.
    cdecl, importc: "usbDsRegisterInterfaceEx".}
## / Only available on [5.0.0+].

proc usbDsClearDeviceData*(): Result {.cdecl, importc: "usbDsClearDeviceData".}
## / Only available on [5.0.0+].

proc usbDsAddUsbStringDescriptor*(outIndex: ptr U8; string: cstring): Result {.cdecl,
    importc: "usbDsAddUsbStringDescriptor".}
## / Only available on [5.0.0+].

proc usbDsAddUsbLanguageStringDescriptor*(outIndex: ptr U8; langIds: ptr U16;
    numLangs: U16): Result {.cdecl, importc: "usbDsAddUsbLanguageStringDescriptor".}
## / Only available on [5.0.0+].

proc usbDsDeleteUsbStringDescriptor*(index: U8): Result {.cdecl,
    importc: "usbDsDeleteUsbStringDescriptor".}
## / Only available on [5.0.0+].

proc usbDsSetUsbDeviceDescriptor*(speed: UsbDeviceSpeed;
                                 descriptor: ptr UsbDeviceDescriptor): Result {.
    cdecl, importc: "usbDsSetUsbDeviceDescriptor".}
## / Only available on [5.0.0+].

proc usbDsSetBinaryObjectStore*(bos: pointer; bosSize: csize_t): Result {.cdecl,
    importc: "usbDsSetBinaryObjectStore".}
## / Only available on [5.0.0+].

proc usbDsEnable*(): Result {.cdecl, importc: "usbDsEnable".}
## / Only available on [5.0.0+].

proc usbDsDisable*(): Result {.cdecl, importc: "usbDsDisable".}
## /@}
## /@name IDsInterface
## /@{

proc usbDsInterfaceClose*(`interface`: ptr UsbDsInterface) {.cdecl,
    importc: "usbDsInterface_Close".}
proc usbDsInterfaceGetSetupPacket*(`interface`: ptr UsbDsInterface; buffer: pointer;
                                  size: csize_t): Result {.cdecl,
    importc: "usbDsInterface_GetSetupPacket".}
proc usbDsInterfaceEnableInterface*(`interface`: ptr UsbDsInterface): Result {.cdecl,
    importc: "usbDsInterface_EnableInterface".}
proc usbDsInterfaceDisableInterface*(`interface`: ptr UsbDsInterface): Result {.
    cdecl, importc: "usbDsInterface_DisableInterface".}
proc usbDsInterfaceCtrlInPostBufferAsync*(`interface`: ptr UsbDsInterface;
    buffer: pointer; size: csize_t; urbId: ptr U32): Result {.cdecl,
    importc: "usbDsInterface_CtrlInPostBufferAsync".}
proc usbDsInterfaceCtrlOutPostBufferAsync*(`interface`: ptr UsbDsInterface;
    buffer: pointer; size: csize_t; urbId: ptr U32): Result {.cdecl,
    importc: "usbDsInterface_CtrlOutPostBufferAsync".}
proc usbDsInterfaceGetCtrlInReportData*(`interface`: ptr UsbDsInterface;
                                       `out`: ptr UsbDsReportData): Result {.cdecl,
    importc: "usbDsInterface_GetCtrlInReportData".}
proc usbDsInterfaceGetCtrlOutReportData*(`interface`: ptr UsbDsInterface;
                                        `out`: ptr UsbDsReportData): Result {.cdecl,
    importc: "usbDsInterface_GetCtrlOutReportData".}
proc usbDsInterfaceStallCtrl*(`interface`: ptr UsbDsInterface): Result {.cdecl,
    importc: "usbDsInterface_StallCtrl".}
## / Removed in [5.0.0+].

proc usbDsInterfaceGetDsEndpoint*(`interface`: ptr UsbDsInterface;
                                 endpoint: ptr ptr UsbDsEndpoint;
                                 descriptor: ptr UsbEndpointDescriptor): Result {.
    cdecl, importc: "usbDsInterface_GetDsEndpoint".}
## / Only available on [5.0.0+].

proc usbDsInterfaceRegisterEndpoint*(`interface`: ptr UsbDsInterface;
                                    endpoint: ptr ptr UsbDsEndpoint;
                                    endpointAddress: U8): Result {.cdecl,
    importc: "usbDsInterface_RegisterEndpoint".}
## / Only available on [5.0.0+].

proc usbDsInterfaceAppendConfigurationData*(`interface`: ptr UsbDsInterface;
    speed: UsbDeviceSpeed; buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "usbDsInterface_AppendConfigurationData".}
## /@}
## /@name IDsEndpoint
## /@{

proc usbDsEndpointClose*(endpoint: ptr UsbDsEndpoint) {.cdecl,
    importc: "usbDsEndpoint_Close".}
proc usbDsEndpointCancel*(endpoint: ptr UsbDsEndpoint): Result {.cdecl,
    importc: "usbDsEndpoint_Cancel".}
proc usbDsEndpointPostBufferAsync*(endpoint: ptr UsbDsEndpoint; buffer: pointer;
                                  size: csize_t; urbId: ptr U32): Result {.cdecl,
    importc: "usbDsEndpoint_PostBufferAsync".}
proc usbDsEndpointGetReportData*(endpoint: ptr UsbDsEndpoint;
                                `out`: ptr UsbDsReportData): Result {.cdecl,
    importc: "usbDsEndpoint_GetReportData".}
proc usbDsEndpointStall*(endpoint: ptr UsbDsEndpoint): Result {.cdecl,
    importc: "usbDsEndpoint_Stall".}
proc usbDsEndpointSetZlt*(endpoint: ptr UsbDsEndpoint; zlt: bool): Result {.cdecl,
    importc: "usbDsEndpoint_SetZlt".}
##  Sets Zero Length Termination for endpoint
## /@}
