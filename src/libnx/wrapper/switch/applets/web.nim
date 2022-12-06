## *
##  @file web.h
##  @brief Wrapper for using the web LibraryApplets. See also: https://switchbrew.org/wiki/Internet_Browser
##  @author p-sam, yellows8
##  @copyright libnx Authors
##

import
  ../types, ../services/applet, ../services/caps, ../services/acc, ../kernel/mutex, ../kernel/event

## / This indicates the type of web-applet.

type
  WebShimKind* = enum
    WebShimKindShop = 1, WebShimKindLogin = 2, WebShimKindOffline = 3,
    WebShimKindShare = 4, WebShimKindWeb = 5, WebShimKindWifi = 6, WebShimKindLobby = 7


## / ExitReason

type
  WebExitReason* = enum
    WebExitReasonExitButton = 0x0, ## /< User pressed the X button to exit.
    WebExitReasonBackButton = 0x1, ## /< User pressed the B button to exit, on the initial page.
    WebExitReasonRequested = 0x2, ## /< The applet exited since \ref webConfigRequestExit was used.
    WebExitReasonLastUrl = 0x3, ## /< The applet exited due to LastUrl handling, see \ref webReplyGetLastUrl.
    WebExitReasonErrorDialog = 0x7, ## /< The applet exited after displaying an error dialog.
    WebExitReasonUnknownE = 0xE ## /< Unknown


## / Button values for \ref webConfigSetBootFooterButtonVisible.

type
  WebFooterButtonId* = enum
    WebFooterButtonIdNone = 0,  ## /< None, for empty \ref WebBootFooterButtonEntry. Invalid for \ref webConfigSetBootFooterButtonVisible input.
    WebFooterButtonIdType1 = 1, ## /< Unknown button Id 1.
    WebFooterButtonIdType2 = 2, ## /< Unknown button Id 2.
    WebFooterButtonIdType3 = 3, ## /< Unknown button Id 3.
    WebFooterButtonIdType4 = 4, ## /< Unknown button Id 4.
    WebFooterButtonIdType5 = 5, ## /< Unknown button Id 5.
    WebFooterButtonIdType6 = 6, ## /< Unknown button Id 6.
    WebFooterButtonIdMax      ## /< Values starting with this are invalid.


## / WebSessionBootMode

type
  WebSessionBootMode* = enum
    WebSessionBootModeAllForeground = 0, ## /< AllForeground. This is the default.
    WebSessionBootModeAllForegroundInitiallyHidden = 1 ## /< AllForegroundInitiallyHidden


## / WebSessionSendMessageKind

type
  WebSessionSendMessageKind* = enum
    WebSessionSendMessageKindBrowserEngineContent = 0x0, ## /< BrowserEngine Content
    WebSessionSendMessageKindSystemMessageAppear = 0x100, ## /< SystemMessage Appear
    WebSessionSendMessageKindAck = 0x1000 ## /< Ack


## / WebSessionReceiveMessageKind

type
  WebSessionReceiveMessageKind* = enum
    WebSessionReceiveMessageKindBrowserEngineContent = 0x0, ## /< BrowserEngine Content
    WebSessionReceiveMessageKindAckBrowserEngine = 0x1000, ## /< Ack BrowserEngine
    WebSessionReceiveMessageKindAckSystemMessage = 0x1001 ## /< Ack SystemMessage


## / Struct for the WebWifi applet input storage.

type
  WebWifiPageArg* {.bycopy.} = object
    unkX0*: U32                ## /< Official sw sets this to 0 with appletStorageWrite, separately from the rest of the config struct.
    conntestUrl*: array[0x100, char] ## /< Connection-test URL.
    initialUrl*: array[0x400, char] ## /< Initial URL navigated to by the applet.
    uuid*: Uuid                ## /< NIFM Network UUID. Only used by the applet when conntest_url is set.
    rev*: U32                  ## /< Input value for nifm cmd SetRequirementByRevision. Only used by the applet when conntest_url is set.


## / Struct for the WebWifi applet output storage.

type
  WebWifiReturnValue* {.bycopy.} = object
    unkX0*: U32                ## /< Unknown.
    res*: Result               ## /< Result


## / Config for WebWifi.

type
  WebWifiConfig* {.bycopy.} = object
    arg*: WebWifiPageArg       ## /< Arg data.


## / TLV storage, starts with \ref WebArgHeader followed by \ref WebArgTLV entries.

type
  WebCommonTLVStorage* {.bycopy.} = object
    data*: array[0x2000, U8]    ## /< Raw TLV data storage.


## / Common struct for the applet output storage, for non-TLV-storage.

type
  WebCommonReturnValue* {.bycopy.} = object
    exitReason*: WebExitReason ## /< ExitReason
    pad*: U32                  ## /< Padding
    lastUrl*: array[0x1000, char] ## /< LastUrl string
    lastUrlSize*: U64          ## /< Size of LastUrl, including NUL-terminator.


## / Header struct at offset 0 in the web Arg storage (non-webWifi).

type
  WebArgHeader* {.bycopy.} = object
    totalEntries*: U16         ## /< Total \ref WebArgTLV entries following this struct.
    pad*: U16                  ## /< Padding
    shimKind*: WebShimKind     ## /< ShimKind


## / Web TLV used in the web Arg storage.

type
  WebArgTLV* {.bycopy.} = object
    `type`*: U16               ## /< Type of this arg.
    size*: U16                 ## /< Size of the arg data following this struct.
    pad*: array[4, U8]          ## /< Padding


## / Config struct for web applets, non-WebWifi.

type
  WebCommonConfig* {.bycopy.} = object
    arg*: WebCommonTLVStorage  ## /< TLV storage.
    appletid*: AppletId        ## /< AppletId
    version*: U32              ## /< CommonArgs applet version.
    holder*: AppletHolder      ## /< AppletHolder


## / Common container struct for applets' reply data, from the output storage.

type
  WebCommonReply* {.bycopy.} = object
    `type`*: bool              ## /< Type of reply: false = ret, true = storage.
    shimKind*: WebShimKind     ## /< ShimKind
    ret*: WebCommonReturnValue ## /< Reply data for reply=false.
    storage*: WebCommonTLVStorage ## /< Reply data for reply=true.


## / Entry data for ::WebArgType_BootFooterButton.

type
  WebBootFooterButtonEntry* {.bycopy.} = object
    id*: WebFooterButtonId
    visible*: U8
    unkX5*: U16
    unkX7*: U8


