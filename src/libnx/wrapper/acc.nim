import strutils
import ospaths
const headeracc = currentSourcePath().splitPath().head & "/nx/include/switch/services/acc.h"
import libnx/ext/integer128
import libnx/wrapper/types
import libnx/wrapper/sm
type
  AccountProfile* {.importc: "AccountProfile", header: headeracc, bycopy.} = object
    s* {.importc: "s".}: Service

  AccountUserData* {.importc: "AccountUserData", header: headeracc, bycopy.} = object
    unk_x0* {.importc: "unk_x0".}: uint32
    iconID* {.importc: "iconID".}: uint32
    iconBackgroundColorID* {.importc: "iconBackgroundColorID".}: uint8
    unk_x9* {.importc: "unk_x9".}: array[0x00000007, uint8]
    miiID* {.importc: "miiID".}: array[0x00000010, uint8]
    unk_x20* {.importc: "unk_x20".}: array[0x00000060, uint8]

  AccountProfileBase* {.importc: "AccountProfileBase", header: headeracc, bycopy.} = object
    userID* {.importc: "userID".}: u128
    lastEditTimestamp* {.importc: "lastEditTimestamp".}: uint64
    username* {.importc: "username".}: array[0x00000020, char]


proc accountInitialize*(): Result {.cdecl, importc: "accountInitialize",
                                 header: headeracc.}
proc accountExit*() {.cdecl, importc: "accountExit", header: headeracc.}
proc accountGetService*(): ptr Service {.cdecl, importc: "accountGetService",
                                     header: headeracc.}
proc accountGetActiveUser*(userID: ptr u128; account_selected: ptr bool): Result {.
    cdecl, importc: "accountGetActiveUser", header: headeracc.}
proc accountGetProfile*(`out`: ptr AccountProfile; userID: u128): Result {.cdecl,
    importc: "accountGetProfile", header: headeracc.}
proc accountProfileGet*(profile: ptr AccountProfile; userdata: ptr AccountUserData;
                       profilebase: ptr AccountProfileBase): Result {.cdecl,
    importc: "accountProfileGet", header: headeracc.}
proc accountProfileGetImageSize*(profile: ptr AccountProfile; image_size: ptr csize): Result {.
    cdecl, importc: "accountProfileGetImageSize", header: headeracc.}
proc accountProfileLoadImage*(profile: ptr AccountProfile; buf: pointer; len: csize;
                             image_size: ptr csize): Result {.cdecl,
    importc: "accountProfileLoadImage", header: headeracc.}
proc accountProfileClose*(profile: ptr AccountProfile) {.cdecl,
    importc: "accountProfileClose", header: headeracc.}