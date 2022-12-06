## *
##  @file shmem.h
##  @brief Shared memory object handling
##  @author plutoo
##  @copyright libnx Authors
##  @remark Shared memory differs from transfer memory in the fact that the kernel (as opposed to the user process) allocates and owns its backing memory.
##

import
  ../types, svc

## / Shared memory information structure.

type
  SharedMemory* {.bycopy.} = object
    handle*: Handle            ## /< Kernel object handle.
    size*: csize_t             ## /< Size of the shared memory object.
    perm*: Permission          ## /< Permissions.
    mapAddr*: pointer          ## /< Address to which the shared memory object is mapped.

proc shmemCreate*(s: ptr SharedMemory; size: csize_t; localPerm: Permission;
                 remotePerm: Permission): Result {.cdecl, importc: "shmemCreate".}
## *
##  @brief Creates a shared memory object.
##  @param s Shared memory information structure which will be filled in.
##  @param size Size of the shared memory object to create.
##  @param local_perm Permissions with which the shared memory object will be mapped in the local process.
##  @param remote_perm Permissions with which the shared memory object will be mapped in the remote process (can be Perm_DontCare).
##  @return Result code.
##  @warning This is a privileged operation; in normal circumstances applications cannot use this function.
##

proc shmemLoadRemote*(s: ptr SharedMemory; handle: Handle; size: csize_t;
                     perm: Permission) {.cdecl, importc: "shmemLoadRemote".}
## *
##  @brief Loads a shared memory object coming from a remote process.
##  @param s Shared memory information structure which will be filled in.
##  @param handle Handle of the shared memory object.
##  @param size Size of the shared memory object that is being loaded.
##  @param perm Permissions with which the shared memory object will be mapped in the local process.
##

proc shmemMap*(s: ptr SharedMemory): Result {.cdecl, importc: "shmemMap".}
## *
##  @brief Maps a shared memory object.
##  @param s Shared memory information structure.
##  @return Result code.
##

proc shmemUnmap*(s: ptr SharedMemory): Result {.cdecl, importc: "shmemUnmap".}
## *
##  @brief Unmaps a shared memory object.
##  @param s Shared memory information structure.
##  @return Result code.
##

proc shmemGetAddr*(s: ptr SharedMemory): pointer {.inline, cdecl.} =
  ## *
  ##  @brief Retrieves the mapped address of a shared memory object.
  ##  @param s Shared memory information structure.
  ##  @return Mapped address of the shared memory object.
  ##
  return s.mapAddr

proc shmemClose*(s: ptr SharedMemory): Result {.cdecl, importc: "shmemClose".}
## *
##  @brief Frees up resources used by a shared memory object, unmapping and closing handles, etc.
##  @param s Shared memory information structure.
##  @return Result code.
##

