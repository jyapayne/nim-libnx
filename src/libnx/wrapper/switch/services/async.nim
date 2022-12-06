## *
##  @file async.h
##  @brief NS/NIM IAsync* IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../applets/error, ../kernel/event

## / AsyncValue

type
  AsyncValue* {.bycopy.} = object
    s*: Service                ## /< IAsyncValue
    event*: Event              ## /< Event with autoclear=false.


## / AsyncResult

type
  AsyncResult* {.bycopy.} = object
    s*: Service                ## /< IAsyncResult
    event*: Event              ## /< Event with autoclear=false.


## /@name IAsyncValue
## /@{
## *
##  @brief Close a \ref AsyncValue.
##  @note When the object is initialized, this uses \ref asyncValueCancel then \ref asyncValueWait with timeout=UINT64_MAX.
##  @param a \ref AsyncValue
##

proc asyncValueClose*(a: ptr AsyncValue) {.cdecl, importc: "asyncValueClose".}
## *
##  @brief Waits for the async operation to finish using the specified timeout.
##  @param a \ref AsyncValue
##  @param[in] timeout Timeout in nanoseconds. UINT64_MAX for no timeout.
##

proc asyncValueWait*(a: ptr AsyncValue; timeout: U64): Result {.cdecl,
    importc: "asyncValueWait".}
## *
##  @brief Gets the value size.
##  @param a \ref AsyncValue
##  @param[out] size Output size.
##

proc asyncValueGetSize*(a: ptr AsyncValue; size: ptr U64): Result {.cdecl,
    importc: "asyncValueGetSize".}
## *
##  @brief Gets the value.
##  @note Prior to using the cmd, this uses \ref asyncResultWait with timeout=UINT64_MAX.
##  @param a \ref AsyncValue
##  @param[out] buffer Output buffer.
##  @param[in] size Output buffer size.
##

proc asyncValueGet*(a: ptr AsyncValue; buffer: pointer; size: csize_t): Result {.cdecl,
    importc: "asyncValueGet".}
## *
##  @brief Cancels the async operation.
##  @note Used automatically by \ref asyncValueClose.
##  @param a \ref AsyncValue
##

proc asyncValueCancel*(a: ptr AsyncValue): Result {.cdecl, importc: "asyncValueCancel".}
## *
##  @brief Gets the \ref ErrorContext.
##  @note Only available on [4.0.0+].
##  @param a \ref AsyncValue
##  @param[out] context \ref ErrorContext
##

proc asyncValueGetErrorContext*(a: ptr AsyncValue; context: ptr ErrorContext): Result {.
    cdecl, importc: "asyncValueGetErrorContext".}
## /@}
## /@name IAsyncResult
## /@{
## *
##  @brief Close a \ref AsyncResult.
##  @note When the object is initialized, this uses \ref asyncResultCancel then \ref asyncResultWait with timeout=UINT64_MAX.
##  @param a \ref AsyncResult
##

proc asyncResultClose*(a: ptr AsyncResult) {.cdecl, importc: "asyncResultClose".}
## *
##  @brief Waits for the async operation to finish using the specified timeout.
##  @param a \ref AsyncResult
##  @param[in] timeout Timeout in nanoseconds. UINT64_MAX for no timeout.
##

proc asyncResultWait*(a: ptr AsyncResult; timeout: U64): Result {.cdecl,
    importc: "asyncResultWait".}
## *
##  @brief Gets the Result.
##  @note Prior to using the cmd, this uses \ref asyncResultWait with timeout=UINT64_MAX.
##  @param a \ref AsyncResult
##

proc asyncResultGet*(a: ptr AsyncResult): Result {.cdecl, importc: "asyncResultGet".}
## *
##  @brief Cancels the async operation.
##  @note Used automatically by \ref asyncResultClose.
##  @param a \ref AsyncResult
##

proc asyncResultCancel*(a: ptr AsyncResult): Result {.cdecl,
    importc: "asyncResultCancel".}
## *
##  @brief Gets the \ref ErrorContext.
##  @note Only available on [4.0.0+].
##  @param a \ref AsyncResult
##  @param[out] context \ref ErrorContext
##

proc asyncResultGetErrorContext*(a: ptr AsyncResult; context: ptr ErrorContext): Result {.
    cdecl, importc: "asyncResultGetErrorContext".}
## /@}
