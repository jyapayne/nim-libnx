import sets
import libnx/graphics
import libnx/console
import libnx/wrapper/hid
import libnx/app
import libnx/input


proc main() =
  initDefault()
  console.init()

  printAt (17, 20), "HELLO FROM NIM"
  mainLoop:
    let keysDown = keysDown(Controller.P1_AUTO)

    if keysDown.len() > 0:
      echo keysDown

    if ControllerKey.Plus in keysDown:
      break

main()
