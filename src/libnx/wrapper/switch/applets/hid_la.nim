## *
##  @file hid_la.h
##  @brief Wrapper for using the controller LibraryApplet.
##  @author yellowS8
##  @copyright libnx Authors
##

import
  ../types, ../services/hid

## / Mode values for HidLaControllerSupportArgPrivate::mode.

type
  HidLaControllerSupportMode* = enum
    HidLaControllerSupportMode_ShowControllerSupport = 0, ## /< ShowControllerSupport
    HidLaControllerSupportMode_ShowControllerStrapGuide = 1, ## /< [3.0.0+] ShowControllerStrapGuide
    HidLaControllerSupportMode_ShowControllerFirmwareUpdate = 2, ## /< [3.0.0+] ShowControllerFirmwareUpdate
    HidLaControllerSupportMode_ShowControllerKeyRemappingForSystem = 4 ## /< [11.0.0+] ShowControllerKeyRemappingForSystem


## / ControllerSupportCaller

type
  HidLaControllerSupportCaller* = enum
    HidLaControllerSupportCaller_Application = 0, ## /< Application, this is the default.
    HidLaControllerSupportCaller_System = 1 ## /< System. Skips the firmware-update confirmation dialog. This has the same affect as using the controller-update option from qlaunch System Settings.


## / ControllerSupportArgPrivate

type
  HidLaControllerSupportArgPrivate* {.bycopy.} = object
    private_size*: U32         ## /< Size of this ControllerSupportArgPrivate struct.
    arg_size*: U32             ## /< Size of the storage following this one (\ref HidLaControllerSupportArg or \ref HidLaControllerFirmwareUpdateArg).
    flag0*: U8                 ## /< Flag0
    flag1*: U8                 ## /< Flag1
    mode*: U8                  ## /< \ref HidLaControllerSupportMode
    controller_support_caller*: U8 ## /< \ref HidLaControllerSupportCaller. Always zero except with \ref hidLaShowControllerFirmwareUpdateForSystem, which sets this to the input param.
    npad_style_set*: U32       ## /< Output from \ref hidGetSupportedNpadStyleSet. With ShowControllerSupportForSystem on pre-3.0.0 this is value 0.
    npad_joy_hold_type*: U32   ## /< Output from \ref hidGetNpadJoyHoldType. With ShowControllerSupportForSystem on pre-3.0.0 this is value 1.


## / Common header used by HidLaControllerSupportArg*.
## / max_supported_players is 4 on pre-8.0.0, 8 on [8.0.0+]. player_count_min and player_count_max are overriden with value 4 when larger than value 4, during conversion handling for \ref HidLaControllerSupportArg on pre-8.0.0.

type
  HidLaControllerSupportArgHeader* {.bycopy.} = object
    player_count_min*: S8      ## /< playerCountMin. Must be >=0 and <=max_supported_players.
    player_count_max*: S8      ## /< playerCountMax. Must be >=1 and <=max_supported_players.
    enable_take_over_connection*: U8 ## /< enableTakeOverConnection, non-zero to enable. Disconnects the controllers when not enabled.
    enable_left_justify*: U8   ## /< enableLeftJustify, non-zero to enable.
    enable_permit_joy_dual*: U8 ## /< enablePermitJoyDual, non-zero to enable.
    enable_single_mode*: U8    ## /< enableSingleMode, non-zero to enable. Enables using a single player in handheld-mode, dual-mode, or single-mode (player_count_* are overridden). Using handheld-mode is not allowed if this is not enabled.
    enable_identification_color*: U8 ## /< When non-zero enables using identification_color.


## / Identification color used by HidLaControllerSupportArg*. When HidLaControllerSupportArgHeader::enable_identification_color is set this controls the color of the UI player box outline.

type
  HidLaControllerSupportArgColor* {.bycopy.} = object
    r*: U8                     ## /< Red color component.
    g*: U8                     ## /< Green color component.
    b*: U8                     ## /< Blue color component.
    a*: U8                     ## /< Alpha color component.


