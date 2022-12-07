## *
##  @file error.h
##  @brief Wrapper for using the error LibraryApplet.
##  @author StuntHacks, yellows8
##  @copyright libnx Authors
##

import
  ../types, ../services/set, ../result

## / Error type for ErrorCommonHeader.type.

type
  ErrorType* = enum
    ErrorTypeNormal = 0,        ## /< Normal
    ErrorTypeSystem = 1,        ## /< System
    ErrorTypeApplication = 2,   ## /< Application
    ErrorTypeEula = 3,          ## /< EULA
    ErrorTypePctl = 4,          ## /< Parental Controls
    ErrorTypeRecord = 5,        ## /< Record
    ErrorTypeSystemUpdateEula = 8 ## /< SystemUpdateEula


## / Stores error-codes which are displayed as XXXX-XXXX, low for the former and desc for the latter.

type
  ErrorCode* {.bycopy.} = object
    low*: U32                  ## /< The module portion of the error, normally this should be set to module + 2000.
    desc*: U32                 ## /< The error description.


## / Error type for ErrorContext.type

type
  ErrorContextType* = enum
    ErrorContextTypeNone = 0,   ## /< None
    ErrorContextTypeHttp = 1,   ## /< Http
    ErrorContextTypeFileSystem = 2, ## /< FileSystem
    ErrorContextTypeWebMediaPlayer = 3, ## /< WebMediaPlayer
    ErrorContextTypeLocalContentShare = 4 ## /< LocalContentShare


## / Error context.

type
  ErrorContext* {.bycopy.} = object
    `type`*: U8                ## /< Type, see \ref ErrorContextType.
    pad*: array[7, U8]          ## /< Padding
    data*: array[0x1f4, U8]     ## /< Data
    res*: Result               ## /< Result


## / Common header for the start of the arg storage.

type
  ErrorCommonHeader* {.bycopy.} = object
    `type`*: U8                ## /< Type, see \ref ErrorType.
    jumpFlag*: U8              ## /< When clear, this indicates WithoutJump.
    unkX2*: array[3, U8]        ## /< Unknown
    contextFlag*: U8           ## /< When set with ::ErrorType_Normal, indicates that an additional storage is pushed for \ref ErrorResultBacktrace. [4.0.0+] Otherwise, when set indicates that an additional storage is pushed for \ref ErrorContext.
    resultFlag*: U8            ## /< ErrorCommonArg: When clear, errorCode is used, otherwise the applet generates the error-code from res.
    contextFlag2*: U8          ## /< Similar to contextFlag except for ErrorCommonArg, indicating \ref ErrorContext is used.


## / Common error arg data.

type
  ErrorCommonArg* {.bycopy.} = object
    hdr*: ErrorCommonHeader    ## /< Common header.
    errorCode*: ErrorCode      ## /< \ref ErrorCode
    res*: Result               ## /< Result


## / Error arg data for certain errors with module PCTL.

type
  ErrorPctlArg* {.bycopy.} = object
    hdr*: ErrorCommonHeader    ## /< Common header.
    res*: Result               ## /< Result


## / ResultBacktrace

type
  ErrorResultBacktrace* {.bycopy.} = object
    count*: S32                ## /< Total entries in the backtrace array.
    backtrace*: array[0x20, Result] ## /< Result backtrace.


## / Error arg data for EULA.

type
  ErrorEulaArg* {.bycopy.} = object
    hdr*: ErrorCommonHeader    ## /< Common header.
    regionCode*: SetRegion     ## /< \ref SetRegion


## / Additional input storage data for \ref errorSystemUpdateEulaShow.

type
  ErrorEulaData* {.bycopy.} = object
    data*: array[0x20000, U8]   ## /< data


## / Error arg data for Record.

type
  ErrorRecordArg* {.bycopy.} = object
    hdr*: ErrorCommonHeader    ## /< Common header.
    errorCode*: ErrorCode      ## /< \ref ErrorCode
    timestamp*: U64            ## /< POSIX timestamp.


## / SystemErrorArg

