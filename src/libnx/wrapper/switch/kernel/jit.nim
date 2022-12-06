## *
##  @file jit.h
##  @brief Just-in-time compilation support.
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types, virtmem

## / JIT implementation type.

type
  JitType* = enum
    JitTypeSetProcessMemoryPermission, ## /< JIT supported using svcSetProcessMemoryPermission
    JitTypeCodeMemory         ## /< JIT supported using [4.0.0+] CodeMemory syscalls


## / JIT buffer object.

type
  INNER_C_UNION_jit_2* {.bycopy, union.} = object
    handle*: Handle
    rv*: ptr VirtmemReservation

  Jit* {.bycopy.} = object
    `type`*: JitType
    size*: csize_t
    srcAddr*: pointer
    rxAddr*: pointer
    rwAddr*: pointer
    isExecutable*: bool
    anoJit3*: INNER_C_UNION_jit_2


## *
##  @brief Creates a JIT buffer.
##  @param j JIT buffer.
##  @param size Size of the JIT buffer.
##  @return Result code.
##

proc jitCreate*(j: ptr Jit; size: csize_t): Result {.cdecl, importc: "jitCreate".}
## *
##  @brief Transition a JIT buffer to have writable permission.
##  @param j JIT buffer.
##  @return Result code.
##

proc jitTransitionToWritable*(j: ptr Jit): Result {.cdecl,
    importc: "jitTransitionToWritable".}
## *
##  @brief Transition a JIT buffer to have executable permission.
##  @param j JIT buffer.
##  @return Result code.
##

proc jitTransitionToExecutable*(j: ptr Jit): Result {.cdecl,
    importc: "jitTransitionToExecutable".}
## *
##  @brief Destroys a JIT buffer.
##  @param j JIT buffer.
##  @return Result code.
##

proc jitClose*(j: ptr Jit): Result {.cdecl, importc: "jitClose".}
## *
##  @brief Gets the address of the writable memory alias of a JIT buffer.
##  @param j JIT buffer.
##  @return Pointer to alias of the JIT buffer that can be written to.
##

proc jitGetRwAddr*(j: ptr Jit): pointer {.inline, cdecl, importc: "jitGetRwAddr".} =
  return j.rwAddr

## *
##  @brief Gets the address of the executable memory alias of a JIT buffer.
##  @param j JIT buffer.
##  @return Pointer to alias of the JIT buffer that can be executed.
##

proc jitGetRxAddr*(j: ptr Jit): pointer {.inline, cdecl, importc: "jitGetRxAddr".} =
  return j.rxAddr
