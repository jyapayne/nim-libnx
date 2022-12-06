## *
##  @file fs.h
##  @brief Filesystem (fsp-srv) service IPC wrapper.
##  Normally applications should just use standard stdio not FS-serv directly. However this can be used if obtaining a FsFileSystem, FsFile, or FsStorage, for mounting with fs_dev/romfs_dev, etc.
##  @author plutoo
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../services/ncm_types, ../services/acc, ../sf/service

##  We use wrapped handles for type safety.

const
  FS_MAX_PATH* = 0x301

## / For use with \ref FsSaveDataAttribute.

const
  FS_SAVEDATA_CURRENT_APPLICATIONID* = 0

type
  FsRightsId* {.bycopy.} = object
    c*: array[0x10, U8]

  FsFileSystem* {.bycopy.} = object
    s*: Service

  FsFile* {.bycopy.} = object
    s*: Service

  FsDir* {.bycopy.} = object
    s*: Service

  FsStorage* {.bycopy.} = object
    s*: Service

  FsSaveDataInfoReader* {.bycopy.} = object
    s*: Service

  FsEventNotifier* {.bycopy.} = object
    s*: Service

  FsDeviceOperator* {.bycopy.} = object
    s*: Service


## / Directory entry.

type
  FsDirectoryEntry* {.bycopy.} = object
    name*: array[Fs_Max_Path, char] ## /< Entry name.
    pad*: array[3, U8]
    `type`*: S8                ## /< See FsDirEntryType.
    pad2*: array[3, U8]         ## /< ?
    fileSize*: S64             ## /< File size.


## / SaveDataAttribute

type
  FsSaveDataAttribute* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId of the savedata to access when accessing other programs' savedata via SaveData, otherwise FS_SAVEDATA_CURRENT_APPLICATIONID.
    uid*: AccountUid           ## /< \ref AccountUid for the user-specific savedata to access, otherwise 0 for common savedata.
    systemSaveDataId*: U64     ## /< SystemSaveDataId, 0 for ::FsSaveDataType_Account.
    saveDataType*: U8          ## /< \ref FsSaveDataType
    saveDataRank*: U8          ## /< \ref FsSaveDataRank
    saveDataIndex*: U16        ## /< SaveDataIndex
    padX24*: U32               ## /< Padding.
    unkX28*: U64               ## /< 0 for ::FsSaveDataType_System/::FsSaveDataType_Account.
    unkX30*: U64               ## /< 0 for ::FsSaveDataType_System/::FsSaveDataType_Account.
    unkX38*: U64               ## /< 0 for ::FsSaveDataType_System/::FsSaveDataType_Account.


## / SaveDataExtraData

type
  FsSaveDataExtraData* {.bycopy.} = object
    attr*: FsSaveDataAttribute ## /< \ref FsSaveDataAttribute
    ownerId*: U64              ## /< ProgramId of the owner of this save data. 0 for ::FsSaveDataType_System.
    timestamp*: U64            ## /< POSIX timestamp.
    flags*: U32                ## /< \ref FsSaveDataFlags
    unkX54*: U32               ## /< Normally 0. Possibly unused?
    dataSize*: S64             ## /< Usable save data size.
    journalSize*: S64          ## /< Journal size of the save data.
    commitId*: U64             ## /< Id of the latest commit.
    unused*: array[0x190, U8]   ## /< Uninitialized.


## / SaveDataMetaInfo

type
  FsSaveDataMetaInfo* {.bycopy.} = object
    size*: U32
    `type`*: U8                ## /< \ref FsSaveDataMetaType
    reserved*: array[0x0B, U8]


## / SaveDataCreationInfo

type
  FsSaveDataCreationInfo* {.bycopy.} = object
    saveDataSize*: S64         ## /< Size of the save data.
    journalSize*: S64          ## /< Journal size of the save data.
    availableSize*: U64        ## /< AvailableSize
    ownerId*: U64              ## /< ProgramId of the owner of this save data. 0 for ::FsSaveDataType_System.
    flags*: U32                ## /< \ref FsSaveDataFlags
    saveDataSpaceId*: U8       ## /< \ref FsSaveDataSpaceId
    unk*: U8                   ## /< 0 for ::FsSaveDataType_System.
    padding*: array[0x1a, U8]   ## /< Uninitialized for ::FsSaveDataType_System.


## / SaveDataInfo

type
  FsSaveDataInfo* {.bycopy.} = object
    saveDataId*: U64           ## /< SaveDataId
    saveDataSpaceId*: U8       ## /< \ref FsSaveDataSpaceId
    saveDataType*: U8          ## /< \ref FsSaveDataType
    pad*: array[6, U8]          ## /< Padding.
    uid*: AccountUid           ## /< FsSave::userID
    systemSaveDataId*: U64     ## /< FsSaveDataAttribute::system_save_data_id
    applicationId*: U64        ## /< ApplicationId for ::FsSaveDataType_Account.
    size*: U64                 ## /< Raw saveimage size.
    saveDataIndex*: U16        ## /< SaveDataIndex
    saveDataRank*: U8          ## /< \ref FsSaveDataRank
    unkX3b*: array[0x25, U8]    ## /< Unknown. Usually zeros?