## / StorageHandleQueue

type
  WebSessionStorageHandleQueue* {.bycopy.} = object
    readPos*: S32
    writePos*: S32
    maxStorages*: S32
    isFull*: bool
    storages*: array[0x10, AppletStorage]


## / WebSession

type
  INNER_C_STRUCT_web_1* {.bycopy.} = object
    count*: U32
    curSize*: U32

  WebSession* {.bycopy.} = object
    mutex*: Mutex
    config*: ptr WebCommonConfig
    queue*: array[2, INNER_C_STRUCT_web_1]
    storageQueue*: WebSessionStorageHandleQueue


## / SessionMessageHeader

type
  WebSessionMessageHeader* {.bycopy.} = object
    kind*: U32                 ## /< Message Kind (\ref WebSessionSendMessageKind / \ref WebSessionReceiveMessageKind)
    size*: U32                 ## /< Data size following the header.
    reserved*: array[0x8, U8]   ## /< Unused


## / Types for \ref WebArgTLV, input storage.

type
  WebArgType* = enum
    WebArgTypeUrl = 0x1,        ## /< [1.0.0+] String, size 0xC00. Initial URL.
    WebArgTypeCallbackUrl = 0x3, ## /< [1.0.0+] String, size 0x400.
    WebArgTypeCallbackableUrl = 0x4, ## /< [1.0.0+] String, size 0x400.
    WebArgTypeApplicationId = 0x5, ## /< [1.0.0+] Offline-applet, u64 ApplicationId
    WebArgTypeDocumentPath = 0x6, ## /< [1.0.0+] Offline-applet, string with size 0xC00.
    WebArgTypeDocumentKind = 0x7, ## /< [1.0.0+] Offline-applet, u32 enum \WebDocumentKind.
    WebArgTypeSystemDataId = 0x8, ## /< [1.0.0+] Offline-applet, u64 SystemDataId
    WebArgTypeShareStartPage = 0x9, ## /< [1.0.0+] u32 enum \WebShareStartPage
    WebArgTypeWhitelist = 0xA,  ## /< [1.0.0+] String, size 0x1000.
    WebArgTypeNewsFlag = 0xB,   ## /< [1.0.0+] u8 bool
    WebArgTypeUnknownC = 0xC,   ## /< [1.0.0+] u8
    WebArgTypeUnknownD = 0xD,   ## /< [1.0.0+] u8
    WebArgTypeUid = 0xE,        ## /< [1.0.0+] \ref AccountUid, controls which user-specific savedata to mount.
    WebArgTypeAlbumEntry0 = 0xF, ## /< [1.0.0+] Share-applet caps AlbumEntry, entry 0.
    WebArgTypeScreenShot = 0x10, ## /< [1.0.0+] u8 bool
    WebArgTypeEcClientCert = 0x11, ## /< [1.0.0+] u8 bool
    WebArgTypeUnknown12 = 0x12, ## /< [1.0.0+] u8
    WebArgTypePlayReport = 0x13, ## /< [1.0.0+] u8 bool
    WebArgTypeUnknown14 = 0x14, ## /< [1.0.0+] u8
    WebArgTypeUnknown15 = 0x15, ## /< [1.0.0+] u8
    WebArgTypeBootDisplayKind = 0x17, ## /< [1.0.0+] u32 enum \ref WebBootDisplayKind
    WebArgTypeBackgroundKind = 0x18, ## /< [1.0.0+] u32 enum \ref WebBackgroundKind
    WebArgTypeFooter = 0x19,    ## /< [1.0.0+] u8 bool
    WebArgTypePointer = 0x1A,   ## /< [1.0.0+] u8 bool
    WebArgTypeLeftStickMode = 0x1B, ## /< [1.0.0+] u32 enum \ref WebLeftStickMode
    WebArgTypeKeyRepeatFrame0 = 0x1C, ## /< [1.0.0+] s32 KeyRepeatFrame, first param
    WebArgTypeKeyRepeatFrame1 = 0x1D, ## /< [1.0.0+] s32 KeyRepeatFrame, second param
    WebArgTypeBootAsMediaPlayerInverted = 0x1E, ## /< [1.0.0+] u8 bool. With News on [3.0.0+] this is set after BootAsMediaPlayer with the value inverted.
    WebArgTypeDisplayUrlKind = 0x1F, ## /< [1.0.0+] u8 bool, DisplayUrlKind (value = (input_enumval==0x1)).
    WebArgTypeBootAsMediaPlayer = 0x21, ## /< [2.0.0+] u8 bool
    WebArgTypeShopJump = 0x22,  ## /< [2.0.0+] u8 bool
    WebArgTypeMediaPlayerUserGestureRestriction = 0x23, ## /< [2.0.0-5.1.0] u8 bool
    WebArgTypeLobbyParameter = 0x24, ## /< [2.0.0+] String, size 0x100.
    WebArgTypeApplicationAlbumEntry = 0x26, ## /< [3.0.0+] Share-applet caps ApplicationAlbumEntry
    WebArgTypeJsExtension = 0x27, ## /< [3.0.0+] u8 bool
    WebArgTypeAdditionalCommentText = 0x28, ## /< [4.0.0+] String, size 0x100. Share-applet AdditionalCommentText.
    WebArgTypeTouchEnabledOnContents = 0x29, ## /< [4.0.0+] u8 bool
    WebArgTypeUserAgentAdditionalString = 0x2A, ## /< [4.0.0+] String, size 0x80.
    WebArgTypeAdditionalMediaData0 = 0x2B, ## /< [4.0.0+] Share-applet 0x10-byte u8 array, AdditionalMediaData. Entry 0. If the user-input size is less than 0x10, the remaining data used for the TLV is cleared.
    WebArgTypeMediaPlayerAutoClose = 0x2C, ## /< [4.0.0+] u8 bool
    WebArgTypePageCache = 0x2D, ## /< [4.0.0+] u8 bool
    WebArgTypeWebAudio = 0x2E,  ## /< [4.0.0+] u8 bool
    WebArgType2F = 0x2F,        ## /< [5.0.0+] u8
    WebArgTypeYouTubeVideoFlag = 0x31, ## /< [5.0.0+] u8 bool Indicates that the built-in whitelist for YouTubeVideo should be used.
    WebArgTypeFooterFixedKind = 0x32, ## /< [5.0.0+] u32 enum \ref WebFooterFixedKind
    WebArgTypePageFade = 0x33,  ## /< [5.0.0+] u8 bool
    WebArgTypeMediaCreatorApplicationRatingAge = 0x34, ## /< [5.0.0+] Share-applet 0x20-byte s8 array, MediaCreatorApplicationRatingAge.
    WebArgTypeBootLoadingIcon = 0x35, ## /< [5.0.0+] u8 bool
    WebArgTypePageScrollIndicator = 0x36, ## /< [5.0.0+] u8 bool
    WebArgTypeMediaPlayerSpeedControl = 0x37, ## /< [6.0.0+] u8 bool
    WebArgTypeAlbumEntry1 = 0x38, ## /< [6.0.0+] Share-applet caps AlbumEntry, entry 1.
    WebArgTypeAlbumEntry2 = 0x39, ## /< [6.0.0+] Share-applet caps AlbumEntry, entry 2.
    WebArgTypeAlbumEntry3 = 0x3A, ## /< [6.0.0+] Share-applet caps AlbumEntry, entry 3.
    WebArgTypeAdditionalMediaData1 = 0x3B, ## /< [6.0.0+] Share-applet 0x10-byte u8 array, AdditionalMediaData. Entry 1.
    WebArgTypeAdditionalMediaData2 = 0x3C, ## /< [6.0.0+] Share-applet 0x10-byte u8 array, AdditionalMediaData. Entry 2.
    WebArgTypeAdditionalMediaData3 = 0x3D, ## /< [6.0.0+] Share-applet 0x10-byte u8 array, AdditionalMediaData. Entry 3.
    WebArgTypeBootFooterButton = 0x3E, ## /< [6.0.0+] Array of \ref WebBootFooterButtonEntry with 0x10 entries.
    WebArgTypeOverrideWebAudioVolume = 0x3F, ## /< [6.0.0+] float
    WebArgTypeOverrideMediaAudioVolume = 0x40, ## /< [6.0.0+] float
    WebArgTypeSessionBootMode = 0x41, ## /< [7.0.0+] u32 enum \ref WebSessionBootMode
    WebArgTypeSessionFlag = 0x42, ## /< [7.0.0+] u8 bool, enables using WebSession when set.
    WebArgTypeMediaPlayerUi = 0x43, ## /< [8.0.0+] u8 bool
    WebArgTypeTransferMemory = 0x44 ## /< [11.0.0+] u8 bool

