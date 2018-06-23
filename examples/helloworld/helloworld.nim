import libnx/wrapper/gfx
import libnx/wrapper/console
import libnx/wrapper/hid
import libnx/wrapper/applet

proc printf(formatstr: cstring) {.importc: "printf", varargs,
                                  header: "<stdio.h>".}

proc main() =
  gfxInitDefault()

  discard consoleInit(nil)

  printf("\x1b[16;20HHello World From NIM!")
  echo "\x1b[17;20HHELLO FROM NIM"
  while appletMainLoop():
    hidScanInput()

    let keysDown = hidKeysDown(CONTROLLER_P1_AUTO)

    if (keysDown and KEY_PLUS.uint64) > 0.uint64:
      break

    gfxFlushBuffers()
    gfxSwapBuffers()
    gfxWaitForVsync()

  gfxExit()

main()
