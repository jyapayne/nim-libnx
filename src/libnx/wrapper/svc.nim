import strutils
import ospaths
const headersvc = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/svc.h"
## *
##  @file svc.h
##  @brief Wrappers for kernel syscalls.
##  @copyright libnx Authors
## 

import
  libnx/wrapper/types

## / Pseudo handle for the current process.

const
  CUR_PROCESS_HANDLE* = 0xFFFF8001

## / Pseudo handle for the current thread.

const
  CUR_THREAD_HANDLE* = 0xFFFF8000

## / Memory type enumeration (lower 8 bits of \ref MemoryState)

import libnx/wrapper/types
type
  MemoryType* {.size: sizeof(cint).} = enum
    MemType_Unmapped = 0x00000000, ## /< Unmapped memory.
    MemType_Io = 0x00000001,    ## /< Mapped by kernel capability parsing in \ref svcCreateProcess.
    MemType_Normal = 0x00000002, ## /< Mapped by kernel capability parsing in \ref svcCreateProcess.
    MemType_CodeStatic = 0x00000003, ## /< Mapped during \ref svcCreateProcess.
    MemType_CodeMutable = 0x00000004, ## /< Transition from MemType_CodeStatic performed by \ref svcSetProcessMemoryPermission.
    MemType_Heap = 0x00000005,  ## /< Mapped using \ref svcSetHeapSize.
    MemType_SharedMem = 0x00000006, ## /< Mapped using \ref svcMapSharedMemory.
    MemType_WeirdMappedMem = 0x00000007, ## /< Mapped using \ref svcMapMemory.
    MemType_ModuleCodeStatic = 0x00000008, ## /< Mapped using \ref svcMapProcessCodeMemory.
    MemType_ModuleCodeMutable = 0x00000009, ## /< Transition from \ref MemType_ModuleCodeStatic performed by \ref svcSetProcessMemoryPermission.
    MemType_IpcBuffer0 = 0x0000000A, ## /< IPC buffers with descriptor flags=0.
    MemType_MappedMemory = 0x0000000B, ## /< Mapped using \ref svcMapMemory.
    MemType_ThreadLocal = 0x0000000C, ## /< Mapped during \ref svcCreateThread.
    MemType_TransferMemIsolated = 0x0000000D, ## /< Mapped using \ref svcMapTransferMemory when the owning process has perm=0.
    MemType_TransferMem = 0x0000000E, ## /< Mapped using \ref svcMapTransferMemory when the owning process has perm!=0.
    MemType_ProcessMem = 0x0000000F, ## /< Mapped using \ref svcMapProcessMemory.
    MemType_Reserved = 0x00000010, ## /< Reserved.
    MemType_IpcBuffer1 = 0x00000011, ## /< IPC buffers with descriptor flags=1.
    MemType_IpcBuffer3 = 0x00000012, ## /< IPC buffers with descriptor flags=3.
    MemType_KernelStack = 0x00000013, ## /< Mapped in kernel during \ref svcCreateThread.
    MemType_CodeReadOnly = 0x00000014, ## /< Mapped in kernel during \ref svcControlCodeMemory.
    MemType_CodeWritable = 0x00000015 ## /< Mapped in kernel during \ref svcControlCodeMemory.


## / Memory state bitmasks.

type
  MemoryState* {.size: sizeof(cint).} = enum
    MemState_Type = 0x000000FF, ## /< Type field (see \ref MemoryType).
    MemState_PermChangeAllowed = BIT(8), ## /< Permission change allowed.
    MemState_ForceRwByDebugSyscalls = BIT(9), ## /< Force read/writable by debug syscalls.
    MemState_IpcSendAllowed_Type0 = BIT(10), ## /< IPC type 0 send allowed.
    MemState_IpcSendAllowed_Type3 = BIT(11), ## /< IPC type 3 send allowed.
    MemState_IpcSendAllowed_Type1 = BIT(12), ## /< IPC type 1 send allowed.
    MemState_ProcessPermChangeAllowed = BIT(14), ## /< Process permission change allowed.
    MemState_MapAllowed = BIT(15), ## /< Map allowed.
    MemState_UnmapProcessCodeMemAllowed = BIT(16), ## /< Unmap process code memory allowed.
    MemState_TransferMemAllowed = BIT(17), ## /< Transfer memory allowed.
    MemState_QueryPAddrAllowed = BIT(18), ## /< Query physical address allowed.
    MemState_MapDeviceAllowed = BIT(19), ## /< Map device allowed (\ref svcMapDeviceAddressSpace and \ref svcMapDeviceAddressSpaceByForce).
    MemState_MapDeviceAlignedAllowed = BIT(20), ## /< Map device aligned allowed.
    MemState_IpcBufferAllowed = BIT(21), ## /< IPC buffer allowed.
    MemState_IsPoolAllocated = BIT(22), ## /< Is pool allocated.
    MemState_MapProcessAllowed = BIT(23), ## /< Map process allowed.
    MemState_AttrChangeAllowed = BIT(24), ## /< Attribute change allowed.
    MemState_CodeMemAllowed = BIT(25) ## /< Code memory allowed.