const
  WebArgTypeMediaAutoPlay* = WebArgTypeMediaPlayerUserGestureRestriction

## / Types for \ref WebArgTLV, output storage.

type
  WebReplyType* = enum
    WebReplyTypeExitReason = 0x1, ## /< [3.0.0+] u32 ExitReason
    WebReplyTypeLastUrl = 0x2,  ## /< [3.0.0+] string
    WebReplyTypeLastUrlSize = 0x3, ## /< [3.0.0+] u64
    WebReplyTypeSharePostResult = 0x4, ## /< [3.0.0+] u32 SharePostResult
    WebReplyTypePostServiceName = 0x5, ## /< [3.0.0+] string
    WebReplyTypePostServiceNameSize = 0x6, ## /< [3.0.0+] u64
    WebReplyTypePostId = 0x7,   ## /< [3.0.0+] string
    WebReplyTypePostIdSize = 0x8, ## /< [3.0.0+] u64
    WebReplyTypeMediaPlayerAutoClosedByCompletion = 0x9 ## /< [8.0.0+] u8 bool


## / This controls the kind of content to mount with Offline-applet.

type
  WebDocumentKind* = enum
    WebDocumentKindOfflineHtmlPage = 0x1, ## /< Use the HtmlDocument NCA content from the application.
    WebDocumentKindApplicationLegalInformation = 0x2, ## /< Use the LegalInformation NCA content from the application.
    WebDocumentKindSystemDataPage = 0x3 ## /< Use the Data NCA content from the specified SystemData, see also: https://switchbrew.org/wiki/Title_list#System_Data_Archives


## / This controls the initial page for ShareApplet, used by \ref webShareCreate.

type
  WebShareStartPage* = enum
    WebShareStartPageDefault = 0, ## /< The default "/" page.
    WebShareStartPageSettings = 1 ## /< The "/settings/" page.


## / Kind values for \ref webConfigSetBootDisplayKind. Controls the background color while displaying the loading screen during applet boot. Also controls the BackgroundKind when value is non-zero.

type
  WebBootDisplayKind* = enum
    WebBootDisplayKindDefault = 0, ## /< Default. BackgroundKind is controlled by \ref WebBackgroundKind.
    WebBootDisplayKindWhite = 1, ## /< White background. Used by \ref webOfflineCreate for docKind ::WebDocumentKind_ApplicationLegalInformation/::WebDocumentKind_SystemDataPage.
    WebBootDisplayKindBlack = 2, ## /< Black background.
    WebBootDisplayKindUnknown3 = 3, ## /< Unknown. Used by \ref webShareCreate.
    WebBootDisplayKindUnknown4 = 4 ## /< Unknown. Used by \ref webLobbyCreate.


## / Kind values for \ref webConfigSetBackgroundKind. Controls the background color while displaying the loading screen during applet boot. Only used when \ref WebBootDisplayKind is ::WebBootDisplayKind_Default. If the applet was not launched by an Application, the applet will only use WebBackgroundKind_Default.

type
  WebBackgroundKind* = enum
    WebBackgroundKindDefault = 0, ## /< Default. Same as ::WebBootDisplayKind_White/::WebBootDisplayKind_Black, determined via ::WebArgType_BootAsMediaPlayer.
    WebBackgroundKindUnknown1 = 1, ## /< Unknown. Same as ::WebBootDisplayKind_Unknown3.
    WebBackgroundKindUnknown2 = 2 ## /< Unknown. Same as ::WebBootDisplayKind_Unknown4. Used by \ref webLobbyCreate.


## / Mode values for \ref webConfigSetLeftStickMode. Controls the initial mode, this can be toggled by the user via the pressing the left-stick button. If the Pointer flag is set to false (\ref webConfigSetPointer), only ::WebLeftStickMode_Cursor will be used and mode toggle by the user is disabled (input value ignored).

type
  WebLeftStickMode* = enum
    WebLeftStickModePointer = 0, ## /< The user can directly control the pointer via the left-stick.
    WebLeftStickModeCursor = 1  ## /< The user can only select elements on the page via the left-stick.


