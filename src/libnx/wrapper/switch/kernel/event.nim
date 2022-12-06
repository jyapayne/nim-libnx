## *
##  @file event.h
##  @brief Kernel-mode event synchronization primitive.
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types, ../result, wait

## / Kernel-mode event structure.

type
  Event* {.bycopy.} = object
    revent*: Handle            ## /< Read-only event handle
    wevent*: Handle            ## /< Write-only event handle
    autoclear*: bool           ## /< Autoclear flag

proc waiterForEvent*(t: ptr Event): Waiter {.inline, cdecl, importc: "waiterForEvent".} =
  ## / Creates a \ref Waiter for a kernel-mode event.
  var waitObj: Waiter
  waitObj.`type` = if t.autoclear: WaiterTypeHandleWithClear else: WaiterTypeHandle
  waitObj.anoWait3.handle = t.revent
  return waitObj

proc eventCreate*(t: ptr Event; autoclear: bool): Result {.cdecl, importc: "eventCreate".}
## *
##  @brief Creates a kernel-mode event.
##  @param[out] t Pointer to \ref Event structure.
##  @param[in] autoclear Autoclear flag.
##  @return Result code.
##  @warning This is a privileged operation; in normal circumstances applications shouldn't use this function.
##

proc eventLoadRemote*(t: ptr Event; handle: Handle; autoclear: bool) {.cdecl,
    importc: "eventLoadRemote".}
## *
##  @brief Loads a kernel-mode event obtained from IPC.
##  @param[out] t Pointer to \ref Event structure.
##  @param[in] handle Read-only event handle.
##  @param[in] autoclear Autoclear flag.
##

proc eventClose*(t: ptr Event) {.cdecl, importc: "eventClose".}
## *
##  @brief Closes a kernel-mode event.
##  @param[in] t Pointer to \ref Event structure.
##

proc eventActive*(t: ptr Event): bool {.inline, cdecl, importc: "eventActive".} =
  ## *
  ##  @brief Returns whether an \ref Event is initialized.
  ##  @param[in] t Pointer to \ref Event structure.
  ##  @return Initialization status.
  ##
  return t.revent != Invalid_Handle

proc eventWait*(t: ptr Event; timeout: U64): Result {.cdecl, importc: "eventWait".}
## *
##  @brief Waits on a kernel-mode event.
##  @param[in] t Pointer to \ref Event structure.
##  @param[in] timeout Timeout in nanoseconds (pass UINT64_MAX to wait indefinitely).
##  @return Result code.
##

proc eventFire*(t: ptr Event): Result {.cdecl, importc: "eventFire".}
## *
##  @brief Signals a kernel-mode event.
##  @param[in] t Pointer to \ref Event structure.
##  @return Result code.
##  @note This function only works for events initialized with \ref eventCreate, it doesn't work with events initialized with \ref eventLoadRemote.
##  @warning This is a privileged operation; in normal circumstances applications shouldn't use this function.
##

proc eventClear*(t: ptr Event): Result {.cdecl, importc: "eventClear".}
## *
##  @brief Clears a kernel-mode event.
##  @param[in] t Pointer to \ref Event structure.
##  @return Result code.
##  @note This function shouldn't be used on autoclear events.
##

