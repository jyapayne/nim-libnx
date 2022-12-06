## *
##  @file counter.h
##  @brief AArch64 system counter-timer.
##  @author fincs
##  @copyright libnx Authors
##

import
  ../types

proc armGetSystemTick*(): U64 {.inline, cdecl, importc: "armGetSystemTick".} =
  ## *
  ##  @brief Gets the current system tick.
  ##  @return The current system tick.
  ##
  {.emit: "__asm__ __volatile__ (\"mrs %x[data], cntpct_el0\" : [data] \"=r\" (`result`));".}

proc armGetSystemTickFreq*(): U64 {.inline, cdecl, importc: "armGetSystemTickFreq".} =
  ## *
  ##  @brief Gets the system counter-timer frequency
  ##  @return The system counter-timer frequency, in Hz.
  ##
  {.emit: "__asm__ (\"mrs %x[data], cntfrq_el0\" : [data] \"=r\" (`result`));".}

proc armNsToTicks*(ns: U64): U64 {.inline, cdecl, importc: "armNsToTicks".} =
  ## *
  ##  @brief Converts from nanoseconds to CPU ticks unit.
  ##  @param ns Time in nanoseconds.
  ##  @return Time in CPU ticks.
  ##
  {.emit: "return (`ns` * 12) / 625;".}

proc armTicksToNs*(tick: U64): U64 {.inline, cdecl, importc: "armTicksToNs".} =
  ## *
  ##  @brief Converts from CPU ticks unit to nanoseconds.
  ##  @param tick Time in ticks.
  ##  @return Time in nanoseconds.
  ##
  {.emit: "return (`tick` * 625) / 12;".}

