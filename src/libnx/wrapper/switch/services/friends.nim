## *
##  @file friend.h
##  @brief Friends (friend:*) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../services/applet, ../services/acc, ../sf/service

type
  FriendsServiceType* = enum
    FriendsServiceTypeUser = 0, ## /< Initializes friend:u
    FriendsServiceTypeViewer = 1, ## /< Initializes friend:v
    FriendsServiceTypeManager = 2, ## /< Initializes friend:m
    FriendsServiceTypeSystem = 3, ## /< Initializes friend:s
    FriendsServiceTypeAdministrator = 4 ## /< Initializes friend:a


## / InAppScreenName

type
  FriendsInAppScreenName* {.bycopy.} = object
    name*: array[0x40, char]    ## /< UTF-8 string, NUL-terminated.
    languageCode*: U64         ## /< LanguageCode, see set.h.


## / FriendInvitationGameModeDescription

type
  FriendsFriendInvitationGameModeDescription* {.bycopy.} = object
    unkX0*: array[0xc00, U8]    ## /< Unknown.


## / FriendInvitationId

type
  FriendsFriendInvitationId* {.bycopy.} = object
    id*: U64                   ## /< Id.


## / FriendInvitationGroupId

type
  FriendsFriendInvitationGroupId* {.bycopy.} = object
    id*: U64                   ## /< Id.


## / FriendsUserSetting

type
  FriendsUserSetting* {.bycopy.} = object
    uid*: AccountUid           ## /< User ID
    presencePermission*: U32   ## /< Presence permission
    playLogPermission*: U32    ## /< Play log permission
    friendRequestReception*: U64 ## /< Unknown
    friendCode*: array[0x20, char] ## /< Friend Code
    friendCodeNextIssuableTime*: U64 ## /< Unknown
    unkX48*: array[0x7C8, U8]   ## /< Unknown


## / Initialize friends

proc friendsInitialize*(serviceType: FriendsServiceType): Result {.cdecl,
    importc: "friendsInitialize".}
## / Exit friends

proc friendsExit*() {.cdecl, importc: "friendsExit".}
## / Gets the Service object for the friends service session.

proc friendsGetServiceSession*(): ptr Service {.cdecl,
    importc: "friendsGetServiceSession".}
## / Gets the Service object for the actual IFriendsService service session.

proc friendsGetServiceSessionIFriendsService*(): ptr Service {.cdecl,
    importc: "friendsGetServiceSession_IFriendsService".}
## *
##  @brief Gets the \ref FriendsUserSetting details
##  @param[in] uid \ref User AccountUid.
##  @param[out] user_setting \ref FriendsUserSetting
##

proc friendsGetUserSetting*(uid: AccountUid; userSetting: ptr FriendsUserSetting): Result {.
    cdecl, importc: "friendsGetUserSetting".}
## *
##  @brief Gets an Event which is signaled when data is available with \ref friendsTryPopFriendInvitationNotificationInfo.
##  @note This is a wrapper for \ref appletGetFriendInvitationStorageChannelEvent, see that for the usage requirements.
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=false.
##

proc friendsGetFriendInvitationNotificationEvent*(outEvent: ptr Event): Result {.
    inline, cdecl.} =
  return appletGetFriendInvitationStorageChannelEvent(outEvent)

## *
##  @brief Uses \ref appletTryPopFromFriendInvitationStorageChannel then reads the data from there into the output params.
##  @note This is a wrapper for \ref appletTryPopFromFriendInvitationStorageChannel, see that for the usage requirements.
##  @param[out] uid \ref AccountUid. Optional, can be NULL.
##  @param[out] buffer Output buffer.
##  @param[out] size Output buffer size.
##  @param[out] out_size Size of the data which was written into the output buffer. Optional, can be NULL.
##

proc friendsTryPopFriendInvitationNotificationInfo*(uid: ptr AccountUid;
    buffer: pointer; size: U64; outSize: ptr U64): Result {.cdecl,
    importc: "friendsTryPopFriendInvitationNotificationInfo".}