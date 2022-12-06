## *
##  @file condvar.h
##  @brief Condition variable synchronization primitive.
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types, ../kernel/svc, ../kernel/mutex

## / Condition variable.

type
  CondVar* = U32

## *
##  @brief Initializes a condition variable.
##  @param[in] c Condition variable object.
##

proc condvarInit*(c: ptr CondVar) {.inline, cdecl, importc: "condvarInit".} =
  c[] = 0

## *
##  @brief Waits on a condition variable with a timeout.
##  @param[in] c Condition variable object.
##  @param[in] m Mutex object to use inside the condition variable.
##  @param[in] timeout Timeout in nanoseconds.
##  @return Result code (0xEA01 on timeout).
##  @remark On function return, the underlying mutex is acquired.
##

proc condvarWaitTimeout*(c: ptr CondVar; m: ptr Mutex; timeout: U64): Result {.cdecl,
    importc: "condvarWaitTimeout".}
## *
##  @brief Waits on a condition variable.
##  @param[in] c Condition variable object.
##  @param[in] m Mutex object to use inside the condition variable.
##  @return Result code.
##  @remark On function return, the underlying mutex is acquired.
##

proc condvarWait*(c: ptr CondVar; m: ptr Mutex): Result {.inline, cdecl,
    importc: "condvarWait".} =
  return condvarWaitTimeout(c, m, uint64.high)

## *
##  @brief Wakes up up to the specified number of threads waiting on a condition variable.
##  @param[in] c Condition variable object.
##  @param[in] num Maximum number of threads to wake up (or -1 to wake them all up).
##  @return Result code.
##

proc condvarWake*(c: ptr CondVar; num: cint): Result {.inline, cdecl,
    importc: "condvarWake".} =
  svcSignalProcessWideKey(c, num)
  return 0

## *
##  @brief Wakes up a single thread waiting on a condition variable.
##  @param[in] c Condition variable object.
##  @return Result code.
##

proc condvarWakeOne*(c: ptr CondVar): Result {.inline, cdecl, importc: "condvarWakeOne".} =
  return condvarWake(c, 1)

## *
##  @brief Wakes up all thread waiting on a condition variable.
##  @param[in] c Condition variable object.
##  @return Result code.
##

proc condvarWakeAll*(c: ptr CondVar): Result {.inline, cdecl, importc: "condvarWakeAll".} =
  return condvarWake(c, -1)
