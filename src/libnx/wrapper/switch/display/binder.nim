import
  ../types, ../kernel/event, ../sf/service

const
  BINDER_FIRST_CALL_TRANSACTION* = 0x1

type
  Binder* {.bycopy.} = object
    created*: bool
    initialized*: bool
    id*: S32
    dummy*: csize_t
    relay*: ptr Service


##  Note: binderClose will not close the session_handle provided to binderCreate.

proc binderCreate*(b: ptr Binder; id: S32) {.cdecl, importc: "binderCreate".}
proc binderClose*(b: ptr Binder) {.cdecl, importc: "binderClose".}
proc binderInitSession*(b: ptr Binder; relay: ptr Service): Result {.cdecl,
    importc: "binderInitSession".}
proc binderTransactParcel*(b: ptr Binder; code: U32; parcelData: pointer;
                          parcelDataSize: csize_t; parcelReply: pointer;
                          parcelReplySize: csize_t; flags: U32): Result {.cdecl,
    importc: "binderTransactParcel".}
proc binderConvertErrorCode*(code: S32): Result {.cdecl,
    importc: "binderConvertErrorCode".}
proc binderAdjustRefcount*(b: ptr Binder; addval: S32; `type`: S32): Result {.cdecl,
    importc: "binderAdjustRefcount".}
proc binderGetNativeHandle*(b: ptr Binder; unk0: U32; eventOut: ptr Event): Result {.
    cdecl, importc: "binderGetNativeHandle".}
proc binderIncreaseWeakRef*(b: ptr Binder): Result {.inline, cdecl.} =
  return binderAdjustRefcount(b, 1, 0)

proc binderDecreaseWeakRef*(b: ptr Binder): Result {.inline, cdecl.} =
  return binderAdjustRefcount(b, -1, 0)

proc binderIncreaseStrongRef*(b: ptr Binder): Result {.inline, cdecl.} =
  return binderAdjustRefcount(b, 1, 1)

proc binderDecreaseStrongRef*(b: ptr Binder): Result {.inline, cdecl.} =
  return binderAdjustRefcount(b, -1, 1)