type
  ErrorSystemArg* {.bycopy.} = object
    hdr*: ErrorCommonHeader    ## /< Common header.
    errorCode*: ErrorCode      ## /< \ref ErrorCode
    languageCode*: U64         ## /< See set.h.
    dialogMessage*: array[0x800, char] ## /< UTF-8 Dialog message.
    fullscreenMessage*: array[0x800, char] ## /< UTF-8 Fullscreen message (displayed when the user clicks on "Details").


## / Error system config.

type
  ErrorSystemConfig* {.bycopy.} = object
    arg*: ErrorSystemArg       ## /< Arg data.
    ctx*: ErrorContext         ## /< Optional error context.


## / ApplicationErrorArg

type
  ErrorApplicationArg* {.bycopy.} = object
    hdr*: ErrorCommonHeader    ## /< Common header.
    errorNumber*: U32          ## /< Raw decimal error number which is displayed in the dialog.
    languageCode*: U64         ## /< See set.h.
    dialogMessage*: array[0x800, char] ## /< UTF-8 Dialog message.
    fullscreenMessage*: array[0x800, char] ## /< UTF-8 Fullscreen message (displayed when the user clicks on "Details").


## / Error application config.

type
  ErrorApplicationConfig* {.bycopy.} = object
    arg*: ErrorApplicationArg  ## /< Arg data.



proc errorCodeCreate*(low: U32; desc: U32): ErrorCode {.inline, cdecl.} =
  ## *
  ##  @brief Creates an \ref ErrorCode.
  ##  @param low  The module portion of the error, normally this should be set to module + 2000.
  ##  @param desc The error description.
  ##
  return ErrorCode(low: low, desc: desc)


proc errorCodeCreateResult*(res: Result): ErrorCode {.inline, cdecl.} =
  ## *
  ##  @brief Creates an \ref ErrorCode with the input Result. Wrapper for \ref errorCodeCreate.
  ##  @param res Input Result.
  ##
  return errorCodeCreate(2000 + r_Module(res), r_Description(res))


proc errorCodeCreateInvalid*(): ErrorCode {.inline, cdecl.} =
  ## *
  ##  @brief Creates an invalid \ref ErrorCode.
  ##
  return ErrorCode(low: 0, desc: 0)


proc errorCodeIsValid*(errorCode: ErrorCode): bool {.inline, cdecl.} =
  ## *
  ##  @brief Checks whether the input ErrorCode is valid.
  ##  @param errorCode \ref ErrorCode
  ##
  return errorCode.low != 0

proc errorResultShow*(res: Result; jumpFlag: bool; ctx: ptr ErrorContext): Result {.
    cdecl, importc: "errorResultShow".}
## *
##  @brief Launches the applet for displaying the specified Result.
##  @param res Result
##  @param jumpFlag Jump flag, normally this is true.
##  @param ctx Optional \ref ErrorContext, can be NULL. Unused when jumpFlag=false. Ignored on pre-4.0.0, since it's only available for [4.0.0+].
##  @note Sets the following fields: jumpFlag and contextFlag2. Uses ::ErrorType_Normal normally.
##  @note For module=PCTL errors with desc 100-119 this sets uses ::ErrorType_Pctl, in which case the applet will display the following special dialog: "This software is restricted by Parental Controls".
##  @note If the input Result is 0xC8A2, the applet will display a special dialog regarding the current application requiring a software update, with buttons "Later" and "Restart".
##  @note [3.0.0+] If the input Result is 0xCAA2, the applet will display a special dialog related to DLC version.
##  @warning This applet creates an error report that is logged in the system, when not handling the above special dialogs. Proceed at your own risk!
##
proc errorCodeShow*(errorCode: ErrorCode; jumpFlag: bool; ctx: ptr ErrorContext): Result {.
    cdecl, importc: "errorCodeShow".}
