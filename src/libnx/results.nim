import
  libnx/wrapper/result,
  libnx/wrapper/types

type

  Module {.pure.} = enum
    Invalid = 0, # This is just so the nim compiler is happy
    Kernel = 1,
    Libnx = 345,
    LibnxNvidia = 348

  Result* = ref object
    code*: uint32
    module*: string
    description*: string
    case kind*: Module
    of Module.Kernel:
      kernelError*: KernelError
    of Module.Libnx:
      libnxError*: LibnxError
    of Module.LibnxNvidia:
      libnxNvidiaError*: LibnxNvidiaError
    else:
      discard

  KernelError* {.pure.} = enum
    Timeout = 117

  LibnxError* {.pure.} = enum
    BadReloc=1,
    OutOfMemory,
    AlreadyMapped,
    BadGetInfo_Stack,
    BadGetInfo_Heap,
    BadQueryMemory,
    AlreadyInitialized,
    NotInitialized,
    NotFound,
    IoError,
    BadInput,
    BadReent,
    BufferProducerError,
    HandleTooEarly,
    HeapAllocFailed,
    TooManyOverrides,
    ParcelError,
    BadGfxInit,
    BadGfxEventWait,
    BadGfxQueueBuffer,
    BadGfxDequeueBuffer,
    AppletCmdidNotFound,
    BadAppletReceiveMessage,
    BadAppletNotifyRunning,
    BadAppletGetCurrentFocusState,
    BadAppletGetOperationMode,
    BadAppletGetPerformanceMode,
    BadUsbCommsRead,
    BadUsbCommsWrite,
    InitFail_SM,
    InitFail_AM,
    InitFail_HID,
    InitFail_FS,
    BadGetInfo_Rng,
    JitUnavailable,
    WeirdKernel,
    IncompatSysVer,
    InitFail_Time,
    TooManyDevOpTabs

  LibnxNvidiaError* {.pure.} = enum
    Unknown=1,
    NotImplemented,       #///< Maps to Nvidia: 1
    NotSupported,         #///< Maps to Nvidia: 2
    NotInitialized,       #///< Maps to Nvidia: 3
    BadParameter,         #///< Maps to Nvidia: 4
    Timeout,              #///< Maps to Nvidia: 5
    InsufficientMemory,   #///< Maps to Nvidia: 6
    ReadOnlyAttribute,    #///< Maps to Nvidia: 7
    InvalidState,         #///< Maps to Nvidia: 8
    InvalidAddress,       #///< Maps to Nvidia: 9
    InvalidSize,          #///< Maps to Nvidia: 10
    BadValue,             #///< Maps to Nvidia: 11
    AlreadyAllocated,     #///< Maps to Nvidia: 13
    Busy,                 #///< Maps to Nvidia: 14
    ResourceError,        #///< Maps to Nvidia: 15
    CountMismatch,        #///< Maps to Nvidia: 16
    SharedMemoryTooSmall, #///< Maps to Nvidia: 0x1000
    FileOperationFailed,  #///< Maps to Nvidia: 0x30003
    IoctlFailed           #///< Maps to Nvidia: 0x3000F


proc succeeded*(res: Result): bool = res.code.R_SUCCEEDED
proc failed*(res: Result): bool = res.code.R_FAILED

proc newResult*(code: uint32): Result =
  ## Create a result from a libnx error code for friendlier syntax.
  result = new(Result)

  result.code = code
  if code.R_SUCCEEDED:
    return

  let moduleCode = code.R_MODULE
  let module = Module(moduleCode)

  result.kind = module

  let descCode = code.R_DESCRIPTION

  var description = ""
  try:
    case module
    of Module.Invalid:
      discard
    of Module.Kernel:
      result.kernelError = KernelError(descCode)
      description = $result.kernelError
    of Module.Libnx:
      result.libnxError = LibnxError(descCode)
      description = $result.libnxError
    of Module.LibnxNvidia:
      result.libnxNvidiaError = LibnxNvidiaError(descCode)
      description = $result.libnxNvidiaError
  except:
    echo "Converting to result failed: " & getCurrentExceptionMsg()
    echo "Code: " & $code
    echo "ModuleCode: " & $moduleCode
    echo "Module: " & $module
    echo "DescCode: " & $descCode

  result.module = $module
  result.description = description
