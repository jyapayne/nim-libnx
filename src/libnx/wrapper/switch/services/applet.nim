## *
##  @file applet.h
##  @brief Applet (applet) service IPC wrapper.
##  @note For wrappers which launch LibraryApplets etc, see switch/applets/.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/apm, ../services/pdm, ../services/caps,
  ../services/pm, ../services/ncm_types, ../services/acc, ../services/set,
  ../kernel/tmem, ../kernel/event, ../nacp

## / AppletType

type
  AppletType* = enum
    AppletTypeNone = -2, AppletTypeDefault = -1, AppletTypeApplication = 0,
    AppletTypeSystemApplet = 1, AppletTypeLibraryApplet = 2,
    AppletTypeOverlayApplet = 3, AppletTypeSystemApplication = 4


## / OperationMode

type
  AppletOperationMode* = enum
    AppletOperationModeHandheld = 0, ## /< Handheld
    AppletOperationModeConsole = 1 ## /< Console (Docked / TV-mode)


## / applet hook types.

type
  AppletHookType* = enum
    AppletHookTypeOnFocusState = 0, ## /< ::AppletMessage_FocusStateChanged
    AppletHookTypeOnOperationMode, ## /< ::AppletMessage_OperationModeChanged
    AppletHookTypeOnPerformanceMode, ## /< ::AppletMessage_PerformanceModeChanged
    AppletHookTypeOnExitRequest, ## /< ::AppletMessage_ExitRequested
    AppletHookTypeOnResume,   ## /< ::AppletMessage_Resume
    AppletHookTypeOnCaptureButtonShortPressed, ## /< ::AppletMessage_CaptureButtonShortPressed
    AppletHookTypeOnAlbumScreenShotTaken, ## /< ::AppletMessage_AlbumScreenShotTaken
    AppletHookTypeRequestToDisplay, ## /< ::AppletMessage_RequestToDisplay
    AppletHookTypeMax         ## /< Number of applet hook types.


## / AppletMessage, for \ref appletGetMessage. See also \ref AppletHookType.

type
  AppletMessage* = enum
    AppletMessageExitRequest = 4, ## /< Exit request.
    AppletMessageFocusStateChanged = 15, ## /< FocusState changed.
    AppletMessageResume = 16,   ## /< Current applet execution was resumed.
    AppletMessageOperationModeChanged = 30, ## /< OperationMode changed.
    AppletMessagePerformanceModeChanged = 31, ## /< PerformanceMode changed.
    AppletMessageRequestToDisplay = 51, ## /< Display requested, see \ref appletApproveToDisplay.
    AppletMessageCaptureButtonShortPressed = 90, ## /< Capture button was short-pressed.
    AppletMessageAlbumScreenShotTaken = 92, ## /< Screenshot was taken.
    AppletMessageAlbumRecordingSaved = 93 ## /< AlbumRecordingSaved


## / FocusState

type
  AppletFocusState* = enum
    AppletFocusStateInFocus = 1, ## /< Applet is focused.
    AppletFocusStateOutOfFocus = 2, ## /< Out of focus - LibraryApplet open.
    AppletFocusStateBackground = 3 ## /< Out of focus - HOME menu open / console is sleeping.


## / FocusHandlingMode

type
  AppletFocusHandlingMode* = enum
    AppletFocusHandlingModeSuspendHomeSleep = 0, ## /< Suspend only when HOME menu is open / console is sleeping (default).
    AppletFocusHandlingModeNoSuspend, ## /< Don't suspend when out of focus.
    AppletFocusHandlingModeSuspendHomeSleepNotify, ## /< Suspend only when HOME menu is open / console is sleeping but still receive OnFocusState hook.
    AppletFocusHandlingModeAlwaysSuspend, ## /< Always suspend when out of focus, regardless of the reason.
    AppletFocusHandlingModeMax ## /< Number of focus handling modes.


## / LaunchParameterKind

type
  AppletLaunchParameterKind* = enum
    AppletLaunchParameterKindUserChannel = 1, ## /< UserChannel. Application-specific LaunchParameter.
    AppletLaunchParameterKindPreselectedUser = 2, ## /< account PreselectedUser
    AppletLaunchParameterKindUnknown = 3 ## /< Unknown if used by anything?


## / AppletId

type
  AppletId* = enum
    AppletIdNone = 0x00,        ## /<                  None
    AppletIdApplication = 0x01, ## /<                  Application. Not valid for use with LibraryApplets.
    AppletIdOverlayApplet = 0x02, ## /< 010000000000100C "overlayDisp"
    AppletIdSystemAppletMenu = 0x03, ## /< 0100000000001000 "qlaunch" (SystemAppletMenu)
    AppletIdSystemApplication = 0x04, ## /< 0100000000001012 "starter" SystemApplication.
    AppletIdLibraryAppletAuth = 0x0A, ## /< 0100000000001001 "auth"
    AppletIdLibraryAppletCabinet = 0x0B, ## /< 0100000000001002 "cabinet"
    AppletIdLibraryAppletController = 0x0C, ## /< 0100000000001003 "controller"
    AppletIdLibraryAppletDataErase = 0x0D, ## /< 0100000000001004 "dataErase"
    AppletIdLibraryAppletError = 0x0E, ## /< 0100000000001005 "error"
    AppletIdLibraryAppletNetConnect = 0x0F, ## /< 0100000000001006 "netConnect"
    AppletIdLibraryAppletPlayerSelect = 0x10, ## /< 0100000000001007 "playerSelect"
    AppletIdLibraryAppletSwkbd = 0x11, ## /< 0100000000001008 "swkbd"
    AppletIdLibraryAppletMiiEdit = 0x12, ## /< 0100000000001009 "miiEdit"
    AppletIdLibraryAppletWeb = 0x13, ## /< 010000000000100A "LibAppletWeb" WebApplet applet
    AppletIdLibraryAppletShop = 0x14, ## /< 010000000000100B "LibAppletShop" ShopN applet
    AppletIdLibraryAppletPhotoViewer = 0x15, ## /< 010000000000100D "photoViewer"
    AppletIdLibraryAppletSet = 0x16, ## /< 010000000000100E "set" (This applet is currently not present on retail devices.)
    AppletIdLibraryAppletOfflineWeb = 0x17, ## /< 010000000000100F "LibAppletOff" offlineWeb applet
    AppletIdLibraryAppletLoginShare = 0x18, ## /< 0100000000001010 "LibAppletLns" loginShare web-applet
    AppletIdLibraryAppletWifiWebAuth = 0x19, ## /< 0100000000001011 "LibAppletAuth" wifiWebAuth applet
    AppletIdLibraryAppletMyPage = 0x1A ## /< 0100000000001013 "myPage"


## / LibraryAppletMode

type
  LibAppletMode* = enum
    LibAppletModeAllForeground = 0, ## /< Foreground.
    LibAppletModeBackground = 1, ## /< Background.
    LibAppletModeNoUi = 2,      ## /< No UI.
    LibAppletModeBackgroundIndirect = 3, ## /< Background with indirect display, see \ref appletHolderGetIndirectLayerConsumerHandle.
    LibAppletModeAllForegroundInitiallyHidden = 4 ## /< Foreground except initially hidden.


## / LibraryAppletExitReason

type
  LibAppletExitReason* = enum
    LibAppletExitReasonNormal = 0, LibAppletExitReasonCanceled = 1,
    LibAppletExitReasonAbnormal = 2, LibAppletExitReasonUnexpected = 10


## / AppletApplicationExitReason

type
  AppletApplicationExitReason* = enum
    AppletApplicationExitReasonNormal = 0, AppletApplicationExitReasonUnknown1 = 1,
    AppletApplicationExitReasonUnknown2 = 2,
    AppletApplicationExitReasonUnknown3 = 3,
    AppletApplicationExitReasonUnknown4 = 4,
    AppletApplicationExitReasonUnknown5 = 5,
    AppletApplicationExitReasonUnexpected = 100


## / ThemeColorType

type
  AppletThemeColorType* = enum
    AppletThemeColorTypeDefault = 0, AppletThemeColorTypeUnknown1 = 1,
    AppletThemeColorTypeUnknown2 = 2, AppletThemeColorTypeUnknown3 = 3


## / Mode values for \ref appletSetTvPowerStateMatchingMode.

type
  AppletTvPowerStateMatchingMode* = enum
    AppletTvPowerStateMatchingModeUnknown0 = 0, ## /< Unknown.
    AppletTvPowerStateMatchingModeUnknown1 = 1 ## /< Unknown.


## / Type values for \ref appletPerformSystemButtonPressingIfInFocus.

type
  AppletSystemButtonType* = enum
    AppletSystemButtonTypeHomeButtonShortPressing = 1, ## /< Short-pressing with the HOME-button.
    AppletSystemButtonTypeHomeButtonLongPressing = 2, ## /< Long-pressing with the HOME-button.
    AppletSystemButtonTypePowerButtonShortPressing = 3, ## /< Short-pressing with the Power-button. Only available with \ref appletPerformSystemButtonPressing.
    AppletSystemButtonTypePowerButtonLongPressing = 4, ## /< Long-pressing with the Power-button. Only available with \ref appletPerformSystemButtonPressing.
    AppletSystemButtonTypeShutdown = 5, ## /< Shutdown the system, as if the Power-button was held for longer than ::AppletSystemButtonType_PowerButtonLongPressing. Only available with \ref appletPerformSystemButtonPressing.
    AppletSystemButtonTypeCaptureButtonShortPressing = 6, ## /< Short-pressing with the Capture-button.
    AppletSystemButtonTypeCaptureButtonLongPressing = 7 ## /< Long-pressing with the Capture-button.


## / Permission values for \ref appletSetScreenShotPermission.

type
  AppletScreenShotPermission* = enum
    AppletScreenShotPermissionInherit = 0, ## /< Inherit from parent applet.
    AppletScreenShotPermissionEnable = 1, ## /< Enable.
    AppletScreenShotPermissionDisable = 2 ## /< Disable.


## / Extension values for \ref appletSetIdleTimeDetectionExtension / \ref appletGetIdleTimeDetectionExtension, for extending user inactivity detection.

type
  AppletIdleTimeDetectionExtension* = enum
    AppletIdleTimeDetectionExtensionNone = 0, ## /< No extension.
    AppletIdleTimeDetectionExtensionExtended = 1, ## /< Extended
    AppletIdleTimeDetectionExtensionExtendedUnsafe = 2 ## /< ExtendedUnsafe


## / Input policy values for \ref appletSetInputDetectionPolicy.

type
  AppletInputDetectionPolicy* = enum
    AppletInputDetectionPolicyUnknown0 = 0, ## /< Unknown.
    AppletInputDetectionPolicyUnknown1 = 1 ## /< Unknown.


## / Input mode values for \ref appletSetWirelessPriorityMode.

type
  AppletWirelessPriorityMode* = enum
    AppletWirelessPriorityModeDefault = 1, ## /< Default
    AppletWirelessPriorityModeOptimizedForWlan = 2 ## /< OptimizedForWlan


## / CaptureSharedBuffer for the IDisplayController commands.

type
  AppletCaptureSharedBuffer* = enum
    AppletCaptureSharedBufferLastApplication = 0, ## /< LastApplication
    AppletCaptureSharedBufferLastForeground = 1, ## /< LastForeground
    AppletCaptureSharedBufferCallerApplet = 2 ## /< CallerApplet


## / WindowOriginMode

type
  AppletWindowOriginMode* = enum
    AppletWindowOriginModeLowerLeft = 0, ## /< LowerLeft
    AppletWindowOriginModeUpperLeft = 1 ## /< UpperLeft


## / ProgramSpecifyKind for the ExecuteProgram cmd. Controls the type of the u64 passed to the ExecuteProgram cmd.

type
  AppletProgramSpecifyKind* = enum
    AppletProgramSpecifyKindExecuteProgram = 0, ## /< u8 ProgramIndex.
    AppletProgramSpecifyKindJumpToSubApplicationProgramForDevelopment = 1, ## /< u64 application_id. Only available when DebugMode is enabled.
    AppletProgramSpecifyKindRestartProgram = 2 ## /< u64 = value 0.


## / applet hook function.

type
  AppletHookFn* = proc (hook: AppletHookType; param: pointer) {.cdecl.}

## / applet hook cookie.

type
  AppletHookCookie* {.bycopy.} = object
    next*: ptr AppletHookCookie ## /< Next cookie.
    callback*: AppletHookFn    ## /< Hook callback.
    param*: pointer            ## /< Callback parameter.


## / LockAccessor

type
  AppletLockAccessor* {.bycopy.} = object
    s*: Service                ## /< ILockAccessor
    event*: Event              ## /< Event from the GetEvent cmd, with autoclear=false.


## / applet IStorage

type
  AppletStorage* {.bycopy.} = object
    s*: Service                ## /< IStorage
    tmem*: TransferMemory      ## /< TransferMemory


## / LibraryApplet state.

type
  AppletHolder* {.bycopy.} = object
    s*: Service                ## /< ILibraryAppletAccessor
    stateChangedEvent*: Event  ## /< Output from GetAppletStateChangedEvent, autoclear=false.
    popInteractiveOutDataEvent*: Event ## /< Output from GetPopInteractiveOutDataEvent, autoclear=false.
    mode*: LibAppletMode       ## /< See ref \ref LibAppletMode.
    layerHandle*: U64          ## /< Output from GetIndirectLayerConsumerHandle on [2.0.0+].
    creatingSelf*: bool        ## /< When set, indicates that the LibraryApplet is creating itself.
    exitreason*: LibAppletExitReason ## /< Set by \ref appletHolderJoin using the output from cmd GetResult, see \ref LibAppletExitReason.


## / IApplicationAccessor container.

type
  AppletApplication* {.bycopy.} = object
    s*: Service                ## /< IApplicationAccessor
    stateChangedEvent*: Event  ## /< Output from GetAppletStateChangedEvent, autoclear=false.
    exitreason*: AppletApplicationExitReason ## /< Set by \ref appletApplicationJoin using the output from cmd GetResult, see \ref AppletApplicationExitReason.


## / GpuErrorHandler

type
  AppletGpuErrorHandler* {.bycopy.} = object
    s*: Service                ## /< IGpuErrorHandler


## / Used by \ref appletInitialize with __nx_applet_AppletAttribute for cmd OpenLibraryAppletProxy (AppletType_LibraryApplet), on [3.0.0+]. The default for this struct is all-zero.

type
  AppletAttribute* {.bycopy.} = object
    flag*: U8                  ## /< Flag. When non-zero, two state fields are set to 1.
    reserved*: array[0x7F, U8]  ## /< Unused.


## / LibraryAppletInfo

type
  LibAppletInfo* {.bycopy.} = object
    appletId*: AppletId        ## /< \ref AppletId
    mode*: LibAppletMode       ## /< \ref LibAppletMode


## / AppletProcessLaunchReason, from GetLaunchReason.

type
  AppletProcessLaunchReason* {.bycopy.} = object
    flag*: U8                  ## /< When non-zero, indicates that OpenCallingLibraryApplet should be used.
    unkX1*: array[3, U8]        ## /< Always zero.


## / Cached info for the current LibraryApplet, from \ref appletGetAppletInfo.

type
  AppletInfo* {.bycopy.} = object
    info*: LibAppletInfo       ## /< Output from \ref appletGetLibraryAppletInfo.
    callerFlag*: bool          ## /< Loaded from AppletProcessLaunchReason::flag, indicates that the below AppletHolder is initialized.
    caller*: AppletHolder      ## /< \ref AppletHolder for the CallingLibraryApplet, automatically closed by \ref appletExit when needed.


## / IdentityInfo

type
  AppletIdentityInfo* {.bycopy.} = object
    appletId*: AppletId        ## /< \ref AppletId
    pad*: U32                  ## /< Padding.
    applicationId*: U64        ## /< ApplicationId, only set with appletId == ::AppletId_application.


## / Attributes for launching applications for Quest.

type
  AppletApplicationAttributeForQuest* {.bycopy.} = object
    unkX0*: U32                ## /< See AppletApplicationAttribute::unk_x0.
    unkX4*: U32                ## /< See AppletApplicationAttribute::unk_x4.
    volume*: cfloat            ## /< [7.0.0+] See AppletApplicationAttribute::volume.


## / ApplicationAttribute

type
  AppletApplicationAttribute* {.bycopy.} = object
    unkX0*: U32                ## /< Default is 0 for non-Quest. Only used when non-zero: unknown value in seconds.
    unkX4*: U32                ## /< Default is 0 for non-Quest. Only used when non-zero: unknown value in seconds.
    volume*: cfloat            ## /< Audio volume. Must be in the range of 0.0f-1.0f. The default is 1.0f.
    unused*: array[0x14, U8]    ## /< Unused. Default is 0.


## / ApplicationLaunchProperty

type
  AppletApplicationLaunchProperty* {.bycopy.} = object
    applicationId*: U64        ## /< ApplicationId.
    version*: U32              ## /< Application version.
    appStorageId*: U8          ## /< \ref NcmStorageId for the Application.
    updateStorageId*: U8       ## /< \ref NcmStorageId for the Application update.
    unkXa*: U8                 ## /< Unknown.
    pad*: U8                   ## /< Padding.


