import strutils
import ospaths
const headercondvar = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/condvar.h"
## *
##  @file condvar.h
##  @brief Condition variable synchronization primitive.
##  @author plutoo
##  @copyright libnx Authors
## 

import
  libnx/wrapper/types, libnx/wrapper/mutex

## / Condition variable structure.

type
  CondVar* {.importc: "CondVar", header: headercondvar, bycopy.} = object
    tag* {.importc: "tag".}: uint32
    mutex* {.importc: "mutex".}: ptr Mutex


## *
##  @brief Initializes a condition variable.
##  @param[in] c Condition variable object.
##  @param[in] m Mutex object to use inside the condition variable.
## 

proc condvarInit*(c: ptr CondVar; m: ptr Mutex) {.cdecl, importc: "condvarInit",
    header: headercondvar.}
## *
##  @brief Waits on a condition variable with a timeout.
##  @param[in] c Condition variable object.
##  @param[in] timeout Timeout in nanoseconds.
##  @return Result code (0xEA01 on timeout).
##  @remark On function return, the underlying mutex is acquired.
## 

proc condvarWaitTimeout*(c: ptr CondVar; timeout: uint64): Result {.cdecl,
    importc: "condvarWaitTimeout", header: headercondvar.}
## *
##  @brief Waits on a condition variable.
##  @param[in] c Condition variable object.
##  @return Result code.
##  @remark On function return, the underlying mutex is acquired.
## 

proc condvarWait*(c: ptr CondVar): Result {.inline, cdecl, importc: "condvarWait",
                                       header: headercondvar.}
## *
##  @brief Wakes up up to the specified number of threads waiting on a condition variable.
##  @param[in] c Condition variable object.
##  @param[in] num Maximum number of threads to wake up (or -1 to wake them all up).
##  @return Result code.
## 

proc condvarWake*(c: ptr CondVar; num: cint): Result {.cdecl, importc: "condvarWake",
    header: headercondvar.}
## *
##  @brief Wakes up a single thread waiting on a condition variable.
##  @param[in] c Condition variable object.
##  @return Result code.
## 

proc condvarWakeOne*(c: ptr CondVar): Result {.inline, cdecl,
    importc: "condvarWakeOne", header: headercondvar.}
## *
##  @brief Wakes up all thread waiting on a condition variable.
##  @param[in] c Condition variable object.
##  @return Result code.
## 

proc condvarWakeAll*(c: ptr CondVar): Result {.inline, cdecl,
    importc: "condvarWakeAll", header: headercondvar.}