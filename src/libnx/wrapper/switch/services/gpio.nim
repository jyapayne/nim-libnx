## *
##  @file gpio.h
##  @brief GPIO service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../sf/service

type
  GpioPadName* = enum
    GpioPadNameAudioCodec = 1, GpioPadNameButtonVolUp = 25,
    GpioPadNameButtonVolDown = 26, GpioPadNameSdCd = 56
  GpioPadSession* {.bycopy.} = object
    s*: Service

  GpioDirection* = enum
    GpioDirectionInput = 0, GpioDirectionOutput = 1
  GpioValue* = enum
    GpioValueLow = 0, GpioValueHigh = 1
  GpioInterruptMode* = enum
    GpioInterruptModeLowLevel = 0, GpioInterruptModeHighLevel = 1,
    GpioInterruptModeRisingEdge = 2, GpioInterruptModeFallingEdge = 3,
    GpioInterruptModeAnyEdge = 4
  GpioInterruptStatus* = enum
    GpioInterruptStatusInactive = 0, GpioInterruptStatusActive = 1






## / Initialize gpio.

proc gpioInitialize*(): Result {.cdecl, importc: "gpioInitialize".}
## / Exit gpio.

proc gpioExit*() {.cdecl, importc: "gpioExit".}
## / Gets the Service object for the actual gpio service session.

proc gpioGetServiceSession*(): ptr Service {.cdecl, importc: "gpioGetServiceSession".}
proc gpioOpenSession*(`out`: ptr GpioPadSession; name: GpioPadName): Result {.cdecl,
    importc: "gpioOpenSession".}
proc gpioOpenSession2*(`out`: ptr GpioPadSession; deviceCode: U32; accessMode: U32): Result {.
    cdecl, importc: "gpioOpenSession2".}
proc gpioIsWakeEventActive*(`out`: ptr bool; name: GpioPadName): Result {.cdecl,
    importc: "gpioIsWakeEventActive".}
proc gpioIsWakeEventActive2*(`out`: ptr bool; deviceCode: U32): Result {.cdecl,
    importc: "gpioIsWakeEventActive2".}
proc gpioPadSetDirection*(p: ptr GpioPadSession; dir: GpioDirection): Result {.cdecl,
    importc: "gpioPadSetDirection".}
proc gpioPadGetDirection*(p: ptr GpioPadSession; `out`: ptr GpioDirection): Result {.
    cdecl, importc: "gpioPadGetDirection".}
proc gpioPadSetInterruptMode*(p: ptr GpioPadSession; mode: GpioInterruptMode): Result {.
    cdecl, importc: "gpioPadSetInterruptMode".}
proc gpioPadGetInterruptMode*(p: ptr GpioPadSession; `out`: ptr GpioInterruptMode): Result {.
    cdecl, importc: "gpioPadGetInterruptMode".}
proc gpioPadSetInterruptEnable*(p: ptr GpioPadSession; en: bool): Result {.cdecl,
    importc: "gpioPadSetInterruptEnable".}
proc gpioPadGetInterruptEnable*(p: ptr GpioPadSession; `out`: ptr bool): Result {.cdecl,
    importc: "gpioPadGetInterruptEnable".}
proc gpioPadGetInterruptStatus*(p: ptr GpioPadSession;
                               `out`: ptr GpioInterruptStatus): Result {.cdecl,
    importc: "gpioPadGetInterruptStatus".}
proc gpioPadClearInterruptStatus*(p: ptr GpioPadSession): Result {.cdecl,
    importc: "gpioPadClearInterruptStatus".}
proc gpioPadSetValue*(p: ptr GpioPadSession; val: GpioValue): Result {.cdecl,
    importc: "gpioPadSetValue".}
proc gpioPadGetValue*(p: ptr GpioPadSession; `out`: ptr GpioValue): Result {.cdecl,
    importc: "gpioPadGetValue".}
proc gpioPadBindInterrupt*(p: ptr GpioPadSession; `out`: ptr Event): Result {.cdecl,
    importc: "gpioPadBindInterrupt".}
proc gpioPadUnbindInterrupt*(p: ptr GpioPadSession): Result {.cdecl,
    importc: "gpioPadUnbindInterrupt".}
proc gpioPadSetDebounceEnabled*(p: ptr GpioPadSession; en: bool): Result {.cdecl,
    importc: "gpioPadSetDebounceEnabled".}
proc gpioPadGetDebounceEnabled*(p: ptr GpioPadSession; `out`: ptr bool): Result {.cdecl,
    importc: "gpioPadGetDebounceEnabled".}
proc gpioPadSetDebounceTime*(p: ptr GpioPadSession; ms: S32): Result {.cdecl,
    importc: "gpioPadSetDebounceTime".}
proc gpioPadGetDebounceTime*(p: ptr GpioPadSession; `out`: ptr S32): Result {.cdecl,
    importc: "gpioPadGetDebounceTime".}
proc gpioPadClose*(p: ptr GpioPadSession) {.cdecl, importc: "gpioPadClose".}