import macros, strutils, sets
import libnx/wrapper/cons
import libnx/utils


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
    flags*: HashSet[Style]
    printCharCallback*: PrintCallback
    initialised*: bool

  DebugDevice* {.size: sizeof(cint), pure.} = enum
    Null, Service, Console, ThreeDMOO

var currentConsole {.threadvar.}: Console

proc toConsole(pconsole: ptr PrintConsole): Console =
  result = new(Console)
  result.pcon = pconsole
  result.font = pconsole.font
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
  result.flags = initSet[Style]()

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
  ## Gets the default console with default values
  let pcon = consoleGetDefault()
  result = pcon.toConsole()

proc select*(console: Console): Console =
  currentConsole = consoleInit(console.pcon).toConsole()
  return currentConsole

proc init*(console: Console): Console {.discardable.} =
  currentConsole = consoleInit(console.pcon).toConsole()
  return currentConsole

proc init*(): Console {.discardable.} =
  currentConsole = consoleInit(nil).toConsole()
  return currentConsole

proc debugInit*(device: DebugDevice) =
  if device == ThreeDMOO:
    consoleDebugInit(debugDevice_3DMOO)
  else:
    consoleDebugInit(debugDevice(device))

proc clear*() =
  consoleClear()

proc printAt*(pos: tuple[row: int, col: int], args: varargs[string, `$`]) =
  echo CONSOLE_ESC("2K"), (CONSOLE_ESC("$#;$#H") % [$pos.row, $pos.col]), args.join("")
  currentConsole.pcon.cursorX = pos.col.int32
  currentConsole.pcon.cursorY = pos.row.int32
  currentConsole.cursorX = pos.col
  currentConsole.cursorY = pos.row

proc print*(args: varargs[string, `$`]) =
  ## Will print at the previously set printPos using ``printAt``
  ## and then increment the row by one
  let
    pcon = currentConsole.pcon
    printPos = (pcon.cursorY.int+1, pcon.cursorX.int)
  printAt printPos, args