## / ApplicationLaunchRequestInfo

type
  AppletApplicationLaunchRequestInfo* {.bycopy.} = object
    unkX0*: U32                ## /< Unknown. The default is 0x0 with \ref appletCreateSystemApplication, 0x3 with \ref appletCreateApplication.
    unkX4*: U32                ## /< Unknown. The default is 0x0 with \ref appletCreateSystemApplication, 0x3 with \ref appletCreateApplication.
    unkX8*: array[0x8, U8]      ## /< Unknown. The default is 0x0.


## / AppletResourceUsageInfo, from \ref appletGetAppletResourceUsageInfo.

type
  AppletResourceUsageInfo* {.bycopy.} = object
    counter0*: U32             ## /< Unknown counter.
    counter1*: U32             ## /< Unknown counter.
    counter2*: U32             ## /< Output from ns cmd GetRightsEnvironmentCountForDebug.
    unused*: array[0x14, U8]    ## /< Always zero.

proc appletInitialize*(): Result {.cdecl, importc: "appletInitialize".}
## / Initialize applet, called automatically during app startup.

proc appletExit*() {.cdecl, importc: "appletExit".}
## / Exit applet, called automatically during app exit.

proc appletGetServiceSessionProxy*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_Proxy".}
## / Gets the Service object for the actual "appletOE"/"appletAE" service session.

proc appletGetServiceSessionAppletCommonFunctions*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_AppletCommonFunctions".}
## / Gets the Service object for IAppletCommonFunctions. Only initialized with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [7.0.0+].

proc appletGetServiceSessionFunctions*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_Functions".}
## / Gets the Service object for I*Functions, specific to each AppletType (IApplicationFunctions for AppletType_*Application). Not initialized with AppletType_LibraryApplet pre-15.0.0. On [15.0.0+] with AppletType_LibraryApplet this returns the object for IHomeMenuFunctions.

proc appletGetServiceSessionGlobalStateController*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_GlobalStateController".}
## / Gets the Service object for IGlobalStateController. Only initialized with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.

proc appletGetServiceSessionApplicationCreator*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_ApplicationCreator".}
## / Gets the Service object for IApplicationCreator. Only initialized with AppletType_SystemApplet.

proc appletGetServiceSessionLibraryAppletSelfAccessor*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_LibraryAppletSelfAccessor".}
## / Gets the Service object for ILibraryAppletSelfAccessor. Only initialized with AppletType_LibraryApplet.

proc appletGetServiceSessionProcessWindingController*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_ProcessWindingController".}
## / Gets the Service object for IProcessWindingController. Only initialized with AppletType_LibraryApplet.

proc appletGetServiceSessionLibraryAppletCreator*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_LibraryAppletCreator".}
## / Gets the Service object for ILibraryAppletCreator.

proc appletGetServiceSessionCommonStateGetter*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_CommonStateGetter".}
## / Gets the Service object for ICommonStateGetter.

proc appletGetServiceSessionSelfController*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_SelfController".}
## / Gets the Service object for ISelfController.

proc appletGetServiceSessionWindowController*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_WindowController".}
## / Gets the Service object for IWindowController.

proc appletGetServiceSessionAudioController*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_AudioController".}
## / Gets the Service object for IAudioController.

proc appletGetServiceSessionDisplayController*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_DisplayController".}
## / Gets the Service object for IDisplayController.

proc appletGetServiceSessionDebugFunctions*(): ptr Service {.cdecl,
    importc: "appletGetServiceSession_DebugFunctions".}
## / Gets the Service object for IDebugFunctions.

proc appletGetAppletResourceUserId*(): U64 {.cdecl,
    importc: "appletGetAppletResourceUserId".}
## / Get the cached AppletResourceUserId.

proc appletGetAppletType*(): AppletType {.cdecl, importc: "appletGetAppletType".}
## / Get the \ref AppletType.

proc appletSetThemeColorType*(theme: AppletThemeColorType) {.cdecl,
    importc: "appletSetThemeColorType".}
## / Sets the state field for \ref AppletThemeColorType.

proc appletGetThemeColorType*(): AppletThemeColorType {.cdecl,
    importc: "appletGetThemeColorType".}
## / Gets the state field for \ref AppletThemeColorType. Used internally by \ref libappletArgsCreate.

proc appletGetCradleStatus*(status: ptr U8): Result {.cdecl,
    importc: "appletGetCradleStatus".}
## /@name ICommonStateGetter
## /@{
## *
##  @brief Gets the CradleStatus.
##  @param[out] status Output Dock status.
##

proc appletGetBootMode*(mode: ptr PmBootMode): Result {.cdecl,
    importc: "appletGetBootMode".}
## *
##  @brief Gets the BootMode which originated from \ref pmbmGetBootMode.
##  @param[out] mode \ref PmBootMode
##

proc appletRequestToAcquireSleepLock*(): Result {.cdecl,
    importc: "appletRequestToAcquireSleepLock".}
## *
##  @brief Request to AcquireSleepLock.
##  @note On success, this then uses cmd GetAcquiredSleepLockEvent and waits on that event.
##

proc appletReleaseSleepLock*(): Result {.cdecl, importc: "appletReleaseSleepLock".}
## *
##  @brief Release the SleepLock.
##

proc appletReleaseSleepLockTransiently*(): Result {.cdecl,
    importc: "appletReleaseSleepLockTransiently".}
## *
##  @brief Release the SleepLock transiently.
##  @note On success, this then uses cmd GetAcquiredSleepLockEvent and waits on that event.
##

proc appletGetWakeupCount*(`out`: ptr U64): Result {.cdecl,
    importc: "appletGetWakeupCount".}
## *
##  @brief GetWakeupCount
##  @note Only available with [11.0.0+].
##  @param[out] out Output value.
##

proc appletPushToGeneralChannel*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPushToGeneralChannel".}
## *
##  @brief Pushes a storage to the general channel. Used for sending requests to SystemApplet.
##  @note  This is not usable under an Application, however it is usable under a LibraryApplet.
##  @note  This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##

proc appletGetHomeButtonReaderLockAccessor*(a: ptr AppletLockAccessor): Result {.
    cdecl, importc: "appletGetHomeButtonReaderLockAccessor".}
## *
##  @brief Gets a \ref AppletLockAccessor for HomeButtonReader.
##  @note Similar to using \ref appletGetReaderLockAccessorEx with inval=0.
##  @param a LockAccessor object.
##

proc appletGetReaderLockAccessorEx*(a: ptr AppletLockAccessor; inval: U32): Result {.
    cdecl, importc: "appletGetReaderLockAccessorEx".}
## *
##  @brief Gets a Reader \ref AppletLockAccessor.
##  @note Only available with [2.0.0+].
##  @param a LockAccessor object.
##  @param[in] inval Input value, must be 0-3. 0 = HomeButton.
##

proc appletGetWriterLockAccessorEx*(a: ptr AppletLockAccessor; inval: U32): Result {.
    cdecl, importc: "appletGetWriterLockAccessorEx".}
## *
##  @brief Gets a Writer \ref AppletLockAccessor.
##  @note Only available with [7.0.0+]. On older sysvers, this is only available with AppletType_SystemApplet on [2.0.0+].
##  @param a LockAccessor object.
##  @param[in] inval Input value, must be 0-3. 0 = HomeButton.
##

proc appletGetCradleFwVersion*(out0: ptr U32; out1: ptr U32; out2: ptr U32; out3: ptr U32): Result {.
    cdecl, importc: "appletGetCradleFwVersion".}
## *
##  @brief Gets the Dock firmware version.
##  @note Only available with [2.0.0+].
##  @param[out] out0 First output value.
##  @param[out] out1 Second output value.
##  @param[out] out2 Third output value.
##  @param[out] out3 Fourth output value.
##

proc appletIsVrModeEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "appletIsVrModeEnabled".}
## *
##  @brief Gets whether VrMode is enabled.
##  @note Only available with [3.0.0+].
##  @param out Output flag
##

proc appletSetVrModeEnabled*(flag: bool): Result {.cdecl,
    importc: "appletSetVrModeEnabled".}
## *
##  @brief Sets whether VrMode is enabled.
##  @note This is only fully usable system-side with [6.0.0+].
##  @note For checking Parental Controls, see \ref pctlIsStereoVisionPermitted.
##  @note On pre-7.0.0 this uses cmd SetVrModeEnabled internally, while on [7.0.0+] this uses cmds BeginVrModeEx/EndVrModeEx.
##  @param flag Flag
##

proc appletSetLcdBacklightOffEnabled*(flag: bool): Result {.cdecl,
    importc: "appletSetLcdBacklightOffEnabled".}
## *
##  @brief Sets whether the LCD screen backlight is turned off.
##  @note Only available with [4.0.0+].
##  @param[in] flag Flag
##

proc appletIsInControllerFirmwareUpdateSection*(`out`: ptr bool): Result {.cdecl,
    importc: "appletIsInControllerFirmwareUpdateSection".}
## *
##  @brief Gets the ControllerFirmwareUpdateSection flag.
##  @note Only available with [3.0.0+].
##  @param[out] out Output flag.
##

proc appletSetVrPositionForDebug*(x: S32; y: S32; width: S32; height: S32): Result {.
    cdecl, importc: "appletSetVrPositionForDebug".}
## *
##  @brief SetVrPositionForDebug
##  @note The cached value loaded from \ref setsysGetDebugModeFlag must be 1, otherwise an error is returned.
##  @note Only available with [11.0.0+].
##  @param[in] x X, must not be negative. x+width must be <=1280.
##  @param[in] y Y, must not be negative. y+height must be <=720.
##  @param[in] width Width, must be 1-1280.
##  @param[in] height Height, must be 1-720.
##

proc appletGetDefaultDisplayResolution*(width: ptr S32; height: ptr S32): Result {.
    cdecl, importc: "appletGetDefaultDisplayResolution".}
## *
##  @brief Gets the DefaultDisplayResolution.
##  @note Only available with [3.0.0+].
##  @param[out] width Output width.
##  @param[out] height Output height.
##

proc appletGetDefaultDisplayResolutionChangeEvent*(outEvent: ptr Event): Result {.
    cdecl, importc: "appletGetDefaultDisplayResolutionChangeEvent".}
## *
##  @brief Gets an Event which is signaled when the output from \ref appletGetDefaultDisplayResolution changes.
##  @note Only available with [3.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc appletGetHdcpAuthenticationState*(state: ptr S32): Result {.cdecl,
    importc: "appletGetHdcpAuthenticationState".}
## *
##  @brief Gets the HdcpAuthenticationState.
##  @note Only available with [4.0.0+].
##  @param[out] state Output state.
##

proc appletGetHdcpAuthenticationStateChangeEvent*(outEvent: ptr Event): Result {.
    cdecl, importc: "appletGetHdcpAuthenticationStateChangeEvent".}
## *
##  @brief Gets an Event which is signaled when the output from \ref appletGetHdcpAuthenticationState changes.
##  @note Only available with [4.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc appletSetTvPowerStateMatchingMode*(mode: AppletTvPowerStateMatchingMode): Result {.
    cdecl, importc: "appletSetTvPowerStateMatchingMode".}
## *
##  @brief Sets the \ref AppletTvPowerStateMatchingMode.
##  @note Only available with [5.0.0+].
##  @param[in] mode \ref AppletTvPowerStateMatchingMode
##

proc appletGetApplicationIdByContentActionName*(applicationId: ptr U64;
    name: cstring): Result {.cdecl,
                          importc: "appletGetApplicationIdByContentActionName".}
## *
##  @brief Gets the ApplicationId for the specified ContentActionName string.
##  @note Only available when the current applet is an AppletType_SystemApplication on [5.1.0+].
##  @param[out] application_id ApplicationId.
##  @param[in] name ContentActionName string.
##

proc appletSetCpuBoostMode*(mode: ApmCpuBoostMode): Result {.cdecl,
    importc: "appletSetCpuBoostMode".}
## *
##  @brief Sets the \ref ApmCpuBoostMode.
##  @note Only available with [7.0.0+] (not fully usable system-side with 6.x).
##  @param mode \ref ApmCpuBoostMode.
##

proc appletCancelCpuBoostMode*(): Result {.cdecl,
                                        importc: "appletCancelCpuBoostMode".}
## *
##  @brief CancelCpuBoostMode
##  @note Only available with [10.0.0+].
##

proc appletGetBuiltInDisplayType*(`out`: ptr S32): Result {.cdecl,
    importc: "appletGetBuiltInDisplayType".}
## *
##  @brief GetBuiltInDisplayType
##  @note Only available with [11.0.0+].
##  @param[out] out Output value.
##

proc appletPerformSystemButtonPressingIfInFocus*(`type`: AppletSystemButtonType): Result {.
    cdecl, importc: "appletPerformSystemButtonPressingIfInFocus".}
## *
##  @brief Perform SystemButtonPressing with the specified \ref AppletSystemButtonType. Internally this cmd checks a state field, verifies that the type is allowed, then runs the same func as \ref appletPerformSystemButtonPressing internally.
##  @note Only available with [6.0.0+].
##  @param[in] type \ref AppletSystemButtonType
##

proc appletSetPerformanceConfigurationChangedNotification*(flag: bool): Result {.
    cdecl, importc: "appletSetPerformanceConfigurationChangedNotification".}
## *
##  @brief Sets whether PerformanceConfigurationChangedNotification is enabled.
##  @note Only available with [7.0.0+].
##  @param[in] flag Whether to enable the notification.
##

proc appletGetCurrentPerformanceConfiguration*(performanceConfiguration: ptr U32): Result {.
    cdecl, importc: "appletGetCurrentPerformanceConfiguration".}
## *
##  @brief Gets the current PerformanceConfiguration.
##  @note Only available with [7.0.0+].
##  @param PerformanceConfiguration Output PerformanceConfiguration.
##

proc appletOpenMyGpuErrorHandler*(g: ptr AppletGpuErrorHandler): Result {.cdecl,
    importc: "appletOpenMyGpuErrorHandler".}
## *
##  @brief Opens an \ref AppletGpuErrorHandler.
##  @note The cached value loaded from \ref setsysGetDebugModeFlag must be 1, otherwise an error is returned.
##  @note Only available with [11.0.0+].
##  @param[out] g \ref AppletGpuErrorHandler
##

proc appletGetOperationModeSystemInfo*(info: ptr U32): Result {.cdecl,
    importc: "appletGetOperationModeSystemInfo".}
## *
##  @brief Gets the OperationModeSystemInfo.
##  @note Only available with [7.0.0+].
##  @param[out] info Output info.
##

proc appletGetSettingsPlatformRegion*(`out`: ptr SetSysPlatformRegion): Result {.
    cdecl, importc: "appletGetSettingsPlatformRegion".}
## *
##  @brief This uses \ref setsysGetPlatformRegion internally.
##  @note Only available with [9.0.0+].
##  @param[out] out \ref SetSysPlatformRegion
##

proc appletActivateMigrationService*(): Result {.cdecl,
    importc: "appletActivateMigrationService".}
## *
##  @brief ActivateMigrationService
##  @note Only available with [10.0.0+].
##

proc appletDeactivateMigrationService*(): Result {.cdecl,
    importc: "appletDeactivateMigrationService".}
## *
##  @brief DeactivateMigrationService
##  @note Only available with [10.0.0+].
##

proc appletDisableSleepTillShutdown*(): Result {.cdecl,
    importc: "appletDisableSleepTillShutdown".}
## *
##  @brief DisableSleepTillShutdown
##  @note Only available with [11.0.0+].
##

proc appletSuppressDisablingSleepTemporarily*(val: U64): Result {.cdecl,
    importc: "appletSuppressDisablingSleepTemporarily".}
## *
##  @brief SuppressDisablingSleepTemporarily
##  @param[in] val Nanoseconds value.
##  @note Only available with [11.0.0+].
##

proc appletSetRequestExitToLibraryAppletAtExecuteNextProgramEnabled*(): Result {.
    cdecl,
    importc: "appletSetRequestExitToLibraryAppletAtExecuteNextProgramEnabled".}
## *
##  @brief SetRequestExitToLibraryAppletAtExecuteNextProgramEnabled
##  @note Only available with [11.0.0+].
##

proc appletGpuErrorHandlerClose*(g: ptr AppletGpuErrorHandler) {.cdecl,
    importc: "appletGpuErrorHandlerClose".}
## /@}
## /@name IGpuErrorHandler
## /@{
## *
##  @brief Close an \ref AppletGpuErrorHandler.
##  @param g \ref AppletGpuErrorHandler
##

proc appletGpuErrorHandlerGetManualGpuErrorInfoSize*(
    g: ptr AppletGpuErrorHandler; `out`: ptr U64): Result {.cdecl,
    importc: "appletGpuErrorHandlerGetManualGpuErrorInfoSize".}
## *
##  @brief Gets the size of the info available with \ref appletGpuErrorHandlerGetManualGpuErrorInfo.
##  @param g \ref AppletGpuErrorHandler
##  @param[out] out Output size.
##