const
  MemState_IsRefCounted = MemState_IsPoolAllocated

## / Memory attribute bitmasks.

type
  MemoryAttribute* {.size: sizeof(cint).} = enum
    MemAttr_IsBorrowed = BIT(0), ## /< Is borrowed memory.
    MemAttr_IsIpcMapped = BIT(1), ## /< Is IPC mapped (when IpcRefCount > 0).
    MemAttr_IsDeviceMapped = BIT(2), ## /< Is device mapped (when DeviceRefCount > 0).
    MemAttr_IsUncached = BIT(3) ## /< Is uncached.


## / Memory permission bitmasks.

type
  Permission* {.size: sizeof(cint).} = enum
    Perm_None = 0,              ## /< No permissions.
    Perm_R = BIT(0),            ## /< Read permission.
    Perm_W = BIT(1),            ## /< Write permission.
    Perm_Rw = Perm_R.int or Perm_W.int,   ## /< Read/write permissions.
    Perm_X = BIT(2),            ## /< Execute permission.
    Perm_Rx = Perm_R.int or Perm_X.int,   ## /< Read/execute permissions.
    Perm_DontCare = BIT(28)     ## /< Don't care


## / Memory information structure.

type
  MemoryInfo* {.importc: "MemoryInfo", header: headersvc, bycopy.} = object
    `addr`* {.importc: "addr".}: uint64 ## /< Base address.
    size* {.importc: "size".}: uint64 ## /< Size.
    `type`* {.importc: "type".}: uint32 ## /< Memory type (see lower 8 bits of \ref MemoryState).
    attr* {.importc: "attr".}: uint32 ## /< Memory attributes (see \ref MemoryAttribute).
    perm* {.importc: "perm".}: uint32 ## /< Memory permissions (see \ref Permission).
    device_refcount* {.importc: "device_refcount".}: uint32 ## /< Device reference count.
    ipc_refcount* {.importc: "ipc_refcount".}: uint32 ## /< IPC reference count.
    padding* {.importc: "padding".}: uint32 ## /< Padding.
  

## / Secure monitor arguments.

type
  SecmonArgs* {.importc: "SecmonArgs", header: headersvc, bycopy.} = object
    X* {.importc: "X".}: array[8, uint64] ## /< Values of X0 through X7.
  

## / Code memory mapping operations

type
  CodeMapOperation* {.size: sizeof(cint).} = enum
    CodeMapOperation_MapOwner = 0, ## /< Map owner.
    CodeMapOperation_MapSlave = 1, ## /< Map slave.
    CodeMapOperation_UnmapOwner = 2, ## /< Unmap owner.
    CodeMapOperation_UnmapSlave = 3 ## /< Unmap slave.


## / Limitable Resources.

type
  LimitableResource* {.size: sizeof(cint).} = enum
    LimitableResource_Memory = 0, ## /<How much memory can a process map.
    LimitableResource_Threads = 1, ## /<How many threads can a process spawn.
    LimitableResource_Events = 2, ## /<How many events can a process have.
    LimitableResource_TransferMemories = 3, ## /<How many transfer memories can a process make.
    LimitableResource_Sessions = 4 ## /<How many sessions can a process own.


## / Process Information.

type
  ProcessInfoType* {.size: sizeof(cint).} = enum
    ProcessInfoType_ProcessState = 0 ## /<What state is a process in.


## / Process States.

type
  ProcessState* {.size: sizeof(cint).} = enum
    ProcessState_Created = 0,   ## /<Newly-created process.
    ProcessState_DebugAttached = 1, ## /<Process attached to debugger.
    ProcessState_DebugDetached = 2, ## /<Process detached from debugger.
    ProcessState_Crashed = 3,   ## /<Process that has just creashed.
    ProcessState_Running = 4,   ## /<Process executing normally.
    ProcessState_Exiting = 5,   ## /<Process has begun exiting.
    ProcessState_Exited = 6,    ## /<Process has finished exiting.
    ProcessState_DebugSuspended = 7 ## /<Process execution suspended by debugger.


## /@name Memory management
## /@{
## *
##  @brief Set the process heap to a given size. It can both extend and shrink the heap.
##  @param[out] out_addr Variable to which write the address of the heap (which is randomized and fixed by the kernel)
##  @param[in] size Size of the heap, must be a multiple of 0x2000000 and [2.0.0+] less than 0x18000000.
##  @return Result code.
##  @note Syscall number 0x00.
## 

proc svcSetHeapSize*(out_addr: ptr pointer; size: uint64): Result {.cdecl,
    importc: "svcSetHeapSize", header: headersvc.}
## *
##  @brief Set the memory permissions of a (page-aligned) range of memory.
##  @param[in] addr Start address of the range.
##  @param[in] size Size of the range, in bytes.
##  @param[in] perm Permissions (see \ref Permission).
##  @return Result code.
##  @remark Perm_X is not allowed. Setting write-only is not allowed either (Perm_W).
##          This can be used to move back and forth between Perm_None, Perm_R and Perm_Rw.
##  @note Syscall number 0x01.
## 

proc svcSetMemoryPermission*(`addr`: pointer; size: uint64; perm: uint32): Result {.cdecl,
    importc: "svcSetMemoryPermission", header: headersvc.}
