import strutils
import ospaths
const headervi = currentSourcePath().splitPath().head & "/nx/include/switch/services/vi.h"
import libnx/types
import libnx/sm
type
  ViDisplay* {.importc: "ViDisplay", header: headervi, bycopy.} = object
    display_id* {.importc: "display_id".}: uint64
    display_name* {.importc: "display_name".}: array[0x00000040, char]
    initialized* {.importc: "initialized".}: bool

  ViLayer* {.importc: "ViLayer", header: headervi, bycopy.} = object
    layer_id* {.importc: "layer_id".}: uint64
    stray_layer* {.importc: "stray_layer".}: bool
    initialized* {.importc: "initialized".}: bool

  ViServiceType* {.size: sizeof(cint).} = enum
    ViServiceType_Default = -1, ViServiceType_Application = 0,
    ViServiceType_System = 1, ViServiceType_Manager = 2
  ViLayerFlags* {.size: sizeof(cint).} = enum
    ViLayerFlags_Default = 0x00000001
  ViScalingMode* {.size: sizeof(cint).} = enum
    ViScalingMode_Default = 0x00000002




proc viInitialize*(servicetype: ViServiceType): Result {.cdecl,
    importc: "viInitialize", header: headervi.}
proc viExit*() {.cdecl, importc: "viExit", header: headervi.}
proc viGetSessionService*(): ptr Service {.cdecl, importc: "viGetSessionService",
                                       header: headervi.}
proc viGetSession_IApplicationDisplayService*(): ptr Service {.cdecl,
    importc: "viGetSession_IApplicationDisplayService", header: headervi.}
proc viGetSession_IHOSBinderDriverRelay*(): ptr Service {.cdecl,
    importc: "viGetSession_IHOSBinderDriverRelay", header: headervi.}
proc viGetSession_ISystemDisplayService*(): ptr Service {.cdecl,
    importc: "viGetSession_ISystemDisplayService", header: headervi.}
proc viGetSession_IManagerDisplayService*(): ptr Service {.cdecl,
    importc: "viGetSession_IManagerDisplayService", header: headervi.}
proc viGetSession_IHOSBinderDriverIndirect*(): ptr Service {.cdecl,
    importc: "viGetSession_IHOSBinderDriverIndirect", header: headervi.}
proc viOpenDisplay*(DisplayName: cstring; display: ptr ViDisplay): Result {.cdecl,
    importc: "viOpenDisplay", header: headervi.}
proc viCloseDisplay*(display: ptr ViDisplay): Result {.cdecl,
    importc: "viCloseDisplay", header: headervi.}
proc viCreateManagedLayer*(display: ptr ViDisplay; LayerFlags: uint32;
                          AppletResourceUserId: uint64; layer_id: ptr uint64): Result {.
    cdecl, importc: "viCreateManagedLayer", header: headervi.}
proc viOpenLayer*(NativeWindow: array[0x00000100, uint8]; NativeWindow_Size: ptr uint64;
                 display: ptr ViDisplay; layer: ptr ViLayer; LayerFlags: uint32;
                 LayerId: uint64): Result {.cdecl, importc: "viOpenLayer",
                                      header: headervi.}
proc viCloseLayer*(layer: ptr ViLayer): Result {.cdecl, importc: "viCloseLayer",
    header: headervi.}
proc viSetLayerScalingMode*(layer: ptr ViLayer; ScalingMode: uint32): Result {.cdecl,
    importc: "viSetLayerScalingMode", header: headervi.}
proc viGetDisplayResolution*(display: ptr ViDisplay; width: ptr uint64; height: ptr uint64): Result {.
    cdecl, importc: "viGetDisplayResolution", header: headervi.}
proc viGetDisplayVsyncEvent*(display: ptr ViDisplay; handle_out: ptr Handle): Result {.
    cdecl, importc: "viGetDisplayVsyncEvent", header: headervi.}