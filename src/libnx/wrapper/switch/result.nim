## *
##  @file result.h
##  @brief Switch result code tools.
##  @copyright libnx Authors
##

import macros

macro combineSym(s1, s2: untyped): untyped =
  return ident($s1.toStrLit & $s2.toStrLit)

import
  types
export types

## / Checks whether a result code indicates success.

template r_Succeeded*(res: untyped): untyped =
  ((res) == 0)

## / Checks whether a result code indicates failure.

template r_Failed*(res: untyped): untyped =
  ((res) != 0)

## / Returns the module ID of a result code.

template r_Module*(res: untyped): untyped =
  ((res) and 0x1FF)

## / Returns the description of a result code.

template r_Description*(res: untyped): untyped =
  (((res) shr 9) and 0x1FFF)

## / Masks out unused bits in a result code, retrieving the actual value for use in comparisons.

template r_Value*(res: untyped): untyped =
  ((res) and 0x3FFFFF)



## / Module values

const
  ModuleKernel* = 1
  ModuleLibnx* = 345
  ModuleHomebrewAbi* = 346
  ModuleHomebrewLoader* = 347
  ModuleLibnxNvidia* = 348
  ModuleLibnxBinder* = 349

## / Kernel error codes

const
  KernelErrorOutOfSessions* = 7
  KernelErrorInvalidCapabilityDescriptor* = 14
  KernelErrorNotImplemented* = 33
  KernelErrorThreadTerminating* = 59
  KernelErrorOutOfDebugEvents* = 70
  KernelErrorInvalidSize* = 101
  KernelErrorInvalidAddress* = 102
  KernelErrorResourceExhausted* = 103
  KernelErrorOutOfMemory* = 104
  KernelErrorOutOfHandles* = 105
  KernelErrorInvalidMemoryState* = 106
  KernelErrorInvalidMemoryPermissions* = 108
  KernelErrorInvalidMemoryRange* = 110
  KernelErrorInvalidPriority* = 112
  KernelErrorInvalidCoreId* = 113
  KernelErrorInvalidHandle* = 114
  KernelErrorInvalidUserBuffer* = 115
  KernelErrorInvalidCombination* = 116
  KernelErrorTimedOut* = 117
  KernelErrorCancelled* = 118
  KernelErrorOutOfRange* = 119
  KernelErrorInvalidEnumValue* = 120
  KernelErrorNotFound* = 121
  KernelErrorAlreadyExists* = 122
  KernelErrorConnectionClosed* = 123
  KernelErrorUnhandledUserInterrupt* = 124
  KernelErrorInvalidState* = 125
  KernelErrorReservedValue* = 126
  KernelErrorInvalidHwBreakpoint* = 127
  KernelErrorFatalUserException* = 128
  KernelErrorOwnedByAnotherProcess* = 129
  KernelErrorConnectionRefused* = 131
  KernelErrorOutOfResource* = 132
  KernelErrorIpcMapFailed* = 259
  KernelErrorIpcCmdbufTooSmall* = 260
  KernelErrorNotDebugged* = 520

## / libnx error codes

const
  LibnxErrorBadReloc* = 1
  LibnxErrorOutOfMemory* = 2
  LibnxErrorAlreadyMapped* = 3
  LibnxErrorBadGetInfoStack* = 4
  LibnxErrorBadGetInfoHeap* = 5
  LibnxErrorBadQueryMemory* = 6
  LibnxErrorAlreadyInitialized* = 7
  LibnxErrorNotInitialized* = 8
  LibnxErrorNotFound* = 9
  LibnxErrorIoError* = 10
  LibnxErrorBadInput* = 11
  LibnxErrorBadReent* = 12
  LibnxErrorBufferProducerError* = 13
  LibnxErrorHandleTooEarly* = 14
  LibnxErrorHeapAllocFailed* = 15
  LibnxErrorTooManyOverrides* = 16
  LibnxErrorParcelError* = 17
  LibnxErrorBadGfxInit* = 18
  LibnxErrorBadGfxEventWait* = 19
  LibnxErrorBadGfxQueueBuffer* = 20
  LibnxErrorBadGfxDequeueBuffer* = 21
  LibnxErrorAppletCmdidNotFound* = 22
  LibnxErrorBadAppletReceiveMessage* = 23
  LibnxErrorBadAppletNotifyRunning* = 24
  LibnxErrorBadAppletGetCurrentFocusState* = 25
  LibnxErrorBadAppletGetOperationMode* = 26
  LibnxErrorBadAppletGetPerformanceMode* = 27
  LibnxErrorBadUsbCommsRead* = 28
  LibnxErrorBadUsbCommsWrite* = 29
  LibnxErrorInitFailSM* = 30
  LibnxErrorInitFailAM* = 31
  LibnxErrorInitFailHID* = 32
  LibnxErrorInitFailFS* = 33
  LibnxErrorBadGetInfoRng* = 34
  LibnxErrorJitUnavailable* = 35
  LibnxErrorWeirdKernel* = 36
  LibnxErrorIncompatSysVer* = 37
  LibnxErrorInitFailTime* = 38
  LibnxErrorTooManyDevOpTabs* = 39
  LibnxErrorDomainMessageUnknownType* = 40
  LibnxErrorDomainMessageTooManyObjectIds* = 41
  LibnxErrorAppletFailedToInitialize* = 42
  LibnxErrorApmFailedToInitialize* = 43
  LibnxErrorNvinfoFailedToInitialize* = 44
  LibnxErrorNvbufFailedToInitialize* = 45
  LibnxErrorLibAppletBadExit* = 46
  LibnxErrorInvalidCmifOutHeader* = 47
  LibnxErrorShouldNotHappen* = 48
  LibnxErrorTimeout* = 49