proc appletGpuErrorHandlerGetManualGpuErrorInfo*(g: ptr AppletGpuErrorHandler;
    buffer: pointer; size: csize_t; `out`: ptr U64): Result {.cdecl,
    importc: "appletGpuErrorHandlerGetManualGpuErrorInfo".}
## *
##  @brief GetManualGpuErrorInfo
##  @param g \ref AppletGpuErrorHandler
##  @param[out] buffer Output buffer.
##  @param[in] size Output buffer size, must be >= the output size from \ref appletGpuErrorHandlerGetManualGpuErrorInfoSize.
##  @param[out] out Output value.
##

proc appletGpuErrorHandlerGetManualGpuErrorDetectionSystemEvent*(
    g: ptr AppletGpuErrorHandler; outEvent: ptr Event): Result {.cdecl,
    importc: "appletGpuErrorHandlerGetManualGpuErrorDetectionSystemEvent".}
## *
##  @brief GetManualGpuErrorDetectionSystemEvent
##  @param g \ref AppletGpuErrorHandler
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletGpuErrorHandlerFinishManualGpuErrorHandling*(
    g: ptr AppletGpuErrorHandler): Result {.cdecl, importc: "appletGpuErrorHandlerFinishManualGpuErrorHandling".}
## *
##  @brief FinishManualGpuErrorHandling
##  @param g \ref AppletGpuErrorHandler
##

proc appletLockExit*(): Result {.cdecl, importc: "appletLockExit".}
## /@}
## /@name ISelfController
## /@{
## *
##  @brief Delay exiting until \ref appletUnlockExit is called, with a 15 second timeout once exit is requested.
##  @note When exit is requested \ref appletMainLoop will return false, hence any main-loop using appletMainLoop will exit. This allows the app to handle cleanup post-main-loop instead of being force-terminated.
##  @note If the above timeout occurs after exit was requested where \ref appletUnlockExit was not called, the process will be forced-terminated.
##  @note \ref appletUnlockExit must be used before main() returns.
##

proc appletUnlockExit*(): Result {.cdecl, importc: "appletUnlockExit".}
## / Unlocks exiting, see \ref appletLockExit.

proc appletEnterFatalSection*(): Result {.cdecl, importc: "appletEnterFatalSection".}
## *
##  @brief Enter FatalSection.
##

proc appletLeaveFatalSection*(): Result {.cdecl, importc: "appletLeaveFatalSection".}
## *
##  @brief Leave FatalSection.
##

proc appletSetScreenShotPermission*(permission: AppletScreenShotPermission): Result {.
    cdecl, importc: "appletSetScreenShotPermission".}
## *
##  @brief Controls whether screenshot-capture is allowed.
##  @param permission \ref AppletScreenShotPermission
##

proc appletSetRestartMessageEnabled*(flag: bool): Result {.cdecl,
    importc: "appletSetRestartMessageEnabled".}
## *
##  @brief Sets whether ::AppletMessage_Resume is enabled.
##  @param[in] flag Whether to enable the notification.
##

proc appletSetScreenShotAppletIdentityInfo*(info: ptr AppletIdentityInfo): Result {.
    cdecl, importc: "appletSetScreenShotAppletIdentityInfo".}
## *
##  @brief Sets the \ref AppletIdentityInfo for screenshots.
##  @param[in] info \ref AppletIdentityInfo
##

proc appletSetControllerFirmwareUpdateSection*(flag: bool): Result {.cdecl,
    importc: "appletSetControllerFirmwareUpdateSection".}
## *
##  @brief Sets ControllerFirmwareUpdateSection.
##  @note Only available with [3.0.0+].
##  @note This throws error 0x40280 when the internal state flag already matches the input value.
##  @param[in] flag Flag
##

proc appletSetRequiresCaptureButtonShortPressedMessage*(flag: bool): Result {.cdecl,
    importc: "appletSetRequiresCaptureButtonShortPressedMessage".}
## *
##  @brief Sets whether ::AppletMessage_CaptureButtonShortPressed is enabled.
##  @note Only available with [3.0.0+].
##  @note When enabled with a non-Overlay applet, Overlay applet will not be notified of capture button short-presses for screenshots.
##  @param[in] flag Whether to enable the notification.
##

proc appletSetAlbumImageOrientation*(orientation: AlbumImageOrientation): Result {.
    cdecl, importc: "appletSetAlbumImageOrientation".}
## *
##  @brief Sets the Album screenshot ImageOrientation.
##  @note Only available with [3.0.0+].
##  @param[in] orientation \ref AlbumImageOrientation
##

proc appletSetDesirableKeyboardLayout*(layout: SetKeyboardLayout): Result {.cdecl,
    importc: "appletSetDesirableKeyboardLayout".}
## *
##  @brief Sets the DesirableKeyboardLayout.
##  @note Only available with [4.0.0+].
##  @param[in] layout Input \ref SetKeyboardLayout.
##

proc appletCreateManagedDisplayLayer*(`out`: ptr U64): Result {.cdecl,
    importc: "appletCreateManagedDisplayLayer".}
## appletCreateManagedDisplayLayer

proc appletIsSystemBufferSharingEnabled*(): Result {.cdecl,
    importc: "appletIsSystemBufferSharingEnabled".}
## *
##  @brief Checks whether SystemBufferSharing is enabled, throwing an error otherwise.
##  @note Only available with [4.0.0+]. Not usable with AppletType_*Application.
##

proc appletGetSystemSharedLayerHandle*(sharedBufferHandle: ptr U64;
                                      sharedLayerHandle: ptr U64): Result {.cdecl,
    importc: "appletGetSystemSharedLayerHandle".}
## *
##  @brief Gets the System SharedBufferHandle and SharedLayerHandle.
##  @note Only available with [4.0.0+]. Not usable with AppletType_*Application.
##  @param[out] SharedBufferHandle Output System SharedBufferHandle.
##  @param[out] SharedLayerHandle Output System SharedLayerHandle.
##

proc appletGetSystemSharedBufferHandle*(sharedBufferHandle: ptr U64): Result {.cdecl,
    importc: "appletGetSystemSharedBufferHandle".}
## *
##  @brief Same as \ref appletGetSystemSharedLayerHandle except this just gets the SharedBufferHandle.
##  @note Only available with [5.0.0+]. Not usable with AppletType_*Application.
##  @param[out] SharedBufferHandle Output System SharedBufferHandle.
##

proc appletCreateManagedDisplaySeparableLayer*(displayLayer: ptr U64;
    recordingLayer: ptr U64): Result {.cdecl, importc: "appletCreateManagedDisplaySeparableLayer".}
## *
##  @brief CreateManagedDisplaySeparableLayer
##  @note Only available with [10.0.0+].
##  @param[out] display_layer Output display_layer.
##  @param[out] recording_layer Output recording_layer.
##

proc appletSetManagedDisplayLayerSeparationMode*(mode: U32): Result {.cdecl,
    importc: "appletSetManagedDisplayLayerSeparationMode".}
## *
##  @brief SetManagedDisplayLayerSeparationMode
##  @note Only available with [10.0.0+].
##  @param[in] mode Mode. Must be 0-1.
##

proc appletSetHandlesRequestToDisplay*(flag: bool): Result {.cdecl,
    importc: "appletSetHandlesRequestToDisplay".}
## *
##  @brief Sets whether ::AppletMessage_RequestToDisplay is enabled.
##  @note Sets an internal state flag. When the input flag is 0, this will in additional run the same code as \ref appletApproveToDisplay.
##  @param[in] flag Flag
##

proc appletApproveToDisplay*(): Result {.cdecl, importc: "appletApproveToDisplay".}
## *
##  @brief Approve the display requested by ::AppletMessage_RequestToDisplay, see also \ref appletSetHandlesRequestToDisplay.
##

proc appletOverrideAutoSleepTimeAndDimmingTime*(inval0: S32; inval1: S32;
    inval2: S32; inval3: S32): Result {.cdecl, importc: "appletOverrideAutoSleepTimeAndDimmingTime".}
## *
##  @brief OverrideAutoSleepTimeAndDimmingTime
##  @param[in] inval0 Unknown input value.
##  @param[in] inval1 Unknown input value.
##  @param[in] inval2 Unknown input value.
##  @param[in] inval3 Unknown input value.
##

proc appletSetIdleTimeDetectionExtension*(ext: AppletIdleTimeDetectionExtension): Result {.
    cdecl, importc: "appletSetIdleTimeDetectionExtension".}
## *
##  @brief Sets the IdleTimeDetectionExtension.
##  @param[in] ext \ref AppletIdleTimeDetectionExtension Must be 0-2: 0 = disabled, 1 = Extended, and 2 = ExtendedUnsafe.
##

proc appletGetIdleTimeDetectionExtension*(
    ext: ptr AppletIdleTimeDetectionExtension): Result {.cdecl,
    importc: "appletGetIdleTimeDetectionExtension".}
## *
##  @brief Gets the value set by \ref appletSetIdleTimeDetectionExtension.
##  @param[out] ext \ref AppletIdleTimeDetectionExtension
##

proc appletSetInputDetectionSourceSet*(val: U32): Result {.cdecl,
    importc: "appletSetInputDetectionSourceSet".}
## *
##  @brief Sets the InputDetectionSourceSet.
##  @param[in] val Input value.
##

proc appletReportUserIsActive*(): Result {.cdecl,
                                        importc: "appletReportUserIsActive".}
## *
##  @brief Reports that the user is active, for idle detection (screen dimming / auto-sleep). This is equivalent to when the user uses HID input.
##  @note Only available with [2.0.0+].
##

proc appletGetCurrentIlluminance*(fLux: ptr cfloat): Result {.cdecl,
    importc: "appletGetCurrentIlluminance".}
## *
##  @brief Gets the current Illuminance from the light sensor.
##  @note Only available with [3.0.0+].
##  @param fLux Output fLux
##

proc appletIsIlluminanceAvailable*(`out`: ptr bool): Result {.cdecl,
    importc: "appletIsIlluminanceAvailable".}
## *
##  @brief Gets whether Illuminance is available.
##  @note Only available with [3.0.0+].
##  @param out Output flag
##

proc appletSetAutoSleepDisabled*(flag: bool): Result {.cdecl,
    importc: "appletSetAutoSleepDisabled".}
## *
##  @brief Sets AutoSleepDisabled.
##  @note Only available with [5.0.0+].
##  @param[in] flag Flag
##

proc appletIsAutoSleepDisabled*(`out`: ptr bool): Result {.cdecl,
    importc: "appletIsAutoSleepDisabled".}
## *
##  @brief Gets AutoSleepDisabled.
##  @note Only available with [5.0.0+].
##  @param[out] out Output flag
##

proc appletGetCurrentIlluminanceEx*(bOverLimit: ptr bool; fLux: ptr cfloat): Result {.
    cdecl, importc: "appletGetCurrentIlluminanceEx".}
## *
##  @brief Gets the current Illuminance from the light sensor. Same as \ref appletGetCurrentIlluminance except for the additional param.
##  @note Only available with [5.0.0+].
##  @param bOverLimit Output bOverLimit
##  @param fLux Output fLux
##

proc appletSetInputDetectionPolicy*(policy: AppletInputDetectionPolicy): Result {.
    cdecl, importc: "appletSetInputDetectionPolicy".}
## *
##  @brief Sets the \ref AppletInputDetectionPolicy.
##  @note Only available with [9.0.0+].
##  @param[in] policy \ref AppletInputDetectionPolicy
##

proc appletSetWirelessPriorityMode*(mode: AppletWirelessPriorityMode): Result {.
    cdecl, importc: "appletSetWirelessPriorityMode".}
## *
##  @brief Sets the WirelessPriorityMode.
##  @note Only available with [4.0.0+].
##  @param[in] mode \ref AppletWirelessPriorityMode
##

proc appletGetProgramTotalActiveTime*(activeTime: ptr U64): Result {.cdecl,
    importc: "appletGetProgramTotalActiveTime".}
## *
##  @brief Gets the total time in nanoseconds that the current process was actively running (not suspended), relative to when \ref appletInitialize was last used.
##  @note Only available with [6.0.0+].
##  @param[out] activeTime Output nanoseconds value.
##

proc appletSetAlbumImageTakenNotificationEnabled*(flag: bool): Result {.cdecl,
    importc: "appletSetAlbumImageTakenNotificationEnabled".}
## *
##  @brief Sets whether ::AppletMessage_AlbumScreenShotTaken is enabled.
##  @note Only available with [7.0.0+].
##  @param[in] flag Whether to enable the notification.
##

proc appletSetApplicationAlbumUserData*(buffer: pointer; size: csize_t): Result {.
    cdecl, importc: "appletSetApplicationAlbumUserData".}
## *
##  @brief Sets the Application AlbumUserData.
##  @note Only available with [8.0.0+].
##  @param[in] buffer Buffer containing arbitrary UserData.
##  @param[in] size Buffer size, must be <=0x400.
##

proc appletSaveCurrentScreenshot*(option: AlbumReportOption): Result {.cdecl,
    importc: "appletSaveCurrentScreenshot".}
## *
##  @brief SaveCurrentScreenshot
##  @note Only available with [11.0.0+].
##  @param[in] option \ref AlbumReportOption
##

proc appletGetAppletResourceUserIdOfCallerApplet*(`out`: ptr U64): Result {.cdecl,
    importc: "appletGetAppletResourceUserIdOfCallerApplet".}
## /@}
## /@name IWindowController
## /@{
## *
##  @brief Gets the AppletResourceUserId of the CallerApplet.
##  @note Only available with [6.0.0+].
##  @param[out] out AppletResourceUserId
##

proc appletSetAppletWindowVisibility*(flag: bool): Result {.cdecl,
    importc: "appletSetAppletWindowVisibility".}
## *
##  @brief Sets the current applet WindowVisibility.
##  @note Only available with [7.0.0+].
##  @param[in] flag Flag
##

proc appletSetAppletGpuTimeSlice*(val: S64): Result {.cdecl,
    importc: "appletSetAppletGpuTimeSlice".}
## *
##  @brief Sets the AppletGpuTimeSlice.
##  @note Only available with [7.0.0+].
##  @param[in] val Input value, must not be negative.
##

proc appletSetExpectedMasterVolume*(mainAppletVolume: cfloat;
                                   libraryAppletVolume: cfloat): Result {.cdecl,
    importc: "appletSetExpectedMasterVolume".}
## /@}
## /@name IAudioController
## /@{
## *
##  @brief Sets the ExpectedMasterVolume for MainApplet and LibraryApplet.
##  @note Used by some official apps before/after launching LibraryApplets. Prior to changing the volume, the official app uses \ref appletGetExpectedMasterVolume, with the output being used to restore the volume after LibraryApplet handling.
##  @param[in] mainAppletVolume MainApplet ExpectedMasterVolume.
##  @param[in] libraryAppletVolume LibraryApplet ExpectedMasterVolume.
##

proc appletGetExpectedMasterVolume*(mainAppletVolume: ptr cfloat;
                                   libraryAppletVolume: ptr cfloat): Result {.cdecl,
    importc: "appletGetExpectedMasterVolume".}
## *
##  @brief Gets the ExpectedMasterVolume for MainApplet and LibraryApplet.
##  @note See also \ref appletSetExpectedMasterVolume.
##  @param[out] mainAppletVolume MainApplet ExpectedMasterVolume. Optional, can be NULL. Used with cmd GetMainAppletExpectedMasterVolume when not NULL.
##  @param[out] libraryAppletVolume LibraryApplet ExpectedMasterVolume. Optional, can be NULL. Used with cmd GetLibraryAppletExpectedMasterVolume when not NULL.
##

proc appletChangeMainAppletMasterVolume*(volume: cfloat; unk: U64): Result {.cdecl,
    importc: "appletChangeMainAppletMasterVolume".}
## *
##  @brief Change the MainApplet MasterVolume.
##  @param[in] volume MainApplet MasterVolume.
##  @param[in] unk Unknown.
##

proc appletSetTransparentVolumeRate*(val: cfloat): Result {.cdecl,
    importc: "appletSetTransparentVolumeRate".}
## *
##  @brief Sets the TransparentVolumeRate.
##  @param[in] val Input value.
##

proc appletUpdateLastForegroundCaptureImage*(): Result {.cdecl,
    importc: "appletUpdateLastForegroundCaptureImage".}
## /@}
## /@name IDisplayController
## /@{
## *
##  @brief Update the LastForeground CaptureImage.
##

proc appletUpdateCallerAppletCaptureImage*(): Result {.cdecl,
    importc: "appletUpdateCallerAppletCaptureImage".}
## *
##  @brief Update the CallerApplet CaptureImage.
##

proc appletGetLastForegroundCaptureImageEx*(buffer: pointer; size: csize_t;
    flag: ptr bool): Result {.cdecl, importc: "appletGetLastForegroundCaptureImageEx".}
## *
##  @brief Gets the LastForeground CaptureImage.
##  @param[out] buffer Output buffer containing the 1280x720 RGBA8 image.
##  @param[out] size Buffer size, must match 0x384000.
##  @param[out] flag Output flag.
##

