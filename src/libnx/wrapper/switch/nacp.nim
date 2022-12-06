## *
##  @file nacp.h
##  @brief Control.nacp structure / related code for nacp.
##  @copyright libnx Authors
##

## / Language entry. These strings are UTF-8.
import types

type
  NacpLanguageEntry* {.bycopy.} = object
    name*: array[0x200, char]
    author*: array[0x100, char]


## / ApplicationNeighborDetectionGroupConfiguration

type
  NacpApplicationNeighborDetectionGroupConfiguration* {.bycopy.} = object
    groupId*: U64              ## /< GroupId
    key*: array[0x10, U8]


## / NeighborDetectionClientConfiguration

type
  NacpNeighborDetectionClientConfiguration* {.bycopy.} = object
    sendGroupConfiguration*: NacpApplicationNeighborDetectionGroupConfiguration ## /< SendGroupConfiguration
    receivableGroupConfigurations*: array[0x10,
        NacpApplicationNeighborDetectionGroupConfiguration] ## /< ReceivableGroupConfigurations


## / ApplicationJitConfiguration

type
  NacpApplicationJitConfiguration* {.bycopy.} = object
    flags*: U64                ## /< Flags
    memorySize*: U64           ## /< MemorySize


## / ns ApplicationControlProperty

type
  NacpStruct* {.bycopy.} = object
    lang*: array[16, NacpLanguageEntry] ## /< \ref NacpLanguageEntry
    isbn*: array[0x25, U8]      ## /< Isbn
    startupUserAccount*: U8    ## /< StartupUserAccount
    userAccountSwitchLock*: U8 ## /< UserAccountSwitchLock
    addOnContentRegistrationType*: U8 ## /< AddOnContentRegistrationType
    attributeFlag*: U32        ## /< AttributeFlag
    supportedLanguageFlag*: U32 ## /< SupportedLanguageFlag
    parentalControlFlag*: U32  ## /< ParentalControlFlag
    screenshot*: U8            ## /< Screenshot
    videoCapture*: U8          ## /< VideoCapture
    dataLossConfirmation*: U8  ## /< DataLossConfirmation
    playLogPolicy*: U8         ## /< PlayLogPolicy
    presenceGroupId*: U64      ## /< PresenceGroupId
    ratingAge*: array[0x20, S8] ## /< RatingAge
    displayVersion*: array[0x10, char] ## /< DisplayVersion
    addOnContentBaseId*: U64   ## /< AddOnContentBaseId
    saveDataOwnerId*: U64      ## /< SaveDataOwnerId
    userAccountSaveDataSize*: U64 ## /< UserAccountSaveDataSize
    userAccountSaveDataJournalSize*: U64 ## /< UserAccountSaveDataJournalSize
    deviceSaveDataSize*: U64   ## /< DeviceSaveDataSize
    deviceSaveDataJournalSize*: U64 ## /< DeviceSaveDataJournalSize
    bcatDeliveryCacheStorageSize*: U64 ## /< BcatDeliveryCacheStorageSize
    applicationErrorCodeCategory*: U64 ## /< ApplicationErrorCodeCategory
    localCommunicationId*: array[0x8, U64] ## /< LocalCommunicationId
    logoType*: U8              ## /< LogoType
    logoHandling*: U8          ## /< LogoHandling
    runtimeAddOnContentInstall*: U8 ## /< RuntimeAddOnContentInstall
    runtimeParameterDelivery*: U8 ## /< RuntimeParameterDelivery
    reservedX30f4*: array[0x2, U8] ## /< Reserved
    crashReport*: U8           ## /< CrashReport
    hdcp*: U8                  ## /< Hdcp
    pseudoDeviceIdSeed*: U64   ## /< SeedForPseudoDeviceId
    bcatPassphrase*: array[0x41, char] ## /< BcatPassphrase
    startupUserAccountOption*: U8 ## /< StartupUserAccountOption
    reservedForUserAccountSaveDataOperation*: array[0x6, U8] ## /< ReservedForUserAccountSaveDataOperation
    userAccountSaveDataSizeMax*: U64 ## /< UserAccountSaveDataSizeMax
    userAccountSaveDataJournalSizeMax*: U64 ## /< UserAccountSaveDataJournalSizeMax
    deviceSaveDataSizeMax*: U64 ## /< DeviceSaveDataSizeMax
    deviceSaveDataJournalSizeMax*: U64 ## /< DeviceSaveDataJournalSizeMax
    temporaryStorageSize*: U64 ## /< TemporaryStorageSize
    cacheStorageSize*: U64     ## /< CacheStorageSize
    cacheStorageJournalSize*: U64 ## /< CacheStorageJournalSize
    cacheStorageDataAndJournalSizeMax*: U64 ## /< CacheStorageDataAndJournalSizeMax
    cacheStorageIndexMax*: U16 ## /< CacheStorageIndexMax
    reservedX318a*: array[0x6, U8] ## /< Reserved
    playLogQueryableApplicationId*: array[0x10, U64] ## /< PlayLogQueryableApplicationId
    playLogQueryCapability*: U8 ## /< PlayLogQueryCapability
    repairFlag*: U8            ## /< RepairFlag
    programIndex*: U8          ## /< ProgramIndex
    requiredNetworkServiceLicenseOnLaunch*: U8 ## /< RequiredNetworkServiceLicenseOnLaunchFlag
    reservedX3214*: U32        ## /< Reserved
    neighborDetectionClientConfiguration*: NacpNeighborDetectionClientConfiguration ## /< NeighborDetectionClientConfiguration
    jitConfiguration*: NacpApplicationJitConfiguration ## /< JitConfiguration
    reservedX33c0*: array[0xc40, U8] ## /< Reserved

proc nacpGetLanguageEntry*(nacp: ptr NacpStruct;
                          langentry: ptr ptr NacpLanguageEntry): Result {.cdecl,
    importc: "nacpGetLanguageEntry".}
## / Get the NacpLanguageEntry from the input nacp corresponding to the current system language (this may fallback to other languages when needed). Output langentry is NULL if none found / content of entry is empty.
## / If you're using ns you may want to use \ref nsGetApplicationDesiredLanguage instead.

