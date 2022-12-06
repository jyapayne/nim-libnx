## *
##  @file fs_dev.h
##  @brief FS driver, using devoptab.
##  @author yellows8
##  @author mtheall
##  @copyright libnx Authors
##

import ../../types
import
  ../../services/fs,
  ../../services/acc

const
  FSDEV_DIRITER_MAGIC* = 0x66736476

## / Open directory struct

type
  FsdevDirT* {.bycopy.} = object
    magic*: U32                ## /< "fsdv"
    fd*: FsDir                 ## /< File descriptor
    index*: SsizeT             ## /< Current entry index
    size*: csize_t             ## /< Current batch size

proc fsdevDirGetEntries*(dir: ptr FsdevDirT): ptr FsDirectoryEntry {.inline, cdecl.} =
  ## / Retrieves a pointer to temporary stage for reading entries
  return cast[ptr FsDirectoryEntry](cast[pointer]((cast[int](dir) + 1)))

proc fsdevMountSdmc*(): Result {.cdecl, importc: "fsdevMountSdmc".}
## / Initializes and mounts the sdmc device if accessible.

proc fsdevMountSaveData*(name: cstring; applicationId: U64; uid: AccountUid): Result {.
    cdecl, importc: "fsdevMountSaveData".}
## / Mounts the specified SaveData.

proc fsdevMountSaveDataReadOnly*(name: cstring; applicationId: U64; uid: AccountUid): Result {.
    cdecl, importc: "fsdevMountSaveDataReadOnly".}
## / Mounts the specified SaveData as ReadOnly.
## / Only available on [2.0.0+].

proc fsdevMountBcatSaveData*(name: cstring; applicationId: U64): Result {.cdecl,
    importc: "fsdevMountBcatSaveData".}
## / Mounts the specified BcatSaveData.

proc fsdevMountDeviceSaveData*(name: cstring; applicationId: U64): Result {.cdecl,
    importc: "fsdevMountDeviceSaveData".}
## / Mounts the specified DeviceSaveData.

proc fsdevMountTemporaryStorage*(name: cstring): Result {.cdecl,
    importc: "fsdevMountTemporaryStorage".}
## / Mounts the TemporaryStorage for the current process.
## / Only available on [3.0.0+].

proc fsdevMountCacheStorage*(name: cstring; applicationId: U64; saveDataIndex: U16): Result {.
    cdecl, importc: "fsdevMountCacheStorage".}
## / Mounts the specified CacheStorage.
## / Only available on [3.0.0+].

proc fsdevMountSystemSaveData*(name: cstring; saveDataSpaceId: FsSaveDataSpaceId;
                              systemSaveDataId: U64; uid: AccountUid): Result {.
    cdecl, importc: "fsdevMountSystemSaveData".}
## / Mounts the specified SystemSaveData.

proc fsdevMountSystemBcatSaveData*(name: cstring; systemSaveDataId: U64): Result {.
    cdecl, importc: "fsdevMountSystemBcatSaveData".}
## / Mounts the specified SystemBcatSaveData.
## / Only available on [4.0.0+].

proc fsdevMountDevice*(name: cstring; fs: FsFileSystem): cint {.cdecl,
    importc: "fsdevMountDevice".}
## / Mounts the input fs with the specified device name. fsdev will handle closing the fs when required, including when fsdevMountDevice() fails.
## / Returns -1 when any errors occur.
## / Input device name string shouldn't exceed 31 characters, and shouldn't have a trailing colon.

proc fsdevUnmountDevice*(name: cstring): cint {.cdecl, importc: "fsdevUnmountDevice".}
## / Unmounts the specified device.

proc fsdevCommitDevice*(name: cstring): Result {.cdecl, importc: "fsdevCommitDevice".}
## / Uses fsFsCommit() with the specified device. This must be used after any savedata-write operations(not just file-write). This should be used after each file-close where file-writing was done.
## / This is not used automatically at device unmount.

proc fsdevGetDeviceFileSystem*(name: cstring): ptr FsFileSystem {.cdecl,
    importc: "fsdevGetDeviceFileSystem".}
## / Returns the FsFileSystem for the specified device. Returns NULL when the specified device isn't found.

proc fsdevTranslatePath*(path: cstring; device: ptr ptr FsFileSystem; outpath: cstring): cint {.
    cdecl, importc: "fsdevTranslatePath".}
## / Writes the FS-path to outpath (which has buffer size FS_MAX_PATH), for the input path (as used in stdio). The FsFileSystem is also written to device when not NULL.

proc fsdevSetConcatenationFileAttribute*(path: cstring): Result {.cdecl,
    importc: "fsdevSetConcatenationFileAttribute".}
## / This calls fsFsSetConcatenationFileAttribute on the filesystem specified by the input path (as used in stdio).

proc fsdevIsValidSignedSystemPartitionOnSdCard*(name: cstring; `out`: ptr bool): Result {.
    cdecl, importc: "fsdevIsValidSignedSystemPartitionOnSdCard".}
##  Uses \ref fsFsIsValidSignedSystemPartitionOnSdCard with the specified device.

proc fsdevCreateFile*(path: cstring; size: csize_t; flags: U32): Result {.cdecl,
    importc: "fsdevCreateFile".}
## / This calls fsFsCreateFile on the filesystem specified by the input path (as used in stdio).

proc fsdevDeleteDirectoryRecursively*(path: cstring): Result {.cdecl,
    importc: "fsdevDeleteDirectoryRecursively".}
## / Recursively deletes the directory specified by the input path (as used in stdio).

proc fsdevUnmountAll*(): Result {.cdecl, importc: "fsdevUnmountAll".}
## / Unmounts all devices and cleans up any resources used by the FS driver.

proc fsdevGetLastResult*(): Result {.cdecl, importc: "fsdevGetLastResult".}
## / Retrieves the last native result code generated during a failed fsdev operation.

