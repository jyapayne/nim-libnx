## *
##  @file ns.h
##  @brief NS services IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../nacp, ../sf/service, ../services/ncm_types, ../services/async,
  ../services/acc, ../services/fs, ../applets/error, ../kernel/event, ../kernel/tmem

## / ShellEvent

type
  NsShellEvent* = enum
    NsShellEventNone = 0,       ## /< None
    NsShellEventExit = 1,       ## /< Exit
    NsShellEventStart = 2,      ## /< Start
    NsShellEventCrash = 3,      ## /< Crash
    NsShellEventDebug = 4       ## /< Debug


## / ApplicationControlSource

type
  NsApplicationControlSource* = enum
    NsApplicationControlSourceCacheOnly = 0, ## /< Returns data from cache.
    NsApplicationControlSourceStorage = 1, ## /< Returns data from storage if not present in cache.
    NsApplicationControlSourceStorageOnly = 2 ## /< Returns data from storage without using cache.


## / BackgroundNetworkUpdateState

type
  NsBackgroundNetworkUpdateState* = enum
    NsBackgroundNetworkUpdateStateNone = 0, ## /< No sysupdate task exists.
    NsBackgroundNetworkUpdateStateDownloading = 1, ## /< Sysupdate download in progress.
    NsBackgroundNetworkUpdateStateReady = 2 ## /< Sysupdate ready, pending install.


## / LatestSystemUpdate

type
  NsLatestSystemUpdate* = enum
    NsLatestSystemUpdateUnknown0 = 0, ## /< Unknown.
    NsLatestSystemUpdateUnknown1 = 1, ## /< Unknown.
    NsLatestSystemUpdateUnknown2 = 2 ## /< Unknown.


## / RequestServerStopper

type
  NsRequestServerStopper* {.bycopy.} = object
    s*: Service                ## /< IRequestServerStopper


## / ProgressMonitorForDeleteUserSaveDataAll

type
  NsProgressMonitorForDeleteUserSaveDataAll* {.bycopy.} = object
    s*: Service                ## /< IProgressMonitorForDeleteUserSaveDataAll


## / ProgressAsyncResult

type
  NsProgressAsyncResult* {.bycopy.} = object
    s*: Service                ## /< IProgressAsyncResult
    event*: Event              ## /< Event with autoclear=false.


## / SystemUpdateControl

type
  NsSystemUpdateControl* {.bycopy.} = object
    s*: Service                ## /< ISystemUpdateControl
    tmem*: TransferMemory      ## /< TransferMemory for SetupCardUpdate/SetupCardUpdateViaSystemUpdater.


## / ApplicationControlData

type
  NsApplicationControlData* {.bycopy.} = object
    nacp*: NacpStruct          ## /< \ref NacpStruct
    icon*: array[0x20000, U8]   ## /< JPEG


## / ApplicationOccupiedSize

type
  NsApplicationOccupiedSize* {.bycopy.} = object
    unkX0*: array[0x80, U8]     ## /< Unknown.


## / NsApplicationContentMetaStatus

type
  NsApplicationContentMetaStatus* {.bycopy.} = object
    metaType*: U8              ## /< \ref NcmContentMetaType
    storageID*: U8             ## /< \ref NcmStorageId
    unkX02*: U8                ## /< Unknown.
    padding*: U8               ## /< Padding.
    version*: U32              ## /< Application version.
    applicationId*: U64        ## /< ApplicationId.


## / ApplicationRecord

type
  NsApplicationRecord* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId.
    `type`*: U8                ## /< Type.
    unkX09*: U8                ## /< Unknown.
    unkX0a*: array[6, U8]       ## /< Unknown.
    unkX10*: U8                ## /< Unknown.
    unkX11*: array[7, U8]       ## /< Unknown.


## / ProgressForDeleteUserSaveDataAll

type
  NsProgressForDeleteUserSaveDataAll* {.bycopy.} = object
    unkX0*: array[0x28, U8]     ## /< Unknown.


## / ApplicationViewDeprecated. The below comments are for the \ref NsApplicationView to NsApplicationViewDeprecated conversion done by \ref nsGetApplicationViewDeprecated on newer system-versions.

type
  NsApplicationViewDeprecated* {.bycopy.} = object
    applicationId*: U64        ## /< Same as NsApplicationView::application_id.
    unkX8*: array[0x4, U8]      ## /< Same as NsApplicationView::unk_x8.
    flags*: U32                ## /< Same as NsApplicationView::flags.
    unkX10*: array[0x10, U8]    ## /< Same as NsApplicationView::unk_x10.
    unkX20*: U32               ## /< Same as NsApplicationView::unk_x20.
    unkX24*: U16               ## /< Same as NsApplicationView::unk_x24.
    unkX26*: array[0x2, U8]     ## /< Cleared to zero.
    unkX28*: array[0x10, U8]    ## /< Same as NsApplicationView::unk_x30.
    unkX38*: U32               ## /< Same as NsApplicationView::unk_x40.
    unkX3c*: U8                ## /< Same as NsApplicationView::unk_x44.
    unkX3d*: array[3, U8]       ## /< Cleared to zero.


## / ApplicationView

type
  NsApplicationView* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId.
    unkX8*: array[0x4, U8]      ## /< Unknown.
    flags*: U32                ## /< Flags.
    unkX10*: array[0x10, U8]    ## /< Unknown.
    unkX20*: U32               ## /< Unknown.
    unkX24*: U16               ## /< Unknown.
    unkX26*: array[0x2, U8]     ## /< Unknown.
    unkX28*: array[0x8, U8]     ## /< Unknown.
    unkX30*: array[0x10, U8]    ## /< Unknown.
    unkX40*: U32               ## /< Unknown.
    unkX44*: U8                ## /< Unknown.
    unkX45*: array[0xb, U8]     ## /< Unknown.


## / NsPromotionInfo

type
  NsPromotionInfo* {.bycopy.} = object
    startTimestamp*: U64       ## /< POSIX timestamp for the promotion start.
    endTimestamp*: U64         ## /< POSIX timestamp for the promotion end.
    remainingTime*: S64        ## /< Remaining time until the promotion ends, in nanoseconds ({end_timestamp - current_time} converted to nanoseconds).
    unkX18*: array[0x4, U8]     ## /< Not set, left at zero.
    flags*: U8                 ## /< Flags. Bit0: whether the PromotionInfo is valid (including bit1). Bit1 clear: remaining_time is set.
    pad*: array[3, U8]          ## /< Padding.


## / NsApplicationViewWithPromotionInfo

type
  NsApplicationViewWithPromotionInfo* {.bycopy.} = object
    view*: NsApplicationView   ## /< \ref NsApplicationView
    promotion*: NsPromotionInfo ## /< \ref NsPromotionInfo


## / LaunchProperties

type
  NsLaunchProperties* {.bycopy.} = object
    programId*: U64            ## /< program_id.
    version*: U32              ## /< Program version.
    storageID*: U8             ## /< \ref NcmStorageId
    index*: U8                 ## /< Index.
    isApplication*: U8         ## /< Whether this is an Application.


## / ShellEventInfo

type
  NsShellEventInfo* {.bycopy.} = object
    event*: NsShellEvent       ## /< \ref NsShellEvent
    processId*: U64            ## /< processID.


## / SystemUpdateProgress. Commands which have this as output will return 0 with the output cleared, when no task is available.

type
  NsSystemUpdateProgress* {.bycopy.} = object
    currentSize*: S64          ## /< Current size. This value can be larger than total_size when the async operation is finishing. When total_size is <=0, this current_size field may contain a progress value for when the total_size is not yet determined.
    totalSize*: S64            ## /< Total size, this field is only valid when >0.


## / ReceiveApplicationProgress. Same as \ref NsSystemUpdateProgress, except cmds which return this will return actual errors on failure, instead of returning 0 with a cleared struct.

type
  NsReceiveApplicationProgress* = NsSystemUpdateProgress

## / SendApplicationProgress. Same as \ref NsSystemUpdateProgress, except cmds which return this will return actual errors on failure, instead of returning 0 with a cleared struct.

type
  NsSendApplicationProgress* = NsSystemUpdateProgress

## / EulaDataPath

type
  NsEulaDataPath* {.bycopy.} = object
    path*: array[0x100, char]   ## /< Path.


## / SystemDeliveryInfo

type
  INNER_C_STRUCT_ns_1* {.bycopy.} = object
    systemDeliveryProtocolVersion*: U32 ## /< Must match a system-setting.
    applicationDeliveryProtocolVersion*: U32 ## /< Loaded from a system-setting. Unused by \ref nssuRequestSendSystemUpdate / \ref nssuControlRequestReceiveSystemUpdate, besides HMAC validation.
    includesExfat*: U32        ## /< Whether ExFat is included. Unused by \ref nssuRequestSendSystemUpdate / \ref nssuControlRequestReceiveSystemUpdate, besides HMAC validation.
    systemUpdateMetaVersion*: U32 ## /< SystemUpdate meta version.
    systemUpdateMetaId*: U64   ## /< SystemUpdate meta Id.
    unkX18*: U8                ## /< Copied into state by \ref nssuRequestSendSystemUpdate.
    unkX19*: U8                ## /< Unused by \ref nssuRequestSendSystemUpdate / \ref nssuControlRequestReceiveSystemUpdate, besides HMAC validation.
    unkX1a*: U8                ## /< Unknown.
    unkX1b*: array[0xc5, U8]    ## /< Unused by \ref nssuRequestSendSystemUpdate / \ref nssuControlRequestReceiveSystemUpdate, besides HMAC validation.

  NsSystemDeliveryInfo* {.bycopy.} = object
    data*: INNER_C_STRUCT_ns_1 ## /< Data used with the below hmac.
    hmac*: array[0x20, U8]      ## /< HMAC-SHA256 over the above data.


## / ApplicationDeliveryInfo

type
  INNER_C_STRUCT_ns_3* {.bycopy.} = object
    unkX0*: array[0x10, U8]     ## /< Unknown.
    applicationVersion*: U32   ## /< Application version.
    unkX14*: U32               ## /< Unknown.
    requiredSystemVersion*: U32 ## /< Required system version, see NsSystemDeliveryInfo::system_update_meta_version.
    unkX1c*: U32               ## /< Unknown.
    unkX20*: array[0xc0, U8]    ## /< Unknown.

  NsApplicationDeliveryInfo* {.bycopy.} = object
    data*: INNER_C_STRUCT_ns_3 ## /< Data used with the below hmac.
    hmac*: array[0x20, U8]      ## /< HMAC-SHA256 over the above data.


## / NsApplicationRightsOnClient

type
  NsApplicationRightsOnClient* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId.
    uid*: AccountUid           ## /< \ref AccountUid
    flagsX18*: U8              ## /< qlaunch uses bit0-bit4 and bit7 from here.
    flagsX19*: U8              ## /< qlaunch uses bit0 from here.
    unkX1a*: array[0x6, U8]     ## /< Unknown.


## / DownloadTaskStatus