## / ControllerSupportArg for [1.0.0+].

type
  HidLaControllerSupportArgV3* {.bycopy.} = object
    hdr*: HidLaControllerSupportArgHeader ## /< \ref HidLaControllerSupportArgHeader
    identification_color*: array[4, HidLaControllerSupportArgColor] ## /< \ref HidLaControllerSupportArgColor for each player, see HidLaControllerSupportArgHeader::enable_identification_color.
    enable_explain_text*: U8   ## /< Enables using the ExplainText data when non-zero.
    explain_text*: array[4, array[0x81, char]] ## /< ExplainText for each player, NUL-terminated UTF-8 strings.


## / ControllerSupportArg for [8.0.0+], converted to \ref HidLaControllerSupportArgV3 on pre-8.0.0.

type
  HidLaControllerSupportArg* {.bycopy.} = object
    hdr*: HidLaControllerSupportArgHeader ## /< \ref HidLaControllerSupportArgHeader
    identification_color*: array[8, HidLaControllerSupportArgColor] ## /< \ref HidLaControllerSupportArgColor for each player, see HidLaControllerSupportArgHeader::enable_identification_color.
    enable_explain_text*: U8   ## /< Enables using the ExplainText data when non-zero.
    explain_text*: array[8, array[0x81, char]] ## /< ExplainText for each player, NUL-terminated UTF-8 strings.


## / ControllerFirmwareUpdateArg

type
  HidLaControllerFirmwareUpdateArg* {.bycopy.} = object
    enable_force_update*: U8   ## /< enableForceUpdate, non-zero to enable. Default is 0. Forces a firmware update when enabled, without an UI option to skip it.
    pad*: array[3, U8]          ## /< Padding.


## / ControllerKeyRemappingArg

type
  HidLaControllerKeyRemappingArg* {.bycopy.} = object
    unk_x0*: U64               ## /< Unknown
    unk_x8*: U32               ## /< Unknown
    pad*: array[0x4, U8]        ## /< Padding


## / ControllerSupportResultInfo. First 8-bytes from the applet output storage.

type
  HidLaControllerSupportResultInfo* {.bycopy.} = object
    player_count*: S8          ## /< playerCount.
    pad*: array[3, U8]          ## /< Padding.
    selected_id*: U32          ## /< \ref HidNpadIdType, selectedId.


## / Struct for the applet output storage.

type
  HidLaControllerSupportResultInfoInternal* {.bycopy.} = object
    info*: HidLaControllerSupportResultInfo ## /< \ref HidLaControllerSupportResultInfo
    res*: U32                  ## /< Output res value.

proc hidLaCreateControllerSupportArg*(arg: ptr HidLaControllerSupportArg) {.cdecl,
    importc: "hidLaCreateControllerSupportArg".}
## *
##  @brief Initializes a \ref HidLaControllerSupportArg with the defaults.
##  @note This clears the arg, then does: HidLaControllerSupportArgHeader::player_count_min = 0, HidLaControllerSupportArgHeader::player_count_max = 4, HidLaControllerSupportArgHeader::enable_take_over_connection = 1, HidLaControllerSupportArgHeader::enable_left_justify = 1, and HidLaControllerSupportArgHeader::enable_permit_joy_dual = 1.
##  @note If preferred, you can also memset \ref HidLaControllerSupportArg manually and initialize it yourself.
##  @param[out] arg \ref HidLaControllerSupportArg
##

proc hidLaCreateControllerFirmwareUpdateArg*(
    arg: ptr HidLaControllerFirmwareUpdateArg) {.cdecl,
    importc: "hidLaCreateControllerFirmwareUpdateArg".}
## *
##  @brief Initializes a \ref HidLaControllerFirmwareUpdateArg with the defaults.
##  @note This just uses memset() with the arg.
##  @param[out] arg \ref HidLaControllerFirmwareUpdateArg
##

