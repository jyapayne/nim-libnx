import strutils
import ospaths
const headerfs_dev = currentSourcePath().splitPath().head & "/nx/include/switch/runtime/devices/fs_dev.h"
import libnx/types
import libnx/fs
const
  FSDEV_DIRITER_MAGIC* = 0x66736476

type
  fsdev_dir_t* {.importc: "fsdev_dir_t", header: headerfs_dev, bycopy.} = object
    magic* {.importc: "magic".}: uint32
    fd* {.importc: "fd".}: FsDir
    index* {.importc: "index".}: ssize_t
    size* {.importc: "size".}: csize
    entry_data* {.importc: "entry_data".}: array[32, FsDirectoryEntry]


proc fsdevMountSdmc*(): Result {.cdecl, importc: "fsdevMountSdmc",
                              header: headerfs_dev.}
proc fsdevMountDevice*(name: cstring; fs: FsFileSystem): cint {.cdecl,
    importc: "fsdevMountDevice", header: headerfs_dev.}
proc fsdevUnmountDevice*(name: cstring): cint {.cdecl,
    importc: "fsdevUnmountDevice", header: headerfs_dev.}
proc fsdevCommitDevice*(name: cstring): Result {.cdecl,
    importc: "fsdevCommitDevice", header: headerfs_dev.}
proc fsdevGetDefaultFileSystem*(): ptr FsFileSystem {.cdecl,
    importc: "fsdevGetDefaultFileSystem", header: headerfs_dev.}
proc fsdevUnmountAll*(): Result {.cdecl, importc: "fsdevUnmountAll",
                               header: headerfs_dev.}