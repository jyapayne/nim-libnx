## *
##  @file mutex.h
##  @brief Mutex synchronization primitive.
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types

## / Mutex datatype, defined in newlib.

type
  Mutex* = distinct uint32
  Lock* = distinct uint32

## / Recursive mutex datatype, defined in newlib.

type
  RMutex* = object
    lock*: Lock
    threadTag*: uint32
    counter*: uint32

## *
##  @brief Initializes a mutex.
##  @param m Mutex object.
##  @note A mutex can also be statically initialized by assigning 0 to it.
##

proc mutexInit*(m: ptr Mutex) {.inline, cdecl.} =
  m[] = INVALID_HANDLE.Mutex

## *
##  @brief Locks a mutex.
##  @param m Mutex object.
##

proc mutexLock*(m: ptr Mutex) {.cdecl, importc: "mutexLock".}
## *
##  @brief Attempts to lock a mutex without waiting.
##  @param m Mutex object.
##  @return 1 if the mutex has been acquired successfully, and 0 on contention.
##

proc mutexTryLock*(m: ptr Mutex): bool {.cdecl, importc: "mutexTryLock".}
## *
##  @brief Unlocks a mutex.
##  @param m Mutex object.
##

proc mutexUnlock*(m: ptr Mutex) {.cdecl, importc: "mutexUnlock".}
## *
##  @brief Gets whether the current thread owns the mutex.
##  @param m Mutex object.
##  @return 1 if the mutex is locked by the current thread, and 0 otherwise.
##

proc mutexIsLockedByCurrentThread*(m: ptr Mutex): bool {.cdecl,
    importc: "mutexIsLockedByCurrentThread".}
## *
##  @brief Initializes a recursive mutex.
##  @param m Recursive mutex object.
##  @note A recursive mutex can also be statically initialized by assigning {0,0,0} to it.
##

proc rmutexInit*(m: ptr RMutex) {.inline, cdecl.} =
  m.lock = 0.Lock
  m.threadTag = 0
  m.counter = 0

## *
##  @brief Locks a recursive mutex.
##  @param m Recursive mutex object.
##

proc rmutexLock*(m: ptr RMutex) {.cdecl, importc: "rmutexLock".}
## *
##  @brief Attempts to lock a recursive mutex without waiting.
##  @param m Recursive mutex object.
##  @return 1 if the mutex has been acquired successfully, and 0 on contention.
##

proc rmutexTryLock*(m: ptr RMutex): bool {.cdecl, importc: "rmutexTryLock".}
## *
##  @brief Unlocks a recursive mutex.
##  @param m Recursive mutex object.
##

proc rmutexUnlock*(m: ptr RMutex) {.cdecl, importc: "rmutexUnlock".}
