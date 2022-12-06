## *
##  @file ectx.h
##  @brief [11.0.0+] Error Context services IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

proc ectxrInitialize*(): Result {.cdecl, importc: "ectxrInitialize".}
## / Initialize ectx:r.

proc ectxrExit*() {.cdecl, importc: "ectxrExit".}
## / Exit ectx:r.

proc ectxrGetServiceSession*(): ptr Service {.cdecl,
    importc: "ectxrGetServiceSession".}
## / Gets the Service object for the actual ectx:r service session.

proc ectxrPullContext*(out0: ptr S32; outTotalSize: ptr U32; outSize: ptr U32;
                      dst: pointer; dstSize: csize_t; descriptor: U32; result: Result): Result {.
    cdecl, importc: "ectxrPullContext".}
## *
##  @brief Retrieves the error context associated with an error descriptor and result.
##  @param[out] out0 Output value.
##  @param[out] out_total_size Total error context size.
##  @param[out] out_size Error context size.
##  @param[out] dst Buffer for output error context.
##  @param[in] dst_size Buffer size for output error context.
##  @param[in] descriptor Error descriptor.
##  @param[in] result Error result.
##  @return Result code.
##

