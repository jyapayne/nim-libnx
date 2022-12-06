## *
##  @file pcv.h
##  @brief PCV service IPC wrapper.
##  @author SciresM
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

type
  PcvModule* = enum
    PcvModuleCpuBus = 0, PcvModuleGPU = 1, PcvModuleI2S1 = 2, PcvModuleI2S2 = 3,
    PcvModuleI2S3 = 4, PcvModulePWM = 5, PcvModuleI2C1 = 6, PcvModuleI2C2 = 7,
    PcvModuleI2C3 = 8, PcvModuleI2C4 = 9, PcvModuleI2C5 = 10, PcvModuleI2C6 = 11,
    PcvModuleSPI1 = 12, PcvModuleSPI2 = 13, PcvModuleSPI3 = 14, PcvModuleSPI4 = 15,
    PcvModuleDISP1 = 16, PcvModuleDISP2 = 17, PcvModuleISP = 18, PcvModuleVI = 19,
    PcvModuleSDMMC1 = 20, PcvModuleSDMMC2 = 21, PcvModuleSDMMC3 = 22,
    PcvModuleSDMMC4 = 23, PcvModuleOWR = 24, PcvModuleCSITE = 25, PcvModuleTSEC = 26,
    PcvModuleMSELECT = 27, PcvModuleHDA2CODEC_2X = 28, PcvModuleACTMON = 29,
    PcvModuleI2C_SLOW = 30, PcvModuleSOR1 = 31, PcvModuleSATA = 32, PcvModuleHDA = 33,
    PcvModuleXUSB_CORE_HOST = 34, PcvModuleXUSB_FALCON = 35, PcvModuleXUSB_FS = 36,
    PcvModuleXUSB_CORE_DEV = 37, PcvModuleXUSB_SS_HOSTDEV = 38, PcvModuleUARTA = 39,
    PcvModuleUARTB = 40, PcvModuleUARTC = 41, PcvModuleUARTD = 42, PcvModuleHOST1X = 43,
    PcvModuleENTROPY = 44, PcvModuleSOC_THERM = 45, PcvModuleVIC = 46,
    PcvModuleNVENC = 47, PcvModuleNVJPG = 48, PcvModuleNVDEC = 49, PcvModuleQSPI = 50,
    PcvModuleVI_I2C = 51, PcvModuleTSECB = 52, PcvModuleAPE = 53, PcvModuleACLK = 54,
    PcvModuleUARTAPE = 55, PcvModuleEMC = 56, PcvModulePLLE00 = 57, PcvModulePLLE01 = 58,
    PcvModuleDSI = 59, PcvModuleMAUD = 60, PcvModuleDPAUX1 = 61, PcvModuleMIPI_CAL = 62,
    PcvModuleUART_FST_MIPI_CAL = 63, PcvModuleOSC = 64, PcvModuleSCLK = 65,
    PcvModuleSOR_SAFE = 66, PcvModuleXUSB_SS = 67, PcvModuleXUSB_HOST = 68,
    PcvModuleXUSB_DEV = 69, PcvModuleEXTPERIPH1 = 70, PcvModuleAHUB = 71,
    PcvModuleHDA2HDMICODEC = 72, PcvModulePLLP5 = 73, PcvModuleUSBD = 74,
    PcvModuleUSB2 = 75, PcvModulePCIE = 76, PcvModuleAFI = 77, PcvModulePCIEXCLK = 78,
    PcvModulePEX_USB_UPHY = 79, PcvModuleXUSB_PADCTL = 80, PcvModuleAPBDMA = 81,
    PcvModuleUSB2TRK = 82, PcvModulePLLE02 = 83, PcvModulePLLE03 = 84, PcvModuleCEC = 85,
    PcvModuleEXTPERIPH2 = 86, PcvModuleCount ##  Not a real module, used to know how many modules there are.


## / Module id returned by [8.0.0+] pcv services
## / See also: https://switchbrew.org/wiki/PCV_services#Modules

