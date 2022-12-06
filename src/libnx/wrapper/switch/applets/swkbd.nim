## *
##  @file swkbd.h
##  @brief Wrapper for using the swkbd (software keyboard) LibraryApplet.
##  @author yellowS8
##  @copyright libnx Authors
##

import
  ../types, ../services/applet

## / Output result returned by \ref SwkbdTextCheckCb.

type
  SwkbdTextCheckResult* = enum
    SwkbdTextCheckResultOK = 0, ## /< Success, valid string.
    SwkbdTextCheckResultBad = 1, ## /< Failure, invalid string. Error message is displayed in a message-box, pressing OK will return to swkbd again.
    SwkbdTextCheckResultPrompt = 2, ## /< Failure, invalid string. Error message is displayed in a message-box, pressing Cancel will return to swkbd again, while pressing OK will continue as if the text was valid.
    SwkbdTextCheckResultSilent = 3 ## /< Failure, invalid string. With value 3 and above, swkbd will silently not accept the string, without displaying any error.


## / Type of keyboard.

type
  SwkbdType* = enum
    SwkbdTypeNormal = 0,        ## /< Normal keyboard.
    SwkbdTypeNumPad = 1,        ## /< Number pad. The buttons at the bottom left/right are only available when they're set by \ref swkbdConfigSetLeftOptionalSymbolKey / \ref swkbdConfigSetRightOptionalSymbolKey.
    SwkbdTypeQWERTY = 2,        ## /< QWERTY (and variants) keyboard only.
    SwkbdTypeUnknown3 = 3,      ## /< The same as SwkbdType_Normal keyboard.
    SwkbdTypeLatin = 4,         ## /< All Latin like languages keyboard only (without CJK keyboard).
    SwkbdTypeZhHans = 5,        ## /< Chinese Simplified keyboard only.
    SwkbdTypeZhHant = 6,        ## /< Chinese Traditional keyboard only.
    SwkbdTypeKorean = 7,        ## /< Korean keyboard only.
    SwkbdTypeAll = 8,           ## /< All language keyboards.
    SwkbdTypeUnknown9 = 9       ## /< Unknown


## / Bitmask for SwkbdArgCommon::keySetDisableBitmask. This disables keys on the keyboard when the corresponding bit(s) are set.

const
  SwkbdKeyDisableBitmaskSpace* = bit(1) ## /< Disable space-bar.
  SwkbdKeyDisableBitmaskAt* = bit(2) ## /< Disable '@'.
  SwkbdKeyDisableBitmaskPercent* = bit(3) ## /< Disable '%'.
  SwkbdKeyDisableBitmaskForwardSlash* = bit(4) ## /< Disable '/'.
  SwkbdKeyDisableBitmaskBackslash* = bit(5) ## /< Disable '\'.
  SwkbdKeyDisableBitmaskNumbers* = bit(6) ## /< Disable numbers.
  SwkbdKeyDisableBitmaskDownloadCode* = bit(7) ## /< Used for \ref swkbdConfigMakePresetDownloadCode.
  SwkbdKeyDisableBitmaskUserName* = bit(8) ## /< Used for \ref swkbdConfigMakePresetUserName. Disables '@', '%', and '\'.

## / Value for SwkbdArgCommon::textDrawType. Only applies when stringLenMax is 1..32, otherwise swkbd will only use SwkbdTextDrawType_Box.

type
  SwkbdTextDrawType* = enum
    SwkbdTextDrawTypeLine = 0,  ## /< The text will be displayed on a line. Also enables displaying the Header and Sub text.
    SwkbdTextDrawTypeBox = 1,   ## /< The text will be displayed in a box.
    SwkbdTextDrawTypeDownloadCode = 2 ## /< Used by \ref swkbdConfigMakePresetDownloadCode on [5.0.0+]. Enables using \ref SwkbdArgV7 unk_x3e0.


## / SwkbdInline Interactive input storage request ID.

type
  SwkbdRequestCommand* = enum
    SwkbdRequestCommandFinalize = 0x4, SwkbdRequestCommandSetUserWordInfo = 0x6,
    SwkbdRequestCommandSetCustomizeDic = 0x7, SwkbdRequestCommandCalc = 0xA,
    SwkbdRequestCommandSetCustomizedDictionaries = 0xB,
    SwkbdRequestCommandUnsetCustomizedDictionaries = 0xC,
    SwkbdRequestCommandSetChangedStringV2Flag = 0xD,
    SwkbdRequestCommandSetMovedCursorV2Flag = 0xE


## / SwkbdInline Interactive output storage reply ID.

type
  SwkbdReplyType* = enum
    SwkbdReplyTypeFinishedInitialize = 0x0, SwkbdReplyTypeChangedString = 0x2,
    SwkbdReplyTypeMovedCursor = 0x3, SwkbdReplyTypeMovedTab = 0x4,
    SwkbdReplyTypeDecidedEnter = 0x5, SwkbdReplyTypeDecidedCancel = 0x6,
    SwkbdReplyTypeChangedStringUtf8 = 0x7, SwkbdReplyTypeMovedCursorUtf8 = 0x8,
    SwkbdReplyTypeDecidedEnterUtf8 = 0x9, SwkbdReplyTypeUnsetCustomizeDic = 0xA,
    SwkbdReplyTypeReleasedUserWordInfo = 0xB,
    SwkbdReplyTypeUnsetCustomizedDictionaries = 0xC,
    SwkbdReplyTypeChangedStringV2 = 0xD, SwkbdReplyTypeMovedCursorV2 = 0xE,
    SwkbdReplyTypeChangedStringUtf8V2 = 0xF, SwkbdReplyTypeMovedCursorUtf8V2 = 0x10


## / SwkbdInline State

type
  SwkbdState* = enum
    SwkbdStateInactive = 0x0,   ## /< Default state from \ref swkbdInlineCreate, before a state is set by \ref swkbdInlineUpdate when a reply is received. Also indicates that the applet is no longer running.
    SwkbdStateInitialized = 0x1, ## /< Applet is initialized but hidden.
    SwkbdStateAppearing = 0x2,  ## /< Applet is appearing.
    SwkbdStateShown = 0x3,      ## /< Applet is fully shown and ready to accept text input.
    SwkbdStateDisappearing = 0x4, ## /< The user pressed the ok or cancel button, causing the applet to disappear.
    SwkbdStateUnknown5 = 0x5, SwkbdStateUnknown6 = 0x6


## / Value for \ref SwkbdInitializeArg mode. Controls the LibAppletMode when launching the applet.

type
  SwkbdInlineMode* = enum
    SwkbdInlineModeUserDisplay = 0, ## /< LibAppletMode_BackgroundIndirect. This is the default. The user-process must handle displaying the swkbd gfx on the screen, by loading the image with \ref swkbdInlineGetImage.
    SwkbdInlineModeAppletDisplay = 1 ## /< LibAppletMode_Background. The applet will handle displaying gfx on the screen.