proc appletGetLastApplicationCaptureImageEx*(buffer: pointer; size: csize_t;
    flag: ptr bool): Result {.cdecl,
                          importc: "appletGetLastApplicationCaptureImageEx".}
## *
##  @brief Gets the LastApplication CaptureImage.
##  @param[out] buffer Output buffer containing the 1280x720 RGBA8 image.
##  @param[out] size Buffer size, must match 0x384000.
##  @param[out] flag Output flag.
##

proc appletGetCallerAppletCaptureImageEx*(buffer: pointer; size: csize_t;
    flag: ptr bool): Result {.cdecl, importc: "appletGetCallerAppletCaptureImageEx".}
## *
##  @brief Gets the CallerApplet CaptureImage.
##  @param[out] buffer Output buffer containing the 1280x720 RGBA8 image.
##  @param[out] size Buffer size, must match 0x384000.
##  @param[out] flag Output flag.
##

proc appletTakeScreenShotOfOwnLayer*(flag: bool;
                                    captureBuf: AppletCaptureSharedBuffer): Result {.
    cdecl, importc: "appletTakeScreenShotOfOwnLayer".}
## *
##  @brief Takes a screenshot of the current applet Layer into the specified CaptureSharedBuffer.
##  @note Only available with [2.0.0+].
##  @param[in] flag Flag.
##  @param[in] captureBuf \ref AppletCaptureSharedBuffer
##

proc appletCopyBetweenCaptureBuffers*(dstCaptureBuf: AppletCaptureSharedBuffer;
                                     srcCaptureBuf: AppletCaptureSharedBuffer): Result {.
    cdecl, importc: "appletCopyBetweenCaptureBuffers".}
## *
##  @brief Copies image data from a CaptureSharedBuffer to another CaptureSharedBuffer.
##  @note Only available with [5.0.0+].
##  @param[in] dstCaptureBuf Destination \ref AppletCaptureSharedBuffer.
##  @param[in] srcCaptureBuf Source \ref AppletCaptureSharedBuffer.
##

proc appletClearCaptureBuffer*(flag: bool; captureBuf: AppletCaptureSharedBuffer;
                              color: U32): Result {.cdecl,
    importc: "appletClearCaptureBuffer".}
## *
##  @brief Clear the input CaptureSharedBuffer with the specified color.
##  @note Only available with [3.0.0+].
##  @param[in] flag Flag.
##  @param[in] captureBuf \ref AppletCaptureSharedBuffer
##  @param[in] color RGBA8 color.
##

proc appletClearAppletTransitionBuffer*(color: U32): Result {.cdecl,
    importc: "appletClearAppletTransitionBuffer".}
## *
##  @brief Clear the AppletTransitionBuffer with the specified color.
##  @note Only available with [3.0.0+].
##  @param[in] color RGBA8 color.
##

proc appletAcquireLastApplicationCaptureSharedBuffer*(flag: ptr bool; id: ptr S32): Result {.
    cdecl, importc: "appletAcquireLastApplicationCaptureSharedBuffer".}
## *
##  @brief Acquire the LastApplication CaptureSharedBuffer.
##  @note Only available with [4.0.0+].
##  @param[out] flag Output flag.
##  @param[out] id Output ID.
##

proc appletReleaseLastApplicationCaptureSharedBuffer*(): Result {.cdecl,
    importc: "appletReleaseLastApplicationCaptureSharedBuffer".}
## *
##  @brief Release the LastApplication CaptureSharedBuffer.
##  @note Only available with [4.0.0+].
##

proc appletAcquireLastForegroundCaptureSharedBuffer*(flag: ptr bool; id: ptr S32): Result {.
    cdecl, importc: "appletAcquireLastForegroundCaptureSharedBuffer".}
## *
##  @brief Acquire the LastForeground CaptureSharedBuffer.
##  @note Only available with [4.0.0+].
##  @param[out] flag Output flag.
##  @param[out] id Output ID.
##

proc appletReleaseLastForegroundCaptureSharedBuffer*(): Result {.cdecl,
    importc: "appletReleaseLastForegroundCaptureSharedBuffer".}
## *
##  @brief Release the LastForeground CaptureSharedBuffer.
##  @note Only available with [4.0.0+].
##

proc appletAcquireCallerAppletCaptureSharedBuffer*(flag: ptr bool; id: ptr S32): Result {.
    cdecl, importc: "appletAcquireCallerAppletCaptureSharedBuffer".}
## *
##  @brief Acquire the CallerApplet CaptureSharedBuffer.
##  @note Only available with [4.0.0+].
##  @param[out] flag Output flag.
##  @param[out] id Output ID.
##

proc appletReleaseCallerAppletCaptureSharedBuffer*(): Result {.cdecl,
    importc: "appletReleaseCallerAppletCaptureSharedBuffer".}
## *
##  @brief Release the CallerApplet CaptureSharedBuffer.
##  @note Only available with [4.0.0+].
##

proc appletTakeScreenShotOfOwnLayerEx*(flag0: bool; immediately: bool;
                                      captureBuf: AppletCaptureSharedBuffer): Result {.
    cdecl, importc: "appletTakeScreenShotOfOwnLayerEx".}
## *
##  @brief Takes a screenshot of the current applet Layer into the specified CaptureSharedBuffer. Same as \ref appletTakeScreenShotOfOwnLayer except for the additional immediately param.
##  @note Only available with [6.0.0+].
##  @param[in] flag0 Flag0.
##  @param[in] immediately Whether the screenshot should be taken immediately.
##  @param[in] captureBuf \ref AppletCaptureSharedBuffer
##

proc appletPushContext*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPushContext".}
## /@}
## /@name IProcessWindingController
## /@{
## *
##  @brief Pushes a storage to the ContextStack. Normally this should only be used when AppletInfo::caller_flag is true.
##  @note Only available with AppletType_LibraryApplet.
##  @note This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##

proc appletPopContext*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPopContext".}
## *
##  @brief Pops a storage from the ContextStack. Normally this should only be used when AppletInfo::caller_flag is true.
##  @note Only available with AppletType_LibraryApplet.
##  @param[out] s Storage object.
##

proc appletLockAccessorClose*(a: ptr AppletLockAccessor) {.cdecl,
    importc: "appletLockAccessorClose".}
##  LockAccessor
## *
##  @brief Closes a LockAccessor.
##  @param a LockAccessor object.
##

proc appletLockAccessorTryLock*(a: ptr AppletLockAccessor; flag: ptr bool): Result {.
    cdecl, importc: "appletLockAccessorTryLock".}
## *
##  @brief TryLock a LockAccessor.
##  @param a LockAccessor object.
##  @param[out] flag Whether locking was successful, when false this indicates that this func should be called again.
##

proc appletLockAccessorLock*(a: ptr AppletLockAccessor): Result {.cdecl,
    importc: "appletLockAccessorLock".}
## *
##  @brief Lock a LockAccessor.
##  @note Similar to \ref appletLockAccessorTryLock, except this uses timeout UINT64_MAX with the eventWait call, and this uses TryLock repeatedly until the output flag value is true.
##  @param a LockAccessor object.
##

proc appletLockAccessorUnlock*(a: ptr AppletLockAccessor): Result {.cdecl,
    importc: "appletLockAccessorUnlock".}
## *
##  @brief Unlock a LockAccessor.
##  @param a LockAccessor object.
##

proc appletCreateLibraryApplet*(h: ptr AppletHolder; id: AppletId; mode: LibAppletMode): Result {.
    cdecl, importc: "appletCreateLibraryApplet".}
## /@}
## /@name ILibraryAppletCreator
## /@{
## *
##  @brief Creates a LibraryApplet.
##  @param h AppletHolder object.
##  @param id See \ref AppletId.
##  @param mode See \ref LibAppletMode.
##

proc appletCreateLibraryAppletSelf*(h: ptr AppletHolder; id: AppletId;
                                   mode: LibAppletMode): Result {.cdecl,
    importc: "appletCreateLibraryAppletSelf".}
## *
##  @brief Creates a LibraryApplet. This is for when a LibraryApplet creates itself.
##  @note  Identical to \ref appletCreateLibraryApplet except this sets the creating_self flag to true.
##  @param h AppletHolder object.
##  @param id See \ref AppletId.
##  @param mode See \ref LibAppletMode.
##

proc appletTerminateAllLibraryApplets*(): Result {.cdecl,
    importc: "appletTerminateAllLibraryApplets".}
## *
##  @brief TerminateAllLibraryApplets which were created by the current applet.
##  @note Normally LibraryApplet cleanup should be handled via \ref AppletHolder.
##

proc appletAreAnyLibraryAppletsLeft*(`out`: ptr bool): Result {.cdecl,
    importc: "appletAreAnyLibraryAppletsLeft".}
## *
##  @brief AreAnyLibraryAppletsLeft which were created by the current applet.
##  @param[out] out Output flag.
##

proc appletHolderClose*(h: ptr AppletHolder) {.cdecl, importc: "appletHolderClose".}
## /@}
## /@name ILibraryAppletAccessor
## /@{
## / Closes an AppletHolder object.

proc appletHolderActive*(h: ptr AppletHolder): bool {.cdecl,
    importc: "appletHolderActive".}
## / Returns whether the AppletHolder object was initialized.

proc appletHolderGetIndirectLayerConsumerHandle*(h: ptr AppletHolder; `out`: ptr U64): Result {.
    cdecl, importc: "appletHolderGetIndirectLayerConsumerHandle".}
## *
##  @brief Gets the IndirectLayerConsumerHandle loaded during \ref appletCreateLibraryApplet, on [2.0.0+].
##  @note  Only available when \ref LibAppletMode is ::LibAppletMode_BackgroundIndirect.
##  @param h AppletHolder object.
##  @param out Output IndirectLayerConsumerHandle.
##

proc appletHolderStart*(h: ptr AppletHolder): Result {.cdecl,
    importc: "appletHolderStart".}
## *
##  @brief Starts the LibraryApplet.
##  @param h AppletHolder object.
##

proc appletHolderJump*(h: ptr AppletHolder): Result {.cdecl,
    importc: "appletHolderJump".}
## *
##  @brief Jumps to the LibraryApplet, with the current-LibraryApplet being terminated. This will enter an infinite-sleep-loop on success.
##  @note Only available with AppletType_LibraryApplet.
##  @param h AppletHolder object.
##

proc appletHolderRequestExit*(h: ptr AppletHolder): Result {.cdecl,
    importc: "appletHolderRequestExit".}
## *
##  @brief Requests the LibraryApplet to exit. The command is only used if \ref appletHolderCheckFinished returns false.
##  @param h AppletHolder object.
##

proc appletHolderTerminate*(h: ptr AppletHolder): Result {.cdecl,
    importc: "appletHolderTerminate".}
## *
##  @brief Terminate the LibraryApplet.
##  @param h AppletHolder object.
##

proc appletHolderRequestExitOrTerminate*(h: ptr AppletHolder; timeout: U64): Result {.
    cdecl, importc: "appletHolderRequestExitOrTerminate".}
## *
##  @brief Uses cmds GetAppletStateChangedEvent and RequestExit, then waits for the LibraryApplet to exit with the specified timeout. If a timeout occurs, the Terminate cmd is used.
##  @param h AppletHolder object.
##  @param[in] timeout Timeout in nanoseconds. UINT64_MAX for no timeout.
##

proc appletHolderJoin*(h: ptr AppletHolder) {.cdecl, importc: "appletHolderJoin".}
## *
##  @brief Waits for the LibraryApplet to exit.
##  @param h AppletHolder object.
##

proc appletHolderGetExitEvent*(h: ptr AppletHolder): ptr Event {.inline, cdecl.} =
  ## *
  ##  @brief Gets the LibraryApplet StateChangedEvent.
  ##  @param h AppletHolder object.
  ##
  return addr(h.stateChangedEvent)

proc appletHolderCheckFinished*(h: ptr AppletHolder): bool {.cdecl,
    importc: "appletHolderCheckFinished".}
## *
##  @brief Waits on the LibraryApplet StateChangedEvent with timeout=0, and returns whether it was successful.
##  @param h AppletHolder object.
##

proc appletHolderGetExitReason*(h: ptr AppletHolder): LibAppletExitReason {.cdecl,
    importc: "appletHolderGetExitReason".}
## *
##  @brief Gets the \ref LibAppletExitReason set by \ref appletHolderJoin.
##  @param h AppletHolder object.
##

proc appletHolderSetOutOfFocusApplicationSuspendingEnabled*(h: ptr AppletHolder;
    flag: bool): Result {.cdecl, importc: "appletHolderSetOutOfFocusApplicationSuspendingEnabled".}
## *
##  @brief Sets OutOfFocusApplicationSuspendingEnabled.
##  @note Only available with AppletType_*Application.
##  @param h AppletHolder object.
##  @param[in] flag Flag
##

proc appletHolderPresetLibraryAppletGpuTimeSliceZero*(h: ptr AppletHolder): Result {.
    cdecl, importc: "appletHolderPresetLibraryAppletGpuTimeSliceZero".}
## *
##  @brief PresetLibraryAppletGpuTimeSliceZero
##  @note Only available with [10.0.0+].
##  @param h AppletHolder object.
##

proc appletHolderGetPopInteractiveOutDataEvent*(h: ptr AppletHolder;
    outEvent: ptr ptr Event): Result {.cdecl, importc: "appletHolderGetPopInteractiveOutDataEvent".}
## *
##  @brief Gets the PopInteractiveOutDataEvent.
##  @param h AppletHolder object.
##  @param[out] out_event Output Event.
##

proc appletHolderWaitInteractiveOut*(h: ptr AppletHolder): bool {.cdecl,
    importc: "appletHolderWaitInteractiveOut".}
## *
##  @brief Waits for the PopInteractiveOutDataEvent and StateChangedEvent.
##  @return false for error / when StateChangedEvent was signaled, and true when PopInteractiveOutDataEvent was signaled. The latter is signaled when a new storage is available with \ref appletHolderPopInteractiveOutData where previously no storage was available (this willl not clear the event), this event is automatically cleared by the system once the last storage is popped.
##  @param h AppletHolder object.
##

proc appletHolderPushInData*(h: ptr AppletHolder; s: ptr AppletStorage): Result {.cdecl,
    importc: "appletHolderPushInData".}
## *
##  @brief Pushes a storage for LibraryApplet input.
##  @note  This uses \ref appletStorageClose automatically.
##  @param h AppletHolder object.
##  @param[in] s Storage object.
##

proc appletHolderPopOutData*(h: ptr AppletHolder; s: ptr AppletStorage): Result {.cdecl,
    importc: "appletHolderPopOutData".}
## *
##  @brief Pops a storage from LibraryApplet output.
##  @param h AppletHolder object.
##  @param[out] s Storage object.
##

proc appletHolderPushExtraStorage*(h: ptr AppletHolder; s: ptr AppletStorage): Result {.
    cdecl, importc: "appletHolderPushExtraStorage".}
## *
##  @brief Pushes a storage for LibraryApplet Extra storage input.
##  @note  This uses \ref appletStorageClose automatically.
##  @param h AppletHolder object.
##  @param[in] s Storage object.
##

proc appletHolderPushInteractiveInData*(h: ptr AppletHolder; s: ptr AppletStorage): Result {.
    cdecl, importc: "appletHolderPushInteractiveInData".}
## *
##  @brief Pushes a storage for LibraryApplet Interactive input.
##  @note  This uses \ref appletStorageClose automatically.
##  @param h AppletHolder object.
##  @param[in] s Storage object.
##

proc appletHolderPopInteractiveOutData*(h: ptr AppletHolder; s: ptr AppletStorage): Result {.
    cdecl, importc: "appletHolderPopInteractiveOutData".}
## *
##  @brief Pops a storage from LibraryApplet Interactive output.
##  @param h AppletHolder object.
##  @param[out] s Storage object.
##

proc appletHolderGetLibraryAppletInfo*(h: ptr AppletHolder; info: ptr LibAppletInfo): Result {.
    cdecl, importc: "appletHolderGetLibraryAppletInfo".}
## *
##  @brief Gets the \ref LibAppletInfo for the specified LibraryApplet.
##  @param h AppletHolder object.
##  @param[out] info \ref LibAppletInfo
##

proc appletCreateStorage*(s: ptr AppletStorage; size: S64): Result {.cdecl,
    importc: "appletCreateStorage".}
## /@}
## /@name (ILibraryAppletCreator ->) IStorage
## /@{
## *
##  @brief Creates a storage.
##  @param s Storage object.
##  @param size Size of storage.
##

proc appletCreateTransferMemoryStorage*(s: ptr AppletStorage; buffer: pointer;
                                       size: S64; writable: bool): Result {.cdecl,
    importc: "appletCreateTransferMemoryStorage".}
## *
##  @brief Creates a TransferMemory storage.
##  @param s Storage object.
##  @param buffer TransferMemory buffer, will be automatically allocated if NULL.
##  @param size Size of storage.
##  @param writable Controls whether writing to the storage is allowed with \ref appletStorageWrite.
##

