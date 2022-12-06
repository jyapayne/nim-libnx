## *
##  @file friends_la.h
##  @brief Wrapper for using the MyPage (friends) LibraryApplet.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../services/acc, ../services/friends

## / Arg type values used with \ref FriendsLaArg.

type
  FriendsLaArgType* = enum
    FriendsLaArgType_ShowFriendList = 0, ## /< ShowFriendList. Launches the applet with the "Friend List" menu initially selected.
    FriendsLaArgType_ShowUserDetailInfo = 1, ## /< ShowUserDetailInfo
    FriendsLaArgType_StartSendingFriendRequest = 2, ## /< StartSendingFriendRequest
    FriendsLaArgType_ShowMethodsOfSendingFriendRequest = 3, ## /< ShowMethodsOfSendingFriendRequest. Launches the applet with the "Add Friend" menu initially selected.
    FriendsLaArgType_StartFacedFriendRequest = 4, ## /< StartFacedFriendRequest. Launches the applet where the "Search for Local Users" menu is initially shown. Returning from this menu will exit the applet.
    FriendsLaArgType_ShowReceivedFriendRequestList = 5, ## /< ShowReceivedFriendRequestList. Launches the applet where the "Received Friend Requests" menu is initially shown. Returning from this menu will exit the applet.
    FriendsLaArgType_ShowBlockedUserList = 6, ## /< ShowBlockedUserList. Launches the applet where the "Blocked-User List" menu is initially shown. Returning from this menu will exit the applet.
    FriendsLaArgType_ShowMyProfile = 7, ## /< ShowMyProfile. Launches the applet with the "Profile" menu initially selected. ShowMyProfileForHomeMenu is identical to this except for playStartupSound=true.
    FriendsLaArgType_StartFriendInvitation = 8, ## /< [9.0.0+] StartFriendInvitation. Launches the applet for sending online-play invites to friends, where the friends are selected via the UI.
    FriendsLaArgType_StartSendingFriendInvitation = 9, ## /< [9.0.0+] StartSendingFriendInvitation.
    FriendsLaArgType_ShowReceivedInvitationDetail = 10 ## /< [9.0.0+] ShowReceivedInvitationDetail.


## / Header for the arg struct.

type
  FriendsLaArgHeader* {.bycopy.} = object
    `type`*: U32               ## /< \ref FriendsLaArgType
    pad*: U32                  ## /< Padding.
    uid*: AccountUid           ## /< \ref AccountUid


## / Common data for the arg struct, for the pre-9.0.0 types.
## / This is only set for
## ::FriendsLaArgType_ShowUserDetailInfo/::FriendsLaArgType_StartSendingFriendRequest, for everything else this is cleared.

type
  FriendsLaArgCommonData* {.bycopy.} = object
    id*: AccountNetworkServiceAccountId ## /< \ref AccountNetworkServiceAccountId for the other account.
    first_inAppScreenName*: FriendsInAppScreenName ## /< First InAppScreenName.
    second_inAppScreenName*: FriendsInAppScreenName ## /< Second InAppScreenName.


## / Arg struct pushed for the applet input storage, for pre-9.0.0.

type
  FriendsLaArgV1* {.bycopy.} = object
    hdr*: FriendsLaArgHeader   ## /< \ref FriendsLaArgHeader
    data*: FriendsLaArgCommonData ## /< \ref FriendsLaArgCommonData


## / Arg struct pushed for the applet input storage, for [9.0.0+].

