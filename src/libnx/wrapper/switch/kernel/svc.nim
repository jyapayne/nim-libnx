## *
##  @file svc.h
##  @brief Wrappers for kernel syscalls.
##  @copyright libnx Authors
##

import
  ../types, ../arm/thread_context

## / Pseudo handle for the current process.

const
  CUR_PROCESS_HANDLE* = 0xFFFF8001

## / Pseudo handle for the current thread.

const
  CUR_THREAD_HANDLE* = 0xFFFF8000

## / Maximum number of objects that can be waited on by \ref svcWaitSynchronization (Horizon kernel limitation).

const
  MAX_WAIT_OBJECTS* = 0x40

## / Memory type enumeration (lower 8 bits of \ref MemoryState)

type
  MemoryType* = enum
    MemTypeUnmapped = 0x00,     ## /< Unmapped memory.
    MemTypeIo = 0x01,           ## /< Mapped by kernel capability parsing in \ref svcCreateProcess.
    MemTypeNormal = 0x02,       ## /< Mapped by kernel capability parsing in \ref svcCreateProcess.
    MemTypeCodeStatic = 0x03,   ## /< Mapped during \ref svcCreateProcess.
    MemTypeCodeMutable = 0x04,  ## /< Transition from MemType_CodeStatic performed by \ref svcSetProcessMemoryPermission.
    MemTypeHeap = 0x05,         ## /< Mapped using \ref svcSetHeapSize.
    MemTypeSharedMem = 0x06,    ## /< Mapped using \ref svcMapSharedMemory.
    MemTypeWeirdMappedMem = 0x07, ## /< Mapped using \ref svcMapMemory.
    MemTypeModuleCodeStatic = 0x08, ## /< Mapped using \ref svcMapProcessCodeMemory.
    MemTypeModuleCodeMutable = 0x09, ## /< Transition from \ref MemType_ModuleCodeStatic performed by \ref svcSetProcessMemoryPermission.
    MemTypeIpcBuffer0 = 0x0A,   ## /< IPC buffers with descriptor flags=0.
    MemTypeMappedMemory = 0x0B, ## /< Mapped using \ref svcMapMemory.
    MemTypeThreadLocal = 0x0C,  ## /< Mapped during \ref svcCreateThread.
    MemTypeTransferMemIsolated = 0x0D, ## /< Mapped using \ref svcMapTransferMemory when the owning process has perm=0.
    MemTypeTransferMem = 0x0E,  ## /< Mapped using \ref svcMapTransferMemory when the owning process has perm!=0.
    MemTypeProcessMem = 0x0F,   ## /< Mapped using \ref svcMapProcessMemory.
    MemTypeReserved = 0x10,     ## /< Reserved.
    MemTypeIpcBuffer1 = 0x11,   ## /< IPC buffers with descriptor flags=1.
    MemTypeIpcBuffer3 = 0x12,   ## /< IPC buffers with descriptor flags=3.
    MemTypeKernelStack = 0x13,  ## /< Mapped in kernel during \ref svcCreateThread.
    MemTypeCodeReadOnly = 0x14, ## /< Mapped in kernel during \ref svcControlCodeMemory.
    MemTypeCodeWritable = 0x15, ## /< Mapped in kernel during \ref svcControlCodeMemory.
    MemTypeCoverage = 0x16,     ## /< Not available.
    MemTypeInsecure = 0x17      ## /< Mapped in kernel during \ref svcMapInsecureMemory.


## / Memory state bitmasks.

type
  MemoryState* = enum
    MemStateType = 0xFF,        ## /< Type field (see \ref MemoryType).
    MemStatePermChangeAllowed = bit(8), ## /< Permission change allowed.
    MemStateForceRwByDebugSyscalls = bit(9), ## /< Force read/writable by debug syscalls.
    MemStateIpcSendAllowedType0 = bit(10), ## /< IPC type 0 send allowed.
    MemStateIpcSendAllowedType3 = bit(11), ## /< IPC type 3 send allowed.
    MemStateIpcSendAllowedType1 = bit(12), ## /< IPC type 1 send allowed.
    MemStateProcessPermChangeAllowed = bit(14), ## /< Process permission change allowed.
    MemStateMapAllowed = bit(15), ## /< Map allowed.
    MemStateUnmapProcessCodeMemAllowed = bit(16), ## /< Unmap process code memory allowed.
    MemStateTransferMemAllowed = bit(17), ## /< Transfer memory allowed.
    MemStateQueryPAddrAllowed = bit(18), ## /< Query physical address allowed.
    MemStateMapDeviceAllowed = bit(19), ## /< Map device allowed (\ref svcMapDeviceAddressSpace and \ref svcMapDeviceAddressSpaceByForce).
    MemStateMapDeviceAlignedAllowed = bit(20), ## /< Map device aligned allowed.
    MemStateIpcBufferAllowed = bit(21), ## /< IPC buffer allowed.
    MemStateIsPoolAllocated = bit(22), ## /< Is pool allocated.
    MemStateMapProcessAllowed = bit(23), ## /< Map process allowed.
    MemStateAttrChangeAllowed = bit(24), ## /< Attribute change allowed.
    MemStateCodeMemAllowed = bit(25) ## /< Code memory allowed.

const
    MemStateIsRefCounted* = MemStateIsPoolAllocated ## /< Alias for \ref MemState_IsPoolAllocated.

## / Memory attribute bitmasks.

type
  MemoryAttribute* = enum
    MemAttrIsBorrowed = bit(0), ## /< Is borrowed memory.
    MemAttrIsIpcMapped = bit(1), ## /< Is IPC mapped (when IpcRefCount > 0).
    MemAttrIsDeviceMapped = bit(2), ## /< Is device mapped (when DeviceRefCount > 0).
    MemAttrIsUncached = bit(3)  ## /< Is uncached.


## / Memory permission bitmasks.

type
  Permission* = enum
    PermNone = 0,               ## /< No permissions.
    PermR = bit(0),             ## /< Read permission.
    PermW = bit(1),             ## /< Write permission.
    PermRw = PermR.uint or PermW.uint,      ## /< Read/write permissions.
    PermX = bit(2),             ## /< Execute permission.
    PermRx = PermR.uint or PermX.uint,      ## /< Read/execute permissions.
    PermDontCare = bit(28)      ## /< Don't care


## / Memory information structure.

type
  MemoryInfo* {.bycopy.} = object
    `addr`*: U64               ## /< Base address.
    size*: U64                 ## /< Size.
    `type`*: U32               ## /< Memory type (see lower 8 bits of \ref MemoryState).
    attr*: U32                 ## /< Memory attributes (see \ref MemoryAttribute).
    perm*: U32                 ## /< Memory permissions (see \ref Permission).
    ipcRefcount*: U32          ## /< IPC reference count.
    deviceRefcount*: U32       ## /< Device reference count.
    padding*: U32              ## /< Padding.


## / Physical memory information structure.

type
  PhysicalMemoryInfo* {.bycopy.} = object
    physicalAddress*: U64      ## /< Physical address.
    virtualAddress*: U64       ## /< Virtual address.
    size*: U64                 ## /< Size.


## / Secure monitor arguments.

type
  SecmonArgs* {.bycopy.} = object
    x*: array[8, U64]           ## /< Values of X0 through X7.


## / Break reasons

type
  BreakReason* = enum
    BreakReasonPanic = 0, BreakReasonAssert = 1, BreakReasonUser = 2,
    BreakReasonPreLoadDll = 3, BreakReasonPostLoadDll = 4,
    BreakReasonPreUnloadDll = 5, BreakReasonPostUnloadDll = 6,
    BreakReasonCppException = 7, BreakReasonNotificationOnlyFlag = 0x80000000


## / Code memory mapping operations

type
  CodeMapOperation* = enum
    CodeMapOperationMapOwner = 0, ## /< Map owner.
    CodeMapOperationMapSlave = 1, ## /< Map slave.
    CodeMapOperationUnmapOwner = 2, ## /< Unmap owner.
    CodeMapOperationUnmapSlave = 3 ## /< Unmap slave.


