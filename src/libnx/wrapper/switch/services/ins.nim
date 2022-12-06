## *
##  @file ins.h
##  @brief INS services IPC wrapper.
##  @author averne
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../sf/service

## / Initialize ins:r.

proc insrInitialize*(): Result {.cdecl, importc: "insrInitialize".}
## / Exit ins:r.

proc insrExit*() {.cdecl, importc: "insrExit".}
## / Gets the Service object for the actual ins:r service session.

proc insrGetServiceSession*(): ptr Service {.cdecl, importc: "insrGetServiceSession".}
## *
##  @brief Retrieves the last system tick the event corresponding to the ID was signaled at.
##  @param[in] id Ins request ID (should be 0..4).
##  @param[out] tick.
##  @return Result code.
##  @note The tick is only updated once per second at minimum.
##

proc insrGetLastTick*(id: U32; tick: ptr U64): Result {.cdecl,
    importc: "insrGetLastTick".}
## *
##  @brief Retrieves the event corresponding to the ID.
##  @param[in] id Ins request ID (should be 0..4).
##  @param[out] out.
##  @return Result code.
##  @note The event is only signaled once per second at minimum.
##

proc insrGetReadableEvent*(id: U32; `out`: ptr Event): Result {.cdecl,
    importc: "insrGetReadableEvent".}
## / Initialize ins:s.

proc inssInitialize*(): Result {.cdecl, importc: "inssInitialize".}
## / Exit ins:s.

proc inssExit*() {.cdecl, importc: "inssExit".}
## / Gets the Service object for the actual ins:s service session.

proc inssGetServiceSession*(): ptr Service {.cdecl, importc: "inssGetServiceSession".}
## *
##  @brief Retrieves the event corresponding to the ID.
##  @param[in] id Ins send ID (should be 0..11).
##  @param[out] out.
##  @return Result code.
##  @note The returned event cannot be waited on, only signaled. Clearing is handled by the service.
##

proc inssGetWritableEvent*(id: U32; `out`: ptr Event): Result {.cdecl,
    importc: "inssGetWritableEvent".}