## / SaveDataFilter

type
  FsSaveDataFilter* {.bycopy.} = object
    filterByApplicationId*: bool ## /< Filter by \ref FsSaveDataAttribute::application_id
    filterBySaveDataType*: bool ## /< Filter by \ref FsSaveDataAttribute::save_data_type
    filterByUserId*: bool      ## /< Filter by \ref FsSaveDataAttribute::uid
    filterBySystemSaveDataId*: bool ## /< Filter by \ref FsSaveDataAttribute::system_save_data_id
    filterByIndex*: bool       ## /< Filter by \ref FsSaveDataAttribute::save_data_index
    saveDataRank*: U8          ## /< \ref FsSaveDataRank
    padding*: array[0x2, U8]    ## /< Padding
    attr*: FsSaveDataAttribute ## /< \ref FsSaveDataAttribute

  FsTimeStampRaw* {.bycopy.} = object
    created*: U64              ## /< POSIX timestamp.
    modified*: U64             ## /< POSIX timestamp.
    accessed*: U64             ## /< POSIX timestamp.
    isValid*: U8               ## /< 0x1 when the timestamps are set.
    padding*: array[7, U8]


## / This is nn::fssystem::ArchiveMacKey. Used by \ref setsysGetThemeKey and \ref setsysSetThemeKey. Does not appear to be in use elsewhere.

type
  FsArchiveMacKey* {.bycopy.} = object
    key*: array[0x10, U8]


## / Returned by fsFsGetEntryType.

type
  FsDirEntryType* = enum
    FsDirEntryTypeDir = 0,      ## /< Entry is a directory.
    FsDirEntryTypeFile = 1      ## /< Entry is a file.


## / For use with fsFsOpenFile.

type
  FsOpenMode* = enum
    FsOpenModeRead = bit(0),    ## /< Open for reading.
    FsOpenModeWrite = bit(1),   ## /< Open for writing.
    FsOpenModeAppend = bit(2)   ## /< Append file.


## / For use with fsFsCreateFile.

type
  FsCreateOption* = enum
    FsCreateOptionBigFile = bit(0) ## /< Creates a ConcatenationFile (dir with archive bit) instead of file.


## / For use with fsFsOpenDirectory.

type
  FsDirOpenMode* = enum
    FsDirOpenModeReadDirs = bit(0), ## /< Enable reading directory entries.
    FsDirOpenModeReadFiles = bit(1), ## /< Enable reading file entries.
    FsDirOpenModeNoFileSize = bit(31) ## /< Causes result entries to not contain filesize information (always 0).


## / For use with fsFileRead.

type
  FsReadOption* = enum
    FsReadOptionNone = 0        ## /< No option.


## / For use with fsFileWrite.

type
  FsWriteOption* = enum
    FsWriteOptionNone = 0,      ## /< No option.
    FsWriteOptionFlush = bit(0) ## /< Forces a flush after write.
  FsContentStorageId* = enum
    FsContentStorageIdSystem = 0, FsContentStorageIdUser = 1,
    FsContentStorageIdSdCard = 2
  FsCustomStorageId* = enum
    FsCustomStorageIdSystem = 0, FsCustomStorageIdSdCard = 1




## / ImageDirectoryId

type
  FsImageDirectoryId* = enum
    FsImageDirectoryIdNand = 0, FsImageDirectoryIdSd = 1


## / SaveDataSpaceId

type
  FsSaveDataSpaceId* = enum
    FsSaveDataSpaceIdAll = -1,  ## /< Pseudo value for fsOpenSaveDataInfoReader().
    FsSaveDataSpaceIdSystem = 0, ## /< System
    FsSaveDataSpaceIdUser = 1,  ## /< User
    FsSaveDataSpaceIdSdSystem = 2, ## /< SdSystem
    FsSaveDataSpaceIdTemporary = 3, ## /< [3.0.0+] Temporary
    FsSaveDataSpaceIdSdUser = 4, ## /< [4.0.0+] SdUser
    FsSaveDataSpaceIdProperSystem = 100, ## /< [3.0.0+] ProperSystem
    FsSaveDataSpaceIdSafeMode = 101 ## /< [3.0.0+] SafeMode


## / SaveDataType

type
  FsSaveDataType* = enum
    FsSaveDataTypeSystem = 0,   ## /< System
    FsSaveDataTypeAccount = 1,  ## /< Account
    FsSaveDataTypeBcat = 2,     ## /< Bcat
    FsSaveDataTypeDevice = 3,   ## /< Device
    FsSaveDataTypeTemporary = 4, ## /< [3.0.0+] Temporary
    FsSaveDataTypeCache = 5,    ## /< [3.0.0+] Cache
    FsSaveDataTypeSystemBcat = 6 ## /< [4.0.0+] SystemBcat


