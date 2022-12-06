## *
##  @file detect.h
##  @brief Kernel capability detection
##  @author plutoo
##  @copyright libnx Authors
##

import
  ../types, ../result, svc

## / Returns true if the process has a debugger attached.

proc detectDebugger*(): bool {.inline, cdecl, importc: "detectDebugger".} =
  var tmp: U64 = 0
  var rc: Result = svcGetInfo(addr(tmp), InfoTypeDebuggerAttached.uint32, Invalid_Handle, 0)
  return r_Succeeded(rc) and tmp != 0

## / Returns true if the underlying kernel is Mesosphère.

proc detectMesosphere*(): bool {.inline, cdecl, importc: "detectMesosphere".} =
  var dummy: U64 = 0
  var rc: Result = svcGetInfo(addr(dummy), 65000, Invalid_Handle, 0)
  ##  InfoType_MesosphereMeta
  return r_Succeeded(rc)
