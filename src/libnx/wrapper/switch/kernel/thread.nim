## *
##  @file thread.h
##  @brief Multi-threading support
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types, ../arm/thread_context, wait

## / Thread information structure.

type
  Thread* {.bycopy.} = object
    handle*: Handle            ## /< Thread handle.
    ownsStackMem*: bool        ## /< Whether the stack memory is automatically allocated.
    stackMem*: pointer         ## /< Pointer to stack memory.
    stackMirror*: pointer      ## /< Pointer to stack memory mirror.
    stackSz*: csize_t          ## /< Stack size.
    tlsArray*: ptr pointer
    next*: ptr Thread
    prevNext*: ptr ptr Thread

proc waiterForThread*(t: ptr Thread): Waiter {.inline, cdecl.} =
  ## / Creates a \ref Waiter for a \ref Thread.
  return waiterForHandle(t.handle)

proc threadCreate*(t: ptr Thread; entry: ThreadFunc; arg: pointer; stackMem: pointer;
                  stackSz: csize_t; prio: cint; cpuid: cint): Result {.cdecl,
    importc: "threadCreate".}
## *
##  @brief Creates a thread.
##  @param t Thread information structure which will be filled in.
##  @param entry Entrypoint of the thread.
##  @param arg Argument to pass to the entrypoint.
##  @param stack_mem Memory to use as backing for stack/tls/reent. Must be page-aligned. NULL argument means to allocate new memory.
##  @param stack_sz  If stack_mem is NULL, size to use for stack. If stack_mem is non-NULL, size to use for stack + reent + tls (must be page-aligned).
##  @param prio Thread priority (0x00~0x3F); 0x2C is the usual priority of the main thread, 0x3B is a special priority on cores 0..2 that enables preemptive multithreading (0x3F on core 3).
##  @param cpuid ID of the core on which to create the thread (0~3); or -2 to use the default core for the current process.
##  @return Result code.
##

proc threadStart*(t: ptr Thread): Result {.cdecl, importc: "threadStart".}
## *
##  @brief Starts the execution of a thread.
##  @param t Thread information structure.
##  @return Result code.
##

proc threadExit*() {.cdecl, importc: "threadExit".}
## *
##  @brief Exits the current thread immediately.
##

proc threadWaitForExit*(t: ptr Thread): Result {.cdecl, importc: "threadWaitForExit".}
## *
##  @brief Waits for a thread to finish executing.
##  @param t Thread information structure.
##  @return Result code.
##

proc threadClose*(t: ptr Thread): Result {.cdecl, importc: "threadClose".}
## *
##  @brief Frees up resources associated with a thread.
##  @param t Thread information structure.
##  @return Result code.
##

proc threadPause*(t: ptr Thread): Result {.cdecl, importc: "threadPause".}
## *
##  @brief Pauses the execution of a thread.
##  @param t Thread information structure.
##  @return Result code.
##

proc threadResume*(t: ptr Thread): Result {.cdecl, importc: "threadResume".}
## *
##  @brief Resumes the execution of a thread, after having been paused.
##  @param t Thread information structure.
##  @return Result code.
##

proc threadDumpContext*(ctx: ptr ThreadContext; t: ptr Thread): Result {.cdecl,
    importc: "threadDumpContext".}
## *
##  @brief Dumps the registers of a thread paused by @ref threadPause (register groups: all).
##  @param[out] ctx Output thread context (register dump).
##  @param t Thread information structure.
##  @return Result code.
##  @warning Official kernel will not dump x0..x18 if the thread is currently executing a system call, and prior to 6.0.0 doesn't dump TPIDR_EL0.
##

proc threadGetSelf*(): ptr Thread {.cdecl, importc: "threadGetSelf".}
## *
##  @brief Gets a pointer to the current thread structure.
##  @return Thread information structure.
##

proc threadGetCurHandle*(): Handle {.cdecl, importc: "threadGetCurHandle".}
## *
##  @brief Gets the raw handle to the current thread.
##  @return The current thread's handle.
##

proc threadTlsAlloc*(destructor: proc (a1: pointer) {.cdecl.}): S32 {.cdecl,
    importc: "threadTlsAlloc".}
## *
##  @brief Allocates a TLS slot.
##  @param destructor Function to run automatically when a thread exits.
##  @return TLS slot ID on success, or a negative value on failure.
##

proc threadTlsGet*(slotId: S32): pointer {.cdecl, importc: "threadTlsGet".}
## *
##  @brief Retrieves the value stored in a TLS slot.
##  @param slot_id TLS slot ID.
##  @return Value.
##

proc threadTlsSet*(slotId: S32; value: pointer) {.cdecl, importc: "threadTlsSet".}
## *
##  @brief Stores the specified value into a TLS slot.
##  @param slot_id TLS slot ID.
##  @param value Value.
##

proc threadTlsFree*(slotId: S32) {.cdecl, importc: "threadTlsFree".}
## *
##  @brief Frees a TLS slot.
##  @param slot_id TLS slot ID.
##