type
  NsDownloadTaskStatus* {.bycopy.} = object
    unkX0*: array[0x20, U8]     ## /< Unknown.


## / Default size for \ref nssuControlSetupCardUpdate / \ref nssuControlSetupCardUpdateViaSystemUpdater. This is the size used by qlaunch for SetupCardUpdate.

const
  NSSU_CARDUPDATE_TMEM_SIZE_DEFAULT* = 0x100000
proc nsInitialize*(): Result {.cdecl, importc: "nsInitialize".}
## /@name ns
## /@{
## / Initialize ns services. Uses ns:am on pre-3.0.0, ns:am2 on [3.0.0+].

proc nsExit*() {.cdecl, importc: "nsExit".}
## / Exit ns services.

proc nsGetServiceSessionGetterInterface*(): ptr Service {.cdecl,
    importc: "nsGetServiceSession_GetterInterface".}
## / Gets the Service object for the actual ns:* service session. Only initialized on [3.0.0+], on pre-3.0.0 see \ref nsGetServiceSession_ApplicationManagerInterface.

proc nsGetServiceSessionApplicationManagerInterface*(): ptr Service {.cdecl,
    importc: "nsGetServiceSession_ApplicationManagerInterface".}
## / Gets the Service object for IApplicationManagerInterface. Only initialized on pre-3.0.0, on [3.0.0+] use \ref nsGetApplicationManagerInterface.

proc nsGetDynamicRightsInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetDynamicRightsInterface".}
## / Gets the Service object for IDynamicRightsInterface via the cmd for that.
## / Only available on [6.0.0+].

proc nsGetReadOnlyApplicationControlDataInterface*(srvOut: ptr Service): Result {.
    cdecl, importc: "nsGetReadOnlyApplicationControlDataInterface".}
## / Gets the Service object for IReadOnlyApplicationControlDataInterface via the cmd for that.
## / Only available on [5.1.0+].

proc nsGetReadOnlyApplicationRecordInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetReadOnlyApplicationRecordInterface".}
## / Gets the Service object for IReadOnlyApplicationRecordInterface via the cmd for that.
## / Only available on [5.0.0+].

proc nsGetECommerceInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetECommerceInterface".}
## / Gets the Service object for IECommerceInterface via the cmd for that.
## / Only available on [4.0.0+].

proc nsGetApplicationVersionInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetApplicationVersionInterface".}
## / Gets the Service object for IApplicationVersionInterface via the cmd for that.
## / Only available on [4.0.0+].

proc nsGetFactoryResetInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetFactoryResetInterface".}
## / Gets the Service object for IFactoryResetInterface via the cmd for that.
## / Only available on [3.0.0+].

proc nsGetAccountProxyInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetAccountProxyInterface".}
## / Gets the Service object for IAccountProxyInterface via the cmd for that.
## / Only available on [3.0.0+].

proc nsGetApplicationManagerInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetApplicationManagerInterface".}
## / Gets the Service object for IApplicationManagerInterface via the cmd for that.
## / Only available on [3.0.0+], on prior sysvers use \ref nsGetServiceSession_ApplicationManagerInterface.

proc nsGetDownloadTaskInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetDownloadTaskInterface".}
## / Gets the Service object for IDownloadTaskInterface via the cmd for that.
## / Only available on [3.0.0+].

proc nsGetContentManagementInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetContentManagementInterface".}
## / Gets the Service object for IContentManagementInterface via the cmd for that.
## / Only available on [3.0.0+].

proc nsGetDocumentInterface*(srvOut: ptr Service): Result {.cdecl,
    importc: "nsGetDocumentInterface".}
## / Gets the Service object for IDocumentInterface via the cmd for that.
## / Only available on [3.0.0+].

proc nsGetApplicationControlData*(source: NsApplicationControlSource;
                                 applicationId: U64;
                                 buffer: ptr NsApplicationControlData;
                                 size: csize_t; actualSize: ptr U64): Result {.cdecl,
    importc: "nsGetApplicationControlData".}
## /@}
## /@name IReadOnlyApplicationControlDataInterface
## /@{
## *
##  @brief Gets the \ref NsApplicationControlData for the specified application.
##  @note Uses \ref nsGetReadOnlyApplicationControlDataInterface on [5.1.0+], otherwise IApplicationManagerInterface is used.
##  @param[in] source Source, official sw uses ::NsApplicationControlSource_Storage.
##  @param[in] application_id ApplicationId.
##  @param[out] buffer \ref NsApplicationControlData
##  @param[in] size Size of the buffer.
##  @param[out] actual_size Actual output size.
##

proc nsGetApplicationDesiredLanguage*(nacp: ptr NacpStruct;
                                     langentry: ptr ptr NacpLanguageEntry): Result {.
    cdecl, importc: "nsGetApplicationDesiredLanguage".}
## *
##  @brief GetApplicationDesiredLanguage. Selects a \ref NacpLanguageEntry to use from the specified \ref NacpStruct.
##  @note Uses \ref nsGetReadOnlyApplicationControlDataInterface on [5.1.0+], otherwise IApplicationManagerInterface is used.
##  @param[in] nacp \ref NacpStruct
##  @param[out] langentry \ref NacpLanguageEntry
##

proc nsRequestLinkDevice*(a: ptr AsyncResult; uid: AccountUid): Result {.cdecl,
    importc: "nsRequestLinkDevice".}
## /@}
## /@name IECommerceInterface
## /@{
## *
##  @brief RequestLinkDevice
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @note Only available on [4.0.0+].
##  @param[out] a \ref AsyncResult
##  @param[in] uid \ref AccountUid
##

proc nsRequestSyncRights*(a: ptr AsyncResult): Result {.cdecl,
    importc: "nsRequestSyncRights".}
## *
##  @brief RequestSyncRights
##  @note Only available on [6.0.0+].
##  @param[out] a \ref AsyncResult
##

proc nsRequestUnlinkDevice*(a: ptr AsyncResult; uid: AccountUid): Result {.cdecl,
    importc: "nsRequestUnlinkDevice".}
## *
##  @brief RequestUnlinkDevice
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @note Only available on [6.0.0+].
##  @param[out] a \ref AsyncResult
##  @param[in] uid \ref AccountUid
##

proc nsResetToFactorySettings*(): Result {.cdecl,
                                        importc: "nsResetToFactorySettings".}
## /@}
## /@name IFactoryResetInterface
## /@{
## *
##  @brief ResetToFactorySettings
##  @note Uses \ref nsGetFactoryResetInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##

proc nsResetToFactorySettingsWithoutUserSaveData*(): Result {.cdecl,
    importc: "nsResetToFactorySettingsWithoutUserSaveData".}
## *
##  @brief ResetToFactorySettingsWithoutUserSaveData
##  @note Uses \ref nsGetFactoryResetInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##

proc nsResetToFactorySettingsForRefurbishment*(): Result {.cdecl,
    importc: "nsResetToFactorySettingsForRefurbishment".}
## *
##  @brief ResetToFactorySettingsForRefurbishment
##  @note Uses \ref nsGetFactoryResetInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @note Only available on [2.0.0+].
##

proc nsResetToFactorySettingsWithPlatformRegion*(): Result {.cdecl,
    importc: "nsResetToFactorySettingsWithPlatformRegion".}
## *
##  @brief ResetToFactorySettingsWithPlatformRegion
##  @note Only available on [9.1.0+].
##

proc nsResetToFactorySettingsWithPlatformRegionAuthentication*(): Result {.cdecl,
    importc: "nsResetToFactorySettingsWithPlatformRegionAuthentication".}
## *
##  @brief ResetToFactorySettingsWithPlatformRegionAuthentication
##  @note Only available on [9.1.0+].
##

proc nsListApplicationRecord*(records: ptr NsApplicationRecord; count: S32;
                             entryOffset: S32; outEntrycount: ptr S32): Result {.
    cdecl, importc: "nsListApplicationRecord".}
## /@}
## /@name IApplicationManagerInterface
## /@{
## *
##  @brief Gets an listing of \ref NsApplicationRecord.
##  @param[out] records Output array of \ref NsApplicationRecord.
##  @param[in] count Size of the records array in entries.
##  @param[in] entry_offset Starting entry offset.
##  @param[out] out_entrycount Total output entries.
##

proc nsGetApplicationRecordUpdateSystemEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "nsGetApplicationRecordUpdateSystemEvent".}
## *
##  @brief GetApplicationRecordUpdateSystemEvent
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc nsGetApplicationViewDeprecated*(views: ptr NsApplicationViewDeprecated;
                                    applicationIds: ptr U64; count: S32): Result {.
    cdecl, importc: "nsGetApplicationViewDeprecated".}
## *
##  @brief GetApplicationViewDeprecated
##  @note On [3.0.0+] you should generally use \ref nsGetApplicationView instead.
##  @param[out] out Output array of \ref NsApplicationViewDeprecated.
##  @param[in] application_ids Input array of ApplicationIds.
##  @param[in] count Size of the input/output arrays in entries.
##

proc nsDeleteApplicationEntity*(applicationId: U64): Result {.cdecl,
    importc: "nsDeleteApplicationEntity".}
## *
##  @brief DeleteApplicationEntity
##  @param[in] application_id ApplicationId.
##

proc nsDeleteApplicationCompletely*(applicationId: U64): Result {.cdecl,
    importc: "nsDeleteApplicationCompletely".}
## *
##  @brief DeleteApplicationCompletely
##  @param[in] application_id ApplicationId.
##

proc nsDeleteRedundantApplicationEntity*(): Result {.cdecl,
    importc: "nsDeleteRedundantApplicationEntity".}
## *
##  @brief DeleteRedundantApplicationEntity
##

proc nsIsApplicationEntityMovable*(applicationId: U64; storageId: NcmStorageId;
                                  `out`: ptr bool): Result {.cdecl,
    importc: "nsIsApplicationEntityMovable".}
## *
##  @brief IsApplicationEntityMovable
##  @param[in] application_id ApplicationId.
##  @param[in] storage_id \ref NcmStorageId
##  @param[out] out Output flag.
##

proc nsMoveApplicationEntity*(applicationId: U64; storageId: NcmStorageId): Result {.
    cdecl, importc: "nsMoveApplicationEntity".}
## *
##  @brief MoveApplicationEntity
##  @note Only available on [1.0.0-9.2.0].
##  @param[in] application_id ApplicationId.
##  @param[in] storage_id \ref NcmStorageId
##

proc nsRequestApplicationUpdateInfo*(a: ptr AsyncValue; applicationId: U64): Result {.
    cdecl, importc: "nsRequestApplicationUpdateInfo".}
## *
##  @brief RequestApplicationUpdateInfo
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @param[out] a \ref AsyncValue. The data that can be read from this is u8 ApplicationUpdateInfo. qlaunch just checks whether this is 0.
##  @param application_id ApplicationId.
##

proc nsCancelApplicationDownload*(applicationId: U64): Result {.cdecl,
    importc: "nsCancelApplicationDownload".}