proc hidLaCreateControllerKeyRemappingArg*(
    arg: ptr HidLaControllerKeyRemappingArg) {.cdecl,
    importc: "hidLaCreateControllerKeyRemappingArg".}
## *
##  @brief Initializes a \ref HidLaControllerKeyRemappingArg with the defaults.
##  @note This just uses memset() with the arg.
##  @param[out] arg \ref HidLaControllerKeyRemappingArg
##

proc hidLaSetExplainText*(arg: ptr HidLaControllerSupportArg; str: cstring;
                         id: HidNpadIdType): Result {.cdecl,
    importc: "hidLaSetExplainText".}
## *
##  @brief Sets the ExplainText for the specified player and \ref HidLaControllerSupportArg.
##  @note This string is displayed in the UI box for the player.
##  @note HidLaControllerSupportArg::enable_explain_text must be set, otherwise this ExplainText is ignored.
##  @param arg \ref HidLaControllerSupportArg
##  @param[in] str Input ExplainText UTF-8 string, max length is 0x80 excluding NUL-terminator.
##  + @oaram[in] id Player controller, must be <8.
##

proc hidLaShowControllerSupport*(result_info: ptr HidLaControllerSupportResultInfo;
                                arg: ptr HidLaControllerSupportArg): Result {.cdecl,
    importc: "hidLaShowControllerSupport".}
## *
##  @brief Launches the applet for ControllerSupport.
##  @note This seems to only display the applet UI when doing so is actually needed? This doesn't apply to \ref hidLaShowControllerSupportForSystem.
##  @param[out] result_info \ref HidLaControllerSupportResultInfo. Optional, can be NULL.
##  @param[in] arg \ref HidLaControllerSupportArg
##

proc hidLaShowControllerStrapGuide*(): Result {.cdecl,
    importc: "hidLaShowControllerStrapGuide".}
## *
##  @brief Launches the applet for ControllerStrapGuide.
##  @note Only available on [3.0.0+].
##

proc hidLaShowControllerFirmwareUpdate*(arg: ptr HidLaControllerFirmwareUpdateArg): Result {.
    cdecl, importc: "hidLaShowControllerFirmwareUpdate".}
## *
##  @brief Launches the applet for ControllerFirmwareUpdate.
##  @note Only available on [3.0.0+].
##  @param[in] arg \ref HidLaControllerFirmwareUpdateArg
##

proc hidLaShowControllerSupportForSystem*(
    result_info: ptr HidLaControllerSupportResultInfo;
    arg: ptr HidLaControllerSupportArg; flag: bool): Result {.cdecl,
    importc: "hidLaShowControllerSupportForSystem".}
## *
##  @brief This is the system version of \ref hidLaShowControllerSupport.
##  @param[out] result_info \ref HidLaControllerSupportResultInfo. Optional, can be NULL.
##  @param[in] arg \ref HidLaControllerSupportArg
##  @param[in] flag Input flag. When true, the applet displays the menu as if launched by qlaunch.
##

proc hidLaShowControllerFirmwareUpdateForSystem*(
    arg: ptr HidLaControllerFirmwareUpdateArg; caller: HidLaControllerSupportCaller): Result {.
    cdecl, importc: "hidLaShowControllerFirmwareUpdateForSystem".}
## *
##  @brief This is the system version of \ref hidLaShowControllerFirmwareUpdate.
##  @note Only available on [3.0.0+].
##  @param[in] arg \ref HidLaControllerFirmwareUpdateArg
##  @param[in] caller \ref HidLaControllerSupportCaller
##

proc hidLaShowControllerKeyRemappingForSystem*(
    arg: ptr HidLaControllerKeyRemappingArg; caller: HidLaControllerSupportCaller): Result {.
    cdecl, importc: "hidLaShowControllerKeyRemappingForSystem".}
## *
##  @brief Launches the applet for ControllerKeyRemappingForSystem.
##  @note Only available on [11.0.0+].
##  @param[in] arg \ref HidLaControllerKeyRemappingArg
##  @param[in] caller \ref HidLaControllerSupportCaller
##

