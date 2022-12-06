## *
##  @file nro.h
##  @brief NRO headers.
##  @copyright libnx Authors
##

import types

const
  NROHEADER_MAGIC* = 0x304f524e
  NROASSETHEADER_MAGIC* = 0x54455341
  NROASSETHEADER_VERSION* = 0

## / Entry for each segment in the codebin.

type
  NroSegment* {.bycopy.} = object
    fileOff*: U32
    size*: U32


## / Offset 0x0 in the NRO.

type
  NroStart* {.bycopy.} = object
    unused*: U32
    modOffset*: U32
    padding*: array[8, U8]


## / This follows NroStart, the actual nro-header.

type
  NroHeader* {.bycopy.} = object
    magic*: U32
    unk1*: U32
    size*: U32
    unk2*: U32
    segments*: array[3, NroSegment]
    bssSize*: U32
    unk3*: U32
    buildId*: array[0x20, U8]
    padding*: array[0x20, U8]


## / Custom asset section.

type
  NroAssetSection* {.bycopy.} = object
    offset*: U64
    size*: U64


## / Custom asset header.

type
  NroAssetHeader* {.bycopy.} = object
    magic*: U32
    version*: U32
    icon*: NroAssetSection
    nacp*: NroAssetSection
    romfs*: NroAssetSection

