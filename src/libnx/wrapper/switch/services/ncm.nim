## *
##  @file ncm.h
##  @brief Content Manager (ncm) service IPC wrapper.
##  @author Adubbz & zhuowei
##  @copyright libnx Authors
##

import
  ../types, ../services/ncm_types, ../services/fs, ../sf/service

## / ContentStorage

type
  NcmContentStorage* {.bycopy.} = object
    s*: Service                ## /< IContentStorage


## / ContentMetaDatabase

type
  NcmContentMetaDatabase* {.bycopy.} = object
    s*: Service                ## /< IContentMetaDatabase


## / RightsId

type
  NcmRightsId* {.bycopy.} = object
    rightsId*: FsRightsId
    keyGeneration*: U8         ## /< [3.0.0+]
    pad*: array[7, U8]          ## /< [3.0.0+]



proc ncmInitialize*(): Result {.cdecl, importc: "ncmInitialize".}
## / Initialize ncm.

proc ncmExit*() {.cdecl, importc: "ncmExit".}
## / Exit ncm.

proc ncmGetServiceSession*(): ptr Service {.cdecl, importc: "ncmGetServiceSession".}
## / Gets the Service object for the actual ncm service session.

proc ncmCreateContentStorage*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmCreateContentStorage".}
proc ncmCreateContentMetaDatabase*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmCreateContentMetaDatabase".}
proc ncmVerifyContentStorage*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmVerifyContentStorage".}
proc ncmVerifyContentMetaDatabase*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmVerifyContentMetaDatabase".}
proc ncmOpenContentStorage*(outContentStorage: ptr NcmContentStorage;
                           storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmOpenContentStorage".}
proc ncmOpenContentMetaDatabase*(outContentMetaDatabase: ptr NcmContentMetaDatabase;
                                storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmOpenContentMetaDatabase".}
proc ncmCloseContentStorageForcibly*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmCloseContentStorageForcibly".}
## /< [1.0.0]

proc ncmCloseContentMetaDatabaseForcibly*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmCloseContentMetaDatabaseForcibly".}
## /< [1.0.0]

proc ncmCleanupContentMetaDatabase*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmCleanupContentMetaDatabase".}
proc ncmActivateContentStorage*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmActivateContentStorage".}
## /< [2.0.0+]

proc ncmInactivateContentStorage*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmInactivateContentStorage".}
## /< [2.0.0+]

proc ncmActivateContentMetaDatabase*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmActivateContentMetaDatabase".}
## /< [2.0.0+]

proc ncmInactivateContentMetaDatabase*(storageId: NcmStorageId): Result {.cdecl,
    importc: "ncmInactivateContentMetaDatabase".}
## /< [2.0.0+]

proc ncmInvalidateRightsIdCache*(): Result {.cdecl,
    importc: "ncmInvalidateRightsIdCache".}
## /< [9.0.0+]

proc ncmContentStorageClose*(cs: ptr NcmContentStorage) {.cdecl,
    importc: "ncmContentStorageClose".}
proc ncmContentStorageGeneratePlaceHolderId*(cs: ptr NcmContentStorage;
    outId: ptr NcmPlaceHolderId): Result {.cdecl, importc: "ncmContentStorageGeneratePlaceHolderId".}
proc ncmContentStorageCreatePlaceHolder*(cs: ptr NcmContentStorage;
                                        contentId: ptr NcmContentId;
                                        placeholderId: ptr NcmPlaceHolderId;
                                        size: S64): Result {.cdecl,
    importc: "ncmContentStorageCreatePlaceHolder".}
proc ncmContentStorageDeletePlaceHolder*(cs: ptr NcmContentStorage;
                                        placeholderId: ptr NcmPlaceHolderId): Result {.
    cdecl, importc: "ncmContentStorageDeletePlaceHolder".}
proc ncmContentStorageHasPlaceHolder*(cs: ptr NcmContentStorage; `out`: ptr bool;
                                     placeholderId: ptr NcmPlaceHolderId): Result {.
    cdecl, importc: "ncmContentStorageHasPlaceHolder".}
proc ncmContentStorageWritePlaceHolder*(cs: ptr NcmContentStorage;
                                       placeholderId: ptr NcmPlaceHolderId;
                                       offset: U64; data: pointer; dataSize: csize_t): Result {.
    cdecl, importc: "ncmContentStorageWritePlaceHolder".}
proc ncmContentStorageRegister*(cs: ptr NcmContentStorage;
                               contentId: ptr NcmContentId;
                               placeholderId: ptr NcmPlaceHolderId): Result {.cdecl,
    importc: "ncmContentStorageRegister".}
proc ncmContentStorageDelete*(cs: ptr NcmContentStorage; contentId: ptr NcmContentId): Result {.
    cdecl, importc: "ncmContentStorageDelete".}
proc ncmContentStorageHas*(cs: ptr NcmContentStorage; `out`: ptr bool;
                          contentId: ptr NcmContentId): Result {.cdecl,
    importc: "ncmContentStorageHas".}
proc ncmContentStorageGetPath*(cs: ptr NcmContentStorage; outPath: cstring;
                              outSize: csize_t; contentId: ptr NcmContentId): Result {.
    cdecl, importc: "ncmContentStorageGetPath".}
proc ncmContentStorageGetPlaceHolderPath*(cs: ptr NcmContentStorage;
    outPath: cstring; outSize: csize_t; placeholderId: ptr NcmPlaceHolderId): Result {.
    cdecl, importc: "ncmContentStorageGetPlaceHolderPath".}
proc ncmContentStorageCleanupAllPlaceHolder*(cs: ptr NcmContentStorage): Result {.
    cdecl, importc: "ncmContentStorageCleanupAllPlaceHolder".}
proc ncmContentStorageListPlaceHolder*(cs: ptr NcmContentStorage;
                                      outIds: ptr NcmPlaceHolderId; count: S32;
                                      outCount: ptr S32): Result {.cdecl,
    importc: "ncmContentStorageListPlaceHolder".}
proc ncmContentStorageGetContentCount*(cs: ptr NcmContentStorage; outCount: ptr S32): Result {.
    cdecl, importc: "ncmContentStorageGetContentCount".}
proc ncmContentStorageListContentId*(cs: ptr NcmContentStorage;
                                    outIds: ptr NcmContentId; count: S32;
                                    outCount: ptr S32; startOffset: S32): Result {.
    cdecl, importc: "ncmContentStorageListContentId".}
proc ncmContentStorageGetSizeFromContentId*(cs: ptr NcmContentStorage;
    outSize: ptr S64; contentId: ptr NcmContentId): Result {.cdecl,
    importc: "ncmContentStorageGetSizeFromContentId".}
proc ncmContentStorageDisableForcibly*(cs: ptr NcmContentStorage): Result {.cdecl,
    importc: "ncmContentStorageDisableForcibly".}
proc ncmContentStorageRevertToPlaceHolder*(cs: ptr NcmContentStorage;
    placeholderId: ptr NcmPlaceHolderId; oldContentId: ptr NcmContentId;
    newContentId: ptr NcmContentId): Result {.cdecl,
    importc: "ncmContentStorageRevertToPlaceHolder".}
## /< [2.0.0+]

proc ncmContentStorageSetPlaceHolderSize*(cs: ptr NcmContentStorage;
    placeholderId: ptr NcmPlaceHolderId; size: S64): Result {.cdecl,
    importc: "ncmContentStorageSetPlaceHolderSize".}
## /< [2.0.0+]

proc ncmContentStorageReadContentIdFile*(cs: ptr NcmContentStorage;
                                        outData: pointer; outDataSize: csize_t;
                                        contentId: ptr NcmContentId; offset: S64): Result {.
    cdecl, importc: "ncmContentStorageReadContentIdFile".}
## /< [2.0.0+]

proc ncmContentStorageGetRightsIdFromPlaceHolderId*(cs: ptr NcmContentStorage;
    outRightsId: ptr NcmRightsId; placeholderId: ptr NcmPlaceHolderId): Result {.cdecl,
    importc: "ncmContentStorageGetRightsIdFromPlaceHolderId".}
## /< [2.0.0+]

proc ncmContentStorageGetRightsIdFromContentId*(cs: ptr NcmContentStorage;
    outRightsId: ptr NcmRightsId; contentId: ptr NcmContentId): Result {.cdecl,
    importc: "ncmContentStorageGetRightsIdFromContentId".}
## /< [2.0.0+]

proc ncmContentStorageWriteContentForDebug*(cs: ptr NcmContentStorage;
    contentId: ptr NcmContentId; offset: S64; data: pointer; dataSize: csize_t): Result {.
    cdecl, importc: "ncmContentStorageWriteContentForDebug".}
## /< [2.0.0+]

proc ncmContentStorageGetFreeSpaceSize*(cs: ptr NcmContentStorage; outSize: ptr S64): Result {.
    cdecl, importc: "ncmContentStorageGetFreeSpaceSize".}
## /< [2.0.0+]

proc ncmContentStorageGetTotalSpaceSize*(cs: ptr NcmContentStorage; outSize: ptr S64): Result {.
    cdecl, importc: "ncmContentStorageGetTotalSpaceSize".}
## /< [2.0.0+]

proc ncmContentStorageFlushPlaceHolder*(cs: ptr NcmContentStorage): Result {.cdecl,
    importc: "ncmContentStorageFlushPlaceHolder".}
## /< [3.0.0+]

proc ncmContentStorageGetSizeFromPlaceHolderId*(cs: ptr NcmContentStorage;
    outSize: ptr S64; placeholderId: ptr NcmPlaceHolderId): Result {.cdecl,
    importc: "ncmContentStorageGetSizeFromPlaceHolderId".}
## /< [4.0.0+]

proc ncmContentStorageRepairInvalidFileAttribute*(cs: ptr NcmContentStorage): Result {.
    cdecl, importc: "ncmContentStorageRepairInvalidFileAttribute".}
## /< [4.0.0+]

proc ncmContentStorageGetRightsIdFromPlaceHolderIdWithCache*(
    cs: ptr NcmContentStorage; outRightsId: ptr NcmRightsId;
    placeholderId: ptr NcmPlaceHolderId; cacheContentId: ptr NcmContentId): Result {.
    cdecl, importc: "ncmContentStorageGetRightsIdFromPlaceHolderIdWithCache".}
## /< [8.0.0+]

proc ncmContentStorageRegisterPath*(cs: ptr NcmContentStorage;
                                   contentId: ptr NcmContentId; path: cstring): Result {.
    cdecl, importc: "ncmContentStorageRegisterPath".}
## /< [13.0.0+]

proc ncmContentStorageClearRegisteredPath*(cs: ptr NcmContentStorage): Result {.
    cdecl, importc: "ncmContentStorageClearRegisteredPath".}
## /< [13.0.0+]

proc ncmContentMetaDatabaseClose*(db: ptr NcmContentMetaDatabase) {.cdecl,
    importc: "ncmContentMetaDatabaseClose".}
proc ncmContentMetaDatabaseSet*(db: ptr NcmContentMetaDatabase;
                               key: ptr NcmContentMetaKey; data: pointer;
                               dataSize: U64): Result {.cdecl,
    importc: "ncmContentMetaDatabaseSet".}
proc ncmContentMetaDatabaseGet*(db: ptr NcmContentMetaDatabase;
                               key: ptr NcmContentMetaKey; outSize: ptr U64;
                               outData: pointer; outDataSize: U64): Result {.cdecl,
    importc: "ncmContentMetaDatabaseGet".}
proc ncmContentMetaDatabaseRemove*(db: ptr NcmContentMetaDatabase;
                                  key: ptr NcmContentMetaKey): Result {.cdecl,
    importc: "ncmContentMetaDatabaseRemove".}
proc ncmContentMetaDatabaseGetContentIdByType*(db: ptr NcmContentMetaDatabase;
    outContentId: ptr NcmContentId; key: ptr NcmContentMetaKey; `type`: NcmContentType): Result {.
    cdecl, importc: "ncmContentMetaDatabaseGetContentIdByType".}
proc ncmContentMetaDatabaseListContentInfo*(db: ptr NcmContentMetaDatabase;
    outEntriesWritten: ptr S32; outInfo: ptr NcmContentInfo; count: S32;
    key: ptr NcmContentMetaKey; startIndex: S32): Result {.cdecl,
    importc: "ncmContentMetaDatabaseListContentInfo".}
proc ncmContentMetaDatabaseList*(db: ptr NcmContentMetaDatabase;
                                outEntriesTotal: ptr S32;
                                outEntriesWritten: ptr S32;
                                outKeys: ptr NcmContentMetaKey; count: S32;
                                metaType: NcmContentMetaType; id: U64; idMin: U64;
                                idMax: U64; installType: NcmContentInstallType): Result {.
    cdecl, importc: "ncmContentMetaDatabaseList".}
proc ncmContentMetaDatabaseGetLatestContentMetaKey*(
    db: ptr NcmContentMetaDatabase; outKey: ptr NcmContentMetaKey; id: U64): Result {.
    cdecl, importc: "ncmContentMetaDatabaseGetLatestContentMetaKey".}
proc ncmContentMetaDatabaseListApplication*(db: ptr NcmContentMetaDatabase;
    outEntriesTotal: ptr S32; outEntriesWritten: ptr S32;
    outKeys: ptr NcmApplicationContentMetaKey; count: S32;
    metaType: NcmContentMetaType): Result {.cdecl,
    importc: "ncmContentMetaDatabaseListApplication".}
proc ncmContentMetaDatabaseHas*(db: ptr NcmContentMetaDatabase; `out`: ptr bool;
                               key: ptr NcmContentMetaKey): Result {.cdecl,
    importc: "ncmContentMetaDatabaseHas".}
proc ncmContentMetaDatabaseHasAll*(db: ptr NcmContentMetaDatabase; `out`: ptr bool;
                                  keys: ptr NcmContentMetaKey; count: S32): Result {.
    cdecl, importc: "ncmContentMetaDatabaseHasAll".}
proc ncmContentMetaDatabaseGetSize*(db: ptr NcmContentMetaDatabase;
                                   outSize: ptr U64; key: ptr NcmContentMetaKey): Result {.
    cdecl, importc: "ncmContentMetaDatabaseGetSize".}
proc ncmContentMetaDatabaseGetRequiredSystemVersion*(
    db: ptr NcmContentMetaDatabase; outVersion: ptr U32; key: ptr NcmContentMetaKey): Result {.
    cdecl, importc: "ncmContentMetaDatabaseGetRequiredSystemVersion".}
proc ncmContentMetaDatabaseGetPatchId*(db: ptr NcmContentMetaDatabase;
                                      outPatchId: ptr U64;
                                      key: ptr NcmContentMetaKey): Result {.cdecl,
    importc: "ncmContentMetaDatabaseGetPatchId".}
proc ncmContentMetaDatabaseDisableForcibly*(db: ptr NcmContentMetaDatabase): Result {.
    cdecl, importc: "ncmContentMetaDatabaseDisableForcibly".}
proc ncmContentMetaDatabaseLookupOrphanContent*(db: ptr NcmContentMetaDatabase;
    outOrphaned: ptr bool; contentIds: ptr NcmContentId; count: S32): Result {.cdecl,
    importc: "ncmContentMetaDatabaseLookupOrphanContent".}
proc ncmContentMetaDatabaseCommit*(db: ptr NcmContentMetaDatabase): Result {.cdecl,
    importc: "ncmContentMetaDatabaseCommit".}
proc ncmContentMetaDatabaseHasContent*(db: ptr NcmContentMetaDatabase;
                                      `out`: ptr bool; key: ptr NcmContentMetaKey;
                                      contentId: ptr NcmContentId): Result {.cdecl,
    importc: "ncmContentMetaDatabaseHasContent".}
proc ncmContentMetaDatabaseListContentMetaInfo*(db: ptr NcmContentMetaDatabase;
    outEntriesWritten: ptr S32; outMetaInfo: pointer; count: S32;
    key: ptr NcmContentMetaKey; startIndex: S32): Result {.cdecl,
    importc: "ncmContentMetaDatabaseListContentMetaInfo".}
proc ncmContentMetaDatabaseGetAttributes*(db: ptr NcmContentMetaDatabase;
    key: ptr NcmContentMetaKey; `out`: ptr U8): Result {.cdecl,
    importc: "ncmContentMetaDatabaseGetAttributes".}
proc ncmContentMetaDatabaseGetRequiredApplicationVersion*(
    db: ptr NcmContentMetaDatabase; outVersion: ptr U32; key: ptr NcmContentMetaKey): Result {.
    cdecl, importc: "ncmContentMetaDatabaseGetRequiredApplicationVersion".}
## /< [2.0.0+]

proc ncmContentMetaDatabaseGetContentIdByTypeAndIdOffset*(
    db: ptr NcmContentMetaDatabase; outContentId: ptr NcmContentId;
    key: ptr NcmContentMetaKey; `type`: NcmContentType; idOffset: U8): Result {.cdecl,
    importc: "ncmContentMetaDatabaseGetContentIdByTypeAndIdOffset".}
## /< [5.0.0+]
