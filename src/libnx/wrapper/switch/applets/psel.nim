## *
##  @file psel.h
##  @brief Wrapper for using the playerSelect (user selection) LibraryApplet.
##  @author XorTroll, yellows8
##  @copyright libnx Authors
##

import
  ../types, ../services/acc

## / playerSelect UI modes.

type
  PselUiMode* = enum
    PselUiModeUserSelector = 0, ## /< UserSelector
    PselUiModeUserCreator = 1,  ## /< UserCreator
    PselUiModeEnsureNetworkServiceAccountAvailable = 2, ## /< EnsureNetworkServiceAccountAvailable
    PselUiModeUserIconEditor = 3, ## /< UserIconEditor
    PselUiModeUserNicknameEditor = 4, ## /< UserNicknameEditor
    PselUiModeUserCreatorForStarter = 5, ## /< UserCreatorForStarter
    PselUiModeNintendoAccountAuthorizationRequestContext = 6, ## /< NintendoAccountAuthorizationRequestContext
    PselUiModeIntroduceExternalNetworkServiceAccount = 7, ## /< IntroduceExternalNetworkServiceAccount
    PselUiModeIntroduceExternalNetworkServiceAccountForRegistration = 8, ## /< [6.0.0+] IntroduceExternalNetworkServiceAccountForRegistration
    PselUiModeNintendoAccountNnidLinker = 9, ## /< [6.0.0+] NintendoAccountNnidLinker
    PselUiModeLicenseRequirementsForNetworkService = 10, ## /< [6.0.0+] LicenseRequirementsForNetworkService
    PselUiModeLicenseRequirementsForNetworkServiceWithUserContextImpl = 11, ## /< [7.0.0+] LicenseRequirementsForNetworkServiceWithUserContextImpl
    PselUiModeUserCreatorForImmediateNaLoginTest = 12, ## /< [7.0.0+] UserCreatorForImmediateNaLoginTest
    PselUiModeUserQualificationPromoter = 13 ## /< [13.0.0+] UserQualificationPromoter


## / UI message text to display with ::PselUiMode_UserSelector. Invalid values are handled as ::PselUserSelectionPurpose_General.

type
  PselUserSelectionPurpose* = enum
    PselUserSelectionPurposeGeneral = 0, ## /< "Select a user."
    PselUserSelectionPurposeGameCardRegistration = 1, ## /< [2.0.0+] "Who will receive the points?"
    PselUserSelectionPurposeEShopLaunch = 2, ## /< [2.0.0+] "Who is using Nintendo eShop?"
    PselUserSelectionPurposeEShopItemShow = 3, ## /< [2.0.0+] "Who is making this purchase?"
    PselUserSelectionPurposePicturePost = 4, ## /< [2.0.0+] "Who is posting?"
    PselUserSelectionPurposeNintendoAccountLinkage = 5, ## /< [2.0.0+] "Select a user to link to a Nintendo Account."
    PselUserSelectionPurposeSettingsUpdate = 6, ## /< [2.0.0+] "Change settings for which user?"
    PselUserSelectionPurposeSaveDataDeletion = 7, ## /< [2.0.0+] "Format data for which user?"
    PselUserSelectionPurposeUserMigration = 8, ## /< [4.0.0+] "Which user will be transferred to another console?"
    PselUserSelectionPurposeSaveDataTransfer = 9 ## /< [8.0.0+] "Send save data for which user?"


## / NintendoAccountStartupDialogType

type
  PselNintendoAccountStartupDialogType* = enum
    PselNintendoAccountStartupDialogTypeLoginAndCreate = 0, ## /< LoginAndCreate
    PselNintendoAccountStartupDialogTypeLogin = 1, ## /< Login
    PselNintendoAccountStartupDialogTypeCreate = 2 ## /< Create


## / Base UI settings for playerSelect.

