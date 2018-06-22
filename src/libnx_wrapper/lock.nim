import strutils
import ospaths
const headerlock = "/opt/devkitpro/devkitA64/aarch64-none-elf/include/sys/lock.h"
import libnx_wrapper/types
type
  LOCK_T* = int32_t
  DUlock_t* {.importc: "__lock_t", header: headerlock, bycopy.} = object
    lock* {.importc: "lock".}: LOCK_T
    thread_tag* {.importc: "thread_tag".}: uint32_t
    counter* {.importc: "counter".}: uint32_t

  LOCK_RECURSIVE_T* = DUlock_t

proc DUlibc_lock_init*(lock: ptr LOCK_T) {.cdecl, importc: "__libc_lock_init",
                                        header: headerlock.}
proc DUlibc_lock_init_recursive*(lock: ptr LOCK_RECURSIVE_T) {.cdecl,
    importc: "__libc_lock_init_recursive", header: headerlock.}
proc DUlibc_lock_close*(lock: ptr LOCK_T) {.cdecl, importc: "__libc_lock_close",
    header: headerlock.}
proc DUlibc_lock_close_recursive*(lock: ptr LOCK_RECURSIVE_T) {.cdecl,
    importc: "__libc_lock_close_recursive", header: headerlock.}
proc DUlibc_lock_acquire*(lock: ptr LOCK_T) {.cdecl,
    importc: "__libc_lock_acquire", header: headerlock.}
proc DUlibc_lock_acquire_recursive*(lock: ptr LOCK_RECURSIVE_T) {.cdecl,
    importc: "__libc_lock_acquire_recursive", header: headerlock.}
proc DUlibc_lock_release*(lock: ptr LOCK_T) {.cdecl,
    importc: "__libc_lock_release", header: headerlock.}
proc DUlibc_lock_release_recursive*(lock: ptr LOCK_RECURSIVE_T) {.cdecl,
    importc: "__libc_lock_release_recursive", header: headerlock.}
proc DUlibc_lock_try_acquire*(lock: ptr LOCK_T): cint {.cdecl,
    importc: "__libc_lock_try_acquire", header: headerlock.}
proc DUlibc_lock_try_acquire_recursive*(lock: ptr LOCK_RECURSIVE_T): cint {.cdecl,
    importc: "__libc_lock_try_acquire_recursive", header: headerlock.}