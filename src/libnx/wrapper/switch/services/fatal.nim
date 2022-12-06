## *
##  @file fatal.h
##  @brief Fatal error (fatal:u) service IPC wrapper.
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types

## / Type of thrown fatal error.

type
  FatalPolicy* = enum
    FatalPolicyErrorReportAndErrorScreen = 0, FatalPolicyErrorReport = 1, FatalPolicyErrorScreen = 2 ## /< Only available with [3.0.0+]. If specified, FatalPolicy_ErrorReportAndErrorScreen will be used instead on pre-3.0.0.


## / Struct for fatal Cpu context, 64-bit.

type
  INNER_C_STRUCT_fatal_5* {.bycopy.} = object
    x*: array[29, U64]
    fp*: U64
    lr*: U64
    sp*: U64
    pc*: U64

  INNER_C_UNION_fatal_4* {.bycopy, union.} = object
    x*: array[32, U64]
    anoFatal6*: INNER_C_STRUCT_fatal_5

  FatalAarch64Context* {.bycopy.} = object
    anoFatal7*: INNER_C_UNION_fatal_4
    pstate*: U64
    afsr0*: U64
    afsr1*: U64
    esr*: U64
    far*: U64
    stackTrace*: array[32, U64]
    startAddress*: U64         ## /< Address of first NSO loaded (generally, process entrypoint).
    registerSetFlags*: U64     ## /< Bitmask, bit i indicates GPR i has a value.
    stackTraceSize*: U32


## / Struct for fatal Cpu context, 32-bit.

type
  INNER_C_STRUCT_fatal_13* {.bycopy.} = object
    r*: array[11, U32]
    fp*: U32
    ip*: U32
    sp*: U32
    lr*: U32
    pc*: U32

  INNER_C_UNION_fatal_12* {.bycopy, union.} = object
    r*: array[16, U32]
    anoFatal14*: INNER_C_STRUCT_fatal_13

  INNER_C_UNION_fatal_18* {.bycopy, union.} = object
    aarch64Ctx*: FatalAarch64Context
    aarch32Ctx*: FatalAarch32Context

  FatalAarch32Context* {.bycopy.} = object
    anoFatal15*: INNER_C_UNION_fatal_12
    pstate*: U32
    afsr0*: U32
    afsr1*: U32
    esr*: U32
    far*: U32
    stackTrace*: array[32, U32]
    stackTraceSize*: U32
    startAddress*: U32         ## /< Address of first NSO loaded (generally, process entrypoint).
    registerSetFlags*: U32     ## /< Bitmask, bit i indicates GPR i has a value.

  FatalCpuContext* {.bycopy.} = object
    anoFatal19*: INNER_C_UNION_fatal_18
    isAarch32*: bool
    `type`*: U32


## *
##  @brief Triggers a system fatal error.
##  @param[in] err Result code to throw.
##  @note This function does not return.
##  @note This uses \ref fatalThrowWithPolicy with \ref FatalPolicy_ErrorScreen internally.
##

proc fatalThrow*(err: Result) {.cdecl, importc: "fatalThrow".}
## *
##  @brief Triggers a system fatal error with a custom \ref FatalPolicy.
##  @param[in] err Result code to throw.
##  @param[in] type Type of fatal error to throw.
##  @note This function may not return, depending on \ref FatalPolicy.
##

proc fatalThrowWithPolicy*(err: Result; `type`: FatalPolicy) {.cdecl,
    importc: "fatalThrowWithPolicy".}
## *
##  @brief Triggers a system fatal error with a custom \ref FatalPolicy and \ref FatalCpuContext.
##  @param[in] err  Result code to throw.
##  @param[in] type Type of fatal error to throw.
##  @param[in] ctx  Cpu context for fatal error to throw.
##  @note This function may not return, depending on \ref FatalPolicy.
##

proc fatalThrowWithContext*(err: Result; `type`: FatalPolicy;
                           ctx: ptr FatalCpuContext) {.cdecl,
    importc: "fatalThrowWithContext".}