## *
##  @brief Set the memory attributes of a (page-aligned) range of memory.
##  @param[in] addr Start address of the range.
##  @param[in] size Size of the range, in bytes.
##  @param[in] val0 State0
##  @param[in] val1 State1
##  @return Result code.
##  @remark See <a href="http://switchbrew.org/index.php?title=SVC#svcSetMemoryAttribute">switchbrew.org Wiki</a> for more details.
##  @note Syscall number 0x02.
## 

proc svcSetMemoryAttribute*(`addr`: pointer; size: uint64; val0: uint32; val1: uint32): Result {.
    cdecl, importc: "svcSetMemoryAttribute", header: headersvc.}
## *
##  @brief Maps a memory range into a different range. Mainly used for adding guard pages around stack.
##  Source range gets reprotected to Perm_None (it can no longer be accessed), and \ref MemAttr_IsBorrowed is set in the source \ref MemoryAttribute.
##  @param[in] dst_addr Destination address.
##  @param[in] src_addr Source address.
##  @param[in] size Size of the range.
##  @return Result code.
##  @note Syscall number 0x04.
## 

proc svcMapMemory*(dst_addr: pointer; src_addr: pointer; size: uint64): Result {.cdecl,
    importc: "svcMapMemory", header: headersvc.}
## *
##  @brief Unmaps a region that was previously mapped with \ref svcMapMemory.
##  @param[in] dst_addr Destination address.
##  @param[in] src_addr Source address.
##  @param[in] size Size of the range.
##  @return Result code.
##  @note Syscall number 0x05.
## 

proc svcUnmapMemory*(dst_addr: pointer; src_addr: pointer; size: uint64): Result {.cdecl,
    importc: "svcUnmapMemory", header: headersvc.}
## *
##  @brief Query information about an address. Will always fetch the lowest page-aligned mapping that contains the provided address.
##  @param[out] meminfo_ptr \ref MemoryInfo structure which will be filled in.
##  @param[out] page_info Page information which will be filled in.
##  @param[in] addr Address to query.
##  @return Result code.
##  @note Syscall number 0x06.
## 

proc svcQueryMemory*(meminfo_ptr: ptr MemoryInfo; pageinfo: ptr uint32; `addr`: uint64): Result {.
    cdecl, importc: "svcQueryMemory", header: headersvc.}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Exits the current process.
##  @note Syscall number 0x07.
## 

proc svcExitProcess*() {.cdecl, importc: "svcExitProcess", header: headersvc.}
## *
##  @brief Creates a thread.
##  @return Result code.
##  @note Syscall number 0x08.
## 

proc svcCreateThread*(`out`: ptr Handle; entry: pointer; arg: pointer;
                     stack_top: pointer; prio: cint; cpuid: cint): Result {.cdecl,
    importc: "svcCreateThread", header: headersvc.}
## *
##  @brief Starts a freshly created thread.
##  @return Result code.
##  @note Syscall number 0x09.
## 

proc svcStartThread*(handle: Handle): Result {.cdecl, importc: "svcStartThread",
    header: headersvc.}
## *
##  @brief Exits the current thread.
##  @note Syscall number 0x0A.
## 

proc svcExitThread*() {.cdecl, importc: "svcExitThread", header: headersvc.}
## *
##  @brief Sleeps the current thread for the specified amount of time.
##  @return Result code.
##  @note Syscall number 0x0B.
## 

proc svcSleepThread*(nano: uint64): Result {.cdecl, importc: "svcSleepThread",
                                      header: headersvc.}
## *
##  @brief Gets a thread's priority.
##  @return Result code.
##  @note Syscall number 0x0C.
## 

proc svcGetThreadPriority*(priority: ptr uint32; handle: Handle): Result {.cdecl,
    importc: "svcGetThreadPriority", header: headersvc.}
## *
##  @brief Sets a thread's priority.
##  @return Result code.
##  @note Syscall number 0x0D.
## 

proc svcSetThreadPriority*(handle: Handle; priority: uint32): Result {.cdecl,
    importc: "svcSetThreadPriority", header: headersvc.}
## *
##  @brief Gets the current processor's number.
##  @return The current processor's number.
##  @note Syscall number 0x10.
## 

proc svcGetCurrentProcessorNumber*(): uint32 {.cdecl,
    importc: "svcGetCurrentProcessorNumber", header: headersvc.}
## /@}
## /@name Synchronization
## /@{
## *
##  @brief Sets an event's signalled status.
##  @return Result code.
##  @note Syscall number 0x11.
## 

proc svcSignalEvent*(handle: Handle): Result {.cdecl, importc: "svcSignalEvent",
    header: headersvc.}
## *
##  @brief Clears an event's signalled status.
##  @return Result code.
##  @note Syscall number 0x12.
## 

proc svcClearEvent*(handle: Handle): Result {.cdecl, importc: "svcClearEvent",
    header: headersvc.}
## /@}
## /@name Inter-process memory sharing
## /@{
## *
##  @brief Maps a block of shared memory.
##  @return Result code.
##  @note Syscall number 0x13.
## 

