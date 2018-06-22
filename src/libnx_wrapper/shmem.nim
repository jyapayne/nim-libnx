import strutils
import ospaths
const headershmem = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/shmem.h"
## *
##  @file shmem.h
##  @brief Shared memory object handling
##  @author plutoo
##  @copyright libnx Authors
##  @remark Shared memory differs from transfer memory in the fact that the kernel (as opposed to the user process) allocates and owns its backing memory.
## 

import
  libnx_wrapper/types

## / Shared memory information structure.

import libnx_wrapper/svc
type
  SharedMemory* {.importc: "SharedMemory", header: headershmem, bycopy.} = object
    handle* {.importc: "handle".}: Handle ## /< Kernel object handle.
    size* {.importc: "size".}: csize ## /< Size of the shared memory object.
    perm* {.importc: "perm".}: Permission ## /< Permissions.
    map_addr* {.importc: "map_addr".}: pointer ## /< Address to which the shared memory object is mapped.
  

## *
##  @brief Creates a shared memory object.
##  @param s Shared memory information structure which will be filled in.
##  @param size Size of the shared memory object to create.
##  @param local_perm Permissions with which the shared memory object will be mapped in the local process.
##  @param remote_perm Permissions with which the shared memory object will be mapped in the remote process (can be Perm_DontCare).
##  @return Result code.
##  @warning This is a privileged operation; in normal circumstances applications cannot use this function.
## 

proc shmemCreate*(s: ptr SharedMemory; size: csize; local_perm: Permission;
                 remote_perm: Permission): Result {.cdecl, importc: "shmemCreate",
    header: headershmem.}
## *
##  @brief Loads a shared memory object coming from a remote process.
##  @param s Shared memory information structure which will be filled in.
##  @param handle Handle of the shared memory object.
##  @param size Size of the shared memory object that is being loaded.
##  @param perm Permissions with which the shared memory object will be mapped in the local process.
## 

proc shmemLoadRemote*(s: ptr SharedMemory; handle: Handle; size: csize; perm: Permission) {.
    cdecl, importc: "shmemLoadRemote", header: headershmem.}
## *
##  @brief Maps a shared memory object.
##  @param s Shared memory information structure.
##  @return Result code.
## 

proc shmemMap*(s: ptr SharedMemory): Result {.cdecl, importc: "shmemMap",
    header: headershmem.}
## *
##  @brief Unmaps a shared memory object.
##  @param s Shared memory information structure.
##  @return Result code.
## 

proc shmemUnmap*(s: ptr SharedMemory): Result {.cdecl, importc: "shmemUnmap",
    header: headershmem.}
## *
##  @brief Retrieves the mapped address of a shared memory object.
##  @param s Shared memory information structure.
##  @return Mapped address of the shared memory object.
## 

proc shmemGetAddr*(s: ptr SharedMemory): pointer {.inline, cdecl,
    importc: "shmemGetAddr", header: headershmem.}
## *
##  @brief Frees up resources used by a shared memory object, unmapping and closing handles, etc.
##  @param s Shared memory information structure.
##  @return Result code.
## 

proc shmemClose*(s: ptr SharedMemory): Result {.cdecl, importc: "shmemClose",
    header: headershmem.}