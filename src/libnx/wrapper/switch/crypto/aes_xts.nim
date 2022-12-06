## *
##  @file AES_xts.h
##  @brief Hardware accelerated AES-XTS implementation.
##  @copyright libnx Authors
##

import
  aes, ../types

## / Context for AES-128 XTS.

type
  Aes128XtsContext* {.bycopy.} = object
    aesCtx*: Aes128Context
    tweakCtx*: Aes128Context
    tweak*: array[AES_Block_Size, U8]
    buffer*: array[AES_Block_Size, U8]
    numBuffered*: csize_t


## / Context for AES-192 XTS.

type
  Aes192XtsContext* {.bycopy.} = object
    aesCtx*: Aes192Context
    tweakCtx*: Aes192Context
    tweak*: array[AES_Block_Size, U8]
    buffer*: array[AES_Block_Size, U8]
    numBuffered*: csize_t


## / Context for AES-256 XTS.

type
  Aes256XtsContext* {.bycopy.} = object
    aesCtx*: Aes256Context
    tweakCtx*: Aes256Context
    tweak*: array[AES_Block_Size, U8]
    buffer*: array[AES_Block_Size, U8]
    numBuffered*: csize_t


## / 128-bit XTS API.

proc aes128XtsContextCreate*(`out`: ptr Aes128XtsContext; key0: pointer;
                            key1: pointer; isEncryptor: bool) {.cdecl,
    importc: "aes128XtsContextCreate".}
proc aes128XtsContextResetTweak*(ctx: ptr Aes128XtsContext; tweak: pointer) {.cdecl,
    importc: "aes128XtsContextResetTweak".}
proc aes128XtsContextResetSector*(ctx: ptr Aes128XtsContext; sector: uint64;
                                 isNintendo: bool) {.cdecl,
    importc: "aes128XtsContextResetSector".}
proc aes128XtsEncrypt*(ctx: ptr Aes128XtsContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes128XtsEncrypt".}
proc aes128XtsDecrypt*(ctx: ptr Aes128XtsContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes128XtsDecrypt".}

## / 192-bit XTS API.

proc aes192XtsContextCreate*(`out`: ptr Aes192XtsContext; key0: pointer;
                            key1: pointer; isEncryptor: bool) {.cdecl,
    importc: "aes192XtsContextCreate".}
proc aes192XtsContextResetTweak*(ctx: ptr Aes192XtsContext; tweak: pointer) {.cdecl,
    importc: "aes192XtsContextResetTweak".}
proc aes192XtsContextResetSector*(ctx: ptr Aes192XtsContext; sector: uint64;
                                 isNintendo: bool) {.cdecl,
    importc: "aes192XtsContextResetSector".}
proc aes192XtsEncrypt*(ctx: ptr Aes192XtsContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes192XtsEncrypt".}
proc aes192XtsDecrypt*(ctx: ptr Aes192XtsContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes192XtsDecrypt".}

## / 256-bit XTS API.

proc aes256XtsContextCreate*(`out`: ptr Aes256XtsContext; key0: pointer;
                            key1: pointer; isEncryptor: bool) {.cdecl,
    importc: "aes256XtsContextCreate".}
proc aes256XtsContextResetTweak*(ctx: ptr Aes256XtsContext; tweak: pointer) {.cdecl,
    importc: "aes256XtsContextResetTweak".}
proc aes256XtsContextResetSector*(ctx: ptr Aes256XtsContext; sector: uint64;
                                 isNintendo: bool) {.cdecl,
    importc: "aes256XtsContextResetSector".}
proc aes256XtsEncrypt*(ctx: ptr Aes256XtsContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes256XtsEncrypt".}
proc aes256XtsDecrypt*(ctx: ptr Aes256XtsContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes256XtsDecrypt".}
