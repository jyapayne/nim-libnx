## *
##  @file utimer.h
##  @brief User-mode timer synchronization primitive.
##  @author plutoo
##  @copyright libnx Authors
##

import
  wait, ../types

## / Valid types for a user-mode timer.

type
  TimerType* = enum
    TimerTypeOneShot,         ## /< Timers of this kind fire once and then stop automatically.
    TimerTypeRepeating        ## /< Timers of this kind fire periodically.


## / User-mode timer object.

type
  UTimer* {.bycopy.} = object
    waitable*: Waitable
    `type`* {.bitsize: 8.}: TimerType
    started* {.bitsize: 1.}: bool
    nextTick*: U64
    interval*: U64

proc waiterForUTimer*(t: ptr UTimer): Waiter {.inline, cdecl,
    importc: "waiterForUTimer".} =
  ## / Creates a waiter for a user-mode timer.
  var waitObj: Waiter
  waitObj.`type` = WaiterTypeWaitable
  waitObj.anoWait3.waitable = addr(t.waitable)
  return waitObj

proc utimerCreate*(t: ptr UTimer; interval: U64; `type`: TimerType) {.cdecl,
    importc: "utimerCreate".}
## *
##  @brief Creates a user-mode timer.
##  @param[out] t UTimer object.
##  @param[in] interval Interval (in nanoseconds).
##  @param[in] type Type of timer to create (see \ref TimerType).
##  @note The timer is stopped when it is created. Use \ref utimerStart to start it.
##  @note It is safe to wait on this timer with several threads simultaneously.
##  @note If more than one thread is listening on it, at least one thread will get the signal. No other guarantees.
##  @note For a repeating timer: If the timer triggers twice before you wait on it, you will only get one signal.
##

proc utimerStart*(t: ptr UTimer) {.cdecl, importc: "utimerStart".}
## *
##  @brief Starts the timer.
##  @param[in] t UTimer object.
##

proc utimerStop*(t: ptr UTimer) {.cdecl, importc: "utimerStop".}
## *
##  @brief Stops the timer.
##  @param[in] t UTimer object.
##

