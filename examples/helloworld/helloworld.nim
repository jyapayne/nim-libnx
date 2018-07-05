import sets
import libnx/graphics
import libnx/wrapper/con
import libnx/wrapper/hid
import libnx/app
import libnx/input


proc main() =
  initDefault()
  discard consoleInit(nil)

  echo "\x1b[17;20HHELLO FROM NIM"
  mainLoop:
    let keysDown = keysDown(Controller.P1_AUTO)

    if keysDown.len() > 0:
      echo keysDown

    if ControllerKey.Plus in keysDown:
      break

main()
