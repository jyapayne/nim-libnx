import strutils
import ospaths
const headerpl = currentSourcePath().splitPath().head & "/nx/include/switch/services/pl.h"
import libnx/types
type
  PlSharedFontType* {.size: sizeof(cint).} = enum
    PlSharedFontType_Standard = 0, PlSharedFontType_ChineseSimplified = 1,
    PlSharedFontType_ExtChineseSimplified = 2,
    PlSharedFontType_ChineseTraditional = 3, PlSharedFontType_KO = 4,
    PlSharedFontType_NintendoExt = 5, PlSharedFontType_Total
  PlFontData* {.importc: "PlFontData", header: headerpl, bycopy.} = object
    `type`* {.importc: "type".}: uint32
    offset* {.importc: "offset".}: uint32
    size* {.importc: "size".}: uint32
    address* {.importc: "address".}: pointer



proc plInitialize*(): Result {.cdecl, importc: "plInitialize", header: headerpl.}
proc plExit*() {.cdecl, importc: "plExit", header: headerpl.}
proc plGetSharedmemAddr*(): pointer {.cdecl, importc: "plGetSharedmemAddr",
                                   header: headerpl.}
proc plGetSharedFontByType*(font: ptr PlFontData; SharedFontType: uint32): Result {.
    cdecl, importc: "plGetSharedFontByType", header: headerpl.}
proc plGetSharedFont*(LanguageCode: uint64; fonts: ptr PlFontData; max_fonts: csize;
                     total_fonts: ptr csize): Result {.cdecl,
    importc: "plGetSharedFont", header: headerpl.}