## / TextCheck callback set by \ref swkbdConfigSetTextCheckCallback, for validating the input string when the swkbd ok-button is pressed. This buffer contains an UTF-8 string. This callback should validate the input string, then return a \ref SwkbdTextCheckResult indicating success/failure. On failure, this function must write an error message to the tmp_string buffer, which will then be displayed by swkbd.

type
  SwkbdTextCheckCb* = proc (tmpString: cstring; tmpStringSize: csize_t): SwkbdTextCheckResult {.
      cdecl.}

## / User dictionary word.

type
  SwkbdDictWord* {.bycopy.} = object
    unkX0*: array[0x64, U8]


## / Input data for SwkbdInline request SetCustomizeDic.

type
  SwkbdCustomizeDicInfo* {.bycopy.} = object
    unkX0*: array[0x70, U8]

  SwkbdCustomizedDictionarySet* {.bycopy.} = object
    buffer*: pointer           ## /< 0x1000-byte aligned buffer.
    bufferSize*: U32           ## /< 0x1000-byte aligned buffer size.
    entries*: array[0x18, U64]
    totalEntries*: U16


## / Base swkbd arg struct.

type
  SwkbdArgCommon* {.bycopy.} = object
    `type`*: SwkbdType         ## /< See \ref SwkbdType.
    okButtonText*: array[18 div 2, U16]
    leftButtonText*: U16
    rightButtonText*: U16
    dicFlag*: U8               ## /< Enables dictionary usage when non-zero (including the system dictionary).
    padX1b*: U8
    keySetDisableBitmask*: U32 ## /< See SwkbdKeyDisableBitmask_*.
    initialCursorPos*: U32     ## /< Initial cursor position in the string: 0 = start, 1 = end.
    headerText*: array[130 div 2, U16]
    subText*: array[258 div 2, U16]
    guideText*: array[514 div 2, U16]
    padX3aa*: U16
    stringLenMax*: U32         ## /< When non-zero, specifies the max string length. When the input is too long, swkbd will stop accepting more input until text is deleted via the B button (Backspace). See also \ref SwkbdTextDrawType.
    stringLenMin*: U32         ## /< When non-zero, specifies the min string length. When the input is too short, swkbd will display an icon and disable the ok-button.
    passwordFlag*: U32         ## /< Use password: 0 = disable, 1 = enable.
    textDrawType*: SwkbdTextDrawType ## /< See \ref SwkbdTextDrawType.
    returnButtonFlag*: U16     ## /< Controls whether the Return button is enabled, for newlines input. 0 = disabled, non-zero = enabled.
    blurBackground*: U8        ## /< When enabled with value 1, the background is blurred.
    padX3bf*: U8
    initialStringOffset*: U32
    initialStringSize*: U32
    userDicOffset*: U32
    userDicEntries*: S32
    textCheckFlag*: U8

  SwkbdArgV0* {.bycopy.} = object
    arg*: SwkbdArgCommon
    padX3d1*: array[7, U8]
    textCheckCb*: SwkbdTextCheckCb ## /< This really doesn't belong in a struct sent to another process, but official sw does this.


## / Arg struct for version 0x30007+.

type
  SwkbdArgV7* {.bycopy.} = object
    arg*: SwkbdArgV0
    textGrouping*: array[8, U32] ## /< When set and enabled via \ref SwkbdTextDrawType, controls displayed text grouping (inserts spaces, without affecting output string).


## / Arg struct for version 0x6000B+.

type
  SwkbdArgVB* {.bycopy.} = object
    arg*: SwkbdArgCommon
    padX3d1*: array[3, U8]
    textGrouping*: array[8, U32] ## /< Same as SwkbdArgV7::textGrouping.
    entries*: array[0x18, U64]  ## /< This is SwkbdCustomizedDictionarySet::entries.
    totalEntries*: U8          ## /< This is SwkbdCustomizedDictionarySet::total_entries.
    unkFlag*: U8               ## /< [8.0.0+]
    padX4b6*: array[0xD, U8]
    trigger*: U8               ## /< [8.0.0+]
    padX4c4*: array[4, U8]

  SwkbdConfig* {.bycopy.} = object
    arg*: SwkbdArgV7
    workbuf*: ptr U8
    workbufSize*: csize_t
    maxDictwords*: S32
    customizedDictionarySet*: SwkbdCustomizedDictionarySet
    unkFlag*: U8
    trigger*: U8
    version*: U32


## / Rect

type
  SwkbdRect* {.bycopy.} = object
    x*: S16                    ## /< X
    y*: S16                    ## /< Y
    width*: S16                ## /< Width
    height*: S16               ## /< Height


## / InitializeArg for SwkbdInline.

type
  SwkbdInitializeArg* {.bycopy.} = object
    unkX0*: U32
    mode*: U8                  ## /< See \ref SwkbdInlineMode. (U8 bool)
    unkX5*: U8                 ## /< Only set on [5.0.0+].
    pad*: array[2, U8]

  SwkbdAppearArg* {.bycopy.} = object
    `type`*: SwkbdType         ## /< See \ref SwkbdType.
    okButtonText*: array[9, U16]
    leftButtonText*: U16
    rightButtonText*: U16
    dicFlag*: U8               ## /< Enables dictionary usage when non-zero (including the system dictionary).
    unkX1b*: U8
    keySetDisableBitmask*: U32 ## /< See SwkbdKeyDisableBitmask_*.
    stringLenMax*: S32         ## /< When non-negative and non-zero, specifies the max string length. When the input is too long, swkbd will stop accepting more input until text is deleted via the B button (Backspace).
    stringLenMin*: S32         ## /< When non-negative and non-zero, specifies the min string length. When the input is too short, swkbd will display an icon and disable the ok-button.
    returnButtonFlag*: U8      ## /< Controls whether the Return button is enabled, for newlines input. 0 = disabled, non-zero = enabled.
    unkX29*: U8                ## /< [10.0.0+] When value 1-2, \ref swkbdInlineAppear / \ref swkbdInlineAppearEx will set keytopAsFloating=0 and footerScalable=1.
    unkX2a*: U8
    unkX2b*: U8
    flags*: U32                ## /< Bitmask 0x4: unknown.
    unkX30*: U8
    unkX31*: array[0x17, U8]

  SwkbdInlineCalcArg* {.bycopy.} = object
    unkX0*: U32
    size*: U16                 ## /< Size of this struct.
    unkX6*: U8
    unkX7*: U8
    flags*: U64
    initArg*: SwkbdInitializeArg ## /< Flags bitmask 0x1.
    volume*: cfloat            ## /< Flags bitmask 0x2.
    cursorPos*: S32            ## /< Flags bitmask 0x10.
    appearArg*: SwkbdAppearArg
    inputText*: array[0x3f4 div 2, U16] ## /< Flags bitmask 0x8.
    utf8Mode*: U8              ## /< Flags bitmask 0x20.
    unkX45d*: U8
    enableBackspace*: U8       ## /< Flags bitmask 0x8000. Only available with [5.0.0+].
    unkX45f*: array[3, U8]
    keytopAsFloating*: U8      ## /< Flags bitmask 0x200.
    footerScalable*: U8        ## /< Flags bitmask 0x100.
    alphaEnabledInInputMode*: U8 ## /< Flags bitmask 0x100.
    inputModeFadeType*: U8     ## /< Flags bitmask 0x100.
    disableTouch*: U8          ## /< Flags bitmask 0x200.
    disableHardwareKeyboard*: U8 ## /< Flags bitmask 0x800.
    unkX468*: array[5, U8]
    unkX46d*: U8
    unkX46e*: U8
    unkX46f*: U8
    keytopScaleX*: cfloat      ## /< Flags bitmask 0x200.
    keytopScaleY*: cfloat      ## /< Flags bitmask 0x200.
    keytopTranslateX*: cfloat  ## /< Flags bitmask 0x200.
    keytopTranslateY*: cfloat  ## /< Flags bitmask 0x200.
    keytopBgAlpha*: cfloat     ## /< Flags bitmask 0x100.
    footerBgAlpha*: cfloat     ## /< Flags bitmask 0x100.
    balloonScale*: cfloat      ## /< Flags bitmask 0x200.
    unkX48c*: cfloat
    unkX490*: array[0xc, U8]
    seGroup*: U8               ## /< Flags bitmask: enable=0x2000, disable=0x4000. Only available with [5.0.0+].
    triggerFlag*: U8           ## /< [6.0.0+] Enables using the trigger field when set.
    trigger*: U8               ## /< [6.0.0+] Trigger
    padX49f*: U8