## / SaveDataRank

type
  FsSaveDataRank* = enum
    FsSaveDataRankPrimary = 0,  ## /< Primary
    FsSaveDataRankSecondary = 1 ## /< Secondary


## / SaveDataFlags

type
  FsSaveDataFlags* = enum
    FsSaveDataFlagsKeepAfterResettingSystemSaveData = bit(0),
    FsSaveDataFlagsKeepAfterRefurbishment = bit(1), FsSaveDataFlagsKeepAfterResettingSystemSaveDataWithoutUserSaveData = bit(
        2), FsSaveDataFlagsNeedsSecureDelete = bit(3)


## / SaveDataMetaType

type
  FsSaveDataMetaType* = enum
    FsSaveDataMetaTypeNone = 0, FsSaveDataMetaTypeThumbnail = 1,
    FsSaveDataMetaTypeExtensionContext = 2
  FsGameCardAttribute* = enum
    FsGameCardAttributeAutoBootFlag = bit(0), ## /< Causes the cartridge to automatically start on bootup
    FsGameCardAttributeHistoryEraseFlag = bit(1), ## /< Causes NS to throw an error on attempt to load the cartridge
    FsGameCardAttributeRepairToolFlag = bit(2), ## /< [4.0.0+] Indicates that this gamecard is a repair tool.
    FsGameCardAttributeDifferentRegionCupToTerraDeviceFlag = bit(3), ## /< [9.0.0+] DifferentRegionCupToTerraDeviceFlag
    FsGameCardAttributeDifferentRegionCupToGlobalDeviceFlag = bit(4) ## /< [9.0.0+] DifferentRegionCupToGlobalDeviceFlag
  FsGameCardPartition* = enum
    FsGameCardPartitionUpdate = 0, FsGameCardPartitionNormal = 1,
    FsGameCardPartitionSecure = 2, FsGameCardPartitionLogo = 3 ## /< [4.0.0+]
  FsGameCardHandle* {.bycopy.} = object
    value*: U32

  FsRangeInfo* {.bycopy.} = object
    aesCtrKeyType*: U32        ## /< Contains bitflags describing how data is AES encrypted.
    speedEmulationType*: U32   ## /< Contains bitflags describing how data is emulated.
    reserved*: array[0x38 div sizeof((U32)), U32]

  FsOperationId* = enum
    FsOperationIdClear,       ## /< Fill range with zero for supported file/storage.
    FsOperationIdClearSignature, ## /< Clears signature for supported file/storage.
    FsOperationIdInvalidateCache, ## /< Invalidates cache for supported file/storage.
    FsOperationIdQueryRange   ## /< Retrieves information on data for supported file/storage.





## / BisPartitionId

type
  FsBisPartitionId* = enum
    FsBisPartitionIdBootPartition1Root = 0,
    FsBisPartitionIdBootPartition2Root = 10, FsBisPartitionIdUserDataRoot = 20,
    FsBisPartitionIdBootConfigAndPackage2Part1 = 21,
    FsBisPartitionIdBootConfigAndPackage2Part2 = 22,
    FsBisPartitionIdBootConfigAndPackage2Part3 = 23,
    FsBisPartitionIdBootConfigAndPackage2Part4 = 24,
    FsBisPartitionIdBootConfigAndPackage2Part5 = 25,
    FsBisPartitionIdBootConfigAndPackage2Part6 = 26,
    FsBisPartitionIdCalibrationBinary = 27, FsBisPartitionIdCalibrationFile = 28,
    FsBisPartitionIdSafeMode = 29, FsBisPartitionIdUser = 30,
    FsBisPartitionIdSystem = 31, FsBisPartitionIdSystemProperEncryption = 32,
    FsBisPartitionIdSystemProperPartition = 33,
    FsBisPartitionIdSignedSystemPartitionOnSafeMode = 34


## / FileSystemType

type
  FsFileSystemType* = enum
    FsFileSystemTypeLogo = 2,   ## /< Logo
    FsFileSystemTypeContentControl = 3, ## /< ContentControl
    FsFileSystemTypeContentManual = 4, ## /< ContentManual
    FsFileSystemTypeContentMeta = 5, ## /< ContentMeta
    FsFileSystemTypeContentData = 6, ## /< ContentData
    FsFileSystemTypeApplicationPackage = 7, ## /< ApplicationPackage
    FsFileSystemTypeRegisteredUpdate = 8 ## /< [4.0.0+] RegisteredUpdate


## / FileSystemQueryId

