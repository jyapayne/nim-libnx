## *
##  @file pctl.h
##  @brief Parental Controls service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / Initialize pctl.

proc pctlInitialize*(): Result {.cdecl, importc: "pctlInitialize".}
## / Exit pctl.

proc pctlExit*() {.cdecl, importc: "pctlExit".}
## / Gets the Service object for the actual pctl service session.

proc pctlGetServiceSession*(): ptr Service {.cdecl, importc: "pctlGetServiceSession".}
## / Gets the Service object for IParentalControlService.

proc pctlGetServiceSessionService*(): ptr Service {.cdecl,
    importc: "pctlGetServiceSession_Service".}
## / Confirm whether VrMode is allowed. Only available with [4.0.0+].

proc pctlConfirmStereoVisionPermission*(): Result {.cdecl,
    importc: "pctlConfirmStereoVisionPermission".}
## / Gets whether Parental Controls are enabled.

proc pctlIsRestrictionEnabled*(flag: ptr bool): Result {.cdecl,
    importc: "pctlIsRestrictionEnabled".}
## / Reset the confirmation done by \ref pctlConfirmStereoVisionPermission. Only available with [5.0.0+].

proc pctlResetConfirmedStereoVisionPermission*(): Result {.cdecl,
    importc: "pctlResetConfirmedStereoVisionPermission".}
## / Gets whether VrMode is allowed. Only available with [5.0.0+].

proc pctlIsStereoVisionPermitted*(flag: ptr bool): Result {.cdecl,
    importc: "pctlIsStereoVisionPermitted".}