## / Struct data for SwkbdInline Interactive reply storage ChangedString*, at the end following the string.

type
  SwkbdChangedStringArg* {.bycopy.} = object
    stringLen*: U32            ## /< String length in characters, without NUL-terminator.
    dicStartCursorPos*: S32    ## /< Starting cursorPos for the current dictionary word in the current text string. -1 for none.
    dicEndCursorPos*: S32      ## /< Ending cursorPos for the current dictionary word in the current text string. -1 for none.
    cursorPos*: S32            ## /< Cursor position.


## / Struct data for SwkbdInline Interactive reply storage MovedCursor*, at the end following the string.

type
  SwkbdMovedCursorArg* {.bycopy.} = object
    stringLen*: U32            ## /< String length in characters, without NUL-terminator.
    cursorPos*: S32            ## /< Cursor position.


## / Struct data for SwkbdInline Interactive reply storage MovedTab*, at the end following the string.

type
  SwkbdMovedTabArg* {.bycopy.} = object
    unkX0*: U32
    unkX4*: U32


## / Struct data for SwkbdInline Interactive reply storage DecidedEnter*, at the end following the string.

type
  SwkbdDecidedEnterArg* {.bycopy.} = object
    stringLen*: U32            ## /< String length in characters, without NUL-terminator.


## / This callback is used by \ref swkbdInlineUpdate when handling ChangedString* replies (text changed by the user or by \ref swkbdInlineSetInputText).
## / str is the UTF-8 string for the current text.

type
  SwkbdChangedStringCb* = proc (str: cstring; arg: ptr SwkbdChangedStringArg) {.cdecl.}

## / This callback is used by \ref swkbdInlineUpdate when handling ChangedString*V2 replies (text changed by the user or by \ref swkbdInlineSetInputText).
## / str is the UTF-8 string for the current text.

type
  SwkbdChangedStringV2Cb* = proc (str: cstring; arg: ptr SwkbdChangedStringArg;
                               flag: bool) {.cdecl.}

## / This callback is used by \ref swkbdInlineUpdate when handling MovedCursor* replies.
## / str is the UTF-8 string for the current text.

type
  SwkbdMovedCursorCb* = proc (str: cstring; arg: ptr SwkbdMovedCursorArg) {.cdecl.}

## / This callback is used by \ref swkbdInlineUpdate when handling MovedCursor*V2 replies.
## / str is the UTF-8 string for the current text.

type
  SwkbdMovedCursorV2Cb* = proc (str: cstring; arg: ptr SwkbdMovedCursorArg; flag: bool) {.
      cdecl.}

## / This callback is used by \ref swkbdInlineUpdate when handling MovedTab* replies.
## / str is the UTF-8 string for the current text.

type
  SwkbdMovedTabCb* = proc (str: cstring; arg: ptr SwkbdMovedTabArg) {.cdecl.}

## / This callback is used by \ref swkbdInlineUpdate when handling DecidedEnter* replies (when the final text was submitted via the button).
## / str is the UTF-8 string for the current text.

type
  SwkbdDecidedEnterCb* = proc (str: cstring; arg: ptr SwkbdDecidedEnterArg) {.cdecl.}

## / InlineKeyboard

type
  SwkbdInline* {.bycopy.} = object
    version*: U32
    holder*: AppletHolder
    calcArg*: SwkbdInlineCalcArg
    directionalButtonAssignFlag*: bool
    state*: SwkbdState
    dicCustomInitialized*: bool
    customizedDictionariesInitialized*: bool
    dicStorage*: AppletStorage
    wordInfoInitialized*: bool
    wordInfoStorage*: AppletStorage
    interactiveTmpbuf*: ptr U8
    interactiveTmpbufSize*: csize_t
    interactiveStrbuf*: cstring
    interactiveStrbufSize*: csize_t
    finishedInitializeCb*: VoidFn
    decidedCancelCb*: VoidFn
    changedStringCb*: SwkbdChangedStringCb
    changedStringV2Cb*: SwkbdChangedStringV2Cb
    movedCursorCb*: SwkbdMovedCursorCb
    movedCursorV2Cb*: SwkbdMovedCursorV2Cb
    movedTabCb*: SwkbdMovedTabCb
    decidedEnterCb*: SwkbdDecidedEnterCb
    releasedUserWordInfoCb*: VoidFn

proc swkbdCreate*(c: ptr SwkbdConfig; maxDictwords: S32): Result {.cdecl,
    importc: "swkbdCreate".}
## *
##  @brief Creates a SwkbdConfig struct.
##  @param c SwkbdConfig struct.
##  @param max_dictwords Max \ref SwkbdDictWord entries, 0 for none.
##

proc swkbdClose*(c: ptr SwkbdConfig) {.cdecl, importc: "swkbdClose".}
## *
##  @brief Closes a SwkbdConfig struct.
##  @param c SwkbdConfig struct.
##

proc swkbdConfigMakePresetDefault*(c: ptr SwkbdConfig) {.cdecl,
    importc: "swkbdConfigMakePresetDefault".}
