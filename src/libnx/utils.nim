import libnx/wrapper/gfx, libnx/wrapper/hid, libnx/wrapper/applet

template mainLoop*(code: untyped): untyped =
  while appletMainLoop():
    hidScanInput()

    code

    gfxFlushBuffers()
    gfxSwapBuffers()
    gfxWaitForVSync()

  gfxExit()