type
  FsFileSystemQueryId* = enum
    FsFileSystemQueryIdSetConcatenationFileAttribute = 0, ## /< [4.0.0+]
    FsFileSystemQueryIdIsValidSignedSystemPartitionOnSdCard = 2 ## /< [8.0.0+]


## / FsPriority

type
  FsPriority* = enum
    FsPriorityNormal = 0, FsPriorityRealtime = 1, FsPriorityLow = 2,
    FsPriorityBackground = 3


## / For use with fsOpenHostFileSystemWithOption

type
  FsMountHostOption* = enum
    FsMountHostOptionFlagNone = 0, ## /< Host filesystem will be case insensitive.
    FsMountHostOptionFlagPseudoCaseSensitive = bit(0) ## /< Host filesystem will be pseudo case sensitive.

proc fsInitialize*(): Result {.cdecl, importc: "fsInitialize".}
## / Initialize fsp-srv. Used automatically during app startup.
proc fsExit*() {.cdecl, importc: "fsExit".}
## / Exit fsp-srv. Used automatically during app exit.
proc fsGetServiceSession*(): ptr Service {.cdecl, importc: "fsGetServiceSession".}
## / Gets the Service object for the actual fsp-srv service session.
proc fsSetPriority*(prio: FsPriority) {.cdecl, importc: "fsSetPriority".}
## / [5.0.0+] Configures the \ref FsPriority of all filesystem commands issued within the current thread.
proc fsOpenFileSystem*(`out`: ptr FsFileSystem; fsType: FsFileSystemType;
                      contentPath: cstring): Result {.cdecl,
    importc: "fsOpenFileSystem".}
## / Mount requested filesystem type from content file
proc fsOpenDataFileSystemByCurrentProcess*(`out`: ptr FsFileSystem): Result {.cdecl,
    importc: "fsOpenDataFileSystemByCurrentProcess".}

proc fsOpenFileSystemWithPatch*(`out`: ptr FsFileSystem; id: U64;
                               fsType: FsFileSystemType): Result {.cdecl,
    importc: "fsOpenFileSystemWithPatch".}
## /< same as calling fsOpenFileSystemWithId with 0 as id

proc fsOpenFileSystemWithId*(`out`: ptr FsFileSystem; id: U64;
                            fsType: FsFileSystemType; contentPath: cstring): Result {.
    cdecl, importc: "fsOpenFileSystemWithId".}
## /< [2.0.0+], like OpenFileSystemWithId but without content path.

proc fsOpenDataFileSystemByProgramId*(`out`: ptr FsFileSystem; programId: U64): Result {.
    cdecl, importc: "fsOpenDataFileSystemByProgramId".}
## /< works on all firmwares, id is ignored on [1.0.0]

proc fsOpenBisFileSystem*(`out`: ptr FsFileSystem; partitionId: FsBisPartitionId;
                         string: cstring): Result {.cdecl,
    importc: "fsOpenBisFileSystem".}
## /< [3.0.0+]
proc fsOpenBisStorage*(`out`: ptr FsStorage; partitionId: FsBisPartitionId): Result {.
    cdecl, importc: "fsOpenBisStorage".}

proc fsOpenSdCardFileSystem*(`out`: ptr FsFileSystem): Result {.cdecl,
    importc: "fsOpenSdCardFileSystem".}
## / Do not call this directly, see fs_dev.h.
proc fsOpenHostFileSystem*(`out`: ptr FsFileSystem; path: cstring): Result {.cdecl,
    importc: "fsOpenHostFileSystem".}
proc fsOpenHostFileSystemWithOption*(`out`: ptr FsFileSystem; path: cstring;
                                    flags: U32): Result {.cdecl,
    importc: "fsOpenHostFileSystemWithOption".}

proc fsDeleteSaveDataFileSystem*(applicationId: U64): Result {.cdecl,
    importc: "fsDeleteSaveDataFileSystem".}
## /< [9.0.0+]
proc fsCreateSaveDataFileSystem*(attr: ptr FsSaveDataAttribute;
                                creationInfo: ptr FsSaveDataCreationInfo;
                                meta: ptr FsSaveDataMetaInfo): Result {.cdecl,
    importc: "fsCreateSaveDataFileSystem".}
proc fsCreateSaveDataFileSystemBySystemSaveDataId*(attr: ptr FsSaveDataAttribute;
    creationInfo: ptr FsSaveDataCreationInfo): Result {.cdecl,
    importc: "fsCreateSaveDataFileSystemBySystemSaveDataId".}
proc fsDeleteSaveDataFileSystemBySaveDataSpaceId*(
    saveDataSpaceId: FsSaveDataSpaceId; saveID: U64): Result {.cdecl,
    importc: "fsDeleteSaveDataFileSystemBySaveDataSpaceId".}

proc fsDeleteSaveDataFileSystemBySaveDataAttribute*(
    saveDataSpaceId: FsSaveDataSpaceId; attr: ptr FsSaveDataAttribute): Result {.
    cdecl, importc: "fsDeleteSaveDataFileSystemBySaveDataAttribute".}
