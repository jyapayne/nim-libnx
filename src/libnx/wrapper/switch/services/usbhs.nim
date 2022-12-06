## *
##  @file usbhs.h
##  @brief USB (usb:hs) devices service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/usb, ../kernel/event

type                          ## /< These use \ref usb_device_descriptor. Bit2..6 require [6.0.0+], these are ignored on eariler versions.
  UsbHsInterfaceFilterFlags* = enum
    UsbHsInterfaceFilterFlagsIdVendor = bit(0),
    UsbHsInterfaceFilterFlagsIdProduct = bit(1),
    UsbHsInterfaceFilterFlagsBcdDeviceMin = bit(2),
    UsbHsInterfaceFilterFlagsBcdDeviceMax = bit(3),
    UsbHsInterfaceFilterFlagsBDeviceClass = bit(4),
    UsbHsInterfaceFilterFlagsBDeviceSubClass = bit(5), UsbHsInterfaceFilterFlagsBDeviceProtocol = bit(
        6),                   ## /< These use \ref usb_interface_descriptor.
    UsbHsInterfaceFilterFlagsBInterfaceClass = bit(7),
    UsbHsInterfaceFilterFlagsBInterfaceSubClass = bit(8),
    UsbHsInterfaceFilterFlagsBInterfaceProtocol = bit(9)


## / Interface filtering struct. When the associated flag bit is set, the associated descriptor field and struct field are compared, on mismatch the interface is filtered out.
## / [7.0.0+]: The filter struct has to be unique, it can't be used by anything else (including other processes). Hence, Flags has to be non-zero. When initialized with usb:hs:a and VID and/or PID filtering is enabled, the VID/PID will be checked against a blacklist.

type
  UsbHsInterfaceFilter* {.bycopy.} = object
    flags*: U16                ## /< See \ref UsbHsInterfaceFilterFlags. Setting this to 0 is equivalent to disabling filtering.
    idVendor*: U16
    idProduct*: U16
    bcdDeviceMin*: U16         ## /< Descriptor value must be >= bcdDevice_Min.
    bcdDeviceMax*: U16         ## /< Descriptor value must be <= bcdDevice_Max.
    bDeviceClass*: U8
    bDeviceSubClass*: U8
    bDeviceProtocol*: U8
    bInterfaceClass*: U8
    bInterfaceSubClass*: U8
    bInterfaceProtocol*: U8


## / Descriptors which are not available are set to all-zero.
## / The INPUT/OUTPUT endpoint descriptors were swapped with [8.0.0+], libnx converts this struct to the newer layout when running on pre-8.0.0.

type
  UsbHsInterfaceInfo* {.bycopy.} = object
    id*: S32
    deviceID_2*: U32
    unkX8*: U32
    interfaceDesc*: UsbInterfaceDescriptor
    padX15*: array[0x7, U8]
    inputEndpointDescs*: array[15, UsbEndpointDescriptor]
    padX85*: array[0x7, U8]
    outputEndpointDescs*: array[15, UsbEndpointDescriptor]
    padXf5*: array[0x6, U8]
    inputSsEndpointCompanionDescs*: array[15, UsbSsEndpointCompanionDescriptor] ## /< ?
    padX155*: array[0x6, U8]
    outputSsEndpointCompanionDescs*: array[15, UsbSsEndpointCompanionDescriptor] ## /< ?
    padX1b5*: array[0x3, U8]


## / Interface struct. Note that devices have a seperate \ref UsbHsInterface for each interface.

type
  UsbHsInterface* {.bycopy.} = object
    inf*: UsbHsInterfaceInfo
    pathstr*: array[0x40, char]
    busID*: U32
    deviceID*: U32
    deviceDesc*: UsbDeviceDescriptor
    configDesc*: UsbConfigDescriptor
    padX21b*: array[0x5, U8]
    timestamp*: U64            ## /< Unknown u64 timestamp for when the device was inserted?

  UsbHsXferReport* {.bycopy.} = object
    xferId*: U32
    res*: Result
    requestedSize*: U32
    transferredSize*: U32
    unkX10*: U64


## / The interface service object. These Events have autoclear=false.

type
  UsbHsClientIfSession* {.bycopy.} = object
    s*: Service
    event0*: Event             ## /< Unknown.
    eventCtrlXfer*: Event      ## /< [2.0.0+] Signaled when CtrlXferAsync finishes.
    id*: S32
    inf*: UsbHsInterface       ## /< Initialized with the input interface from \ref usbHsAcquireUsbIf, then overwritten with the cmd output. Pre-3.0.0 this only overwrites the first 0x1B8-bytes (data before pathstr).

  UsbHsClientEpSession* {.bycopy.} = object
    s*: Service
    eventXfer*: Event          ## /< [2.0.0+] Signaled when PostBufferAsync finishes.
    desc*: UsbEndpointDescriptor