proc appletCreateHandleStorage*(s: ptr AppletStorage; inval: S64; handle: Handle): Result {.
    cdecl, importc: "appletCreateHandleStorage".}
## *
##  @brief Creates a HandleStorage.
##  @note Only available on [2.0.0+].
##  @param s Storage object.
##  @param inval Arbitrary input value.
##  @param handle Arbitrary input handle.
##

proc appletCreateHandleStorageTmem*(s: ptr AppletStorage; buffer: pointer; size: S64): Result {.
    cdecl, importc: "appletCreateHandleStorageTmem".}
## *
##  @brief Creates a HandleStorage using TransferMemory. Wrapper for \ref appletCreateHandleStorage.
##  @param s Storage object.
##  @param buffer TransferMemory buffer, will be automatically allocated if NULL.
##  @param size Size of storage.
##

proc appletStorageClose*(s: ptr AppletStorage) {.cdecl, importc: "appletStorageClose".}
## / Closes the storage object. TransferMemory closing is seperate, see \ref appletStorageCloseTmem.
## / Other applet functions which push an input storage will automatically call this.

proc appletStorageCloseTmem*(s: ptr AppletStorage) {.cdecl,
    importc: "appletStorageCloseTmem".}
## / Closes the TransferMemory in the storage object. For TransferMemory storage created by the current process, this must be called after the LibraryApplet finishes using it (if sent to one).

proc appletStorageGetSize*(s: ptr AppletStorage; size: ptr S64): Result {.cdecl,
    importc: "appletStorageGetSize".}
## / Gets the size of the storage. This is not usable with HandleStorage, use \ref appletStorageGetHandle or \ref appletStorageMap instead for that.

proc appletStorageWrite*(s: ptr AppletStorage; offset: S64; buffer: pointer;
                        size: csize_t): Result {.cdecl,
    importc: "appletStorageWrite".}
## *
##  @brief Writes to a storage. offset(+size) must be within the actual storage size.
##  @note  This is not usable with HandleStorage.
##  @param s Storage object.
##  @param offset Offset in storage.
##  @param buffer Input data.
##  @param size Data size.
##

proc appletStorageRead*(s: ptr AppletStorage; offset: S64; buffer: pointer;
                       size: csize_t): Result {.cdecl, importc: "appletStorageRead".}
## *
##  @brief Reads from a storage. offset(+size) must be within the actual storage size.
##  @note  This is not usable with HandleStorage.
##  @param s Storage object.
##  @param offset Offset in storage.
##  @param buffer Input data.
##  @param size Data size.
##

proc appletStorageGetHandle*(s: ptr AppletStorage; `out`: ptr S64; handle: ptr Handle): Result {.
    cdecl, importc: "appletStorageGetHandle".}
## *
##  @brief Gets data for a HandleStorage originally from \ref appletCreateHandleStorage input.
##  @note  Only available on [2.0.0+].
##  @param s Storage object.
##  @param out Output value.
##  @param handle Output handle.
##

proc appletStorageMap*(s: ptr AppletStorage; `addr`: ptr pointer; size: ptr csize_t): Result {.
    cdecl, importc: "appletStorageMap".}
## *
##  @brief Maps TransferMemory for a HandleStorage. Wrapper for \ref appletCreateHandleStorage.
##  @note  The TransferMemory can be unmapped with \ref appletStorageCloseTmem.
##  @note  Do not use this if the AppletStorage already contains initialized TransferMemory state.
##  @param s Storage object.
##  @param addr Output mapped address (optional).
##  @param size Output size (optional).
##

proc appletPopLaunchParameter*(s: ptr AppletStorage; kind: AppletLaunchParameterKind): Result {.
    cdecl, importc: "appletPopLaunchParameter".}
## /@}
## /@name IApplicationFunctions: IFunctions for AppletType_*Application.
## /@{
## *
##  @brief Pops a LaunchParameter AppletStorage, the storage will be removed from sysmodule state during this.
##  @param[out] s Output storage.
##  @param kind See \ref AppletLaunchParameterKind.
##  @note Only available with AppletType_*Application.
##  @note See also acc.h \ref accountGetPreselectedUser (wrapper for appletPopLaunchParameter etc).
##

proc appletRequestLaunchApplication*(applicationId: U64; s: ptr AppletStorage): Result {.
    cdecl, importc: "appletRequestLaunchApplication".}
## *
##  @brief Requests to launch the specified application.
##  @note Only available with AppletType_*Application, or AppletType_LibraryApplet on [5.0.0+].
##  @param[in] application_id ApplicationId. Value 0 can be used to relaunch the current application.
##  @param[in] s Optional AppletStorage object, can be NULL. This is automatically closed. When NULL on pre-4.0.0 (or with AppletType_LibraryApplet), this will internally create a tmp storage with size 0 for use with the cmd. This is the storage available to the launched application via \ref appletPopLaunchParameter with ::AppletLaunchParameterKind_UserChannel.
##

proc appletRequestLaunchApplicationForQuest*(applicationId: U64;
    s: ptr AppletStorage; attr: ptr AppletApplicationAttributeForQuest): Result {.
    cdecl, importc: "appletRequestLaunchApplicationForQuest".}
## *
##  @brief Requests to launch the specified application, for kiosk systems.
##  @note Only available with AppletType_*Application on [3.0.0+].
##  @note Identical to \ref appletRequestLaunchApplication, except this allows the user to specify the attribute fields instead of the defaults being used.
##  @param[in] application_id ApplicationId
##  @param[in] s Optional AppletStorage object, can be NULL. This is automatically closed. When NULL on pre-4.0.0, this will internally create a tmp storage with size 0 for use with the cmd. This is the storage available to the launched application via \ref appletPopLaunchParameter with ::AppletLaunchParameterKind_UserChannel.
##  @param[in] attr Kiosk application attributes.
##

proc appletGetDesiredLanguage*(languageCode: ptr U64): Result {.cdecl,
    importc: "appletGetDesiredLanguage".}
## *
##  @brief Gets the DesiredLanguage for the current host application control.nacp.
##  @note Only available with AppletType_*Application.
##  @param[out] LanguageCode Output LanguageCode, see set.h.
##

proc appletGetDisplayVersion*(displayVersion: cstring): Result {.cdecl,
    importc: "appletGetDisplayVersion".}
## *
##  @brief Gets the DisplayVersion for the current host application control.nacp.
##  @note Only available with AppletType_*Application.
##  @param[out] displayVersion Output DisplayVersion string, must be at least 0x10-bytes. This is always NUL-terminated.
##

proc appletBeginBlockingHomeButtonShortAndLongPressed*(val: S64): Result {.cdecl,
    importc: "appletBeginBlockingHomeButtonShortAndLongPressed".}
## *
##  @brief Blocks the usage of the home button, for short (Home Menu) and long (Overlay) presses.
##  @note Only available with AppletType_*Application.
##  @param val Unknown. Official sw only uses hard-coded value 0 for this.
##

proc appletEndBlockingHomeButtonShortAndLongPressed*(): Result {.cdecl,
    importc: "appletEndBlockingHomeButtonShortAndLongPressed".}
## *
##  @brief Ends the blocking started by \ref appletBeginBlockingHomeButtonShortAndLongPressed.
##  @note Only available with AppletType_*Application.
##

proc appletBeginBlockingHomeButton*(val: S64): Result {.cdecl,
    importc: "appletBeginBlockingHomeButton".}
## *
##  @brief Blocks the usage of the home button, for short presses (Home Menu).
##  @note Only available with AppletType_*Application.
##  @param val Unknown nanoseconds. Value 0 can be used.
##

proc appletEndBlockingHomeButton*(): Result {.cdecl,
    importc: "appletEndBlockingHomeButton".}
## *
##  @brief Ends the blocking started by \ref appletBeginBlockingHomeButton.
##  @note Only available with AppletType_*Application.
##

proc appletNotifyRunning*(`out`: ptr bool) {.cdecl, importc: "appletNotifyRunning".}
## *
##  @brief Notify that the app is now running, for the Application logo screen. This throws a fatal-error on failure.
##  @note This will just return when applet-type isn't AppletType_Application, or when this was already used previously. Used automatically by \ref appletInitialize when __nx_applet_auto_notifyrunning is set to true (the default value).
##

proc appletGetPseudoDeviceId*(`out`: ptr Uuid): Result {.cdecl,
    importc: "appletGetPseudoDeviceId".}
## *
##  @brief Gets the PseudoDeviceId. This is derived from the output of a ns command, and from data in the host application control.nacp.
##  @note Only available with AppletType_*Application on [2.0.0+].
##  @param[out] out Output PseudoDeviceId.
##

proc appletSetMediaPlaybackState*(state: bool): Result {.cdecl,
    importc: "appletSetMediaPlaybackState".}
## / Set media playback state.
## / If state is set to true, screen dimming and auto sleep is disabled.
## / For *Application, this uses cmd SetMediaPlaybackStateForApplication, otherwise cmd SetMediaPlaybackState is used.

proc appletIsGamePlayRecordingSupported*(flag: ptr bool): Result {.cdecl,
    importc: "appletIsGamePlayRecordingSupported".}
## / Gets whether video recording is supported.
## / See also \ref appletInitializeGamePlayRecording.

proc appletSetGamePlayRecordingState*(state: bool): Result {.cdecl,
    importc: "appletSetGamePlayRecordingState".}
## / Disable/enable video recording. Only available after \ref appletInitializeGamePlayRecording was used.
## / See also \ref appletInitializeGamePlayRecording.

proc appletInitializeGamePlayRecording*(): Result {.cdecl,
    importc: "appletInitializeGamePlayRecording".}
## / Initializes video recording. This allocates a 0x6000000-byte buffer for the TransferMemory, cleanup is handled automatically during app exit in \ref appletExit.
## / Only available with AppletType_Application on [3.0.0+], hence errors from this can be ignored.
## / Video recording is only fully available system-side with [4.0.0+].
## / Only usable when running under an application which supports video recording. Using this is only needed when the host application control.nacp has VideoCaptureMode set to Enabled, with Automatic appletInitializeGamePlayRecording is not needed.

proc appletRequestFlushGamePlayingMovieForDebug*(): Result {.cdecl,
    importc: "appletRequestFlushGamePlayingMovieForDebug".}
## *
##  @brief Requests to save the video recording, as if the Capture-button was held.
##  @note Only available with AppletType_*Application on [4.0.0+].
##

proc appletRequestToShutdown*(): Result {.cdecl, importc: "appletRequestToShutdown".}
## *
##  @brief Requests a system shutdown. This will enter an infinite-sleep-loop on success.
##  @note Only available with AppletType_*Application on [3.0.0+].
##

proc appletRequestToReboot*(): Result {.cdecl, importc: "appletRequestToReboot".}
## *
##  @brief Requests a system reboot. This will enter an infinite-sleep-loop on success.
##  @note Only available with AppletType_*Application on [3.0.0+].
##

proc appletRequestToSleep*(): Result {.cdecl, importc: "appletRequestToSleep".}
## *
##  @brief RequestToSleep
##  @note Only available with AppletType_*Application on [10.0.0+].
##

proc appletExitAndRequestToShowThanksMessage*(): Result {.cdecl,
    importc: "appletExitAndRequestToShowThanksMessage".}
## *
##  @brief Exit the application and return to the kiosk demo menu. This terminates the current process. This will enter an infinite-sleep-loop on success.
##  @note Only available with AppletType_*Application on [4.0.0+], on kiosk systems (QuestFlag set).
##

proc appletInitializeApplicationCopyrightFrameBuffer*(): Result {.cdecl,
    importc: "appletInitializeApplicationCopyrightFrameBuffer".}
## *
##  @brief Initializes the ApplicationCopyrightFrameBuffer, with dimensions 1280x720 + the tmem for it. This is used as an overlay for screenshots.
##  @note Only available with AppletType_*Application on [5.0.0+].
##  @note Cleanup for this is handled automatically during app exit in \ref appletExit.
##

proc appletSetApplicationCopyrightImage*(buffer: pointer; size: csize_t; x: S32;
                                        y: S32; width: S32; height: S32;
                                        mode: AppletWindowOriginMode): Result {.
    cdecl, importc: "appletSetApplicationCopyrightImage".}
## *
##  @brief Sets the RGBA8 image for use with \ref appletInitializeApplicationCopyrightFrameBuffer. Overrides the current image, if this was already used previously.
##  @note Only available with AppletType_*Application on [5.0.0+].
##  @note The specified coordinates and width/height must be within the bounds of the framebuffer setup by \ref appletInitializeApplicationCopyrightFrameBuffer.
##  @param[in] buffer Input image buffer.
##  @param[in] size Input image buffer size.
##  @param[in] x X coordinate. Must not be negative.
##  @param[in] y Y coordinate. Must not be negative.
##  @param[in] width Image width. Must be >=1.
##  @param[in] height Image height. Must be >=1.
##  @param[in] mode \ref AppletWindowOriginMode
##

proc appletSetApplicationCopyrightVisibility*(visible: bool): Result {.cdecl,
    importc: "appletSetApplicationCopyrightVisibility".}
## *
##  @brief Sets the visibility for the image set by \ref appletSetApplicationCopyrightImage, in screenshots.
##  @note Only available with AppletType_*Application on [5.0.0+].
##  @param[in] visible Whether the image is visible. The default is true.
##

proc appletQueryApplicationPlayStatistics*(
    stats: ptr PdmApplicationPlayStatistics; applicationIds: ptr U64; count: S32;
    totalOut: ptr S32): Result {.cdecl,
                             importc: "appletQueryApplicationPlayStatistics".}
## *
##  @brief Gets ApplicationPlayStatistics.
##  @note Only available with AppletType_*Application on [5.0.0+].
##  @note The input ApplicationIds must be allowed via control.nacp with the current host application. The minimum allowed ApplicationId is the ApplicationId for the current application.
##  @param stats Output \ref PdmApplicationPlayStatistics array.
##  @param application_ids Input ApplicationIds array.
##  @param count Total entries in the input/output arrays.
##  @param total_out Total output entries.
##

proc appletQueryApplicationPlayStatisticsByUid*(uid: AccountUid;
    stats: ptr PdmApplicationPlayStatistics; applicationIds: ptr U64; count: S32;
    totalOut: ptr S32): Result {.cdecl, importc: "appletQueryApplicationPlayStatisticsByUid".}
## *
##  @brief Same as \ref appletQueryApplicationPlayStatistics except this gets playstats specific to the input userId.
##  @note Only available with AppletType_*Application on [6.0.0+].
##  @param[in] uid \ref AccountUid
##  @param[out] stats Output \ref PdmApplicationPlayStatistics array.
##  @param[in] application_ids Input ApplicationIds array.
##  @param[in] count Total entries in the input/output arrays.
##  @param[out] total_out Total output entries.
##

proc appletExecuteProgram*(programIndex: S32; buffer: pointer; size: csize_t): Result {.
    cdecl, importc: "appletExecuteProgram".}
## *
##  @brief Launches Application {current_ApplicationId}+programIndex. This will enter an infinite-sleep-loop on success.
##  @note Only available with AppletType_*Application on [5.0.0+].
##  @note Creates the storage if needed. Uses cmd ClearUserChannel. Uses cmd UnpopToUserChannel when the storage was created. Lastly cmd ExecuteProgramCmd is used.
##  @param[in] programIndex ProgramIndex, must be 0x0-0xFF. 0 is the same as the current application. ProgramIndex values where the application is not installed should not be used.
##  @param[in] buffer Optional buffer containing the storage data which will be used for ::AppletLaunchParameterKind_UserChannel with the launched Application, can be NULL.
##  @param[in] size Size of the above buffer, 0 to not use the storage. Must be <=0x1000.
##

proc appletJumpToSubApplicationProgramForDevelopment*(applicationId: U64;
    buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "appletJumpToSubApplicationProgramForDevelopment".}
## *
##  @brief Launches the specified ApplicationId.
##  @note Only available with AppletType_*Application on [5.0.0+], with DebugMode enabled.
##  @note Creates the storage if needed. Uses cmd ClearUserChannel. Uses cmd UnpopToUserChannel when the storage was created. Lastly cmd ExecuteProgramCmd is used.
##  @param[in] application_id ApplicationId.
##  @param[in] buffer Optional buffer containing the storage data which will be used for ::AppletLaunchParameterKind_UserChannel with the launched Application, can be NULL.
##  @param[in] size Size of the above buffer, 0 to not use the storage. Must be <=0x1000.
##

proc appletRestartProgram*(buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "appletRestartProgram".}
## *
##  @brief Relaunches the current Application.
##  @note Only available with AppletType_*Application on [5.0.0+].
##  @note Creates the storage if needed. Uses cmd ClearUserChannel. Uses cmd UnpopToUserChannel when the storage was created. Lastly cmd ExecuteProgramCmd is used.
##  @param[in] buffer Optional buffer containing the storage data which will be used for ::AppletLaunchParameterKind_UserChannel with the launched Application, can be NULL.
##  @param[in] size Size of the above buffer, 0 to not use the storage. Must be <=0x1000.
##

proc appletGetPreviousProgramIndex*(programIndex: ptr S32): Result {.cdecl,
    importc: "appletGetPreviousProgramIndex".}