## *
##  @brief Clears the args in the SwkbdConfig struct and initializes it with the Default Preset.
##  @note Do not use this before \ref swkbdCreate.
##  @note Uses the following: swkbdConfigSetType() with \ref SwkbdType_QWERTY, swkbdConfigSetInitialCursorPos() with value 1, swkbdConfigSetReturnButtonFlag() with value 1, and swkbdConfigSetBlurBackground() with value 1. Pre-5.0.0: swkbdConfigSetTextDrawType() with \ref SwkbdTextDrawType_Box.
##  @param c SwkbdConfig struct.
##

proc swkbdConfigMakePresetPassword*(c: ptr SwkbdConfig) {.cdecl,
    importc: "swkbdConfigMakePresetPassword".}
## *
##  @brief Clears the args in the SwkbdConfig struct and initializes it with the Password Preset.
##  @note Do not use this before \ref swkbdCreate.
##  @note Uses the following: swkbdConfigSetType() with \ref SwkbdType_QWERTY, swkbdConfigSetInitialCursorPos() with value 1, swkbdConfigSetPasswordFlag() with value 1, and swkbdConfigSetBlurBackground() with value 1.
##  @param c SwkbdConfig struct.
##

proc swkbdConfigMakePresetUserName*(c: ptr SwkbdConfig) {.cdecl,
    importc: "swkbdConfigMakePresetUserName".}
## *
##  @brief Clears the args in the SwkbdConfig struct and initializes it with the UserName Preset.
##  @note Do not use this before \ref swkbdCreate.
##  @note Uses the following: swkbdConfigSetType() with \ref SwkbdType_Normal, swkbdConfigSetKeySetDisableBitmask() with SwkbdKeyDisableBitmask_UserName, swkbdConfigSetInitialCursorPos() with value 1, and swkbdConfigSetBlurBackground() with value 1.
##  @param c SwkbdConfig struct.
##

proc swkbdConfigMakePresetDownloadCode*(c: ptr SwkbdConfig) {.cdecl,
    importc: "swkbdConfigMakePresetDownloadCode".}
## *
##  @brief Clears the args in the SwkbdConfig struct and initializes it with the DownloadCode Preset.
##  @note Do not use this before \ref swkbdCreate.
##  @note Uses the following: swkbdConfigSetType() with \ref SwkbdType_Normal (\ref SwkbdType_QWERTY on [5.0.0+]), swkbdConfigSetKeySetDisableBitmask() with SwkbdKeyDisableBitmask_DownloadCode, swkbdConfigSetInitialCursorPos() with value 1, and swkbdConfigSetBlurBackground() with value 1. [5.0.0+]: swkbdConfigSetStringLenMax() with value 16, swkbdConfigSetStringLenMin() with value 1, and swkbdConfigSetTextDrawType() with SwkbdTextDrawType_DownloadCode. Uses swkbdConfigSetTextGrouping() for [0-2] with: 0x3, 0x7, and 0xb.
##  @param c SwkbdConfig struct.
##

proc swkbdConfigSetOkButtonText*(c: ptr SwkbdConfig; str: cstring) {.cdecl,
    importc: "swkbdConfigSetOkButtonText".}
## *
##  @brief Sets the Ok button text. The default is "".
##  @param c SwkbdConfig struct.
##  @param str UTF-8 input string.
##

proc swkbdConfigSetLeftOptionalSymbolKey*(c: ptr SwkbdConfig; str: cstring) {.cdecl,
    importc: "swkbdConfigSetLeftOptionalSymbolKey".}
## *
##  @brief Sets the LeftOptionalSymbolKey, for \ref SwkbdType_NumPad. The default is "".
##  @param c SwkbdConfig struct.
##  @param str UTF-8 input string.
##

proc swkbdConfigSetRightOptionalSymbolKey*(c: ptr SwkbdConfig; str: cstring) {.cdecl,
    importc: "swkbdConfigSetRightOptionalSymbolKey".}
## *
##  @brief Sets the RightOptionalSymbolKey, for \ref SwkbdType_NumPad. The default is "".
##  @param c SwkbdConfig struct.
##  @param str UTF-8 input string.
##

proc swkbdConfigSetHeaderText*(c: ptr SwkbdConfig; str: cstring) {.cdecl,
    importc: "swkbdConfigSetHeaderText".}
## *
##  @brief Sets the Header text. The default is "".
##  @note See SwkbdArgCommon::stringLenMax.
##  @param c SwkbdConfig struct.
##  @param str UTF-8 input string.
##

proc swkbdConfigSetSubText*(c: ptr SwkbdConfig; str: cstring) {.cdecl,
    importc: "swkbdConfigSetSubText".}
## *
##  @brief Sets the Sub text. The default is "".
##  @note See SwkbdArgCommon::stringLenMax.
##  @param c SwkbdConfig struct.
##  @param str UTF-8 input string.
##

proc swkbdConfigSetGuideText*(c: ptr SwkbdConfig; str: cstring) {.cdecl,
    importc: "swkbdConfigSetGuideText".}
## *
##  @brief Sets the Guide text. The default is "".
##  @note The swkbd applet only displays this when the current displayed cursor position is 0.
##  @param c SwkbdConfig struct.
##  @param str UTF-8 input string.
##

proc swkbdConfigSetInitialText*(c: ptr SwkbdConfig; str: cstring) {.cdecl,
    importc: "swkbdConfigSetInitialText".}
## *
##  @brief Sets the Initial text. The default is "".
##  @param c SwkbdConfig struct.
##  @param str UTF-8 input string.
##

proc swkbdConfigSetDictionary*(c: ptr SwkbdConfig; input: ptr SwkbdDictWord;
                              entries: S32) {.cdecl,
    importc: "swkbdConfigSetDictionary".}
## *
##  @brief Sets the user dictionary.
##  @param c SwkbdConfig struct.
##  @param input Input data.
##  @param entries Total entries in the buffer.
##

proc swkbdConfigSetCustomizedDictionaries*(c: ptr SwkbdConfig;
    dic: ptr SwkbdCustomizedDictionarySet): Result {.cdecl,
    importc: "swkbdConfigSetCustomizedDictionaries".}
## *
##  @brief Sets the CustomizedDictionaries.
##  @note Only available on [6.0.0+].
##  @param c SwkbdConfig struct.
##  @param dic Input \ref SwkbdCustomizedDictionarySet
##

proc swkbdConfigSetTextCheckCallback*(c: ptr SwkbdConfig; cb: SwkbdTextCheckCb) {.
    cdecl, importc: "swkbdConfigSetTextCheckCallback".}
## *
##  @brief Sets the TextCheck callback.
##  @param c SwkbdConfig struct.
##  @param cb \ref SwkbdTextCheckCb callback.
##

proc swkbdConfigSetType*(c: ptr SwkbdConfig; `type`: SwkbdType) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::SwkbdType.
  ##  @param c SwkbdConfig struct.
  ##  @param type \ref SwkbdType
  ##

  c.arg.arg.arg.`type` = `type`

proc swkbdConfigSetDicFlag*(c: ptr SwkbdConfig; flag: U8) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::dicFlag.
  ##  @param c SwkbdConfig struct.
  ##  @param flag Flag
  ##

  c.arg.arg.arg.dicFlag = flag

