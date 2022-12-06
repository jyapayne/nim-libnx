## *
##  @file spl.h
##  @brief Security Processor Liaison (spl*) service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../sf/service

const
  SPL_RSA_BUFFER_SIZE* = (0x100)

type
  SplConfigItem* = enum
    SplConfigItemDisableProgramVerification = 1, SplConfigItemDramId = 2,
    SplConfigItemSecurityEngineIrqNumber = 3, SplConfigItemVersion = 4,
    SplConfigItemHardwareType = 5, SplConfigItemIsRetail = 6,
    SplConfigItemIsRecoveryBoot = 7, SplConfigItemDeviceId = 8,
    SplConfigItemBootReason = 9, SplConfigItemMemoryArrange = 10,
    SplConfigItemIsDebugMode = 11, SplConfigItemKernelMemoryConfiguration = 12,
    SplConfigItemIsChargerHiZModeEnabled = 13, SplConfigItemIsKiosk = 14,
    SplConfigItemNewHardwareType = 15, SplConfigItemNewKeyGeneration = 16,
    SplConfigItemPackage2Hash = 17
  RsaKeyVersion* = enum
    RsaKeyVersionDeprecated = 0, RsaKeyVersionExtended = 1


proc splInitialize*(): Result {.cdecl, importc: "splInitialize".}
## / Initialize 'spl:'.

proc splExit*() {.cdecl, importc: "splExit".}
## / Exit 'spl:'.

proc splGetServiceSession*(): ptr Service {.cdecl, importc: "splGetServiceSession".}
## / Gets the Service object for the IGeneralInterface usable with spl*().

proc splCryptoInitialize*(): Result {.cdecl, importc: "splCryptoInitialize".}
## / Initialize spl:mig. On pre-4.0.0 this just calls \ref splInitialize.

proc splCryptoExit*() {.cdecl, importc: "splCryptoExit".}
## / Exit spl:mig. On pre-4.0.0 this just calls \ref splExit.

proc splCryptoGetServiceSession*(): ptr Service {.cdecl,
    importc: "splCryptoGetServiceSession".}
## / Gets the Service object for the IGeneralInterface usable with splCrypto*().

proc splSslInitialize*(): Result {.cdecl, importc: "splSslInitialize".}
## / Initialize spl:ssl. On pre-4.0.0 this just calls \ref splInitialize.

proc splSslExit*() {.cdecl, importc: "splSslExit".}
## / Exit spl:ssl. On pre-4.0.0 this just calls \ref splExit.

proc splSslGetServiceSession*(): ptr Service {.cdecl,
    importc: "splSslGetServiceSession".}
## / Gets the Service object for the IGeneralInterface usable with splSsl*().

proc splEsInitialize*(): Result {.cdecl, importc: "splEsInitialize".}
## / Initialize spl:es. On pre-4.0.0 this just calls \ref splInitialize.

proc splEsExit*() {.cdecl, importc: "splEsExit".}
## / Exit spl:es. On pre-4.0.0 this just calls \ref splExit.

proc splEsGetServiceSession*(): ptr Service {.cdecl,
    importc: "splEsGetServiceSession".}
## / Gets the Service object for the IGeneralInterface usable with splEs*().

proc splFsInitialize*(): Result {.cdecl, importc: "splFsInitialize".}
## / Initialize spl:fs. On pre-4.0.0 this just calls \ref splInitialize.

proc splFsExit*() {.cdecl, importc: "splFsExit".}
## / Exit spl:fs. On pre-4.0.0 this just calls \ref splExit.

proc splFsGetServiceSession*(): ptr Service {.cdecl,
    importc: "splFsGetServiceSession".}
## / Gets the Service object for the IGeneralInterface usable with splFs*().

proc splManuInitialize*(): Result {.cdecl, importc: "splManuInitialize".}
## / Initialize spl:manu. On pre-4.0.0 this just calls \ref splInitialize.

proc splManuExit*() {.cdecl, importc: "splManuExit".}
## / Exit spl:manu. On pre-4.0.0 this just calls \ref splExit.

proc splManuGetServiceSession*(): ptr Service {.cdecl,
    importc: "splManuGetServiceSession".}
## / Gets the Service object for the IGeneralInterface usable with splManu*().

proc splGetConfig*(configItem: SplConfigItem; outConfig: ptr U64): Result {.cdecl,
    importc: "splGetConfig".}
proc splUserExpMod*(input: pointer; modulus: pointer; exp: pointer; expSize: csize_t;
                   dst: pointer): Result {.cdecl, importc: "splUserExpMod".}
proc splSetConfig*(configItem: SplConfigItem; value: U64): Result {.cdecl,
    importc: "splSetConfig".}
proc splGetRandomBytes*(`out`: pointer; outSize: csize_t): Result {.cdecl,
    importc: "splGetRandomBytes".}
proc splIsDevelopment*(outIsDevelopment: ptr bool): Result {.cdecl,
    importc: "splIsDevelopment".}
proc splSetBootReason*(value: U32): Result {.cdecl, importc: "splSetBootReason".}
proc splGetBootReason*(outValue: ptr U32): Result {.cdecl, importc: "splGetBootReason".}
proc splCryptoGenerateAesKek*(wrappedKek: pointer; keyGeneration: U32; option: U32;
                             outSealedKek: pointer): Result {.cdecl,
    importc: "splCryptoGenerateAesKek".}
