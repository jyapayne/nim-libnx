## *
##  @file nfc.h
##  @brief Nintendo Figurine (amiibo) Platform (nfp:user) service IPC wrapper.
##  @author averne
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/mii, ../kernel/event

## / NfpServiceType

type
  NfpServiceType* = enum
    NfpServiceTypeUser = 0,     ## /< Initializes nfp:user.
    NfpServiceTypeDebug = 1,    ## /< Initializes nfp:dbg.
    NfpServiceTypeSystem = 2    ## /< Initializes nfp:sys.


## / NfcServiceType

type
  NfcServiceType* = enum
    NfcServiceTypeUser = 0,     ## /< Initializes nfc:user.
    NfcServiceTypeSystem = 1    ## /< Initializes nfc:sys.
  NfpState* = enum
    NfpStateNonInitialized = 0, NfpStateInitialized = 1
  NfpDeviceState* = enum
    NfpDeviceStateInitialized = 0, NfpDeviceStateSearchingForTag = 1,
    NfpDeviceStateTagFound = 2, NfpDeviceStateTagRemoved = 3,
    NfpDeviceStateTagMounted = 4, NfpDeviceStateUnavailable = 5,
    NfpDeviceStateFinalized = 6
  NfpDeviceType* = enum
    NfpDeviceTypeAmiibo = 0
  NfpMountTarget* = enum
    NfpMountTargetRom = 1, NfpMountTargetRam = 2, NfpMountTargetAll = 3
  NfpTagInfo* {.bycopy.} = object
    uuid*: array[10, U8]
    uuidLength*: U8
    reserved1*: array[0x15, U8]
    protocol*: U32
    tagType*: U32
    reserved2*: array[0x30, U8]

  NfpCommonInfo* {.bycopy.} = object
    lastWriteYear*: U16
    lastWriteMonth*: U8
    lastWriteDay*: U8
    writeCounter*: U16
    version*: U16
    applicationAreaSize*: U32
    reserved*: array[0x34, U8]

  NfpModelInfo* {.bycopy.} = object
    amiiboId*: array[0x8, U8]
    reserved*: array[0x38, U8]

  NfpRegisterInfo* {.bycopy.} = object
    mii*: MiiCharInfo
    firstWriteYear*: U16
    firstWriteMonth*: U8
    firstWriteDay*: U8
    amiiboName*: array[10 + 1, char] ## /< utf-8, null-terminated
    reserved*: array[0x99, U8]

  NfcRequiredMcuVersionData* {.bycopy.} = object
    version*: U64
    reserved*: array[3, U64]







## / Nfc/Nfp DeviceHandle

type
  NfcDeviceHandle* {.bycopy.} = object
    handle*: array[0x8, U8]     ## /< Handle.

proc nfpInitialize*(serviceType: NfpServiceType): Result {.cdecl,
    importc: "nfpInitialize".}
## / Initialize nfp:*.
proc nfpExit*() {.cdecl, importc: "nfpExit".}
## / Exit nfp:*.
proc nfcInitialize*(serviceType: NfcServiceType): Result {.cdecl,
    importc: "nfcInitialize".}
## / Initialize nfc:*.
proc nfcExit*() {.cdecl, importc: "nfcExit".}
## / Exit nfc:*.
proc nfpGetServiceSession*(): ptr Service {.cdecl, importc: "nfpGetServiceSession".}
## / Gets the Service object for the actual nfp:* service session.
proc nfpGetServiceSessionInterface*(): ptr Service {.cdecl,
    importc: "nfpGetServiceSession_Interface".}
## / Gets the Service object for the interface from nfp:*.
proc nfcGetServiceSession*(): ptr Service {.cdecl, importc: "nfcGetServiceSession".}
## / Gets the Service object for the actual nfc:* service session.
proc nfcGetServiceSessionInterface*(): ptr Service {.cdecl,
    importc: "nfcGetServiceSession_Interface".}
## / Gets the Service object for the interface from nfc:*.

proc nfpListDevices*(totalOut: ptr S32; `out`: ptr NfcDeviceHandle; count: S32): Result {.
    cdecl, importc: "nfpListDevices".}
proc nfpStartDetection*(handle: ptr NfcDeviceHandle): Result {.cdecl,
    importc: "nfpStartDetection".}
proc nfpStopDetection*(handle: ptr NfcDeviceHandle): Result {.cdecl,
    importc: "nfpStopDetection".}
