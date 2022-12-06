## *
##  @file sha256.h
##  @brief Hardware accelerated SHA256 implementation.
##  @copyright libnx Authors
##

import
  ../types

when not defined(SHA256_HASH_SIZE):
  const
    SHA256_HASH_SIZE* = 0x20
when not defined(SHA256_BLOCK_SIZE):
  const
    SHA256_BLOCK_SIZE* = 0x40
## / Context for SHA256 operations.

type
  Sha256Context* {.bycopy.} = object
    intermediateHash*: array[Sha256Hash_Size div sizeof((U32)), U32]
    buffer*: array[Sha256Block_Size, U8]
    bitsConsumed*: U64
    numBuffered*: csize_t
    finalized*: bool

proc sha256ContextCreate*(`out`: ptr Sha256Context) {.cdecl,
    importc: "sha256ContextCreate".}
## / Initialize a SHA256 context.

proc sha256ContextUpdate*(ctx: ptr Sha256Context; src: pointer; size: csize_t) {.cdecl,
    importc: "sha256ContextUpdate".}
## / Updates SHA256 context with data to hash

proc sha256ContextGetHash*(ctx: ptr Sha256Context; dst: pointer) {.cdecl,
    importc: "sha256ContextGetHash".}
## / Gets the context's output hash, finalizes the context.

proc sha256CalculateHash*(dst: pointer; src: pointer; size: csize_t) {.cdecl,
    importc: "sha256CalculateHash".}
## / Simple all-in-one SHA256 calculator.