type
  INNER_C_STRUCT_friends_la_79* {.bycopy.} = object
    id_count*: S32             ## /< \ref AccountNetworkServiceAccountId count, must be 1-15.
    pad*: U32                  ## /< Padding.
    userdata_size*: U64        ## /< User-data size, must be <=0x400.
    userdata*: array[0x400, U8] ## /< Arbitrary user-data, see above size.
    desc*: FriendsFriendInvitationGameModeDescription ## /< \ref FriendsFriendInvitationGameModeDescription

  INNER_C_STRUCT_friends_la_80* {.bycopy.} = object
    id_count*: S32             ## /< \ref AccountNetworkServiceAccountId count, must be 1-15.
    pad*: U32                  ## /< Padding.
    id_list*: array[16, AccountNetworkServiceAccountId] ## /< \ref AccountNetworkServiceAccountId list, see above count.
    userdata_size*: U64        ## /< User-data size, must be <=0x400.
    userdata*: array[0x400, U8] ## /< Arbitrary user-data, see above size.
    desc*: FriendsFriendInvitationGameModeDescription ## /< \ref FriendsFriendInvitationGameModeDescription

  INNER_C_STRUCT_friends_la_81* {.bycopy.} = object
    invitation_id*: FriendsFriendInvitationId ## /< \ref FriendsFriendInvitationId
    invitation_group_id*: FriendsFriendInvitationGroupId ## /< \ref FriendsFriendInvitationGroupId

  INNER_C_UNION_friends_la_79* {.bycopy, union.} = object
    raw*: array[0x1090, U8]     ## /< Raw data.
    common*: FriendsLaArgCommonData ## /< \ref FriendsLaArgCommonData
    start_friend_invitation*: INNER_C_STRUCT_friends_la_79 ## /< Data for ::FriendsLaArgType_StartFriendInvitation.
    start_sending_friend_invitation*: INNER_C_STRUCT_friends_la_80 ## /< Data for ::FriendsLaArgType_StartSendingFriendInvitation.
    show_received_invitation_detail*: INNER_C_STRUCT_friends_la_81 ## /< Data for ::FriendsLaArgType_ShowReceivedInvitationDetail.

  FriendsLaArg* {.bycopy.} = object
    hdr*: FriendsLaArgHeader   ## /< \ref FriendsLaArgHeader
    data*: INNER_C_UNION_friends_la_79 ## /< Data for each \ref FriendsLaArgType.

