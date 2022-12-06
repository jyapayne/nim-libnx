## *
##  @file nfp_la.h
##  @brief Wrapper for using the cabinet (amiibo) LibraryApplet.
##  @author yellowS8
##  @copyright libnx Authors
##

import
  ../types, ../services/nfc

## / Values for NfpLaStartParamForAmiiboSettings::type.

type
  NfpLaStartParamTypeForAmiiboSettings* = enum
    NfpLaStartParamTypeForAmiiboSettings_NicknameAndOwnerSettings = 0, ## /< NicknameAndOwnerSettings
    NfpLaStartParamTypeForAmiiboSettings_GameDataEraser = 1, ## /< GameDataEraser
    NfpLaStartParamTypeForAmiiboSettings_Restorer = 2, ## /< Restorer
    NfpLaStartParamTypeForAmiiboSettings_Formatter = 3 ## /< Formatter


## / AmiiboSettingsStartParam

type
  NfpLaAmiiboSettingsStartParam* {.bycopy.} = object
    unk_x0*: array[0x8, U8]     ## /< Unknown
    unk_x8*: array[0x20, U8]    ## /< Unknown
    unk_x28*: U8               ## /< Unknown


## / StartParamForAmiiboSettings

type
  NfpLaStartParamForAmiiboSettings* {.bycopy.} = object
    unk_x0*: U8                ## /< Unknown
    `type`*: U8                ## /< \ref NfpLaStartParamTypeForAmiiboSettings
    flags*: U8                 ## /< Flags
    unk_x3*: U8                ## /< NfpLaAmiiboSettingsStartParam::unk_x28
    unk_x4*: array[0x8, U8]     ## /< NfpLaAmiiboSettingsStartParam::unk_x0
    tag_info*: NfpTagInfo      ## /< \ref NfpTagInfo, only enabled when flags bit1 is set.
    register_info*: NfpRegisterInfo ## /< \ref NfpRegisterInfo, only enabled when flags bit2 is set.
    unk_x164*: array[0x20, U8]  ## /< NfpLaAmiiboSettingsStartParam::unk_x8
    unk_x184*: array[0x24, U8]  ## /< Unknown


## / ReturnValueForAmiiboSettings

type
  NfpLaReturnValueForAmiiboSettings* {.bycopy.} = object
    flags*: U8                 ## /< 0 = error, non-zero = success.
    pad*: array[3, U8]          ## /< Padding
    handle*: NfcDeviceHandle   ## /< \ref NfcDeviceHandle
    tag_info*: NfpTagInfo      ## /< \ref NfpTagInfo
    register_info*: NfpRegisterInfo ## /< \ref NfpRegisterInfo, only available when flags bit2 is set.
    unk_x164*: array[0x24, U8]  ## /< Unknown

proc nfpLaStartNicknameAndOwnerSettings*(in_param: ptr NfpLaAmiiboSettingsStartParam;
                                        in_tag_info: ptr NfpTagInfo;
                                        in_reg_info: ptr NfpRegisterInfo;
                                        out_tag_info: ptr NfpTagInfo;
                                        handle: ptr NfcDeviceHandle;
                                        reg_info_flag: ptr bool;
                                        out_reg_info: ptr NfpRegisterInfo): Result {.
    cdecl, importc: "nfpLaStartNicknameAndOwnerSettings".}
## *
##  @brief Launches the applet for NicknameAndOwnerSettings.
##  @note Official sw does not expose functionality for using input/output \ref NfpTagInfo at the same time.
##  @param[in] in_param \ref NfpLaAmiiboSettingsStartParam
##  @param[in] in_tag_info \ref NfpTagInfo. Optional, can be NULL. If specified, this must match the scanned amiibo.
##  @param[in] in_reg_info \ref NfpRegisterInfo. Optional, can be NULL. If specified, this sets the \ref NfpRegisterInfo which will be used for writing, with an option for the user to change it.
##  @param[out] out_tag_info \ref NfpTagInfo. Optional, can be NULL.
##  @param[out] handle \ref NfcDeviceHandle
##  @param[out] reg_info_flag Flag indicating whether the data for out_reg_info is set. Optional, can be NULL.
##  @param[out] out_reg_info \ref NfpRegisterInfo, see reg_info_flag. Optional, can be NULL.
##

proc nfpLaStartGameDataEraser*(in_param: ptr NfpLaAmiiboSettingsStartParam;
                              in_tag_info: ptr NfpTagInfo;
                              out_tag_info: ptr NfpTagInfo;
                              handle: ptr NfcDeviceHandle): Result {.cdecl,
    importc: "nfpLaStartGameDataEraser".}
## *
##  @brief Launches the applet for GameDataEraser.
##  @note Official sw does not expose functionality for using input/output \ref NfpTagInfo at the same time.
##  @param[in] in_param \ref NfpLaAmiiboSettingsStartParam
##  @param[in] in_tag_info \ref NfpTagInfo. Optional, can be NULL. If specified, this must match the scanned amiibo.
##  @param[out] out_tag_info \ref NfpTagInfo. Optional, can be NULL.
##  @param[out] handle \ref NfcDeviceHandle
##

proc nfpLaStartRestorer*(in_param: ptr NfpLaAmiiboSettingsStartParam;
                        in_tag_info: ptr NfpTagInfo; out_tag_info: ptr NfpTagInfo;
                        handle: ptr NfcDeviceHandle): Result {.cdecl,
    importc: "nfpLaStartRestorer".}
## *
##  @brief Launches the applet for Restorer.
##  @note Official sw does not expose functionality for using input/output \ref NfpTagInfo at the same time.
##  @param[in] in_param \ref NfpLaAmiiboSettingsStartParam
##  @param[in] in_tag_info \ref NfpTagInfo. Optional, can be NULL. If specified, this must match the scanned amiibo.
##  @param[out] out_tag_info \ref NfpTagInfo. Optional, can be NULL.
##  @param[out] handle \ref NfcDeviceHandle
##

proc nfpLaStartFormatter*(in_param: ptr NfpLaAmiiboSettingsStartParam;
                         out_tag_info: ptr NfpTagInfo; handle: ptr NfcDeviceHandle): Result {.
    cdecl, importc: "nfpLaStartFormatter".}
## *
##  @brief Launches the applet for Formatter.
##  @param[in] in_param \ref NfpLaAmiiboSettingsStartParam
##  @param[out] out_tag_info \ref NfpTagInfo
##  @param[out] handle \ref NfcDeviceHandle
##

