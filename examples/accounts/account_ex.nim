import sets, strutils
import libnx/graphics
import libnx/wrapper/hid
import libnx/wrapper/console
import libnx/ext/integer128
import libnx/account
import libnx/input
import libnx/app

proc main() =
  initDefault()
  discard consoleInit(nil)

  echo "\x1b[5;2H" & "Account info:"

  withAccountService:
    try:
      let user = getActiveUser()
      let userID = user.id
      echo "\x1b[6;2HUserID: 0x" & userID.toHex()
      echo "\x1b[7;2HUsername: " & user.username
      echo "\x1b[8;2HMiiID: " & $user.miiID
      echo "\x1b[9;2HIconID: " & $user.iconID
    except AccountUserNotSelectedError:
      echo "\x1b[6;2HNo user currently selected!"
    except AccountError:
      let msg = getCurrentExceptionMsg()
      echo "\x1b[6;2H" & msg

    try:
      let users = listAllUsers()
      echo ""
      echo " There are $# users:" % $users.len()
      for user in users:
        echo " User: " & user.username
    except AccountUserListError:
      let msg = getCurrentExceptionMsg()
      echo msg



  mainLoop:
    let keysDown = keysDown(Controller.P1_AUTO)

    if ControllerKey.Plus in keysDown:
      break

main()