## / Limitable Resources.

type
  LimitableResource* = enum
    LimitableResourceMemory = 0, ## /<How much memory can a process map.
    LimitableResourceThreads = 1, ## /<How many threads can a process spawn.
    LimitableResourceEvents = 2, ## /<How many events can a process have.
    LimitableResourceTransferMemories = 3, ## /<How many transfer memories can a process make.
    LimitableResourceSessions = 4 ## /<How many sessions can a process own.


## / Thread Activity.

type
  ThreadActivity* = enum
    ThreadActivityRunnable = 0, ## /< Thread can run.
    ThreadActivityPaused = 1    ## /< Thread is paused.


## / Process Information.

type
  ProcessInfoType* = enum
    ProcessInfoTypeProcessState = 0 ## /<What state is a process in.


## / Process States.

type
  ProcessState* = enum
    ProcessStateCreated = 0,    ## /<Newly-created process, not yet started.
    ProcessStateCreatedAttached = 1, ## /<Newly-created process, not yet started but attached to debugger.
    ProcessStateRunning = 2,    ## /<Process that is running normally (and detached from any debugger).
    ProcessStateCrashed = 3,    ## /<Process that has just crashed.
    ProcessStateRunningAttached = 4, ## /<Process that is running normally, attached to a debugger.
    ProcessStateExiting = 5,    ## /<Process has begun exiting.
    ProcessStateExited = 6,     ## /<Process has finished exiting.
    ProcessStateDebugSuspended = 7 ## /<Process execution suspended by debugger.


## / Process Activity.

type
  ProcessActivity* = enum
    ProcessActivityRunnable = 0, ## /< Process can run.
    ProcessActivityPaused = 1   ## /< Process is paused.


## / Debug Thread Parameters.

type
  DebugThreadParam* = enum
    DebugThreadParamActualPriority = 0, DebugThreadParamState = 1,
    DebugThreadParamIdealCore = 2, DebugThreadParamCurrentCore = 3,
    DebugThreadParamCoreMask = 4


## / GetInfo IDs.

type
  InfoType* = enum
    InfoTypeCoreMask = 0,       ## /< Bitmask of allowed Core IDs.
    InfoTypePriorityMask = 1,   ## /< Bitmask of allowed Thread Priorities.
    InfoTypeAliasRegionAddress = 2, ## /< Base of the Alias memory region.
    InfoTypeAliasRegionSize = 3, ## /< Size of the Alias memory region.
    InfoTypeHeapRegionAddress = 4, ## /< Base of the Heap memory region.
    InfoTypeHeapRegionSize = 5, ## /< Size of the Heap memory region.
    InfoTypeTotalMemorySize = 6, ## /< Total amount of memory available for process.
    InfoTypeUsedMemorySize = 7, ## /< Amount of memory currently used by process.
    InfoTypeDebuggerAttached = 8, ## /< Whether current process is being debugged.
    InfoTypeResourceLimit = 9,  ## /< Current process's resource limit handle.
    InfoTypeIdleTickCount = 10, ## /< Number of idle ticks on CPU.
    InfoTypeRandomEntropy = 11, ## /< [2.0.0+] Random entropy for current process.
    InfoTypeAslrRegionAddress = 12, ## /< [2.0.0+] Base of the process's address space.
    InfoTypeAslrRegionSize = 13, ## /< [2.0.0+] Size of the process's address space.
    InfoTypeStackRegionAddress = 14, ## /< [2.0.0+] Base of the Stack memory region.
    InfoTypeStackRegionSize = 15, ## /< [2.0.0+] Size of the Stack memory region.
    InfoTypeSystemResourceSizeTotal = 16, ## /< [3.0.0+] Total memory allocated for process memory management.
    InfoTypeSystemResourceSizeUsed = 17, ## /< [3.0.0+] Amount of memory currently used by process memory management.
    InfoTypeProgramId = 18,     ## /< [3.0.0+] Program ID for the process.
    InfoTypeInitialProcessIdRange = 19, ## /< [4.0.0-4.1.0] Min/max initial process IDs.
    InfoTypeUserExceptionContextAddress = 20, ## /< [5.0.0+] Address of the process's exception context (for break).
    InfoTypeTotalNonSystemMemorySize = 21, ## /< [6.0.0+] Total amount of memory available for process, excluding that for process memory management.
    InfoTypeUsedNonSystemMemorySize = 22, ## /< [6.0.0+] Amount of memory used by process, excluding that for process memory management.
    InfoTypeIsApplication = 23, ## /< [9.0.0+] Whether the specified process is an Application.
    InfoTypeFreeThreadCount = 24, ## /< [11.0.0+] The number of free threads available to the process's resource limit.
    InfoTypeThreadTickCount = 25, ## /< [13.0.0+] Number of ticks spent on thread.
    InfoTypeIsSvcPermitted = 26, ## /< [14.0.0+] Does process have access to SVC (only usable with \ref svcSynchronizePreemptionState at present).
    InfoTypeThreadTickCountDeprecated = 0xF0000002 ## /< [1.0.0-12.1.0] Number of ticks spent on thread.


## / GetSystemInfo IDs.

type
  SystemInfoType* = enum
    SystemInfoTypeTotalPhysicalMemorySize = 0, ## /< Total amount of DRAM available to system.
    SystemInfoTypeUsedPhysicalMemorySize = 1, ## /< Current amount of DRAM used by system.
    SystemInfoTypeInitialProcessIdRange = 2 ## /< Min/max initial process IDs.


## / GetInfo Idle/Thread Tick Count Sub IDs.

type
  TickCountInfo* = enum
    TickCountInfoCore0 = 0,     ## /< Tick count on core 0.
    TickCountInfoCore1 = 1,     ## /< Tick count on core 1.
    TickCountInfoCore2 = 2,     ## /< Tick count on core 2.
    TickCountInfoCore3 = 3,     ## /< Tick count on core 3.
    TickCountInfoTotal = uint32.high ## /< Tick count on all cores.


## / GetInfo InitialProcessIdRange Sub IDs.

type
  InitialProcessIdRangeInfo* = enum
    InitialProcessIdRangeInfoMinimum = 0, ## /< Lowest initial process ID.
    InitialProcessIdRangeInfoMaximum = 1 ## /< Highest initial process ID.


## / GetSystemInfo PhysicalMemory Sub IDs.

type
  PhysicalMemorySystemInfo* = enum
    PhysicalMemorySystemInfoApplication = 0, ## /< Memory allocated for application usage.
    PhysicalMemorySystemInfoApplet = 1, ## /< Memory allocated for applet usage.
    PhysicalMemorySystemInfoSystem = 2, ## /< Memory allocated for system usage.
    PhysicalMemorySystemInfoSystemUnsafe = 3 ## /< Memory allocated for unsafe system usage (accessible to devices).


## / SleepThread yield types.

type
  YieldType* = enum
    YieldTypeToAnyThread = -2'i32 ## /< Yields and performs forced load-balancing.
    YieldTypeWithCoreMigration = -1'i32, ## /< Yields to another thread (possibly on a different core).
    YieldTypeWithoutCoreMigration = 0'i32, ## /< Yields to another thread on the same core.


## / SignalToAddress behaviors.

type
  SignalType* = enum
    SignalTypeSignal = 0,       ## /< Signals the address.
    SignalTypeSignalAndIncrementIfEqual = 1, ## /< Signals the address and increments its value if equal to argument.
    SignalTypeSignalAndModifyBasedOnWaitingThreadCountIfEqual = 2 ## /< Signals the address and updates its value if equal to argument.


## / WaitForAddress behaviors.

type
  ArbitrationType* = enum
    ArbitrationTypeWaitIfLessThan = 0, ## /< Wait if the value is less than argument.
    ArbitrationTypeDecrementAndWaitIfLessThan = 1, ## /< Decrement the value and wait if it is less than argument.
    ArbitrationTypeWaitIfEqual = 2 ## /< Wait if the value is equal to argument.


## / Context of a scheduled thread.