## *
##  @brief CancelApplicationDownload
##  @param[in] application_id ApplicationId.
##

proc nsResumeApplicationDownload*(applicationId: U64): Result {.cdecl,
    importc: "nsResumeApplicationDownload".}
## *
##  @brief ResumeApplicationDownload
##  @param[in] application_id ApplicationId.
##

proc nsCheckApplicationLaunchVersion*(applicationId: U64): Result {.cdecl,
    importc: "nsCheckApplicationLaunchVersion".}
## *
##  @brief CheckApplicationLaunchVersion
##  @param[in] application_id ApplicationId.
##

proc nsCalculateApplicationDownloadRequiredSize*(applicationId: U64;
    storageId: ptr NcmStorageId; size: ptr S64): Result {.cdecl,
    importc: "nsCalculateApplicationDownloadRequiredSize".}
## *
##  @brief CalculateApplicationApplyDeltaRequiredSize
##  @param[in] application_id ApplicationId.
##  @param[out] storage_id Output \ref NcmStorageId.
##  @param[out] size Output size.
##

proc nsCleanupSdCard*(): Result {.cdecl, importc: "nsCleanupSdCard".}
## *
##  @brief CleanupSdCard
##

proc nsGetSdCardMountStatusChangedEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "nsGetSdCardMountStatusChangedEvent".}
## *
##  @brief GetSdCardMountStatusChangedEvent
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc nsGetGameCardUpdateDetectionEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "nsGetGameCardUpdateDetectionEvent".}
## *
##  @brief GetGameCardUpdateDetectionEvent
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc nsDisableApplicationAutoDelete*(applicationId: U64): Result {.cdecl,
    importc: "nsDisableApplicationAutoDelete".}
## *
##  @brief DisableApplicationAutoDelete
##  @param[in] application_id ApplicationId.
##

proc nsEnableApplicationAutoDelete*(applicationId: U64): Result {.cdecl,
    importc: "nsEnableApplicationAutoDelete".}
## *
##  @brief EnableApplicationAutoDelete
##  @param[in] application_id ApplicationId.
##

proc nsSetApplicationTerminateResult*(applicationId: U64; res: Result): Result {.
    cdecl, importc: "nsSetApplicationTerminateResult".}
## *
##  @brief SetApplicationTerminateResult
##  @param[in] application_id ApplicationId.
##  @param[in] res Result.
##

proc nsClearApplicationTerminateResult*(applicationId: U64): Result {.cdecl,
    importc: "nsClearApplicationTerminateResult".}
## *
##  @brief ClearApplicationTerminateResult
##  @param[in] application_id ApplicationId.
##

proc nsGetLastSdCardMountUnexpectedResult*(): Result {.cdecl,
    importc: "nsGetLastSdCardMountUnexpectedResult".}
## *
##  @brief GetLastSdCardMountUnexpectedResult
##

proc nsGetRequestServerStopper*(r: ptr NsRequestServerStopper): Result {.cdecl,
    importc: "nsGetRequestServerStopper".}
## *
##  @brief Opens a \ref NsRequestServerStopper.
##  @note Only available on [2.0.0+].
##  @param[out] r \ref NsRequestServerStopper
##

proc nsCancelApplicationApplyDelta*(applicationId: U64): Result {.cdecl,
    importc: "nsCancelApplicationApplyDelta".}
## *
##  @brief CancelApplicationApplyDelta
##  @note Only available on [3.0.0+].
##  @param[in] application_id ApplicationId.
##

proc nsResumeApplicationApplyDelta*(applicationId: U64): Result {.cdecl,
    importc: "nsResumeApplicationApplyDelta".}
## *
##  @brief ResumeApplicationApplyDelta
##  @note Only available on [3.0.0+].
##  @param[in] application_id ApplicationId.
##

proc nsCalculateApplicationApplyDeltaRequiredSize*(applicationId: U64;
    storageId: ptr NcmStorageId; size: ptr S64): Result {.cdecl,
    importc: "nsCalculateApplicationApplyDeltaRequiredSize".}
## *
##  @brief CalculateApplicationApplyDeltaRequiredSize
##  @note Only available on [3.0.0+].
##  @param[in] application_id ApplicationId.
##  @param[out] storage_id Output \ref NcmStorageId.
##  @param[out] size Output size.
##

proc nsResumeAll*(): Result {.cdecl, importc: "nsResumeAll".}
## *
##  @brief ResumeAll
##  @note Only available on [3.0.0+].
##

proc nsGetStorageSize*(storageId: NcmStorageId; totalSpaceSize: ptr S64;
                      freeSpaceSize: ptr S64): Result {.cdecl,
    importc: "nsGetStorageSize".}
## *
##  @brief Temporarily mounts the specified fs ContentStorage, then uses fs GetTotalSpaceSize/GetFreeSpaceSize with that mounted ContentStorage.
##  @note Only available on [3.0.0+].
##  @param[in] storage_id \ref NcmStorageId, must be ::NcmStorageId_BuiltInUser or ::NcmStorageId_SdCard.
##  @param[out] total_space_size Output from GetTotalSpaceSize.
##  @param[out] free_space_size Output from GetFreeSpaceSize.
##

proc nsRequestUpdateApplication2*(a: ptr AsyncResult; applicationId: U64): Result {.
    cdecl, importc: "nsRequestUpdateApplication2".}
## *
##  @brief RequestUpdateApplication2
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @note Only available on [4.0.0+].
##  @param[out] a \ref AsyncResult
##  @param[in] application_id ApplicationId.
##

proc nsDeleteUserSaveDataAll*(p: ptr NsProgressMonitorForDeleteUserSaveDataAll;
                             uid: AccountUid): Result {.cdecl,
    importc: "nsDeleteUserSaveDataAll".}
## *
##  @brief DeleteUserSaveDataAll
##  @param[in] p \ref NsProgressMonitorForDeleteUserSaveDataAll
##  @param[in] uid \ref AccountUid
##

proc nsDeleteUserSystemSaveData*(uid: AccountUid; systemSaveDataId: U64): Result {.
    cdecl, importc: "nsDeleteUserSystemSaveData".}
## *
##  @brief DeleteUserSystemSaveData
##  @param[in] uid \ref AccountUid
##  @param[in] system_save_data_id SystemSaveDataId
##

proc nsDeleteSaveData*(saveDataSpaceId: FsSaveDataSpaceId; saveDataId: U64): Result {.
    cdecl, importc: "nsDeleteSaveData".}
## *
##  @brief DeleteSaveData
##  @note Only available on [6.0.0+].
##  @param[in] save_data_space_id \ref FsSaveDataSpaceId
##  @param[in] save_data_id SaveDataId
##

proc nsUnregisterNetworkServiceAccount*(uid: AccountUid): Result {.cdecl,
    importc: "nsUnregisterNetworkServiceAccount".}
## *
##  @brief UnregisterNetworkServiceAccount
##  @param[in] uid \ref AccountUid
##

proc nsUnregisterNetworkServiceAccountWithUserSaveDataDeletion*(uid: AccountUid): Result {.
    cdecl, importc: "nsUnregisterNetworkServiceAccountWithUserSaveDataDeletion".}
## *
##  @brief UnregisterNetworkServiceAccountWithUserSaveDataDeletion
##  @note Only available on [6.0.0+].
##  @param[in] uid \ref AccountUid
##

proc nsRequestDownloadApplicationControlData*(a: ptr AsyncResult; applicationId: U64): Result {.
    cdecl, importc: "nsRequestDownloadApplicationControlData".}
## *
##  @brief RequestDownloadApplicationControlData
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @param[out] a \ref AsyncResult
##  @param[in] application_id ApplicationId.
##

proc nsListApplicationTitle*(a: ptr AsyncValue; source: NsApplicationControlSource;
                            applicationIds: ptr U64; count: S32; buffer: pointer;
                            size: csize_t): Result {.cdecl,
    importc: "nsListApplicationTitle".}
## *
##  @brief ListApplicationTitle
##  @note The data available with \ref asyncValueGet is a s32 for the offset within the buffer where the output data is located, \ref asyncValueGetSize returns the total byte-size of the data located here. The data located here is the \ref NacpLanguageEntry for each specified ApplicationId.
##  @note Only available on [8.0.0+].
##  @param[out] a \ref AsyncValue
##  @param[in] source Source, qlaunch uses ::NsApplicationControlSource_Storage.
##  @param[in] application_ids Input array of ApplicationIds.
##  @param[in] count Size of the application_ids array in entries.
##  @param buffer 0x1000-byte aligned buffer for TransferMemory. This buffer must not be accessed until the async operation finishes.
##  @param[in] size 0x1000-byte aligned buffer size for TransferMemory. This must be at least: count*sizeof(\ref NacpLanguageEntry) + count*sizeof(u64) + count*sizeof(\ref NsApplicationControlData).
##

proc nsListApplicationIcon*(a: ptr AsyncValue; source: NsApplicationControlSource;
                           applicationIds: ptr U64; count: S32; buffer: pointer;
                           size: csize_t): Result {.cdecl,
    importc: "nsListApplicationIcon".}
## *
##  @brief ListApplicationIcon
##  @note The data available with \ref asyncValueGet is a s32 for the offset within the buffer where the output data is located, \ref asyncValueGetSize returns the total byte-size of the data located here. This data is: an u64 for total entries, an array of u64s for each icon size, then the icon JPEGs for the specified ApplicationIds.
##  @note Only available on [8.0.0+].
##  @param[out] a \ref AsyncValue
##  @param[in] source Source.
##  @param[in] application_ids Input array of ApplicationIds.
##  @param[in] count Size of the application_ids array in entries.
##  @param buffer 0x1000-byte aligned buffer for TransferMemory. This buffer must not be accessed until the async operation finishes.
##  @param[in] size 0x1000-byte aligned buffer size for TransferMemory. This must be at least: 0x4 + count*sizeof(u64) + count*sizeof(\ref NsApplicationControlData::icon) + count*sizeof(u64) + sizeof(\ref NsApplicationControlData).
##

proc nsRequestCheckGameCardRegistration*(a: ptr AsyncResult; applicationId: U64): Result {.
    cdecl, importc: "nsRequestCheckGameCardRegistration".}
## *
##  @brief RequestCheckGameCardRegistration
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @note Only available on [2.0.0+].
##  @param[out] a \ref AsyncResult
##  @param[in] application_id ApplicationId.
##

proc nsRequestGameCardRegistrationGoldPoint*(a: ptr AsyncValue; uid: AccountUid;
    applicationId: U64): Result {.cdecl, importc: "nsRequestGameCardRegistrationGoldPoint".}
## *
##  @brief RequestGameCardRegistrationGoldPoint
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @note Only available on [2.0.0+].
##  @param[out] a \ref AsyncValue. The data that can be read from this is 4-bytes.
##  @param[in] uid \ref AccountUid
##  @param[in] application_id ApplicationId.
##

proc nsRequestRegisterGameCard*(a: ptr AsyncResult; uid: AccountUid;
                               applicationId: U64; inval: S32): Result {.cdecl,
    importc: "nsRequestRegisterGameCard".}
