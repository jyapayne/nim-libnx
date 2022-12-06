## *
##  @file csrng.h
##  @brief Cryptographically-Secure Random Number Generation (csrng) service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / Initialize csrng.

proc csrngInitialize*(): Result {.cdecl, importc: "csrngInitialize".}
## / Exit csrng.

proc csrngExit*() {.cdecl, importc: "csrngExit".}
## / Gets the Service object for the actual csrng service session.

proc csrngGetServiceSession*(): ptr Service {.cdecl,
    importc: "csrngGetServiceSession".}
proc csrngGetRandomBytes*(`out`: pointer; outSize: csize_t): Result {.cdecl,
    importc: "csrngGetRandomBytes".}