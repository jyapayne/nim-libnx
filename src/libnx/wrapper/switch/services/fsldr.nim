## *
##  @file fsldr.h
##  @brief FilesystemProxy-ForLoader (fsp-ldr) service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/fs, ../crypto/sha256

type
  FsCodeInfo* {.bycopy.} = object
    signature*: array[0x100, U8]
    hash*: array[Sha256Hash_Size, U8]
    isSigned*: bool
    reserved*: array[3, U8]



proc fsldrInitialize*(): Result {.cdecl, importc: "fsldrInitialize".}
## / Initialize fsp-ldr.

proc fsldrExit*() {.cdecl, importc: "fsldrExit".}
## / Exit fsp-ldr.

proc fsldrGetServiceSession*(): ptr Service {.cdecl,
    importc: "fsldrGetServiceSession".}
## / Gets the Service object for the actual fsp-ldr service session.

proc fsldrOpenCodeFileSystem*(outCodeInfo: ptr FsCodeInfo; tid: U64; path: cstring;
                             `out`: ptr FsFileSystem): Result {.cdecl,
    importc: "fsldrOpenCodeFileSystem".}
proc fsldrIsArchivedProgram*(pid: U64; `out`: ptr bool): Result {.cdecl,
    importc: "fsldrIsArchivedProgram".}
