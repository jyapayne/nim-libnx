## *
##  @file caps.h
##  @brief Common caps (caps:*) service IPC header.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../services/acc

## / ImageOrientation

type
  AlbumImageOrientation* = enum
    AlbumImageOrientationUnknown0 = 0, ## /< Unknown. Default.
    AlbumImageOrientationUnknown1 = 1, ## /< Unknown.
    AlbumImageOrientationUnknown2 = 2, ## /< Unknown.
    AlbumImageOrientationUnknown3 = 3 ## /< Unknown.


## / AlbumReportOption

type
  AlbumReportOption* = enum
    AlbumReportOptionDisable = 0, ## /< Don't display the screenshot-taken Overlay-applet notification.
    AlbumReportOptionEnable = 1 ## /< Display the screenshot-taken Overlay notification.
  CapsAlbumStorage* = enum
    CapsAlbumStorageNand = 0,   ## /< Nand
    CapsAlbumStorageSd = 1      ## /< Sd



## / ContentType

type
  CapsContentType* = enum
    CapsContentTypeScreenshot = 0, ## /< Album screenshots.
    CapsContentTypeMovie = 1,   ## /< Album videos.
    CapsContentTypeExtraMovie = 3 ## /< Videos recorded by the current host Application via \ref grcCreateMovieMaker.


## / ScreenShotAttribute

type
  CapsScreenShotAttribute* {.bycopy.} = object
    unkX0*: U32                ## /< Always set to 0 by official sw.
    orientation*: U32          ## /< \ref AlbumImageOrientation
    unkX8*: U32                ## /< Always set to 0 by official sw.
    unkXc*: U32                ## /< Always set to 1 by official sw.
    unkX10*: array[0x30, U8]    ## /< Always set to 0 by official sw.


## / ScreenShotAttributeForApplication. Only unk_x0 is used by official sw.

type
  CapsScreenShotAttributeForApplication* {.bycopy.} = object
    unkX0*: U32                ## /< Unknown.
    unkX4*: U8                 ## /< Unknown.
    unkX5*: U8                 ## /< Unknown.
    unkX6*: U8                 ## /< Unknown.
    pad*: U8                   ## /< Padding.
    unkX8*: U32                ## /< Unknown.
    unkXc*: U32                ## /< Unknown.
    unkX10*: U32               ## /< Unknown.
    unkX14*: U32               ## /< Unknown.
    unkX18*: U32               ## /< Unknown.
    unkX1c*: U32               ## /< Unknown.
    unkX20*: U16               ## /< Unknown.
    unkX22*: U16               ## /< Unknown.
    unkX24*: U16               ## /< Unknown.
    unkX26*: U16               ## /< Unknown.
    reserved*: array[0x18, U8]  ## /< Always zero.


## / ScreenShotDecoderFlag

type
  CapsScreenShotDecoderFlag* = enum
    CapsScreenShotDecoderFlagNone = 0, ## /< No special processing.
    CapsScreenShotDecoderFlagEnableFancyUpsampling = bit(0), ## /< See libjpeg-turbo do_fancy_upsampling.
    CapsScreenShotDecoderFlagEnableBlockSmoothing = bit(1) ## /< See libjpeg-turbo do_block_smoothing.


## / ScreenShotDecodeOption

type
  CapsScreenShotDecodeOption* {.bycopy.} = object
    flags*: U64                ## /< Bitflags, see \ref CapsScreenShotDecoderFlag.
    reserved*: array[0x3, U64]  ## /< Reserved. Unused by official sw.


## / AlbumFileDateTime. This corresponds to each field in the Album entry filename, prior to the "-": "YYYYMMDDHHMMSSII".

type
  CapsAlbumFileDateTime* {.bycopy.} = object
    year*: U16                 ## /< Year.
    month*: U8                 ## /< Month.
    day*: U8                   ## /< Day of the month.
    hour*: U8                  ## /< Hour.
    minute*: U8                ## /< Minute.
    second*: U8                ## /< Second.
    id*: U8                    ## /< Unique ID for when there's multiple Album files with the same timestamp.


