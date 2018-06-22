import strutils
import ospaths
const headerparcel = currentSourcePath().splitPath().head & "/nx/include/switch/gfx/parcel.h"
import libnx/types
import libnx/result
import libnx/binder
type
  Parcel* {.importc: "Parcel", header: headerparcel, bycopy.} = object
    payload* {.importc: "payload".}: array[0x00000400, uint8]
    capacity* {.importc: "capacity".}: uint32
    size* {.importc: "size".}: uint32
    pos* {.importc: "pos".}: uint32
    ParcelObjects* {.importc: "ParcelObjects".}: ptr uint8
    ParcelObjectsSize* {.importc: "ParcelObjectsSize".}: uint32


proc parcelInitialize*(ctx: ptr Parcel) {.cdecl, importc: "parcelInitialize",
                                      header: headerparcel.}
proc parcelTransact*(session: ptr Binder; code: uint32; in_parcel: ptr Parcel;
                    reply_parcel: ptr Parcel): Result {.cdecl,
    importc: "parcelTransact", header: headerparcel.}
proc parcelWriteData*(ctx: ptr Parcel; data: pointer; data_size: csize): pointer {.
    cdecl, importc: "parcelWriteData", header: headerparcel.}
proc parcelReadData*(ctx: ptr Parcel; data: pointer; data_size: csize): pointer {.
    cdecl, importc: "parcelReadData", header: headerparcel.}
proc parcelWriteInt32*(ctx: ptr Parcel; val: s32) {.cdecl,
    importc: "parcelWriteInt32", header: headerparcel.}
proc parcelWriteUInt32*(ctx: ptr Parcel; val: uint32) {.cdecl,
    importc: "parcelWriteUInt32", header: headerparcel.}
proc parcelWriteString16*(ctx: ptr Parcel; str: cstring) {.cdecl,
    importc: "parcelWriteString16", header: headerparcel.}
proc parcelReadInt32*(ctx: ptr Parcel): s32 {.cdecl, importc: "parcelReadInt32",
    header: headerparcel.}
proc parcelReadUInt32*(ctx: ptr Parcel): uint32 {.cdecl, importc: "parcelReadUInt32",
    header: headerparcel.}
proc parcelWriteInterfaceToken*(ctx: ptr Parcel; str: cstring) {.cdecl,
    importc: "parcelWriteInterfaceToken", header: headerparcel.}
proc parcelReadFlattenedObject*(ctx: ptr Parcel; size: ptr csize): pointer {.cdecl,
    importc: "parcelReadFlattenedObject", header: headerparcel.}
proc parcelWriteFlattenedObject*(ctx: ptr Parcel; data: pointer; size: csize): pointer {.
    cdecl, importc: "parcelWriteFlattenedObject", header: headerparcel.}