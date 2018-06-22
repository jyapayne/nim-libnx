import strutils
import ospaths
const headerspl = currentSourcePath().splitPath().head & "/nx/include/switch/services/spl.h"
import libnx/types
type
  SplConfigItem* {.size: sizeof(cint).} = enum
    SplConfigItem_DisableProgramVerification = 1, SplConfigItem_DramId = 2,
    SplConfigItem_SecurityEngineIrqNumber = 3, SplConfigItem_Version = 4,
    SplConfigItem_HardwareType = 5, SplConfigItem_IsRetail = 6,
    SplConfigItem_IsRecoveryBoot = 7, SplConfigItem_DeviceId = 8,
    SplConfigItem_BootReason = 9, SplConfigItem_MemoryArrange = 10,
    SplConfigItem_IsDebugMode = 11, SplConfigItem_KernelMemoryConfiguration = 12,
    SplConfigItem_IsChargerHiZModeEnabled = 13, SplConfigItem_IsKiosk = 14,
    SplConfigItem_NewHardwareType = 15, SplConfigItem_NewKeyGeneration = 16,
    SplConfigItem_Package2Hash = 17
  RsaKeyVersion* {.size: sizeof(cint).} = enum
    RsaKeyVersion_Deprecated = 0, RsaKeyVersion_Extended = 1



proc splInitialize*(): Result {.cdecl, importc: "splInitialize", header: headerspl.}
proc splExit*() {.cdecl, importc: "splExit", header: headerspl.}
proc splCryptoInitialize*(): Result {.cdecl, importc: "splCryptoInitialize",
                                   header: headerspl.}
proc splCryptoExit*() {.cdecl, importc: "splCryptoExit", header: headerspl.}
proc splSslInitialize*(): Result {.cdecl, importc: "splSslInitialize",
                                header: headerspl.}
proc splSslExit*() {.cdecl, importc: "splSslExit", header: headerspl.}
proc splEsInitialize*(): Result {.cdecl, importc: "splEsInitialize",
                               header: headerspl.}
proc splEsExit*() {.cdecl, importc: "splEsExit", header: headerspl.}
proc splFsInitialize*(): Result {.cdecl, importc: "splFsInitialize",
                               header: headerspl.}
proc splFsExit*() {.cdecl, importc: "splFsExit", header: headerspl.}
proc splManuInitialize*(): Result {.cdecl, importc: "splManuInitialize",
                                 header: headerspl.}
proc splManuExit*() {.cdecl, importc: "splManuExit", header: headerspl.}
proc splGetConfig*(config_item: SplConfigItem; out_config: ptr uint64): Result {.cdecl,
    importc: "splGetConfig", header: headerspl.}
proc splUserExpMod*(input: pointer; modulus: pointer; exp: pointer; exp_size: csize;
                   dst: pointer): Result {.cdecl, importc: "splUserExpMod",
                                        header: headerspl.}
proc splSetConfig*(config_item: SplConfigItem; value: uint64): Result {.cdecl,
    importc: "splSetConfig", header: headerspl.}
proc splGetRandomBytes*(`out`: pointer; out_size: csize): Result {.cdecl,
    importc: "splGetRandomBytes", header: headerspl.}
proc splIsDevelopment*(out_is_development: ptr bool): Result {.cdecl,
    importc: "splIsDevelopment", header: headerspl.}
proc splSetSharedData*(value: uint32): Result {.cdecl, importc: "splSetSharedData",
    header: headerspl.}
proc splGetSharedData*(out_value: ptr uint32): Result {.cdecl,
    importc: "splGetSharedData", header: headerspl.}
proc splCryptoGenerateAesKek*(wrapped_kek: pointer; key_generation: uint32; option: uint32;
                             out_sealed_kek: pointer): Result {.cdecl,
    importc: "splCryptoGenerateAesKek", header: headerspl.}
proc splCryptoLoadAesKey*(sealed_kek: pointer; wrapped_key: pointer; keyslot: uint32): Result {.
    cdecl, importc: "splCryptoLoadAesKey", header: headerspl.}
proc splCryptoGenerateAesKey*(sealed_kek: pointer; wrapped_key: pointer;
                             out_sealed_key: pointer): Result {.cdecl,
    importc: "splCryptoGenerateAesKey", header: headerspl.}
proc splCryptoDecryptAesKey*(wrapped_key: pointer; key_generation: uint32; option: uint32;
                            out_sealed_key: pointer): Result {.cdecl,
    importc: "splCryptoDecryptAesKey", header: headerspl.}
proc splCryptoCryptAesCtr*(input: pointer; output: pointer; size: csize; ctr: pointer): Result {.
    cdecl, importc: "splCryptoCryptAesCtr", header: headerspl.}