## *
##  @brief RequestRegisterGameCard
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @note Only available on [2.0.0+].
##  @param[out] a \ref AsyncResult
##  @param[in] uid \ref AccountUid
##  @param[in] application_id ApplicationId.
##  @param[in] inval Input value.
##

proc nsGetGameCardMountFailureEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "nsGetGameCardMountFailureEvent".}
## *
##  @brief GetGameCardMountFailureEvent
##  @note The Event must be closed by the user once finished with it.
##  @note Only available on [3.0.0+].
##  @param[out] out_event Output Event with autoclear=false.
##

proc nsIsGameCardInserted*(`out`: ptr bool): Result {.cdecl,
    importc: "nsIsGameCardInserted".}
## *
##  @brief IsGameCardInserted
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc nsEnsureGameCardAccess*(): Result {.cdecl, importc: "nsEnsureGameCardAccess".}
## *
##  @brief EnsureGameCardAccess
##  @note Only available on [3.0.0+].
##

proc nsGetLastGameCardMountFailureResult*(): Result {.cdecl,
    importc: "nsGetLastGameCardMountFailureResult".}
## *
##  @brief GetLastGameCardMountFailureResult
##  @note Only available on [3.0.0+].
##

proc nsListApplicationIdOnGameCard*(applicationIds: ptr U64; count: S32;
                                   totalOut: ptr S32): Result {.cdecl,
    importc: "nsListApplicationIdOnGameCard".}
## *
##  @brief ListApplicationIdOnGameCard
##  @note Only available on [5.0.0+].
##  @param[out] application_ids Output array of ApplicationIds.
##  @param[in] count Size of the application_ids array in entries.
##  @param[out] total_out Total output entries.
##

proc nsTouchApplication*(applicationId: U64): Result {.cdecl,
    importc: "nsTouchApplication".}
## *
##  @brief TouchApplication
##  @note Only available on [2.0.0+].
##  @param[in] application_id ApplicationId.
##

proc nsIsApplicationUpdateRequested*(applicationId: U64; flag: ptr bool;
                                    `out`: ptr U32): Result {.cdecl,
    importc: "nsIsApplicationUpdateRequested".}
## *
##  @brief IsApplicationUpdateRequested
##  @note Only available on [2.0.0+].
##  @param[in] application_id ApplicationId.
##  @param[out] flag Output flag, indicating whether out is valid.
##  @param[out] out Output value.
##

proc nsWithdrawApplicationUpdateRequest*(applicationId: U64): Result {.cdecl,
    importc: "nsWithdrawApplicationUpdateRequest".}
## *
##  @brief WithdrawApplicationUpdateRequest
##  @note Only available on [2.0.0+].
##  @param[in] application_id ApplicationId.
##

proc nsRequestVerifyAddOnContentsRights*(a: ptr NsProgressAsyncResult;
                                        applicationId: U64): Result {.cdecl,
    importc: "nsRequestVerifyAddOnContentsRights".}
## *
##  @brief RequestVerifyAddOnContentsRights
##  @note Only available on [3.0.0-9.2.0].
##  @param[out] a \ref NsProgressAsyncResult
##  @param[in] application_id ApplicationId.
##

proc nsRequestVerifyApplication*(a: ptr NsProgressAsyncResult; applicationId: U64;
                                unk: U32; buffer: pointer; size: csize_t): Result {.
    cdecl, importc: "nsRequestVerifyApplication".}
## *
##  @brief RequestVerifyApplication
##  @note On pre-5.0.0 this uses cmd RequestVerifyApplicationDeprecated, otherwise cmd RequestVerifyApplication is used.
##  @param[out] a \ref NsProgressAsyncResult. The data available with \ref nsProgressAsyncResultGetProgress is basically the same as \ref NsSystemUpdateProgress.
##  @param[in] application_id ApplicationId.
##  @param[in] unk Unknown. A default value of 0x7 can be used (which is what qlaunch uses). Only used on [5.0.0+].
##  @param buffer 0x1000-byte aligned buffer for TransferMemory. This buffer must not be accessed until the async operation finishes.
##  @param[in] size 0x1000-byte aligned buffer size for TransferMemory. qlaunch uses size 0x100000.
##

proc nsIsAnyApplicationEntityInstalled*(applicationId: U64; `out`: ptr bool): Result {.
    cdecl, importc: "nsIsAnyApplicationEntityInstalled".}
## *
##  @brief IsAnyApplicationEntityInstalled
##  @note Only available on [2.0.0+].
##  @param[in] application_id ApplicationId.
##  @param[out] out Output flag.
##

proc nsCleanupUnavailableAddOnContents*(applicationId: U64; uid: AccountUid): Result {.
    cdecl, importc: "nsCleanupUnavailableAddOnContents".}
## *
##  @brief CleanupUnavailableAddOnContents
##  @note Only available on [6.0.0+].
##  @param[in] application_id ApplicationId.
##  @param[in] uid \ref AccountUid
##

proc nsFormatSdCard*(): Result {.cdecl, importc: "nsFormatSdCard".}
## *
##  @brief FormatSdCard
##  @note Only available on [2.0.0+].
##

proc nsNeedsSystemUpdateToFormatSdCard*(`out`: ptr bool): Result {.cdecl,
    importc: "nsNeedsSystemUpdateToFormatSdCard".}
## *
##  @brief NeedsSystemUpdateToFormatSdCard
##  @note Only available on [2.0.0+].
##  @param[out] out Output flag.
##

proc nsGetLastSdCardFormatUnexpectedResult*(): Result {.cdecl,
    importc: "nsGetLastSdCardFormatUnexpectedResult".}
## *
##  @brief GetLastSdCardFormatUnexpectedResult
##  @note Only available on [2.0.0+].
##

proc nsGetApplicationView*(views: ptr NsApplicationView; applicationIds: ptr U64;
                          count: S32): Result {.cdecl,
    importc: "nsGetApplicationView".}
## *
##  @brief GetApplicationView
##  @note Only available on [3.0.0+], on prior system-versions use \ref nsGetApplicationViewDeprecated instead.
##  @param[out] out Output array of \ref NsApplicationView.
##  @param[in] application_ids Input array of ApplicationIds.
##  @param[in] count Size of the input/output arrays in entries.
##

proc nsGetApplicationViewDownloadErrorContext*(applicationId: U64;
    context: ptr ErrorContext): Result {.cdecl, importc: "nsGetApplicationViewDownloadErrorContext".}
## *
##  @brief GetApplicationViewDownloadErrorContext
##  @note Only available on [4.0.0+].
##  @param[in] application_id ApplicationId
##  @param[out] context \ref ErrorContext
##

proc nsGetApplicationViewWithPromotionInfo*(
    `out`: ptr NsApplicationViewWithPromotionInfo; applicationIds: ptr U64; count: S32): Result {.
    cdecl, importc: "nsGetApplicationViewWithPromotionInfo".}
## *
##  @brief GetApplicationViewWithPromotionInfo
##  @note Only available on [8.0.0+].
##  @param[out] out Output array of \ref NsApplicationViewWithPromotionInfo.
##  @param[in] application_ids Input array of ApplicationIds.
##  @param[in] count Size of the input/output arrays in entries.
##

proc nsRequestDownloadApplicationPrepurchasedRights*(a: ptr AsyncResult;
    applicationId: U64): Result {.cdecl, importc: "nsRequestDownloadApplicationPrepurchasedRights".}
## *
##  @brief RequestDownloadApplicationPrepurchasedRights
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @note Only available on [4.0.0+].
##  @param[out] a \ref AsyncResult
##  @param[in] application_id ApplicationId.
##

proc nsGetSystemDeliveryInfo*(info: ptr NsSystemDeliveryInfo): Result {.cdecl,
    importc: "nsGetSystemDeliveryInfo".}
## *
##  @brief Generates a \ref NsSystemDeliveryInfo using the currently installed SystemUpdate meta.
##  @note Only available on [4.0.0+].
##  @param[out] info \ref NsSystemDeliveryInfo
##

proc nsSelectLatestSystemDeliveryInfo*(sysList: ptr NsSystemDeliveryInfo;
                                      sysCount: S32;
                                      baseInfo: ptr NsSystemDeliveryInfo;
                                      appList: ptr NsApplicationDeliveryInfo;
                                      appCount: S32; index: ptr S32): Result {.cdecl,
    importc: "nsSelectLatestSystemDeliveryInfo".}
## *
##  @brief SelectLatestSystemDeliveryInfo
##  @note This selects the \ref NsSystemDeliveryInfo with the latest version from sys_list, using minimum versions determined from app_list/state and base_info. This also does various validation, etc.
##  @note Only available on [4.0.0+].
##  @param[in] sys_list Input array of \ref NsSystemDeliveryInfo.
##  @param[in] sys_count Size of the sys_list array in entries.
##  @param[in] base_info \ref NsSystemDeliveryInfo
##  @param[in] app_list Input array of \ref NsApplicationDeliveryInfo. This can be NULL.
##  @param[in] app_count Size of the app_list array in entries. This can be 0.
##  @param[out] index Output index for the selected entry in sys_list, -1 if none found.
##

proc nsVerifyDeliveryProtocolVersion*(info: ptr NsSystemDeliveryInfo): Result {.
    cdecl, importc: "nsVerifyDeliveryProtocolVersion".}
## *
##  @brief VerifyDeliveryProtocolVersion
##  @note Only available on [4.0.0+].
##  @param[in] info \ref NsSystemDeliveryInfo
##

proc nsGetApplicationDeliveryInfo*(info: ptr NsApplicationDeliveryInfo; count: S32;
                                  applicationId: U64; attr: U32; totalOut: ptr S32): Result {.
    cdecl, importc: "nsGetApplicationDeliveryInfo".}
## *
##  @brief Generates \ref NsApplicationDeliveryInfo for the specified ApplicationId.
##  @note Only available on [4.0.0+].
##  @param[out] info Output array of \ref NsApplicationDeliveryInfo.
##  @param[in] count Size of the array in entries.
##  @param[in] application_id ApplicationId
##  @param[in] attr ApplicationDeliveryAttributeTag bitmask.
##  @param[out] total_out Total output entries.
##

proc nsHasAllContentsToDeliver*(info: ptr NsApplicationDeliveryInfo; count: S32;
                               `out`: ptr bool): Result {.cdecl,
    importc: "nsHasAllContentsToDeliver".}
## *
##  @brief HasAllContentsToDeliver
##  @note Only available on [4.0.0+].
##  @param[in] info Input array of \ref NsApplicationDeliveryInfo.
##  @param[in] count Size of the array in entries. Must be value 1.
##  @param[out] out Output flag.
##

proc nsCompareApplicationDeliveryInfo*(info0: ptr NsApplicationDeliveryInfo;
                                      count0: S32;
                                      info1: ptr NsApplicationDeliveryInfo;
                                      count1: S32; `out`: ptr S32): Result {.cdecl,
    importc: "nsCompareApplicationDeliveryInfo".}