## / Kind values for \ref webConfigSetFooterFixedKind. Controls UI footer display behaviour.

type
  WebFooterFixedKind* = enum
    WebFooterFixedKindDefault = 0, ## /< Default. Footer is hidden while scrolling.
    WebFooterFixedKindAlways = 1, ## /< Footer is always displayed regardless of scrolling.
    WebFooterFixedKindHidden = 2 ## /< Footer is hidden regardless of scrolling.

proc webWifiCreate*(config: ptr WebWifiConfig; conntestUrl: cstring;
                   initialUrl: cstring; uuid: Uuid; rev: U32) {.cdecl,
    importc: "webWifiCreate".}
## *
##  @brief Creates the config for WifiWebAuthApplet. This is the captive portal applet.
##  @param config WebWifiConfig object.
##  @param conntest_url URL used for the connection-test requests. When empty/NULL the applet will test the connection with nifm and throw an error on failure.
##  @param initial_url Initial URL navigated to by the applet.
##  @param uuid NIFM Network UUID, for nifm cmd SetNetworkProfileId. Value 0 can be used. Only used by the applet when conntest_url is set.
##  @param rev Input value for nifm cmd SetRequirementByRevision. Value 0 can be used. Only used by the applet when conntest_url is set.
##

proc webWifiShow*(config: ptr WebWifiConfig; `out`: ptr WebWifiReturnValue): Result {.
    cdecl, importc: "webWifiShow".}
## *
##  @brief Launches WifiWebAuthApplet with the specified config and waits for it to exit.
##  @param config WebWifiConfig object.
##  @param out Optional output applet reply data, can be NULL.
##

proc webPageCreate*(config: ptr WebCommonConfig; url: cstring): Result {.cdecl,
    importc: "webPageCreate".}
## *
##  @brief Creates the config for WebApplet. This applet uses an URL whitelist loaded from the user-process host Application, which is only loaded when running under an Application.
##  @note Sets ::WebArgType_UnknownD, and ::WebArgType_Unknown12 on pre-3.0.0, to value 1.
##  @param config WebCommonConfig object.
##  @param url Initial URL navigated to by the applet.
##

proc webNewsCreate*(config: ptr WebCommonConfig; url: cstring): Result {.cdecl,
    importc: "webNewsCreate".}
## *
##  @brief Creates the config for WebApplet. This is based on \ref webPageCreate, for News. Hence other functions referencing \ref webPageCreate also apply to this.
##  @note The domain from the input URL is automatically whitelisted, in addition to any already loaded whitelist.
##  @note Sets ::WebArgType_UnknownD to value 1, and sets ::WebArgType_NewsFlag to true. Also uses \ref webConfigSetEcClientCert and \ref webConfigSetShopJump with flag=true.
##  @param config WebCommonConfig object.
##  @param url Initial URL navigated to by the applet.
##

proc webYouTubeVideoCreate*(config: ptr WebCommonConfig; url: cstring): Result {.cdecl,
    importc: "webYouTubeVideoCreate".}
## *
##  @brief Creates the config for WebApplet. This is based on \ref webPageCreate, for YouTubeVideo. Hence other functions referencing \ref webPageCreate also apply to this. This uses a whitelist which essentially only allows youtube embed/ URLs (without mounting content from the host Application).
##  @note This is only available on [5.0.0+].
##  @note Sets ::WebArgType_UnknownD to value 1, and sets ::WebArgType_YouTubeVideoFlag to true. Also uses \ref webConfigSetBootAsMediaPlayer with flag=true.
##  @param config WebCommonConfig object.
##  @param url Initial URL navigated to by the applet.
##

proc webOfflineCreate*(config: ptr WebCommonConfig; docKind: WebDocumentKind; id: U64;
                      docPath: cstring): Result {.cdecl, importc: "webOfflineCreate".}
## *
##  @brief Creates the config for Offline-applet. This applet uses data loaded from content.
##  @note Uses \ref webConfigSetLeftStickMode with ::WebLeftStickMode_Cursor and sets ::WebArgType_BootAsMediaPlayerInverted to false. Uses \ref webConfigSetPointer with flag = docKind == ::WebDocumentKind_OfflineHtmlPage.
##  @note For docKind ::WebDocumentKind_ApplicationLegalInformation / ::WebDocumentKind_SystemDataPage, uses \ref webConfigSetFooter with flag=true and \ref webConfigSetBackgroundKind with ::WebBackgroundKind_Default.
##  @note For docKind ::WebDocumentKind_SystemDataPage, uses \ref webConfigSetBootDisplayKind with ::WebBootDisplayKind_White.
##  @note Sets ::WebArgType_Unknown14/::WebArgType_Unknown15 to value 1. With docKind ::WebDocumentKind_ApplicationLegalInformation, uses \ref webConfigSetBootDisplayKind with ::WebBootDisplayKind_White.
##  @note Sets ::WebArgType_UnknownC to value 1.
##  @note With docKind ::WebDocumentKind_ApplicationLegalInformation, uses \ref webConfigSetEcClientCert with flag=true.
##  @note With docKind ::WebDocumentKind_OfflineHtmlPage on pre-3.0.0, sets ::WebArgType_Unknown12 to value 1.
##  @note Lastly, sets the TLVs as needed for the input params.
##  @param config WebCommonConfig object.
##  @param docKind \ref WebDocumentKind
##  @param id Id to load the content from. With docKind = ::WebDocumentKind_OfflineHtmlPage, id=0 should be used to specify the user-process application (non-zero is ignored with this docKind).
##  @param docPath Initial document path in RomFS, without the leading '/'. For ::WebDocumentKind_OfflineHtmlPage, this is relative to "html-document/" in RomFS. For the other docKind values, this is relative to "/" in RomFS. This path must contain ".htdocs/".
##

proc webShareCreate*(config: ptr WebCommonConfig; page: WebShareStartPage): Result {.
    cdecl, importc: "webShareCreate".}