type
  LastThreadContext* {.bycopy.} = object
    fp*: U64                   ## /< Frame Pointer for the thread.
    sp*: U64                   ## /< Stack Pointer for the thread.
    lr*: U64                   ## /< Link Register for the thread.
    pc*: U64                   ## /< Program Counter for the thread.


## / Memory mapping type.

type
  MemoryMapping* = enum
    MemoryMappingIoRegister = 0, ## /< Mapping IO registers.
    MemoryMappingUncached = 1,  ## /< Mapping normal memory without cache.
    MemoryMappingMemory = 2     ## /< Mapping normal memory.


## / Io Pools.

type
  IoPoolType* = enum
    IoPoolTypePcieA2 = 0        ## /< Physical address range 0x12000000-0x1FFFFFFF

proc svcSetHeapSize*(outAddr: ptr pointer; size: U64): Result {.cdecl,
    importc: "svcSetHeapSize".}
## /@name Memory management
## /@{
## *
##  @brief Set the process heap to a given size. It can both extend and shrink the heap.
##  @param[out] out_addr Variable to which write the address of the heap (which is randomized and fixed by the kernel)
##  @param[in] size Size of the heap, must be a multiple of 0x200000 and [2.0.0+] less than 0x18000000.
##  @return Result code.
##  @note Syscall number 0x01.
##

proc svcSetMemoryPermission*(`addr`: pointer; size: U64; perm: U32): Result {.cdecl,
    importc: "svcSetMemoryPermission".}
## *
##  @brief Set the memory permissions of a (page-aligned) range of memory.
##  @param[in] addr Start address of the range.
##  @param[in] size Size of the range, in bytes.
##  @param[in] perm Permissions (see \ref Permission).
##  @return Result code.
##  @remark Perm_X is not allowed. Setting write-only is not allowed either (Perm_W).
##          This can be used to move back and forth between Perm_None, Perm_R and Perm_Rw.
##  @note Syscall number 0x02.
##

proc svcSetMemoryAttribute*(`addr`: pointer; size: U64; val0: U32; val1: U32): Result {.
    cdecl, importc: "svcSetMemoryAttribute".}
## *
##  @brief Set the memory attributes of a (page-aligned) range of memory.
##  @param[in] addr Start address of the range.
##  @param[in] size Size of the range, in bytes.
##  @param[in] val0 State0
##  @param[in] val1 State1
##  @return Result code.
##  @remark See <a href="https://switchbrew.org/wiki/SVC#svcSetMemoryAttribute">switchbrew.org Wiki</a> for more details.
##  @note Syscall number 0x03.
##

proc svcMapMemory*(dstAddr: pointer; srcAddr: pointer; size: U64): Result {.cdecl,
    importc: "svcMapMemory".}
## *
##  @brief Maps a memory range into a different range. Mainly used for adding guard pages around stack.
##  Source range gets reprotected to Perm_None (it can no longer be accessed), and \ref MemAttr_IsBorrowed is set in the source \ref MemoryAttribute.
##  @param[in] dst_addr Destination address.
##  @param[in] src_addr Source address.
##  @param[in] size Size of the range.
##  @return Result code.
##  @note Syscall number 0x04.
##

proc svcUnmapMemory*(dstAddr: pointer; srcAddr: pointer; size: U64): Result {.cdecl,
    importc: "svcUnmapMemory".}
## *
##  @brief Unmaps a region that was previously mapped with \ref svcMapMemory.
##  @param[in] dst_addr Destination address.
##  @param[in] src_addr Source address.
##  @param[in] size Size of the range.
##  @return Result code.
##  @note Syscall number 0x05.
##

proc svcQueryMemory*(meminfoPtr: ptr MemoryInfo; pageinfo: ptr U32; `addr`: U64): Result {.
    cdecl, importc: "svcQueryMemory".}
## *
##  @brief Query information about an address. Will always fetch the lowest page-aligned mapping that contains the provided address.
##  @param[out] meminfo_ptr \ref MemoryInfo structure which will be filled in.
##  @param[out] pageinfo Page information which will be filled in.
##  @param[in] addr Address to query.
##  @return Result code.
##  @note Syscall number 0x06.
##

proc svcExitProcess*() {.cdecl, importc: "svcExitProcess".}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Exits the current process.
##  @note Syscall number 0x07.
##

proc svcCreateThread*(`out`: ptr Handle; entry: pointer; arg: pointer;
                     stackTop: pointer; prio: cint; cpuid: cint): Result {.cdecl,
    importc: "svcCreateThread".}
## *
##  @brief Creates a thread.
##  @return Result code.
##  @note Syscall number 0x08.
##

proc svcStartThread*(handle: Handle): Result {.cdecl, importc: "svcStartThread".}
## *
##  @brief Starts a freshly created thread.
##  @return Result code.
##  @note Syscall number 0x09.
##

proc svcExitThread*() {.cdecl, importc: "svcExitThread".}
## *
##  @brief Exits the current thread.
##  @note Syscall number 0x0A.
##

proc svcSleepThread*(nano: S64) {.cdecl, importc: "svcSleepThread".}
## *
##  @brief Sleeps the current thread for the specified amount of time.
##  @param[in] nano Number of nanoseconds to sleep, or \ref YieldType for yield.
##  @note Syscall number 0x0B.
##

proc svcGetThreadPriority*(priority: ptr S32; handle: Handle): Result {.cdecl,
    importc: "svcGetThreadPriority".}
## *
##  @brief Gets a thread's priority.
##  @return Result code.
##  @note Syscall number 0x0C.
##

proc svcSetThreadPriority*(handle: Handle; priority: U32): Result {.cdecl,
    importc: "svcSetThreadPriority".}
## *
##  @brief Sets a thread's priority.
##  @return Result code.
##  @note Syscall number 0x0D.
##

proc svcGetThreadCoreMask*(preferredCore: ptr S32; affinityMask: ptr U64;
                          handle: Handle): Result {.cdecl,
    importc: "svcGetThreadCoreMask".}
## *
##  @brief Gets a thread's core mask.
##  @return Result code.
##  @note Syscall number 0x0E.
##

proc svcSetThreadCoreMask*(handle: Handle; preferredCore: S32; affinityMask: U32): Result {.
    cdecl, importc: "svcSetThreadCoreMask".}
## *
##  @brief Sets a thread's core mask.
##  @return Result code.
##  @note Syscall number 0x0F.
##

proc svcGetCurrentProcessorNumber*(): U32 {.cdecl,
    importc: "svcGetCurrentProcessorNumber".}
## *
##  @brief Gets the current processor's number.
##  @return The current processor's number.
##  @note Syscall number 0x10.
##

proc svcSignalEvent*(handle: Handle): Result {.cdecl, importc: "svcSignalEvent".}
## /@}
## /@name Synchronization
## /@{
## *
##  @brief Sets an event's signalled status.
##  @return Result code.
##  @note Syscall number 0x11.
##

proc svcClearEvent*(handle: Handle): Result {.cdecl, importc: "svcClearEvent".}
## *
##  @brief Clears an event's signalled status.
##  @return Result code.
##  @note Syscall number 0x12.
##

proc svcMapSharedMemory*(handle: Handle; `addr`: pointer; size: csize_t; perm: U32): Result {.
    cdecl, importc: "svcMapSharedMemory".}
## /@}
## /@name Inter-process memory sharing
## /@{
## *
##  @brief Maps a block of shared memory.
##  @return Result code.
##  @note Syscall number 0x13.
##

proc svcUnmapSharedMemory*(handle: Handle; `addr`: pointer; size: csize_t): Result {.
    cdecl, importc: "svcUnmapSharedMemory".}
## *
##  @brief Unmaps a block of shared memory.
##  @return Result code.
##  @note Syscall number 0x14.
##

proc svcCreateTransferMemory*(`out`: ptr Handle; `addr`: pointer; size: csize_t;
                             perm: U32): Result {.cdecl,
    importc: "svcCreateTransferMemory".}
## *
##  @brief Creates a block of transfer memory.
##  @return Result code.
##  @note Syscall number 0x15.
##