## *
##  @brief Gets the ProgramIndex of the program which launched this program.
##  @note Only available with AppletType_*Application on [5.0.0+].
##  @param[out] programIndex ProgramIndex, -1 when there was no previous program.
##

proc appletSetDelayTimeToAbortOnGpuError*(val: U64): Result {.cdecl,
    importc: "appletSetDelayTimeToAbortOnGpuError".}
## *
##  @brief SetDelayTimeToAbortOnGpuError
##  @note Only available with AppletType_*Application on [11.0.0+].
##  @param[in] val Input nanoseconds value.
##

proc appletGetFriendInvitationStorageChannelEvent*(outEvent: ptr Event): Result {.
    cdecl, importc: "appletGetFriendInvitationStorageChannelEvent".}
## *
##  @brief Gets an Event which is signaled when a new storage is available with \ref appletTryPopFromFriendInvitationStorageChannel where previously no storage was available, this event is automatically cleared by the system once the last storage is popped.
##  @note This is used by \ref friendsGetFriendInvitationNotificationEvent.
##  @note Only available with AppletType_*Application on [9.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletTryPopFromFriendInvitationStorageChannel*(s: ptr AppletStorage): Result {.
    cdecl, importc: "appletTryPopFromFriendInvitationStorageChannel".}
## *
##  @brief Pops a storage from the FriendInvitation StorageChannel.
##  @note This is used by \ref friendsTryPopFriendInvitationNotificationInfo.
##  @note Only available with AppletType_*Application on [9.0.0+].
##  @param[out] s Storage object.
##

proc appletGetNotificationStorageChannelEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "appletGetNotificationStorageChannelEvent".}
## *
##  @brief Gets an Event which is signaled when a new storage is available with \ref appletTryPopFromNotificationStorageChannel where previously no storage was available, this event is automatically cleared by the system once the last storage is popped.
##  @note This is used by \ref notifGetNotificationSystemEvent.
##  @note Only available with AppletType_*Application on [9.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletTryPopFromNotificationStorageChannel*(s: ptr AppletStorage): Result {.
    cdecl, importc: "appletTryPopFromNotificationStorageChannel".}
## *
##  @brief Pops a storage from the Notification StorageChannel.
##  @note This is used by \ref notifTryPopNotifiedApplicationParameter.
##  @note Only available with AppletType_*Application on [9.0.0+].
##  @param[out] s Storage object.
##

proc appletGetHealthWarningDisappearedSystemEvent*(outEvent: ptr Event): Result {.
    cdecl, importc: "appletGetHealthWarningDisappearedSystemEvent".}
## *
##  @brief GetHealthWarningDisappearedSystemEvent
##  @note Only available with AppletType_*Application on [9.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletSetHdcpAuthenticationActivated*(flag: bool): Result {.cdecl,
    importc: "appletSetHdcpAuthenticationActivated".}
## *
##  @brief SetHdcpAuthenticationActivated
##  @note Only available with AppletType_*Application on [9.0.0+].
##  @param[in] flag Whether HdcpAuthentication is activated.
##

proc appletGetLastApplicationExitReason*(`out`: ptr S32): Result {.cdecl,
    importc: "appletGetLastApplicationExitReason".}
## *
##  @brief GetLastApplicationExitReason
##  @note Only available with AppletType_*Application on [11.0.0+].
##  @param[out] out Output value.
##

proc appletCreateMovieMaker*(srvOut: ptr Service; tmem: ptr TransferMemory): Result {.
    cdecl, importc: "appletCreateMovieMaker".}
## *
##  @brief CreateMovieMaker. Do not use this directly, use \ref grcCreateMovieMaker instead.
##  @note Only available with AppletType_*Application on [5.0.0+].
##  @param[out] srv_out Output Service for applet IMovieMaker.
##  @param[in] tmem TransferMemory
##

proc appletPrepareForJit*(): Result {.cdecl, importc: "appletPrepareForJit".}
## *
##  @brief Launches the jit-sysmodule when it was not previously launched by this cmd. Returns 0 when it was previously launched.
##  @note Only available with AppletType_*Application on [5.0.0+].
##  @note Requires the jit-sysmodule to actually be installed.
##

proc appletRequestToGetForeground*(): Result {.cdecl,
    importc: "appletRequestToGetForeground".}
## /@}
## /@name IHomeMenuFunctions: IFunctions for AppletType_SystemApplet and on [15.0.0+] for AppletType_LibraryApplet.
## /@{
## *
##  @brief RequestToGetForeground
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet.
##

proc appletLockForeground*(): Result {.cdecl, importc: "appletLockForeground".}
## *
##  @brief LockForeground
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet.
##

proc appletUnlockForeground*(): Result {.cdecl, importc: "appletUnlockForeground".}
## *
##  @brief UnlockForeground
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet.
##

proc appletPopFromGeneralChannel*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPopFromGeneralChannel".}
## *
##  @brief Pops a storage from the general channel.
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet.
##  @param[out] s Storage object.
##

proc appletGetPopFromGeneralChannelEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "appletGetPopFromGeneralChannelEvent".}
## *
##  @brief Gets an Event which is signaled when a new storage is available with \ref appletPopFromGeneralChannel where previously no storage was available, this event is automatically cleared by the system once the last storage is popped.
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletGetHomeButtonWriterLockAccessor*(a: ptr AppletLockAccessor): Result {.
    cdecl, importc: "appletGetHomeButtonWriterLockAccessor".}
## *
##  @brief Gets a \ref AppletLockAccessor for HomeButtonWriter.
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet.
##  @note Similar to using \ref appletGetWriterLockAccessorEx with inval=0.
##  @param a LockAccessor object.
##

proc appletIsSleepEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "appletIsSleepEnabled".}
## *
##  @brief IsSleepEnabled
##  @note Only available with AppletType_SystemApplet on [11.0.0+], or on [15.0.0+] with AppletType_LibraryApplet.
##  @param[out] out Output flag.
##

proc appletPopRequestLaunchApplicationForDebug*(uids: ptr AccountUid; count: S32;
    applicationId: ptr U64; totalOut: ptr S32): Result {.cdecl,
    importc: "appletPopRequestLaunchApplicationForDebug".}
## *
##  @brief PopRequestLaunchApplicationForDebug
##  @note Only available with AppletType_SystemApplet on [6.0.0+], or on [15.0.0+] with AppletType_LibraryApplet.
##  @param[out] uids Output array of \ref AccountUid.
##  @param[in] count Size of the uids array in entries, must be at least the size stored in state.
##  @param[out] application_id Output ApplicationId.
##  @param[out] total_out Total output userID entries.
##

proc appletIsForceTerminateApplicationDisabledForDebug*(`out`: ptr bool): Result {.
    cdecl, importc: "appletIsForceTerminateApplicationDisabledForDebug".}
## *
##  @brief IsForceTerminateApplicationDisabledForDebug
##  @note Only available with AppletType_SystemApplet on [9.0.0+], or on [15.0.0+] with AppletType_LibraryApplet.
##  @param[out] out Output flag. 0 when DebugMode is not enabled, otherwise this is loaded from a system-setting.
##

proc appletLaunchDevMenu*(): Result {.cdecl, importc: "appletLaunchDevMenu".}
## *
##  @brief Launches DevMenu and the dev Overlay-applet. This will enter an infinite-sleep-loop on success.
##  @note Only available with AppletType_SystemApplet on [8.0.0+], or on [15.0.0+] with AppletType_LibraryApplet.
##  @note This verifies that DebugMode is enabled, then uses a ns cmd. That cmd then loads the system-settings for these two ProgramIds (which normally only exist on devunits), and verifies that these programs are installed + launches them.
##

proc appletSetLastApplicationExitReason*(reason: S32): Result {.cdecl,
    importc: "appletSetLastApplicationExitReason".}
## *
##  @brief SetLastApplicationExitReason
##  @note Only available with AppletType_SystemApplet on [11.0.0+], or on [15.0.0+] with AppletType_LibraryApplet.
##  @param[in] reason Reason
##

proc appletStartSleepSequence*(flag: bool): Result {.cdecl,
    importc: "appletStartSleepSequence".}
## /@}
## /@name IGlobalStateController
## /@{
## *
##  @brief Start the sequence for entering sleep-mode.
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##  @param[in] flag Flag, official sw uses hard-coded value = true.
##

proc appletStartShutdownSequence*(): Result {.cdecl,
    importc: "appletStartShutdownSequence".}
## *
##  @brief Start the system-shutdown sequence.
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##

proc appletStartRebootSequence*(): Result {.cdecl,
    importc: "appletStartRebootSequence".}
## *
##  @brief Start the system-reboot sequence.
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##

proc appletIsAutoPowerDownRequested*(`out`: ptr bool): Result {.cdecl,
    importc: "appletIsAutoPowerDownRequested".}
## *
##  @brief IsAutoPowerDownRequested. Uses an idle:sys cmd internally.
##  @note Only available with AppletType_SystemApplet on [7.0.0+], or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##  @param[out] out Output flag.
##

proc appletLoadAndApplyIdlePolicySettings*(): Result {.cdecl,
    importc: "appletLoadAndApplyIdlePolicySettings".}
## *
##  @brief LoadAndApplyIdlePolicySettings. Uses an idle:sys cmd internally.
##  @note Only available with AppletType_SystemApplet, or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##

proc appletNotifyCecSettingsChanged*(): Result {.cdecl,
    importc: "appletNotifyCecSettingsChanged".}
## *
##  @brief NotifyCecSettingsChanged. Uses an omm cmd internally.
##  @note Only available with AppletType_SystemApplet on [2.0.0+], or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##

proc appletSetDefaultHomeButtonLongPressTime*(val: S64): Result {.cdecl,
    importc: "appletSetDefaultHomeButtonLongPressTime".}
## *
##  @brief Sets the DefaultHomeButtonLongPressTime.
##  @note Only available with AppletType_SystemApplet on [3.0.0+], or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##  @param[in] val Input value.
##

proc appletUpdateDefaultDisplayResolution*(): Result {.cdecl,
    importc: "appletUpdateDefaultDisplayResolution".}
## *
##  @brief UpdateDefaultDisplayResolution. Uses an omm cmd internally.
##  @note Only available with AppletType_SystemApplet on [3.0.0+], or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##

proc appletShouldSleepOnBoot*(`out`: ptr bool): Result {.cdecl,
    importc: "appletShouldSleepOnBoot".}
## *
##  @brief ShouldSleepOnBoot. Uses an omm cmd internally.
##  @note Only available with AppletType_SystemApplet on [3.0.0+], or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##  @param[out] out Output flag.
##

proc appletGetHdcpAuthenticationFailedEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "appletGetHdcpAuthenticationFailedEvent".}
## *
##  @brief Gets an Event which is signaled for HdcpAuthenticationFailed.
##  @note Only available with AppletType_SystemApplet on [4.0.0+], or on [15.0.0+] with AppletType_LibraryApplet/AppletType_OverlayApplet.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletCreateApplication*(a: ptr AppletApplication; applicationId: U64): Result {.
    cdecl, importc: "appletCreateApplication".}
## /@}
## /@name IApplicationCreator
## /@{
## *
##  @brief Creates an Application.
##  @note Only available with AppletType_SystemApplet.
##  @param[out] a \ref AppletApplication
##  @param[in] application_id ApplicationId.
##

proc appletPopLaunchRequestedApplication*(a: ptr AppletApplication): Result {.cdecl,
    importc: "appletPopLaunchRequestedApplication".}
## *
##  @brief Pops a \ref AppletApplication for a requested Application launch.
##  @note Only available with AppletType_SystemApplet.
##  @param[out] a \ref AppletApplication
##

proc appletCreateSystemApplication*(a: ptr AppletApplication;
                                   systemApplicationId: U64): Result {.cdecl,
    importc: "appletCreateSystemApplication".}
## *
##  @brief Creates a SystemApplication.
##  @note Only available with AppletType_SystemApplet.
##  @param[out] a \ref AppletApplication
##  @param[in] system_application_id SystemApplicationId.
##

proc appletPopFloatingApplicationForDevelopment*(a: ptr AppletApplication): Result {.
    cdecl, importc: "appletPopFloatingApplicationForDevelopment".}
## *
##  @brief PopFloatingApplicationForDevelopment.
##  @note Only available with AppletType_SystemApplet. Should not be used if no FloatingApplication is available.
##  @param[out] a \ref AppletApplication
##

proc appletApplicationClose*(a: ptr AppletApplication) {.cdecl,
    importc: "appletApplicationClose".}
## /@}
## /@name IApplicationAccessor
## /@{
## *
##  @brief Close an \ref AppletApplication.
##  @param a \ref AppletApplication
##

proc appletApplicationActive*(a: ptr AppletApplication): bool {.cdecl,
    importc: "appletApplicationActive".}
## *
##  @brief Returns whether the AppletApplication object was initialized.
##  @param a \ref AppletApplication
##

proc appletApplicationStart*(a: ptr AppletApplication): Result {.cdecl,
    importc: "appletApplicationStart".}
## *
##  @brief Starts the Application.
##  @param a \ref AppletApplication
##

proc appletApplicationRequestExit*(a: ptr AppletApplication): Result {.cdecl,
    importc: "appletApplicationRequestExit".}
## *
##  @brief Requests the Application to exit.
##  @param a \ref AppletApplication
##

proc appletApplicationTerminate*(a: ptr AppletApplication): Result {.cdecl,
    importc: "appletApplicationTerminate".}
## *
##  @brief Terminate the Application.
##  @param a \ref AppletApplication
##

proc appletApplicationJoin*(a: ptr AppletApplication) {.cdecl,
    importc: "appletApplicationJoin".}
## *
##  @brief Waits for the Application to exit.
##  @param a \ref AppletApplication
##

proc appletApplicationCheckFinished*(a: ptr AppletApplication): bool {.cdecl,
    importc: "appletApplicationCheckFinished".}
## *
##  @brief Waits on the Application StateChangedEvent with timeout=0, and returns whether it was successful.
##  @param a \ref AppletApplication
##

proc appletApplicationGetExitReason*(a: ptr AppletApplication): AppletApplicationExitReason {.
    cdecl, importc: "appletApplicationGetExitReason".}
## *
##  @brief Gets the \ref AppletApplicationExitReason set by \ref appletApplicationJoin.
##  @param a \ref AppletApplication
##

proc appletApplicationRequestForApplicationToGetForeground*(
    a: ptr AppletApplication): Result {.cdecl, importc: "appletApplicationRequestForApplicationToGetForeground".}
## *
##  @brief RequestForApplicationToGetForeground.
##  @param a \ref AppletApplication
##

proc appletApplicationTerminateAllLibraryApplets*(a: ptr AppletApplication): Result {.
    cdecl, importc: "appletApplicationTerminateAllLibraryApplets".}
## *
##  @brief TerminateAllLibraryApplets which were created by the Application.
##

proc appletApplicationAreAnyLibraryAppletsLeft*(a: ptr AppletApplication;
    `out`: ptr bool): Result {.cdecl,
                           importc: "appletApplicationAreAnyLibraryAppletsLeft".}
## *
##  @brief AreAnyLibraryAppletsLeft which were created by the Application.
##  @param a \ref AppletApplication
##  @param[out] out Output flag.
##

proc appletApplicationRequestExitLibraryAppletOrTerminate*(
    a: ptr AppletApplication; timeout: U64): Result {.cdecl,
    importc: "appletApplicationRequestExitLibraryAppletOrTerminate".}
## *
##  @brief Calls the same func as \ref appletHolderRequestExitOrTerminate with the output IAppletAccessor from the GetCurrentLibraryApplet cmd.
##  @param a \ref AppletApplication
##  @param[in] timeout Timeout in nanoseconds. UINT64_MAX for no timeout.
##

proc appletApplicationGetApplicationId*(a: ptr AppletApplication;
                                       applicationId: ptr U64): Result {.cdecl,
    importc: "appletApplicationGetApplicationId".}
## *
##  @brief Gets the ApplicationId for the Application.
##  @param a \ref AppletApplication
##  @param[out] application_id Output ApplicationId.
##

proc appletApplicationPushLaunchParameter*(a: ptr AppletApplication;
    kind: AppletLaunchParameterKind; s: ptr AppletStorage): Result {.cdecl,
    importc: "appletApplicationPushLaunchParameter".}
## *
##  @brief Pushes a LaunchParameter AppletStorage to the Application.
##  @note This uses \ref appletStorageClose automatically.
##  @param a \ref AppletApplication
##  @param[in] kind \ref AppletLaunchParameterKind
##  @param[in] s Input storage.
##

proc appletApplicationGetApplicationControlProperty*(a: ptr AppletApplication;
    nacp: ptr NacpStruct): Result {.cdecl, importc: "appletApplicationGetApplicationControlProperty".}
## *
##  @brief Gets the \ref NacpStruct for the Application.
##  @note Not usable when the \ref AppletApplication is for an AppletType_SystemApplication.
##  @param a \ref AppletApplication
##  @param[out] nacp \ref NacpStruct
##

