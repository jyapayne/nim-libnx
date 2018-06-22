import strutils
import ospaths
const headerrwlock = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/rwlock.h"
import libnx_wrapper/mutex
type
  RwLock* {.importc: "RwLock", header: headerrwlock, bycopy.} = object
    r* {.importc: "r".}: RMutex
    g* {.importc: "g".}: RMutex
    b* {.importc: "b".}: uint64


proc rwlockReadLock*(r: ptr RwLock) {.cdecl, importc: "rwlockReadLock",
                                  header: headerrwlock.}
proc rwlockReadUnlock*(r: ptr RwLock) {.cdecl, importc: "rwlockReadUnlock",
                                    header: headerrwlock.}
proc rwlockWriteLock*(r: ptr RwLock) {.cdecl, importc: "rwlockWriteLock",
                                   header: headerrwlock.}
proc rwlockWriteUnlock*(r: ptr RwLock) {.cdecl, importc: "rwlockWriteUnlock",
                                     header: headerrwlock.}