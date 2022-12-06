## *
##  @file nv.h
##  @brief NVIDIA low level driver (nvdrv*) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../kernel/event


proc nvInitialize*(): Result {.cdecl, importc: "nvInitialize".}
## / Initialize nvdrv*.

proc nvExit*() {.cdecl, importc: "nvExit".}
## / Exit nvdrv*.

proc nvGetServiceSession*(): ptr Service {.cdecl, importc: "nvGetServiceSession".}
## / Gets the Service object for the actual nvdrv* service session.

type
  NvEventId* = enum
    NvEventIdGpuSmExceptionBptIntReport = 1,
    NvEventIdGpuSmExceptionBptPauseReport = 2, NvEventIdGpuErrorNotifier = 3

const
  NvEventIdCtrlGpuErrorEventHandle* = NvEventIdGpuSmExceptionBptIntReport
  NvEventIdCtrlGpuUnknown* = NvEventIdGpuSmExceptionBptPauseReport

template nv_Event_Id_Ctrl_Syncpt*(slot, syncpt: untyped): untyped =
  ((1'u shl 28) or ((syncpt) shl 16) or (slot))

proc nvOpen*(fd: ptr U32; devicepath: cstring): Result {.cdecl, importc: "nvOpen".}
proc nvIoctl*(fd: U32; request: U32; argp: pointer): Result {.cdecl, importc: "nvIoctl".}
proc nvIoctl2*(fd: U32; request: U32; argp: pointer; inbuf: pointer; inbufSize: csize_t): Result {.
    cdecl, importc: "nvIoctl2".}
## /< [3.0.0+]

proc nvIoctl3*(fd: U32; request: U32; argp: pointer; outbuf: pointer; outbufSize: csize_t): Result {.
    cdecl, importc: "nvIoctl3".}
## /< [3.0.0+]

proc nvClose*(fd: U32): Result {.cdecl, importc: "nvClose".}
proc nvQueryEvent*(fd: U32; eventId: U32; eventOut: ptr Event): Result {.cdecl,
    importc: "nvQueryEvent".}
proc nvConvertError*(rc: cint): Result {.cdecl, importc: "nvConvertError".}