proc friendsLaShowFriendList*(uid: AccountUid): Result {.cdecl,
    importc: "friendsLaShowFriendList".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_ShowFriendList, the specified input, and playStartupSound=false.
##  @param[in] uid \ref AccountUid
##

proc friendsLaShowUserDetailInfo*(uid: AccountUid;
                                 id: AccountNetworkServiceAccountId;
    first_inAppScreenName: ptr FriendsInAppScreenName; second_inAppScreenName: ptr FriendsInAppScreenName): Result {.
    cdecl, importc: "friendsLaShowUserDetailInfo".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_ShowUserDetailInfo, the specified input, and playStartupSound=false.
##  @param[in] uid \ref AccountUid
##  @param[in] id \ref AccountNetworkServiceAccountId for the user to show UserDetailInfo for.
##  @param[in] first_inAppScreenName First \ref FriendsInAppScreenName.
##  @param[in] second_inAppScreenName Second \ref FriendsInAppScreenName.
##

proc friendsLaStartSendingFriendRequest*(uid: AccountUid;
                                        id: AccountNetworkServiceAccountId;
    first_inAppScreenName: ptr FriendsInAppScreenName; second_inAppScreenName: ptr FriendsInAppScreenName): Result {.
    cdecl, importc: "friendsLaStartSendingFriendRequest".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_StartSendingFriendRequest, the specified input, and playStartupSound=false. On success, this will load the output Result from the output storage.
##  @param[in] uid \ref AccountUid
##  @param[in] id \ref AccountNetworkServiceAccountId to send the friend request to.
##  @param[in] first_inAppScreenName First \ref FriendsInAppScreenName.
##  @param[in] second_inAppScreenName Second \ref FriendsInAppScreenName.
##

proc friendsLaShowMethodsOfSendingFriendRequest*(uid: AccountUid): Result {.cdecl,
    importc: "friendsLaShowMethodsOfSendingFriendRequest".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_ShowMethodsOfSendingFriendRequest, the specified input, and playStartupSound=false.
##  @param[in] uid \ref AccountUid
##

proc friendsLaStartFacedFriendRequest*(uid: AccountUid): Result {.cdecl,
    importc: "friendsLaStartFacedFriendRequest".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_StartFacedFriendRequest, the specified input, and playStartupSound=false.
##  @param[in] uid \ref AccountUid
##

proc friendsLaShowReceivedFriendRequestList*(uid: AccountUid): Result {.cdecl,
    importc: "friendsLaShowReceivedFriendRequestList".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_ShowReceivedFriendRequestList, the specified input, and playStartupSound=false.
##  @param[in] uid \ref AccountUid
##

proc friendsLaShowBlockedUserList*(uid: AccountUid): Result {.cdecl,
    importc: "friendsLaShowBlockedUserList".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_ShowBlockedUserList, the specified input, and playStartupSound=false.
##  @param[in] uid \ref AccountUid
##

proc friendsLaShowMyProfile*(uid: AccountUid): Result {.cdecl,
    importc: "friendsLaShowMyProfile".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_ShowMyProfile, the specified input, and playStartupSound=false.
##  @param[in] uid \ref AccountUid
##

proc friendsLaShowMyProfileForHomeMenu*(uid: AccountUid): Result {.cdecl,
    importc: "friendsLaShowMyProfileForHomeMenu".}
## *
##  @brief Same as \ref friendsLaShowMyProfile except with playStartupSound=true.
##  @param[in] uid \ref AccountUid
##

proc friendsLaStartFriendInvitation*(uid: AccountUid; id_count: S32; desc: ptr FriendsFriendInvitationGameModeDescription;
                                    userdata: pointer; userdata_size: U64): Result {.
    cdecl, importc: "friendsLaStartFriendInvitation".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_StartFriendInvitation, the specified input, and playStartupSound=false. On success, this will load the output Result from the output storage.
##  @note Only available on [9.0.0+].
##  @param[in] uid \ref AccountUid
##  @param[in] id_count \ref AccountNetworkServiceAccountId count, must be 1-15. Number of friends to invite.
##  @param[in] desc \ref FriendsFriendInvitationGameModeDescription
##  @param[in] userdata Arbitrary user-data. Can be NULL.
##  @param[in] userdata_size User-data size, must be <=0x400. Can be 0 if userdata is NULL.
##

proc friendsLaStartSendingFriendInvitation*(uid: AccountUid;
    id_list: ptr AccountNetworkServiceAccountId; id_count: S32;
    desc: ptr FriendsFriendInvitationGameModeDescription; userdata: pointer;
    userdata_size: U64): Result {.cdecl,
                               importc: "friendsLaStartSendingFriendInvitation".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_StartSendingFriendInvitation, the specified input, and playStartupSound=false. On success, this will load the output Result from the output storage.
##  @note Only available on [9.0.0+].
##  @param[in] uid \ref AccountUid
##  @param[in] id_list \ref AccountNetworkServiceAccountId list.
##  @param[in] id_count Size of the id_list array in entries, must be 1-15. Number of friends to invite.
##  @param[in] desc \ref FriendsFriendInvitationGameModeDescription
##  @param[in] userdata Arbitrary user-data. Can be NULL.
##  @param[in] userdata_size User-data size, must be <=0x400. Can be 0 if userdata is NULL.
##

proc friendsLaShowReceivedInvitationDetail*(uid: AccountUid;
    invitation_id: FriendsFriendInvitationId;
    invitation_group_id: FriendsFriendInvitationGroupId): Result {.cdecl,
    importc: "friendsLaShowReceivedInvitationDetail".}
## *
##  @brief Launches the applet with ::FriendsLaArgType_ShowReceivedInvitationDetail, the specified input, and playStartupSound=false.
##  @note Only available on [9.0.0+].
##  @param[in] uid \ref AccountUid
##  @param[in] invitation_id \ref FriendsFriendInvitationId
##  @param[in] invitation_group_id \ref FriendsFriendInvitationGroupId
##

