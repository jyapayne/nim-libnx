import strutils
import ospaths
const headercache = currentSourcePath().splitPath().head & "/nx/include/switch/arm/cache.h"
import libnx/types
proc armDCacheFlush*(`addr`: pointer; size: csize) {.cdecl,
    importc: "armDCacheFlush", header: headercache.}
proc armDCacheClean*(`addr`: pointer; size: csize) {.cdecl,
    importc: "armDCacheClean", header: headercache.}
proc armICacheInvalidate*(`addr`: pointer; size: csize) {.cdecl,
    importc: "armICacheInvalidate", header: headercache.}
proc armDCacheZero*(`addr`: pointer; size: csize) {.cdecl, importc: "armDCacheZero",
    header: headercache.}