## / libnx binder error codes

const
  LibnxBinderErrorUnknown* = 1
  LibnxBinderErrorNoMemory* = 2
  LibnxBinderErrorInvalidOperation* = 3
  LibnxBinderErrorBadValue* = 4
  LibnxBinderErrorBadType* = 5
  LibnxBinderErrorNameNotFound* = 6
  LibnxBinderErrorPermissionDenied* = 7
  LibnxBinderErrorNoInit* = 8
  LibnxBinderErrorAlreadyExists* = 9
  LibnxBinderErrorDeadObject* = 10
  LibnxBinderErrorFailedTransaction* = 11
  LibnxBinderErrorBadIndex* = 12
  LibnxBinderErrorNotEnoughData* = 13
  LibnxBinderErrorWouldBlock* = 14
  LibnxBinderErrorTimedOut* = 15
  LibnxBinderErrorUnknownTransaction* = 16
  LibnxBinderErrorFdsNotAllowed* = 17

## / libnx nvidia error codes

const
  LibnxNvidiaErrorUnknown* = 1
  LibnxNvidiaErrorNotImplemented* = 2 ## /< Maps to Nvidia: 1
  LibnxNvidiaErrorNotSupported* = 3 ## /< Maps to Nvidia: 2
  LibnxNvidiaErrorNotInitialized* = 4 ## /< Maps to Nvidia: 3
  LibnxNvidiaErrorBadParameter* = 5 ## /< Maps to Nvidia: 4
  LibnxNvidiaErrorTimeout* = 6  ## /< Maps to Nvidia: 5
  LibnxNvidiaErrorInsufficientMemory* = 7 ## /< Maps to Nvidia: 6
  LibnxNvidiaErrorReadOnlyAttribute* = 8 ## /< Maps to Nvidia: 7
  LibnxNvidiaErrorInvalidState* = 9 ## /< Maps to Nvidia: 8
  LibnxNvidiaErrorInvalidAddress* = 10 ## /< Maps to Nvidia: 9
  LibnxNvidiaErrorInvalidSize* = 11 ## /< Maps to Nvidia: 10
  LibnxNvidiaErrorBadValue* = 12 ## /< Maps to Nvidia: 11
  LibnxNvidiaErrorAlreadyAllocated* = 13 ## /< Maps to Nvidia: 13
  LibnxNvidiaErrorBusy* = 14    ## /< Maps to Nvidia: 14
  LibnxNvidiaErrorResourceError* = 15 ## /< Maps to Nvidia: 15
  LibnxNvidiaErrorCountMismatch* = 16 ## /< Maps to Nvidia: 16
  LibnxNvidiaErrorSharedMemoryTooSmall* = 17 ## /< Maps to Nvidia: 0x1000
  LibnxNvidiaErrorFileOperationFailed* = 18 ## /< Maps to Nvidia: 0x30003
  LibnxNvidiaErrorIoctlFailed* = 19 ## /< Maps to Nvidia: 0x3000F

template makeResult*(module, description: untyped): untyped =
  ## / Builds a result code from its constituent components.
  ((((module) and 0x1FF)) or ((description) and 0x1FFF) shl 9)

template kernelResult*(description: untyped): untyped =
  ## / Builds a kernel error result code.
  makeResult(Module_Kernel, combineSym(KernelError, description))