## *
##  @brief Both \ref NsApplicationDeliveryInfo are validated, then the application_version in the first/second \ref NsApplicationDeliveryInfo are compared.
##  @note Only available on [4.0.0+].
##  @param[in] info0 First input array of \ref NsApplicationDeliveryInfo.
##  @param[in] count0 Size of the info0 array in entries. Must be value 1.
##  @param[in] info1 Second input array of \ref NsApplicationDeliveryInfo.
##  @param[in] count1 Size of the info1 array in entries. Must be value 1.
##  @param[out] out Comparison result: -1 for less than, 0 for equal, and 1 for higher than.
##

proc nsCanDeliverApplication*(info0: ptr NsApplicationDeliveryInfo; count0: S32;
                             info1: ptr NsApplicationDeliveryInfo; count1: S32;
                             `out`: ptr bool): Result {.cdecl,
    importc: "nsCanDeliverApplication".}
## *
##  @brief CanDeliverApplication
##  @note Only available on [4.0.0+].
##  @param[in] info0 First input array of \ref NsApplicationDeliveryInfo.
##  @param[in] count0 Size of the info0 array in entries. Must be value <=1, when 0 this will return 0 with out set to 0.
##  @param[in] info1 Second input array of \ref NsApplicationDeliveryInfo.
##  @param[in] count1 Size of the info1 array in entries. Must be value 1.
##  @param[out] out Output flag.
##

proc nsListContentMetaKeyToDeliverApplication*(meta: ptr NcmContentMetaKey;
    metaCount: S32; metaIndex: S32; info: ptr NsApplicationDeliveryInfo;
    infoCount: S32; totalOut: ptr S32): Result {.cdecl,
    importc: "nsListContentMetaKeyToDeliverApplication".}
## *
##  @brief ListContentMetaKeyToDeliverApplication
##  @note Only available on [4.0.0+].
##  @param[out] meta Output array of \ref NcmContentMetaKey.
##  @param[in] meta_count Size of the meta array in entries. Must be at least 1, only 1 entry will be returned.
##  @param[in] meta_index Meta entry index. An output \ref NcmContentMetaKey will not be returned when this value is larger than 0.
##  @param[in] info Input array of \ref NsApplicationDeliveryInfo.
##  @param[in] info_count Size of the info array in entries. Must be value 1.
##  @param[out] total_out Total output entries.
##

proc nsNeedsSystemUpdateToDeliverApplication*(
    info: ptr NsApplicationDeliveryInfo; count: S32;
    sysInfo: ptr NsSystemDeliveryInfo; `out`: ptr bool): Result {.cdecl,
    importc: "nsNeedsSystemUpdateToDeliverApplication".}
## *
##  @brief After validation etc, this sets the output bool by comparing system-version fields in the \ref NsSystemDeliveryInfo / info-array and with a state field.
##  @note Only available on [4.0.0+].
##  @param[in] info Input array of \ref NsApplicationDeliveryInfo.
##  @param[in] count Size of the info array in entries. Must be value 1.
##  @param[in] sys_info \ref NsSystemDeliveryInfo
##  @param[out] out Output flag.
##

proc nsEstimateRequiredSize*(meta: ptr NcmContentMetaKey; count: S32; `out`: ptr S64): Result {.
    cdecl, importc: "nsEstimateRequiredSize".}
## *
##  @brief EstimateRequiredSize
##  @note Only available on [4.0.0+].
##  @param[in] meta Input array of \ref NcmContentMetaKey.
##  @param[in] count Size of the meta array in entries. When less than 1, this will return 0 with out set to 0.
##  @param[out] out Output size.
##

proc nsRequestReceiveApplication*(a: ptr AsyncResult; `addr`: U32; port: U16;
                                 applicationId: U64; meta: ptr NcmContentMetaKey;
                                 count: S32; storageId: NcmStorageId): Result {.
    cdecl, importc: "nsRequestReceiveApplication".}
## *
##  @brief RequestReceiveApplication
##  @note This is the Application version of \ref nssuControlRequestReceiveSystemUpdate, see the notes for that.
##  @note Only available on [4.0.0+].
##  @param[out] a \ref AsyncResult
##  @param[in] addr Server IPv4 address.
##  @param[in] port Socket port. qlaunch uses value 55556.
##  @param[in] application_id ApplicationId
##  @param[in] meta Input array of \ref NcmContentMetaKey. The ::NcmContentMetaType must match ::NcmContentMetaType_Patch.
##  @param[in] count Size of the meta array in entries.
##  @param[in] storage_id \ref NcmStorageId. qlaunch uses ::NcmStorageId_Any.
##

proc nsCommitReceiveApplication*(applicationId: U64): Result {.cdecl,
    importc: "nsCommitReceiveApplication".}
## *
##  @brief CommitReceiveApplication
##  @note Only available on [4.0.0+].
##  @param[in] application_id ApplicationId
##

proc nsGetReceiveApplicationProgress*(applicationId: U64;
                                     `out`: ptr NsReceiveApplicationProgress): Result {.
    cdecl, importc: "nsGetReceiveApplicationProgress".}
## *
##  @brief GetReceiveApplicationProgress
##  @note Only available on [4.0.0+].
##  @param[in] application_id ApplicationId
##  @param[out] out \ref NsReceiveApplicationProgress
##

proc nsRequestSendApplication*(a: ptr AsyncResult; `addr`: U32; port: U16;
                              applicationId: U64; meta: ptr NcmContentMetaKey;
                              count: S32): Result {.cdecl,
    importc: "nsRequestSendApplication".}
## *
##  @brief RequestSendApplication
##  @note This is the Application version of \ref nssuRequestSendSystemUpdate, see the notes for that.
##  @note Only available on [4.0.0+].
##  @param[out] a \ref AsyncResult
##  @param[in] addr Client IPv4 address.
##  @param[in] port Socket port. qlaunch uses value 55556.
##  @param[in] application_id ApplicationId
##  @param[in] meta Input array of \ref NcmContentMetaKey. The ::NcmContentMetaType must match ::NcmContentMetaType_Patch.
##  @param[in] count Size of the meta array in entries.
##

proc nsGetSendApplicationProgress*(applicationId: U64;
                                  `out`: ptr NsSendApplicationProgress): Result {.
    cdecl, importc: "nsGetSendApplicationProgress".}
## *
##  @brief GetSendApplicationProgress
##  @note Only available on [4.0.0+].
##  @param[in] application_id ApplicationId
##  @param[out] out \ref NsSendApplicationProgress
##

proc nsCompareSystemDeliveryInfo*(info0: ptr NsSystemDeliveryInfo;
                                 info1: ptr NsSystemDeliveryInfo; `out`: ptr S32): Result {.
    cdecl, importc: "nsCompareSystemDeliveryInfo".}
## *
##  @brief Both \ref NsSystemDeliveryInfo are validated, then the system_update_meta_version in the first/second \ref NsSystemDeliveryInfo are compared.
##  @note Only available on [4.0.0+].
##  @param[in] info0 First \ref NsSystemDeliveryInfo.
##  @param[in] info1 Second \ref NsSystemDeliveryInfo.
##  @param[out] out Comparison result: -1 for less than, 0 for equal, and 1 for higher than.
##

proc nsListNotCommittedContentMeta*(meta: ptr NcmContentMetaKey; count: S32;
                                   applicationId: U64; unk: S32; totalOut: ptr S32): Result {.
    cdecl, importc: "nsListNotCommittedContentMeta".}
## *
##  @brief ListNotCommittedContentMeta
##  @note Only available on [4.0.0+].
##  @param[out] meta Output array of \ref NcmContentMetaKey.
##  @param[in] count Size of the meta array in entries.
##  @param[in] application_id ApplicationId
##  @param[in] unk Unknown.
##  @param[out] total_out Total output entries.
##

proc nsGetApplicationDeliveryInfoHash*(info: ptr NsApplicationDeliveryInfo;
                                      count: S32; outHash: ptr U8): Result {.cdecl,
    importc: "nsGetApplicationDeliveryInfoHash".}
## *
##  @brief This extracts data from the input array for hashing with SHA256, with validation being done when handling each entry.
##  @note Only available on [5.0.0+].
##  @param[in] info Input array of \ref NsApplicationDeliveryInfo.
##  @param[in] count Size of the array in entries.
##  @param[out] out_hash Output 0x20-byte SHA256 hash.
##

proc nsGetApplicationTerminateResult*(applicationId: U64; res: ptr Result): Result {.
    cdecl, importc: "nsGetApplicationTerminateResult".}
## *
##  @brief GetApplicationTerminateResult
##  @note Only available on [6.0.0+].
##  @param[in] application_id ApplicationId.
##  @param[out] res Output Result.
##

proc nsGetApplicationRightsOnClient*(rights: ptr NsApplicationRightsOnClient;
                                    count: S32; applicationId: U64; uid: AccountUid;
                                    flags: U32; totalOut: ptr S32): Result {.cdecl,
    importc: "nsGetApplicationRightsOnClient".}
## *
##  @brief GetApplicationRightsOnClient
##  @note Only available on [6.0.0+].
##  @param[out] rights Output array of \ref NsApplicationRightsOnClient.
##  @param[in] count Size of the rights array in entries. qlaunch uses value 3 for this.
##  @param[in] application_id ApplicationId
##  @param[in] uid \ref AccountUid, can optionally be all-zero.
##  @param[in] flags Flags. Official sw hard-codes this to value 0x3.
##  @param[out] total_out Total output entries.
##

proc nsRequestNoDownloadRightsErrorResolution*(a: ptr AsyncValue; applicationId: U64): Result {.
    cdecl, importc: "nsRequestNoDownloadRightsErrorResolution".}
## *
##  @brief RequestNoDownloadRightsErrorResolution
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @note Only available on [9.0.0+].
##  @param[out] a \ref AsyncValue. The data that can be read from this is u8 NoDownloadRightsErrorResolution.
##  @param application_id ApplicationId.
##

proc nsRequestResolveNoDownloadRightsError*(a: ptr AsyncValue; applicationId: U64): Result {.
    cdecl, importc: "nsRequestResolveNoDownloadRightsError".}
## *
##  @brief RequestResolveNoDownloadRightsError
##  @note \ref nifmInitialize must be used prior to this. Before using the cmd, this calls \ref nifmIsAnyInternetRequestAccepted with the output from \ref nifmGetClientId, an error is returned when that returns false.
##  @note Only available on [9.0.0+].
##  @param[out] a \ref AsyncValue. The data that can be read from this is u8 NoDownloadRightsErrorResolution.
##  @param application_id ApplicationId.
##

proc nsGetPromotionInfo*(promotion: ptr NsPromotionInfo; applicationId: U64;
                        uid: AccountUid): Result {.cdecl,
    importc: "nsGetPromotionInfo".}
## *
##  @brief GetPromotionInfo
##  @note Only available on [8.0.0+].
##  @param[out] promotion \ref NsPromotionInfo
##  @param application_id ApplicationId.
##  @param[in] uid \ref AccountUid
##