proc appletApplicationGetApplicationLaunchProperty*(a: ptr AppletApplication;
    `out`: ptr AppletApplicationLaunchProperty): Result {.cdecl,
    importc: "appletApplicationGetApplicationLaunchProperty".}
## *
##  @brief Gets the \ref AppletApplicationLaunchProperty for the Application.
##  @note Only available on [2.0.0+]. Not usable when the \ref AppletApplication is for an AppletType_SystemApplication.
##  @param a \ref AppletApplication
##  @param[out] out \ref AppletApplicationLaunchProperty
##

proc appletApplicationGetApplicationLaunchRequestInfo*(a: ptr AppletApplication;
    `out`: ptr AppletApplicationLaunchRequestInfo): Result {.cdecl,
    importc: "appletApplicationGetApplicationLaunchRequestInfo".}
## *
##  @brief Gets the \ref AppletApplicationLaunchRequestInfo for the Application.
##  @note Only available on [6.0.0+].
##  @param a \ref AppletApplication
##  @param[out] out \ref AppletApplicationLaunchRequestInfo
##

proc appletApplicationSetUsers*(a: ptr AppletApplication; uids: ptr AccountUid;
                               count: S32; flag: bool): Result {.cdecl,
    importc: "appletApplicationSetUsers".}
## *
##  @brief SetUsers for the Application.
##  @note Only available on [6.0.0+].
##  @param a \ref AppletApplication
##  @param[in] uids Input array of \ref AccountUid.
##  @param[in] count Size of the uids array in entries, must be <=ACC_USER_LIST_SIZE.
##  @param[in] flag When this flag is true, this just clears the users_available state flag to 0 and returns.
##

proc appletApplicationCheckRightsEnvironmentAvailable*(a: ptr AppletApplication;
    `out`: ptr bool): Result {.cdecl, importc: "appletApplicationCheckRightsEnvironmentAvailable".}
## *
##  @brief CheckRightsEnvironmentAvailable.
##  @note Only available on [6.0.0+].
##  @param a \ref AppletApplication
##  @param[out] out Output flag.
##

proc appletApplicationGetNsRightsEnvironmentHandle*(a: ptr AppletApplication;
    handle: ptr U64): Result {.cdecl, importc: "appletApplicationGetNsRightsEnvironmentHandle".}
## *
##  @brief GetNsRightsEnvironmentHandle.
##  @note Only available on [6.0.0+].
##  @param a \ref AppletApplication
##  @param[out] handle Output NsRightsEnvironmentHandle.
##

proc appletApplicationGetDesirableUids*(a: ptr AppletApplication;
                                       uids: ptr AccountUid; count: S32;
                                       totalOut: ptr S32): Result {.cdecl,
    importc: "appletApplicationGetDesirableUids".}
## *
##  @brief Gets an array of userIds for the Application DesirableUids.
##  @note Only available on [6.0.0+].
##  @note qlaunch only uses 1 userId with this.
##  @param a \ref AppletApplication
##  @param[out] uids Output array of \ref AccountUid.
##  @param[in] count Size of the uids array in entries, must be at least the size stored in state.
##  @param[out] total_out Total output entries.
##

proc appletApplicationReportApplicationExitTimeout*(a: ptr AppletApplication): Result {.
    cdecl, importc: "appletApplicationReportApplicationExitTimeout".}
## *
##  @brief ReportApplicationExitTimeout.
##  @note Only available on [6.0.0+].
##  @param a \ref AppletApplication
##

proc appletApplicationSetApplicationAttribute*(a: ptr AppletApplication;
    attr: ptr AppletApplicationAttribute): Result {.cdecl,
    importc: "appletApplicationSetApplicationAttribute".}
## *
##  @brief Sets the \ref AppletApplicationAttribute for the Application.
##  @note Only available on [8.0.0+].
##  @param a \ref AppletApplication
##  @param[in] attr \ref AppletApplicationAttribute
##

proc appletApplicationHasSaveDataAccessPermission*(a: ptr AppletApplication;
    applicationId: U64; `out`: ptr bool): Result {.cdecl,
    importc: "appletApplicationHasSaveDataAccessPermission".}
## *
##  @brief Gets whether the savedata specified by the input ApplicationId is accessible.
##  @note Only available on [8.0.0+].
##  @param a \ref AppletApplication
##  @param[in] application_id ApplicationId for the savedata.
##  @param[out] out Output flag.
##

proc appletApplicationPushToFriendInvitationStorageChannel*(
    a: ptr AppletApplication; uid: AccountUid; buffer: pointer; size: U64): Result {.
    cdecl, importc: "appletApplicationPushToFriendInvitationStorageChannel".}
## *
##  @brief Creates a storage using the specified input then pushes it to the FriendInvitation StorageChannel.
##  @note The system will clear the StorageChannel before pushing the storage.
##  @note Only available on [9.0.0+].
##  @param a \ref AppletApplication
##  @param[in] uid \ref AccountUid
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size.
##

proc appletApplicationPushToNotificationStorageChannel*(a: ptr AppletApplication;
    buffer: pointer; size: U64): Result {.cdecl, importc: "appletApplicationPushToNotificationStorageChannel".}
## *
##  @brief Creates a storage using the specified input then pushes it to the Notification StorageChannel.
##  @note The system will clear the StorageChannel before pushing the storage.
##  @note Only available on [9.0.0+].
##  @param a \ref AppletApplication
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size.
##

proc appletApplicationRequestApplicationSoftReset*(a: ptr AppletApplication): Result {.
    cdecl, importc: "appletApplicationRequestApplicationSoftReset".}
## *
##  @brief RequestApplicationSoftReset
##  @note Only available on [10.0.0+].
##  @param a \ref AppletApplication
##

proc appletApplicationRestartApplicationTimer*(a: ptr AppletApplication): Result {.
    cdecl, importc: "appletApplicationRestartApplicationTimer".}
## *
##  @brief RestartApplicationTimer
##  @note Only available on [10.0.0+].
##  @param a \ref AppletApplication
##

proc appletPopInData*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPopInData".}
## /@}
## /@name ILibraryAppletSelfAccessor
## /@{
## *
##  @brief Pops a storage from current-LibraryApplet input.
##  @note Only available with AppletType_LibraryApplet.
##  @param[out] s Storage object.
##

proc appletPushOutData*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPushOutData".}
## *
##  @brief Pushes a storage for current-LibraryApplet output.
##  @note Only available with AppletType_LibraryApplet.
##  @note This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##

proc appletPopInteractiveInData*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPopInteractiveInData".}
## *
##  @brief Pops a storage from current-LibraryApplet Interactive input.
##  @note Only available with AppletType_LibraryApplet.
##  @param[out] s Storage object.
##

proc appletPushInteractiveOutData*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPushInteractiveOutData".}
## *
##  @brief Pushes a storage for current-LibraryApplet Interactive output.
##  @note Only available with AppletType_LibraryApplet.
##  @note This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##

proc appletGetPopInDataEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "appletGetPopInDataEvent".}
## *
##  @brief Gets an Event which is signaled when a new storage is available with \ref appletPopInData where previously no storage was available, this event is automatically cleared by the system once the last storage is popped.
##  @note Only available with AppletType_LibraryApplet.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletGetPopInteractiveInDataEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "appletGetPopInteractiveInDataEvent".}
## *
##  @brief Gets an Event which is signaled when a new storage is available with \ref appletPopInteractiveInData where previously no storage was available, this event is automatically cleared by the system once the last storage is popped.
##  @note Only available with AppletType_LibraryApplet.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletGetLibraryAppletInfo*(info: ptr LibAppletInfo): Result {.cdecl,
    importc: "appletGetLibraryAppletInfo".}
## *
##  @brief Gets the \ref LibAppletInfo for the current LibraryApplet.
##  @note Only available with AppletType_LibraryApplet.
##  @param[out] info \ref LibAppletInfo
##

proc appletGetMainAppletIdentityInfo*(info: ptr AppletIdentityInfo): Result {.cdecl,
    importc: "appletGetMainAppletIdentityInfo".}
## *
##  @brief Gets the \ref AppletIdentityInfo for the MainApplet.
##  @note Only available with AppletType_LibraryApplet.
##  @param[out] info \ref AppletIdentityInfo
##

proc appletCanUseApplicationCore*(`out`: ptr bool): Result {.cdecl,
    importc: "appletCanUseApplicationCore".}
## *
##  @brief CanUseApplicationCore
##  @note Only available with AppletType_LibraryApplet.
##  @param[out] out Output flag.
##

proc appletGetCallerAppletIdentityInfo*(info: ptr AppletIdentityInfo): Result {.
    cdecl, importc: "appletGetCallerAppletIdentityInfo".}
## *
##  @brief Gets the \ref AppletIdentityInfo for the CallerApplet.
##  @note Only available with AppletType_LibraryApplet.
##  @param[out] info \ref AppletIdentityInfo
##

proc appletGetMainAppletApplicationControlProperty*(nacp: ptr NacpStruct): Result {.
    cdecl, importc: "appletGetMainAppletApplicationControlProperty".}
## *
##  @brief Gets the \ref NacpStruct for the MainApplet.
##  @note Only available with AppletType_LibraryApplet on [2.0.0+].
##  @param[out] nacp \ref NacpStruct
##

proc appletGetMainAppletStorageId*(storageId: ptr NcmStorageId): Result {.cdecl,
    importc: "appletGetMainAppletStorageId".}
## *
##  @brief Gets the NcmStorageId for the MainApplet.
##  @note Only available with AppletType_LibraryApplet on [2.0.0+].
##  @param[out] storageId \ref NcmStorageId
##

proc appletGetCallerAppletIdentityInfoStack*(stack: ptr AppletIdentityInfo;
    count: S32; totalOut: ptr S32): Result {.cdecl, importc: "appletGetCallerAppletIdentityInfoStack".}
## *
##  @brief Gets an array of \ref AppletIdentityInfo for the CallerStack.
##  @note Only available with AppletType_LibraryApplet on [3.0.0+].
##  @param[out] stack Output array of \ref AppletIdentityInfo.
##  @param[in] count Size of the stack array.
##  @param[out] total_out Total output entries.
##

proc appletGetNextReturnDestinationAppletIdentityInfo*(
    info: ptr AppletIdentityInfo): Result {.cdecl, importc: "appletGetNextReturnDestinationAppletIdentityInfo".}
## *
##  @brief Gets the \ref AppletIdentityInfo for the NextReturnDestinationApplet.
##  @note Only available with AppletType_LibraryApplet on [4.0.0+].
##  @param[out] info \ref AppletIdentityInfo
##

proc appletGetDesirableKeyboardLayout*(layout: ptr SetKeyboardLayout): Result {.
    cdecl, importc: "appletGetDesirableKeyboardLayout".}
## *
##  @brief Gets the DesirableKeyboardLayout previously set by \ref appletSetDesirableKeyboardLayout. An error is returned when it's not set.
##  @note Only available with AppletType_LibraryApplet on [4.0.0+].
##  @param[out] layout Output \ref SetKeyboardLayout.
##

proc appletPopExtraStorage*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPopExtraStorage".}
## *
##  @brief Pops a storage from current-LibraryApplet Extra input.
##  @note Only available with AppletType_LibraryApplet.
##  @param[out] s Storage object.
##

proc appletGetPopExtraStorageEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "appletGetPopExtraStorageEvent".}
## *
##  @brief Gets an Event which is signaled when a new storage is available with \ref appletPopExtraStorage where previously no storage was available, this event is automatically cleared by the system once the last storage is popped.
##  @note Only available with AppletType_LibraryApplet.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletUnpopInData*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletUnpopInData".}
## *
##  @brief Unpop a storage for current-LibraryApplet input.
##  @note Only available with AppletType_LibraryApplet.
##  @note This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##

proc appletUnpopExtraStorage*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletUnpopExtraStorage".}
## *
##  @brief Unpop a storage for current-LibraryApplet Extra input.
##  @note Only available with AppletType_LibraryApplet.
##  @note This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##

proc appletGetIndirectLayerProducerHandle*(`out`: ptr U64): Result {.cdecl,
    importc: "appletGetIndirectLayerProducerHandle".}
## *
##  @brief Gets the IndirectLayerProducerHandle.
##  @note Only available with AppletType_LibraryApplet on [2.0.0+].
##  @param[out] out Output IndirectLayerProducerHandle.
##

proc appletGetMainAppletApplicationDesiredLanguage*(languageCode: ptr U64): Result {.
    cdecl, importc: "appletGetMainAppletApplicationDesiredLanguage".}
## *
##  @brief Gets the DesiredLanguage for the MainApplet.
##  @note Only available with AppletType_LibraryApplet on [4.0.0+].
##  @param[out] LanguageCode Output LanguageCode, see set.h.
##

proc appletGetCurrentApplicationId*(applicationId: ptr U64): Result {.cdecl,
    importc: "appletGetCurrentApplicationId".}
## *
##  @brief Gets the ApplicationId for the currently running Application.
##  @note Only available with AppletType_LibraryApplet on [8.0.0+].
##  @param[out] application_id Output ApplicationId, 0 when no Application is running.
##

proc appletRequestExitToSelf*(): Result {.cdecl, importc: "appletRequestExitToSelf".}
## *
##  @brief Exits the current applet. Same as \ref appletHolderRequestExit except this is for the current applet.
##  @note Only available with AppletType_LibraryApplet on [6.0.0+].
##

proc appletCreateGameMovieTrimmer*(srvOut: ptr Service; tmem: ptr TransferMemory): Result {.
    cdecl, importc: "appletCreateGameMovieTrimmer".}
## *
##  @brief CreateGameMovieTrimmer. Do not use this directly, use \ref grcTrimGameMovie instead.
##  @note Only available with AppletType_LibraryApplet on [4.0.0+].
##  @note See also \ref appletReserveResourceForMovieOperation and \ref appletUnreserveResourceForMovieOperation.
##  @param[out] srv_out Output Service for grc IGameMovieTrimmer.
##  @param[in] tmem TransferMemory
##

proc appletReserveResourceForMovieOperation*(): Result {.cdecl,
    importc: "appletReserveResourceForMovieOperation".}
## *
##  @brief ReserveResourceForMovieOperation. Must be used at some point prior to \ref appletCreateGameMovieTrimmer.
##  @note Only available with AppletType_LibraryApplet on [5.0.0+].
##

proc appletUnreserveResourceForMovieOperation*(): Result {.cdecl,
    importc: "appletUnreserveResourceForMovieOperation".}
## *
##  @brief UnreserveResourceForMovieOperation. Must be used at some point after all finished with GameMovieTrimmer usage (\ref appletCreateGameMovieTrimmer).
##  @note Only available with AppletType_LibraryApplet on [5.0.0+].
##

proc appletGetMainAppletAvailableUsers*(uids: ptr AccountUid; count: S32;
                                       flag: ptr bool; totalOut: ptr S32): Result {.
    cdecl, importc: "appletGetMainAppletAvailableUsers".}
## *
##  @brief Gets an array of userIds for the MainApplet AvailableUsers.
##  @note Only available with AppletType_LibraryApplet on [6.0.0+].
##  @param[out] uids Output array of \ref AccountUid.
##  @param[in] count Size of the uids array in entries, must be at least ACC_USER_LIST_SIZE.
##  @param[out] flag When true, this indicates that no users are available.
##  @param[out] total_out Total output entries. This is -1 when flag is true.
##

proc appletSetApplicationMemoryReservation*(val: U64): Result {.cdecl,
    importc: "appletSetApplicationMemoryReservation".}
## *
##  @brief SetApplicationMemoryReservation
##  @note Only available with AppletType_LibraryApplet on [10.0.0+].
##  @note An Application must be currently running.
##  @param[in] val Input value.
##

proc appletShouldSetGpuTimeSliceManually*(`out`: ptr bool): Result {.cdecl,
    importc: "appletShouldSetGpuTimeSliceManually".}
## *
##  @brief ShouldSetGpuTimeSliceManually
##  @note Only available with AppletType_LibraryApplet on [10.0.0+].
##  @param[out] out Output flag.
##

proc appletBeginToWatchShortHomeButtonMessage*(): Result {.cdecl,
    importc: "appletBeginToWatchShortHomeButtonMessage".}
## /@}
## /@name IOverlayFunctions: IFunctions for AppletType_OverlayApplet.
## /@{
## *
##  @brief Stops forwarding the input to the foreground app.
##  @note Only available with AppletType_OverlayApplet.
##  @note You have to call this to receive inputs through the hid service when running as the overlay applet.
##

proc appletEndToWatchShortHomeButtonMessage*(): Result {.cdecl,
    importc: "appletEndToWatchShortHomeButtonMessage".}
## *
##  @brief Forwards input to the foreground app.
##  @note Only available with AppletType_OverlayApplet.
##  @note After calling this the overlay applet won't receive any input until \ref appletBeginToWatchShortHomeButtonMessage is called again.
##

proc appletGetApplicationIdForLogo*(applicationId: ptr U64): Result {.cdecl,
    importc: "appletGetApplicationIdForLogo".}
