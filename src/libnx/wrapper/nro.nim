import strutils
import ospaths
const headernro = currentSourcePath().splitPath().head & "/nx/include/switch/nro.h"
const
  NROHEADER_MAGIC* = 0x0304F524
  NROASSETHEADER_MAGIC* = 0x54455341
  NROASSETHEADER_VERSION* = 0

type
  NroSegment* {.importc: "NroSegment", header: headernro, bycopy.} = object
    file_off* {.importc: "file_off".}: uint32
    size* {.importc: "size".}: uint32

  NroStart* {.importc: "NroStart", header: headernro, bycopy.} = object
    unused* {.importc: "unused".}: uint32
    mod_offset* {.importc: "mod_offset".}: uint32
    padding* {.importc: "padding".}: array[8, uint8]

  NroHeader* {.importc: "NroHeader", header: headernro, bycopy.} = object
    magic* {.importc: "magic".}: uint32
    unk1* {.importc: "unk1".}: uint32
    size* {.importc: "size".}: uint32
    unk2* {.importc: "unk2".}: uint32
    segments* {.importc: "segments".}: array[3, NroSegment]
    bss_size* {.importc: "bss_size".}: uint32
    unk3* {.importc: "unk3".}: uint32
    build_id* {.importc: "build_id".}: array[0x00000020, uint8]
    padding* {.importc: "padding".}: array[0x00000020, uint8]

  NroAssetSection* {.importc: "NroAssetSection", header: headernro, bycopy.} = object
    offset* {.importc: "offset".}: uint64
    size* {.importc: "size".}: uint64

  NroAssetHeader* {.importc: "NroAssetHeader", header: headernro, bycopy.} = object
    magic* {.importc: "magic".}: uint32
    version* {.importc: "version".}: uint32
    icon* {.importc: "icon".}: NroAssetSection
    nacp* {.importc: "nacp".}: NroAssetSection
    romfs* {.importc: "romfs".}: NroAssetSection

