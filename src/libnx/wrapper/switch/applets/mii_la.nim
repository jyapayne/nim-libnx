## *
##  @file mii_la.h
##  @brief Wrapper for using the MiiEdit LibraryApplet.
##  @author yellowS8
##  @copyright libnx Authors
##

import
  ../types, ../services/mii

## / AppletMode

type
  MiiLaAppletMode* = enum
    MiiLaAppletMode_ShowMiiEdit = 0, ## /< ShowMiiEdit
    MiiLaAppletMode_AppendMii = 1, ## /< AppendMii
    MiiLaAppletMode_AppendMiiImage = 2, ## /< AppendMiiImage
    MiiLaAppletMode_UpdateMiiImage = 3, ## /< UpdateMiiImage
    MiiLaAppletMode_CreateMii = 4, ## /< [10.2.0+] CreateMii
    MiiLaAppletMode_EditMii = 5 ## /< [10.2.0+] EditMii


## / AppletInput

type
  INNER_C_STRUCT_mii_la_35* {.bycopy.} = object
    char_info*: MiiCharInfo    ## /< \ref MiiCharInfo
    unused_x64*: array[0x28, U8] ## /< Unused

  INNER_C_UNION_mii_la_35* {.bycopy, union.} = object
    valid_uuid_array*: array[8, Uuid] ## /< ValidUuidArray. Only used with \ref MiiLaAppletMode ::NfpLaMiiLaAppletMode_AppendMiiImage / ::NfpLaMiiLaAppletMode_UpdateMiiImage.
    char_info*: INNER_C_STRUCT_mii_la_35

  MiiLaAppletInput* {.bycopy.} = object
    version*: S32              ## /< Version
    mode*: U32                 ## /< \ref MiiLaAppletMode
    special_key_code*: S32     ## /< \ref MiiSpecialKeyCode
    ano_mii_la_35*: INNER_C_UNION_mii_la_35
    used_uuid*: Uuid           ## /< UsedUuid. Only used with \ref MiiLaAppletMode ::NfpLaMiiLaAppletMode_UpdateMiiImage.
    unk_x9C*: array[0x64, U8]   ## /< Unused


## / AppletOutput

type
  MiiLaAppletOutput* {.bycopy.} = object
    res*: U32                  ## /< Result: 0 = Success, 1 = Cancel.
    index*: S32                ## /< Index. Only set when Result is Success, where \ref MiiLaAppletMode isn't ::NfpLaMiiLaAppletMode_ShowMiiEdit.
    unk_x8*: array[0x18, U8]    ## /< Unused


## / AppletOutputForCharInfoEditing

type
  MiiLaAppletOutputForCharInfoEditing* {.bycopy.} = object
    res*: U32                  ## /< MiiLaAppletOutput::res
    char_info*: MiiCharInfo    ## /< \ref MiiCharInfo
    unused*: array[0x24, U8]    ## /< Unused

proc miiLaShowMiiEdit*(special_key_code: MiiSpecialKeyCode): Result {.cdecl,
    importc: "miiLaShowMiiEdit".}
## *
##  @brief Launches the applet for ShowMiiEdit.
##  @param[in] special_key_code \ref MiiSpecialKeyCode
##

proc miiLaAppendMii*(special_key_code: MiiSpecialKeyCode; index: ptr S32): Result {.
    cdecl, importc: "miiLaAppendMii".}
## *
##  @brief Launches the applet for AppendMii.
##  @param[in] special_key_code \ref MiiSpecialKeyCode
##  @param[out] index Output Index.
##

proc miiLaAppendMiiImage*(special_key_code: MiiSpecialKeyCode;
                         valid_uuid_array: ptr Uuid; count: S32; index: ptr S32): Result {.
    cdecl, importc: "miiLaAppendMiiImage".}
## *
##  @brief Launches the applet for AppendMiiImage.
##  @param[in] special_key_code \ref MiiSpecialKeyCode
##  @param[in] valid_uuid_array Input array of Uuid.
##  @param[in] count Total entries for the valid_uuid_array. Must be 0-8.
##  @param[out] index Output Index.
##

proc miiLaUpdateMiiImage*(special_key_code: MiiSpecialKeyCode;
                         valid_uuid_array: ptr Uuid; count: S32; used_uuid: Uuid;
                         index: ptr S32): Result {.cdecl,
    importc: "miiLaUpdateMiiImage".}
## *
##  @brief Launches the applet for UpdateMiiImage.
##  @param[in] special_key_code \ref MiiSpecialKeyCode
##  @param[in] valid_uuid_array Input array of Uuid.
##  @param[in] count Total entries for the valid_uuid_array. Must be 0-8.
##  @param[in] used_uuid UsedUuid
##  @param[out] index Output Index.
##

proc miiLaCreateMii*(special_key_code: MiiSpecialKeyCode; out_char: ptr MiiCharInfo): Result {.
    cdecl, importc: "miiLaCreateMii".}
## *
##  @brief Launches the applet for CreateMii.
##  @note This creates a Mii and returns it, without saving it in the database.
##  @note Only available on [10.2.0+].
##  @param[in] special_key_code \ref MiiSpecialKeyCode
##  @param[out] out_char \ref MiiCharInfo
##

proc miiLaEditMii*(special_key_code: MiiSpecialKeyCode; in_char: ptr MiiCharInfo;
                  out_char: ptr MiiCharInfo): Result {.cdecl, importc: "miiLaEditMii".}
## *
##  @brief Launches the applet for EditMii.
##  @note This edits the specified Mii and returns it, without saving it in the database.
##  @note Only available on [10.2.0+].
##  @param[in] special_key_code \ref MiiSpecialKeyCode
##  @param[in] in_char \ref MiiCharInfo
##  @param[out] out_char \ref MiiCharInfo
##

