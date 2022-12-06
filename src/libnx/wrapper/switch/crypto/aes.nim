## *
##  @file aes.h
##  @brief Hardware accelerated AES-ECB implementation.
##  @copyright libnx Authors
##

import
  ../types

const
  AES_BLOCK_SIZE* = 0x10
  AES_128_KEY_SIZE* = 0x10
  AES_128_U32_PER_KEY* = (Aes_128Key_Size div sizeof((U32)))
  AES_128_NUM_ROUNDS* = 10
  AES_192_KEY_SIZE* = 0x18
  AES_192_U32_PER_KEY* = (Aes_192Key_Size div sizeof((U32)))
  AES_192_NUM_ROUNDS* = 12
  AES_256_KEY_SIZE* = 0x20
  AES_256_U32_PER_KEY* = (Aes_256Key_Size div sizeof((U32)))
  AES_256_NUM_ROUNDS* = 14

## / Context for AES-128 operations.

type
  Aes128Context* {.bycopy.} = object
    roundKeys*: array[Aes_128Num_Rounds + 1, array[Aes_Block_Size, U8]]


## / Context for AES-192 operations.

type
  Aes192Context* {.bycopy.} = object
    roundKeys*: array[Aes_192Num_Rounds + 1, array[Aes_Block_Size, U8]]


## / Context for AES-256 operations.

type
  Aes256Context* {.bycopy.} = object
    roundKeys*: array[Aes_256Num_Rounds + 1, array[Aes_Block_Size, U8]]

proc aes128ContextCreate*(`out`: ptr Aes128Context; key: pointer; isEncryptor: bool) {.
    cdecl, importc: "aes128ContextCreate".}
## / Initialize a 128-bit AES context.

proc aes128EncryptBlock*(ctx: ptr Aes128Context; dst: pointer; src: pointer) {.cdecl,
    importc: "aes128EncryptBlock".}
## / Encrypt using an AES context (Requires is_encryptor when initializing)

proc aes128DecryptBlock*(ctx: ptr Aes128Context; dst: pointer; src: pointer) {.cdecl,
    importc: "aes128DecryptBlock".}
## / Decrypt using an AES context (Requires !is_encryptor when initializing)

proc aes192ContextCreate*(`out`: ptr Aes192Context; key: pointer; isEncryptor: bool) {.
    cdecl, importc: "aes192ContextCreate".}
## / Initialize a 192-bit AES context.

proc aes192EncryptBlock*(ctx: ptr Aes192Context; dst: pointer; src: pointer) {.cdecl,
    importc: "aes192EncryptBlock".}
## / Encrypt using an AES context (Requires is_encryptor when initializing)

proc aes192DecryptBlock*(ctx: ptr Aes192Context; dst: pointer; src: pointer) {.cdecl,
    importc: "aes192DecryptBlock".}
## / Decrypt using an AES context (Requires !is_encryptor when initializing)

proc aes256ContextCreate*(`out`: ptr Aes256Context; key: pointer; isEncryptor: bool) {.
    cdecl, importc: "aes256ContextCreate".}
## / Initialize a 256-bit AES context.

proc aes256EncryptBlock*(ctx: ptr Aes256Context; dst: pointer; src: pointer) {.cdecl,
    importc: "aes256EncryptBlock".}
## / Encrypt using an AES context (Requires is_encryptor when initializing)

proc aes256DecryptBlock*(ctx: ptr Aes256Context; dst: pointer; src: pointer) {.cdecl,
    importc: "aes256DecryptBlock".}
## / Decrypt using an AES context (Requires !is_encryptor when initializing)