proc swkbdConfigSetKeySetDisableBitmask*(c: ptr SwkbdConfig;
                                        keySetDisableBitmask: U32) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::keySetDisableBitmask.
  ##  @param c SwkbdConfig struct.
  ##  @param keySetDisableBitmask keySetDisableBitmask
  ##

  c.arg.arg.arg.keySetDisableBitmask = keySetDisableBitmask

proc swkbdConfigSetInitialCursorPos*(c: ptr SwkbdConfig; initialCursorPos: U32) {.
    inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::initialCursorPos.
  ##  @param c SwkbdConfig struct.
  ##  @param initialCursorPos initialCursorPos
  ##

  c.arg.arg.arg.initialCursorPos = initialCursorPos

proc swkbdConfigSetStringLenMax*(c: ptr SwkbdConfig; stringLenMax: U32) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::stringLenMax.
  ##  @param c SwkbdConfig struct.
  ##  @param stringLenMax stringLenMax
  ##

  c.arg.arg.arg.stringLenMax = stringLenMax

proc swkbdConfigSetStringLenMin*(c: ptr SwkbdConfig; stringLenMin: U32) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::stringLenMin.
  ##  @param c SwkbdConfig struct.
  ##  @param stringLenMin stringLenMin
  ##

  c.arg.arg.arg.stringLenMin = stringLenMin

proc swkbdConfigSetPasswordFlag*(c: ptr SwkbdConfig; flag: U32) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::passwordFlag.
  ##  @param c SwkbdConfig struct.
  ##  @param flag Flag
  ##

  c.arg.arg.arg.passwordFlag = flag

proc swkbdConfigSetTextDrawType*(c: ptr SwkbdConfig; textDrawType: SwkbdTextDrawType) {.
    inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::textDrawType.
  ##  @param c SwkbdConfig struct.
  ##  @param textDrawType \ref SwkbdTextDrawType
  ##

  c.arg.arg.arg.textDrawType = textDrawType

proc swkbdConfigSetReturnButtonFlag*(c: ptr SwkbdConfig; flag: U16) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::returnButtonFlag.
  ##  @param c SwkbdConfig struct.
  ##  @param flag Flag
  ##

  c.arg.arg.arg.returnButtonFlag = flag

proc swkbdConfigSetBlurBackground*(c: ptr SwkbdConfig; blurBackground: U8) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgCommon::blurBackground.
  ##  @param c SwkbdConfig struct.
  ##  @param blurBackground blurBackground
  ##

  c.arg.arg.arg.blurBackground = blurBackground

proc swkbdConfigSetTextGrouping*(c: ptr SwkbdConfig; index: U32; value: U32) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdArgV7::textGrouping.
  ##  @param index Array index.
  ##  @param value Value to write.
  ##

  if index >= sizeof(c.arg.textGrouping) div sizeof(U32):
    return
  c.arg.textGrouping[index] = value

proc swkbdConfigSetUnkFlag*(c: ptr SwkbdConfig; flag: U8) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdConfig::unkFlag, default is 0. Copied to SwkbdArgVB::unkFlag with [8.0.0+].
  ##  @param flag Flag
  ##

  c.unkFlag = flag

proc swkbdConfigSetTrigger*(c: ptr SwkbdConfig; trigger: U8) {.inline, cdecl.} =
  ## *
  ##  @brief Sets SwkbdConfig::trigger, default is 0. Copied to SwkbdArgVB::trigger with [8.0.0+].
  ##  @param trigger Trigger
  ##

  c.trigger = trigger

proc swkbdShow*(c: ptr SwkbdConfig; outString: cstring; outStringSize: csize_t): Result {.
    cdecl, importc: "swkbdShow".}
## *
##  @brief Launch swkbd with the specified config. This will return once swkbd is finished running.
##  @note The string buffer is also used for the buffer passed to the \ref SwkbdTextCheckCb, when it's set. Hence, in that case this buffer should be large enough to handle TextCheck string input/output. The size passed to the callback is the same size passed here, -1.
##  @param c SwkbdConfig struct.
##  @param out_string UTF-8 Output string buffer.
##  @param out_string_size UTF-8 Output string buffer size, including NUL-terminator.
##

proc swkbdInlineCreate*(s: ptr SwkbdInline): Result {.cdecl,
    importc: "swkbdInlineCreate".}
## *
##  @brief Creates a SwkbdInline object. Only available on [2.0.0+].
##  @note This is essentially an asynchronous version of the regular swkbd.
##  @note This calls \ref swkbdInlineSetUtf8Mode internally with flag=true.
##  @param s SwkbdInline object.
##

proc swkbdInlineClose*(s: ptr SwkbdInline): Result {.cdecl,
    importc: "swkbdInlineClose".}
## *
##  @brief Closes a SwkbdInline object. If the applet is running, this will tell the applet to exit, then wait for the applet to exit + applet exit handling.
##  @param s SwkbdInline object.
##

proc swkbdInlineLaunch*(s: ptr SwkbdInline): Result {.cdecl,
    importc: "swkbdInlineLaunch".}
## *
##  @brief Does setup for \ref SwkbdInitializeArg and launches the applet with the SwkbdInline object.
##  @note The initArg is cleared, and on [5.0.0+] unk_x5 is set to 1.
##  @param s SwkbdInline object.
##

proc swkbdInlineLaunchForLibraryApplet*(s: ptr SwkbdInline; mode: U8; unkX5: U8): Result {.
    cdecl, importc: "swkbdInlineLaunchForLibraryApplet".}
## *
##  @brief Same as \ref swkbdInlineLaunch, except mode and unk_x5 for \ref SwkbdInitializeArg are set to the input params.
##  @param s SwkbdInline object.
##  @param mode Value for SwkbdInitializeArg::mode.
##  @param unk_x5 Value for SwkbdInitializeArg::unk_x5.
##

proc swkbdInlineGetWindowSize*(width: ptr S32; height: ptr S32) {.inline, cdecl.} =
  ## *
  ##  @brief GetWindowSize
  ##  @param[out] width Output width.
  ##  @param[out] height Output height.
  ##

  width[] = 1280
  height[] = 720

proc swkbdInlineGetImageMemoryRequirement*(outSize: ptr U64; outAlignment: ptr U64): Result {.
    cdecl, importc: "swkbdInlineGetImageMemoryRequirement".}
## *
##  @brief GetImageMemoryRequirement
##  @note Wrapper for \ref viGetIndirectLayerImageRequiredMemoryInfo.
##  @param[out] out_size Output size.
##  @param[out] out_alignment Output alignment.
##

proc swkbdInlineGetImage*(s: ptr SwkbdInline; buffer: pointer; size: U64;
                         dataAvailable: ptr bool): Result {.cdecl,
    importc: "swkbdInlineGetImage".}
## *
##  @brief GetImage
##  @note Only available with ::SwkbdInlineMode_UserDisplay.
##  @note For width/height, see \ref swkbdInlineGetWindowSize.
##  @param s SwkbdInline object.
##  @param[out] buffer Output RGBA8 image buffer, this must use the alignment from \ref swkbdInlineGetImageMemoryRequirement.
##  @param[in] size Output buffer size, this must match the size from \ref swkbdInlineGetImageMemoryRequirement.
##  @param[out] data_available Whether data is available.
##

proc swkbdInlineGetMaxHeight*(s: ptr SwkbdInline): S32 {.cdecl,
    importc: "swkbdInlineGetMaxHeight".}
## *
##  @brief Gets the image max height, relative to the bottom of the screen.
##  @param s SwkbdInline object.
##

proc swkbdInlineGetMiniaturizedHeight*(s: ptr SwkbdInline): S32 {.cdecl,
    importc: "swkbdInlineGetMiniaturizedHeight".}
## *
##  @brief Gets the MiniaturizedHeight, relative to the bottom of the screen.
##  @param s SwkbdInline object.
##

proc swkbdInlineGetTouchRectangles*(s: ptr SwkbdInline; keytop: ptr SwkbdRect;
                                   footer: ptr SwkbdRect): S32 {.cdecl,
    importc: "swkbdInlineGetTouchRectangles".}
## *
##  @brief GetTouchRectangles. Returns number of valid Rects: 1 for only keytop, 2 for keytop/footer.
##  @param s SwkbdInline object.
##  @param[out] keytop \ref SwkbdRect for keytop. Optional, can be NULL.
##  @param[out] footer \ref SwkbdRect for footer. Optional, can be NULL.
##

proc swkbdInlineIsUsedTouchPointByKeyboard*(s: ptr SwkbdInline; x: S32; y: S32): bool {.
    cdecl, importc: "swkbdInlineIsUsedTouchPointByKeyboard".}
## *
##  @brief Gets whether the input x/y are within the output from \ref swkbdInlineGetTouchRectangles.
##  @param s SwkbdInline object.
##  @param[out] x X
##  @param[out] y Y
##

proc swkbdInlineUpdate*(s: ptr SwkbdInline; outState: ptr SwkbdState): Result {.cdecl,
    importc: "swkbdInlineUpdate".}
## *
##  @brief Handles updating SwkbdInline state, this should be called periodically.
##  @note Handles applet exit if needed, and also sends the \ref SwkbdInlineCalcArg to the applet if needed. Hence, this should be called at some point after writing to \ref SwkbdInlineCalcArg.
##  @note Handles applet Interactive storage output when needed.
##  @param s SwkbdInline object.
##  @param out_state Optional output \ref SwkbdState.
##

proc swkbdInlineSetFinishedInitializeCallback*(s: ptr SwkbdInline; cb: VoidFn) {.
    cdecl, importc: "swkbdInlineSetFinishedInitializeCallback".}
## *
##  @brief Sets the FinishedInitialize callback, used by \ref swkbdInlineUpdate. The default is NULL for none.
##  @param s SwkbdInline object.
##  @param cb Callback
##

proc swkbdInlineSetDecidedCancelCallback*(s: ptr SwkbdInline; cb: VoidFn) {.cdecl,
    importc: "swkbdInlineSetDecidedCancelCallback".}
## *
##  @brief Sets the DecidedCancel callback, used by \ref swkbdInlineUpdate. The default is NULL for none.
##  @param s SwkbdInline object.
##  @param cb Callback
##

proc swkbdInlineSetChangedStringCallback*(s: ptr SwkbdInline;
    cb: SwkbdChangedStringCb) {.cdecl,
                              importc: "swkbdInlineSetChangedStringCallback".}
## *
##  @brief Sets the ChangedString callback, used by \ref swkbdInlineUpdate. The default is NULL for none.
##  @note This clears the callback set by \ref swkbdInlineSetChangedStringV2Callback.
##  @note This should be called after \ref swkbdInlineLaunch / \ref swkbdInlineLaunchForLibraryApplet.
##  @param s SwkbdInline object.
##  @param cb \ref SwkbdChangedStringCb Callback
##

proc swkbdInlineSetChangedStringV2Callback*(s: ptr SwkbdInline;
    cb: SwkbdChangedStringV2Cb) {.cdecl, importc: "swkbdInlineSetChangedStringV2Callback".}
## *
##  @brief Sets the ChangedStringV2 callback, used by \ref swkbdInlineUpdate. The default is NULL for none.
##  @note Only available with [8.0.0+].
##  @note This must be called after \ref swkbdInlineLaunch / \ref swkbdInlineLaunchForLibraryApplet.
##  @param s SwkbdInline object.
##  @param cb \ref SwkbdChangedStringV2Cb Callback
##

proc swkbdInlineSetMovedCursorCallback*(s: ptr SwkbdInline; cb: SwkbdMovedCursorCb) {.
    cdecl, importc: "swkbdInlineSetMovedCursorCallback".}
## *
##  @brief Sets the MovedCursor callback, used by \ref swkbdInlineUpdate. The default is NULL for none.
##  @note This clears the callback set by \ref swkbdInlineSetMovedCursorV2Callback.
##  @note This should be called after \ref swkbdInlineLaunch / \ref swkbdInlineLaunchForLibraryApplet.
##  @param s SwkbdInline object.
##  @param cb \ref SwkbdMovedCursorCb Callback
##

proc swkbdInlineSetMovedCursorV2Callback*(s: ptr SwkbdInline;
    cb: SwkbdMovedCursorV2Cb) {.cdecl,
                              importc: "swkbdInlineSetMovedCursorV2Callback".}
## *
##  @brief Sets the MovedCursorV2 callback, used by \ref swkbdInlineUpdate. The default is NULL for none.
##  @note Only available with [8.0.0+].
##  @note This must be called after \ref swkbdInlineLaunch / \ref swkbdInlineLaunchForLibraryApplet.
##  @param s SwkbdInline object.
##  @param cb \ref SwkbdMovedCursorV2Cb Callback
##

proc swkbdInlineSetMovedTabCallback*(s: ptr SwkbdInline; cb: SwkbdMovedTabCb) {.cdecl,
    importc: "swkbdInlineSetMovedTabCallback".}
## *
##  @brief Sets the MovedTab callback, used by \ref swkbdInlineUpdate. The default is NULL for none.
##  @param s SwkbdInline object.
##  @param cb \ref SwkbdMovedTabCb Callback
##

proc swkbdInlineSetDecidedEnterCallback*(s: ptr SwkbdInline; cb: SwkbdDecidedEnterCb) {.
    cdecl, importc: "swkbdInlineSetDecidedEnterCallback".}
## *
##  @brief Sets the DecidedEnter callback, used by \ref swkbdInlineUpdate. The default is NULL for none.
##  @param s SwkbdInline object.
##  @param cb \ref SwkbdDecidedEnterCb Callback
##

proc swkbdInlineSetReleasedUserWordInfoCallback*(s: ptr SwkbdInline; cb: VoidFn) {.
    cdecl, importc: "swkbdInlineSetReleasedUserWordInfoCallback".}
## *
##  @brief Sets the ReleasedUserWordInfo callback, used by \ref swkbdInlineUpdate. The default is NULL for none.
##  @param s SwkbdInline object.
##  @param cb Callback
##

proc swkbdInlineAppear*(s: ptr SwkbdInline; arg: ptr SwkbdAppearArg) {.cdecl,
    importc: "swkbdInlineAppear".}
## *
##  @brief Appear the kbd and set \ref SwkbdAppearArg.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @note Wrapper for \ref swkbdInlineAppearEx, with trigger=0.
##  @param s SwkbdInline object.
##  @param arg Input SwkbdAppearArg.
##

proc swkbdInlineAppearEx*(s: ptr SwkbdInline; arg: ptr SwkbdAppearArg; trigger: U8) {.
    cdecl, importc: "swkbdInlineAppearEx".}
## *
##  @brief Appear the kbd and set \ref SwkbdAppearArg.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param arg Input SwkbdAppearArg.
##  @param trigger Trigger, default is 0. Requires [6.0.0+], on eariler versions this will always use value 0 internally.
##

proc swkbdInlineDisappear*(s: ptr SwkbdInline) {.cdecl,
    importc: "swkbdInlineDisappear".}
## *
##  @brief Disappear the kbd.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##

proc swkbdInlineMakeAppearArg*(arg: ptr SwkbdAppearArg; `type`: SwkbdType) {.cdecl,
    importc: "swkbdInlineMakeAppearArg".}
## *
##  @brief Creates a \ref SwkbdAppearArg which can then be passed to \ref swkbdInlineAppear. arg is initialized with the defaults, with type being set to the input type.
##  @param arg Output \ref SwkbdAppearArg.
##  @param type \ref SwkbdType type
##

proc swkbdInlineAppearArgSetOkButtonText*(arg: ptr SwkbdAppearArg; str: cstring) {.
    cdecl, importc: "swkbdInlineAppearArgSetOkButtonText".}
## *
##  @brief Sets okButtonText for the specified SwkbdAppearArg, which was previously initialized with \ref swkbdInlineMakeAppearArg.
##  @param arg \ref SwkbdAppearArg
##  @param str Input UTF-8 string for the Ok button text, this can be empty/NULL to use the default.
##

proc swkbdInlineAppearArgSetLeftButtonText*(arg: ptr SwkbdAppearArg; str: cstring) {.
    cdecl, importc: "swkbdInlineAppearArgSetLeftButtonText".}
## *
##  @brief Sets the LeftButtonText, for \ref SwkbdType_NumPad. The default is "". Equivalent to \ref swkbdConfigSetLeftOptionalSymbolKey.
##  @param arg \ref SwkbdAppearArg, previously initialized by \ref swkbdInlineMakeAppearArg.
##  @param str UTF-8 input string.
##

proc swkbdInlineAppearArgSetRightButtonText*(arg: ptr SwkbdAppearArg; str: cstring) {.
    cdecl, importc: "swkbdInlineAppearArgSetRightButtonText".}
## *
##  @brief Sets the RightButtonText, for \ref SwkbdType_NumPad. The default is "". Equivalent to \ref swkbdConfigSetRightOptionalSymbolKey.
##  @param arg \ref SwkbdAppearArg, previously initialized by \ref swkbdInlineMakeAppearArg.
##  @param str UTF-8 input string.
##

proc swkbdInlineAppearArgSetStringLenMax*(arg: ptr SwkbdAppearArg; stringLenMax: S32) {.
    inline, cdecl.} =
  ## *
  ##  @brief Sets the stringLenMax for the specified SwkbdAppearArg, which was previously initialized with \ref swkbdInlineMakeAppearArg.
  ##  @param arg \ref SwkbdAppearArg
  ##  @param stringLenMax Max string length
  ##

  arg.stringLenMax = stringLenMax

proc swkbdInlineAppearArgSetStringLenMin*(arg: ptr SwkbdAppearArg; stringLenMin: S32) {.
    inline, cdecl.} =
  ## *
  ##  @brief Sets the stringLenMin for the specified SwkbdAppearArg, which was previously initialized with \ref swkbdInlineMakeAppearArg.
  ##  @param arg \ref SwkbdAppearArg
  ##  @param stringLenMin Min string length
  ##

  arg.stringLenMin = stringLenMin

proc swkbdInlineSetVolume*(s: ptr SwkbdInline; volume: cfloat) {.cdecl,
    importc: "swkbdInlineSetVolume".}
## *
##  @brief Sets the audio volume.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param volume Volume
##

proc swkbdInlineSetInputText*(s: ptr SwkbdInline; str: cstring) {.cdecl,
    importc: "swkbdInlineSetInputText".}
## *
##  @brief Sets the current input text string. Overrides the entire user input string if the user previously entered any text.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @note This will not affect the cursor position, see \ref swkbdInlineSetCursorPos for that.
##  @param s SwkbdInline object.
##  @param str UTF-8 input string.
##

proc swkbdInlineSetCursorPos*(s: ptr SwkbdInline; pos: S32) {.cdecl,
    importc: "swkbdInlineSetCursorPos".}
## *
##  @brief Sets the cursor character position in the string.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param pos Position
##

proc swkbdInlineSetUserWordInfo*(s: ptr SwkbdInline; input: ptr SwkbdDictWord;
                                entries: S32): Result {.cdecl,
    importc: "swkbdInlineSetUserWordInfo".}
## *
##  @brief Sets the UserWordInfo.
##  @note Not available when \ref SwkbdState is above ::SwkbdState_Initialized. Can't be used if this was already used previously.
##  @note The specified buffer must not be used after this, until \ref swkbdInlineClose is used.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards.
##  @note If input==NULL or total_entries==0, this will just call \ref swkbdInlineUnsetUserWordInfo internally.
##  @param s SwkbdInline object.
##  @param input Input data.
##  @param entries Total entries in the buffer.
##

proc swkbdInlineUnsetUserWordInfo*(s: ptr SwkbdInline): Result {.cdecl,
    importc: "swkbdInlineUnsetUserWordInfo".}
## *
##  @brief Request UnsetUserWordInfo.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @note Not available when \ref SwkbdState is above ::SwkbdState_Initialized.
##  @param s SwkbdInline object.
##

proc swkbdInlineSetUtf8Mode*(s: ptr SwkbdInline; flag: bool) {.cdecl,
    importc: "swkbdInlineSetUtf8Mode".}
## *
##  @brief Sets the utf8Mode.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @note Automatically used internally by \ref swkbdInlineCreate.
##  @param s SwkbdInline object.
##  @param flag Flag
##

proc swkbdInlineSetCustomizeDic*(s: ptr SwkbdInline; buffer: pointer; size: csize_t;
                                info: ptr SwkbdCustomizeDicInfo): Result {.cdecl,
    importc: "swkbdInlineSetCustomizeDic".}
## *
##  @brief Sets the CustomizeDic.
##  @note Not available when \ref SwkbdState is above ::SwkbdState_Initialized. Can't be used if this or \ref swkbdInlineSetCustomizedDictionaries was already used previously.
##  @note The specified buffer must not be used after this, until \ref swkbdInlineClose is used. However, it will also become available once \ref swkbdInlineUpdate handles SwkbdReplyType_UnsetCustomizeDic internally.
##  @param s SwkbdInline object.
##  @param buffer 0x1000-byte aligned buffer.
##  @param size 0x1000-byte aligned buffer size.
##  @param info Input \ref SwkbdCustomizeDicInfo
##

proc swkbdInlineUnsetCustomizeDic*(s: ptr SwkbdInline) {.cdecl,
    importc: "swkbdInlineUnsetCustomizeDic".}
## *
##  @brief Request UnsetCustomizeDic.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @note Not available when \ref SwkbdState is above ::SwkbdState_Initialized.
##  @param s SwkbdInline object.
##

proc swkbdInlineSetCustomizedDictionaries*(s: ptr SwkbdInline;
    dic: ptr SwkbdCustomizedDictionarySet): Result {.cdecl,
    importc: "swkbdInlineSetCustomizedDictionaries".}
## *
##  @brief Sets the CustomizedDictionaries.
##  @note Not available when \ref SwkbdState is above ::SwkbdState_Initialized. Can't be used if this or \ref swkbdInlineSetCustomizeDic was already used previously.
##  @note The specified buffer in dic must not be used after this, until \ref swkbdInlineClose is used. However, it will also become available once \ref swkbdInlineUpdate handles SwkbdReplyType_UnsetCustomizedDictionaries internally.
##  @note Only available on [6.0.0+].
##  @param s SwkbdInline object.
##  @param dic Input \ref SwkbdCustomizedDictionarySet
##

proc swkbdInlineUnsetCustomizedDictionaries*(s: ptr SwkbdInline): Result {.cdecl,
    importc: "swkbdInlineUnsetCustomizedDictionaries".}
## *
##  @brief Request UnsetCustomizedDictionaries.
##  @note Not available when \ref SwkbdState is above ::SwkbdState_Initialized.
##  @note Only available on [6.0.0+].
##  @param s SwkbdInline object.
##

proc swkbdInlineSetInputModeFadeType*(s: ptr SwkbdInline; `type`: U8) {.cdecl,
    importc: "swkbdInlineSetInputModeFadeType".}
## *
##  @brief Sets InputModeFadeType.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param type Type
##

proc swkbdInlineSetAlphaEnabledInInputMode*(s: ptr SwkbdInline; flag: bool) {.cdecl,
    importc: "swkbdInlineSetAlphaEnabledInInputMode".}
## *
##  @brief Sets AlphaEnabledInInputMode.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param flag Flag
##

proc swkbdInlineSetKeytopBgAlpha*(s: ptr SwkbdInline; alpha: cfloat) {.cdecl,
    importc: "swkbdInlineSetKeytopBgAlpha".}
## *
##  @brief Sets KeytopBgAlpha.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param alpha Alpha, clamped to range 0.0f..1.0f.
##

proc swkbdInlineSetFooterBgAlpha*(s: ptr SwkbdInline; alpha: cfloat) {.cdecl,
    importc: "swkbdInlineSetFooterBgAlpha".}
## *
##  @brief Sets FooterBgAlpha.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param alpha Alpha, clamped to range 0.0f..1.0f.
##

proc swkbdInlineSetKeytopScale*(s: ptr SwkbdInline; scale: cfloat) {.cdecl,
    importc: "swkbdInlineSetKeytopScale".}
## *
##  @brief Sets gfx scaling. Configures KeytopScale* and BalloonScale based on the input value.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @note The BalloonScale is not updated when \ref SwkbdState is above ::SwkbdState_Initialized.
##  @param s SwkbdInline object.
##  @param scale Scale
##

proc swkbdInlineSetKeytopTranslate*(s: ptr SwkbdInline; x: cfloat; y: cfloat) {.cdecl,
    importc: "swkbdInlineSetKeytopTranslate".}
## *
##  @brief Sets gfx translation for the displayed swkbd image position.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param x X
##  @param y Y
##

proc swkbdInlineSetKeytopAsFloating*(s: ptr SwkbdInline; flag: bool) {.cdecl,
    importc: "swkbdInlineSetKeytopAsFloating".}
## *
##  @brief Sets KeytopAsFloating.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @note Not available when \ref SwkbdState is above ::SwkbdState_Initialized.
##  @param s SwkbdInline object.
##  @param flag Flag
##

proc swkbdInlineSetFooterScalable*(s: ptr SwkbdInline; flag: bool) {.cdecl,
    importc: "swkbdInlineSetFooterScalable".}
## *
##  @brief Sets FooterScalable.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param flag Flag
##

proc swkbdInlineSetTouchFlag*(s: ptr SwkbdInline; flag: bool) {.cdecl,
    importc: "swkbdInlineSetTouchFlag".}
## *
##  @brief Sets whether touch is enabled. The default is enabled.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param flag Flag
##

proc swkbdInlineSetHardwareKeyboardFlag*(s: ptr SwkbdInline; flag: bool) {.cdecl,
    importc: "swkbdInlineSetHardwareKeyboardFlag".}
## *
##  @brief Sets whether Hardware-keyboard is enabled. The default is enabled.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @param s SwkbdInline object.
##  @param flag Flag
##

proc swkbdInlineSetDirectionalButtonAssignFlag*(s: ptr SwkbdInline; flag: bool) {.
    cdecl, importc: "swkbdInlineSetDirectionalButtonAssignFlag".}
## *
##  @brief Sets whether DirectionalButtonAssign is enabled. The default is disabled.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @note Only available on [4.0.0+].
##  @param s SwkbdInline object.
##  @param flag Flag
##

proc swkbdInlineSetSeGroup*(s: ptr SwkbdInline; seGroup: U8; flag: bool) {.cdecl,
    importc: "swkbdInlineSetSeGroup".}
## *
##  @brief Sets whether the specified SeGroup (sound effect) is enabled. The default is enabled.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect. If called again with a different seGroup, \ref swkbdInlineUpdate must be called prior to calling this again.
##  @note Only available on [5.0.0+].
##  @param s SwkbdInline object.
##  @param seGroup SeGroup
##  @param flag Flag
##

proc swkbdInlineSetBackspaceFlag*(s: ptr SwkbdInline; flag: bool) {.cdecl,
    importc: "swkbdInlineSetBackspaceFlag".}
## *
##  @brief Sets whether the backspace button is enabled. The default is enabled.
##  @note \ref swkbdInlineUpdate must be called at some point afterwards for this to take affect.
##  @note Only available on [5.0.0+].
##  @param s SwkbdInline object.
##  @param flag Flag
##