## *
##  @brief Creates the config for ShareApplet. This applet is for social media posting/settings.
##  @note If a non-zero uid isn't set with \ref webConfigSetUid prior to using \ref webConfigShow, the applet will launch the profile-selector applet to select an account.
##  @note An error will be displayed if neither \ref webConfigSetAlbumEntry, nor \ref webConfigSetApplicationAlbumEntry, nor \ref webConfigAddAlbumEntryAndMediaData are used prior to using \ref webConfigShow, with ::WebShareStartPage_Default.
##  @note Uses \ref webConfigSetLeftStickMode with ::WebLeftStickMode_Cursor, \ref webConfigSetUid with uid=0, \ref webConfigSetDisplayUrlKind with kind=true, and sets ::WebArgType_Unknown14/::WebArgType_Unknown15 to value 1. Uses \ref webConfigSetBootDisplayKind with ::WebBootDisplayKind_Unknown3.
##  @param config WebCommonConfig object.
##  @param page \ref WebShareStartPage
##

proc webLobbyCreate*(config: ptr WebCommonConfig): Result {.cdecl,
    importc: "webLobbyCreate".}
## *
##  @brief Creates the config for LobbyApplet. This applet is for "Nintendo Switch Online Lounge".
##  @note Only available on [2.0.0+].
##  @note If a non-zero uid isn't set with \ref webConfigSetUid prior to using \ref webConfigShow, the applet will launch the profile-selector applet to select an account.
##  @note Uses \ref webConfigSetLeftStickMode with ::WebLeftStickMode_Cursor, \ref webConfigSetPointer with flag=false on [3.0.0+], \ref webConfigSetUid with uid=0, and sets ::WebArgType_Unknown14/::WebArgType_Unknown15 to value 1. Uses \ref webConfigSetBootDisplayKind with ::WebBootDisplayKind_Unknown4, \ref webConfigSetBackgroundKind with ::WebBackgroundKind_Unknown2, and sets ::WebArgType_BootAsMediaPlayerInverted to false.
##  @param config WebCommonConfig object.
##

proc webConfigSetCallbackUrl*(config: ptr WebCommonConfig; url: cstring): Result {.
    cdecl, importc: "webConfigSetCallbackUrl".}
## *
##  @brief Sets the CallbackUrl. See also \ref webReplyGetLastUrl.
##  @note With Offline-applet for LastUrl handling, it compares the domain with "localhost" instead.
##  @note Only available with config created by \ref webPageCreate or with Share-applet.
##  @param config WebCommonConfig object.
##  @param url URL
##

proc webConfigSetCallbackableUrl*(config: ptr WebCommonConfig; url: cstring): Result {.
    cdecl, importc: "webConfigSetCallbackableUrl".}
## *
##  @brief Sets the CallbackableUrl.
##  @note Only available with config created by \ref webPageCreate.
##  @param config WebCommonConfig object.
##  @param url URL
##

proc webConfigSetWhitelist*(config: ptr WebCommonConfig; whitelist: cstring): Result {.
    cdecl, importc: "webConfigSetWhitelist".}
## *
##  @brief Sets the whitelist.
##  @note Only available with config created by \ref webPageCreate.
##  @note If the whitelist isn't formatted properly, the applet will exit briefly after the applet is launched.
##  @param config WebCommonConfig object.
##  @param whitelist Whitelist string, each line is a regex for each whitelisted URL.
##

proc webConfigSetUid*(config: ptr WebCommonConfig; uid: AccountUid): Result {.cdecl,
    importc: "webConfigSetUid".}
## *
##  @brief Sets the account uid. Controls which user-specific savedata to mount.
##  @note Only available with config created by \ref webPageCreate, \ref webLobbyCreate, or with Share-applet.
##  @note Used automatically by \ref webShareCreate and \ref webLobbyCreate with uid=0.
##  @param config WebCommonConfig object.
##  @param uid \ref AccountUid
##

proc webConfigSetAlbumEntry*(config: ptr WebCommonConfig; entry: ptr CapsAlbumEntry): Result {.
    cdecl, importc: "webConfigSetAlbumEntry".}
## *
##  @brief Sets the Share CapsAlbumEntry.
##  @note Only available with config created by \ref webShareCreate.
##  @param config WebCommonConfig object.
##  @param entry \ref CapsAlbumEntry
##

proc webConfigSetScreenShot*(config: ptr WebCommonConfig; flag: bool): Result {.cdecl,
    importc: "webConfigSetScreenShot".}
## *
##  @brief Sets the ScreenShot flag, which controls whether screen-shot capture is allowed.
##  @note Only available with config created by \ref webPageCreate.
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetEcClientCert*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetEcClientCert".}
## *
##  @brief Sets the EcClientCert flag.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate.
##  @note Used automatically by \ref webOfflineCreate, depending on the docKind.
##  @note Used automatically by \ref webNewsCreate with flag=true.
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetPlayReport*(config: ptr WebCommonConfig; flag: bool): Result {.cdecl,
    importc: "webConfigSetPlayReport".}
## *
##  @brief Sets whether PlayReport is enabled.
##  @note Only available with config created by \ref webOfflineCreate.
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetBootDisplayKind*(config: ptr WebCommonConfig;
                                 kind: WebBootDisplayKind): Result {.cdecl,
    importc: "webConfigSetBootDisplayKind".}
## *
##  @brief Sets the BootDisplayKind.
##  @note Only available with config created by \ref webOfflineCreate, \ref webShareCreate, \ref webPageCreate, or \ref webLobbyCreate..
##  @note Used automatically by \ref webOfflineCreate, depending on the docKind.
##  @note Used automatically by \ref webShareCreate with kind=::WebBootDisplayKind_Unknown3.
##  @note Used automatically by \ref webLobbyCreate with kind=::WebBootDisplayKind_Unknown4.
##  @param config WebCommonConfig object.
##  @param kind \ref WebBootDisplayKind
##

proc webConfigSetBackgroundKind*(config: ptr WebCommonConfig;
                                kind: WebBackgroundKind): Result {.cdecl,
    importc: "webConfigSetBackgroundKind".}
## *
##  @brief Sets the BackgroundKind.
##  @note Only available with config created by \ref webOfflineCreate, \ref webPageCreate, or \ref webLobbyCreate.
##  @note Used automatically by \ref webOfflineCreate, depending on the docKind.
##  @note Used automatically by \ref webLobbyCreate with kind=2.
##  @param config WebCommonConfig object.
##  @param kind \ref WebBackgroundKind
##

proc webConfigSetFooter*(config: ptr WebCommonConfig; flag: bool): Result {.cdecl,
    importc: "webConfigSetFooter".}
## *
##  @brief Sets the whether the UI footer is enabled.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate.
##  @note Used automatically by \ref webOfflineCreate, depending on the docKind.
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetPointer*(config: ptr WebCommonConfig; flag: bool): Result {.cdecl,
    importc: "webConfigSetPointer".}