type
  PselUiSettingsV1* {.bycopy.} = object
    mode*: U32                 ## /< \ref PselUiMode
    pad*: U32                  ## /< Padding.
    invalidUidList*: array[Acc_User_List_Size, AccountUid] ## /< List of \ref AccountUid. TODO: This is only correct for ::PselUiMode_UserSelector, for other modes this is a single uid, followed by mode-specific data (if any).
    applicationId*: U64        ## /< ApplicationId with \ref pselShowUserSelectorForLauncher.
    isNetworkServiceAccountRequired*: U8 ## /< PselUserSelectionSettings::is_network_service_account_required.
    isSkipEnabled*: U8         ## /< PselUserSelectionSettings::is_skip_enabled
    unkX92*: U8                ## /< Set to value 1 by \ref pselShowUserSelectorForSystem / \ref pselShowUserSelectorForLauncher.
    isPermitted*: U8           ## /< isPermitted. With ::PselUiMode_UserSelector: enables the option to create a new user. Set to the output from \ref accountIsUserRegistrationRequestPermitted with pselShowUserSelector*. When not set, a dialog will be displayed when the user attempts to create an user.
    showSkipButton*: U8        ## /< PselUserSelectionSettings::show_skip_button
    additionalSelect*: U8      ## /< PselUserSelectionSettings::additional_select
    unkX96*: U8                ## /< [2.0.0+] Set to PselUserSelectionSettingsForSystemService::enable_user_creation_button. \ref pselShowUserSelectorForLauncher / \ref pselShowUserSelector sets this to value 1.
    unkX97*: U8                ## /< [6.0.0+] Set to PselUserSelectionSettings::is_unqualified_user_selectable ^ 1.


## / UI settings for versions starting with 0x10000.

type
  PselUiSettings* {.bycopy.} = object
    settings*: PselUiSettingsV1 ## /< \ref PselUiSettingsV1
    unkX98*: U32               ## /< [2.0.0+] Set to PselUserSelectionSettingsForSystemService::purpose.
    unkX9c*: array[0x4, U8]     ## /< Unknown.


## / UserSelectionSettings

type
  PselUserSelectionSettings* {.bycopy.} = object
    invalidUidList*: array[Acc_User_List_Size, AccountUid] ## /< invalidUidList.
    isSkipEnabled*: U8         ## /< isSkipEnabled. When set, the first user in invalid_uid_list must not be set, and additional_select must be 0. When enabled \ref accountTrySelectUserWithoutInteraction will be used to select the user, in this case the applet will only be launched if \ref accountTrySelectUserWithoutInteraction doesn't return an user.
    isNetworkServiceAccountRequired*: U8 ## /< isNetworkServiceAccountRequired. Whether the user needs to be linked to a Nintendo account.
    showSkipButton*: U8        ## /< showSkipButton. Enables the option to skip user selection with a button.
    additionalSelect*: U8      ## /< additionalSelect.
    isUnqualifiedUserSelectable*: U8 ## /< [6.0.0+] isUnqualifiedUserSelectable


## / [2.0.0+] UserSelectionSettingsForSystemService

type
  PselUserSelectionSettingsForSystemService* {.bycopy.} = object
    purpose*: U32              ## /< \ref PselUserSelectionPurpose
    enableUserCreationButton*: U8 ## /< Enables the user-creation button when set. Whether user-creation when pressing the button is actually allowed is controlled by PselUiSettingsV1::is_permitted.
    pad*: array[0x3, U8]        ## /< Padding.


## / Return data sent after execution.

type
  PselUiReturnArg* {.bycopy.} = object
    res*: Result               ## /< Result.
    userId*: AccountUid        ## /< Selected \ref AccountUid.

proc pselUiCreate*(ui: ptr PselUiSettings; mode: PselUiMode): Result {.cdecl,
    importc: "pselUiCreate".}
## *
##  @brief Creates a new UI config for the playerSelect applet with the specified mode.
##  @param ui PseluiSettings struct.
##  @param mode playerSelect UI mode.
##

proc pselUiAddUser*(ui: ptr PselUiSettings; userId: AccountUid) {.cdecl,
    importc: "pselUiAddUser".}
## *
##  @brief Adds an user to the user list of the applet.
##  @param ui PselUiSettings struct.
##  @param[in] user_id user ID.
##  @note The users will be treated as invalid users for user selection mode, and as the input user for other modes.
##

proc pselUiSetAllowUserCreation*(ui: ptr PselUiSettings; flag: bool) {.inline, cdecl.} =
  ## *
  ##  @brief Sets whether users can be created in the applet.
  ##  @param ui PselUiSettings struct.
  ##  @param flag Flag value.
  ##  @note Only used for ::PselUiMode_SelectUser.
  ##

  if ui.settings.mode == PselUiModeUserSelector.U32:
    ui.settings.isPermitted = flag.U8

proc pselUiSetNetworkServiceRequired*(ui: ptr PselUiSettings; flag: bool) {.inline,
    cdecl.} =
  ## *
  ##  @brief Sets whether users need to be linked to a Nintendo account.
  ##  @param ui PselUiSettings struct.
  ##  @param flag Flag value.
  ##

  ui.settings.isNetworkServiceAccountRequired = flag.U8

