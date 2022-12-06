## *
##  @file nim.h
##  @brief Network Install Manager (nim) service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

## / SystemUpdateTaskId

type
  NimSystemUpdateTaskId* {.bycopy.} = object
    uuid*: Uuid                ## /< UUID


## / Initialize nim.

proc nimInitialize*(): Result {.cdecl, importc: "nimInitialize".}
## / Exit nim.

proc nimExit*() {.cdecl, importc: "nimExit".}
## / Gets the Service object for the actual nim service session.

proc nimGetServiceSession*(): ptr Service {.cdecl, importc: "nimGetServiceSession".}
proc nimListSystemUpdateTask*(outCount: ptr S32;
                             outTaskIds: ptr NimSystemUpdateTaskId;
                             maxTaskIds: csize_t): Result {.cdecl,
    importc: "nimListSystemUpdateTask".}
proc nimDestroySystemUpdateTask*(taskId: ptr NimSystemUpdateTaskId): Result {.cdecl,
    importc: "nimDestroySystemUpdateTask".}