proc svcMapSharedMemory*(handle: Handle; `addr`: pointer; size: csize; perm: uint32): Result {.
    cdecl, importc: "svcMapSharedMemory", header: headersvc.}
## *
##  @brief Unmaps a block of shared memory.
##  @return Result code.
##  @note Syscall number 0x14.
## 

proc svcUnmapSharedMemory*(handle: Handle; `addr`: pointer; size: csize): Result {.
    cdecl, importc: "svcUnmapSharedMemory", header: headersvc.}
## *
##  @brief Creates a block of transfer memory.
##  @return Result code.
##  @note Syscall number 0x15.
## 

proc svcCreateTransferMemory*(`out`: ptr Handle; `addr`: pointer; size: csize; perm: uint32): Result {.
    cdecl, importc: "svcCreateTransferMemory", header: headersvc.}
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

proc svcCloseHandle*(handle: Handle): Result {.cdecl, importc: "svcCloseHandle",
    header: headersvc.}
## /@}
## /@name Synchronization
## /@{
## *
##  @brief Resets a signal.
##  @return Result code.
##  @note Syscall number 0x17.
## 

proc svcResetSignal*(handle: Handle): Result {.cdecl, importc: "svcResetSignal",
    header: headersvc.}
## /@}
## /@name Synchronization
## /@{
## *
##  @brief Waits on one or more synchronization objects, optionally with a timeout.
##  @return Result code.
##  @note Syscall number 0x18.
## 

proc svcWaitSynchronization*(index: ptr s32; handles: ptr Handle; handleCount: s32;
                            timeout: uint64): Result {.cdecl,
    importc: "svcWaitSynchronization", header: headersvc.}
## *
##  @brief Waits on a single synchronization object, optionally with a timeout.
##  @return Result code.
##  @note Wrapper for \ref svcWaitSynchronization.
## 

proc svcWaitSynchronizationSingle*(handle: Handle; timeout: uint64): Result {.inline,
    cdecl, importc: "svcWaitSynchronizationSingle", header: headersvc.}
## *
##  @brief Waits a \ref svcWaitSynchronization operation being done on a synchronization object in another thread.
##  @return Result code.
##  @note Syscall number 0x19.
## 

proc svcCancelSynchronization*(thread: Handle): Result {.cdecl,
    importc: "svcCancelSynchronization", header: headersvc.}
## *
##  @brief Arbitrates a mutex lock operation in userspace.
##  @return Result code.
##  @note Syscall number 0x1A.
## 

proc svcArbitrateLock*(wait_tag: uint32; tag_location: ptr uint32; self_tag: uint32): Result {.
    cdecl, importc: "svcArbitrateLock", header: headersvc.}
## *
##  @brief Arbitrates a mutex unlock operation in userspace.
##  @return Result code.
##  @note Syscall number 0x1B.
## 

proc svcArbitrateUnlock*(tag_location: ptr uint32): Result {.cdecl,
    importc: "svcArbitrateUnlock", header: headersvc.}
## *
##  @brief Performs a condition variable wait operation in userspace.
##  @return Result code.
##  @note Syscall number 0x1C.
## 

proc svcWaitProcessWideKeyAtomic*(key: ptr uint32; tag_location: ptr uint32; self_tag: uint32;
                                 timeout: uint64): Result {.cdecl,
    importc: "svcWaitProcessWideKeyAtomic", header: headersvc.}
## *
##  @brief Performs a condition variable wake-up operation in userspace.
##  @return Result code.
##  @note Syscall number 0x1D.
## 

proc svcSignalProcessWideKey*(key: ptr uint32; num: s32): Result {.cdecl,
    importc: "svcSignalProcessWideKey", header: headersvc.}
## /@}
## /@name Miscellaneous
## /@{
## *
##  @brief Gets the current system tick.
##  @return The current system tick.
##  @note Syscall number 0x1E.
## 

proc svcGetSystemTick*(): uint64 {.cdecl, importc: "svcGetSystemTick",
                             header: headersvc.}
## /@}
## /@name Inter-process communication (IPC)
## /@{
## *
##  @brief Connects to a registered named port.
##  @return Result code.
##  @note Syscall number 0x1F.
## 

proc svcConnectToNamedPort*(session: ptr Handle; name: cstring): Result {.cdecl,
    importc: "svcConnectToNamedPort", header: headersvc.}
## *
##  @brief Sends an IPC synchronization request to a session.
##  @return Result code.
##  @note Syscall number 0x21.
## 

proc svcSendSyncRequest*(session: Handle): Result {.cdecl,
    importc: "svcSendSyncRequest", header: headersvc.}
## *
##  @brief Sends an IPC synchronization request to a session from an user allocated buffer.
##  @return Result code.
##  @remark size must be allocated to 0x1000 bytes.
##  @note Syscall number 0x22.
## 

proc svcSendSyncRequestWithUserBuffer*(usrBuffer: pointer; size: uint64; session: Handle): Result {.
    cdecl, importc: "svcSendSyncRequestWithUserBuffer", header: headersvc.}
