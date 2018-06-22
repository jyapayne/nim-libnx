import strutils
import ospaths
const headermutex = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/mutex.h"
import libnx/lock
import libnx/types
type
  Mutex* = LOCK_T
  RMutex* = LOCK_RECURSIVE_T

proc mutexInit*(m: ptr Mutex) {.inline, cdecl.} =
  m[] = 0

proc mutexLock*(m: ptr Mutex) {.cdecl, importc: "mutexLock", header: headermutex.}
proc mutexTryLock*(m: ptr Mutex): bool {.cdecl, importc: "mutexTryLock",
                                     header: headermutex.}
proc mutexUnlock*(m: ptr Mutex) {.cdecl, importc: "mutexUnlock", header: headermutex.}
proc rmutexInit*(m: ptr RMutex) {.inline, cdecl.} =
  m.lock = 0
  m.thread_tag = 0
  m.counter = 0

proc rmutexLock*(m: ptr RMutex) {.cdecl, importc: "rmutexLock", header: headermutex.}
proc rmutexTryLock*(m: ptr RMutex): bool {.cdecl, importc: "rmutexTryLock",
                                       header: headermutex.}
proc rmutexUnlock*(m: ptr RMutex) {.cdecl, importc: "rmutexUnlock",
                                header: headermutex.}