import libnx/wrapper/gfx
import libnx/wrapper/hid
import libnx/wrapper/console
import libnx/account
import libnx/utils

proc main() =
  gfxInitDefault()
  discard consoleInit(nil)

  echo "\x1b[5;2H" & "Account info:"

  withAccountService:
    try:
      let user = getActiveUser()
      echo "\x1b[6;2HUsername: " & user.username
      echo "\x1b[7;2HMiiID: " & $user.miiID
      echo "\x1b[8;2HIconID: " & $user.iconID
    except AccountError:
      echo "\x1b[6;2HNo user currently selected!"

  mainLoop:
    let keysDown = hidKeysDown(CONTROLLER_P1_AUTO)

    if (keysDown and KEY_PLUS.uint64) > 0.uint64:
      break

main()
