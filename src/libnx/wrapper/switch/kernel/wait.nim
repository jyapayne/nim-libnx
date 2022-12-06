## *
##  @file wait.h
##  @brief User mode synchronization primitive waiting operations.
##  @author plutoo
##  @copyright libnx Authors
##

import
  mutex
import ../types

##  Implementation details.

type
  WaitableMethods* = object
  WaitableNode* {.bycopy.} = object
    prev*: ptr WaitableNode
    next*: ptr WaitableNode

  Waitable* {.bycopy.} = object
    vt*: ptr WaitableMethods
    list*: WaitableNode
    mutex*: Mutex

  WaiterType* = enum
    WaiterTypeHandle, WaiterTypeHandleWithClear, WaiterTypeWaitable


##  User-facing API starts here.
## / Waiter structure, representing any generic waitable synchronization object; both kernel-mode and user-mode.

type
  INNER_C_UNION_wait_2* {.bycopy, union.} = object
    handle*: Handle
    waitable*: ptr Waitable

  Waiter* {.bycopy.} = object
    `type`*: WaiterType
    anoWait3*: INNER_C_UNION_wait_2


## / Creates a \ref Waiter for a kernel-mode \ref Handle.

proc waiterForHandle*(h: Handle): Waiter {.inline, cdecl, importc: "waiterForHandle".} =
  var waitObj: Waiter
  waitObj.`type` = WaiterTypeHandle
  waitObj.anoWait3.handle = h
  return waitObj

## *
##  @brief Waits for an arbitrary number of generic waitable synchronization objects, optionally with a timeout.
##  @param[out] idx_out Variable that will received the index of the signalled object.
##  @param[in] objects Array containing \ref Waiter structures.
##  @param[in] num_objects Number of objects in the array.
##  @param[in] timeout Timeout (in nanoseconds).
##  @return Result code.
##  @note The number of objects must not be greater than \ref MAX_WAIT_OBJECTS. This is a Horizon kernel limitation.
##

proc waitObjects*(idxOut: ptr S32; objects: ptr Waiter; numObjects: S32; timeout: U64): Result {.
    cdecl, importc: "waitObjects".}
## *
##  @brief Waits for an arbitrary number of kernel synchronization objects, optionally with a timeout. This function replaces \ref svcWaitSynchronization.
##  @param[out] idx_out Variable that will received the index of the signalled object.
##  @param[in] handles Array containing handles.
##  @param[in] num_handles Number of handles in the array.
##  @param[in] timeout Timeout (in nanoseconds).
##  @return Result code.
##  @note The number of objects must not be greater than \ref MAX_WAIT_OBJECTS. This is a Horizon kernel limitation.
##

proc waitHandles*(idxOut: ptr S32; handles: ptr Handle; numHandles: S32; timeout: U64): Result {.
    cdecl, importc: "waitHandles".}

## *
##  @brief Helper macro for \ref waitObjects that accepts \ref Waiter structures as variadic arguments instead of as an array.
##  @param[out] idx_out The index of the signalled waiter.
##  @param[in] timeout Timeout (in nanoseconds).
##  @note The number of objects must not be greater than \ref MAX_WAIT_OBJECTS. This is a Horizon kernel limitation.
##
##  #define waitMulti(idx_out, timeout, ...) ({ \
##      Waiter __objects[] = { __VA_ARGS__ }; \
##      waitObjects((idx_out), __objects, sizeof(__objects) / sizeof(Waiter), (timeout)); \
##  })
## *
##  @brief Helper macro for \ref waitHandles that accepts handles as variadic arguments instead of as an array.
##  @param[out] idx_out The index of the signalled handle.
##  @param[in] timeout Timeout (in nanoseconds).
##  @note The number of objects must not be greater than \ref MAX_WAIT_OBJECTS. This is a Horizon kernel limitation.
##
##  #define waitMultiHandle(idx_out, timeout, ...) ({ \
##      Handle __handles[] = { __VA_ARGS__ }; \
##      waitHandles((idx_out), __handles, sizeof(__handles) / sizeof(Handle), (timeout)); \
##  })
## *
##  @brief Waits on a single generic waitable synchronization object, optionally with a timeout.
##  @param[in] w \ref Waiter structure.
##  @param[in] timeout Timeout (in nanoseconds).
##

proc waitSingle*(w: Waiter; timeout: U64): Result {.inline, cdecl, importc: "waitSingle".} =
  var idx: S32
  return waitObjects(addr(idx), addr(w), 1, timeout)

## *
##  @brief Waits for a single kernel synchronization object, optionally with a timeout.
##  @param[in] h \ref Handle of the object.
##  @param[in] timeout Timeout (in nanoseconds).
##

proc waitSingleHandle*(h: Handle; timeout: U64): Result {.inline, cdecl,
    importc: "waitSingleHandle".} =
  var idx: S32
  return waitHandles(addr(idx), addr(h), 1, timeout)
