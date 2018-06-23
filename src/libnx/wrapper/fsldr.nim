import strutils
import ospaths
const headerfsldr = currentSourcePath().splitPath().head & "/nx/include/switch/services/fsldr.h"
import libnx/wrapper/types
import libnx/wrapper/sm
import libnx/wrapper/fs
proc fsldrInitialize*(): Result {.cdecl, importc: "fsldrInitialize",
                               header: headerfsldr.}
proc fsldrExit*() {.cdecl, importc: "fsldrExit", header: headerfsldr.}
proc fsldrOpenCodeFileSystem*(tid: uint64; path: cstring; `out`: ptr FsFileSystem): Result {.
    cdecl, importc: "fsldrOpenCodeFileSystem", header: headerfsldr.}
proc fsldrIsArchivedProgram*(pid: uint64; `out`: ptr bool): Result {.cdecl,
    importc: "fsldrIsArchivedProgram", header: headerfsldr.}
proc fsldrSetCurrentProcess*(): Result {.cdecl, importc: "fsldrSetCurrentProcess",
                                      header: headerfsldr.}