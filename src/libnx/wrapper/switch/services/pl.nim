## *
##  @file pl.h
##  @brief pl:u service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

type
  PlServiceType* = enum
    PlServiceTypeUser = 0,      ## /< Initializes pl:u.
    PlServiceTypeSystem = 1     ## /< Initializes pl:s.


## / SharedFontType

type
  PlSharedFontType* = enum
    PlSharedFontTypeStandard = 0, ## /< Japan, US and Europe
    PlSharedFontTypeChineseSimplified = 1, ## /< Chinese Simplified
    PlSharedFontTypeExtChineseSimplified = 2, ## /< Extended Chinese Simplified
    PlSharedFontTypeChineseTraditional = 3, ## /< Chinese Traditional
    PlSharedFontTypeKO = 4,     ## /< Korean (Hangul)
    PlSharedFontTypeNintendoExt = 5, ## /< Nintendo Extended. This font only has the special Nintendo-specific characters, which aren't available with the other fonts.
    PlSharedFontTypeTotal     ## /< Total fonts supported by this enum.


## / FontData

type
  PlFontData* {.bycopy.} = object
    `type`*: U32               ## /< \ref PlSharedFontType
    offset*: U32               ## /< Offset of the font in sharedmem.
    size*: U32                 ## /< Size of the font.
    address*: pointer          ## /< Address of the actual font.


## / Initialize pl.

proc plInitialize*(serviceType: PlServiceType): Result {.cdecl,
    importc: "plInitialize".}
## / Exit pl.

proc plExit*() {.cdecl, importc: "plExit".}
## / Gets the Service object for the actual pl service session.

proc plGetServiceSession*(): ptr Service {.cdecl, importc: "plGetServiceSession".}
## / Gets the address of the SharedMemory.

proc plGetSharedmemAddr*(): pointer {.cdecl, importc: "plGetSharedmemAddr".}
## /< Gets a specific shared-font via \ref PlSharedFontType.

proc plGetSharedFontByType*(font: ptr PlFontData; sharedFontType: PlSharedFontType): Result {.
    cdecl, importc: "plGetSharedFontByType".}
## /< Gets shared font(s).

proc plGetSharedFont*(languageCode: U64; fonts: ptr PlFontData; maxFonts: S32;
                     totalFonts: ptr S32): Result {.cdecl, importc: "plGetSharedFont".}