## *
##  @file acc.h
##  @brief Account (acc:*) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

const
  ACC_USER_LIST_SIZE* = 8

type
  AccountServiceType* = enum
    AccountServiceTypeApplication = 0, ## /< Initializes acc:u0.
    AccountServiceTypeSystem = 1, ## /< Initializes acc:u1.
    AccountServiceTypeAdministrator = 2 ## /< Initializes acc:su.


## / Profile

type
  AccountProfile* {.bycopy.} = object
    s*: Service                ## /< IProfile


## / Account UserId.

type
  AccountUid* {.bycopy.} = object
    uid*: array[2, U64]         ## /< UserId. All-zero is invalid / Uid not set. See also \ref accountUidIsValid.


## / UserData

type
  AccountUserData* {.bycopy.} = object
    unkX0*: U32                ## /< Unknown.
    iconID*: U32               ## /< Icon ID. 0 = Mii, the rest are character icon IDs.
    iconBackgroundColorID*: U8 ## /< Profile icon background color ID
    unkX9*: array[0x7, U8]      ## /< Unknown.
    miiID*: array[0x10, U8]     ## /< Some ID related to the Mii? All zeros when a character icon is used.
    unkX20*: array[0x60, U8]    ## /< Usually zeros?


## / ProfileBase

type
  AccountProfileBase* {.bycopy.} = object
    uid*: AccountUid           ## /< \ref AccountUid
    lastEditTimestamp*: U64    ## /< POSIX UTC timestamp, for the last account edit.
    nickname*: array[0x20, char] ## /< UTF-8 Nickname.


## / NetworkServiceAccountId

type
  AccountNetworkServiceAccountId* {.bycopy.} = object
    id*: U64                   ## /< Id.


## / Initialize account.

proc accountInitialize*(serviceType: AccountServiceType): Result {.cdecl,
    importc: "accountInitialize".}
## / Exit account.

proc accountExit*() {.cdecl, importc: "accountExit".}
## / Gets the Service object for the actual account service session.

proc accountGetServiceSession*(): ptr Service {.cdecl,
    importc: "accountGetServiceSession".}
## / Get the total number of user profiles.

proc accountGetUserCount*(userCount: ptr S32): Result {.cdecl,
    importc: "accountGetUserCount".}
## *
##  @brief Get a list of all userIds. The returned list will never be larger than ACC_USER_LIST_SIZE.
##  @param uids Pointer to array of userIds.
##  @param max_uids Maximum number of userIds to return.
##  @param actual_total The actual total number of userIds found.
##

proc accountListAllUsers*(uids: ptr AccountUid; maxUids: S32; actualTotal: ptr S32): Result {.
    cdecl, importc: "accountListAllUsers".}
## / Get the userId for the last opened user.

proc accountGetLastOpenedUser*(uid: ptr AccountUid): Result {.cdecl,
    importc: "accountGetLastOpenedUser".}
## / Get an AccountProfile for the specified userId.

proc accountGetProfile*(`out`: ptr AccountProfile; uid: AccountUid): Result {.cdecl,
    importc: "accountGetProfile".}
## / IsUserRegistrationRequestPermitted

proc accountIsUserRegistrationRequestPermitted*(`out`: ptr bool): Result {.cdecl,
    importc: "accountIsUserRegistrationRequestPermitted".}
## / TrySelectUserWithoutInteraction

proc accountTrySelectUserWithoutInteraction*(uid: ptr AccountUid;
    isNetworkServiceAccountRequired: bool): Result {.cdecl,
    importc: "accountTrySelectUserWithoutInteraction".}
## / Close the AccountProfile.

proc accountProfileClose*(profile: ptr AccountProfile) {.cdecl,
    importc: "accountProfileClose".}
## / Get \ref AccountUserData and \ref AccountProfileBase for the specified profile, userdata is optional (can be NULL).

proc accountProfileGet*(profile: ptr AccountProfile; userdata: ptr AccountUserData;
                       profilebase: ptr AccountProfileBase): Result {.cdecl,
    importc: "accountProfileGet".}
## / Get the icon image size.

proc accountProfileGetImageSize*(profile: ptr AccountProfile; imageSize: ptr U32): Result {.
    cdecl, importc: "accountProfileGetImageSize".}
## / Load the JPEG profile icon, valid for both Miis and character icons. The output image_size is the same as the one from \ref accountProfileGetImageSize.

proc accountProfileLoadImage*(profile: ptr AccountProfile; buf: pointer; len: csize_t;
                             imageSize: ptr U32): Result {.cdecl,
    importc: "accountProfileLoadImage".}
## / Gets the userId which was selected by the profile-selector applet (if any), prior to launching the currently running Application.
## / This gets the cached PreselectedUser loaded during accountInitialize, when PreselectedUser is available.

proc accountGetPreselectedUser*(uid: ptr AccountUid): Result {.cdecl,
    importc: "accountGetPreselectedUser".}
## *
##  @brief Checks whether the specified \ref AccountUid is valid/set (non-zero).
##  @param[in] Uid \ref AccountUid
##

proc accountUidIsValid*(uid: ptr AccountUid): bool {.inline, cdecl,
    importc: "accountUidIsValid".} =
  return uid.uid[0] != 0 or uid.uid[1] != 0
