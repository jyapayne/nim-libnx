## *
##  @file fan.h
##  @brief Fan service IPC wrapper.
##  @author Behemoth
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

type
  FanController* {.bycopy.} = object
    s*: Service


## / Initialize fan.

proc fanInitialize*(): Result {.cdecl, importc: "fanInitialize".}
## / Exit fan.

proc fanExit*() {.cdecl, importc: "fanExit".}
## / Gets the Service object for the actual fan service session.

proc fanGetServiceSession*(): ptr Service {.cdecl, importc: "fanGetServiceSession".}
## / Opens IController session.

proc fanOpenController*(`out`: ptr FanController; deviceCode: U32): Result {.cdecl,
    importc: "fanOpenController".}
## / Close IController session.

proc fanControllerClose*(controller: ptr FanController) {.cdecl,
    importc: "fanControllerClose".}
## / @warning Disabling your fan can damage your system.

proc fanControllerSetRotationSpeedLevel*(controller: ptr FanController;
                                        level: cfloat): Result {.cdecl,
    importc: "fanControllerSetRotationSpeedLevel".}
proc fanControllerGetRotationSpeedLevel*(controller: ptr FanController;
                                        level: ptr cfloat): Result {.cdecl,
    importc: "fanControllerGetRotationSpeedLevel".}