proc nsClearTaskStatusList*(): Result {.cdecl, importc: "nsClearTaskStatusList".}
## /@}
## /@name IDownloadTaskInterface
## /@{
## *
##  @brief ClearTaskStatusList
##  @note Uses \ref nsGetDownloadTaskInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @note Only available on [2.0.0+].
##

proc nsRequestDownloadTaskList*(): Result {.cdecl,
    importc: "nsRequestDownloadTaskList".}
## *
##  @brief RequestDownloadTaskList
##  @note Uses \ref nsGetDownloadTaskInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @note Only available on [2.0.0+].
##

proc nsRequestEnsureDownloadTask*(a: ptr AsyncResult): Result {.cdecl,
    importc: "nsRequestEnsureDownloadTask".}
## *
##  @brief RequestEnsureDownloadTask
##  @note Uses \ref nsGetDownloadTaskInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @note Only available on [2.0.0+].
##  @param[out] a \ref AsyncResult
##

proc nsListDownloadTaskStatus*(tasks: ptr NsDownloadTaskStatus; count: S32;
                              totalOut: ptr S32): Result {.cdecl,
    importc: "nsListDownloadTaskStatus".}
## *
##  @brief ListDownloadTaskStatus
##  @note Uses \ref nsGetDownloadTaskInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @note Only available on [2.0.0+].
##  @param[out] tasks Output array of \ref NsDownloadTaskStatus.
##  @param[in] count Size of the tasks array in entries. A maximum of 0x100 tasks can be stored in state.
##  @param[out] total_out Total output entries.
##

proc nsRequestDownloadTaskListData*(a: ptr AsyncValue): Result {.cdecl,
    importc: "nsRequestDownloadTaskListData".}
## *
##  @brief RequestDownloadTaskListData
##  @note Uses \ref nsGetDownloadTaskInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @note Only available on [2.0.0+].
##  @param[out] a \ref AsyncValue
##

proc nsTryCommitCurrentApplicationDownloadTask*(): Result {.cdecl,
    importc: "nsTryCommitCurrentApplicationDownloadTask".}
## *
##  @brief TryCommitCurrentApplicationDownloadTask
##  @note Only available on [4.0.0+].
##

proc nsEnableAutoCommit*(): Result {.cdecl, importc: "nsEnableAutoCommit".}
## *
##  @brief EnableAutoCommit
##  @note Only available on [4.0.0+].
##

proc nsDisableAutoCommit*(): Result {.cdecl, importc: "nsDisableAutoCommit".}
## *
##  @brief DisableAutoCommit
##  @note Only available on [4.0.0+].
##

proc nsTriggerDynamicCommitEvent*(): Result {.cdecl,
    importc: "nsTriggerDynamicCommitEvent".}
## *
##  @brief TriggerDynamicCommitEvent
##  @note Only available on [4.0.0+].
##

proc nsCalculateApplicationOccupiedSize*(applicationId: U64;
                                        `out`: ptr NsApplicationOccupiedSize): Result {.
    cdecl, importc: "nsCalculateApplicationOccupiedSize".}
## /@}
## /@name IContentManagementInterface
## /@{
## *
##  @brief CalculateApplicationOccupiedSize
##  @note Uses \ref nsGetContentManagementInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @param[in] application_id ApplicationId.
##  @param[out] out \ref NsApplicationOccupiedSize
##

proc nsCheckSdCardMountStatus*(): Result {.cdecl,
                                        importc: "nsCheckSdCardMountStatus".}
## *
##  @brief CheckSdCardMountStatus
##  @note Uses \ref nsGetContentManagementInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##

proc nsGetTotalSpaceSize*(storageId: NcmStorageId; size: ptr S64): Result {.cdecl,
    importc: "nsGetTotalSpaceSize".}
## *
##  @brief Returns the total storage capacity (used + free) from content manager services.
##  @note Uses \ref nsGetContentManagementInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @param[in] storage_id \ref NcmStorageId. Must be ::NcmStorageId_SdCard.
##  @param[out] size Pointer to output the total storage size to.
##

proc nsGetFreeSpaceSize*(storageId: NcmStorageId; size: ptr S64): Result {.cdecl,
    importc: "nsGetFreeSpaceSize".}
## *
##  @brief Returns the available storage capacity from content manager services.
##  @note Uses \ref nsGetContentManagementInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @param[in] storage_id \ref NcmStorageId. Must be ::NcmStorageId_SdCard.
##  @param[out] size Pointer to output the free storage size to.
##

proc nsCountApplicationContentMeta*(applicationId: U64; `out`: ptr S32): Result {.
    cdecl, importc: "nsCountApplicationContentMeta".}
## *
##  @brief CountApplicationContentMeta
##  @note Uses \ref nsGetContentManagementInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @note Only available on [2.0.0+].
##  @param[in] application_id ApplicationId.
##  @param[out] out Output count.
##

proc nsListApplicationContentMetaStatus*(applicationId: U64; index: S32; list: ptr NsApplicationContentMetaStatus;
                                        count: S32; outEntrycount: ptr S32): Result {.
    cdecl, importc: "nsListApplicationContentMetaStatus".}
## *
##  @brief Gets an listing of \ref NsApplicationContentMetaStatus.
##  @note Uses \ref nsGetContentManagementInterface on [3.0.0+], otherwise IApplicationManagerInterface is used.
##  @note Only available on [2.0.0+].
##  @param[in] application_id ApplicationId.
##  @param[in] index Starting entry index.
##  @param[out] list Output array of \ref NsApplicationContentMetaStatus.
##  @param[in] count Size of the list array in entries.
##  @param[out] out_entrycount Total output entries.
##

proc nsIsAnyApplicationRunning*(`out`: ptr bool): Result {.cdecl,
    importc: "nsIsAnyApplicationRunning".}
## *
##  @brief IsAnyApplicationRunning
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc nsRequestServerStopperClose*(r: ptr NsRequestServerStopper) {.cdecl,
    importc: "nsRequestServerStopperClose".}
## /@}
## /@name IRequestServerStopper
## /@{
## *
##  @brief Close a \ref NsRequestServerStopper.
##  @param r \ref NsRequestServerStopper
##

proc nsProgressMonitorForDeleteUserSaveDataAllClose*(
    p: ptr NsProgressMonitorForDeleteUserSaveDataAll): Result {.cdecl,
    importc: "nsProgressMonitorForDeleteUserSaveDataAllClose".}
## /@}
## /@name IProgressMonitorForDeleteUserSaveDataAll
## /@{
## *
##  @brief Close a \ref NsProgressMonitorForDeleteUserSaveDataAll. When initialized this will use \ref nsProgressMonitorForDeleteUserSaveDataAllIsFinished, throwing errors on failure / when the operation isn't finished (without closing the object).
##  @note Cancelling the operation before it's finished is not supported by \ref NsProgressMonitorForDeleteUserSaveDataAll.
##  @param p \ref NsProgressMonitorForDeleteUserSaveDataAll
##

proc nsProgressMonitorForDeleteUserSaveDataAllGetSystemEvent*(
    p: ptr NsProgressMonitorForDeleteUserSaveDataAll; outEvent: ptr Event): Result {.
    cdecl, importc: "nsProgressMonitorForDeleteUserSaveDataAllGetSystemEvent".}
## *
##  @brief GetSystemEvent
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc nsProgressMonitorForDeleteUserSaveDataAllIsFinished*(
    p: ptr NsProgressMonitorForDeleteUserSaveDataAll; `out`: ptr bool): Result {.cdecl,
    importc: "nsProgressMonitorForDeleteUserSaveDataAllIsFinished".}
## *
##  @brief IsFinished
##  @param p \ref NsProgressMonitorForDeleteUserSaveDataAll
##  @param[out] out Whether the operation finished.
##

proc nsProgressMonitorForDeleteUserSaveDataAllGetResult*(
    p: ptr NsProgressMonitorForDeleteUserSaveDataAll): Result {.cdecl,
    importc: "nsProgressMonitorForDeleteUserSaveDataAllGetResult".}
## *
##  @brief GetResult
##  @param p \ref NsProgressMonitorForDeleteUserSaveDataAll
##

proc nsProgressMonitorForDeleteUserSaveDataAllGetProgress*(
    p: ptr NsProgressMonitorForDeleteUserSaveDataAll;
    progress: ptr NsProgressForDeleteUserSaveDataAll): Result {.cdecl,
    importc: "nsProgressMonitorForDeleteUserSaveDataAllGetProgress".}
## *
##  @brief GetProgress
##  @param p \ref NsProgressMonitorForDeleteUserSaveDataAll
##  @param[out] progress Output \ref NsProgressForDeleteUserSaveDataAll.
##

proc nsProgressAsyncResultClose*(a: ptr NsProgressAsyncResult) {.cdecl,
    importc: "nsProgressAsyncResultClose".}
## /@}
## /@name IProgressAsyncResult
## /@{
## *
##  @brief Close a \ref NsProgressAsyncResult.
##  @note When the object is initialized, this uses \ref nsProgressAsyncResultCancel then \ref nsProgressAsyncResultWait with timeout=UINT64_MAX.
##  @param a \ref NsProgressAsyncResult
##

proc nsProgressAsyncResultWait*(a: ptr NsProgressAsyncResult; timeout: U64): Result {.
    cdecl, importc: "nsProgressAsyncResultWait".}
## *
##  @brief Waits for the async operation to finish using the specified timeout.
##  @param a \ref NsProgressAsyncResult
##  @param[in] timeout Timeout in nanoseconds. UINT64_MAX for no timeout.
##

proc nsProgressAsyncResultGet*(a: ptr NsProgressAsyncResult): Result {.cdecl,
    importc: "nsProgressAsyncResultGet".}
## *
##  @brief Gets the Result.
##  @note Prior to using the cmd, this uses \ref nsProgressAsyncResultWait with timeout=UINT64_MAX.
##  @param a \ref NsProgressAsyncResult
##

proc nsProgressAsyncResultCancel*(a: ptr NsProgressAsyncResult): Result {.cdecl,
    importc: "nsProgressAsyncResultCancel".}
## *
##  @brief Cancels the async operation.
##  @note Used automatically by \ref nsProgressAsyncResultClose.
##  @param a \ref NsProgressAsyncResult
##

proc nsProgressAsyncResultGetProgress*(a: ptr NsProgressAsyncResult;
                                      buffer: pointer; size: csize_t): Result {.
    cdecl, importc: "nsProgressAsyncResultGetProgress".}
## *
##  @brief Gets the progress.
##  @param a \ref NsProgressAsyncResult
##  @param[out] buffer Output buffer.
##  @param[in] size Output buffer size.
##

proc nsProgressAsyncResultGetDetailResult*(a: ptr NsProgressAsyncResult): Result {.
    cdecl, importc: "nsProgressAsyncResultGetDetailResult".}
## *
##  @brief GetDetailResult
##  @param a \ref NsProgressAsyncResult
##

