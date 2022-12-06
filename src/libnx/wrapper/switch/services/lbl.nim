## *
##  @file lbl.h
##  @brief LBL service IPC wrapper.
##  @author SciresM, exelix
##  @copyright libnx Authors
##

import
  ../types, ../sf/service

type
  LblBacklightSwitchStatus* = enum
    LblBacklightSwitchStatusDisabled = 0, LblBacklightSwitchStatusEnabled = 1,
    LblBacklightSwitchStatusEnabling = 2, LblBacklightSwitchStatusDisabling = 3


## / Initialize lbl.

proc lblInitialize*(): Result {.cdecl, importc: "lblInitialize".}
## / Exit lbl.

proc lblExit*() {.cdecl, importc: "lblExit".}
## / Gets the Service object for the actual lbl service session.

proc lblGetServiceSession*(): ptr Service {.cdecl, importc: "lblGetServiceSession".}
proc lblSaveCurrentSetting*(): Result {.cdecl, importc: "lblSaveCurrentSetting".}
proc lblLoadCurrentSetting*(): Result {.cdecl, importc: "lblLoadCurrentSetting".}
## *
##  @note The brightness goes from 0 to 1.0.
##

proc lblSetCurrentBrightnessSetting*(brightness: cfloat): Result {.cdecl,
    importc: "lblSetCurrentBrightnessSetting".}
proc lblGetCurrentBrightnessSetting*(outValue: ptr cfloat): Result {.cdecl,
    importc: "lblGetCurrentBrightnessSetting".}
proc lblApplyCurrentBrightnessSettingToBacklight*(): Result {.cdecl,
    importc: "lblApplyCurrentBrightnessSettingToBacklight".}
proc lblGetBrightnessSettingAppliedToBacklight*(outValue: ptr cfloat): Result {.
    cdecl, importc: "lblGetBrightnessSettingAppliedToBacklight".}
proc lblSwitchBacklightOn*(fadeTime: U64): Result {.cdecl,
    importc: "lblSwitchBacklightOn".}
proc lblSwitchBacklightOff*(fadeTime: U64): Result {.cdecl,
    importc: "lblSwitchBacklightOff".}
proc lblGetBacklightSwitchStatus*(outValue: ptr LblBacklightSwitchStatus): Result {.
    cdecl, importc: "lblGetBacklightSwitchStatus".}
proc lblEnableDimming*(): Result {.cdecl, importc: "lblEnableDimming".}
proc lblDisableDimming*(): Result {.cdecl, importc: "lblDisableDimming".}
proc lblIsDimmingEnabled*(outValue: ptr bool): Result {.cdecl,
    importc: "lblIsDimmingEnabled".}
proc lblEnableAutoBrightnessControl*(): Result {.cdecl,
    importc: "lblEnableAutoBrightnessControl".}
proc lblDisableAutoBrightnessControl*(): Result {.cdecl,
    importc: "lblDisableAutoBrightnessControl".}
proc lblIsAutoBrightnessControlEnabled*(outValue: ptr bool): Result {.cdecl,
    importc: "lblIsAutoBrightnessControlEnabled".}
proc lblSetAmbientLightSensorValue*(value: cfloat): Result {.cdecl,
    importc: "lblSetAmbientLightSensorValue".}
## *
##  @note Used internally by \ref appletGetAmbientLightSensorValue and \ref appletGetCurrentIlluminanceEx.
##

proc lblGetAmbientLightSensorValue*(overLimit: ptr bool; lux: ptr cfloat): Result {.
    cdecl, importc: "lblGetAmbientLightSensorValue".}
## *
##  @note Only available on [3.0.0+].
##  @note Used internally by \ref appletIsIlluminanceAvailable.
##

proc lblIsAmbientLightSensorAvailable*(outValue: ptr bool): Result {.cdecl,
    importc: "lblIsAmbientLightSensorAvailable".}
## *
##  @note Only available on [3.0.0+].
##

proc lblSetCurrentBrightnessSettingForVrMode*(brightness: cfloat): Result {.cdecl,
    importc: "lblSetCurrentBrightnessSettingForVrMode".}
## *
##  @note Only available on [3.0.0+].
##

proc lblGetCurrentBrightnessSettingForVrMode*(outValue: ptr cfloat): Result {.cdecl,
    importc: "lblGetCurrentBrightnessSettingForVrMode".}
## *
##  @note Only available on [3.0.0+].
##  @note Used internally by \ref appletSetVrModeEnabled.
##

proc lblEnableVrMode*(): Result {.cdecl, importc: "lblEnableVrMode".}
## *
##  @note Only available on [3.0.0+].
##  @note Used internally by \ref appletSetVrModeEnabled.
##

proc lblDisableVrMode*(): Result {.cdecl, importc: "lblDisableVrMode".}
## *
##  @note Only available on [3.0.0+].
##  @note Used internally by \ref appletIsVrModeEnabled.
##

proc lblIsVrModeEnabled*(outValue: ptr bool): Result {.cdecl,
    importc: "lblIsVrModeEnabled".}