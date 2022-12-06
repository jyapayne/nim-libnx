## *
##  @file mmu.h
##  @brief Multimedia (mm) IPC wrapper.
##  @author averne
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

type
  MmuModuleId* = enum
    MmuModuleIdRam = 2, MmuModuleIdNvenc = 5, MmuModuleIdNvdec = 6, MmuModuleIdNvjpg = 7
  MmuRequest* {.bycopy.} = object
    module*: MmuModuleId
    id*: U32



proc mmuInitialize*(): Result {.cdecl, importc: "mmuInitialize".}
proc mmuExit*() {.cdecl, importc: "mmuExit".}
proc mmuGetServiceSession*(): ptr Service {.cdecl, importc: "mmuGetServiceSession".}
proc mmuRequestInitialize*(request: ptr MmuRequest; module: MmuModuleId; unk: U32;
                          autoclear: bool): Result {.cdecl,
    importc: "mmuRequestInitialize".}
## /< unk is ignored by official software

proc mmuRequestFinalize*(request: ptr MmuRequest): Result {.cdecl,
    importc: "mmuRequestFinalize".}
proc mmuRequestGet*(request: ptr MmuRequest; outFreqHz: ptr U32): Result {.cdecl,
    importc: "mmuRequestGet".}
proc mmuRequestSetAndWait*(request: ptr MmuRequest; freqHz: U32; timeout: S32): Result {.
    cdecl, importc: "mmuRequestSetAndWait".}