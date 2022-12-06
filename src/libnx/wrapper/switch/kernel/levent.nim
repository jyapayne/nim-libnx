## *
##  @file levent.h
##  @brief Light event synchronization primitive [4.0.0+]
##  @author fincs
##  @copyright libnx Authors
##

import
  ../types, ../result

## / User-mode light event structure.

type
  LEvent* {.bycopy.} = object
    counter*: U32
    autoclear*: bool

proc leventInit*(le: ptr LEvent; signaled: bool; autoclear: bool) {.inline, cdecl,
    importc: "leventInit".} =
  ## *
  ##  @brief Initializes a user-mode light event.
  ##  @param[out] le Pointer to \ref LEvent structure.
  ##  @param[in] signaled Whether the event starts off in signaled state.
  ##  @param[in] autoclear Autoclear flag.
  ##

  le.counter = if signaled: 2 else: 0
  le.autoclear = autoclear

proc leventWait*(le: ptr LEvent; timeoutNs: U64): bool {.cdecl, importc: "leventWait".}
## *
##  @brief Waits on a user-mode light event.
##  @param[in] le Pointer to \ref LEvent structure.
##  @param[in] timeout_ns Timeout in nanoseconds (pass UINT64_MAX to wait indefinitely).
##  @return true if wait succeeded, false if wait timed out.
##

proc leventTryWait*(le: ptr LEvent): bool {.cdecl, importc: "leventTryWait".}
## *
##  @brief Polls a user-mode light event.
##  @param[in] le Pointer to \ref LEvent structure.
##  @return true if event is signaled, false otherwise.
##

proc leventSignal*(le: ptr LEvent) {.cdecl, importc: "leventSignal".}
## *
##  @brief Signals a user-mode light event.
##  @param[in] le Pointer to \ref LEvent structure.
##

proc leventClear*(le: ptr LEvent) {.cdecl, importc: "leventClear".}
## *
##  @brief Clears a user-mode light event.
##  @param[in] le Pointer to \ref LEvent structure.
##

