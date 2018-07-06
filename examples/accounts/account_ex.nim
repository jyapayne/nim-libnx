import sets, strutils
import libnx/[graphics, console, account, input, app]
import libnx/ext/integer128

proc main() =
  graphics.initDefault()
  console.init()

  printAt (5, 2), "Account info:"

  withAccountService:
    try:
      let
        user = getActiveUser()
        userID = user.id

      print "UserID: 0x" & userID.toHex()
      print "Username: " & user.username
      print "MiiID: " & $user.miiID
      print "IconID: " & $user.iconID
    except AccountUserNotSelectedError:
      print "No user currently selected!"
    except AccountError:
      let msg = getCurrentExceptionMsg()
      print msg

    try:
      let users = listAllUsers()
      print ""
      print "There are $# users:" % $users.len()
      for user in users:
        print "User: " & user.username
    except AccountUserListError:
      let msg = getCurrentExceptionMsg()
      print msg


  mainLoop:
    let keysDown = keysDown(Controller.P1_AUTO)

    if keysDown.len() > 0:
      print keysDown

    if ControllerKey.Plus in keysDown:
      break

main()
