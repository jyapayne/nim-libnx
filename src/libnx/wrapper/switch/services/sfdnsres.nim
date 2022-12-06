## *
##  @file sfdnsres.h
##  @brief Domain name resolution service IPC wrapper. Please use the standard <netdb.h> interface instead.
##  @author TuxSH
##  @author fincs
##  @copyright libnx Authors
##

import
  ../types

##  SetDnsAddressesPrivateRequest & GetDnsAddressPrivateRequest are stubbed

proc sfdnsresGetHostByNameRequest*(cancelHandle: U32; useNsd: bool; name: cstring;
                                  hErrno: ptr U32; errno: ptr U32; outBuffer: pointer;
                                  outBufferSize: csize_t;
                                  outSerializedSize: ptr U32): Result {.cdecl,
    importc: "sfdnsresGetHostByNameRequest".}
proc sfdnsresGetHostByAddrRequest*(inAddr: pointer; inAddrLen: csize_t; `type`: U32;
                                  cancelHandle: U32; hErrno: ptr U32; errno: ptr U32;
                                  outBuffer: pointer; outBufferSize: csize_t;
                                  outSerializedSize: ptr U32): Result {.cdecl,
    importc: "sfdnsresGetHostByAddrRequest".}
proc sfdnsresGetHostStringErrorRequest*(err: U32; outStr: cstring;
                                       outStrSize: csize_t): Result {.cdecl,
    importc: "sfdnsresGetHostStringErrorRequest".}
proc sfdnsresGetGaiStringErrorRequest*(err: U32; outStr: cstring; outStrSize: csize_t): Result {.
    cdecl, importc: "sfdnsresGetGaiStringErrorRequest".}
proc sfdnsresGetAddrInfoRequest*(cancelHandle: U32; useNsd: bool; node: cstring;
                                service: cstring; inHints: pointer;
                                inHintsSize: csize_t; outBuffer: pointer;
                                outBufferSize: csize_t; errno: ptr U32; ret: ptr S32;
                                outSerializedSize: ptr U32): Result {.cdecl,
    importc: "sfdnsresGetAddrInfoRequest".}
proc sfdnsresGetNameInfoRequest*(flags: U32; inSa: pointer; inSaSize: csize_t;
                                outHost: cstring; outHostSize: csize_t;
                                outServ: cstring; outServLen: csize_t;
                                cancelHandle: U32; errno: ptr U32; ret: ptr S32): Result {.
    cdecl, importc: "sfdnsresGetNameInfoRequest".}
proc sfdnsresGetCancelHandleRequest*(outHandle: ptr U32): Result {.cdecl,
    importc: "sfdnsresGetCancelHandleRequest".}
proc sfdnsresCancelRequest*(handle: U32): Result {.cdecl,
    importc: "sfdnsresCancelRequest".}