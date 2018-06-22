import strutils
import ospaths
const headerbinder = currentSourcePath().splitPath().head & "/nx/include/switch/gfx/binder.h"
import libnx/types
const
  BINDER_FIRST_CALL_TRANSACTION* = 0x00000001

type
  Binder* {.importc: "Binder", header: headerbinder, bycopy.} = object
    created* {.importc: "created".}: bool
    initialized* {.importc: "initialized".}: bool
    sessionHandle* {.importc: "sessionHandle".}: Handle
    id* {.importc: "id".}: s32
    nativeHandle* {.importc: "nativeHandle".}: Handle
    ipcBufferSize* {.importc: "ipcBufferSize".}: csize
    hasTransactAuto* {.importc: "hasTransactAuto".}: bool


proc binderCreateSession*(session: ptr Binder; sessionHandle: Handle; ID: s32) {.
    cdecl, importc: "binderCreateSession", header: headerbinder.}
proc binderInitSession*(session: ptr Binder; unk0: uint32): Result {.cdecl,
    importc: "binderInitSession", header: headerbinder.}
proc binderExitSession*(session: ptr Binder) {.cdecl, importc: "binderExitSession",
    header: headerbinder.}
proc binderTransactParcel*(session: ptr Binder; code: uint32; parcel_data: pointer;
                          parcel_data_size: csize; parcel_reply: pointer;
                          parcel_reply_size: csize; flags: uint32): Result {.cdecl,
    importc: "binderTransactParcel", header: headerbinder.}
proc binderAdjustRefcount*(session: ptr Binder; addval: s32; `type`: s32): Result {.
    cdecl, importc: "binderAdjustRefcount", header: headerbinder.}
proc binderGetNativeHandle*(session: ptr Binder; unk0: uint32; handle_out: ptr Handle): Result {.
    cdecl, importc: "binderGetNativeHandle", header: headerbinder.}