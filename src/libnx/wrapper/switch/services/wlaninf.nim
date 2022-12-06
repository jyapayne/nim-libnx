## *
##  @file wlaninf.h
##  @brief WLAN InfraManager service IPC wrapper.
##  @author natinusala, yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / WLAN State.

type
  WlanInfState* = enum
    WlanInfStateNotConnected = 1, ## /< WLAN is disabled or enabled and not connected.
    WlanInfStateConnecting,   ## /< WLAN is connecting.
    WlanInfStateConnected     ## /< WLAN is connected.


## / [1.0.0-14.1.2] Initialize wlan:inf.

proc wlaninfInitialize*(): Result {.cdecl, importc: "wlaninfInitialize".}
## / Exit wlan:inf.

proc wlaninfExit*() {.cdecl, importc: "wlaninfExit".}
## / Gets the Service object for the actual wlan:inf service session.

proc wlaninfGetServiceSession*(): ptr Service {.cdecl,
    importc: "wlaninfGetServiceSession".}
## / Gets \ref WlanInfState.

proc wlaninfGetState*(`out`: ptr WlanInfState): Result {.cdecl,
    importc: "wlaninfGetState".}
## / Value goes from -30 (really good signal) to -90 (barely enough to stay connected)
## / on a logarithmic scale

proc wlaninfGetRSSI*(`out`: ptr S32): Result {.cdecl, importc: "wlaninfGetRSSI".}