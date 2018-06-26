import strutils
import ospaths
const headerresult = currentSourcePath().splitPath().head & "/nx/include/switch/result.h"
## *
##  @file result.h
##  @brief Switch result code tools.
##  @copyright libnx Authors
## 

import
  types

## / Checks whether a result code indicates success.

template R_SUCCEEDED*(res: untyped): untyped =
  ((res) == 0)

## / Checks whether a result code indicates failure.

template R_FAILED*(res: untyped): untyped =
  ((res) != 0)

## / Returns the module ID of a result code.

template R_MODULE*(res: untyped): untyped =
  ((res) and 0x000001FF)

## / Returns the description of a result code.

template R_DESCRIPTION*(res: untyped): untyped =
  (((res) shr 9) and 0x00001FFF)

## / Builds a result code from its constituent components.

template MAKERESULT*(module, description: untyped): untyped =
  ((((module) and 0x000001FF)) or ((description) and 0x00001FFF) shl 9)

## / Module values

const
  Module_Kernel* = 1
  Module_Libnx* = 345
  Module_LibnxNvidia* = 348

## / Kernel error codes

const
  KernelError_Timeout* = 117

## / libnx error codes

const
  LibnxError_BadReloc* = 1
  LibnxError_OutOfMemory* = 2
  LibnxError_AlreadyMapped* = 3
  LibnxError_BadGetInfo_Stack* = 4
  LibnxError_BadGetInfo_Heap* = 5
  LibnxError_BadQueryMemory* = 6
  LibnxError_AlreadyInitialized* = 7
  LibnxError_NotInitialized* = 8
  LibnxError_NotFound* = 9
  LibnxError_IoError* = 10
  LibnxError_BadInput* = 11
  LibnxError_BadReent* = 12
  LibnxError_BufferProducerError* = 13
  LibnxError_HandleTooEarly* = 14
  LibnxError_HeapAllocFailed* = 15
  LibnxError_TooManyOverrides* = 16
  LibnxError_ParcelError* = 17
  LibnxError_BadGfxInit* = 18
  LibnxError_BadGfxEventWait* = 19
  LibnxError_BadGfxQueueBuffer* = 20
  LibnxError_BadGfxDequeueBuffer* = 21
  LibnxError_AppletCmdidNotFound* = 22
  LibnxError_BadAppletReceiveMessage* = 23
  LibnxError_BadAppletNotifyRunning* = 24
  LibnxError_BadAppletGetCurrentFocusState* = 25
  LibnxError_BadAppletGetOperationMode* = 26
  LibnxError_BadAppletGetPerformanceMode* = 27
  LibnxError_BadUsbCommsRead* = 28
  LibnxError_BadUsbCommsWrite* = 29
  LibnxError_InitFail_SM* = 30
  LibnxError_InitFail_AM* = 31
  LibnxError_InitFail_HID* = 32
  LibnxError_InitFail_FS* = 33
  LibnxError_BadGetInfo_Rng* = 34
  LibnxError_JitUnavailable* = 35
  LibnxError_WeirdKernel* = 36
  LibnxError_IncompatSysVer* = 37
  LibnxError_InitFail_Time* = 38
  LibnxError_TooManyDevOpTabs* = 39
  LibnxError_DomainMessageUnknownType* = 40
  LibnxError_DomainMessageTooManyObjectIds* = 41

## / libnx nvidia error codes

const
  LibnxNvidiaError_Unknown* = 1
  LibnxNvidiaError_NotImplemented* = 2 ## /< Maps to Nvidia: 1
  LibnxNvidiaError_NotSupported* = 3 ## /< Maps to Nvidia: 2
  LibnxNvidiaError_NotInitialized* = 4 ## /< Maps to Nvidia: 3
  LibnxNvidiaError_BadParameter* = 5 ## /< Maps to Nvidia: 4
  LibnxNvidiaError_Timeout* = 6 ## /< Maps to Nvidia: 5
  LibnxNvidiaError_InsufficientMemory* = 7 ## /< Maps to Nvidia: 6
  LibnxNvidiaError_ReadOnlyAttribute* = 8 ## /< Maps to Nvidia: 7
  LibnxNvidiaError_InvalidState* = 9 ## /< Maps to Nvidia: 8
  LibnxNvidiaError_InvalidAddress* = 10 ## /< Maps to Nvidia: 9
  LibnxNvidiaError_InvalidSize* = 11 ## /< Maps to Nvidia: 10
  LibnxNvidiaError_BadValue* = 12 ## /< Maps to Nvidia: 11
  LibnxNvidiaError_AlreadyAllocated* = 13 ## /< Maps to Nvidia: 13
  LibnxNvidiaError_Busy* = 14   ## /< Maps to Nvidia: 14
  LibnxNvidiaError_ResourceError* = 15 ## /< Maps to Nvidia: 15
  LibnxNvidiaError_CountMismatch* = 16 ## /< Maps to Nvidia: 16
  LibnxNvidiaError_SharedMemoryTooSmall* = 17 ## /< Maps to Nvidia: 0x1000
  LibnxNvidiaError_FileOperationFailed* = 18 ## /< Maps to Nvidia: 0x30003
  LibnxNvidiaError_IoctlFailed* = 19 ## /< Maps to Nvidia: 0x3000F
