## *
##  @file console.h
##  @brief Framebuffer text console.
##  @author yellows8
##  @author WinterMute
##  @copyright libnx Authors
##
##  Provides stdio integration for printing to the Switch screen as well as debug print
##  functionality provided by stderr.
##
##  General usage is to initialize the console by:
##  @code
##  consoleInit(NULL)
##  @endcode
##  optionally customizing the console usage by passing a pointer to a custom PrintConsole struct.
##

import
  ../../types

template CONSOLE_ESC*(x: string): string =
  ("\x1b[" & x)

const
  CONSOLE_RESET* = "0m".CONSOLE_ESC
  CONSOLE_BLACK* = "30m".CONSOLE_ESC
  CONSOLE_RED* = "31;1m".CONSOLE_ESC
  CONSOLE_GREEN* = "32;1m".CONSOLE_ESC
  CONSOLE_YELLOW* = "33;1m".CONSOLE_ESC
  CONSOLE_BLUE* = "34;1m".CONSOLE_ESC
  CONSOLE_MAGENTA* = "35;1m".CONSOLE_ESC
  CONSOLE_CYAN* = "36;1m".CONSOLE_ESC
  CONSOLE_WHITE* = "37;1m".CONSOLE_ESC

##  Forward declaration


## / Renderer interface for the console.

type
  ConsoleRenderer* {.bycopy.} = object
    init*: proc (con: ptr PrintConsole): bool {.cdecl.}
    deinit*: proc (con: ptr PrintConsole) {.cdecl.}
    drawChar*: proc (con: ptr PrintConsole; x: cint; y: cint; c: cint) {.cdecl.}
    scrollWindow*: proc (con: ptr PrintConsole) {.cdecl.}
    flushAndSwap*: proc (con: ptr PrintConsole) {.cdecl.}

  PrintConsole* {.bycopy.} = object
    ## *
    ##  @brief Console structure used to store the state of a console render context.
    ##
    ##  Default values from consoleGetDefault();
    ##  @code
    ##  PrintConsole defaultConsole =
    ##  {
    ##  	//Font:
    ##  	{
    ##  		default_font_bin, //font gfx
    ##  		0, //first ascii character in the set
    ##  		256, //number of characters in the font set
    ##  		16, //tile width
    ##  		16, //tile height
    ## 	},
    ## 	NULL, //renderer
    ## 	0,0, //cursorX cursorY
    ## 	0,0, //prevcursorX prevcursorY
    ## 	80, //console width
    ## 	45, //console height
    ## 	0,  //window x
    ## 	0,  //window y
    ## 	80, //window width
    ## 	45, //window height
    ## 	3, //tab size
    ## 	7, // foreground color
    ## 	0, // background color
    ## 	0, // flags
    ## 	false //console initialized
    ##  };
    ##  @endcode
    ##
    font*: ConsoleFont         ## /< Font of the console
    renderer*: ptr ConsoleRenderer ## /< Renderer of the console
    cursorX*: cint             ## /< Current X location of the cursor (as a tile offset by default)
    cursorY*: cint             ## /< Current Y location of the cursor (as a tile offset by default)
    prevCursorX*: cint         ## /< Internal state
    prevCursorY*: cint         ## /< Internal state
    consoleWidth*: cint        ## /< Width of the console hardware layer in characters
    consoleHeight*: cint       ## /< Height of the console hardware layer in characters
    windowX*: cint             ## /< Window X location in characters
    windowY*: cint             ## /< Window Y location in characters
    windowWidth*: cint         ## /< Window width in characters
    windowHeight*: cint        ## /< Window height in characters
    tabSize*: cint             ## /< Size of a tab
    fg*: U16                   ## /< Foreground color
    bg*: U16                   ## /< Background color
    flags*: cint               ## /< Reverse/bright flags
    consoleInitialised*: bool  ## /< True if the console is initialized

  ConsoleFont* {.bycopy.} = object
    ## / A font struct for the console.
    gfx*: pointer              ## /< A pointer to the font graphics
    asciiOffset*: U16          ## /< Offset to the first valid character in the font table
    numChars*: U16             ## /< Number of characters in the font graphics
    tileWidth*: U16
    tileHeight*: U16

