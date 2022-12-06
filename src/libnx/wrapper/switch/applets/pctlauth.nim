## *
##  @file pctlauth.h
##  @brief Wrapper for using the Parental Controls authentication LibraryApplet. This applet is used by qlaunch.
##  @author yellowS8
##  @copyright libnx Authors
##

import
  ../types

## / Type values for PctlAuthArg::type.

type
  PctlAuthType* = enum
    PctlAuthType_Show = 0,      ## /< ShowParentalAuthentication
    PctlAuthType_RegisterPasscode = 1, ## /< RegisterParentalPasscode
    PctlAuthType_ChangePasscode = 2 ## /< ChangeParentalPasscode


## / Input arg storage for the applet.

type
  PctlAuthArg* {.bycopy.} = object
    unk_x0*: U32               ## /< Always set to 0 by the user-process.
    `type`*: PctlAuthType      ## /< \ref PctlAuthType
    arg0*: U8                  ## /< Arg0
    arg1*: U8                  ## /< Arg1
    arg2*: U8                  ## /< Arg2
    pad*: U8                   ## /< Padding

proc pctlauthShow*(flag: bool): Result {.cdecl, importc: "pctlauthShow".}
## *
##  @brief Launches the applet.
##  @note Should not be used if a PIN is not already registered. See \ref pctlIsRestrictionEnabled.
##  @param flag Input flag. false = temporarily disable Parental Controls. true = validate the input PIN.
##

proc pctlauthShowEx*(arg0: U8; arg1: U8; arg2: U8): Result {.cdecl,
    importc: "pctlauthShowEx".}
## *
##  @brief Launches the applet. Only available with [4.0.0+].
##  @param arg0 Value for PctlAuthArg.arg0.
##  @param arg1 Value for PctlAuthArg.arg1.
##  @param arg2 Value for PctlAuthArg.arg2.
##

proc pctlauthShowForConfiguration*(): Result {.cdecl,
    importc: "pctlauthShowForConfiguration".}
## *
##  @brief Just calls: pctlauthShowEx(1, 0, 1). Launches the applet for checking the PIN, used when changing system-settings.
##  @note Should not be used if a PIN is not already registered. See \ref pctlIsRestrictionEnabled.
##

proc pctlauthRegisterPasscode*(): Result {.cdecl,
                                        importc: "pctlauthRegisterPasscode".}
## *
##  @brief Launches the applet for registering the Parental Controls PIN.
##

proc pctlauthChangePasscode*(): Result {.cdecl, importc: "pctlauthChangePasscode".}
## *
##  @brief Launches the applet for changing the Parental Controls PIN.
##  @note Should not be used if a PIN is not already registered. See \ref pctlIsRestrictionEnabled.
##

