## *
##  @file thread_context.h
##  @brief AArch64 register dump format and related definitions.
##  @author TuxSH
##  @copyright libnx Authors
##

import
  ../types

## / Armv8 CPU register.

type
  CpuRegister* {.bycopy, union.} = object
    x*: U64                    ## /< 64-bit AArch64 register view.
    w*: U32                    ## /< 32-bit AArch64 register view.
    r*: U32                    ## /< AArch32 register view.


## / Armv8 NEON register.

type
  FpuRegister* {.bycopy, union.} = object
    v*: U128                   ## /< 128-bit vector view.
    d*: cdouble                ## /< 64-bit double-precision view.
    s*: cfloat                 ## /< 32-bit single-precision view.


## / Armv8 register group. @ref svcGetThreadContext3 uses @ref RegisterGroup_All.

type
  RegisterGroup* = enum
    RegisterGroupCpuGprs = bit(0), ## /< General-purpose CPU registers (x0..x28 or r0..r10,r12).
    RegisterGroupCpuSprs = bit(1), ## /< Special-purpose CPU registers (fp, lr, sp, pc, PSTATE or cpsr, TPIDR_EL0).
    RegisterGroupCpuAll = RegisterGroupCpuGprs.uint or RegisterGroupCpuSprs.uint, ## /< All CPU registers.
    RegisterGroupFpuGprs = bit(2), ## /< General-purpose NEON registers.
    RegisterGroupFpuSprs = bit(3), ## /< Special-purpose NEON registers.
    RegisterGroupFpuAll = RegisterGroupFpuGprs.uint or RegisterGroupFpuSprs.uint, ## /< All NEON registers.
    RegisterGroupAll = RegisterGroupCpuAll.uint or RegisterGroupFpuAll.uint ## /< All registers.


## / This is for \ref ThreadExceptionDump error_desc.

type
  ThreadExceptionDesc* = enum
    ThreadExceptionDescInstructionAbort = 0x100, ## /< Instruction abort
    ThreadExceptionDescOther = 0x101, ## /< None of the above, EC <= 0x34 and not a breakpoint
    ThreadExceptionDescMisalignedPC = 0x102, ## /< Misaligned PC
    ThreadExceptionDescMisalignedSP = 0x103, ## /< Misaligned SP
    ThreadExceptionDescTrap = 0x104, ## /< Uncategorized, CP15RTTrap, CP15RRTTrap, CP14RTTrap, CP14RRTTrap, IllegalState, SystemRegisterTrap
    ThreadExceptionDescSError = 0x106, ## /< SError [not in 1.0.0?]
    ThreadExceptionDescBadSVC = 0x301 ## /< Bad SVC


## / Thread context structure (register dump)

type
  ThreadContext* {.bycopy.} = object
    cpuGprs*: array[29, CpuRegister] ## /< GPRs 0..28. Note: also contains AArch32 SPRs.
    fp*: U64                   ## /< Frame pointer (x29) (AArch64). For AArch32, check r11.
    lr*: U64                   ## /< Link register (x30) (AArch64). For AArch32, check r14.
    sp*: U64                   ## /< Stack pointer (AArch64). For AArch32, check r13.
    pc*: CpuRegister           ## /< Program counter.
    psr*: U32                  ## /< PSTATE or cpsr.
    fpuGprs*: array[32, FpuRegister] ## /< 32 general-purpose NEON registers.
    fpcr*: U32                 ## /< Floating-point control register.
    fpsr*: U32                 ## /< Floating-point status register.
    tpidr*: U64                ## /< EL0 Read/Write Software Thread ID Register.


## / Thread exception dump structure.

type
  ThreadExceptionDump* {.bycopy.} = object
    errorDesc*: U32            ## /< See \ref ThreadExceptionDesc.
    pad*: array[3, U32]
    cpuGprs*: array[29, CpuRegister] ## /< GPRs 0..28. Note: also contains AArch32 registers.
    fp*: CpuRegister           ## /< Frame pointer.
    lr*: CpuRegister           ## /< Link register.
    sp*: CpuRegister           ## /< Stack pointer.
    pc*: CpuRegister           ## /< Program counter (elr_el1).
    padding*: U64
    fpuGprs*: array[32, FpuRegister] ## /< 32 general-purpose NEON registers.
    pstate*: U32               ## /< pstate & 0xFF0FFE20
    afsr0*: U32
    afsr1*: U32
    esr*: U32
    far*: CpuRegister          ## /< Fault Address Register.

  ThreadExceptionFrameA64* {.bycopy.} = object
    cpuGprs*: array[9, U64]     ## /< GPRs 0..8.
    lr*: U64
    sp*: U64
    elrEl1*: U64
    pstate*: U32               ## /< pstate & 0xFF0FFE20
    afsr0*: U32
    afsr1*: U32
    esr*: U32
    far*: U64

  ThreadExceptionFrameA32* {.bycopy.} = object
    cpuGprs*: array[8, U32]     ## /< GPRs 0..7.
    sp*: U32
    lr*: U32
    elrEl1*: U32
    tpidrEl0*: U32             ## /< tpidr_el0 = 1
    cpsr*: U32                 ## /< cpsr & 0xFF0FFE20
    afsr0*: U32
    afsr1*: U32
    esr*: U32
    far*: U32

proc threadContextIsAArch64*(ctx: ptr ThreadContext): bool {.inline, cdecl,
    importc: "threadContextIsAArch64".} =
  ## *
  ##  @brief Determines whether a thread context belong to an AArch64 process based on the PSR.
  ##  @param[in] ctx Thread context to which PSTATE/cspr has been dumped to.
  ##  @return true if and only if the thread context belongs to an AArch64 process.
  ##

  return (ctx.psr and 0x10) == 0

proc threadExceptionIsAArch64*(ctx: ptr ThreadExceptionDump): bool {.inline, cdecl,
    importc: "threadExceptionIsAArch64".} =
  ## *
  ##  @brief Determines whether a ThreadExceptionDump belongs to an AArch64 process based on the PSTATE.
  ##  @param[in] ctx ThreadExceptionDump.
  ##  @return true if and only if the ThreadExceptionDump belongs to an AArch64 process.
  ##
  return (ctx.pstate and 0x10) == 0
