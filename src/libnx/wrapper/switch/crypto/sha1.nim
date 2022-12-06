## *
##  @file sha1.h
##  @brief Hardware accelerated SHA1 implementation.
##  @copyright libnx Authors
##

import
  ../types

const
  SHA1_HASH_SIZE* = 0x14
  SHA1_BLOCK_SIZE* = 0x40
## / Context for SHA1 operations.

type
  Sha1Context* {.bycopy.} = object
    intermediateHash*: array[Sha1Hash_Size div sizeof((U32)), U32]
    buffer*: array[Sha1Block_Size, U8]
    bitsConsumed*: U64
    numBuffered*: csize_t
    finalized*: bool

proc sha1ContextCreate*(`out`: ptr Sha1Context) {.cdecl, importc: "sha1ContextCreate".}
## / Initialize a SHA1 context.

proc sha1ContextUpdate*(ctx: ptr Sha1Context; src: pointer; size: csize_t) {.cdecl,
    importc: "sha1ContextUpdate".}
## / Updates SHA1 context with data to hash

proc sha1ContextGetHash*(ctx: ptr Sha1Context; dst: pointer) {.cdecl,
    importc: "sha1ContextGetHash".}
## / Gets the context's output hash, finalizes the context.

proc sha1CalculateHash*(dst: pointer; src: pointer; size: csize_t) {.cdecl,
    importc: "sha1CalculateHash".}
## / Simple all-in-one SHA1 calculator.

