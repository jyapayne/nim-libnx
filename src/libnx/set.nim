import strutils
import ospaths
const headerset = currentSourcePath().splitPath().head & "/nx/include/switch/services/set.h"
import libnx/types
import libnx/result
const
  SET_MAX_NAME_SIZE* = 0x00000048

type
  ColorSetId* {.size: sizeof(cint).} = enum
    ColorSetId_Light = 0, ColorSetId_Dark = 1
  SetLanguage* {.size: sizeof(cint).} = enum
    SetLanguage_JA = 0, SetLanguage_ENUS = 1, SetLanguage_FR = 2, SetLanguage_DE = 3,
    SetLanguage_IT = 4, SetLanguage_ES = 5, SetLanguage_ZHCN = 6, SetLanguage_KO = 7,
    SetLanguage_NL = 8, SetLanguage_PT = 9, SetLanguage_RU = 10, SetLanguage_ZHTW = 11,
    SetLanguage_ENGB = 12, SetLanguage_FRCA = 13, SetLanguage_ES419 = 14,
    SetLanguage_Total
  SetRegion* {.size: sizeof(cint).} = enum
    SetRegion_JPN = 0, SetRegion_USA = 1, SetRegion_EUR = 2, SetRegion_AUS = 3
  SetSysFlag* {.size: sizeof(cint).} = enum
    SetSysFlag_LockScreen = 7, SetSysFlag_ConsoleInformationUpload = 25,
    SetSysFlag_AutomaticApplicationDownload = 27, SetSysFlag_Quest = 47,
    SetSysFlag_Usb30Enable = 65, SetSysFlag_NfcEnable = 69,
    SetSysFlag_WirelessLanEnable = 73, SetSysFlag_BluetoothEnable = 88,
    SetSysFlag_AutoUpdateEnable = 95, SetSysFlag_BatteryPercentage = 99,
    SetSysFlag_ExternalRtcReset = 101, SetSysFlag_UsbFullKeyEnable = 103,
    SetSysFlag_BluetoothAfhEnable = 111, SetSysFlag_BluetoothBoostEnable = 113,
    SetSysFlag_InRepairProcessEnable = 115, SetSysFlag_HeadphoneVolumeUpdate = 117





proc setInitialize*(): Result {.cdecl, importc: "setInitialize", header: headerset.}
proc setExit*() {.cdecl, importc: "setExit", header: headerset.}
proc setMakeLanguage*(LanguageCode: uint64; Language: ptr s32): Result {.cdecl,
    importc: "setMakeLanguage", header: headerset.}
proc setMakeLanguageCode*(Language: s32; LanguageCode: ptr uint64): Result {.cdecl,
    importc: "setMakeLanguageCode", header: headerset.}
proc setGetSystemLanguage*(LanguageCode: ptr uint64): Result {.cdecl,
    importc: "setGetSystemLanguage", header: headerset.}
proc setGetLanguageCode*(LanguageCode: ptr uint64): Result {.cdecl,
    importc: "setGetLanguageCode", header: headerset.}
proc setGetAvailableLanguageCodes*(total_entries: ptr s32; LanguageCodes: ptr uint64;
                                  max_entries: csize): Result {.cdecl,
    importc: "setGetAvailableLanguageCodes", header: headerset.}
proc setGetAvailableLanguageCodeCount*(total: ptr s32): Result {.cdecl,
    importc: "setGetAvailableLanguageCodeCount", header: headerset.}
proc setGetRegionCode*(`out`: ptr SetRegion): Result {.cdecl,
    importc: "setGetRegionCode", header: headerset.}
proc setsysInitialize*(): Result {.cdecl, importc: "setsysInitialize",
                                header: headerset.}
proc setsysExit*() {.cdecl, importc: "setsysExit", header: headerset.}
proc setsysGetColorSetId*(`out`: ptr ColorSetId): Result {.cdecl,
    importc: "setsysGetColorSetId", header: headerset.}
proc setsysSetColorSetId*(id: ColorSetId): Result {.cdecl,
    importc: "setsysSetColorSetId", header: headerset.}
proc setsysGetSettingsItemValueSize*(name: cstring; item_key: cstring;
                                    size_out: ptr uint64): Result {.cdecl,
    importc: "setsysGetSettingsItemValueSize", header: headerset.}
proc setsysGetSettingsItemValue*(name: cstring; item_key: cstring;
                                value_out: pointer; value_out_size: csize): Result {.
    cdecl, importc: "setsysGetSettingsItemValue", header: headerset.}
proc setsysGetSerialNumber*(serial: cstring): Result {.cdecl,
    importc: "setsysGetSerialNumber", header: headerset.}
proc setsysGetFlag*(flag: SetSysFlag; `out`: ptr bool): Result {.cdecl,
    importc: "setsysGetFlag", header: headerset.}
proc setsysSetFlag*(flag: SetSysFlag; enable: bool): Result {.cdecl,
    importc: "setsysSetFlag", header: headerset.}