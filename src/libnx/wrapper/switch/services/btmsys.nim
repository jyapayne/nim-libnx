## *
##  @file btmsys.h
##  @brief btm:sys (btm system) service IPC wrapper.
##  @author yellows8
##

import
  ../types, ../kernel/event, ../sf/service

## / Initialize btm:sys.

proc btmsysInitialize*(): Result {.cdecl, importc: "btmsysInitialize".}
## / Exit btm:sys.

proc btmsysExit*() {.cdecl, importc: "btmsysExit".}
## / Gets the Service object for the actual btm:sys service session. This object must be closed by the user once finished using cmds with this.

proc btmsysGetServiceSession*(srvOut: ptr Service): Result {.cdecl,
    importc: "btmsysGetServiceSession".}
## / Gets the Service object for IBtmSystemCore.

proc btmsysGetServiceSessionIBtmSystemCore*(): ptr Service {.cdecl,
    importc: "btmsysGetServiceSession_IBtmSystemCore".}
## *
##  @brief StartGamepadPairing
##

proc btmsysStartGamepadPairing*(): Result {.cdecl,
    importc: "btmsysStartGamepadPairing".}
## *
##  @brief CancelGamepadPairing
##

proc btmsysCancelGamepadPairing*(): Result {.cdecl,
    importc: "btmsysCancelGamepadPairing".}
## *
##  @brief ClearGamepadPairingDatabase
##

proc btmsysClearGamepadPairingDatabase*(): Result {.cdecl,
    importc: "btmsysClearGamepadPairingDatabase".}
## *
##  @brief GetPairedGamepadCount
##  @param[out] out Output count.
##

proc btmsysGetPairedGamepadCount*(`out`: ptr U8): Result {.cdecl,
    importc: "btmsysGetPairedGamepadCount".}
## *
##  @brief EnableRadio
##

proc btmsysEnableRadio*(): Result {.cdecl, importc: "btmsysEnableRadio".}
## *
##  @brief DisableRadio
##

proc btmsysDisableRadio*(): Result {.cdecl, importc: "btmsysDisableRadio".}
## *
##  @brief GetRadioOnOff
##  @param[out] out Output flag.
##

proc btmsysGetRadioOnOff*(`out`: ptr bool): Result {.cdecl,
    importc: "btmsysGetRadioOnOff".}
## *
##  @brief AcquireRadioEvent
##  @note Only available on [3.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmsysAcquireRadioEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmsysAcquireRadioEvent".}
## *
##  @brief AcquireGamepadPairingEvent
##  @note Only available on [3.0.0+].
##  @note The Event must be closed by the user once finished with it.
##  @param[out] out_event Output Event with autoclear=true.
##

proc btmsysAcquireGamepadPairingEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "btmsysAcquireGamepadPairingEvent".}
## *
##  @brief IsGamepadPairingStarted
##  @note Only available on [3.0.0+].
##  @param[out] out Output flag.
##

proc btmsysIsGamepadPairingStarted*(`out`: ptr bool): Result {.cdecl,
    importc: "btmsysIsGamepadPairingStarted".}