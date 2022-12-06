## *
##  @file AES_ctr.h
##  @brief Hardware accelerated AES-CTR implementation.
##  @copyright libnx Authors
##

import
  aes, ../types

## / Context for AES-128 CTR.

type
  Aes128CtrContext* {.bycopy.} = object
    aesCtx*: Aes128Context
    ctr*: array[AES_Block_Size, U8]
    encCtrBuffer*: array[AES_Block_Size, U8]
    bufferOffset*: csize_t


## / Context for AES-192 CTR.

type
  Aes192CtrContext* {.bycopy.} = object
    aesCtx*: Aes192Context
    ctr*: array[AES_Block_Size, U8]
    encCtrBuffer*: array[AES_Block_Size, U8]
    bufferOffset*: csize_t


## / Context for AES-256 CTR.

type
  Aes256CtrContext* {.bycopy.} = object
    aesCtx*: Aes256Context
    ctr*: array[AES_Block_Size, U8]
    encCtrBuffer*: array[AES_Block_Size, U8]
    bufferOffset*: csize_t


## / 128-bit CTR API.

proc aes128CtrContextCreate*(`out`: ptr Aes128CtrContext; key: pointer; ctr: pointer) {.
    cdecl, importc: "aes128CtrContextCreate".}
proc aes128CtrContextResetCtr*(ctx: ptr Aes128CtrContext; ctr: pointer) {.cdecl,
    importc: "aes128CtrContextResetCtr".}
proc aes128CtrCrypt*(ctx: ptr Aes128CtrContext; dst: pointer; src: pointer;
                    size: csize_t) {.cdecl, importc: "aes128CtrCrypt".}

## / 192-bit CTR API.

proc aes192CtrContextCreate*(`out`: ptr Aes192CtrContext; key: pointer; ctr: pointer) {.
    cdecl, importc: "aes192CtrContextCreate".}
proc aes192CtrContextResetCtr*(ctx: ptr Aes192CtrContext; ctr: pointer) {.cdecl,
    importc: "aes192CtrContextResetCtr".}
proc aes192CtrCrypt*(ctx: ptr Aes192CtrContext; dst: pointer; src: pointer;
                    size: csize_t) {.cdecl, importc: "aes192CtrCrypt".}

## / 256-bit CTR API.

proc aes256CtrContextCreate*(`out`: ptr Aes256CtrContext; key: pointer; ctr: pointer) {.
    cdecl, importc: "aes256CtrContextCreate".}
proc aes256CtrContextResetCtr*(ctx: ptr Aes256CtrContext; ctr: pointer) {.cdecl,
    importc: "aes256CtrContextResetCtr".}
proc aes256CtrCrypt*(ctx: ptr Aes256CtrContext; dst: pointer; src: pointer;
                    size: csize_t) {.cdecl, importc: "aes256CtrCrypt".}
