## *
##  @file uevent.h
##  @brief User-mode event synchronization primitive.
##  @author plutoo
##  @copyright libnx Authors
##

import
  wait

## / User-mode event object.

type
  UEvent* {.bycopy.} = object
    waitable*: Waitable
    signal*: bool
    autoClear*: bool

proc waiterForUEvent*(e: ptr UEvent): Waiter {.inline, cdecl.} =
  ## / Creates a waiter for a user-mode event.
  var waitObj: Waiter
  waitObj.`type` = WaiterTypeWaitable
  waitObj.anoWait3.waitable = addr(e.waitable)
  return waitObj

proc ueventCreate*(e: ptr UEvent; autoClear: bool) {.cdecl, importc: "ueventCreate".}
## *
##  @brief Creates a user-mode event.
##  @param[out] e UEvent object.
##  @param[in] auto_clear Whether to automatically clear the event.
##  @note It is safe to wait on this event with several threads simultaneously.
##  @note If more than one thread is listening on it, at least one thread will get the signal. No other guarantees.
##

proc ueventClear*(e: ptr UEvent) {.cdecl, importc: "ueventClear".}
## *
##  @brief Clears the event signal.
##  @param[in] e UEvent object.
##

proc ueventSignal*(e: ptr UEvent) {.cdecl, importc: "ueventSignal".}
## *
##  @brief Signals the event.
##  @param[in] e UEvent object.
##