## /< [2.0.0+]

proc fsIsExFatSupported*(`out`: ptr bool): Result {.cdecl,
    importc: "fsIsExFatSupported".}
## /< [4.0.0+]
proc fsOpenGameCardFileSystem*(`out`: ptr FsFileSystem;
                              handle: ptr FsGameCardHandle;
                              partition: FsGameCardPartition): Result {.cdecl,
    importc: "fsOpenGameCardFileSystem".}
proc fsExtendSaveDataFileSystem*(saveDataSpaceId: FsSaveDataSpaceId; saveID: U64;
                                dataSize: S64; journalSize: S64): Result {.cdecl,
    importc: "fsExtendSaveDataFileSystem".}

proc fsOpenSaveDataFileSystem*(`out`: ptr FsFileSystem;
                              saveDataSpaceId: FsSaveDataSpaceId;
                              attr: ptr FsSaveDataAttribute): Result {.cdecl,
    importc: "fsOpenSaveDataFileSystem".}
## /< [3.0.0+]
proc fsOpenSaveDataFileSystemBySystemSaveDataId*(`out`: ptr FsFileSystem;
    saveDataSpaceId: FsSaveDataSpaceId; attr: ptr FsSaveDataAttribute): Result {.
    cdecl, importc: "fsOpenSaveDataFileSystemBySystemSaveDataId".}
proc fsOpenReadOnlySaveDataFileSystem*(`out`: ptr FsFileSystem;
                                      saveDataSpaceId: FsSaveDataSpaceId;
                                      attr: ptr FsSaveDataAttribute): Result {.
    cdecl, importc: "fsOpenReadOnlySaveDataFileSystem".}

proc fsReadSaveDataFileSystemExtraDataBySaveDataSpaceId*(buf: pointer;
    len: csize_t; saveDataSpaceId: FsSaveDataSpaceId; saveID: U64): Result {.cdecl,
    importc: "fsReadSaveDataFileSystemExtraDataBySaveDataSpaceId".}
## /< [2.0.0+].
proc fsReadSaveDataFileSystemExtraData*(buf: pointer; len: csize_t; saveID: U64): Result {.
    cdecl, importc: "fsReadSaveDataFileSystemExtraData".}
proc fsWriteSaveDataFileSystemExtraData*(buf: pointer; len: csize_t;
                                        saveDataSpaceId: FsSaveDataSpaceId;
                                        saveID: U64): Result {.cdecl,
    importc: "fsWriteSaveDataFileSystemExtraData".}
proc fsOpenSaveDataInfoReader*(`out`: ptr FsSaveDataInfoReader;
                              saveDataSpaceId: FsSaveDataSpaceId): Result {.cdecl,
    importc: "fsOpenSaveDataInfoReader".}
proc fsOpenSaveDataInfoReaderWithFilter*(`out`: ptr FsSaveDataInfoReader;
                                        saveDataSpaceId: FsSaveDataSpaceId;
                                        saveDataFilter: ptr FsSaveDataFilter): Result {.
    cdecl, importc: "fsOpenSaveDataInfoReaderWithFilter".}

proc fsOpenImageDirectoryFileSystem*(`out`: ptr FsFileSystem;
                                    imageDirectoryId: FsImageDirectoryId): Result {.
    cdecl, importc: "fsOpenImageDirectoryFileSystem".}
## /< [6.0.0+]
proc fsOpenContentStorageFileSystem*(`out`: ptr FsFileSystem;
                                    contentStorageId: FsContentStorageId): Result {.
    cdecl, importc: "fsOpenContentStorageFileSystem".}
proc fsOpenCustomStorageFileSystem*(`out`: ptr FsFileSystem;
                                   customStorageId: FsCustomStorageId): Result {.
    cdecl, importc: "fsOpenCustomStorageFileSystem".}

proc fsOpenDataStorageByCurrentProcess*(`out`: ptr FsStorage): Result {.cdecl,
    importc: "fsOpenDataStorageByCurrentProcess".}
## /< [7.0.0+]
proc fsOpenDataStorageByProgramId*(`out`: ptr FsStorage; programId: U64): Result {.
    cdecl, importc: "fsOpenDataStorageByProgramId".}

proc fsOpenDataStorageByDataId*(`out`: ptr FsStorage; dataId: U64;
                               storageId: NcmStorageId): Result {.cdecl,
    importc: "fsOpenDataStorageByDataId".}
## / <[3.0.0+]
proc fsOpenPatchDataStorageByCurrentProcess*(`out`: ptr FsStorage): Result {.cdecl,
    importc: "fsOpenPatchDataStorageByCurrentProcess".}
proc fsOpenDeviceOperator*(`out`: ptr FsDeviceOperator): Result {.cdecl,
    importc: "fsOpenDeviceOperator".}
