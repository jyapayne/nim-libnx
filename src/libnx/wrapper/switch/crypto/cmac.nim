## *
##  @file cmac.h
##  @brief Hardware accelerated AES-CMAC implementation.
##  @copyright libnx Authors
##

import
  aes, ../types

## / Context for AES-128 CMAC.

type
  Aes128CmacContext* {.bycopy.} = object
    ctx*: Aes128Context
    subkey*: array[AES_Block_Size, U8]
    mac*: array[AES_Block_Size, U8]
    buffer*: array[AES_Block_Size, U8]
    numBuffered*: csize_t
    finalized*: bool


## / Context for AES-192 CMAC.

type
  Aes192CmacContext* {.bycopy.} = object
    ctx*: Aes192Context
    subkey*: array[AES_Block_Size, U8]
    mac*: array[AES_Block_Size, U8]
    buffer*: array[AES_Block_Size, U8]
    numBuffered*: csize_t
    finalized*: bool


## / Context for AES-256 CMAC.

type
  Aes256CmacContext* {.bycopy.} = object
    ctx*: Aes256Context
    subkey*: array[AES_Block_Size, U8]
    mac*: array[AES_Block_Size, U8]
    buffer*: array[AES_Block_Size, U8]
    numBuffered*: csize_t
    finalized*: bool

proc cmacAes128ContextCreate*(`out`: ptr Aes128CmacContext; key: pointer) {.cdecl,
    importc: "cmacAes128ContextCreate".}
## / Initialize an AES-128-CMAC context.

proc cmacAes128ContextUpdate*(ctx: ptr Aes128CmacContext; src: pointer; size: csize_t) {.
    cdecl, importc: "cmacAes128ContextUpdate".}
## / Updates AES-128-CMAC context with data to hash

proc cmacAes128ContextGetMac*(ctx: ptr Aes128CmacContext; dst: pointer) {.cdecl,
    importc: "cmacAes128ContextGetMac".}
## / Gets the context's output mac, finalizes the context.

proc cmacAes128CalculateMac*(dst: pointer; key: pointer; src: pointer; size: csize_t) {.
    cdecl, importc: "cmacAes128CalculateMac".}
## / Simple all-in-one AES-128-CMAC calculator.

proc cmacAes192ContextCreate*(`out`: ptr Aes192CmacContext; key: pointer) {.cdecl,
    importc: "cmacAes192ContextCreate".}
## / Initialize an AES-192-CMAC context.

proc cmacAes192ContextUpdate*(ctx: ptr Aes192CmacContext; src: pointer; size: csize_t) {.
    cdecl, importc: "cmacAes192ContextUpdate".}
## / Updates AES-192-CMAC context with data to hash

proc cmacAes192ContextGetMac*(ctx: ptr Aes192CmacContext; dst: pointer) {.cdecl,
    importc: "cmacAes192ContextGetMac".}
## / Gets the context's output mac, finalizes the context.

proc cmacAes192CalculateMac*(dst: pointer; key: pointer; src: pointer; size: csize_t) {.
    cdecl, importc: "cmacAes192CalculateMac".}
## / Simple all-in-one AES-192-CMAC calculator.

proc cmacAes256ContextCreate*(`out`: ptr Aes256CmacContext; key: pointer) {.cdecl,
    importc: "cmacAes256ContextCreate".}
## / Initialize an AES-256-CMAC context.

proc cmacAes256ContextUpdate*(ctx: ptr Aes256CmacContext; src: pointer; size: csize_t) {.
    cdecl, importc: "cmacAes256ContextUpdate".}
## / Updates AES-256-CMAC context with data to hash

proc cmacAes256ContextGetMac*(ctx: ptr Aes256CmacContext; dst: pointer) {.cdecl,
    importc: "cmacAes256ContextGetMac".}
## / Gets the context's output mac, finalizes the context.

proc cmacAes256CalculateMac*(dst: pointer; key: pointer; src: pointer; size: csize_t) {.
    cdecl, importc: "cmacAes256CalculateMac".}
## / Simple all-in-one AES-256-CMAC calculator.