## *
##  @brief Launches the applet for displaying the specified ErrorCode.
##  @param errorCode \ref ErrorCode
##  @param jumpFlag Jump flag, normally this is true.
##  @param ctx Optional \ref ErrorContext, can be NULL. Unused when jumpFlag=false. Ignored on pre-4.0.0, since it's only available for [4.0.0+].
##  @note Sets the following fields: jumpFlag and contextFlag2. resultFlag=1. Uses ::ErrorType_Normal.
##  @warning This applet creates an error report that is logged in the system. Proceed at your own risk!
##
proc errorResultBacktraceCreate*(backtrace: ptr ErrorResultBacktrace; count: S32;
                                entries: ptr Result): Result {.cdecl,
    importc: "errorResultBacktraceCreate".}
## *
##  @brief Creates an ErrorResultBacktrace struct.
##  @param backtrace \ref ErrorResultBacktrace struct.
##  @param count Total number of entries.
##  @param entries Input array of Result.
##
proc errorResultBacktraceShow*(res: Result; backtrace: ptr ErrorResultBacktrace): Result {.
    cdecl, importc: "errorResultBacktraceShow".}
## *
##  @brief Launches the applet for \ref ErrorResultBacktrace.
##  @param backtrace ErrorResultBacktrace struct.
##  @param res Result
##  @note Sets the following fields: jumpFlag=1, contextFlag=1, and uses ::ErrorType_Normal.
##  @warning This applet creates an error report that is logged in the system. Proceed at your own risk!
##
proc errorEulaShow*(regionCode: SetRegion): Result {.cdecl, importc: "errorEulaShow".}
## *
##  @brief Launches the applet for displaying the EULA.
##  @param RegionCode \ref SetRegion
##  @note Sets the following fields: jumpFlag=1, regionCode, and uses ::ErrorType_Eula.
##
proc errorSystemUpdateEulaShow*(regionCode: SetRegion; eula: ptr ErrorEulaData): Result {.
    cdecl, importc: "errorSystemUpdateEulaShow".}
## *
##  @brief Launches the applet for displaying the system-update EULA.
##  @param RegionCode \ref SetRegion
##  @param eula EULA data. Address must be 0x1000-byte aligned.
##  @note Sets the following fields: jumpFlag=1, regionCode, and uses ::ErrorType_SystemUpdateEula.
##
proc errorCodeRecordShow*(errorCode: ErrorCode; timestamp: U64): Result {.cdecl,
    importc: "errorCodeRecordShow".}
## *
##  @brief Launches the applet for displaying an error full-screen, using the specified ErrorCode and timestamp.
##  @param errorCode \ref ErrorCode
##  @param timestamp POSIX timestamp.
##  @note Sets the following fields: jumpFlag=1, errorCode, timestamp, and uses ::ErrorType_Record.
##  @note The applet does not log an error report for this. error*RecordShow is used by qlaunch for displaying previously logged error reports.
##
proc errorResultRecordShow*(res: Result; timestamp: U64): Result {.inline, cdecl.} =
  ## *
  ##  @brief Launches the applet for displaying an error full-screen, using the specified Result and timestamp.
  ##  @param res Result
  ##  @param timestamp POSIX timestamp.
  ##  @note Wrapper for \ref errorCodeRecordShow, see \ref errorCodeRecordShow notes.
  ##
  return errorCodeRecordShow(errorCodeCreateResult(res), timestamp)

proc errorSystemCreate*(c: ptr ErrorSystemConfig; dialogMessage: cstring;
                       fullscreenMessage: cstring): Result {.cdecl,
    importc: "errorSystemCreate".}
## *
##  @brief Creates an ErrorSystemConfig struct.
##  @param c ErrorSystemConfig struct.
##  @param dialog_message UTF-8 dialog message.
##  @param fullscreen_message UTF-8 fullscreen message, displayed when the user clicks on "Details". Optional, can be NULL (which disables displaying Details).
##  @note Sets the following fields: {strings}, and uses ::ErrorType_System. The rest are cleared.
##  @note On pre-5.0.0 this will initialize languageCode by using: setInitialize(), setMakeLanguageCode(SetLanguage_ENUS, ...), and setExit(). This is needed since an empty languageCode wasn't supported until [5.0.0+] (which would also use SetLanguage_ENUS).
##  @warning This applet creates an error report that is logged in the system. Proceed at your own risk!
##
proc errorSystemShow*(c: ptr ErrorSystemConfig): Result {.cdecl,
    importc: "errorSystemShow".}