proc fsOpenSdCardDetectionEventNotifier*(`out`: ptr FsEventNotifier): Result {.cdecl,
    importc: "fsOpenSdCardDetectionEventNotifier".}
proc fsIsSignedSystemPartitionOnSdCardValid*(`out`: ptr bool): Result {.cdecl,
    importc: "fsIsSignedSystemPartitionOnSdCardValid".}

proc fsGetRightsIdByPath*(path: cstring; outRightsId: ptr FsRightsId): Result {.cdecl,
    importc: "fsGetRightsIdByPath".}
## / Retrieves the rights id corresponding to the content path. Only available on [2.0.0+].

proc fsGetRightsIdAndKeyGenerationByPath*(path: cstring; outKeyGeneration: ptr U8;
    outRightsId: ptr FsRightsId): Result {.cdecl, importc: "fsGetRightsIdAndKeyGenerationByPath".}
## / Retrieves the rights id and key generation corresponding to the content path. Only available on [3.0.0+].
proc fsDisableAutoSaveDataCreation*(): Result {.cdecl,
    importc: "fsDisableAutoSaveDataCreation".}
proc fsSetGlobalAccessLogMode*(mode: U32): Result {.cdecl,
    importc: "fsSetGlobalAccessLogMode".}
proc fsGetGlobalAccessLogMode*(outMode: ptr U32): Result {.cdecl,
    importc: "fsGetGlobalAccessLogMode".}
proc fsOutputAccessLogToSdCard*(log: cstring; size: csize_t): Result {.cdecl,
    importc: "fsOutputAccessLogToSdCard".}

proc fsGetProgramIndexForAccessLog*(outProgramIndex: ptr U32;
                                   outProgramCount: ptr U32): Result {.cdecl,
    importc: "fsGetProgramIndexForAccessLog".}
## / Only available on [7.0.0+].

proc fsCreateTemporaryStorage*(applicationId: U64; ownerId: U64; size: S64; flags: U32): Result {.
    cdecl, importc: "fsCreate_TemporaryStorage".}
##  Wrapper(s) for fsCreateSaveDataFileSystem.

proc fsCreateSystemSaveDataWithOwner*(saveDataSpaceId: FsSaveDataSpaceId;
                                     systemSaveDataId: U64; uid: AccountUid;
                                     ownerId: U64; size: S64; journalSize: S64;
                                     flags: U32): Result {.cdecl,
    importc: "fsCreate_SystemSaveDataWithOwner".}
##  Wrapper(s) for fsCreateSaveDataFileSystemBySystemSaveDataId.
proc fsCreateSystemSaveData*(saveDataSpaceId: FsSaveDataSpaceId;
                            systemSaveDataId: U64; size: S64; journalSize: S64;
                            flags: U32): Result {.cdecl,
    importc: "fsCreate_SystemSaveData".}

proc fsOpenSaveData*(`out`: ptr FsFileSystem; applicationId: U64; uid: AccountUid): Result {.
    cdecl, importc: "fsOpen_SaveData".}
## / Wrapper for fsOpenSaveDataFileSystem.
## / See \ref FsSaveDataAttribute for application_id and uid.

proc fsOpenSaveDataReadOnly*(`out`: ptr FsFileSystem; applicationId: U64;
                            uid: AccountUid): Result {.cdecl,
    importc: "fsOpen_SaveDataReadOnly".}
## / Wrapper for fsOpenReadOnlySaveDataFileSystem.
## / Only available on [2.0.0+].
## / See \ref FsSaveDataAttribute for application_id and uid.

proc fsOpenBcatSaveData*(`out`: ptr FsFileSystem; applicationId: U64): Result {.cdecl,
    importc: "fsOpen_BcatSaveData".}
## / Wrapper for fsOpenSaveDataFileSystem, for opening BcatSaveData.

proc fsOpenDeviceSaveData*(`out`: ptr FsFileSystem; applicationId: U64): Result {.
    cdecl, importc: "fsOpen_DeviceSaveData".}
## / Wrapper for fsOpenSaveDataFileSystem, for opening DeviceSaveData.
## / See \ref FsSaveDataAttribute for application_id.

proc fsOpenTemporaryStorage*(`out`: ptr FsFileSystem): Result {.cdecl,
    importc: "fsOpen_TemporaryStorage".}
## / Wrapper for fsOpenSaveDataFileSystem, for opening TemporaryStorage.
## / Only available on [3.0.0+].

proc fsOpenCacheStorage*(`out`: ptr FsFileSystem; applicationId: U64;
                        saveDataIndex: U16): Result {.cdecl,
    importc: "fsOpen_CacheStorage".}
## / Wrapper for fsOpenSaveDataFileSystem, for opening CacheStorage.
## / Only available on [3.0.0+].
## / See \ref FsSaveDataAttribute for application_id.

