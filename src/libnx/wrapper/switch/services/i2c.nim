## *
##  @file i2c.h
##  @brief I2C service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

type
  I2cDevice* = enum
    I2cDeviceDebugPad = 0, I2cDeviceTouchPanel = 1, I2cDeviceTmp451 = 2,
    I2cDeviceNct72 = 3, I2cDeviceAlc5639 = 4, I2cDeviceMax77620Rtc = 5,
    I2cDeviceMax77620Pmic = 6, I2cDeviceMax77621Cpu = 7, I2cDeviceMax77621Gpu = 8,
    I2cDeviceBq24193 = 9, I2cDeviceMax17050 = 10, I2cDeviceBm92t30mwv = 11,
    I2cDeviceIna226Vdd15v0Hb = 12, I2cDeviceIna226VsysCpuDs = 13,
    I2cDeviceIna226VsysGpuDs = 14, I2cDeviceIna226VsysDdrDs = 15,
    I2cDeviceIna226VsysAp = 16, I2cDeviceIna226VsysBlDs = 17, I2cDeviceBh1730 = 18,
    I2cDeviceIna226VsysCore = 19, I2cDeviceIna226Soc1V8 = 20,
    I2cDeviceIna226Lpddr1V8 = 21, I2cDeviceIna226Reg1V32 = 22,
    I2cDeviceIna226Vdd3V3Sys = 23, I2cDeviceHdmiDdc = 24, I2cDeviceHdmiScdc = 25,
    I2cDeviceHdmiHdcp = 26, I2cDeviceFan53528 = 27, I2cDeviceMax778123 = 28,
    I2cDeviceMax778122 = 29, I2cDeviceIna226VddDdr0V6 = 30, I2cDeviceCount
  I2cSession* {.bycopy.} = object
    s*: Service

  I2cTransactionOption* = enum
    I2cTransactionOptionStart = (1 shl 0),
    I2cTransactionOptionStop = (1 shl 1),
    I2cTransactionOptionAll = I2cTransactionOptionStart.cint or I2cTransactionOptionStop.cint




proc i2cInitialize*(): Result {.cdecl, importc: "i2cInitialize".}
## / Initialize i2c.

proc i2cExit*() {.cdecl, importc: "i2cExit".}
## / Exit i2c.

proc i2cGetServiceSession*(): ptr Service {.cdecl, importc: "i2cGetServiceSession".}
## / Gets the Service object for the actual i2c service session.
proc i2cOpenSession*(`out`: ptr I2cSession; dev: I2cDevice): Result {.cdecl,
    importc: "i2cOpenSession".}
proc i2csessionSendAuto*(s: ptr I2cSession; buf: pointer; size: csize_t;
                        option: I2cTransactionOption): Result {.cdecl,
    importc: "i2csessionSendAuto".}
proc i2csessionReceiveAuto*(s: ptr I2cSession; buf: pointer; size: csize_t;
                           option: I2cTransactionOption): Result {.cdecl,
    importc: "i2csessionReceiveAuto".}
proc i2csessionExecuteCommandList*(s: ptr I2cSession; dst: pointer; dstSize: csize_t;
                                  cmdList: pointer; cmdListSize: csize_t): Result {.
    cdecl, importc: "i2csessionExecuteCommandList".}
proc i2csessionClose*(s: ptr I2cSession) {.cdecl, importc: "i2csessionClose".}
