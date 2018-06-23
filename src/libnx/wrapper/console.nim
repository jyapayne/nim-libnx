import strutils
import ospaths
const headerconsole = currentSourcePath().splitPath().head & "/nx/include/switch/runtime/devices/console.h"
import libnx/wrapper/types
type
  ConsolePrint* = proc (con: pointer; c: cint): bool {.cdecl.}
  ConsoleFont* {.importc: "ConsoleFont", header: headerconsole, bycopy.} = object
    gfx* {.importc: "gfx".}: ptr uint16
    asciiOffset* {.importc: "asciiOffset".}: uint16
    numChars* {.importc: "numChars".}: uint16

  PrintConsole* {.importc: "PrintConsole", header: headerconsole, bycopy.} = object
    font* {.importc: "font".}: ConsoleFont
    frameBuffer* {.importc: "frameBuffer".}: ptr uint32
    frameBuffer2* {.importc: "frameBuffer2".}: ptr uint32
    cursorX* {.importc: "cursorX".}: cint
    cursorY* {.importc: "cursorY".}: cint
    prevCursorX* {.importc: "prevCursorX".}: cint
    prevCursorY* {.importc: "prevCursorY".}: cint
    consoleWidth* {.importc: "consoleWidth".}: cint
    consoleHeight* {.importc: "consoleHeight".}: cint
    windowX* {.importc: "windowX".}: cint
    windowY* {.importc: "windowY".}: cint
    windowWidth* {.importc: "windowWidth".}: cint
    windowHeight* {.importc: "windowHeight".}: cint
    tabSize* {.importc: "tabSize".}: cint
    fg* {.importc: "fg".}: cint
    bg* {.importc: "bg".}: cint
    flags* {.importc: "flags".}: cint
    PrintChar* {.importc: "PrintChar".}: ConsolePrint
    consoleInitialised* {.importc: "consoleInitialised".}: bool

  debugDevice* {.size: sizeof(cint).} = enum
    debugDevice_NULL, debugDevice_SVC, debugDevice_CONSOLE

const
  debugDevice_3DMOO = debugDevice_SVC

proc consoleSetFont*(console: ptr PrintConsole; font: ptr ConsoleFont) {.cdecl,
    importc: "consoleSetFont", header: headerconsole.}
proc consoleSetWindow*(console: ptr PrintConsole; x: cint; y: cint; width: cint;
                      height: cint) {.cdecl, importc: "consoleSetWindow",
                                    header: headerconsole.}
proc consoleGetDefault*(): ptr PrintConsole {.cdecl, importc: "consoleGetDefault",
    header: headerconsole.}
proc consoleSelect*(console: ptr PrintConsole): ptr PrintConsole {.cdecl,
    importc: "consoleSelect", header: headerconsole.}
proc consoleInit*(console: ptr PrintConsole): ptr PrintConsole {.cdecl,
    importc: "consoleInit", header: headerconsole.}
proc consoleDebugInit*(device: debugDevice) {.cdecl, importc: "consoleDebugInit",
    header: headerconsole.}
proc consoleClear*() {.cdecl, importc: "consoleClear", header: headerconsole.}