## *
##  @brief Sends an IPC synchronization request to a session from an user allocated buffer (asynchronous version).
##  @return Result code.
##  @remark size must be allocated to 0x1000 bytes.
##  @note Syscall number 0x23.
## 

proc svcSendAsyncRequestWithUserBuffer*(handle: ptr Handle; usrBuffer: pointer;
                                       size: uint64; session: Handle): Result {.cdecl,
    importc: "svcSendAsyncRequestWithUserBuffer", header: headersvc.}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Gets the PID associated with a process.
##  @return Result code.
##  @note Syscall number 0x24.
## 

proc svcGetProcessId*(processID: ptr uint64; handle: Handle): Result {.cdecl,
    importc: "svcGetProcessId", header: headersvc.}
## *
##  @brief Gets the TID associated with a process.
##  @return Result code.
##  @note Syscall number 0x25.
## 

proc svcGetThreadId*(threadID: ptr uint64; handle: Handle): Result {.cdecl,
    importc: "svcGetThreadId", header: headersvc.}
## /@}
## /@name Miscellaneous
## /@{
## *
##  @brief Breaks execution. Panic.
##  @param[in] breakReason Break reason.
##  @param[in] inval1 First break parameter.
##  @param[in] inval2 Second break parameter.
##  @return Result code.
##  @note Syscall number 0x26.
## 

proc svcBreak*(breakReason: uint32; inval1: uint64; inval2: uint64): Result {.cdecl,
    importc: "svcBreak", header: headersvc.}
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

proc svcOutputDebugString*(str: cstring; size: uint64): Result {.cdecl,
    importc: "svcOutputDebugString", header: headersvc.}
## /@}
## /@name Miscellaneous
## /@{
## *
##  @brief Retrieves information about the system, or a certain kernel object.
##  @param[out] out Variable to which store the information.
##  @param[in] id0 First ID of the property to retrieve.
##  @param[in] handle Handle of the object to retrieve information from, or \ref INVALID_HANDLE to retrieve information about the system.
##  @param[in] id1 Second ID of the property to retrieve.
##  @return Result code.
##  @remark The full list of property IDs can be found on the <a href="http://switchbrew.org/index.php?title=SVC#svcGetInfo">switchbrew.org wiki</a>.
##  @note Syscall number 0x29.
## 

proc svcGetInfo*(`out`: ptr uint64; id0: uint64; handle: Handle; id1: uint64): Result {.cdecl,
    importc: "svcGetInfo", header: headersvc.}
## /@}
## /@name Memory management
## /@{
## *
##  @brief Maps new heap memory at the desired address. [3.0.0+]
##  @return Result code.
##  @note Syscall number 0x2A.
## 

proc svcMapPhysicalMemory*(address: pointer; size: uint64): Result {.cdecl,
    importc: "svcMapPhysicalMemory", header: headersvc.}
## *
##  @brief Undoes the effects of \ref svcMapPhysicalMemory. [3.0.0+]
##  @return Result code.
##  @note Syscall number 0x2B.
## 

proc svcUnmapPhysicalMemory*(address: pointer; size: uint64): Result {.cdecl,
    importc: "svcUnmapPhysicalMemory", header: headersvc.}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Configures the pause/unpause status of a thread.
##  @return Result code.
##  @note Syscall number 0x32.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcSetThreadActivity*(thread: Handle; paused: bool): Result {.cdecl,
    importc: "svcSetThreadActivity", header: headersvc.}
## /@}
## /@name Resource Limit Management
## /@{
## *
##  @brief Gets the maximum value a LimitableResource can have, for a Resource Limit handle.
##  @return Result code.
##  @note Syscall number 0x30.
## 

proc svcGetResourceLimitLimitValue*(`out`: ptr uint64; reslimit_h: Handle;
                                   which: LimitableResource): Result {.cdecl,
    importc: "svcGetResourceLimitLimitValue", header: headersvc.}
## *
##  @brief Gets the maximum value a LimitableResource can have, for a Resource Limit handle.
##  @return Result code.
##  @note Syscall number 0x31.
## 

proc svcGetResourceLimitCurrentValue*(`out`: ptr uint64; reslimit_h: Handle;
                                     which: LimitableResource): Result {.cdecl,
    importc: "svcGetResourceLimitCurrentValue", header: headersvc.}
## /@}
## /@name Inter-process communication (IPC)
## /@{
## *
##  @brief Creates an IPC session.
##  @return Result code.
##  @note Syscall number 0x40.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcCreateSession*(server_handle: ptr Handle; client_handle: ptr Handle; unk0: uint32;
                      unk1: uint64): Result {.cdecl, importc: "svcCreateSession",
                                        header: headersvc.}
## unk* are normally 0?
## *
##  @brief Accepts an IPC session.
##  @return Result code.
##  @note Syscall number 0x41.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcAcceptSession*(session_handle: ptr Handle; port_handle: Handle): Result {.
    cdecl, importc: "svcAcceptSession", header: headersvc.}
## *
##  @brief Performs IPC input/output.
##  @return Result code.
##  @note Syscall number 0x43.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcReplyAndReceive*(index: ptr s32; handles: ptr Handle; handleCount: s32;
                        replyTarget: Handle; timeout: uint64): Result {.cdecl,
    importc: "svcReplyAndReceive", header: headersvc.}