const
  CONSOLE_COLOR_BOLD* = (1 shl 0) ## /< Bold text
  CONSOLE_COLOR_FAINT* = (1 shl 1) ## /< Faint text
  CONSOLE_ITALIC* = (1 shl 2)     ## /< Italic text
  CONSOLE_UNDERLINE* = (1 shl 3)  ## /< Underlined text
  CONSOLE_BLINK_SLOW* = (1 shl 4) ## /< Slow blinking text
  CONSOLE_BLINK_FAST* = (1 shl 5) ## /< Fast blinking text
  CONSOLE_COLOR_REVERSE* = (1 shl 6) ## /< Reversed color text
  CONSOLE_CONCEAL* = (1 shl 7)    ## /< Concealed text
  CONSOLE_CROSSED_OUT* = (1 shl 8) ## /< Crossed out text
  CONSOLE_FG_CUSTOM* = (1 shl 9)  ## /< Foreground custom color
  CONSOLE_BG_CUSTOM* = (1 shl 10) ## /< Background custom color

## / Console debug devices supported by libnx.

type
  DebugDevice* = enum
    debugDeviceNULL,          ## /< Swallows prints to stderr
    debugDeviceSVC,           ## /< Outputs stderr debug statements using svcOutputDebugString, which can then be captured by interactive debuggers
    debugDeviceCONSOLE        ## /< Directs stderr debug statements to Switch console window

proc consoleSetFont*(console: ptr PrintConsole; font: ptr ConsoleFont) {.cdecl,
    importc: "consoleSetFont".}
## *
##  @brief Loads the font into the console.
##  @param console Pointer to the console to update, if NULL it will update the current console.
##  @param font The font to load.
##

proc consoleSetWindow*(console: ptr PrintConsole; x: cint; y: cint; width: cint;
                      height: cint) {.cdecl, importc: "consoleSetWindow".}
## *
##  @brief Sets the print window.
##  @param console Console to set, if NULL it will set the current console window.
##  @param x X location of the window.
##  @param y Y location of the window.
##  @param width Width of the window.
##  @param height Height of the window.
##

proc consoleGetDefault*(): ptr PrintConsole {.cdecl, importc: "consoleGetDefault".}
## *
##  @brief Gets a pointer to the console with the default values.
##  This should only be used when using a single console or without changing the console that is returned, otherwise use consoleInit().
##  @return A pointer to the console with the default values.
##

proc consoleSelect*(console: ptr PrintConsole): ptr PrintConsole {.cdecl,
    importc: "consoleSelect".}
## *
##  @brief Make the specified console the render target.
##  @param console A pointer to the console struct (must have been initialized with consoleInit(PrintConsole* console)).
##  @return A pointer to the previous console.
##

proc consoleInit*(console: ptr PrintConsole): ptr PrintConsole {.cdecl,
    importc: "consoleInit".}
## *
##  @brief Initialise the console.
##  @param console A pointer to the console data to initialize (if it's NULL, the default console will be used).
##  @return A pointer to the current console.
##

proc consoleExit*(console: ptr PrintConsole) {.cdecl, importc: "consoleExit".}
## *
##  @brief Deinitialise the console.
##  @param console A pointer to the console data to initialize (if it's NULL, the default console will be used).
##

proc consoleUpdate*(console: ptr PrintConsole) {.cdecl, importc: "consoleUpdate".}
## *
##  @brief Updates the console, submitting a new frame to the display.
##  @param console A pointer to the console data to initialize (if it's NULL, the default console will be used).
##  @remark This function should be called periodically. Failure to call this function will result in lack of screen updating.
##

proc consoleDebugInit*(device: DebugDevice) {.cdecl, importc: "consoleDebugInit".}
## *
##  @brief Initializes debug console output on stderr to the specified device.
##  @param device The debug device (or devices) to output debug print statements to.
##

proc consoleClear*() {.cdecl, importc: "consoleClear".}
## / Clears the screan by using printf("\x1b[2J");