proc svcCloseHandle*(handle: Handle): Result {.cdecl, importc: "svcCloseHandle".}
## /@}
## /@name Miscellaneous
## /@{
## *
##  @brief Closes a handle, decrementing the reference count of the corresponding kernel object.
##  This might result in the kernel freeing the object.
##  @param handle Handle to close.
##  @return Result code.
##  @note Syscall number 0x16.
##

proc svcResetSignal*(handle: Handle): Result {.cdecl, importc: "svcResetSignal".}
## /@}
## /@name Synchronization
## /@{
## *
##  @brief Resets a signal.
##  @return Result code.
##  @note Syscall number 0x17.
##

proc svcWaitSynchronization*(index: ptr S32; handles: ptr Handle; handleCount: S32;
                            timeout: U64): Result {.cdecl,
    importc: "svcWaitSynchronization".}
## /@}
## /@name Synchronization
## /@{
## *
##  @brief Waits on one or more synchronization objects, optionally with a timeout.
##  @return Result code.
##  @note Syscall number 0x18.
##  @note \p handleCount must not be greater than \ref MAX_WAIT_OBJECTS. This is a Horizon kernel limitation.
##  @note This is the raw syscall, which can be cancelled by \ref svcCancelSynchronization or other means. \ref waitHandles or \ref waitMultiHandle should normally be used instead.
##

proc svcWaitSynchronizationSingle*(handle: Handle; timeout: U64): Result {.inline, cdecl.} =
  ## *
  ##  @brief Waits on a single synchronization object, optionally with a timeout.
  ##  @return Result code.
  ##  @note Wrapper for \ref svcWaitSynchronization.
  ##  @note This is the raw syscall, which can be cancelled by \ref svcCancelSynchronization or other means. \ref waitSingleHandle should normally be used instead.
  ##
  var tmp: S32
  return svcWaitSynchronization(addr(tmp), addr(handle), 1, timeout)

proc svcCancelSynchronization*(thread: Handle): Result {.cdecl,
    importc: "svcCancelSynchronization".}
## *
##  @brief Waits a \ref svcWaitSynchronization operation being done on a synchronization object in another thread.
##  @return Result code.
##  @note Syscall number 0x19.
##

proc svcArbitrateLock*(waitTag: U32; tagLocation: ptr U32; selfTag: U32): Result {.cdecl,
    importc: "svcArbitrateLock".}
## *
##  @brief Arbitrates a mutex lock operation in userspace.
##  @return Result code.
##  @note Syscall number 0x1A.
##

proc svcArbitrateUnlock*(tagLocation: ptr U32): Result {.cdecl,
    importc: "svcArbitrateUnlock".}
## *
##  @brief Arbitrates a mutex unlock operation in userspace.
##  @return Result code.
##  @note Syscall number 0x1B.
##

proc svcWaitProcessWideKeyAtomic*(key: ptr U32; tagLocation: ptr U32; selfTag: U32;
                                 timeout: U64): Result {.cdecl,
    importc: "svcWaitProcessWideKeyAtomic".}
## *
##  @brief Performs a condition variable wait operation in userspace.
##  @return Result code.
##  @note Syscall number 0x1C.
##

proc svcSignalProcessWideKey*(key: ptr U32; num: S32) {.cdecl,
    importc: "svcSignalProcessWideKey".}
## *
##  @brief Performs a condition variable wake-up operation in userspace.
##  @note Syscall number 0x1D.
##

proc svcGetSystemTick*(): U64 {.cdecl, importc: "svcGetSystemTick".}
## /@}
## /@name Miscellaneous
## /@{
## *
##  @brief Gets the current system tick.
##  @return The current system tick.
##  @note Syscall number 0x1E.
##

proc svcConnectToNamedPort*(session: ptr Handle; name: cstring): Result {.cdecl,
    importc: "svcConnectToNamedPort".}
## /@}
## /@name Inter-process communication (IPC)
## /@{
## *
##  @brief Connects to a registered named port.
##  @return Result code.
##  @note Syscall number 0x1F.
##

proc svcSendSyncRequestLight*(session: Handle): Result {.cdecl,
    importc: "svcSendSyncRequestLight".}
## *
##  @brief Sends a light IPC synchronization request to a session.
##  @return Result code.
##  @note Syscall number 0x20.
##

proc svcSendSyncRequest*(session: Handle): Result {.cdecl,
    importc: "svcSendSyncRequest".}
## *
##  @brief Sends an IPC synchronization request to a session.
##  @return Result code.
##  @note Syscall number 0x21.
##

proc svcSendSyncRequestWithUserBuffer*(usrBuffer: pointer; size: U64; session: Handle): Result {.
    cdecl, importc: "svcSendSyncRequestWithUserBuffer".}
## *
##  @brief Sends an IPC synchronization request to a session from an user allocated buffer.
##  @return Result code.
##  @remark size must be allocated to 0x1000 bytes.
##  @note Syscall number 0x22.
##

proc svcSendAsyncRequestWithUserBuffer*(handle: ptr Handle; usrBuffer: pointer;
                                       size: U64; session: Handle): Result {.cdecl,
    importc: "svcSendAsyncRequestWithUserBuffer".}
## *
##  @brief Sends an IPC synchronization request to a session from an user allocated buffer (asynchronous version).
##  @return Result code.
##  @remark size must be allocated to 0x1000 bytes.
##  @note Syscall number 0x23.
##

proc svcGetProcessId*(processID: ptr U64; handle: Handle): Result {.cdecl,
    importc: "svcGetProcessId".}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Gets the PID associated with a process.
##  @return Result code.
##  @note Syscall number 0x24.
##

proc svcGetThreadId*(threadID: ptr U64; handle: Handle): Result {.cdecl,
    importc: "svcGetThreadId".}
## *
##  @brief Gets the TID associated with a process.
##  @return Result code.
##  @note Syscall number 0x25.

proc svcBreak*(breakReason: U32; address: uintptrT; size: uintptrT): Result {.cdecl,
    importc: "svcBreak".}
## /@}
## /@name Miscellaneous
## /@{
## *
##  @brief Breaks execution.
##  @param[in] breakReason Break reason (see \ref BreakReason).
##  @param[in] address Address of the buffer to pass to the debugger.
##  @param[in] size Size of the buffer to pass to the debugger.
##  @return Result code.
##  @note Syscall number 0x26.
##

proc svcOutputDebugString*(str: cstring; size: U64): Result {.cdecl,
    importc: "svcOutputDebugString".}
## /@}
## /@name Debugging
## /@{
## *
##  @brief Outputs debug text, if used during debugging.
##  @param[in] str Text to output.
##  @param[in] size Size of the text in bytes.
##  @return Result code.
##  @note Syscall number 0x27.
##

proc svcReturnFromException*(res: Result) {.cdecl, importc: "svcReturnFromException".}
## /@}
## /@name Miscellaneous
## /@{
## *
##  @brief Returns from an exception.
##  @param[in] res Result code.
##  @note Syscall number 0x28.
##

proc svcGetInfo*(`out`: ptr U64; id0: U32; handle: Handle; id1: U64): Result {.cdecl,
    importc: "svcGetInfo".}
## *
##  @brief Retrieves information about the system, or a certain kernel object.
##  @param[out] out Variable to which store the information.
##  @param[in] id0 First ID of the property to retrieve.
##  @param[in] handle Handle of the object to retrieve information from, or \ref INVALID_HANDLE to retrieve information about the system.
##  @param[in] id1 Second ID of the property to retrieve.
##  @return Result code.
##  @remark The full list of property IDs can be found on the <a href="https://switchbrew.org/wiki/SVC#svcGetInfo">switchbrew.org wiki</a>.
##  @note Syscall number 0x29.
##

proc svcFlushEntireDataCache*() {.cdecl, importc: "svcFlushEntireDataCache".}
## /@}
## /@name Cache Management
## /@{
## *
##  @brief Flushes the entire data cache (by set/way).
##  @note Syscall number 0x2A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##  @warning This syscall is dangerous, and should not be used.
##

proc svcFlushDataCache*(address: pointer; size: csize_t): Result {.cdecl,
    importc: "svcFlushDataCache".}
