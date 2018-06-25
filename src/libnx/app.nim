import libnx/graphics, libnx/wrapper/hid, libnx/wrapper/applet

template mainLoop*(code: untyped): untyped =
  while appletMainLoop():
    hidScanInput()

    code

    flushBuffers()
    swapBuffers()
    waitForVSync()

  graphics.exit()
