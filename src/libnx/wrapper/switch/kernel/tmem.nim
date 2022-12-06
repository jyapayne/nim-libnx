## *
##  @file tmem.h
##  @brief Transfer memory handling
##  @author plutoo
##  @copyright libnx Authors
##  @remark Transfer memory differs from shared memory in the fact that the user process (as opposed to the kernel) allocates and owns its backing memory.
##

import
  ../types, ../kernel/svc

## / Transfer memory information structure.

type
  TransferMemory* {.bycopy.} = object
    handle*: Handle            ## /< Kernel object handle.
    size*: csize_t             ## /< Size of the transfer memory object.
    perm*: Permission          ## /< Permissions of the transfer memory object.
    srcAddr*: pointer          ## /< Address of the source backing memory.
    mapAddr*: pointer          ## /< Address to which the transfer memory object is mapped.


## *
##  @brief Creates a transfer memory object.
##  @param t Transfer memory information structure that will be filled in.
##  @param size Size of the transfer memory object to create.
##  @param perm Permissions with which to protect the transfer memory in the local process.
##  @return Result code.
##

proc tmemCreate*(t: ptr TransferMemory; size: csize_t; perm: Permission): Result {.cdecl,
    importc: "tmemCreate".}
## *
##  @brief Creates a transfer memory object from existing memory.
##  @param t Transfer memory information structure that will be filled in.
##  @param buf Pointer to a page-aligned buffer.
##  @param size Size of the transfer memory object to create.
##  @param perm Permissions with which to protect the transfer memory in the local process.
##  @return Result code.
##

proc tmemCreateFromMemory*(t: ptr TransferMemory; buf: pointer; size: csize_t;
                          perm: Permission): Result {.cdecl,
    importc: "tmemCreateFromMemory".}
## *
##  @brief Loads a transfer memory object coming from a remote process.
##  @param t Transfer memory information structure which will be filled in.
##  @param handle Handle of the transfer memory object.
##  @param size Size of the transfer memory object that is being loaded.
##  @param perm Permissions which the transfer memory is expected to have in the process that owns the memory.
##  @warning This is a privileged operation; in normal circumstances applications shouldn't use this function.
##

proc tmemLoadRemote*(t: ptr TransferMemory; handle: Handle; size: csize_t;
                    perm: Permission) {.cdecl, importc: "tmemLoadRemote".}
## *
##  @brief Maps a transfer memory object.
##  @param t Transfer memory information structure.
##  @return Result code.
##  @warning This is a privileged operation; in normal circumstances applications cannot use this function.
##

proc tmemMap*(t: ptr TransferMemory): Result {.cdecl, importc: "tmemMap".}
## *
##  @brief Unmaps a transfer memory object.
##  @param t Transfer memory information structure.
##  @return Result code.
##  @warning This is a privileged operation; in normal circumstances applications cannot use this function.
##

proc tmemUnmap*(t: ptr TransferMemory): Result {.cdecl, importc: "tmemUnmap".}
## *
##  @brief Retrieves the mapped address of a transfer memory object.
##  @param t Transfer memory information structure.
##  @return Mapped address of the transfer memory object.
##

proc tmemGetAddr*(t: ptr TransferMemory): pointer {.inline, cdecl,
    importc: "tmemGetAddr".} =
  return t.mapAddr

## *
##  @brief Frees up resources used by a transfer memory object, unmapping and closing handles, etc.
##  @param t Transfer memory information structure.
##  @return Result code.
##

proc tmemClose*(t: ptr TransferMemory): Result {.cdecl, importc: "tmemClose".}