## *
##  @brief Performs IPC input/output from an user allocated buffer.
##  @return Result code.
##  @note Syscall number 0x44.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcReplyAndReceiveWithUserBuffer*(index: ptr s32; usrBuffer: pointer; size: uint64;
                                      handles: ptr Handle; handleCount: s32;
                                      replyTarget: Handle; timeout: uint64): Result {.
    cdecl, importc: "svcReplyAndReceiveWithUserBuffer", header: headersvc.}
## /@}
## /@name Synchronization
## /@{
## *
##  @brief Creates a system event.
##  @return Result code.
##  @note Syscall number 0x45.
## 

proc svcCreateEvent*(server_handle: ptr Handle; client_handle: ptr Handle): Result {.
    cdecl, importc: "svcCreateEvent", header: headersvc.}
## /@}
## /@name Memory management
## /@{
## *
##  @brief Maps unsafe memory (usable for GPU DMA) for a system module at the desired address. [5.0.0+]
##  @return Result code.
##  @note Syscall number 0x48.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcMapPhysicalMemoryUnsafe*(address: pointer; size: uint64): Result {.cdecl,
    importc: "svcMapPhysicalMemoryUnsafe", header: headersvc.}
## *
##  @brief Undoes the effects of \ref svcMapPhysicalMemoryUnsafe. [5.0.0+]
##  @return Result code.
##  @note Syscall number 0x49.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcUnmapPhysicalMemoryUnsafe*(address: pointer; size: uint64): Result {.cdecl,
    importc: "svcUnmapPhysicalMemoryUnsafe", header: headersvc.}
## *
##  @brief Sets the system-wide limit for unsafe memory mappable using \ref svcMapPhysicalMemoryUnsafe. [5.0.0+]
##  @return Result code.
##  @note Syscall number 0x4A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcSetUnsafeLimit*(size: uint64): Result {.cdecl, importc: "svcSetUnsafeLimit",
    header: headersvc.}
## /@}
## /@name Code memory / Just-in-time (JIT) compilation support
## /@{
## *
##  @brief Creates code memory in the caller's address space [4.0.0+].
##  @return Result code.
##  @note Syscall number 0x4B.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcCreateCodeMemory*(code_handle: ptr Handle; src_addr: pointer; size: uint64): Result {.
    cdecl, importc: "svcCreateCodeMemory", header: headersvc.}
## *
##  @brief Maps code memory in the caller's address space [4.0.0+].
##  @return Result code.
##  @note Syscall number 0x4C.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcControlCodeMemory*(code_handle: Handle; op: CodeMapOperation;
                          dst_addr: pointer; size: uint64; perm: uint64): Result {.cdecl,
    importc: "svcControlCodeMemory", header: headersvc.}
## /@}
## /@name Device memory-mapped I/O (MMIO)
## /@{
## *
##  @brief Reads/writes a protected MMIO register.
##  @return Result code.
##  @note Syscall number 0x4E.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcReadWriteRegister*(outVal: ptr uint32; regAddr: uint64; rwMask: uint32; inVal: uint32): Result {.
    cdecl, importc: "svcReadWriteRegister", header: headersvc.}
## /@}
## /@name Inter-process memory sharing
## /@{
## *
##  @brief Creates a block of shared memory.
##  @return Result code.
##  @note Syscall number 0x50.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcCreateSharedMemory*(`out`: ptr Handle; size: csize; local_perm: uint32;
                           other_perm: uint32): Result {.cdecl,
    importc: "svcCreateSharedMemory", header: headersvc.}
## *
##  @brief Maps a block of transfer memory.
##  @return Result code.
##  @note Syscall number 0x51.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcMapTransferMemory*(tmem_handle: Handle; `addr`: pointer; size: csize; perm: uint32): Result {.
    cdecl, importc: "svcMapTransferMemory", header: headersvc.}
## *
##  @brief Unmaps a block of transfer memory.
##  @return Result code.
##  @note Syscall number 0x52.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcUnmapTransferMemory*(tmem_handle: Handle; `addr`: pointer; size: csize): Result {.
    cdecl, importc: "svcUnmapTransferMemory", header: headersvc.}
## /@}
## /@name Device memory-mapped I/O (MMIO)
## /@{
## *
##  @brief Creates an event and binds it to a specific hardware interrupt.
##  @return Result code.
##  @note Syscall number 0x53.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcCreateInterruptEvent*(handle: ptr Handle; irqNum: uint64; flag: uint32): Result {.
    cdecl, importc: "svcCreateInterruptEvent", header: headersvc.}
## *
##  @brief Queries information about a certain virtual address, including its physical address.
##  @return Result code.
##  @note Syscall number 0x54.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcQueryPhysicalAddress*(`out`: array[3, uint64]; virtaddr: uint64): Result {.cdecl,
    importc: "svcQueryPhysicalAddress", header: headersvc.}
## *
##  @brief Returns a virtual address mapped to a given IO range.
##  @return Result code.
##  @note Syscall number 0x55.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcQueryIoMapping*(virtaddr: ptr uint64; physaddr: uint64; size: uint64): Result {.cdecl,
    importc: "svcQueryIoMapping", header: headersvc.}