proc pselUiSetSkipButtonEnabled*(ui: ptr PselUiSettings; flag: bool) {.inline, cdecl.} =
  ## *
  ##  @brief Sets whether selection can be skipped with a button.
  ##  @param ui PselUiSettings struct.
  ##  @param flag Flag value.
  ##

  ui.settings.showSkipButton = flag.U8

proc pselUiShow*(ui: ptr PselUiSettings; outUser: ptr AccountUid): Result {.cdecl,
    importc: "pselUiShow".}
## *
##  @brief Shows the applet with the specified UI settings.
##  @param ui PselUiSettings struct.
##  @param out_user Selected user ID.
##  @note If user skips (see \ref pselUiSetSkipEnabled) this will return successfully but the output ID will be 0.
##

proc pselShowUserSelectorForSystem*(outUser: ptr AccountUid;
                                   settings: ptr PselUserSelectionSettings;
    settingsSystem: ptr PselUserSelectionSettingsForSystemService): Result {.cdecl,
    importc: "pselShowUserSelectorForSystem".}
## *
##  @brief This is the System version of \ref pselShowUserSelector.
##  @note This uses \ref accountIsUserRegistrationRequestPermitted, hence \ref accountInitialize must be used prior to this. See also the docs for PselUserSelectionSettings::is_skip_enabled.
##  @param[out] out_user Returned selected user ID.
##  @param[in] settings \ref PselUserSelectionSettings
##  @param[in] settings_system [2.0.0+] \ref PselUserSelectionSettingsForSystemService, ignored on prior versions.
##

proc pselShowUserSelectorForLauncher*(outUser: ptr AccountUid;
                                     settings: ptr PselUserSelectionSettings;
                                     applicationId: U64): Result {.cdecl,
    importc: "pselShowUserSelectorForLauncher".}
## *
##  @brief This is the Launcher version of \ref pselShowUserSelector.
##  @note This uses \ref accountIsUserRegistrationRequestPermitted, hence \ref accountInitialize must be used prior to this. See also the docs for PselUserSelectionSettings::is_skip_enabled.
##  @param[out] out_user Returned selected user ID.
##  @param[in] settings \ref PselUserSelectionSettings
##  @param[in] application_id ApplicationId
##

proc pselShowUserSelector*(outUser: ptr AccountUid;
                          settings: ptr PselUserSelectionSettings): Result {.cdecl,
    importc: "pselShowUserSelector".}
## *
##  @brief Shows the applet to select a user.
##  @note This uses \ref accountIsUserRegistrationRequestPermitted, hence \ref accountInitialize must be used prior to this. See also the docs for PselUserSelectionSettings::is_skip_enabled.
##  @param[out] out_user Returned selected user ID.
##  @param[in] settings \ref PselUserSelectionSettings
##

proc pselShowUserCreator*(): Result {.cdecl, importc: "pselShowUserCreator".}
## *
##  @brief Shows the applet to create a user.
##  @note This uses \ref accountIsUserRegistrationRequestPermitted, hence \ref accountInitialize must be used prior to this. If the output flag is 0, an error will be thrown.
##

proc pselShowUserIconEditor*(user: AccountUid): Result {.cdecl,
    importc: "pselShowUserIconEditor".}
## *
##  @brief Shows the applet to change a user's icon.
##  @param[in] user Input user ID.
##

proc pselShowUserNicknameEditor*(user: AccountUid): Result {.cdecl,
    importc: "pselShowUserNicknameEditor".}
## *
##  @brief Shows the applet to change a user's nickname.
##  @param[in] user Input user ID.
##

proc pselShowUserCreatorForStarter*(): Result {.cdecl,
    importc: "pselShowUserCreatorForStarter".}
## *
##  @brief Shows the applet to create a user. Used by the starter applet during system setup.
##

proc pselShowNintendoAccountNnidLinker*(user: AccountUid): Result {.cdecl,
    importc: "pselShowNintendoAccountNnidLinker".}
## *
##  @brief Shows the applet for Nintendo Account Nnid linking.
##  @note Only available on [6.0.0+].
##  @param[in] user Input user ID.
##

proc pselShowUserQualificationPromoter*(user: AccountUid): Result {.cdecl,
    importc: "pselShowUserQualificationPromoter".}
## *
##  @brief Shows the applet for UserQualificationPromoter.
##  @note Only available on [13.0.0+].
##  @param[in] user Input user ID.
##