## *
##  @brief Launches the applet with the specified config.
##  @param c ErrorSystemConfig struct.
##
proc errorSystemSetCode*(c: ptr ErrorSystemConfig; errorCode: ErrorCode) {.inline,
    cdecl.} =
  ## *
  ##  @brief Sets the error code.
  ##  @param c    ErrorSystemConfig struct.
  ##  @param errorCode \ref ErrorCode
  ##
  c.arg.errorCode = errorCode

proc errorSystemSetResult*(c: ptr ErrorSystemConfig; res: Result) {.inline, cdecl.} =
  ## *
  ##  @brief Sets the error code, using the input Result. Wrapper for \ref errorSystemSetCode.
  ##  @param c    ErrorSystemConfig struct.
  ##  @param res  The Result to set.
  ##
  errorSystemSetCode(c, errorCodeCreateResult(res))

proc errorSystemSetLanguageCode*(c: ptr ErrorSystemConfig; languageCode: U64) {.
    inline, cdecl.} =
  ## *
  ##  @brief Sets the LanguageCode.
  ##  @param c            ErrorSystemConfig struct.
  ##  @param LanguageCode LanguageCode, see set.h.
  ##
  c.arg.languageCode = languageCode

proc errorSystemSetContext*(c: ptr ErrorSystemConfig; ctx: ptr ErrorContext) {.cdecl,
    importc: "errorSystemSetContext".}
## *
##  @brief Sets the ErrorContext.
##  @note Only available on [4.0.0+], on older versions this will return without setting the context.
##  @param c   ErrorSystemConfig struct.
##  @param ctx ErrorContext, NULL to clear it.
##
proc errorApplicationCreate*(c: ptr ErrorApplicationConfig; dialogMessage: cstring;
                            fullscreenMessage: cstring): Result {.cdecl,
    importc: "errorApplicationCreate".}
## *
##  @brief Creates an ErrorApplicationConfig struct.
##  @param c ErrorApplicationConfig struct.
##  @param dialog_message UTF-8 dialog message.
##  @param fullscreen_message UTF-8 fullscreen message, displayed when the user clicks on "Details". Optional, can be NULL (which disables displaying Details).
##  @note Sets the following fields: jumpFlag=1, {strings}, and uses ::ErrorType_Application. The rest are cleared.
##  @note On pre-5.0.0 this will initialize languageCode by using: setInitialize(), setMakeLanguageCode(SetLanguage_ENUS, ...), and setExit(). This is needed since an empty languageCode wasn't supported until [5.0.0+] (which would also use SetLanguage_ENUS).
##  @note With [10.0.0+] this must only be used when running under an Application, since otherwise the applet will trigger a fatalerr.
##  @warning This applet creates an error report that is logged in the system. Proceed at your own risk!
##


proc errorApplicationShow*(c: ptr ErrorApplicationConfig): Result {.cdecl,
    importc: "errorApplicationShow".}
## *
##  @brief Launches the applet with the specified config.
##  @param c ErrorApplicationConfig struct.
##

proc errorApplicationSetNumber*(c: ptr ErrorApplicationConfig; errorNumber: U32) {.
    inline, cdecl.} =
  ## *
  ##  @brief Sets the error code number.
  ##  @param c           ErrorApplicationConfig struct.
  ##  @param errorNumber Error code number. Raw decimal error number which is displayed in the dialog.
  ##
  c.arg.errorNumber = errorNumber


proc errorApplicationSetLanguageCode*(c: ptr ErrorApplicationConfig;
                                     languageCode: U64) {.inline, cdecl.} =
  ## *
  ##  @brief Sets the LanguageCode.
  ##  @param c            ErrorApplicationConfig struct.
  ##  @param LanguageCode LanguageCode, see set.h.
  ##
  c.arg.languageCode = languageCode