proc nsProgressAsyncResultGetErrorContext*(a: ptr NsProgressAsyncResult;
    context: ptr ErrorContext): Result {.cdecl, importc: "nsProgressAsyncResultGetErrorContext".}
## *
##  @brief Gets the \ref ErrorContext.
##  @note Only available on [4.0.0+].
##  @param a \ref NsProgressAsyncResult
##  @param[out] context \ref ErrorContext
##

proc nsvmInitialize*(): Result {.cdecl, importc: "nsvmInitialize".}
## /@}
## /@name ns:vm
## /@{
## / Initialize ns:vm. On pre-3.0.0 this must be used with \ref nsInitialize.

proc nsvmExit*() {.cdecl, importc: "nsvmExit".}
## / Exit ns:vm.

proc nsvmGetServiceSession*(): ptr Service {.cdecl, importc: "nsvmGetServiceSession".}
## / Gets the Service object for ns:vm. This is only initialized on [3.0.0+].

proc nsvmNeedsUpdateVulnerability*(`out`: ptr bool): Result {.cdecl,
    importc: "nsvmNeedsUpdateVulnerability".}
##

proc nsvmGetSafeSystemVersion*(`out`: ptr NcmContentMetaKey): Result {.cdecl,
    importc: "nsvmGetSafeSystemVersion".}
##

proc nsdevInitialize*(): Result {.cdecl, importc: "nsdevInitialize".}
## /< [4.0.0+]
## /@}
## /@name ns:dev
## /@{
## / Initialize ns:dev.

proc nsdevExit*() {.cdecl, importc: "nsdevExit".}
## / Initialize ns:dev.

proc nsdevGetServiceSession*(): ptr Service {.cdecl,
    importc: "nsdevGetServiceSession".}
## / Gets the Service object for ns:dev.

proc nsdevLaunchProgram*(outPid: ptr U64; properties: ptr NsLaunchProperties;
                        flags: U32): Result {.cdecl, importc: "nsdevLaunchProgram".}
##

proc nsdevTerminateProcess*(pid: U64): Result {.cdecl,
    importc: "nsdevTerminateProcess".}
## /< [1.0.0-9.2.0]

proc nsdevTerminateProgram*(tid: U64): Result {.cdecl,
    importc: "nsdevTerminateProgram".}
##

proc nsdevGetShellEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "nsdevGetShellEvent".}
## /< [1.0.0-9.2.0]

proc nsdevGetShellEventInfo*(`out`: ptr NsShellEventInfo): Result {.cdecl,
    importc: "nsdevGetShellEventInfo".}
## /< Autoclear for nsdevShellEvent is always true. [1.0.0-9.2.0]

proc nsdevTerminateApplication*(): Result {.cdecl,
    importc: "nsdevTerminateApplication".}
## /< [1.0.0-9.2.0]

proc nsdevPrepareLaunchProgramFromHost*(`out`: ptr NsLaunchProperties;
                                       path: cstring; pathLen: csize_t): Result {.
    cdecl, importc: "nsdevPrepareLaunchProgramFromHost".}
##

proc nsdevLaunchApplicationForDevelop*(outPid: ptr U64; applicationId: U64; flags: U32): Result {.
    cdecl, importc: "nsdevLaunchApplicationForDevelop".}
## /< [1.0.0-9.2.0]

proc nsdevLaunchApplicationFromHost*(outPid: ptr U64; path: cstring; pathLen: csize_t;
                                    flags: U32): Result {.cdecl,
    importc: "nsdevLaunchApplicationFromHost".}
## /< [1.0.0-9.2.0]

proc nsdevLaunchApplicationWithStorageIdForDevelop*(outPid: ptr U64;
    applicationId: U64; flags: U32; appStorageId: U8; patchStorageId: U8): Result {.
    cdecl, importc: "nsdevLaunchApplicationWithStorageIdForDevelop".}
## /< [10.0.0+]

proc nsdevIsSystemMemoryResourceLimitBoosted*(`out`: ptr bool): Result {.cdecl,
    importc: "nsdevIsSystemMemoryResourceLimitBoosted".}
##

proc nsdevGetRunningApplicationProcessIdForDevelop*(outPid: ptr U64): Result {.cdecl,
    importc: "nsdevGetRunningApplicationProcessIdForDevelop".}
## /< [6.0.0-8.1.0]

proc nsdevSetCurrentApplicationRightsEnvironmentCanBeActiveForDevelop*(
    canBeActive: bool): Result {.cdecl, importc: "nsdevSetCurrentApplicationRightsEnvironmentCanBeActiveForDevelop".}
## /< [6.0.0+]

proc nssuInitialize*(): Result {.cdecl, importc: "nssuInitialize".}
## /< [6.0.0+]
## /@}
## /@name ns:su
## /@{
## / Initialize ns:su.

proc nssuExit*() {.cdecl, importc: "nssuExit".}
## / Exit ns:su.

proc nssuGetServiceSession*(): ptr Service {.cdecl, importc: "nssuGetServiceSession".}
## / Gets the Service object for ns:su.

proc nssuGetBackgroundNetworkUpdateState*(
    `out`: ptr NsBackgroundNetworkUpdateState): Result {.cdecl,
    importc: "nssuGetBackgroundNetworkUpdateState".}
## *
##  @brief Gets the \ref NsBackgroundNetworkUpdateState.
##  @note Internally this uses nim commands ListSystemUpdateTask and GetSystemUpdateTaskInfo to determine the output state.
##  @param[out] out \ref NsBackgroundNetworkUpdateState
##

proc nssuOpenSystemUpdateControl*(c: ptr NsSystemUpdateControl): Result {.cdecl,
    importc: "nssuOpenSystemUpdateControl".}
## *
##  @brief Opens a \ref NsSystemUpdateControl.
##  @note Only 1 \ref NsSystemUpdateControl can be open at a time.
##  @param[out] c \ref NsSystemUpdateControl
##

proc nssuNotifyExFatDriverRequired*(): Result {.cdecl,
    importc: "nssuNotifyExFatDriverRequired".}
## *
##  @brief Uses nim ListSystemUpdateTask, then uses the task with DestroySystemUpdateTask if it exists. Then this runs ExFat handling, updates state, and sets the same state flag as \ref nssuRequestBackgroundNetworkUpdate.
##  @note Only usable when a \ref NsSystemUpdateControl isn't open.
##

proc nssuClearExFatDriverStatusForDebug*(): Result {.cdecl,
    importc: "nssuClearExFatDriverStatusForDebug".}
## *
##  @brief ClearExFatDriverStatusForDebug
##

proc nssuRequestBackgroundNetworkUpdate*(): Result {.cdecl,
    importc: "nssuRequestBackgroundNetworkUpdate".}
## *
##  @brief RequestBackgroundNetworkUpdate
##  @note Only usable when a \ref NsSystemUpdateControl isn't open.
##

proc nssuNotifyBackgroundNetworkUpdate*(key: ptr NcmContentMetaKey): Result {.cdecl,
    importc: "nssuNotifyBackgroundNetworkUpdate".}
## *
##  @brief This checks whether a sysupdate is needed with the input \ref NcmContentMetaKey using NCM commands, if not this will just return 0. Otherwise, this will then run code which is identical to \ref nssuRequestBackgroundNetworkUpdate.
##  @note Only usable when a \ref NsSystemUpdateControl isn't open.
##  @param[in] key \ref NcmContentMetaKey
##

proc nssuNotifyExFatDriverDownloadedForDebug*(): Result {.cdecl,
    importc: "nssuNotifyExFatDriverDownloadedForDebug".}
## *
##  @brief NotifyExFatDriverDownloadedForDebug
##

proc nssuGetSystemUpdateNotificationEventForContentDelivery*(outEvent: ptr Event): Result {.
    cdecl, importc: "nssuGetSystemUpdateNotificationEventForContentDelivery".}
## *
##  @brief Gets an Event which can be signaled by \ref nssuNotifySystemUpdateForContentDelivery.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc nssuNotifySystemUpdateForContentDelivery*(): Result {.cdecl,
    importc: "nssuNotifySystemUpdateForContentDelivery".}
## *
##  @brief Signals the event returned by \ref nssuGetSystemUpdateNotificationEventForContentDelivery.
##

proc nssuPrepareShutdown*(): Result {.cdecl, importc: "nssuPrepareShutdown".}
## *
##  @brief This does shutdown preparation.
##  @note This is used by am-sysmodule, so generally there's no need to use this.
##  @note Only available on [3.0.0+].
##

proc nssuDestroySystemUpdateTask*(): Result {.cdecl,
    importc: "nssuDestroySystemUpdateTask".}
## *
##  @brief This uses nim ListSystemUpdateTask, then when a task is returned uses it with DestroySystemUpdateTask.
##  @note Only available on [4.0.0+].
##

proc nssuRequestSendSystemUpdate*(a: ptr AsyncResult; `addr`: U32; port: U16;
                                 info: ptr NsSystemDeliveryInfo): Result {.cdecl,
    importc: "nssuRequestSendSystemUpdate".}
## *
##  @brief RequestSendSystemUpdate
##  @note The system will use the input addr/port with bind(), the input addr will eventually be validated with the addr from accept(). addr/port are little-endian.
##  @note After the system accepts a connection etc, an error will be thrown if the system is Internet-connected.
##  @note Only available on [4.0.0+].
##  @param[out] a \ref AsyncResult
##  @param[in] addr Client IPv4 address. qlaunch uses a local-WLAN addr.
##  @param[in] port Socket port. qlaunch uses value 55556.
##  @param[in] info \ref NsSystemDeliveryInfo
##

proc nssuGetSendSystemUpdateProgress*(`out`: ptr NsSystemUpdateProgress): Result {.
    cdecl, importc: "nssuGetSendSystemUpdateProgress".}
## *
##  @brief GetSendSystemUpdateProgress
##  @note Only available on [4.0.0+].
##  @param[out] out \ref NsSystemUpdateProgress
##

proc nssuControlClose*(c: ptr NsSystemUpdateControl) {.cdecl,
    importc: "nssuControlClose".}
## /@}
## /@name ISystemUpdateControl
## /@{
## *
##  @brief Close a \ref NsSystemUpdateControl.
##  @param c \ref NsSystemUpdateControl
##

proc nssuControlHasDownloaded*(c: ptr NsSystemUpdateControl; `out`: ptr bool): Result {.
    cdecl, importc: "nssuControlHasDownloaded".}
## *
##  @brief Gets whether a network sysupdate was downloaded, with install pending.
##  @param c \ref NsSystemUpdateControl
##  @param[out] out Output flag.
##

proc nssuControlRequestCheckLatestUpdate*(c: ptr NsSystemUpdateControl;
    a: ptr AsyncValue): Result {.cdecl,
                             importc: "nssuControlRequestCheckLatestUpdate".}
## *
##  @brief RequestCheckLatestUpdate
##  @param c \ref NsSystemUpdateControl
##  @param[out] a \ref AsyncValue. The data that can be read from this is u8 \ref NsLatestSystemUpdate.
##