type
  PcvModuleId* = enum
    PcvModuleIdI2C1 = 0x02000001, PcvModuleIdI2C2 = 0x02000002,
    PcvModuleIdI2C3 = 0x02000003, PcvModuleIdI2C4 = 0x02000004,
    PcvModuleIdI2C5 = 0x02000005, PcvModuleIdI2C6 = 0x02000006,
    PcvModuleIdUARTA = 0x03000001, PcvModuleIdSPI1 = 0x07000000,
    PcvModuleIdSPI2 = 0x07000001, PcvModuleIdSPI3 = 0x07000002,
    PcvModuleIdSPI4 = 0x07000003, PcvModuleIdUARTB = 0x35000405,
    PcvModuleIdUARTC = 0x3500040F, PcvModuleIdUARTD = 0x37000001,
    PcvModuleIdCpuBus = 0x40000001, PcvModuleIdGPU = 0x40000002,
    PcvModuleIdI2S1 = 0x40000003, PcvModuleIdI2S2 = 0x40000004,
    PcvModuleIdI2S3 = 0x40000005, PcvModuleIdPWM = 0x40000006,
    PcvModuleIdDISP1 = 0x40000011, PcvModuleIdDISP2 = 0x40000012,
    PcvModuleIdISP = 0x40000013, PcvModuleIdVI = 0x40000014,
    PcvModuleIdSDMMC1 = 0x40000015, PcvModuleIdSDMMC2 = 0x40000016,
    PcvModuleIdSDMMC3 = 0x40000017, PcvModuleIdSDMMC4 = 0x40000018,
    PcvModuleIdOWR = 0x40000019, PcvModuleIdCSITE = 0x4000001A,
    PcvModuleIdTSEC = 0x4000001B, PcvModuleIdMSELECT = 0x4000001C,
    PcvModuleIdHDA2CODEC_2X = 0x4000001D, PcvModuleIdACTMON = 0x4000001E,
    PcvModuleIdI2C_SLOW = 0x4000001F, PcvModuleIdSOR1 = 0x40000020,
    PcvModuleIdSATA = 0x40000021, PcvModuleIdHDA = 0x40000022,
    PcvModuleIdXUSB_CORE_HOST = 0x40000023, PcvModuleIdXUSB_FALCON = 0x40000024,
    PcvModuleIdXUSB_FS = 0x40000025, PcvModuleIdXUSB_CORE_DEV = 0x40000026,
    PcvModuleIdXUSB_SS_HOSTDEV = 0x40000027, PcvModuleIdHOST1X = 0x4000002C,
    PcvModuleIdENTROPY = 0x4000002D, PcvModuleIdSOC_THERM = 0x4000002E,
    PcvModuleIdVIC = 0x4000002F, PcvModuleIdNVENC = 0x40000030,
    PcvModuleIdNVJPG = 0x40000031, PcvModuleIdNVDEC = 0x40000032,
    PcvModuleIdQSPI = 0x40000033, PcvModuleIdVI_I2C = 0x40000034,
    PcvModuleIdTSECB = 0x40000035, PcvModuleIdAPE = 0x40000036,
    PcvModuleIdACLK = 0x40000037, PcvModuleIdUARTAPE = 0x40000038,
    PcvModuleIdEMC = 0x40000039, PcvModuleIdPLLE00 = 0x4000003A,
    PcvModuleIdPLLE01 = 0x4000003B, PcvModuleIdDSI = 0x4000003C,
    PcvModuleIdMAUD = 0x4000003D, PcvModuleIdDPAUX1 = 0x4000003E,
    PcvModuleIdMIPI_CAL = 0x4000003F, PcvModuleIdUART_FST_MIPI_CAL = 0x40000040,
    PcvModuleIdOSC = 0x40000041, PcvModuleIdSCLK = 0x40000042,
    PcvModuleIdSOR_SAFE = 0x40000043, PcvModuleIdXUSB_SS = 0x40000044,
    PcvModuleIdXUSB_HOST = 0x40000045, PcvModuleIdXUSB_DEV = 0x40000046,
    PcvModuleIdEXTPERIPH1 = 0x40000047, PcvModuleIdAHUB = 0x40000048,
    PcvModuleIdHDA2HDMICODEC = 0x40000049, PcvModuleIdPLLP5 = 0x4000004A,
    PcvModuleIdUSBD = 0x4000004B, PcvModuleIdUSB2 = 0x4000004C,
    PcvModuleIdPCIE = 0x4000004D, PcvModuleIdAFI = 0x4000004E,
    PcvModuleIdPCIEXCLK = 0x4000004F, PcvModuleIdPEX_USB_UPHY = 0x40000050,
    PcvModuleIdXUSB_PADCTL = 0x40000051, PcvModuleIdAPBDMA = 0x40000052,
    PcvModuleIdUSB2TRK = 0x40000053, PcvModuleIdPLLE02 = 0x40000054,
    PcvModuleIdPLLE03 = 0x40000055, PcvModuleIdCEC = 0x40000056,
    PcvModuleIdEXTPERIPH2 = 0x40000057


## / Initialize pcv.

proc pcvInitialize*(): Result {.cdecl, importc: "pcvInitialize".}
## / Exit pcv.

proc pcvExit*() {.cdecl, importc: "pcvExit".}
## / Gets the Service object for the actual pcv service session.

proc pcvGetServiceSession*(): ptr Service {.cdecl, importc: "pcvGetServiceSession".}
proc pcvGetModuleId*(moduleId: ptr PcvModuleId; module: PcvModule): Result {.cdecl,
    importc: "pcvGetModuleId".}
## / Only available on [1.0.0-7.0.1].

proc pcvGetClockRate*(module: PcvModule; outHz: ptr U32): Result {.cdecl,
    importc: "pcvGetClockRate".}
## / Only available on [1.0.0-7.0.1].

proc pcvSetClockRate*(module: PcvModule; hz: U32): Result {.cdecl,
    importc: "pcvSetClockRate".}
## / Only available on [1.0.0-7.0.1].

proc pcvSetVoltageEnabled*(powerDomain: U32; state: bool): Result {.cdecl,
    importc: "pcvSetVoltageEnabled".}
## / Only available on [1.0.0-7.0.1].

proc pcvGetVoltageEnabled*(isEnabled: ptr bool; powerDomain: U32): Result {.cdecl,
    importc: "pcvGetVoltageEnabled".}