## *
##  @brief Sets the whether the Pointer is enabled. See also \ref WebLeftStickMode.
##  @note Only available with config created by \ref webOfflineCreate, \ref webPageCreate, or \ref webLobbyCreate.
##  @note Used automatically by \ref webOfflineCreate.
##  @note Used automatically by \ref webLobbyCreate with flag=false on [3.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetLeftStickMode*(config: ptr WebCommonConfig; mode: WebLeftStickMode): Result {.
    cdecl, importc: "webConfigSetLeftStickMode".}
## *
##  @brief Sets the LeftStickMode.
##  @note Only available with config created by \ref webOfflineCreate, \ref webShareCreate, \ref webPageCreate, or \ref webLobbyCreate.
##  @note Used automatically by \ref webOfflineCreate, \ref webShareCreate, and \ref webLobbyCreate with ::WebLeftStickMode_Cursor.
##  @param config WebCommonConfig object.
##  @param mode Mode, different enums for Web and Offline.
##

proc webConfigSetKeyRepeatFrame*(config: ptr WebCommonConfig; inval0: S32; inval1: S32): Result {.
    cdecl, importc: "webConfigSetKeyRepeatFrame".}
## *
##  @brief Sets the KeyRepeatFrame.
##  @note Only available with config created by \ref webOfflineCreate.
##  @param config WebCommonConfig object.
##  @param inval0 First input param.
##  @param inval1 Second input param.
##

proc webConfigSetDisplayUrlKind*(config: ptr WebCommonConfig; kind: bool): Result {.
    cdecl, importc: "webConfigSetDisplayUrlKind".}
## *
##  @brief Sets the DisplayUrlKind.
##  @note Only available with config created by \ref webShareCreate or \ref webPageCreate.
##  @param config WebCommonConfig object.
##  @note Used automatically by \ref webShareCreate with kind=true.
##  @param kind Kind
##

proc webConfigSetBootAsMediaPlayer*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetBootAsMediaPlayer".}
## *
##  @brief Sets the BootAsMediaPlayer flag.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [2.0.0+].
##  @note With config created by \ref webNewsCreate on [3.0.0+], this also sets ::WebArgType_BootAsMediaPlayerInverted to !flag.
##  @param config WebCommonConfig object.
##  @param flag Flag. true = BootAsMediaPlayer, false = BootAsWebPage.
##

proc webConfigSetShopJump*(config: ptr WebCommonConfig; flag: bool): Result {.cdecl,
    importc: "webConfigSetShopJump".}
## *
##  @brief Sets the ShopJump flag.
##  @note Only available with config created by \ref webPageCreate on [2.0.0+].
##  @note Used automatically by \ref webNewsCreate with flag=true.
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetMediaPlayerUserGestureRestriction*(config: ptr WebCommonConfig;
    flag: bool): Result {.cdecl,
                       importc: "webConfigSetMediaPlayerUserGestureRestriction".}
## *
##  @brief Sets the MediaPlayerUserGestureRestriction flag.
##  @note Only available with config created by \ref webPageCreate on [2.0.0-5.1.0].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetMediaAutoPlay*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetMediaAutoPlay".}
## *
##  @brief Sets whether MediaAutoPlay is enabled.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [6.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetLobbyParameter*(config: ptr WebCommonConfig; str: cstring): Result {.
    cdecl, importc: "webConfigSetLobbyParameter".}
## *
##  @brief Sets the LobbyParameter.
##  @note Only available with config created by \ref webLobbyCreate.
##  @param config WebCommonConfig object.
##  @param str String
##

proc webConfigSetApplicationAlbumEntry*(config: ptr WebCommonConfig;
                                       entry: ptr CapsApplicationAlbumEntry): Result {.
    cdecl, importc: "webConfigSetApplicationAlbumEntry".}
## *
##  @brief Sets the Share CapsApplicationAlbumEntry.
##  @note Only available with config created by \ref webShareCreate on [3.0.0+].
##  @param config WebCommonConfig object.
##  @param entry \ref CapsApplicationAlbumEntry, see also capssu.h.
##

proc webConfigSetJsExtension*(config: ptr WebCommonConfig; flag: bool): Result {.cdecl,
    importc: "webConfigSetJsExtension".}
## *
##  @brief Sets whether JsExtension is enabled.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [3.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetAdditionalCommentText*(config: ptr WebCommonConfig; str: cstring): Result {.
    cdecl, importc: "webConfigSetAdditionalCommentText".}
## *
##  @brief Sets the Share AdditionalCommentText.
##  @note Only available with config created by \ref webShareCreate on [4.0.0+].
##  @param config WebCommonConfig object.
##  @param str String
##

proc webConfigSetTouchEnabledOnContents*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetTouchEnabledOnContents".}
## *
##  @brief Sets the TouchEnabledOnContents flag.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [4.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetUserAgentAdditionalString*(config: ptr WebCommonConfig;
    str: cstring): Result {.cdecl, importc: "webConfigSetUserAgentAdditionalString".}
## *
##  @brief Sets the UserAgentAdditionalString. " " followed by this string are appended to the normal User-Agent string.
##  @note Only available with config created by \ref webPageCreate on [4.0.0+].
##  @param config WebCommonConfig object.
##  @param str String
##

proc webConfigSetAdditionalMediaData*(config: ptr WebCommonConfig; data: ptr U8;
                                     size: csize_t): Result {.cdecl,
    importc: "webConfigSetAdditionalMediaData".}
## *
##  @brief Sets the Share AdditionalMediaData.
##  @note Only available with config created by \ref webShareCreate on [4.0.0+].
##  @param config WebCommonConfig object.
##  @param data Input data
##  @param size Size of the input data, max size is 0x10.
##

proc webConfigSetMediaPlayerAutoClose*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetMediaPlayerAutoClose".}
## *
##  @brief Sets the MediaPlayerAutoClose flag.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [4.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetPageCache*(config: ptr WebCommonConfig; flag: bool): Result {.cdecl,
    importc: "webConfigSetPageCache".}
## *
##  @brief Sets whether PageCache is enabled.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [4.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetWebAudio*(config: ptr WebCommonConfig; flag: bool): Result {.cdecl,
    importc: "webConfigSetWebAudio".}
