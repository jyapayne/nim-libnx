## *
##  @file ncm_types.h
##  @brief Content Manager (ncm) service types (see ncm.h for the rest).
##  @author Adubbz, zhuowei, and yellows8
##  @copyright libnx Authors
##

import
  ../types, ../crypto/sha256

## / StorageId

type
  NcmStorageId* = enum
    NcmStorageIdNone = 0,       ## /< None
    NcmStorageIdHost = 1,       ## /< Host
    NcmStorageIdGameCard = 2,   ## /< GameCard
    NcmStorageIdBuiltInSystem = 3, ## /< BuiltInSystem
    NcmStorageIdBuiltInUser = 4, ## /< BuiltInUser
    NcmStorageIdSdCard = 5,     ## /< SdCard
    NcmStorageIdAny = 6         ## /< Any


## / ContentType

type
  NcmContentType* = enum
    NcmContentTypeMeta = 0,     ## /< Meta
    NcmContentTypeProgram = 1,  ## /< Program
    NcmContentTypeData = 2,     ## /< Data
    NcmContentTypeControl = 3,  ## /< Control
    NcmContentTypeHtmlDocument = 4, ## /< HtmlDocument
    NcmContentTypeLegalInformation = 5, ## /< LegalInformation
    NcmContentTypeDeltaFragment = 6 ## /< DeltaFragment


## / ContentMetaType

type
  NcmContentMetaType* = enum
    NcmContentMetaTypeUnknown = 0x0, ## /< Unknown
    NcmContentMetaTypeSystemProgram = 0x1, ## /< SystemProgram
    NcmContentMetaTypeSystemData = 0x2, ## /< SystemData
    NcmContentMetaTypeSystemUpdate = 0x3, ## /< SystemUpdate
    NcmContentMetaTypeBootImagePackage = 0x4, ## /< BootImagePackage
    NcmContentMetaTypeBootImagePackageSafe = 0x5, ## /< BootImagePackageSafe
    NcmContentMetaTypeApplication = 0x80, ## /< Application
    NcmContentMetaTypePatch = 0x81, ## /< Patch
    NcmContentMetaTypeAddOnContent = 0x82, ## /< AddOnContent
    NcmContentMetaTypeDelta = 0x83 ## /< Delta


## / ContentMetaAttribute

type
  NcmContentMetaAttribute* = enum
    NcmContentMetaAttributeNone = 0, ## /< None
    NcmContentMetaAttributeIncludesExFatDriver = bit(0), ## /< IncludesExFatDriver
    NcmContentMetaAttributeRebootless = bit(1) ## /< Rebootless


## / ContentInstallType

type
  NcmContentInstallType* = enum
    NcmContentInstallTypeFull = 0, ## /< Full
    NcmContentInstallTypeFragmentOnly = 1, ## /< FragmentOnly
    NcmContentInstallTypeUnknown = 7 ## /< Unknown


## / ContentId

type
  NcmContentId* {.bycopy.} = object
    c*: array[0x10, U8]         ## /< Id


## / PlaceHolderId

type
  NcmPlaceHolderId* {.bycopy.} = object
    uuid*: Uuid                ## /< UUID


## / ContentMetaKey

type
  NcmContentMetaKey* {.bycopy.} = object
    id*: U64                   ## /< Id.
    version*: U32              ## /< Version.
    `type`*: U8                ## /< \ref NcmContentMetaType
    installType*: U8           ## /< \ref NcmContentInstallType
    padding*: array[2, U8]      ## /< Padding.


## / ApplicationContentMetaKey

type
  NcmApplicationContentMetaKey* {.bycopy.} = object
    key*: NcmContentMetaKey    ## /< \ref NcmContentMetaKey
    applicationId*: U64        ## /< ApplicationId.


## / ContentInfo

type
  NcmContentInfo* {.bycopy.} = object
    contentId*: NcmContentId   ## /< \ref NcmContentId
    size*: array[0x6, U8]       ## /< Content size.
    contentType*: U8           ## /< \ref NcmContentType.
    idOffset*: U8              ## /< Offset of this content. Unused by most applications.


## / PackagedContentInfo

type
  NcmPackagedContentInfo* {.bycopy.} = object
    hash*: array[Sha256Hash_Size, U8]
    info*: NcmContentInfo


## / ContentMetaInfo

type
  NcmContentMetaInfo* {.bycopy.} = object
    id*: U64                   ## /< Id.
    version*: U32              ## /< Version.
    `type`*: U8                ## /< \ref NcmContentMetaType
    attr*: U8                  ## /< \ref NcmContentMetaAttribute
    padding*: array[2, U8]      ## /< Padding.


## / ContentMetaHeader

type
  NcmContentMetaHeader* {.bycopy.} = object
    extendedHeaderSize*: U16   ## /< Size of optional struct that comes after this one.
    contentCount*: U16         ## /< Number of NcmContentInfos after the extra bytes.
    contentMetaCount*: U16     ## /< Number of NcmContentMetaInfos that come after the NcmContentInfos.
    attributes*: U8            ## /< Usually None (0).
    storageId*: U8             ## /< Usually None (0).


## / ApplicationMetaExtendedHeader

type
  NcmApplicationMetaExtendedHeader* {.bycopy.} = object
    patchId*: U64              ## /< PatchId of this application's patch.
    requiredSystemVersion*: U32 ## /< Firmware version required by this application.
    requiredApplicationVersion*: U32 ## /< [9.0.0+] Owner application version required by this application. Previously padding.


## / PatchMetaExtendedHeader

type
  NcmPatchMetaExtendedHeader* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId of this patch's corresponding application.
    requiredSystemVersion*: U32 ## /< Firmware version required by this patch.
    extendedDataSize*: U32     ## /< Size of the extended data following the NcmContentInfos.
    reserved*: array[0x8, U8]   ## /< Unused.


## / AddOnContentMetaExtendedHeader

type
  NcmAddOnContentMetaExtendedHeader* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId of this add-on-content's corresponding application.
    requiredApplicationVersion*: U32 ## /< Version of the application required by this add-on-content.
    padding*: U32              ## /< Padding.


## / SystemUpdateMetaExtendedHeader

type
  NcmSystemUpdateMetaExtendedHeader* {.bycopy.} = object
    extendedDataSize*: U32     ## /< Size of the extended data after NcmContentInfos and NcmContentMetaInfos.


## / ProgramLocation

type
  NcmProgramLocation* {.bycopy.} = object
    programId*: U64            ## /< ProgramId
    storageID*: U8             ## /< \ref NcmStorageId
    pad*: array[7, U8]          ## /< Padding