proc fsOpenSystemSaveData*(`out`: ptr FsFileSystem;
                          saveDataSpaceId: FsSaveDataSpaceId;
                          systemSaveDataId: U64; uid: AccountUid): Result {.cdecl,
    importc: "fsOpen_SystemSaveData".}
## / Wrapper for fsOpenSaveDataFileSystemBySystemSaveDataId, for opening SystemSaveData.
## / WARNING: You can brick when writing to SystemSaveData, if the data is corrupted etc.

proc fsOpenSystemBcatSaveData*(`out`: ptr FsFileSystem; systemSaveDataId: U64): Result {.
    cdecl, importc: "fsOpen_SystemBcatSaveData".}
## / Wrapper for fsOpenSaveDataFileSystemBySystemSaveDataId, for opening SystemBcatSaveData.
## / Only available on [4.0.0+].

##  IFileSystem

proc fsFsCreateFile*(fs: ptr FsFileSystem; path: cstring; size: S64; option: U32): Result {.
    cdecl, importc: "fsFsCreateFile".}
proc fsFsDeleteFile*(fs: ptr FsFileSystem; path: cstring): Result {.cdecl,
    importc: "fsFsDeleteFile".}
proc fsFsCreateDirectory*(fs: ptr FsFileSystem; path: cstring): Result {.cdecl,
    importc: "fsFsCreateDirectory".}
proc fsFsDeleteDirectory*(fs: ptr FsFileSystem; path: cstring): Result {.cdecl,
    importc: "fsFsDeleteDirectory".}
proc fsFsDeleteDirectoryRecursively*(fs: ptr FsFileSystem; path: cstring): Result {.
    cdecl, importc: "fsFsDeleteDirectoryRecursively".}
proc fsFsRenameFile*(fs: ptr FsFileSystem; curPath: cstring; newPath: cstring): Result {.
    cdecl, importc: "fsFsRenameFile".}
proc fsFsRenameDirectory*(fs: ptr FsFileSystem; curPath: cstring; newPath: cstring): Result {.
    cdecl, importc: "fsFsRenameDirectory".}
proc fsFsGetEntryType*(fs: ptr FsFileSystem; path: cstring; `out`: ptr FsDirEntryType): Result {.
    cdecl, importc: "fsFsGetEntryType".}
proc fsFsOpenFile*(fs: ptr FsFileSystem; path: cstring; mode: U32; `out`: ptr FsFile): Result {.
    cdecl, importc: "fsFsOpenFile".}
proc fsFsOpenDirectory*(fs: ptr FsFileSystem; path: cstring; mode: U32; `out`: ptr FsDir): Result {.
    cdecl, importc: "fsFsOpenDirectory".}
proc fsFsCommit*(fs: ptr FsFileSystem): Result {.cdecl, importc: "fsFsCommit".}
proc fsFsGetFreeSpace*(fs: ptr FsFileSystem; path: cstring; `out`: ptr S64): Result {.
    cdecl, importc: "fsFsGetFreeSpace".}
proc fsFsGetTotalSpace*(fs: ptr FsFileSystem; path: cstring; `out`: ptr S64): Result {.
    cdecl, importc: "fsFsGetTotalSpace".}
proc fsFsGetFileTimeStampRaw*(fs: ptr FsFileSystem; path: cstring;
                             `out`: ptr FsTimeStampRaw): Result {.cdecl,
    importc: "fsFsGetFileTimeStampRaw".}
## /< [3.0.0+]

proc fsFsCleanDirectoryRecursively*(fs: ptr FsFileSystem; path: cstring): Result {.
    cdecl, importc: "fsFsCleanDirectoryRecursively".}
## /< [3.0.0+]

proc fsFsQueryEntry*(fs: ptr FsFileSystem; `out`: pointer; outSize: csize_t;
                    `in`: pointer; inSize: csize_t; path: cstring;
                    queryId: FsFileSystemQueryId): Result {.cdecl,
    importc: "fsFsQueryEntry".}
## /< [4.0.0+]

proc fsFsClose*(fs: ptr FsFileSystem) {.cdecl, importc: "fsFsClose".}

proc fsFsSetConcatenationFileAttribute*(fs: ptr FsFileSystem; path: cstring): Result {.
    cdecl, importc: "fsFsSetConcatenationFileAttribute".}
## / Uses \ref fsFsQueryEntry to set the archive bit on the specified absolute directory path.
## / This will cause HOS to treat the directory as if it were a file containing the directory's concatenated contents.

proc fsFsIsValidSignedSystemPartitionOnSdCard*(fs: ptr FsFileSystem; `out`: ptr bool): Result {.
    cdecl, importc: "fsFsIsValidSignedSystemPartitionOnSdCard".}
## / Wrapper for fsFsQueryEntry with FsFileSystemQueryId_IsValidSignedSystemPartitionOnSdCard.
## / Only available on [8.0.0+].

