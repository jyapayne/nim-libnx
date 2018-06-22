import strutils
import ospaths
const headerapplet = currentSourcePath().splitPath().head & "/nx/include/switch/services/applet.h"
import libnx_wrapper/types
type
  AppletType* {.size: sizeof(cint).} = enum
    AppletType_None = -2, AppletType_Default = -1, AppletType_Application = 0,
    AppletType_SystemApplet = 1, AppletType_LibraryApplet = 2,
    AppletType_OverlayApplet = 3, AppletType_SystemApplication = 4
  AppletOperationMode* {.size: sizeof(cint).} = enum
    AppletOperationMode_Handheld = 0, AppletOperationMode_Docked = 1
  AppletHookType* {.size: sizeof(cint).} = enum
    AppletHookType_OnFocusState = 0, AppletHookType_OnOperationMode,
    AppletHookType_OnPerformanceMode, AppletHookType_Max
  AppletHookFn* = proc (hook: AppletHookType; param: pointer) {.cdecl.}




type
  AppletHookCookie* {.importc: "AppletHookCookie", header: headerapplet, bycopy.} = object
    next* {.importc: "next".}: ptr AppletHookCookie
    callback* {.importc: "callback".}: AppletHookFn
    param* {.importc: "param".}: pointer


proc appletInitialize*(): Result {.cdecl, importc: "appletInitialize",
                                header: headerapplet.}
proc appletExit*() {.cdecl, importc: "appletExit", header: headerapplet.}
proc appletGetAppletResourceUserId*(`out`: ptr uint64): Result {.cdecl,
    importc: "appletGetAppletResourceUserId", header: headerapplet.}
proc appletNotifyRunning*(`out`: ptr uint8) {.cdecl, importc: "appletNotifyRunning",
                                       header: headerapplet.}
proc appletCreateManagedDisplayLayer*(`out`: ptr uint64): Result {.cdecl,
    importc: "appletCreateManagedDisplayLayer", header: headerapplet.}
proc appletGetDesiredLanguage*(LanguageCode: ptr uint64): Result {.cdecl,
    importc: "appletGetDesiredLanguage", header: headerapplet.}
proc appletSetScreenShotPermission*(val: s32): Result {.cdecl,
    importc: "appletSetScreenShotPermission", header: headerapplet.}
proc appletSetScreenShotImageOrientation*(val: s32): Result {.cdecl,
    importc: "appletSetScreenShotImageOrientation", header: headerapplet.}
proc appletMainLoop*(): bool {.cdecl, importc: "appletMainLoop",
                             header: headerapplet.}
proc appletHook*(cookie: ptr AppletHookCookie; callback: AppletHookFn; param: pointer) {.
    cdecl, importc: "appletHook", header: headerapplet.}
proc appletUnhook*(cookie: ptr AppletHookCookie) {.cdecl, importc: "appletUnhook",
    header: headerapplet.}
proc appletGetOperationMode*(): uint8 {.cdecl, importc: "appletGetOperationMode",
                                  header: headerapplet.}
proc appletGetPerformanceMode*(): uint32 {.cdecl,
                                     importc: "appletGetPerformanceMode",
                                     header: headerapplet.}
proc appletGetFocusState*(): uint8 {.cdecl, importc: "appletGetFocusState",
                               header: headerapplet.}