## *
##  @brief Flushes data cache for a virtual address range.
##  @param[in] address Address of region to flush.
##  @param[in] size Size of region to flush.
##  @remark armDCacheFlush should be used instead of this syscall whenever possible.
##  @note Syscall number 0x2B.
##

proc svcMapPhysicalMemory*(address: pointer; size: U64): Result {.cdecl,
    importc: "svcMapPhysicalMemory".}
## /@}
## /@name Memory management
## /@{
## *
##  @brief Maps new heap memory at the desired address. [3.0.0+]
##  @return Result code.
##  @note Syscall number 0x2C.
##

proc svcUnmapPhysicalMemory*(address: pointer; size: U64): Result {.cdecl,
    importc: "svcUnmapPhysicalMemory".}
## *
##  @brief Undoes the effects of \ref svcMapPhysicalMemory. [3.0.0+]
##  @return Result code.
##  @note Syscall number 0x2D.
##

proc svcGetDebugFutureThreadInfo*(outContext: ptr LastThreadContext;
                                 outThreadId: ptr U64; debug: Handle; ns: S64): Result {.
    cdecl, importc: "svcGetDebugFutureThreadInfo".}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Gets information about a thread that will be scheduled in the future. [5.0.0+]
##  @param[out] out_context Output \ref LastThreadContext for the thread that will be scheduled.
##  @param[out] out_thread_id Output thread id for the thread that will be scheduled.
##  @param[in] debug Debug handle.
##  @param[in] ns Nanoseconds in the future to get scheduled thread at.
##  @return Result code.
##  @note Syscall number 0x2E.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcGetLastThreadInfo*(outContext: ptr LastThreadContext;
                          outTlsAddress: ptr U64; outFlags: ptr U32): Result {.cdecl,
    importc: "svcGetLastThreadInfo".}
## *
##  @brief Gets information about the previously-scheduled thread.
##  @param[out] out_context Output \ref LastThreadContext for the previously scheduled thread.
##  @param[out] out_tls_address Output tls address for the previously scheduled thread.
##  @param[out] out_flags Output flags for the previously scheduled thread.
##  @return Result code.
##  @note Syscall number 0x2F.
##

proc svcGetResourceLimitLimitValue*(`out`: ptr S64; reslimitH: Handle;
                                   which: LimitableResource): Result {.cdecl,
    importc: "svcGetResourceLimitLimitValue".}
## /@}
## /@name Resource Limit Management
## /@{
## *
##  @brief Gets the maximum value a LimitableResource can have, for a Resource Limit handle.
##  @return Result code.
##  @note Syscall number 0x30.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcGetResourceLimitCurrentValue*(`out`: ptr S64; reslimitH: Handle;
                                     which: LimitableResource): Result {.cdecl,
    importc: "svcGetResourceLimitCurrentValue".}
## *
##  @brief Gets the maximum value a LimitableResource can have, for a Resource Limit handle.
##  @return Result code.
##  @note Syscall number 0x31.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcSetThreadActivity*(thread: Handle; paused: ThreadActivity): Result {.cdecl,
    importc: "svcSetThreadActivity".}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Configures the pause/unpause status of a thread.
##  @return Result code.
##  @note Syscall number 0x32.
##

proc svcGetThreadContext3*(ctx: ptr ThreadContext; thread: Handle): Result {.cdecl,
    importc: "svcGetThreadContext3".}
## *
##  @brief Dumps the registers of a thread paused by @ref svcSetThreadActivity (register groups: all).
##  @param[out] ctx Output thread context (register dump).
##  @param[in] thread Thread handle.
##  @return Result code.
##  @note Syscall number 0x33.
##  @warning Official kernel will not dump x0..x18 if the thread is currently executing a system call, and prior to 6.0.0 doesn't dump TPIDR_EL0.
##

proc svcWaitForAddress*(address: pointer; arbType: U32; value: S32; timeout: S64): Result {.
    cdecl, importc: "svcWaitForAddress".}
## /@}
## /@name Synchronization
## /@{
## *
##  @brief Arbitrates an address depending on type and value. [4.0.0+]
##  @param[in] address Address to arbitrate.
##  @param[in] arb_type \ref ArbitrationType to use.
##  @param[in] value Value to arbitrate on.
##  @param[in] timeout Maximum time in nanoseconds to wait.
##  @return Result code.
##  @note Syscall number 0x34.
##

proc svcSignalToAddress*(address: pointer; signalType: U32; value: S32; count: S32): Result {.
    cdecl, importc: "svcSignalToAddress".}
## *
##  @brief Signals (and updates) an address depending on type and value. [4.0.0+]
##  @param[in] address Address to arbitrate.
##  @param[in] signal_type \ref SignalType to use.
##  @param[in] value Value to arbitrate on.
##  @param[in] count Number of waiting threads to signal.
##  @return Result code.
##  @note Syscall number 0x35.
##

proc svcSynchronizePreemptionState*() {.cdecl,
                                      importc: "svcSynchronizePreemptionState".}
## /@}
## /@name Miscellaneous
## /@{
## *
##  @brief Sets thread preemption state (used during abort/panic). [8.0.0+]
##  @note Syscall number 0x36.
##

proc svcGetResourceLimitPeakValue*(`out`: ptr S64; reslimitH: Handle;
                                  which: LimitableResource): Result {.cdecl,
    importc: "svcGetResourceLimitPeakValue".}
## /@}
## /@name Resource Limit Management
## /@{
## *
##  @brief Gets the peak value a LimitableResource has had, for a Resource Limit handle. [11.0.0+]
##  @return Result code.
##  @note Syscall number 0x37.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreateIoPool*(outHandle: ptr Handle; poolType: U32): Result {.cdecl,
    importc: "svcCreateIoPool".}
## /@}
## /@name Memory Management
## /@{
## *
##  @brief Creates an IO Pool. [13.0.0+]
##  @return Result code.
##  @note Syscall number 0x39.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreateIoRegion*(outHandle: ptr Handle; ioPoolH: Handle; physicalAddress: U64;
                       size: U64; memoryMapping: U32; perm: U32): Result {.cdecl,
    importc: "svcCreateIoRegion".}
## *
##  @brief Creates an IO Region. [13.0.0+]
##  @return Result code.
##  @note Syscall number 0x3A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcDumpInfo*(dumpInfoType: U32; arg0: U64) {.cdecl, importc: "svcDumpInfo".}
## /@}
## /@name Debugging
## /@{
## *
##  @brief Causes the kernel to dump debug information. [1.0.0-3.0.2]
##  @param[in] dump_info_type Type of information to dump.
##  @param[in] arg0 Argument to the debugging operation.
##  @note Syscall number 0x3C.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcKernelDebug*(kernDebugType: U32; arg0: U64; arg1: U64; arg2: U64) {.cdecl,
    importc: "svcKernelDebug".}
## *
##  @brief Performs a debugging operation on the kernel. [4.0.0+]
##  @param[in] kern_debug_type Type of debugging operation to perform.
##  @param[in] arg0 First argument to the debugging operation.
##  @param[in] arg1 Second argument to the debugging operation.
##  @param[in] arg2 Third argument to the debugging operation.
##  @note Syscall number 0x3C.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcChangeKernelTraceState*(kernTraceState: U32) {.cdecl,
    importc: "svcChangeKernelTraceState".}
## *
##  @brief Performs a debugging operation on the kernel. [4.0.0+]
##  @param[in] kern_trace_state Type of tracing the kernel should perform.
##  @note Syscall number 0x3D.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreateSession*(serverHandle: ptr Handle; clientHandle: ptr Handle; unk0: U32;
                      unk1: U64): Result {.cdecl, importc: "svcCreateSession".}
## /@}
## /@name Inter-process communication (IPC)
## /@{
## *
##  @brief Creates an IPC session.
##  @return Result code.
##  @note Syscall number 0x40.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcAcceptSession*(sessionHandle: ptr Handle; portHandle: Handle): Result {.cdecl,
    importc: "svcAcceptSession".}