## /@}
## /@name I/O memory management unit (IOMMU)
## /@{
## *
##  @brief Creates a virtual address space for binding device address spaces.
##  @return Result code.
##  @note Syscall number 0x56.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcCreateDeviceAddressSpace*(handle: ptr Handle; dev_addr: uint64; dev_size: uint64): Result {.
    cdecl, importc: "svcCreateDeviceAddressSpace", header: headersvc.}
## *
##  @brief Attaches a device address space to a device.
##  @return Result code.
##  @note Syscall number 0x57.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcAttachDeviceAddressSpace*(device: uint64; handle: Handle): Result {.cdecl,
    importc: "svcAttachDeviceAddressSpace", header: headersvc.}
## *
##  @brief Detaches a device address space from a device.
##  @return Result code.
##  @note Syscall number 0x58.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcDetachDeviceAddressSpace*(device: uint64; handle: Handle): Result {.cdecl,
    importc: "svcDetachDeviceAddressSpace", header: headersvc.}
## *
##  @brief Maps an attached device address space to an userspace address.
##  @return Result code.
##  @remark The userspace destination address must have the \ref MemState_MapDeviceAllowed bit set.
##  @note Syscall number 0x59.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcMapDeviceAddressSpaceByForce*(handle: Handle; proc_handle: Handle;
                                     map_addr: uint64; dev_size: uint64; dev_addr: uint64;
                                     perm: uint32): Result {.cdecl,
    importc: "svcMapDeviceAddressSpaceByForce", header: headersvc.}
## *
##  @brief Maps an attached device address space to an userspace address.
##  @return Result code.
##  @remark The userspace destination address must have the \ref MemState_MapDeviceAlignedAllowed bit set.
##  @note Syscall number 0x5A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcMapDeviceAddressSpaceAligned*(handle: Handle; proc_handle: Handle;
                                     map_addr: uint64; dev_size: uint64; dev_addr: uint64;
                                     perm: uint32): Result {.cdecl,
    importc: "svcMapDeviceAddressSpaceAligned", header: headersvc.}
## *
##  @brief Unmaps an attached device address space from an userspace address.
##  @return Result code.
##  @note Syscall number 0x5C.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcUnmapDeviceAddressSpace*(handle: Handle; proc_handle: Handle; map_addr: uint64;
                                map_size: uint64; dev_addr: uint64): Result {.cdecl,
    importc: "svcUnmapDeviceAddressSpace", header: headersvc.}
## /@}
## /@name Debugging
## /@{
## *
##  @brief Debugs an active process.
##  @return Result code.
##  @note Syscall number 0x60.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcDebugActiveProcess*(debug: ptr Handle; processID: uint64): Result {.cdecl,
    importc: "svcDebugActiveProcess", header: headersvc.}
## *
##  @brief Breaks an active debugging session.
##  @return Result code.
##  @note Syscall number 0x61.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcBreakDebugProcess*(debug: Handle): Result {.cdecl,
    importc: "svcBreakDebugProcess", header: headersvc.}
## *
##  @brief Gets an incoming debug event from a debugging session.
##  @return Result code.
##  @note Syscall number 0x63.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcGetDebugEvent*(event_out: ptr uint8; debug: Handle): Result {.cdecl,
    importc: "svcGetDebugEvent", header: headersvc.}
## *
##  @brief Continues a debugging session.
##  @return Result code.
##  @note Syscall number 0x64.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcContinueDebugEvent*(debug: Handle; flags: uint32; threadID: uint64): Result {.cdecl,
    importc: "svcContinueDebugEvent", header: headersvc.}
## *
##  @brief Gets the context of a thread in a debugging session.
##  @return Result code.
##  @note Syscall number 0x67.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcGetDebugThreadContext*(`out`: ptr uint8; debug: Handle; threadID: uint64; flags: uint32): Result {.
    cdecl, importc: "svcGetDebugThreadContext", header: headersvc.}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Retrieves a list of all running processes.
##  @return Result code.
##  @note Syscall number 0x65.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcGetProcessList*(num_out: ptr uint32; pids_out: ptr uint64; max_pids: uint32): Result {.
    cdecl, importc: "svcGetProcessList", header: headersvc.}
## /@}
## /@name Debugging
## /@{
## *
##  @brief Queries memory information from a process that is being debugged.
##  @return Result code.
##  @note Syscall number 0x69.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcQueryDebugProcessMemory*(meminfo_ptr: ptr MemoryInfo; pageinfo: ptr uint32;
                                debug: Handle; `addr`: uint64): Result {.cdecl,
    importc: "svcQueryDebugProcessMemory", header: headersvc.}
## *
##  @brief Reads memory from a process that is being debugged.
##  @return Result code.
##  @note Syscall number 0x6A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcReadDebugProcessMemory*(buffer: pointer; debug: Handle; `addr`: uint64; size: uint64): Result {.
    cdecl, importc: "svcReadDebugProcessMemory", header: headersvc.}