##  IFile

proc fsFileRead*(f: ptr FsFile; off: S64; buf: pointer; readSize: U64; option: U32;
                bytesRead: ptr U64): Result {.cdecl, importc: "fsFileRead".}
proc fsFileWrite*(f: ptr FsFile; off: S64; buf: pointer; writeSize: U64; option: U32): Result {.
    cdecl, importc: "fsFileWrite".}
proc fsFileFlush*(f: ptr FsFile): Result {.cdecl, importc: "fsFileFlush".}
proc fsFileSetSize*(f: ptr FsFile; sz: S64): Result {.cdecl, importc: "fsFileSetSize".}
proc fsFileGetSize*(f: ptr FsFile; `out`: ptr S64): Result {.cdecl,
    importc: "fsFileGetSize".}
proc fsFileOperateRange*(f: ptr FsFile; opId: FsOperationId; off: S64; len: S64;
                        `out`: ptr FsRangeInfo): Result {.cdecl,
    importc: "fsFileOperateRange".}

proc fsFileClose*(f: ptr FsFile) {.cdecl, importc: "fsFileClose".}
## /< [4.0.0+]

##  IDirectory

proc fsDirRead*(d: ptr FsDir; totalEntries: ptr S64; maxEntries: csize_t;
               buf: ptr FsDirectoryEntry): Result {.cdecl, importc: "fsDirRead".}
proc fsDirGetEntryCount*(d: ptr FsDir; count: ptr S64): Result {.cdecl,
    importc: "fsDirGetEntryCount".}
proc fsDirClose*(d: ptr FsDir) {.cdecl, importc: "fsDirClose".}

##  IStorage

proc fsStorageRead*(s: ptr FsStorage; off: S64; buf: pointer; readSize: U64): Result {.
    cdecl, importc: "fsStorageRead".}
proc fsStorageWrite*(s: ptr FsStorage; off: S64; buf: pointer; writeSize: U64): Result {.
    cdecl, importc: "fsStorageWrite".}
proc fsStorageFlush*(s: ptr FsStorage): Result {.cdecl, importc: "fsStorageFlush".}
proc fsStorageSetSize*(s: ptr FsStorage; sz: S64): Result {.cdecl,
    importc: "fsStorageSetSize".}
proc fsStorageGetSize*(s: ptr FsStorage; `out`: ptr S64): Result {.cdecl,
    importc: "fsStorageGetSize".}
proc fsStorageOperateRange*(s: ptr FsStorage; opId: FsOperationId; off: S64; len: S64;
                           `out`: ptr FsRangeInfo): Result {.cdecl,
    importc: "fsStorageOperateRange".}

proc fsStorageClose*(s: ptr FsStorage) {.cdecl, importc: "fsStorageClose".}
## /< [4.0.0+]

##  ISaveDataInfoReader

proc fsSaveDataInfoReaderRead*(s: ptr FsSaveDataInfoReader; buf: ptr FsSaveDataInfo;
                              maxEntries: csize_t; totalEntries: ptr S64): Result {.
    cdecl, importc: "fsSaveDataInfoReaderRead".}
## / Read FsSaveDataInfo data into the buf array.

proc fsSaveDataInfoReaderClose*(s: ptr FsSaveDataInfoReader) {.cdecl,
    importc: "fsSaveDataInfoReaderClose".}

##  IEventNotifier

proc fsEventNotifierGetEventHandle*(e: ptr FsEventNotifier; `out`: ptr Event;
                                   autoclear: bool): Result {.cdecl,
    importc: "fsEventNotifierGetEventHandle".}
proc fsEventNotifierClose*(e: ptr FsEventNotifier) {.cdecl,
    importc: "fsEventNotifierClose".}

##  IDeviceOperator

proc fsDeviceOperatorIsSdCardInserted*(d: ptr FsDeviceOperator; `out`: ptr bool): Result {.
    cdecl, importc: "fsDeviceOperatorIsSdCardInserted".}
proc fsDeviceOperatorIsGameCardInserted*(d: ptr FsDeviceOperator; `out`: ptr bool): Result {.
    cdecl, importc: "fsDeviceOperatorIsGameCardInserted".}
proc fsDeviceOperatorGetGameCardHandle*(d: ptr FsDeviceOperator;
                                       `out`: ptr FsGameCardHandle): Result {.cdecl,
    importc: "fsDeviceOperatorGetGameCardHandle".}
proc fsDeviceOperatorGetGameCardAttribute*(d: ptr FsDeviceOperator;
    handle: ptr FsGameCardHandle; `out`: ptr U8): Result {.cdecl,
    importc: "fsDeviceOperatorGetGameCardAttribute".}
proc fsDeviceOperatorClose*(d: ptr FsDeviceOperator) {.cdecl,
    importc: "fsDeviceOperatorClose".}