proc splCryptoLoadAesKey*(sealedKek: pointer; wrappedKey: pointer; keyslot: U32): Result {.
    cdecl, importc: "splCryptoLoadAesKey".}
proc splCryptoGenerateAesKey*(sealedKek: pointer; wrappedKey: pointer;
                             outSealedKey: pointer): Result {.cdecl,
    importc: "splCryptoGenerateAesKey".}
proc splCryptoDecryptAesKey*(wrappedKey: pointer; keyGeneration: U32; option: U32;
                            outSealedKey: pointer): Result {.cdecl,
    importc: "splCryptoDecryptAesKey".}
proc splCryptoCryptAesCtr*(input: pointer; output: pointer; size: csize_t;
                          keyslot: U32; ctr: pointer): Result {.cdecl,
    importc: "splCryptoCryptAesCtr".}
proc splCryptoComputeCmac*(input: pointer; size: csize_t; keyslot: U32;
                          outCmac: pointer): Result {.cdecl,
    importc: "splCryptoComputeCmac".}
proc splCryptoLockAesEngine*(outKeyslot: ptr U32): Result {.cdecl,
    importc: "splCryptoLockAesEngine".}
proc splCryptoUnlockAesEngine*(keyslot: U32): Result {.cdecl,
    importc: "splCryptoUnlockAesEngine".}
proc splCryptoGetSecurityEngineEvent*(outEvent: ptr Event): Result {.cdecl,
    importc: "splCryptoGetSecurityEngineEvent".}
proc splRsaDecryptPrivateKey*(sealedKek: pointer; wrappedKey: pointer;
                             wrappedRsaKey: pointer; wrappedRsaKeySize: csize_t;
                             version: RsaKeyVersion; dst: pointer; dstSize: csize_t): Result {.
    cdecl, importc: "splRsaDecryptPrivateKey".}
proc splSslLoadSecureExpModKey*(sealedKek: pointer; wrappedKey: pointer;
                               wrappedRsaKey: pointer; wrappedRsaKeySize: csize_t): Result {.
    cdecl, importc: "splSslLoadSecureExpModKey".}
proc splSslSecureExpMod*(input: pointer; modulus: pointer; dst: pointer): Result {.
    cdecl, importc: "splSslSecureExpMod".}
proc splEsLoadRsaOaepKey*(sealedKek: pointer; wrappedKey: pointer;
                         wrappedRsaKey: pointer; wrappedRsaKeySize: csize_t;
                         version: RsaKeyVersion): Result {.cdecl,
    importc: "splEsLoadRsaOaepKey".}
proc splEsUnwrapRsaOaepWrappedTitlekey*(rsaWrappedTitlekey: pointer;
                                       modulus: pointer; labelHash: pointer;
                                       labelHashSize: csize_t; keyGeneration: U32;
                                       outSealedTitlekey: pointer): Result {.cdecl,
    importc: "splEsUnwrapRsaOaepWrappedTitlekey".}
proc splEsUnwrapAesWrappedTitlekey*(aesWrappedTitlekey: pointer;
                                   keyGeneration: U32; outSealedTitlekey: pointer): Result {.
    cdecl, importc: "splEsUnwrapAesWrappedTitlekey".}
proc splEsLoadSecureExpModKey*(sealedKek: pointer; wrappedKey: pointer;
                              wrappedRsaKey: pointer; wrappedRsaKeySize: csize_t): Result {.
    cdecl, importc: "splEsLoadSecureExpModKey".}
proc splEsSecureExpMod*(input: pointer; modulus: pointer; dst: pointer): Result {.cdecl,
    importc: "splEsSecureExpMod".}
proc splEsUnwrapElicenseKey*(rsaWrappedElicenseKey: pointer; modulus: pointer;
                            labelHash: pointer; labelHashSize: csize_t;
                            keyGeneration: U32; outSealedElicenseKey: pointer): Result {.
    cdecl, importc: "splEsUnwrapElicenseKey".}
proc splEsLoadElicenseKey*(sealedElicenseKey: pointer; keyslot: U32): Result {.cdecl,
    importc: "splEsLoadElicenseKey".}
proc splFsLoadSecureExpModKey*(sealedKek: pointer; wrappedKey: pointer;
                              wrappedRsaKey: pointer; wrappedRsaKeySize: csize_t;
                              version: RsaKeyVersion): Result {.cdecl,
    importc: "splFsLoadSecureExpModKey".}
proc splFsSecureExpMod*(input: pointer; modulus: pointer; dst: pointer): Result {.cdecl,
    importc: "splFsSecureExpMod".}
proc splFsGenerateSpecificAesKey*(wrappedKey: pointer; keyGeneration: U32;
                                 option: U32; outSealedKey: pointer): Result {.cdecl,
    importc: "splFsGenerateSpecificAesKey".}
proc splFsLoadTitlekey*(sealedTitlekey: pointer; keyslot: U32): Result {.cdecl,
    importc: "splFsLoadTitlekey".}
proc splFsGetPackage2Hash*(outHash: pointer): Result {.cdecl,
    importc: "splFsGetPackage2Hash".}
proc splManuEncryptRsaKeyForImport*(sealedKekPre: pointer; wrappedKeyPre: pointer;
                                   sealedKekPost: pointer;
                                   wrappedKekPost: pointer; option: U32;
                                   wrappedRsaKey: pointer;
                                   outWrappedRsaKey: pointer; rsaKeySize: csize_t): Result {.
    cdecl, importc: "splManuEncryptRsaKeyForImport".}
