## *
##  @file AES_cbc.h
##  @brief Hardware accelerated AES-CBC implementation.
##  @copyright libnx Authors
##

import
  aes, ../types

## / Context for AES-128 CBC.

type
  Aes128CbcContext* {.bycopy.} = object
    aesCtx*: Aes128Context
    iv*: array[AES_Block_Size, U8]
    buffer*: array[AES_Block_Size, U8]
    numBuffered*: csize_t


## / Context for AES-192 CBC.

type
  Aes192CbcContext* {.bycopy.} = object
    aesCtx*: Aes192Context
    iv*: array[AES_Block_Size, U8]
    buffer*: array[AES_Block_Size, U8]
    numBuffered*: csize_t


## / Context for AES-256 CBC.

type
  Aes256CbcContext* {.bycopy.} = object
    aesCtx*: Aes256Context
    iv*: array[AES_Block_Size, U8]
    buffer*: array[AES_Block_Size, U8]
    numBuffered*: csize_t


## / 128-bit CBC API.

proc aes128CbcContextCreate*(`out`: ptr Aes128CbcContext; key: pointer; iv: pointer;
                            isEncryptor: bool) {.cdecl,
    importc: "aes128CbcContextCreate".}
proc aes128CbcContextResetIv*(ctx: ptr Aes128CbcContext; iv: pointer) {.cdecl,
    importc: "aes128CbcContextResetIv".}
proc aes128CbcEncrypt*(ctx: ptr Aes128CbcContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes128CbcEncrypt".}
proc aes128CbcDecrypt*(ctx: ptr Aes128CbcContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes128CbcDecrypt".}

## / 192-bit CBC API.

proc aes192CbcContextCreate*(`out`: ptr Aes192CbcContext; key: pointer; iv: pointer;
                            isEncryptor: bool) {.cdecl,
    importc: "aes192CbcContextCreate".}
proc aes192CbcContextResetIv*(ctx: ptr Aes192CbcContext; iv: pointer) {.cdecl,
    importc: "aes192CbcContextResetIv".}
proc aes192CbcEncrypt*(ctx: ptr Aes192CbcContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes192CbcEncrypt".}
proc aes192CbcDecrypt*(ctx: ptr Aes192CbcContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes192CbcDecrypt".}

## / 256-bit CBC API.

proc aes256CbcContextCreate*(`out`: ptr Aes256CbcContext; key: pointer; iv: pointer;
                            isEncryptor: bool) {.cdecl,
    importc: "aes256CbcContextCreate".}
proc aes256CbcContextResetIv*(ctx: ptr Aes256CbcContext; iv: pointer) {.cdecl,
    importc: "aes256CbcContextResetIv".}
proc aes256CbcEncrypt*(ctx: ptr Aes256CbcContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes256CbcEncrypt".}
proc aes256CbcDecrypt*(ctx: ptr Aes256CbcContext; dst: pointer; src: pointer;
                      size: csize_t): csize_t {.cdecl, importc: "aes256CbcDecrypt".}