## unk* are normally 0?
## *
##  @brief Accepts an IPC session.
##  @return Result code.
##  @note Syscall number 0x41.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcReplyAndReceiveLight*(handle: Handle): Result {.cdecl,
    importc: "svcReplyAndReceiveLight".}
## *
##  @brief Performs light IPC input/output.
##  @return Result code.
##  @param[in] handle Server or port handle to act on.
##  @note Syscall number 0x42.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcReplyAndReceive*(index: ptr S32; handles: ptr Handle; handleCount: S32;
                        replyTarget: Handle; timeout: U64): Result {.cdecl,
    importc: "svcReplyAndReceive".}
## *
##  @brief Performs IPC input/output.
##  @return Result code.
##  @note Syscall number 0x43.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcReplyAndReceiveWithUserBuffer*(index: ptr S32; usrBuffer: pointer; size: U64;
                                      handles: ptr Handle; handleCount: S32;
                                      replyTarget: Handle; timeout: U64): Result {.
    cdecl, importc: "svcReplyAndReceiveWithUserBuffer".}
## *
##  @brief Performs IPC input/output from an user allocated buffer.
##  @return Result code.
##  @note Syscall number 0x44.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreateEvent*(serverHandle: ptr Handle; clientHandle: ptr Handle): Result {.
    cdecl, importc: "svcCreateEvent".}
## /@}
## /@name Synchronization
## /@{
## *
##  @brief Creates a system event.
##  @return Result code.
##  @note Syscall number 0x45.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcMapIoRegion*(ioRegionH: Handle; address: pointer; size: U64; perm: U32): Result {.
    cdecl, importc: "svcMapIoRegion".}
## /@}
## /@name Memory management
## /@{
## *
##  @brief Maps an IO Region. [13.0.0+]
##  @return Result code.
##  @note Syscall number 0x46.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcUnmapIoRegion*(ioRegionH: Handle; address: pointer; size: U64): Result {.cdecl,
    importc: "svcUnmapIoRegion".}
## *
##  @brief Undoes the effects of \ref svcMapIoRegion. [13.0.0+]
##  @return Result code.
##  @note Syscall number 0x47.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcMapPhysicalMemoryUnsafe*(address: pointer; size: U64): Result {.cdecl,
    importc: "svcMapPhysicalMemoryUnsafe".}
## *
##  @brief Maps unsafe memory (usable for GPU DMA) for a system module at the desired address. [5.0.0+]
##  @return Result code.
##  @note Syscall number 0x48.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcUnmapPhysicalMemoryUnsafe*(address: pointer; size: U64): Result {.cdecl,
    importc: "svcUnmapPhysicalMemoryUnsafe".}
## *
##  @brief Undoes the effects of \ref svcMapPhysicalMemoryUnsafe. [5.0.0+]
##  @return Result code.
##  @note Syscall number 0x49.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcSetUnsafeLimit*(size: U64): Result {.cdecl, importc: "svcSetUnsafeLimit".}
## *
##  @brief Sets the system-wide limit for unsafe memory mappable using \ref svcMapPhysicalMemoryUnsafe. [5.0.0+]
##  @return Result code.
##  @note Syscall number 0x4A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreateCodeMemory*(codeHandle: ptr Handle; srcAddr: pointer; size: U64): Result {.
    cdecl, importc: "svcCreateCodeMemory".}
## /@}
## /@name Code memory / Just-in-time (JIT) compilation support
## /@{
## *
##  @brief Creates code memory in the caller's address space [4.0.0+].
##  @return Result code.
##  @note Syscall number 0x4B.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcControlCodeMemory*(codeHandle: Handle; op: CodeMapOperation;
                          dstAddr: pointer; size: U64; perm: U64): Result {.cdecl,
    importc: "svcControlCodeMemory".}
## *
##  @brief Maps code memory in the caller's address space [4.0.0+].
##  @return Result code.
##  @note Syscall number 0x4C.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcSleepSystem*() {.cdecl, importc: "svcSleepSystem".}
## /@}
## /@name Power Management
## /@{
## *
##  @brief Causes the system to enter deep sleep.
##  @note Syscall number 0x4D.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcReadWriteRegister*(outVal: ptr U32; regAddr: U64; rwMask: U32; inVal: U32): Result {.
    cdecl, importc: "svcReadWriteRegister".}
## /@}
## /@name Device memory-mapped I/O (MMIO)
## /@{
## *
##  @brief Reads/writes a protected MMIO register.
##  @return Result code.
##  @note Syscall number 0x4E.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcSetProcessActivity*(process: Handle; paused: ProcessActivity): Result {.cdecl,
    importc: "svcSetProcessActivity".}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Configures the pause/unpause status of a process.
##  @return Result code.
##  @note Syscall number 0x4F.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreateSharedMemory*(`out`: ptr Handle; size: csize_t; localPerm: U32;
                           otherPerm: U32): Result {.cdecl,
    importc: "svcCreateSharedMemory".}
## /@}
## /@name Inter-process memory sharing
## /@{
## *
##  @brief Creates a block of shared memory.
##  @return Result code.
##  @note Syscall number 0x50.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcMapTransferMemory*(tmemHandle: Handle; `addr`: pointer; size: csize_t;
                          perm: U32): Result {.cdecl,
    importc: "svcMapTransferMemory".}
## *
##  @brief Maps a block of transfer memory.
##  @return Result code.
##  @note Syscall number 0x51.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcUnmapTransferMemory*(tmemHandle: Handle; `addr`: pointer; size: csize_t): Result {.
    cdecl, importc: "svcUnmapTransferMemory".}
## *
##  @brief Unmaps a block of transfer memory.
##  @return Result code.
##  @note Syscall number 0x52.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreateInterruptEvent*(handle: ptr Handle; irqNum: U64; flag: U32): Result {.
    cdecl, importc: "svcCreateInterruptEvent".}
## /@}
## /@name Device memory-mapped I/O (MMIO)
## /@{
## *
##  @brief Creates an event and binds it to a specific hardware interrupt.
##  @return Result code.
##  @note Syscall number 0x53.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcQueryPhysicalAddress*(`out`: ptr PhysicalMemoryInfo; virtaddr: U64): Result {.
    cdecl, importc: "svcQueryPhysicalAddress".}
## *
##  @brief Queries information about a certain virtual address, including its physical address.
##  @return Result code.
##  @note Syscall number 0x54.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcQueryIoMapping*(virtaddr: ptr U64; outSize: ptr U64; physaddr: U64; size: U64): Result {.
    cdecl, importc: "svcQueryIoMapping".}
## *
##  @brief Returns a virtual address mapped to a given IO range.
##  @return Result code.
##  @note Syscall number 0x55.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##  @warning Only exists on [10.0.0+]. For older versions use \ref svcLegacyQueryIoMapping.
##

proc svcLegacyQueryIoMapping*(virtaddr: ptr U64; physaddr: U64; size: U64): Result {.
    cdecl, importc: "svcLegacyQueryIoMapping".}
## *
##  @brief Returns a virtual address mapped to a given IO range.
##  @return Result code.
##  @note Syscall number 0x55.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##  @warning Only exists on [1.0.0-9.2.0]. For newer versions use \ref svcQueryIoMapping.
##

proc svcCreateDeviceAddressSpace*(handle: ptr Handle; devAddr: U64; devSize: U64): Result {.
    cdecl, importc: "svcCreateDeviceAddressSpace".}
## /@}
## /@name I/O memory management unit (IOMMU)
## /@{
## *
##  @brief Creates a virtual address space for binding device address spaces.
##  @return Result code.
##  @note Syscall number 0x56.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcAttachDeviceAddressSpace*(device: U64; handle: Handle): Result {.cdecl,
    importc: "svcAttachDeviceAddressSpace".}
## *
##  @brief Attaches a device address space to a device.
##  @return Result code.
##  @note Syscall number 0x57.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcDetachDeviceAddressSpace*(device: U64; handle: Handle): Result {.cdecl,
    importc: "svcDetachDeviceAddressSpace".}
