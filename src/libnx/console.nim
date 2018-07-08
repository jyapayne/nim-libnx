import libnx/wrapper/con
import libnx/utils
import macros, strutils


type
  PrintCallback* = proc (con: Console; c: char): bool

  Font* = ref ConsoleFont

  Style* {.pure.} = enum
    Bold = CONSOLE_COLOR_BOLD(),
    Faint = CONSOLE_COLOR_FAINT(),
    Italic = CONSOLE_ITALIC(),
    Underline = CONSOLE_UNDERLINE(),
    BlinkSlow = CONSOLE_BLINK_SLOW(),
    BlinkFast = CONSOLE_BLINK_FAST(),
    ColorReverse = CONSOLE_COLOR_REVERSE(),
    Conceal = CONSOLE_CONCEAL(),
    CrossedOut = CONSOLE_CROSSED_OUT()

  Console* = ref object
    pcon: ptr PrintConsole
    font*: ConsoleFont
    frameBuffer*: ptr UncheckedArray[uint32]
    frameBuffer2*: ptr UncheckedArray[uint32]
    cursorX*: int
    cursorY*: int
    prevCursorX*: int
    prevCursorY*: int
    width*: int
    height*: int
    windowX*: int
    windowY*: int
    windowWidth*: int
    windowHeight*: int
    tabSize*: int
    fg*: int
    bg*: int
    flags*: set[Style]
    printCharCallback*: PrintCallback
    initialised*: bool

  DebugDevice* {.size: sizeof(cint), pure.} = enum
    Null, Service, Console, ThreeDMOO

proc toConsole(pconsole: ptr PrintConsole): Console =
  result = new(Console)
  result.pcon = pconsole
  result.font = pconsole.font
  result.cursorX = pconsole.cursorX
  result.frameBuffer = cast[ptr UncheckedArray[uint32]](pconsole.frameBuffer)
  result.frameBuffer2 = cast[ptr UncheckedArray[uint32]](pconsole.frameBuffer2)
  result.cursorX = pconsole.cursorX
  result.cursorY = pconsole.cursorY
  result.prevCursorX = pconsole.prevCursorX
  result.prevCursorY = pconsole.prevCursorY
  result.width = pconsole.consoleWidth
  result.height = pconsole.consoleHeight
  result.windowX = pconsole.windowX
  result.windowY = pconsole.windowY
  result.windowWidth = pconsole.windowWidth
  result.windowHeight = pconsole.windowHeight
  result.tabSize = pconsole.tabSize
  result.fg = pconsole.fg
  result.bg = pconsole.bg
  result.flags = {}

  result.pcon.PrintChar = proc (con: pointer, c: cint): bool {.cdecl.} =
    let console = cast[ptr PrintConsole](con).toConsole()
    if not console.printCharCallback.isNil:
      return console.printCharCallback(console, c.char)

  result.initialised = pconsole.consoleInitialised

proc setFont*(console: Console; font: Font) =
  var f = font
  consoleSetFont(console.pcon, f[].addr)
  console.font = console.pcon.font

proc setWindow*(console: Console, x, y, width, height: int) =
  console.pcon.consoleSetWindow(x.cint, y.cint, width.cint, height.cint)
  console.width = console.pcon.consoleWidth
  console.height = console.pcon.consoleHeight
  console.windowX = console.pcon.windowX.int
  console.windowY = console.pcon.windowY.int

proc getDefault*(): Console =
  let pcon = consoleGetDefault()
  result = pcon.toConsole()

proc select*(console: Console): Console =
  consoleSelect(console.pcon).toConsole()

proc init*(console: Console = nil): Console {.discardable.} =
  var newCon = console
  if newCon.isNil:
    newCon = new(Console)

  let pcon = consoleInit(newCon.pcon)
  newCon = pcon.toConsole()
  return newCon

proc debugInit*(device: DebugDevice) =
  if device == ThreeDMOO:
    consoleDebugInit(debugDevice_3DMOO)
  else:
    consoleDebugInit(debugDevice(device))

proc clear*() =
  consoleClear()

var printPos: tuple[row: int, col: int] = (0, 0)

proc setPrintPos*(pos: tuple[row: int, col: int]) =
  printPos = pos

proc printAt*(pos: tuple[row: int, col: int], args: varargs[string, `$`]) =
  setPrintPos(pos)
  echo ("\x1b[$#;$#H" % [$pos[0], $pos[1]]), args.join("")

proc print*(args: varargs[string, `$`]) =
  ## Will print at the previously set printPos using ``printAt`` or ``setPrintPos``
  ## and then increment the row by one
  printAt printPos, args
  printPos.row += 1