## / AlbumEntryId

type
  CapsAlbumFileId* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId
    datetime*: CapsAlbumFileDateTime ## /< \ref CapsAlbumFileDateTime
    storage*: U8               ## /< \ref CapsAlbumStorage
    content*: U8               ## /< \ref CapsAlbumFileContents
    padX12*: array[0x6, U8]     ## /< padding


## / AlbumEntry

type
  CapsAlbumEntry* {.bycopy.} = object
    size*: U64                 ## /< Size.
    fileId*: CapsAlbumFileId   ## /< \ref CapsAlbumFileId


## / ApplicationAlbumEntry

type
  INNER_C_STRUCT_caps_5* {.bycopy.} = object
    unkX0*: array[0x20, U8]     ## /< aes256 with random key over \ref AlbumEntry.

  INNER_C_STRUCT_caps_6* {.bycopy.} = object
    size*: U64                 ## /< size of the entry
    hash*: U64                 ## /< aes256 with hardcoded key over \ref AlbumEntry.
    datetime*: CapsAlbumFileDateTime ## /< \ref CapsAlbumFileDateTime
    storage*: U8               ## /< \ref CapsAlbumStorage
    content*: U8               ## /< \ref CapsAlbumFileContents
    padX1a*: array[0x5, U8]     ## /< padding
    unkX1f*: U8                ## /< Set to 1 by official software

  INNER_C_UNION_caps_4* {.bycopy, union.} = object
    data*: array[0x20, U8]      ## /< Data.
    v0*: INNER_C_STRUCT_caps_5 ## /< Pre-7.0.0
    v1*: INNER_C_STRUCT_caps_6 ## /< [7.0.0+]

  CapsApplicationAlbumEntry* {.bycopy.} = object
    anoCaps7*: INNER_C_UNION_caps_4

template data*(caae: CapsApplicationAlbumEntry): array[0x20, U8] =
  caae.anoCaps7.data

template v0*(caae: CapsApplicationAlbumEntry): INNER_C_STRUCT_caps_5 =
  caae.anoCaps7.v0

template v1*(caae: CapsApplicationAlbumEntry): INNER_C_STRUCT_caps_6 =
  caae.anoCaps7.v1


## / ApplicationAlbumFileEntry

type
  CapsApplicationAlbumFileEntry* {.bycopy.} = object
    entry*: CapsApplicationAlbumEntry ## /< \ref CapsApplicationAlbumEntry
    datetime*: CapsAlbumFileDateTime ## /< \ref CapsAlbumFileDateTime
    unkX28*: U64               ## /< Unknown.


## / ApplicationData

type
  CapsApplicationData* {.bycopy.} = object
    userdata*: array[0x400, U8] ## /< UserData.
    size*: U32                 ## /< UserData size.


## / AlbumFileContents

type
  CapsAlbumFileContents* = enum
    CapsAlbumFileContentsScreenShot = 0, CapsAlbumFileContentsMovie = 1,
    CapsAlbumFileContentsExtraScreenShot = 2, CapsAlbumFileContentsExtraMovie = 3
  CapsAlbumContentsUsageFlag* = enum
    CapsAlbumContentsUsageFlagHasGreaterUsage = bit(0), ## /< Indicates that there are additional files not captured by the count/size fields of CapsAlbumContentsUsage
    CapsAlbumContentsUsageFlagIsUnknownContents = bit(1) ## /< Indicates that the file is not a known content type
  CapsAlbumContentsUsage* {.bycopy.} = object
    count*: S64                ## /< Count.
    size*: S64                 ## /< Size. Used storage space.
    flags*: U32                ## /< \ref CapsAlbumContentsUsageFlag
    fileContents*: U8          ## /< \ref CapsAlbumFileContents
    padX15*: array[0x3, U8]     ## /< Unused

  CapsAlbumUsage2* {.bycopy.} = object
    usages*: array[2, CapsAlbumContentsUsage] ## /< \ref CapsAlbumContentsUsage

  CapsAlbumUsage3* {.bycopy.} = object
    usages*: array[3, CapsAlbumContentsUsage] ## /< \ref CapsAlbumContentsUsage

  CapsAlbumUsage16* {.bycopy.} = object
    usages*: array[16, CapsAlbumContentsUsage] ## /< \ref CapsAlbumContentsUsage