## *
##  @brief Detaches a device address space from a device.
##  @return Result code.
##  @note Syscall number 0x58.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcMapDeviceAddressSpaceByForce*(handle: Handle; procHandle: Handle;
                                     mapAddr: U64; devSize: U64; devAddr: U64;
                                     option: U32): Result {.cdecl,
    importc: "svcMapDeviceAddressSpaceByForce".}
## *
##  @brief Maps an attached device address space to an userspace address.
##  @return Result code.
##  @remark The userspace destination address must have the \ref MemState_MapDeviceAllowed bit set.
##  @note Syscall number 0x59.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcMapDeviceAddressSpaceAligned*(handle: Handle; procHandle: Handle;
                                     mapAddr: U64; devSize: U64; devAddr: U64;
                                     option: U32): Result {.cdecl,
    importc: "svcMapDeviceAddressSpaceAligned".}
## *
##  @brief Maps an attached device address space to an userspace address.
##  @return Result code.
##  @remark The userspace destination address must have the \ref MemState_MapDeviceAlignedAllowed bit set.
##  @note Syscall number 0x5A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcMapDeviceAddressSpace*(outMappedSize: ptr U64; handle: Handle;
                              procHandle: Handle; mapAddr: U64; devSize: U64;
                              devAddr: U64; perm: U32): Result {.cdecl,
    importc: "svcMapDeviceAddressSpace".}
## *
##  @brief Maps an attached device address space to an userspace address. [1.0.0-12.1.0]
##  @return Result code.
##  @remark The userspace destination address must have the \ref MemState_MapDeviceAlignedAllowed bit set.
##  @note Syscall number 0x5B.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcUnmapDeviceAddressSpace*(handle: Handle; procHandle: Handle; mapAddr: U64;
                                mapSize: U64; devAddr: U64): Result {.cdecl,
    importc: "svcUnmapDeviceAddressSpace".}
## *
##  @brief Unmaps an attached device address space from an userspace address.
##  @return Result code.
##  @note Syscall number 0x5C.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcInvalidateProcessDataCache*(process: Handle; address: uintptrT; size: csize_t): Result {.
    cdecl, importc: "svcInvalidateProcessDataCache".}
## /@}
## /@name Cache Management
## /@{
## *
##  @brief Invalidates data cache for a virtual address range within a process.
##  @param[in] address Address of region to invalidate.
##  @param[in] size Size of region to invalidate.
##  @note Syscall number 0x5D.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcStoreProcessDataCache*(process: Handle; address: uintptrT; size: csize_t): Result {.
    cdecl, importc: "svcStoreProcessDataCache".}
## *
##  @brief Stores data cache for a virtual address range within a process.
##  @param[in] address Address of region to store.
##  @param[in] size Size of region to store.
##  @note Syscall number 0x5E.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcFlushProcessDataCache*(process: Handle; address: uintptrT; size: csize_t): Result {.
    cdecl, importc: "svcFlushProcessDataCache".}
## *
##  @brief Flushes data cache for a virtual address range within a process.
##  @param[in] address Address of region to flush.
##  @param[in] size Size of region to flush.
##  @note Syscall number 0x5F.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcDebugActiveProcess*(debug: ptr Handle; processID: U64): Result {.cdecl,
    importc: "svcDebugActiveProcess".}
## /@}
## /@name Debugging
## /@{
## *
##  @brief Debugs an active process.
##  @return Result code.
##  @note Syscall number 0x60.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcBreakDebugProcess*(debug: Handle): Result {.cdecl,
    importc: "svcBreakDebugProcess".}
## *
##  @brief Breaks an active debugging session.
##  @return Result code.
##  @note Syscall number 0x61.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcTerminateDebugProcess*(debug: Handle): Result {.cdecl,
    importc: "svcTerminateDebugProcess".}
## *
##  @brief Terminates the process of an active debugging session.
##  @return Result code.
##  @note Syscall number 0x62.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcGetDebugEvent*(eventOut: pointer; debug: Handle): Result {.cdecl,
    importc: "svcGetDebugEvent".}
## *
##  @brief Gets an incoming debug event from a debugging session.
##  @return Result code.
##  @note Syscall number 0x63.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcContinueDebugEvent*(debug: Handle; flags: U32; tidList: ptr U64; numTids: U32): Result {.
    cdecl, importc: "svcContinueDebugEvent".}
## *
##  @brief Continues a debugging session.
##  @return Result code.
##  @note Syscall number 0x64.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##  @warning Only exists on [3.0.0+]. For older versions use \ref svcLegacyContinueDebugEvent.
##

proc svcLegacyContinueDebugEvent*(debug: Handle; flags: U32; threadID: U64): Result {.
    cdecl, importc: "svcLegacyContinueDebugEvent".}
## *
##  @brief Continues a debugging session.
##  @return Result code.
##  @note Syscall number 0x64.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##  @warning Only exists on [1.0.0-2.3.0]. For newer versions use \ref svcContinueDebugEvent.
##

proc svcGetDebugThreadContext*(ctx: ptr ThreadContext; debug: Handle; threadID: U64;
                              flags: U32): Result {.cdecl,
    importc: "svcGetDebugThreadContext".}
## *
##  @brief Gets the context (dump the registers) of a thread in a debugging session.
##  @return Result code.
##  @param[out] ctx Output thread context (register dump).
##  @param[in] debug Debug handle.
##  @param[in] threadID ID of the thread to dump the context of.
##  @param[in] flags Register groups to select, combination of @ref RegisterGroup flags.
##  @note Syscall number 0x67.
##  @warning Official kernel will not dump any CPU GPR if the thread is currently executing a system call (except @ref svcBreak and @ref svcReturnFromException).
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcSetDebugThreadContext*(debug: Handle; threadID: U64; ctx: ptr ThreadContext;
                              flags: U32): Result {.cdecl,
    importc: "svcSetDebugThreadContext".}
## *
##  @brief Gets the context (dump the registers) of a thread in a debugging session.
##  @return Result code.
##  @param[in] debug Debug handle.
##  @param[in] threadID ID of the thread to set the context of.
##  @param[in] ctx Input thread context (register dump).
##  @param[in] flags Register groups to select, combination of @ref RegisterGroup flags.
##  @note Syscall number 0x68.
##  @warning Official kernel will return an error if the thread is currently executing a system call (except @ref svcBreak and @ref svcReturnFromException).
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcGetProcessList*(numOut: ptr S32; pidsOut: ptr U64; maxPids: U32): Result {.cdecl,
    importc: "svcGetProcessList".}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Retrieves a list of all running processes.
##  @return Result code.
##  @note Syscall number 0x65.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcGetThreadList*(numOut: ptr S32; tidsOut: ptr U64; maxTids: U32; debug: Handle): Result {.
    cdecl, importc: "svcGetThreadList".}
## *
##  @brief Retrieves a list of all threads for a debug handle (or zero).
##  @return Result code.
##  @note Syscall number 0x66.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcQueryDebugProcessMemory*(meminfoPtr: ptr MemoryInfo; pageinfo: ptr U32;
                                debug: Handle; `addr`: U64): Result {.cdecl,
    importc: "svcQueryDebugProcessMemory".}
## /@}
## /@name Debugging
## /@{
## *
##  @brief Queries memory information from a process that is being debugged.
##  @return Result code.
##  @note Syscall number 0x69.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcReadDebugProcessMemory*(buffer: pointer; debug: Handle; `addr`: U64; size: U64): Result {.
    cdecl, importc: "svcReadDebugProcessMemory".}
## *
##  @brief Reads memory from a process that is being debugged.
##  @return Result code.
##  @note Syscall number 0x6A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcWriteDebugProcessMemory*(debug: Handle; buffer: pointer; `addr`: U64; size: U64): Result {.
    cdecl, importc: "svcWriteDebugProcessMemory".}
## *
##  @brief Writes to memory in a process that is being debugged.
##  @return Result code.
##  @note Syscall number 0x6B.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcSetHardwareBreakPoint*(which: U32; flags: U64; value: U64): Result {.cdecl,
    importc: "svcSetHardwareBreakPoint".}