proc nssuControlRequestDownloadLatestUpdate*(c: ptr NsSystemUpdateControl;
    a: ptr AsyncResult): Result {.cdecl,
                              importc: "nssuControlRequestDownloadLatestUpdate".}
## *
##  @brief RequestDownloadLatestUpdate
##  @param c \ref NsSystemUpdateControl
##  @param[out] a \ref AsyncResult
##

proc nssuControlGetDownloadProgress*(c: ptr NsSystemUpdateControl;
                                    `out`: ptr NsSystemUpdateProgress): Result {.
    cdecl, importc: "nssuControlGetDownloadProgress".}
## *
##  @brief GetDownloadProgress
##  @param c \ref NsSystemUpdateControl
##  @param[out] out \ref NsSystemUpdateProgress
##

proc nssuControlApplyDownloadedUpdate*(c: ptr NsSystemUpdateControl): Result {.cdecl,
    importc: "nssuControlApplyDownloadedUpdate".}
## *
##  @brief ApplyDownloadedUpdate
##  @param c \ref NsSystemUpdateControl
##

proc nssuControlRequestPrepareCardUpdate*(c: ptr NsSystemUpdateControl;
    a: ptr AsyncResult): Result {.cdecl,
                              importc: "nssuControlRequestPrepareCardUpdate".}
## *
##  @brief RequestPrepareCardUpdate
##  @param c \ref NsSystemUpdateControl
##  @param[out] a \ref AsyncResult
##

proc nssuControlGetPrepareCardUpdateProgress*(c: ptr NsSystemUpdateControl;
    `out`: ptr NsSystemUpdateProgress): Result {.cdecl,
    importc: "nssuControlGetPrepareCardUpdateProgress".}
## *
##  @brief GetPrepareCardUpdateProgress
##  @note \ref nssuControlSetupCardUpdate / \ref nssuControlSetupCardUpdateViaSystemUpdater must have been used at some point prior to using this.
##  @param c \ref NsSystemUpdateControl
##  @param[out] out \ref NsSystemUpdateProgress
##

proc nssuControlHasPreparedCardUpdate*(c: ptr NsSystemUpdateControl; `out`: ptr bool): Result {.
    cdecl, importc: "nssuControlHasPreparedCardUpdate".}
## *
##  @brief HasPreparedCardUpdate
##  @note \ref nssuControlSetupCardUpdate / \ref nssuControlSetupCardUpdateViaSystemUpdater must have been used at some point prior to using this.
##  @param c \ref NsSystemUpdateControl
##  @param[out] out Output flag.
##

proc nssuControlApplyCardUpdate*(c: ptr NsSystemUpdateControl): Result {.cdecl,
    importc: "nssuControlApplyCardUpdate".}
## *
##  @brief ApplyCardUpdate
##  @note \ref nssuControlSetupCardUpdate / \ref nssuControlSetupCardUpdateViaSystemUpdater must have been used at some point prior to using this.
##  @param c \ref NsSystemUpdateControl
##

proc nssuControlGetDownloadedEulaDataSize*(c: ptr NsSystemUpdateControl;
    path: cstring; filesize: ptr U64): Result {.cdecl,
    importc: "nssuControlGetDownloadedEulaDataSize".}
## *
##  @brief Gets the filesize for the specified DownloadedEulaData.
##  @note This mounts the Eula SystemData, then uses the file "<mountname>:/<input path>".
##  @param c \ref NsSystemUpdateControl
##  @param[in] path EulaData path.
##  @param[out] filesize Output filesize.
##

proc nssuControlGetDownloadedEulaData*(c: ptr NsSystemUpdateControl; path: cstring;
                                      buffer: pointer; size: csize_t;
                                      filesize: ptr U64): Result {.cdecl,
    importc: "nssuControlGetDownloadedEulaData".}
## *
##  @brief Gets the specified DownloadedEulaData.
##  @note See the note for \ref nssuControlGetDownloadedEulaDataSize.
##  @param c \ref NsSystemUpdateControl
##  @param[in] path EulaData path.
##  @param[out] buffer Output buffer.
##  @param[in] size Size of the output buffer, must be at least the output size from \ref nssuControlGetDownloadedEulaDataSize.
##  @param[out] filesize Output filesize.
##

proc nssuControlSetupCardUpdate*(c: ptr NsSystemUpdateControl; buffer: pointer;
                                size: csize_t): Result {.cdecl,
    importc: "nssuControlSetupCardUpdate".}
## *
##  @brief SetupCardUpdate
##  @param c \ref NsSystemUpdateControl
##  @param[in] buffer TransferMemory buffer, when NULL this is automatically allocated.
##  @param[in] size TransferMemory buffer size, see \ref NSSU_CARDUPDATE_TMEM_SIZE_DEFAULT.
##

proc nssuControlGetPreparedCardUpdateEulaDataSize*(c: ptr NsSystemUpdateControl;
    path: cstring; filesize: ptr U64): Result {.cdecl,
    importc: "nssuControlGetPreparedCardUpdateEulaDataSize".}
## *
##  @brief Gets the filesize for the specified PreparedCardUpdateEulaData.
##  @note See the note for \ref nssuControlGetDownloadedEulaDataSize.
##  @param c \ref NsSystemUpdateControl
##  @param[in] path EulaData path.
##  @param[out] filesize Output filesize.
##

proc nssuControlGetPreparedCardUpdateEulaData*(c: ptr NsSystemUpdateControl;
    path: cstring; buffer: pointer; size: csize_t; filesize: ptr U64): Result {.cdecl,
    importc: "nssuControlGetPreparedCardUpdateEulaData".}
## *
##  @brief Gets the specified PreparedCardUpdateEulaData.
##  @note See the note for \ref nssuControlGetDownloadedEulaDataSize.
##  @param c \ref NsSystemUpdateControl
##  @param[in] path EulaData path.
##  @param[out] buffer Output buffer.
##  @param[in] size Size of the output buffer, must be at least the output size from \ref nssuControlGetPreparedCardUpdateEulaDataSize.
##  @param[out] filesize Output filesize.
##

proc nssuControlSetupCardUpdateViaSystemUpdater*(c: ptr NsSystemUpdateControl;
    buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "nssuControlSetupCardUpdateViaSystemUpdater".}
## *
##  @brief SetupCardUpdateViaSystemUpdater
##  @note Same as \ref nssuControlSetupCardUpdate, except this doesn't run the code for fs cmds GetGameCardHandle/GetGameCardUpdatePartitionInfo, and uses fs OpenRegisteredUpdatePartition instead of OpenGameCardFileSystem.
##  @note Only available on [4.0.0+].
##  @param c \ref NsSystemUpdateControl
##  @param[in] buffer TransferMemory buffer, when NULL this is automatically allocated.
##  @param[in] size TransferMemory buffer size, see \ref NSSU_CARDUPDATE_TMEM_SIZE_DEFAULT.
##

proc nssuControlHasReceived*(c: ptr NsSystemUpdateControl; `out`: ptr bool): Result {.
    cdecl, importc: "nssuControlHasReceived".}
## *
##  @brief HasReceived
##  @note Only available on [4.0.0+].
##  @param c \ref NsSystemUpdateControl
##  @param[out] out Output flag.
##

proc nssuControlRequestReceiveSystemUpdate*(c: ptr NsSystemUpdateControl;
    a: ptr AsyncResult; `addr`: U32; port: U16; info: ptr NsSystemDeliveryInfo): Result {.
    cdecl, importc: "nssuControlRequestReceiveSystemUpdate".}
## *
##  @brief RequestReceiveSystemUpdate
##  @note The system will use the input addr/port with connect(). addr/port are little-endian.
##  @note Only available on [4.0.0+].
##  @param c \ref NsSystemUpdateControl
##  @param[out] a \ref AsyncResult
##  @param[in] addr Server IPv4 address. qlaunch uses a local-WLAN addr, however this can be any addr.
##  @param[in] port Socket port. qlaunch uses value 55556.
##  @param[in] info \ref NsSystemDeliveryInfo
##

proc nssuControlGetReceiveProgress*(c: ptr NsSystemUpdateControl;
                                   `out`: ptr NsSystemUpdateProgress): Result {.
    cdecl, importc: "nssuControlGetReceiveProgress".}
## *
##  @brief GetReceiveProgress
##  @note Only available on [4.0.0+].
##  @param c \ref NsSystemUpdateControl
##  @param[out] out \ref NsSystemUpdateProgress
##

proc nssuControlApplyReceivedUpdate*(c: ptr NsSystemUpdateControl): Result {.cdecl,
    importc: "nssuControlApplyReceivedUpdate".}
## *
##  @brief ApplyReceivedUpdate
##  @note Only available on [4.0.0+].
##  @param c \ref NsSystemUpdateControl
##

proc nssuControlGetReceivedEulaDataSize*(c: ptr NsSystemUpdateControl;
                                        path: cstring; filesize: ptr U64): Result {.
    cdecl, importc: "nssuControlGetReceivedEulaDataSize".}
## *
##  @brief Gets the filesize for the specified ReceivedEulaData.
##  @note See the note for \ref nssuControlGetDownloadedEulaDataSize.
##  @note Only available on [4.0.0+].
##  @param c \ref NsSystemUpdateControl
##  @param[in] path EulaData path.
##  @param[out] filesize Output filesize.
##

proc nssuControlGetReceivedEulaData*(c: ptr NsSystemUpdateControl; path: cstring;
                                    buffer: pointer; size: csize_t;
                                    filesize: ptr U64): Result {.cdecl,
    importc: "nssuControlGetReceivedEulaData".}
## *
##  @brief Gets the specified ReceivedEulaData.
##  @note See the note for \ref nssuControlGetDownloadedEulaDataSize.
##  @note Only available on [4.0.0+].
##  @param c \ref NsSystemUpdateControl
##  @param[in] path EulaData path.
##  @param[out] buffer Output buffer.
##  @param[in] size Size of the output buffer, must be at least the output size from \ref nssuControlGetReceivedEulaDataSize.
##  @param[out] filesize Output filesize.
##

proc nssuControlSetupToReceiveSystemUpdate*(c: ptr NsSystemUpdateControl): Result {.
    cdecl, importc: "nssuControlSetupToReceiveSystemUpdate".}
## *
##  @brief Does setup for ReceiveSystemUpdate by using the same nim cmds as \ref nssuDestroySystemUpdateTask.
##  @note qlaunch uses this before \ref nssuControlRequestReceiveSystemUpdate.
##  @note Only available on [4.0.0+].
##  @param c \ref NsSystemUpdateControl
##

proc nssuControlRequestCheckLatestUpdateIncludesRebootlessUpdate*(
    c: ptr NsSystemUpdateControl; a: ptr AsyncValue): Result {.cdecl,
    importc: "nssuControlRequestCheckLatestUpdateIncludesRebootlessUpdate".}
## *
##  @brief RequestCheckLatestUpdateIncludesRebootlessUpdate
##  @note Only available on [6.0.0+].
##  @param c \ref NsSystemUpdateControl
##  @param[out] a \ref AsyncValue
##

## /@}