proc nfpMount*(handle: ptr NfcDeviceHandle; deviceType: NfpDeviceType;
              mountTarget: NfpMountTarget): Result {.cdecl, importc: "nfpMount".}
proc nfpUnmount*(handle: ptr NfcDeviceHandle): Result {.cdecl, importc: "nfpUnmount".}

proc nfpOpenApplicationArea*(handle: ptr NfcDeviceHandle; appId: U32): Result {.cdecl,
    importc: "nfpOpenApplicationArea".}
## / Not available with ::NfpServiceType_System.

proc nfpGetApplicationArea*(handle: ptr NfcDeviceHandle; buf: pointer;
                           bufSize: csize_t): Result {.cdecl,
    importc: "nfpGetApplicationArea".}
## / Not available with ::NfpServiceType_System.

proc nfpSetApplicationArea*(handle: ptr NfcDeviceHandle; buf: pointer;
                           bufSize: csize_t): Result {.cdecl,
    importc: "nfpSetApplicationArea".}
## / Not available with ::NfpServiceType_System.
proc nfpFlush*(handle: ptr NfcDeviceHandle): Result {.cdecl, importc: "nfpFlush".}
proc nfpRestore*(handle: ptr NfcDeviceHandle): Result {.cdecl, importc: "nfpRestore".}

proc nfpCreateApplicationArea*(handle: ptr NfcDeviceHandle; appId: U32; buf: pointer;
                              bufSize: csize_t): Result {.cdecl,
    importc: "nfpCreateApplicationArea".}
## / Not available with ::NfpServiceType_System.
proc nfpGetTagInfo*(handle: ptr NfcDeviceHandle; `out`: ptr NfpTagInfo): Result {.cdecl,
    importc: "nfpGetTagInfo".}
proc nfpGetRegisterInfo*(handle: ptr NfcDeviceHandle; `out`: ptr NfpRegisterInfo): Result {.
    cdecl, importc: "nfpGetRegisterInfo".}
proc nfpGetCommonInfo*(handle: ptr NfcDeviceHandle; `out`: ptr NfpCommonInfo): Result {.
    cdecl, importc: "nfpGetCommonInfo".}
proc nfpGetModelInfo*(handle: ptr NfcDeviceHandle; `out`: ptr NfpModelInfo): Result {.
    cdecl, importc: "nfpGetModelInfo".}

proc nfpAttachActivateEvent*(handle: ptr NfcDeviceHandle; outEvent: ptr Event): Result {.
    cdecl, importc: "nfpAttachActivateEvent".}
## / Returned event will have autoclear off.

proc nfpAttachDeactivateEvent*(handle: ptr NfcDeviceHandle; outEvent: ptr Event): Result {.
    cdecl, importc: "nfpAttachDeactivateEvent".}
## / Returned event will have autoclear off.
proc nfpGetState*(`out`: ptr NfpState): Result {.cdecl, importc: "nfpGetState".}
proc nfpGetDeviceState*(handle: ptr NfcDeviceHandle; `out`: ptr NfpDeviceState): Result {.
    cdecl, importc: "nfpGetDeviceState".}
proc nfpGetNpadId*(handle: ptr NfcDeviceHandle; `out`: ptr U32): Result {.cdecl,
    importc: "nfpGetNpadId".}

proc nfpAttachAvailabilityChangeEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "nfpAttachAvailabilityChangeEvent".}
## / Returned event will have autoclear on.
## / Only available with [3.0.0+].

proc nfcIsNfcEnabled*(`out`: ptr bool): Result {.cdecl, importc: "nfcIsNfcEnabled".}
## / This uses nfc:*.
proc nfcSendCommandByPassThrough*(handle: ptr NfcDeviceHandle; timeout: U64;
                                 cmdBuf: pointer; cmdBufSize: csize_t;
                                 replyBuf: pointer; replyBufSize: csize_t;
                                 outSize: ptr U64): Result {.cdecl,
    importc: "nfcSendCommandByPassThrough".}
proc nfcKeepPassThroughSession*(handle: ptr NfcDeviceHandle): Result {.cdecl,
    importc: "nfcKeepPassThroughSession".}
proc nfcReleasePassThroughSession*(handle: ptr NfcDeviceHandle): Result {.cdecl,
    importc: "nfcReleasePassThroughSession".}