## / UserIdList

type
  CapsUserIdList* {.bycopy.} = object
    uids*: array[Acc_User_List_Size, AccountUid] ## /< \ref AccountUid
    count*: U8                 ## /< Total userIDs.
    pad*: array[7, U8]          ## /< Padding.


## / LoadAlbumScreenShotImageOutputForApplication

type
  CapsLoadAlbumScreenShotImageOutputForApplication* {.bycopy.} = object
    width*: S64                ## /< Width. Official sw copies this to a s32 output field.
    height*: S64               ## /< Height. Official sw copies this to a s32 output field.
    attr*: CapsScreenShotAttributeForApplication ## /< \ref CapsScreenShotAttributeForApplication
    appdata*: CapsApplicationData ## /< \ref CapsApplicationData
    reserved*: array[0xac, U8]  ## /< Unused.


## / LoadAlbumScreenShotImageOutput

type
  CapsLoadAlbumScreenShotImageOutput* {.bycopy.} = object
    width*: S64                ## /< Width. Official sw copies this to a s32 output field.
    height*: S64               ## /< Height. Official sw copies this to a s32 output field.
    attr*: CapsScreenShotAttribute ## /< \ref CapsScreenShotAttribute
    unkX50*: array[0x400, U8]   ## /< Unused.


## / AlbumFileContentsFlag

type
  CapsAlbumFileContentsFlag* = enum
    CapsAlbumFileContentsFlagScreenShot = bit(0), ## /< Query for ScreenShot files.
    CapsAlbumFileContentsFlagMovie = bit(1) ## /< Query for Movie files.


## / AlbumCache

type
  CapsAlbumCache* {.bycopy.} = object
    count*: U64                ## /< Count
    unkX8*: U64                ## /< Unknown

proc capsGetShimLibraryVersion*(): U64 {.cdecl, importc: "capsGetShimLibraryVersion".}
## / Gets the ShimLibraryVersion.

proc capsGetDefaultStartDateTime*(): CapsAlbumFileDateTime {.inline, cdecl.} =
  ## / Gets the default start_datetime.
  return CapsAlbumFileDateTime(year: 1970, month: 1, day: 1)

proc capsGetDefaultEndDateTime*(): CapsAlbumFileDateTime {.inline, cdecl,
    importc: "capsGetDefaultEndDateTime".} =
  ## / Gets the default end_datetime.
  return CapsAlbumFileDateTime(year: 3000,month: 1,day: 1)

proc capsConvertApplicationAlbumFileEntryToApplicationAlbumEntry*(
    `out`: ptr CapsApplicationAlbumEntry; `in`: ptr CapsApplicationAlbumFileEntry) {.
    inline, cdecl,
    importc: "capsConvertApplicationAlbumFileEntryToApplicationAlbumEntry".} =
  ## / Convert a \ref CapsApplicationAlbumFileEntry to \ref CapsApplicationAlbumEntry.
  `out`[] = `in`.entry

proc capsConvertApplicationAlbumEntryToApplicationAlbumFileEntry*(
    `out`: ptr CapsApplicationAlbumFileEntry; `in`: ptr CapsApplicationAlbumEntry) {.
    inline, cdecl,
    importc: "capsConvertApplicationAlbumEntryToApplicationAlbumFileEntry".} =
  ## / Convert a \ref CapsApplicationAlbumEntry to \ref CapsApplicationAlbumFileEntry. Should only be used on [7.0.0+].
  `out`.entry = `in`[]
  `out`.datetime = `in`[].v1.datetime
  `out`.unkX28 = 0