## *
##  @brief Sets one of the hardware breakpoints.
##  @return Result code.
##  @note Syscall number 0x6C.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcGetDebugThreadParam*(out64: ptr U64; out32: ptr U32; debug: Handle;
                            threadID: U64; param: DebugThreadParam): Result {.cdecl,
    importc: "svcGetDebugThreadParam".}
## *
##  @brief Gets parameters from a thread in a debugging session.
##  @return Result code.
##  @note Syscall number 0x6D.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcGetSystemInfo*(`out`: ptr U64; id0: U64; handle: Handle; id1: U64): Result {.cdecl,
    importc: "svcGetSystemInfo".}
## /@}
## /@name Miscellaneous
## /@{
## *
##  @brief Retrieves privileged information about the system, or a certain kernel object.
##  @param[out] out Variable to which store the information.
##  @param[in] id0 First ID of the property to retrieve.
##  @param[in] handle Handle of the object to retrieve information from, or \ref INVALID_HANDLE to retrieve information about the system.
##  @param[in] id1 Second ID of the property to retrieve.
##  @return Result code.
##  @remark The full list of property IDs can be found on the <a href="https://switchbrew.org/wiki/SVC#svcGetSystemInfo">switchbrew.org wiki</a>.
##  @note Syscall number 0x6F.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreatePort*(portServer: ptr Handle; portClient: ptr Handle; maxSessions: S32;
                   isLight: bool; name: cstring): Result {.cdecl,
    importc: "svcCreatePort".}
## /@}
## /@name Inter-process communication (IPC)
## /@{
## *
##  @brief Creates a port.
##  @return Result code.
##  @note Syscall number 0x70.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcManageNamedPort*(portServer: ptr Handle; name: cstring; maxSessions: S32): Result {.
    cdecl, importc: "svcManageNamedPort".}
## *
##  @brief Manages a named port.
##  @return Result code.
##  @note Syscall number 0x71.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcConnectToPort*(session: ptr Handle; port: Handle): Result {.cdecl,
    importc: "svcConnectToPort".}
## *
##  @brief Manages a named port.
##  @return Result code.
##  @note Syscall number 0x72.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcSetProcessMemoryPermission*(`proc`: Handle; `addr`: U64; size: U64; perm: U32): Result {.
    cdecl, importc: "svcSetProcessMemoryPermission".}
## /@}
## /@name Memory management
## /@{
## *
##  @brief Sets the memory permissions for the specified memory with the supplied process handle.
##  @param[in] proc Process handle.
##  @param[in] addr Address of the memory.
##  @param[in] size Size of the memory.
##  @param[in] perm Permissions (see \ref Permission).
##  @return Result code.
##  @remark This returns an error (0xD801) when \p perm is >0x5, hence -WX and RWX are not allowed.
##  @note Syscall number 0x73.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcMapProcessMemory*(dst: pointer; `proc`: Handle; src: U64; size: U64): Result {.
    cdecl, importc: "svcMapProcessMemory".}
## *
##  @brief Maps the src address from the supplied process handle into the current process.
##  @param[in] dst Address to which map the memory in the current process.
##  @param[in] proc Process handle.
##  @param[in] src Source mapping address.
##  @param[in] size Size of the memory.
##  @return Result code.
##  @remark This allows mapping code and rodata with RW- permission.
##  @note Syscall number 0x74.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcUnmapProcessMemory*(dst: pointer; `proc`: Handle; src: U64; size: U64): Result {.
    cdecl, importc: "svcUnmapProcessMemory".}
## *
##  @brief Undoes the effects of \ref svcMapProcessMemory.
##  @param[in] dst Destination mapping address
##  @param[in] proc Process handle.
##  @param[in] src Address of the memory in the process.
##  @param[in] size Size of the memory.
##  @return Result code.
##  @remark This allows mapping code and rodata with RW- permission.
##  @note Syscall number 0x75.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcQueryProcessMemory*(meminfoPtr: ptr MemoryInfo; pageinfo: ptr U32;
                           `proc`: Handle; `addr`: U64): Result {.cdecl,
    importc: "svcQueryProcessMemory".}
## *
##  @brief Equivalent to \ref svcQueryMemory, for another process.
##  @param[out] meminfo_ptr \ref MemoryInfo structure which will be filled in.
##  @param[out] pageinfo Page information which will be filled in.
##  @param[in] proc Process handle.
##  @param[in] addr Address to query.
##  @return Result code.
##  @note Syscall number 0x76.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcMapProcessCodeMemory*(`proc`: Handle; dst: U64; src: U64; size: U64): Result {.
    cdecl, importc: "svcMapProcessCodeMemory".}
## *
##  @brief Maps normal heap in a certain process as executable code (used when loading NROs).
##  @param[in] proc Process handle (cannot be \ref CUR_PROCESS_HANDLE).
##  @param[in] dst Destination mapping address.
##  @param[in] src Source mapping address.
##  @param[in] size Size of the mapping.
##  @return Result code.
##  @note Syscall number 0x77.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcUnmapProcessCodeMemory*(`proc`: Handle; dst: U64; src: U64; size: U64): Result {.
    cdecl, importc: "svcUnmapProcessCodeMemory".}
## *
##  @brief Undoes the effects of \ref svcMapProcessCodeMemory.
##  @param[in] proc Process handle (cannot be \ref CUR_PROCESS_HANDLE).
##  @param[in] dst Destination mapping address.
##  @param[in] src Source mapping address.
##  @param[in] size Size of the mapping.
##  @return Result code.
##  @note Syscall number 0x78.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreateProcess*(`out`: ptr Handle; procInfo: pointer; caps: ptr U32; capNum: U64): Result {.
    cdecl, importc: "svcCreateProcess".}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Creates a new process.
##  @return Result code.
##  @note Syscall number 0x79.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcStartProcess*(`proc`: Handle; mainPrio: S32; defaultCpu: S32; stackSize: U32): Result {.
    cdecl, importc: "svcStartProcess".}
## *
##  @brief Starts executing a freshly created process.
##  @return Result code.
##  @note Syscall number 0x7A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcTerminateProcess*(`proc`: Handle): Result {.cdecl,
    importc: "svcTerminateProcess".}
## *
##  @brief Terminates a running process.
##  @return Result code.
##  @note Syscall number 0x7B.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcGetProcessInfo*(`out`: ptr S64; `proc`: Handle; which: ProcessInfoType): Result {.
    cdecl, importc: "svcGetProcessInfo".}
## *
##  @brief Gets a \ref ProcessInfoType for a process.
##  @return Result code.
##  @note Syscall number 0x7C.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCreateResourceLimit*(`out`: ptr Handle): Result {.cdecl,
    importc: "svcCreateResourceLimit".}
## /@}
## /@name Resource Limit Management
## /@{
## *
##  @brief Creates a new Resource Limit handle.
##  @return Result code.
##  @note Syscall number 0x7D.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcSetResourceLimitLimitValue*(reslimit: Handle; which: LimitableResource;
                                   value: U64): Result {.cdecl,
    importc: "svcSetResourceLimitLimitValue".}
## *
##  @brief Sets the value for a \ref LimitableResource for a Resource Limit handle.
##  @return Result code.
##  @note Syscall number 0x7E.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcCallSecureMonitor*(regs: ptr SecmonArgs) {.cdecl,
    importc: "svcCallSecureMonitor".}
## /@}
## /@name ( ͡° ͜ʖ ͡°)
## /@{
## *
##  @brief Calls a secure monitor function (TrustZone, EL3).
##  @param regs Arguments to pass to the secure monitor.
##  @note Syscall number 0x7F.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
##

proc svcMapInsecureMemory*(address: pointer; size: U64): Result {.cdecl,
    importc: "svcMapInsecureMemory".}
## /@}
## /@name Memory management
## /@{
## *
##  @brief Maps new insecure memory at the desired address. [15.0.0+]
##  @return Result code.
##  @note Syscall number 0x90.
##

proc svcUnmapInsecureMemory*(address: pointer; size: U64): Result {.cdecl,
    importc: "svcUnmapInsecureMemory".}
## *
##  @brief Undoes the effects of \ref svcMapInsecureMemory. [15.0.0+]
##  @return Result code.
##  @note Syscall number 0x91.
##