## *
##  @brief Gets the ApplicationId for displaying the logo screen during application launch.
##  @note Only available with AppletType_OverlayApplet.
##  @param[out] application_id Output ApplicationId, 0 when no application is running.
##

proc appletSetGpuTimeSliceBoost*(val: U64): Result {.cdecl,
    importc: "appletSetGpuTimeSliceBoost".}
## *
##  @brief Sets the GpuTimeSliceBoost.
##  @note Only available with AppletType_OverlayApplet.
##  @param[in] val Input value.
##

proc appletSetAutoSleepTimeAndDimmingTimeEnabled*(flag: bool): Result {.cdecl,
    importc: "appletSetAutoSleepTimeAndDimmingTimeEnabled".}
## *
##  @brief Sets AutoSleepTimeAndDimmingTimeEnabled.
##  @note Only available with AppletType_OverlayApplet on [2.0.0+].
##  @param[in] flag Flag
##

proc appletTerminateApplicationAndSetReason*(reason: Result): Result {.cdecl,
    importc: "appletTerminateApplicationAndSetReason".}
## *
##  @brief TerminateApplicationAndSetReason
##  @note Only available with AppletType_OverlayApplet on [2.0.0+].
##  @param[in] reason Result reason.
##

proc appletSetScreenShotPermissionGlobally*(flag: bool): Result {.cdecl,
    importc: "appletSetScreenShotPermissionGlobally".}
## *
##  @brief Sets ScreenShotPermissionGlobally.
##  @note Only available with AppletType_OverlayApplet on [3.0.0+].
##  @param[in] flag Flag
##

proc appletStartShutdownSequenceForOverlay*(): Result {.cdecl,
    importc: "appletStartShutdownSequenceForOverlay".}
## *
##  @brief Start the system-shutdown sequence. This will enter an infinite-sleep-loop on success.
##  @note Only available with AppletType_OverlayApplet on [6.0.0+].
##

proc appletStartRebootSequenceForOverlay*(): Result {.cdecl,
    importc: "appletStartRebootSequenceForOverlay".}
## *
##  @brief Start the system-reboot sequence. This will enter an infinite-sleep-loop on success.
##  @note Only available with AppletType_OverlayApplet on [6.0.0+].
##

proc appletSetHealthWarningShowingState*(flag: bool): Result {.cdecl,
    importc: "appletSetHealthWarningShowingState".}
## *
##  @brief SetHealthWarningShowingState
##  @note Only available with AppletType_OverlayApplet on [9.0.0+].
##  @param[in] flag Flag
##

proc appletIsHealthWarningRequired*(`out`: ptr bool): Result {.cdecl,
    importc: "appletIsHealthWarningRequired".}
## *
##  @brief IsHealthWarningRequired
##  @note Only available with AppletType_OverlayApplet on [10.0.0+].
##  @param[out] out Output flag.
##

proc appletBeginToObserveHidInputForDevelop*(): Result {.cdecl,
    importc: "appletBeginToObserveHidInputForDevelop".}
## *
##  @brief Enables HID input for the OverlayApplet, without disabling input for the foreground applet. Generally \ref appletBeginToWatchShortHomeButtonMessage / appletEndToWatchShortHomeButtonMessage should be used instead.
##  @note Only available with AppletType_OverlayApplet on [5.0.0+].
##

proc appletReadThemeStorage*(buffer: pointer; size: csize_t; offset: U64;
                            transferSize: ptr U64): Result {.cdecl,
    importc: "appletReadThemeStorage".}
## /@}
## /@name IAppletCommonFunctions
## /@{
## *
##  @brief Reads the ThemeStorage for the current applet.
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [7.0.0+].
##  @note offset(+size) must be <=0x400.
##  @param[out] buffer Output buffer data.
##  @param[in] size Size to read.
##  @param[in] offset Offset within the ThemeStorage.
##  @param[out] transfer_size Actual read size.
##

proc appletWriteThemeStorage*(buffer: pointer; size: csize_t; offset: U64): Result {.
    cdecl, importc: "appletWriteThemeStorage".}
## *
##  @brief Writes the ThemeStorage for the current applet.
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [7.0.0+].
##  @note offset(+size) must be <=0x400.
##  @param[in] buffer Input buffer data.
##  @param[in] size Size to write.
##  @param[in] offset Offset within the ThemeStorage.
##

proc appletPushToAppletBoundChannel*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletPushToAppletBoundChannel".}
## *
##  @brief This is similar to \ref appletPushToAppletBoundChannelForDebug (no DebugMode check), except the used channel is loaded from elsewhere and must be in the range 31-32.
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [9.0.0+].
##  @note This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##

proc appletTryPopFromAppletBoundChannel*(s: ptr AppletStorage): Result {.cdecl,
    importc: "appletTryPopFromAppletBoundChannel".}
## *
##  @brief This is similar to \ref appletTryPopFromAppletBoundChannelForDebug (no DebugMode check), except the used channel is loaded from elsewhere and must be in the range 31-32.
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [9.0.0+].
##  @param[out] s Storage object.
##

proc appletGetDisplayLogicalResolution*(width: ptr S32; height: ptr S32): Result {.
    cdecl, importc: "appletGetDisplayLogicalResolution".}
## *
##  @brief Gets the DisplayLogicalResolution.
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [8.0.0+].
##  @param[out] width Output width.
##  @param[out] height Output height.
##

proc appletSetDisplayMagnification*(x: cfloat; y: cfloat; width: cfloat; height: cfloat): Result {.
    cdecl, importc: "appletSetDisplayMagnification".}
## *
##  @brief Sets the DisplayMagnification. This is essentially layer image crop, for everything non-Overlay.
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [8.0.0+].
##  @note x and width are multiplied with the same width value returned by \ref appletGetDisplayLogicalResolution, so these should be in the range 0.0f-1.0f. Likewise for y and height, except these are multipled with the height value.
##  @param[in] x X position.
##  @param[in] y Y position.
##  @param[in] width Width.
##  @param[in] height Height.
##

proc appletSetHomeButtonDoubleClickEnabled*(flag: bool): Result {.cdecl,
    importc: "appletSetHomeButtonDoubleClickEnabled".}
## *
##  @brief Sets whether HomeButtonDoubleClick is enabled.
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [8.0.0+].
##  @param[in] flag Flag
##

proc appletGetHomeButtonDoubleClickEnabled*(`out`: ptr bool): Result {.cdecl,
    importc: "appletGetHomeButtonDoubleClickEnabled".}
## *
##  @brief Gets whether HomeButtonDoubleClick is enabled.
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [8.0.0+].
##  @param[out] out Output flag.
##

proc appletIsHomeButtonShortPressedBlocked*(`out`: ptr bool): Result {.cdecl,
    importc: "appletIsHomeButtonShortPressedBlocked".}
## *
##  @brief IsHomeButtonShortPressedBlocked
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [10.0.0+].
##  @param[out] out Output flag.
##

proc appletIsVrModeCurtainRequired*(`out`: ptr bool): Result {.cdecl,
    importc: "appletIsVrModeCurtainRequired".}
## *
##  @brief IsVrModeCurtainRequired
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [11.0.0+].
##  @param[out] out Output flag.
##

proc appletSetCpuBoostRequestPriority*(priority: S32): Result {.cdecl,
    importc: "appletSetCpuBoostRequestPriority".}
## *
##  @brief SetCpuBoostRequestPriority
##  @note Only available with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [11.0.0+].
##  @param[in] priority Priority
##

proc appletOpenMainApplication*(a: ptr AppletApplication): Result {.cdecl,
    importc: "appletOpenMainApplication".}
## /@}
## /@name IDebugFunctions
## /@{
## *
##  @brief Open an \ref AppletApplication for the currently running Application.
##  @note Should not be used when no Application is running.
##  @note Only available on [1.0.0-9.2.0].
##  @param[out] a \ref AppletApplication
##

proc appletPerformSystemButtonPressing*(`type`: AppletSystemButtonType): Result {.
    cdecl, importc: "appletPerformSystemButtonPressing".}
## *
##  @brief Perform SystemButtonPressing with the specified \ref AppletSystemButtonType.
##  @param[in] type \ref AppletSystemButtonType
##

proc appletInvalidateTransitionLayer*(): Result {.cdecl,
    importc: "appletInvalidateTransitionLayer".}
## *
##  @brief InvalidateTransitionLayer.
##

proc appletRequestLaunchApplicationWithUserAndArgumentForDebug*(
    applicationId: U64; uids: ptr AccountUid; totalUids: S32; flag: bool;
    buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "appletRequestLaunchApplicationWithUserAndArgumentForDebug".}
## *
##  @brief Requests to launch the specified Application, with the specified users.
##  @note Only available on [6.0.0+].
##  @param[in] application_id ApplicationId.
##  @param[in] uids Input array of \ref AccountUid.
##  @param[in] total_uids Total input uids, must be <=ACC_USER_LIST_SIZE.
##  @param[in] flag Whether to use the specified buffer to create a storage which will be pushed for ::AppletLaunchParameterKind_UserChannel.
##  @param[in] buffer Buffer containing the above storage data.
##  @param[in] size Size of the storage buffer.
##

proc appletGetAppletResourceUsageInfo*(info: ptr AppletResourceUsageInfo): Result {.
    cdecl, importc: "appletGetAppletResourceUsageInfo".}
## *
##  @brief Gets the \ref AppletResourceUsageInfo.
##  @note Only available on [6.0.0+].
##  @param[out] info \ref AppletResourceUsageInfo
##

proc appletPushToAppletBoundChannelForDebug*(s: ptr AppletStorage; channel: S32): Result {.
    cdecl, importc: "appletPushToAppletBoundChannelForDebug".}
## *
##  @brief The channel must match the value already stored in state when the state value is non-zero, otherwise an error is returned. When the state value is 0, the channel is written into state. Then the input storage is pushed to the StorageChannel.
##  @note Only available on [9.0.0+]. DebugMode must be enabled.
##  @note This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##  @param[in] channel Channel.
##

proc appletTryPopFromAppletBoundChannelForDebug*(s: ptr AppletStorage; channel: S32): Result {.
    cdecl, importc: "appletTryPopFromAppletBoundChannelForDebug".}
## *
##  @brief The channel must not be 0 and must match the value previously saved by \ref appletPushToAppletBoundChannelForDebug, otherwise errors are returned. Then the output storage is popped from the StorageChannel.
##  @note Only available on [9.0.0+]. DebugMode must be enabled.
##  @param[out] s Storage object.
##  @param[in] channel Channel.
##

proc appletAlarmSettingNotificationEnableAppEventReserve*(s: ptr AppletStorage;
    applicationId: U64): Result {.cdecl, importc: "appletAlarmSettingNotificationEnableAppEventReserve".}
## *
##  @brief Clears a StorageChannel, pushes the input storage there, and writes the ApplicationId into state.
##  @note Only available on [9.0.0+].
##  @note This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##  @param[in] application_id ApplicationId
##

proc appletAlarmSettingNotificationDisableAppEventReserve*(): Result {.cdecl,
    importc: "appletAlarmSettingNotificationDisableAppEventReserve".}
## *
##  @brief Clears the StorageChannel/saved-ApplicationId used by \ref appletAlarmSettingNotificationEnableAppEventReserve.
##  @note Only available on [9.0.0+].
##

proc appletAlarmSettingNotificationPushAppEventNotify*(buffer: pointer; size: U64): Result {.
    cdecl, importc: "appletAlarmSettingNotificationPushAppEventNotify".}
## *
##  @brief Same as \ref appletApplicationPushToNotificationStorageChannel except this uses the MainApplication.
##  @note Only available on [9.0.0+].
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size.
##

proc appletFriendInvitationSetApplicationParameter*(s: ptr AppletStorage;
    applicationId: U64): Result {.cdecl, importc: "appletFriendInvitationSetApplicationParameter".}
## *
##  @brief Clears a StorageChannel, pushes the input storage there, and writes the ApplicationId into state.
##  @note Only available on [9.0.0+].
##  @note This uses \ref appletStorageClose automatically.
##  @param[in] s Storage object.
##  @param[in] application_id ApplicationId
##

proc appletFriendInvitationClearApplicationParameter*(): Result {.cdecl,
    importc: "appletFriendInvitationClearApplicationParameter".}
## *
##  @brief Clears the StorageChannel/saved-ApplicationId used by \ref appletFriendInvitationSetApplicationParameter.
##  @note Only available on [9.0.0+].
##

proc appletFriendInvitationPushApplicationParameter*(uid: AccountUid;
    buffer: pointer; size: U64): Result {.cdecl, importc: "appletFriendInvitationPushApplicationParameter".}
## *
##  @brief Same as \ref appletApplicationPushToFriendInvitationStorageChannel except this uses the MainApplication.
##  @note Only available on [9.0.0+].
##  @param[in] uid \ref AccountUid
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size.
##

proc appletSetTerminateResult*(res: Result): Result {.cdecl,
    importc: "appletSetTerminateResult".}
## /@}
## /@name Common cmds
## /@{
## *
##  @brief SetTerminateResult
##  @note Only available with AppletType_*Application. Or with AppletType_SystemApplet, AppletType_LibraryApplet, or AppletType_OverlayApplet, on [9.0.0+].
##  @param[in] res Result
##

proc appletGetLaunchStorageInfoForDebug*(appStorageId: ptr NcmStorageId;
                                        updateStorageId: ptr NcmStorageId): Result {.
    cdecl, importc: "appletGetLaunchStorageInfoForDebug".}
## *
##  @brief Gets the LaunchStorageInfo.
##  @note Only available with AppletType_*Application on [2.0.0+], or with AppletType_LibraryApplet on [9.0.0+].
##  @param[out] app_storageId Same as AppletApplicationLaunchProperty::app_storageId.
##  @param[out] update_storageId Same as AppletApplicationLaunchProperty::update_storageId.
##

proc appletGetGpuErrorDetectedSystemEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "appletGetGpuErrorDetectedSystemEvent".}
## *
##  @brief Gets an Event which is signaled for GpuErrorDetected.
##  @note Only available with AppletType_*Application on [8.0.0+], or with AppletType_LibraryApplet on [9.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @note Official sw waits on this Event from a seperate thread, triggering an abort when it's signaled.
##  @param[out] out_event Output Event with autoclear=false.
##

proc appletSetHandlingHomeButtonShortPressedEnabled*(flag: bool): Result {.cdecl,
    importc: "appletSetHandlingHomeButtonShortPressedEnabled".}
## *
##  @brief Sets HandlingHomeButtonShortPressedEnabled.
##  @note Only available with AppletType_OverlayApplet on [8.0.0+]. Or with non-AppletType_OverlayApplet on [9.1.0+].
##  @param[in] flag Flag
##

proc appletGetAppletInfo*(): ptr AppletInfo {.cdecl, importc: "appletGetAppletInfo".}
## /@}
## /@name State / other
## /@{
## *
##  @brief Gets the cached \ref AppletInfo loaded during \ref appletInitialize. This will return NULL when the info is not initialized, due to not running as AppletType_LibraryApplet, or when any of the used cmds fail.
##  @note Only available with AppletType_LibraryApplet.
##

proc appletGetMessage*(msg: ptr U32): Result {.cdecl, importc: "appletGetMessage".}
## *
##  @brief Gets a notification message, see \ref AppletMessage.
##

proc appletProcessMessage*(msg: U32): bool {.cdecl, importc: "appletProcessMessage".}
## *
##  @brief Processes the current applet status using the specified msg.
##  @param msg Notification message, normally from \ref appletGetMessage.
##  @return Whether the application should continue running.
##

proc appletMainLoop*(): bool {.cdecl, importc: "appletMainLoop".}
## *
##  @brief Processes the current applet status. Generally used within a main loop.
##  @note Uses \ref appletGetMessage and \ref appletProcessMessage internally.
##  @return Whether the application should continue running.
##

proc appletHook*(cookie: ptr AppletHookCookie; callback: AppletHookFn; param: pointer) {.
    cdecl, importc: "appletHook".}
## *
##  @brief Sets up an applet status hook.
##  @param cookie Hook cookie to use.
##  @param callback Function to call when applet's status changes.
##  @param param User-defined parameter to pass to the callback.
##

proc appletUnhook*(cookie: ptr AppletHookCookie) {.cdecl, importc: "appletUnhook".}
## *
##  @brief Removes an applet status hook.
##  @param cookie Hook cookie to remove.
##

proc appletGetOperationMode*(): AppletOperationMode {.cdecl,
    importc: "appletGetOperationMode".}
## / These return state which is updated by appletMainLoop() when notifications are received.

proc appletGetPerformanceMode*(): ApmPerformanceMode {.cdecl,
    importc: "appletGetPerformanceMode".}
## appletgetperformanceMode

proc appletGetFocusState*(): AppletFocusState {.cdecl,
    importc: "appletGetFocusState".}
## appletGetFocusState

proc appletSetFocusHandlingMode*(mode: AppletFocusHandlingMode): Result {.cdecl,
    importc: "appletSetFocusHandlingMode".}
## *
##  @brief Sets the current \ref AppletFocusHandlingMode.
##  @note Should only be called with AppletType_Application.
##