proc splCryptoComputeCmac*(input: pointer; size: csize; keyslot: uint32; out_cmac: pointer): Result {.
    cdecl, importc: "splCryptoComputeCmac", header: headerspl.}
proc splCryptoLockAesEngine*(out_keyslot: ptr uint32): Result {.cdecl,
    importc: "splCryptoLockAesEngine", header: headerspl.}
proc splCryptoUnlockAesEngine*(keyslot: uint32): Result {.cdecl,
    importc: "splCryptoUnlockAesEngine", header: headerspl.}
proc splCryptoGetSecurityEngineEvent*(out_event: ptr Handle): Result {.cdecl,
    importc: "splCryptoGetSecurityEngineEvent", header: headerspl.}
proc splRsaDecryptPrivateKey*(sealed_kek: pointer; wrapped_key: pointer;
                             wrapped_rsa_key: pointer;
                             wrapped_rsa_key_size: csize; version: RsaKeyVersion;
                             dst: pointer; dst_size: csize): Result {.cdecl,
    importc: "splRsaDecryptPrivateKey", header: headerspl.}
proc splSslLoadSecureExpModKey*(sealed_kek: pointer; wrapped_key: pointer;
                               wrapped_rsa_key: pointer;
                               wrapped_rsa_key_size: csize; version: RsaKeyVersion): Result {.
    cdecl, importc: "splSslLoadSecureExpModKey", header: headerspl.}
proc splSslSecureExpMod*(input: pointer; modulus: pointer; dst: pointer): Result {.
    cdecl, importc: "splSslSecureExpMod", header: headerspl.}
proc splEsLoadRsaOaepKey*(sealed_kek: pointer; wrapped_key: pointer;
                         wrapped_rsa_key: pointer; wrapped_rsa_key_size: csize;
                         version: RsaKeyVersion): Result {.cdecl,
    importc: "splEsLoadRsaOaepKey", header: headerspl.}
proc splEsUnwrapRsaOaepWrappedTitlekey*(rsa_wrapped_titlekey: pointer;
                                       modulus: pointer; label_hash: pointer;
                                       label_hash_size: csize;
                                       key_generation: uint32;
                                       out_sealed_titlekey: pointer): Result {.
    cdecl, importc: "splEsUnwrapRsaOaepWrappedTitlekey", header: headerspl.}
proc splEsUnwrapAesWrappedTitlekey*(aes_wrapped_titlekey: pointer;
                                   key_generation: uint32;
                                   out_sealed_titlekey: pointer): Result {.cdecl,
    importc: "splEsUnwrapAesWrappedTitlekey", header: headerspl.}
proc splEsLoadSecureExpModKey*(sealed_kek: pointer; wrapped_key: pointer;
                              wrapped_rsa_key: pointer;
                              wrapped_rsa_key_size: csize; version: RsaKeyVersion): Result {.
    cdecl, importc: "splEsLoadSecureExpModKey", header: headerspl.}
proc splEsSecureExpMod*(input: pointer; modulus: pointer; dst: pointer): Result {.
    cdecl, importc: "splEsSecureExpMod", header: headerspl.}
proc splFsLoadSecureExpModKey*(sealed_kek: pointer; wrapped_key: pointer;
                              wrapped_rsa_key: pointer;
                              wrapped_rsa_key_size: csize; version: RsaKeyVersion): Result {.
    cdecl, importc: "splFsLoadSecureExpModKey", header: headerspl.}
proc splFsSecureExpMod*(input: pointer; modulus: pointer; dst: pointer): Result {.
    cdecl, importc: "splFsSecureExpMod", header: headerspl.}
proc splFsGenerateSpecificAesKey*(wrapped_key: pointer; key_generation: uint32;
                                 option: uint32; out_sealed_key: pointer): Result {.
    cdecl, importc: "splFsGenerateSpecificAesKey", header: headerspl.}
proc splFsLoadTitlekey*(sealed_titlekey: pointer; keyslot: uint32): Result {.cdecl,
    importc: "splFsLoadTitlekey", header: headerspl.}
proc splFsGetPackage2Hash*(out_hash: pointer): Result {.cdecl,
    importc: "splFsGetPackage2Hash", header: headerspl.}
proc splManuEncryptRsaKeyForImport*(sealed_kek_pre: pointer;
                                   wrapped_key_pre: pointer;
                                   sealed_kek_post: pointer;
                                   wrapped_kek_post: pointer; option: uint32;
                                   wrapped_rsa_key: pointer;
                                   out_wrapped_rsa_key: pointer;
                                   rsa_key_size: csize): Result {.cdecl,
    importc: "splManuEncryptRsaKeyForImport", header: headerspl.}