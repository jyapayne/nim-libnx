## *
##  @file rwlock.h
##  @brief Read/write lock synchronization primitive.
##  @author plutoo, SciresM
##  @copyright libnx Authors
##

import
  ../kernel/mutex, ../kernel/condvar, ../types

## / Read/write lock structure.

type
  RwLock* {.bycopy.} = object
    mutex*: Mutex
    condvarReaderWait*: CondVar
    condvarWriterWait*: CondVar
    readLockCount*: U32
    readWaiterCount*: U32
    writeLockCount*: U32
    writeWaiterCount*: U32
    writeOwnerTag*: U32

proc rwlockInit*(r: ptr RwLock) {.cdecl, importc: "rwlockInit".}
## *
##  @brief Initializes the read/write lock.
##  @param r Read/write lock object.
##

proc rwlockReadLock*(r: ptr RwLock) {.cdecl, importc: "rwlockReadLock".}
## *
##  @brief Locks the read/write lock for reading.
##  @param r Read/write lock object.
##

proc rwlockTryReadLock*(r: ptr RwLock): bool {.cdecl, importc: "rwlockTryReadLock".}
## *
##  @brief Attempts to lock the read/write lock for reading without waiting.
##  @param r Read/write lock object.
##  @return 1 if the mutex has been acquired successfully, and 0 on contention.
##

proc rwlockReadUnlock*(r: ptr RwLock) {.cdecl, importc: "rwlockReadUnlock".}
## *
##  @brief Unlocks the read/write lock for reading.
##  @param r Read/write lock object.
##

proc rwlockWriteLock*(r: ptr RwLock) {.cdecl, importc: "rwlockWriteLock".}
## *
##  @brief Locks the read/write lock for writing.
##  @param r Read/write lock object.
##

proc rwlockTryWriteLock*(r: ptr RwLock): bool {.cdecl, importc: "rwlockTryWriteLock".}
## *
##  @brief Attempts to lock the read/write lock for writing without waiting.
##  @param r Read/write lock object.
##  @return 1 if the mutex has been acquired successfully, and 0 on contention.
##

proc rwlockWriteUnlock*(r: ptr RwLock) {.cdecl, importc: "rwlockWriteUnlock".}
## *
##  @brief Unlocks the read/write lock for writing.
##  @param r Read/write lock object.
##

proc rwlockIsWriteLockHeldByCurrentThread*(r: ptr RwLock): bool {.cdecl,
    importc: "rwlockIsWriteLockHeldByCurrentThread".}
## *
##  @brief Checks if the write lock is held by the current thread.
##  @param r Read/write lock object.
##  @return 1 if the current hold holds the write lock, and 0 if it does not.
##

proc rwlockIsOwnedByCurrentThread*(r: ptr RwLock): bool {.cdecl,
    importc: "rwlockIsOwnedByCurrentThread".}
## *
##  @brief Checks if the read/write lock is owned by the current thread.
##  @param r Read/write lock object.
##  @return 1 if the current hold holds the write lock or if it holds read locks acquired
##          while it held the write lock, and 0 if it does not.
##

