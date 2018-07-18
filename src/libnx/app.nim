import libnx/graphics, libnx/input, libnx/wrapper/applet

template mainFunction*(code: untyped): untyped =
  proc main() =
    try:
      code
    except:
      let e = getCurrentException()
      echo ""
      echo e.getStackTrace()
      echo getCurrentExceptionMsg()
      echo ""
      echo "Your program has crashed. Press + on Controller 1 to exit safely."
      echo ""

      while appletMainLoop():
        scanInput()

        let keysDown = keysDown(Controller.P1_AUTO)

        if ControllerKey.Plus in keysDown:
          break

        flushBuffers()
        swapBuffers()
        waitForVSync()
      try:
        graphics.exit()
        quit(0)
      except:
        quit(0)

  main()

template mainLoop*(code: untyped): untyped =
  while appletMainLoop():
    scanInput()

    code

    flushBuffers()
    swapBuffers()
    waitForVSync()

  graphics.exit()
