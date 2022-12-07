## *
##  @file tls.h
##  @brief AArch64 thread local storage.
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types
export types

## *
##  @brief Gets the thread local storage buffer.
##  @return The thread local storage buffer.
##

proc armGetTls*(): pointer {.inline, cdecl.} =
  {.emit: "__asm__ (\"mrs %x[data], tpidrro_el0\" : [data] \"=r\" (`result`));".}