## / Initialize usb:hs.

proc usbHsInitialize*(): Result {.cdecl, importc: "usbHsInitialize".}
## / Exit usb:hs.

proc usbHsExit*() {.cdecl, importc: "usbHsExit".}
## / Gets the Service object for the actual usb:hs service session.

proc usbHsGetServiceSession*(): ptr Service {.cdecl,
    importc: "usbHsGetServiceSession".}
## / Returns the Event loaded during init with autoclear=false.
## / Signaled when a device was removed.
## / When signaled, the user should use \ref usbHsQueryAcquiredInterfaces and cleanup state for all interfaces which are not listed in the output interfaces (none of the IDs match \ref usbHsIfGetID output).

proc usbHsGetInterfaceStateChangeEvent*(): ptr Event {.cdecl,
    importc: "usbHsGetInterfaceStateChangeEvent".}
## *
##  @brief Returns an array of all \ref UsbHsInterface. Internally this loads the same interfaces as \ref usbHsQueryAvailableInterfaces, followed by \ref usbHsQueryAcquiredInterfaces. However, ID in \ref UsbHsInterface is set to -1, hence the output from this should not be used with \ref usbHsAcquireUsbIf.
##  @param[in] filter \ref UsbHsInterfaceFilter.
##  @param[out] interfaces Array of output interfaces.
##  @param[in] interfaces_maxsize Max byte-size of the interfaces buffer.
##  @param[out] total_entries Total number of output interfaces.
##

proc usbHsQueryAllInterfaces*(filter: ptr UsbHsInterfaceFilter;
                             interfaces: ptr UsbHsInterface;
                             interfacesMaxsize: csize_t; totalEntries: ptr S32): Result {.
    cdecl, importc: "usbHsQueryAllInterfaces".}
## *
##  @brief Returns an array of \ref UsbHsInterface which are available.
##  @param[in] filter \ref UsbHsInterfaceFilter.
##  @param[out] interfaces Array of output interfaces.
##  @param[in] interfaces_maxsize Max byte-size of the interfaces buffer.
##  @param[out] total_entries Total number of output interfaces.
##

proc usbHsQueryAvailableInterfaces*(filter: ptr UsbHsInterfaceFilter;
                                   interfaces: ptr UsbHsInterface;
                                   interfacesMaxsize: csize_t;
                                   totalEntries: ptr S32): Result {.cdecl,
    importc: "usbHsQueryAvailableInterfaces".}
## *
##  @brief Returns an array of \ref UsbHsInterface which were previously acquired.
##  @param[out] interfaces Array of output interfaces.
##  @param[in] interfaces_maxsize Max byte-size of the interfaces buffer.
##  @param[out] total_entries Total number of output interfaces.
##

proc usbHsQueryAcquiredInterfaces*(interfaces: ptr UsbHsInterface;
                                  interfacesMaxsize: csize_t;
                                  totalEntries: ptr S32): Result {.cdecl,
    importc: "usbHsQueryAcquiredInterfaces".}
## *
##  @brief Creates an event which is signaled when an interface is available which passes the filtering checks.
##  @param[out] out_event Event object.
##  @param[in] autoclear Event autoclear.
##  @param[in] index Event index, must be 0..2.
##  @param[in] filter \ref UsbHsInterfaceFilter.
##

proc usbHsCreateInterfaceAvailableEvent*(outEvent: ptr Event; autoclear: bool;
                                        index: U8;
                                        filter: ptr UsbHsInterfaceFilter): Result {.
    cdecl, importc: "usbHsCreateInterfaceAvailableEvent".}
## *
##  @brief Destroys an event setup by \ref usbHsCreateInterfaceAvailableEvent. This *must* be used at some point during cleanup.
##  @param[in] event Event object to close.
##  @param[in] index Event index, must be 0..2.
##

proc usbHsDestroyInterfaceAvailableEvent*(event: ptr Event; index: U8): Result {.cdecl,
    importc: "usbHsDestroyInterfaceAvailableEvent".}
## *
##  @brief Acquires/opens the specified interface. This returns an error if the interface was already acquired by another process.
##  @param[in] s The service object.
##  @param[in] interface Interface to use.
##

