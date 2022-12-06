## *
##  @file psc.h
##  @brief PSC service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../kernel/event, ../sf/service

type
  PscPmState* = enum
    PscPmStateAwake = 0,        ## /< Everything is awake.
    PscPmStateReadyAwaken = 1,  ## /< Preparing to transition to awake.
    PscPmStateReadySleep = 2,   ## /< Preparing to transition to sleep.
    PscPmStateReadySleepCritical = 3, ## /< Critical services are ready to sleep.
    PscPmStateReadyAwakenCritical = 4, ## /< Critical services are ready to wake up.
    PscPmStateReadyShutdown = 5 ## /< Preparing to transition to shutdown.
  PscPmModuleId* = enum
    PscPmModuleIdUsb = 4, PscPmModuleIdEthernet = 5, PscPmModuleIdFgm = 6,
    PscPmModuleIdPcvClock = 7, PscPmModuleIdPcvVoltage = 8, PscPmModuleIdGpio = 9,
    PscPmModuleIdPinmux = 10, PscPmModuleIdUart = 11, PscPmModuleIdI2c = 12,
    PscPmModuleIdI2cPcv = 13, PscPmModuleIdSpi = 14, PscPmModuleIdPwm = 15,
    PscPmModuleIdPsm = 16, PscPmModuleIdTc = 17, PscPmModuleIdOmm = 18,
    PscPmModuleIdPcie = 19, PscPmModuleIdLbl = 20, PscPmModuleIdDisplay = 21,
    PscPmModuleIdHid = 24, PscPmModuleIdWlanSockets = 25, PscPmModuleIdFs = 27,
    PscPmModuleIdAudio = 28, PscPmModuleIdTmaHostIo = 30, PscPmModuleIdBluetooth = 31,
    PscPmModuleIdBpc = 32, PscPmModuleIdFan = 33, PscPmModuleIdPcm = 34,
    PscPmModuleIdNfc = 35, PscPmModuleIdApm = 36, PscPmModuleIdBtm = 37,
    PscPmModuleIdNifm = 38, PscPmModuleIdGpioLow = 39, PscPmModuleIdNpns = 40,
    PscPmModuleIdLm = 41, PscPmModuleIdBcat = 42, PscPmModuleIdTime = 43,
    PscPmModuleIdPctl = 44, PscPmModuleIdErpt = 45, PscPmModuleIdEupld = 46,
    PscPmModuleIdFriends = 47, PscPmModuleIdBgtc = 48, PscPmModuleIdAccount = 49,
    PscPmModuleIdSasbus = 50, PscPmModuleIdNtc = 51, PscPmModuleIdIdle = 52,
    PscPmModuleIdTcap = 53, PscPmModuleIdPsmLow = 54, PscPmModuleIdNdd = 55,
    PscPmModuleIdOlsc = 56, PscPmModuleIdNs = 61, PscPmModuleIdNvservices = 101,
    PscPmModuleIdSpsm = 127
  PscPmModule* {.bycopy.} = object
    event*: Event
    srv*: Service
    moduleId*: PscPmModuleId




## / Initialize psc:m.

proc pscmInitialize*(): Result {.cdecl, importc: "pscmInitialize".}
## / Exit psc:m.

proc pscmExit*() {.cdecl, importc: "pscmExit".}
## / Gets the Service object for the actual psc:m service session.

proc pscmGetServiceSession*(): ptr Service {.cdecl, importc: "pscmGetServiceSession".}
proc pscmGetPmModule*(`out`: ptr PscPmModule; moduleId: PscPmModuleId;
                     dependencies: ptr U32; dependencyCount: csize_t; autoclear: bool): Result {.
    cdecl, importc: "pscmGetPmModule".}
proc pscPmModuleGetRequest*(module: ptr PscPmModule; outState: ptr PscPmState;
                           outFlags: ptr U32): Result {.cdecl,
    importc: "pscPmModuleGetRequest".}
proc pscPmModuleAcknowledge*(module: ptr PscPmModule; state: PscPmState): Result {.
    cdecl, importc: "pscPmModuleAcknowledge".}
proc pscPmModuleFinalize*(module: ptr PscPmModule): Result {.cdecl,
    importc: "pscPmModuleFinalize".}
proc pscPmModuleClose*(module: ptr PscPmModule) {.cdecl, importc: "pscPmModuleClose".}