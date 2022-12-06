## *
##  @file barrier.h
##  @brief Multi-threading Barrier
##  @author tatehaga
##  @copyright libnx Authors
##

import
  mutex, condvar
import ../types

## / Barrier structure.

type
  Barrier* {.bycopy.} = object
    count*: U64                ## /< Number of threads to reach the barrier.
    total*: U64                ## /< Number of threads to wait on.
    mutex*: Mutex
    condvar*: CondVar


## *
##  @brief Initializes a barrier and the number of threads to wait on.
##  @param b Barrier object.
##  @param thread_count Initial value for the number of threads the barrier must wait for.
##

proc barrierInit*(b: ptr Barrier; threadCount: U64) {.cdecl, importc: "barrierInit".}
## *
##  @brief Forces threads to wait until all threads have called barrierWait.
##  @param b Barrier object.
##

proc barrierWait*(b: ptr Barrier) {.cdecl, importc: "barrierWait".}
