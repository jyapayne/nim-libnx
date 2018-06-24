import strutils
import libnx/wrapper/acc
import libnx/results
import libnx/wrapper/types
import libnx/service

type
  AccountError* = object of Exception

  User* = ref object
    id*: u128
    selected*: bool
    username*: string
    lastEdited*: uint64
    iconID*: uint32
    iconBgColorID*: uint8
    miiID*: array[0x10, uint8]

  Profile* = ref object
    service*: Service

  AccountImage* = ref object
    data: seq[uint8]
    imageSize: int

var enabled = false

template raiseEx(message: string) =
  raise newException(AccountError, message)

proc getService*(): Service =
  let serv = accountGetService()[]
  result = newService(serv)

proc init() =
  let service = getService()
  if service.isActive:
    return

  let code = accountInitialize().newResult
  if code.failed:
    raiseEx("Error, account api could not be initialized: " & code.description)

proc exit() =
  let service = getService()
  if not service.isActive:
    return
  accountExit()

proc close*(profile: AccountProfile) =
  accountProfileClose(profile.unsafeAddr)

template withAccountService*(code: untyped): typed =
  enabled = true
  init()
  code
  exit()
  enabled = false

proc ensureEnabled() =
  if not enabled:
    raiseEx("Use withAccountService to access account functions.")

proc getImageSize*(profile: AccountProfile): int =
  ensureEnabled()
  var res = 0.csize
  result = 0
  let code = accountProfileGetImageSize(profile.unsafeAddr, res.addr).newResult
  if code.failed:
    raiseEx("Error, image size could not be received: " & code.description)
  result = res.int

proc imageSize*(user: User): int =
  var prof: AccountProfile
  var size: csize
  let res = accountProfileGetImageSize(prof.addr, size.addr).newResult

  if res.failed:
    raiseEx("Error, could not get image size: " & res.description)

  result = size.int

proc getProfileHelper(userID: u128): AccountProfile =
  let res = accountGetProfile(result.addr, userID).newResult

  if res.failed:
    raiseEx("Error, could not get user profile: " & res.description)


proc loadImage*(user: User): AccountImage =
  ensureEnabled()
  result = new(AccountImage)
  let imSize = user.imageSize()
  var size: csize

  var prof = getProfileHelper(user.id)

  result.data = newSeq[uint8](imSize)

  let res = accountProfileLoadImage(
    prof.addr, result.data[0].addr,
    imSize, result.imageSize.addr
  ).newResult

  if res.failed:
    prof.close()
    raiseEx("Error, could not load image: " & res.description)

  prof.close()

proc getActiveUser*(): User =
  ensureEnabled()
  result = new(User)
  var
    userID: u128
    selected: bool

  var res = accountGetActiveUser(userID.addr, selected.addr).newResult

  if res.failed:
    raiseEx("Error, could not get active user ID: " & res.description)

  if not selected:
    raiseEx("No user currently selected!")

  result.id = userID
  result.selected = selected

  var
    prof: AccountProfile = getProfileHelper(userID)
    userData: AccountUserData
    profBase: AccountProfileBase

  res = accountProfileGet(prof.addr, userData.addr, profBase.addr).newResult

  if res.failed:
    raiseEx("Error, could not get user data: " & res.description)

  result.username = profBase.username.join("")
  result.lastEdited = profBase.lastEditTimestamp
  result.iconID = userData.iconID
  result.iconBgColorID = userData.iconBackgroundColorID
  result.miiID = userData.miiID

  prof.close()


proc getProfile*(user: User): Profile =
  ensureEnabled()
  result = new(Profile)
  var prof: AccountProfile

  let res = accountGetProfile(prof.addr, user.id).newResult
  if res.failed:
    raiseEx("Error, could not get account profile: " & res.description)

  result.service = newService(prof.s)
  prof.close()