## *
##  @brief Sets whether WebAudio is enabled.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [4.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetFooterFixedKind*(config: ptr WebCommonConfig;
                                 kind: WebFooterFixedKind): Result {.cdecl,
    importc: "webConfigSetFooterFixedKind".}
## *
##  @brief Sets the FooterFixedKind.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [5.0.0+].
##  @param config WebCommonConfig object.
##  @param kind \ref WebFooterFixedKind
##

proc webConfigSetPageFade*(config: ptr WebCommonConfig; flag: bool): Result {.cdecl,
    importc: "webConfigSetPageFade".}
## *
##  @brief Sets the PageFade flag.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [5.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetMediaCreatorApplicationRatingAge*(config: ptr WebCommonConfig;
    data: ptr S8): Result {.cdecl,
                        importc: "webConfigSetMediaCreatorApplicationRatingAge".}
## *
##  @brief Sets the Share MediaCreatorApplicationRatingAge.
##  @note Only available with config created by \ref webShareCreate on [5.0.0+].
##  @param config WebCommonConfig object.
##  @param data 0x20-byte input data
##

proc webConfigSetBootLoadingIcon*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetBootLoadingIcon".}
## *
##  @brief Sets the BootLoadingIcon flag.
##  @note Only available with config created by \ref webOfflineCreate on [5.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetPageScrollIndicator*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetPageScrollIndicator".}
## *
##  @brief Sets the PageScrollIndicator flag.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [5.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetMediaPlayerSpeedControl*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetMediaPlayerSpeedControl".}
## *
##  @brief Sets whether MediaPlayerSpeedControl is enabled.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [6.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigAddAlbumEntryAndMediaData*(config: ptr WebCommonConfig;
                                        entry: ptr CapsAlbumEntry; data: ptr U8;
                                        size: csize_t): Result {.cdecl,
    importc: "webConfigAddAlbumEntryAndMediaData".}
## *
##  @brief Adds a pair of Share CapsAlbumEntry + optionally AdditionalMediaData. This can be used up to 4 times, for setting multiple pairs.
##  @note Only available with config created by \ref webShareCreate on [6.0.0+].
##  @param config WebCommonConfig object.
##  @param entry \ref CapsAlbumEntry
##  @param data Input data for AdditionalMediaData. Optional, can be NULL.
##  @param size Size of the input data, max size is 0x10. Optional, can be 0.
##

proc webConfigSetBootFooterButtonVisible*(config: ptr WebCommonConfig;
    button: WebFooterButtonId; visible: bool): Result {.cdecl,
    importc: "webConfigSetBootFooterButtonVisible".}
## *
##  @brief Sets whether the specified BootFooterButton is visible.
##  @note Only available with config created by \ref webOfflineCreate on [6.0.0+].
##  @param config WebCommonConfig object.
##  @param button \ref WebFooterButtonId
##  @param visible Visible flag.
##

proc webConfigSetOverrideWebAudioVolume*(config: ptr WebCommonConfig; value: cfloat): Result {.
    cdecl, importc: "webConfigSetOverrideWebAudioVolume".}
## *
##  @brief Sets OverrideWebAudioVolume.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [6.0.0+].
##  @param config WebCommonConfig object.
##  @param value Value
##

proc webConfigSetOverrideMediaAudioVolume*(config: ptr WebCommonConfig;
    value: cfloat): Result {.cdecl, importc: "webConfigSetOverrideMediaAudioVolume".}
## *
##  @brief Sets OverrideMediaAudioVolume.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [6.0.0+].
##  @param config WebCommonConfig object.
##  @param value Value
##

proc webConfigSetBootMode*(config: ptr WebCommonConfig; mode: WebSessionBootMode): Result {.
    cdecl, importc: "webConfigSetBootMode".}
## *
##  @brief Sets \ref WebSessionBootMode.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [7.0.0+].
##  @param config WebCommonConfig object.
##  @param mode \ref WebSessionBootMode
##

proc webConfigSetMediaPlayerUi*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetMediaPlayerUi".}
## *
##  @brief Sets whether MediaPlayerUi is enabled.
##  @note Only available with config created by \ref webOfflineCreate on [8.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigSetTransferMemory*(config: ptr WebCommonConfig; flag: bool): Result {.
    cdecl, importc: "webConfigSetTransferMemory".}
## *
##  @brief Sets whether TransferMemory is enabled.
##  @note Only available with config created by \ref webPageCreate on [11.0.0+].
##  @param config WebCommonConfig object.
##  @param flag Flag
##

proc webConfigShow*(config: ptr WebCommonConfig; `out`: ptr WebCommonReply): Result {.
    cdecl, importc: "webConfigShow".}
## *
##  @brief Launches the {web applet} with the specified config and waits for it to exit.
##  @param config WebCommonConfig object.
##  @param out Optional output applet reply data, can be NULL.
##

proc webConfigRequestExit*(config: ptr WebCommonConfig): Result {.cdecl,
    importc: "webConfigRequestExit".}
## *
##  @brief Request the applet to exit after \ref webConfigShow was used, while the applet is still running. This is for use from another thread.
##  @param config WebCommonConfig object.
##

proc webReplyGetExitReason*(reply: ptr WebCommonReply; exitReason: ptr WebExitReason): Result {.
    cdecl, importc: "webReplyGetExitReason".}
## *
##  @brief Gets the ExitReason from the specified reply.
##  @param reply WebCommonReply object.
##  @param exitReason Output \ref WebExitReason
##

proc webReplyGetLastUrl*(reply: ptr WebCommonReply; outstr: cstring;
                        outstrMaxsize: csize_t; outSize: ptr csize_t): Result {.cdecl,
    importc: "webReplyGetLastUrl".}
## *
##  @brief Gets the LastUrl from the specified reply. When the applet loads a page where the beginning of the URL matches the URL from \ref webConfigSetCallbackUrl, the applet will exit and set LastUrl to that URL (exit doesn't occur when \ref webConfigSetCallbackableUrl was used).
##  @note This is only available with ::WebExitReason_LastUrl (string is empty otherwise).
##  @note If you want to allocate a string buffer on heap, you can call this with outstr=NULL/outstr_maxsize=0 to get the out_size, then call it again with the allocated buffer.
##  @param reply WebCommonReply object.
##  @param outstr Output string buffer. If NULL, the string is not loaded.
##  @param outstr_maxsize Size of the buffer, including NUL-terminator. If outstr is set, this size must be >1. The size used for the actual string-copy is this size-1, to make sure the output is NUL-terminated (the entire buffer is cleared first).
##  @param out_size Output string length including NUL-terminator, for the original input string in the reply loaded from a separate size field.
##

