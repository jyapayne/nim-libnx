## *
##  @file semaphore.h
##  @brief Thread synchronization based on Mutex.
##  @author SciresM & Kevoot
##  @copyright libnx Authors
##

import
  mutex, condvar, ../types

## / Semaphore structure.

type
  Semaphore* {.bycopy.} = object
    condvar*: CondVar          ## /< Condition variable object.
    mutex*: Mutex              ## /< Mutex object.
    count*: U64                ## /< Internal counter.

proc semaphoreInit*(s: ptr Semaphore; initialCount: U64) {.cdecl,
    importc: "semaphoreInit".}
## *
##  @brief Initializes a semaphore and its internal counter.
##  @param s Semaphore object.
##  @param initial_count initial value for internal counter (typically the # of free resources).
##

proc semaphoreSignal*(s: ptr Semaphore) {.cdecl, importc: "semaphoreSignal".}
## *
##  @brief Increments the Semaphore to allow other threads to continue.
##  @param s Semaphore object.
##

proc semaphoreWait*(s: ptr Semaphore) {.cdecl, importc: "semaphoreWait".}
## *
##  @brief Decrements Semaphore and waits if 0.
##  @param s Semaphore object.
##

proc semaphoreTryWait*(s: ptr Semaphore): bool {.cdecl, importc: "semaphoreTryWait".}
## *
##  @brief Attempts to get lock without waiting.
##  @param s Semaphore object.
##  @return true if no wait and successful lock, false otherwise.
##

