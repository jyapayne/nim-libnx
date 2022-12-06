## *
##  @file hmac.h
##  @brief Hardware accelerated HMAC-SHA(1, 256) implementation.
##  @copyright libnx Authors
##

import
  sha1, sha256, ../types

## / Context for HMAC-SHA1 operations.

type
  HmacSha1Context* {.bycopy.} = object
    shaCtx*: Sha1Context
    key*: array[Sha1Block_Size div sizeof(U32), U32]
    mac*: array[Sha1Hash_Size div sizeof(U32), U32]
    finalized*: bool


## / Context for HMAC-SHA256 operations.

type
  HmacSha256Context* {.bycopy.} = object
    shaCtx*: Sha256Context
    key*: array[Sha256Block_Size div sizeof((U32)), U32]
    mac*: array[Sha256Hash_Size div sizeof((U32)), U32]
    finalized*: bool


const
  HMAC_SHA1_KEY_MAX* = (sizeof(((cast[ptr HmacSha1Context](nil)).key)))
  HMAC_SHA256_KEY_MAX* = (sizeof(((cast[ptr HmacSha256Context](nil)).key)))

proc hmacSha256ContextCreate*(`out`: ptr HmacSha256Context; key: pointer;
                             keySize: csize_t) {.cdecl,
    importc: "hmacSha256ContextCreate".}
## / Initialize a HMAC-SHA256 context.

proc hmacSha256ContextUpdate*(ctx: ptr HmacSha256Context; src: pointer; size: csize_t) {.
    cdecl, importc: "hmacSha256ContextUpdate".}
## / Updates HMAC-SHA256 context with data to hash

proc hmacSha256ContextGetMac*(ctx: ptr HmacSha256Context; dst: pointer) {.cdecl,
    importc: "hmacSha256ContextGetMac".}
## / Gets the context's output mac, finalizes the context.

proc hmacSha256CalculateMac*(dst: pointer; key: pointer; keySize: csize_t;
                            src: pointer; size: csize_t) {.cdecl,
    importc: "hmacSha256CalculateMac".}
## / Simple all-in-one HMAC-SHA256 calculator.

proc hmacSha1ContextCreate*(`out`: ptr HmacSha1Context; key: pointer; keySize: csize_t) {.
    cdecl, importc: "hmacSha1ContextCreate".}
## / Initialize a HMAC-SHA1 context.

proc hmacSha1ContextUpdate*(ctx: ptr HmacSha1Context; src: pointer; size: csize_t) {.
    cdecl, importc: "hmacSha1ContextUpdate".}
## / Updates HMAC-SHA1 context with data to hash

proc hmacSha1ContextGetMac*(ctx: ptr HmacSha1Context; dst: pointer) {.cdecl,
    importc: "hmacSha1ContextGetMac".}
## / Gets the context's output mac, finalizes the context.

proc hmacSha1CalculateMac*(dst: pointer; key: pointer; keySize: csize_t; src: pointer;
                          size: csize_t) {.cdecl, importc: "hmacSha1CalculateMac".}
## / Simple all-in-one HMAC-SHA1 calculator.

