import libnx/graphics
import libnx/wrapper/console
import libnx/wrapper/hid
import libnx/app

proc main() =
  initDefault()
  discard consoleInit(nil)

  echo "\x1b[17;20HHELLO FROM NIM"
  mainLoop:
    let keysDown = hidKeysDown(CONTROLLER_P1_AUTO)

    if (keysDown and KEY_PLUS.uint64) > 0.uint64:
      break

main()