## *
##  @brief Writes to memory in a process that is being debugged.
##  @return Result code.
##  @note Syscall number 0x6B.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcWriteDebugProcessMemory*(debug: Handle; buffer: pointer; `addr`: uint64; size: uint64): Result {.
    cdecl, importc: "svcWriteDebugProcessMemory", header: headersvc.}
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
##  @remark The full list of property IDs can be found on the <a href="http://switchbrew.org/index.php?title=SVC#svcGetSystemInfo">switchbrew.org wiki</a>.
##  @note Syscall number 0x6F.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcGetSystemInfo*(`out`: ptr uint64; id0: uint64; handle: Handle; id1: uint64): Result {.
    cdecl, importc: "svcGetSystemInfo", header: headersvc.}
## /@}
## /@name Inter-process communication (IPC)
## /@{
## *
##  @brief Creates a port.
##  @return Result code.
##  @note Syscall number 0x70.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcCreatePort*(portServer: ptr Handle; portClient: ptr Handle; max_sessions: s32;
                   is_light: bool; name: cstring): Result {.cdecl,
    importc: "svcCreatePort", header: headersvc.}
## *
##  @brief Manages a named port.
##  @return Result code.
##  @note Syscall number 0x71.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcManageNamedPort*(portServer: ptr Handle; name: cstring; maxSessions: s32): Result {.
    cdecl, importc: "svcManageNamedPort", header: headersvc.}
## *
##  @brief Manages a named port.
##  @return Result code.
##  @note Syscall number 0x72.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcConnectToPort*(session: ptr Handle; port: Handle): Result {.cdecl,
    importc: "svcConnectToPort", header: headersvc.}
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

proc svcSetProcessMemoryPermission*(`proc`: Handle; `addr`: uint64; size: uint64; perm: uint32): Result {.
    cdecl, importc: "svcSetProcessMemoryPermission", header: headersvc.}
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

proc svcMapProcessMemory*(dst: pointer; `proc`: Handle; src: uint64; size: uint64): Result {.
    cdecl, importc: "svcMapProcessMemory", header: headersvc.}
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

proc svcUnmapProcessMemory*(dst: pointer; `proc`: Handle; src: uint64; size: uint64): Result {.
    cdecl, importc: "svcUnmapProcessMemory", header: headersvc.}
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

proc svcMapProcessCodeMemory*(`proc`: Handle; dst: uint64; src: uint64; size: uint64): Result {.
    cdecl, importc: "svcMapProcessCodeMemory", header: headersvc.}
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

proc svcUnmapProcessCodeMemory*(`proc`: Handle; dst: uint64; src: uint64; size: uint64): Result {.
    cdecl, importc: "svcUnmapProcessCodeMemory", header: headersvc.}
## /@}
## /@name Process and thread management
## /@{
## *
##  @brief Creates a new process.
##  @return Result code.
##  @note Syscall number 0x79.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcCreateProcess*(`out`: ptr Handle; proc_info: pointer; caps: ptr uint32; cap_num: uint64): Result {.
    cdecl, importc: "svcCreateProcess", header: headersvc.}
## *
##  @brief Starts executing a freshly created process.
##  @return Result code.
##  @note Syscall number 0x7A.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcStartProcess*(`proc`: Handle; main_prio: s32; default_cpu: s32; stack_size: uint32): Result {.
    cdecl, importc: "svcStartProcess", header: headersvc.}
## *
##  @brief Terminates a running process.
##  @return Result code.
##  @note Syscall number 0x7B.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcTerminateProcess*(`proc`: Handle): Result {.cdecl,
    importc: "svcTerminateProcess", header: headersvc.}
## *
##  @brief Gets a \ref ProcessInfoType for a process.
##  @return Result code.
##  @note Syscall number 0x7C.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcGetProcessInfo*(`out`: ptr uint64; `proc`: Handle; which: ProcessInfoType): Result {.
    cdecl, importc: "svcGetProcessInfo", header: headersvc.}
## /@}
## /@name Resource Limit Management
## /@{
## *
##  @brief Creates a new Resource Limit handle.
##  @return Result code.
##  @note Syscall number 0x7D.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcCreateResourceLimit*(`out`: ptr Handle): Result {.cdecl,
    importc: "svcCreateResourceLimit", header: headersvc.}
## *
##  @brief Sets the value for a \ref LimitableResource for a Resource Limit handle.
##  @return Result code.
##  @note Syscall number 0x7E.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcSetResourceLimitLimitValue*(reslimit: Handle; which: LimitableResource;
                                   value: uint64): Result {.cdecl,
    importc: "svcSetResourceLimitLimitValue", header: headersvc.}
## /@}
## /@name ( ͡° ͜ʖ ͡°)
## /@{
## *
##  @brief Calls a secure monitor function (TrustZone, EL3).
##  @param regs Arguments to pass to the secure monitor.
##  @return Return value from the secure monitor.
##  @note Syscall number 0x7F.
##  @warning This is a privileged syscall. Use \ref envIsSyscallHinted to check if it is available.
## 

proc svcCallSecureMonitor*(regs: ptr SecmonArgs): uint64 {.cdecl,
    importc: "svcCallSecureMonitor", header: headersvc.}
## /@}
