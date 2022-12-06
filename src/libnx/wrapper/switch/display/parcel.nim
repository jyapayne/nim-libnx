import
  ../result, ../display/binder

type
  ParcelHeader* {.bycopy.} = object
    payloadSize*: U32
    payloadOff*: U32
    objectsSize*: U32
    objectsOff*: U32


const
  PARCEL_MAX_PAYLOAD* = 0x400

type
  Parcel* {.bycopy.} = object
    payload*: array[Parcel_Max_Payload, U8]
    payloadSize*: U32
    objects*: ptr U8
    objectsSize*: U32
    capacity*: U32
    pos*: U32


proc parcelCreate*(ctx: ptr Parcel) {.cdecl, importc: "parcelCreate".}
proc parcelTransact*(session: ptr Binder; code: U32; inParcel: ptr Parcel;
                    replyParcel: ptr Parcel): Result {.cdecl,
    importc: "parcelTransact".}
proc parcelWriteData*(ctx: ptr Parcel; data: pointer; dataSize: csize_t): pointer {.
    cdecl, importc: "parcelWriteData".}
proc parcelReadData*(ctx: ptr Parcel; data: pointer; dataSize: csize_t): pointer {.cdecl,
    importc: "parcelReadData".}
proc parcelWriteInt32*(ctx: ptr Parcel; val: S32) {.cdecl, importc: "parcelWriteInt32".}
proc parcelWriteUInt32*(ctx: ptr Parcel; val: U32) {.cdecl,
    importc: "parcelWriteUInt32".}
proc parcelWriteString16*(ctx: ptr Parcel; str: cstring) {.cdecl,
    importc: "parcelWriteString16".}
proc parcelReadInt32*(ctx: ptr Parcel): S32 {.cdecl, importc: "parcelReadInt32".}
proc parcelReadUInt32*(ctx: ptr Parcel): U32 {.cdecl, importc: "parcelReadUInt32".}
proc parcelWriteInterfaceToken*(ctx: ptr Parcel; str: cstring) {.cdecl,
    importc: "parcelWriteInterfaceToken".}
proc parcelReadFlattenedObject*(ctx: ptr Parcel; size: ptr csize_t): pointer {.cdecl,
    importc: "parcelReadFlattenedObject".}
proc parcelWriteFlattenedObject*(ctx: ptr Parcel; data: pointer; size: csize_t): pointer {.
    cdecl, importc: "parcelWriteFlattenedObject".}
