import strutils
import ospaths
const headernacp = currentSourcePath().splitPath().head & "/nx/include/switch/nacp.h"
import libnx/wrapper/types
type
  NacpLanguageEntry* {.importc: "NacpLanguageEntry", header: headernacp, bycopy.} = object
    name* {.importc: "name".}: array[0x00000200, char]
    author* {.importc: "author".}: array[0x00000100, char]

  NacpStruct* {.importc: "NacpStruct", header: headernacp, bycopy.} = object
    lang* {.importc: "lang".}: array[16, NacpLanguageEntry]
    x3000_unk* {.importc: "x3000_unk".}: array[0x00000024, uint8]
    x3024_unk* {.importc: "x3024_unk".}: uint32
    x3028_unk* {.importc: "x3028_unk".}: uint32
    x302C_unk* {.importc: "x302C_unk".}: uint32
    x3030_unk* {.importc: "x3030_unk".}: uint32
    x3034_unk* {.importc: "x3034_unk".}: uint32
    titleID0* {.importc: "titleID0".}: uint64
    x3040_unk* {.importc: "x3040_unk".}: array[0x00000020, uint8]
    version* {.importc: "version".}: array[0x00000010, char]
    titleID_DlcBase* {.importc: "titleID_DlcBase".}: uint64
    titleID1* {.importc: "titleID1".}: uint64
    x3080_unk* {.importc: "x3080_unk".}: uint32
    x3084_unk* {.importc: "x3084_unk".}: uint32
    x3088_unk* {.importc: "x3088_unk".}: uint32
    x308C_unk* {.importc: "x308C_unk".}: array[0x00000024, uint8]
    titleID2* {.importc: "titleID2".}: uint64
    titleIDs* {.importc: "titleIDs".}: array[7, uint64]
    x30F0_unk* {.importc: "x30F0_unk".}: uint32
    x30F4_unk* {.importc: "x30F4_unk".}: uint32
    titleID3* {.importc: "titleID3".}: uint64
    bcatPassphrase* {.importc: "bcatPassphrase".}: array[0x00000040, char]
    x3140_unk* {.importc: "x3140_unk".}: array[0x00000EC0, uint8]


proc nacpGetLanguageEntry*(nacp: ptr NacpStruct;
                          langentry: ptr ptr NacpLanguageEntry): Result {.cdecl,
    importc: "nacpGetLanguageEntry", header: headernacp.}