proc usbHsAcquireUsbIf*(s: ptr UsbHsClientIfSession; `interface`: ptr UsbHsInterface): Result {.
    cdecl, importc: "usbHsAcquireUsbIf".}
## / UsbHsClientIfSession
## / Closes the specified interface session.

proc usbHsIfClose*(s: ptr UsbHsClientIfSession) {.cdecl, importc: "usbHsIfClose".}
## / Returns whether the specified interface session was initialized.

proc usbHsIfIsActive*(s: ptr UsbHsClientIfSession): bool {.inline, cdecl,
    importc: "usbHsIfIsActive".} =
  return serviceIsActive(addr(s.s))

## / Returns the ID which can be used for comparing with the ID in the output interfaces from \ref usbHsQueryAcquiredInterfaces.

proc usbHsIfGetID*(s: ptr UsbHsClientIfSession): S32 {.inline, cdecl,
    importc: "usbHsIfGetID".} =
  return s.id

## *
##  @brief Selects an interface.
##  @param[in] s The service object.
##  @param[out] inf The output interface info. If NULL, the output is stored within s instead.
##  @param[in] id ID
##

proc usbHsIfSetInterface*(s: ptr UsbHsClientIfSession; inf: ptr UsbHsInterfaceInfo;
                         id: U8): Result {.cdecl, importc: "usbHsIfSetInterface".}
## *
##  @brief Gets an interface.
##  @param[in] s The service object.
##  @param[out] inf The output interface info. If NULL, the output is stored within s instead.
##

proc usbHsIfGetInterface*(s: ptr UsbHsClientIfSession; inf: ptr UsbHsInterfaceInfo): Result {.
    cdecl, importc: "usbHsIfGetInterface".}
## *
##  @brief Gets an alternate interface.
##  @param[in] s The service object.
##  @param[out] inf The output interface info. If NULL, the output is stored within s instead.
##  @param[in] id ID
##

proc usbHsIfGetAlternateInterface*(s: ptr UsbHsClientIfSession;
                                  inf: ptr UsbHsInterfaceInfo; id: U8): Result {.
    cdecl, importc: "usbHsIfGetAlternateInterface".}
## / On [1.0.0] this is stubbed, just returns 0 with out=0.

proc usbHsIfGetCurrentFrame*(s: ptr UsbHsClientIfSession; `out`: ptr U32): Result {.
    cdecl, importc: "usbHsIfGetCurrentFrame".}
## / Uses a control transfer, this will block until the transfer finishes. The buffer address and size should be aligned to 0x1000-bytes, where wLength is the original size.

proc usbHsIfCtrlXfer*(s: ptr UsbHsClientIfSession; bmRequestType: U8; bRequest: U8;
                     wValue: U16; wIndex: U16; wLength: U16; buffer: pointer;
                     transferredSize: ptr U32): Result {.cdecl,
    importc: "usbHsIfCtrlXfer".}
## *
##  @brief Opens an endpoint. maxUrbCount*maxXferSize must be non-zero.
##  @param[in] s The interface object.
##  @param[out] ep The endpoint object.
##  @param[in] maxUrbCount maxUrbCount, must be <0x11.
##  @param[in] maxXferSize Max transfer size for a packet. This can be desc->wMaxPacketSize. Must be <=0xFF0000.
##  @param[in] desc Endpoint descriptor.
##

proc usbHsIfOpenUsbEp*(s: ptr UsbHsClientIfSession; ep: ptr UsbHsClientEpSession;
                      maxUrbCount: U16; maxXferSize: U32;
                      desc: ptr UsbEndpointDescriptor): Result {.cdecl,
    importc: "usbHsIfOpenUsbEp".}
## / Resets the device: has the same affect as unplugging the device and plugging it back in.

proc usbHsIfResetDevice*(s: ptr UsbHsClientIfSession): Result {.cdecl,
    importc: "usbHsIfResetDevice".}
## / UsbHsClientEpSession
## / Closes the specified endpoint session.

proc usbHsEpClose*(s: ptr UsbHsClientEpSession) {.cdecl, importc: "usbHsEpClose".}
## / Uses a data transfer with the specified endpoint, this will block until the transfer finishes. The buffer address and size should be aligned to 0x1000-bytes, where the input size is the original size.

proc usbHsEpPostBuffer*(s: ptr UsbHsClientEpSession; buffer: pointer; size: U32;
                       transferredSize: ptr U32): Result {.cdecl,
    importc: "usbHsEpPostBuffer".}