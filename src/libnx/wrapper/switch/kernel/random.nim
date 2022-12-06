## *
##  @file random.h
##  @brief OS-seeded pseudo-random number generation support (ChaCha algorithm).
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types

## *
##  @brief Fills a buffer with random data.
##  @param buf Pointer to the buffer.
##  @param len Size of the buffer in bytes.
##

proc randomGet*(buf: pointer; len: csize_t) {.cdecl, importc: "randomGet".}
## *
##  @brief Returns a random 64-bit value.
##  @return Random value.
##

proc randomGet64*(): U64 {.cdecl, importc: "randomGet64".}