proc webReplyGetSharePostResult*(reply: ptr WebCommonReply; sharePostResult: ptr U32): Result {.
    cdecl, importc: "webReplyGetSharePostResult".}
## *
##  @brief Gets the SharePostResult from the specified reply.
##  @note Only available with reply data from ShareApplet on [3.0.0+].
##  @param reply WebCommonReply object.
##  @param sharePostResult Output sharePostResult
##

proc webReplyGetPostServiceName*(reply: ptr WebCommonReply; outstr: cstring;
                                outstrMaxsize: csize_t; outSize: ptr csize_t): Result {.
    cdecl, importc: "webReplyGetPostServiceName".}
## *
##  @brief Gets the PostServiceName from the specified reply.
##  @note Only available with reply data from ShareApplet on [3.0.0+].
##  @note If you want to allocate a string buffer on heap, you can call this with outstr=NULL/outstr_maxsize=0 to get the out_size, then call it again with the allocated buffer.
##  @param reply WebCommonReply object.
##  @param outstr Output string buffer. If NULL, the string is not loaded.
##  @param outstr_maxsize Size of the buffer, including NUL-terminator. If outstr is set, this size must be >1. The size used for the actual string-copy is this size-1, to make sure the output is NUL-terminated (the entire buffer is cleared first).
##  @param out_size Output string length including NUL-terminator, for the original input string in the reply loaded from a separate size field.
##

proc webReplyGetPostId*(reply: ptr WebCommonReply; outstr: cstring;
                       outstrMaxsize: csize_t; outSize: ptr csize_t): Result {.cdecl,
    importc: "webReplyGetPostId".}
## *
##  @brief Gets the PostId from the specified reply.
##  @note Only available with reply data from ShareApplet on [3.0.0+].
##  @note If you want to allocate a string buffer on heap, you can call this with outstr=NULL/outstr_maxsize=0 to get the out_size, then call it again with the allocated buffer.
##  @param reply WebCommonReply object.
##  @param outstr Output string buffer. If NULL, the string is not loaded.
##  @param outstr_maxsize Size of the buffer, including NUL-terminator. If outstr is set, this size must be >1. The size used for the actual string-copy is this size-1, to make sure the output is NUL-terminated (the entire buffer is cleared first).
##  @param out_size Output string length including NUL-terminator, for the original input string in the reply loaded from a separate size field.
##

proc webReplyGetMediaPlayerAutoClosedByCompletion*(reply: ptr WebCommonReply;
    flag: ptr bool): Result {.cdecl, importc: "webReplyGetMediaPlayerAutoClosedByCompletion".}
## *
##  @brief Gets the MediaPlayerAutoClosedByCompletion flag from the specified reply.
##  @note Only available with reply data from Web on [8.0.0+].
##  @param reply WebCommonReply object.
##  @param flag Output flag
##

proc webSessionCreate*(s: ptr WebSession; config: ptr WebCommonConfig) {.cdecl,
    importc: "webSessionCreate".}
## *
##  @brief Creates a \ref WebSession object.
##  @param s \ref WebSession
##  @param config WebCommonConfig object.
##

proc webSessionClose*(s: ptr WebSession) {.cdecl, importc: "webSessionClose".}
## *
##  @brief Closes a \ref WebSession object.
##  @param s \ref WebSession
##

proc webSessionStart*(s: ptr WebSession; outEvent: ptr ptr Event): Result {.cdecl,
    importc: "webSessionStart".}
## *
##  @brief Launches the applet for \ref WebSession.
##  @note Only available with config created by \ref webOfflineCreate or \ref webPageCreate, on [7.0.0+].
##  @note Do not use \ref webConfigShow when using WebSession.
##  @param s \ref WebSession
##  @param[out] out_event Output Event with autoclear=false, from \ref appletHolderGetExitEvent. Optional, can be NULL.
##

proc webSessionWaitForExit*(s: ptr WebSession; `out`: ptr WebCommonReply): Result {.
    cdecl, importc: "webSessionWaitForExit".}
## *
##  @brief Waits for the applet to exit.
##  @note This must be used before \ref webSessionClose, when \ref webSessionStart was used successfully.
##  @param s \ref WebSession
##  @param out Optional output applet reply data, can be NULL.
##

proc webSessionRequestExit*(s: ptr WebSession): Result {.cdecl,
    importc: "webSessionRequestExit".}
## *
##  @brief Request the applet to exit.
##  @note Use this instead of \ref webConfigRequestExit, when using WebSession.
##  @param s \ref WebSession
##

proc webSessionAppear*(s: ptr WebSession; flag: ptr bool): Result {.cdecl,
    importc: "webSessionAppear".}
## *
##  @brief Request the applet to Appear, this is only needed with ::WebSessionBootMode_AllForegroundInitiallyHidden.
##  @note This should not be used before \ref webSessionStart.
##  @param s \ref WebSession
##  @param[out] flag Whether the message was sent successfully.
##

proc webSessionTrySendContentMessage*(s: ptr WebSession; content: cstring; size: U32;
                                     flag: ptr bool): Result {.cdecl,
    importc: "webSessionTrySendContentMessage".}
## *
##  @brief TrySendContentMessage
##  @note This should not be used before \ref webSessionStart.
##  @note The JS-side for this is only available when JsExtension is enabled via \ref webConfigSetJsExtension.
##  @note The JS-side may ignore this if it's sent too soon after the applet launches.
##  @param s \ref WebSession
##  @param[in] content Input content NUL-terminated string.
##  @param[in] size Size of content.
##  @param[out] flag Whether the message was sent successfully.
##

proc webSessionTryReceiveContentMessage*(s: ptr WebSession; content: cstring;
                                        size: U64; outSize: ptr U64; flag: ptr bool): Result {.
    cdecl, importc: "webSessionTryReceiveContentMessage".}
## *
##  @brief TryReceiveContentMessage
##  @note This should not be used before \ref webSessionStart.
##  @note The JS-side for this is only available when JsExtension is enabled via \ref webConfigSetJsExtension.
##  @param s \ref WebSession
##  @param[out] content Output content string, always NUL-terminated.
##  @param[in] size Max size of content.
##  @param[out] out_size Original content size, prior to being clamped to the specified size param.
##  @param[out] flag Whether the message was received successfully.
##

