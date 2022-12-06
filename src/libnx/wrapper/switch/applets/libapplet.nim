## *
##  @file libapplet.h
##  @brief LibraryApplet wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../services/applet, ../services/acc

## / CommonArguments

type
  LibAppletArgs* {.bycopy.} = object
    CommonArgs_version*: U32   ## /< \ref libappletArgsCreate sets this to 1, and \ref libappletArgsPop requires value 1. v0 is not supported.
    CommonArgs_size*: U32      ## /< Size of this struct.
    LaVersion*: U32            ## /< LibraryApplet API version.
    ExpectedThemeColor*: S32   ## /< Set to the output from \ref appletGetThemeColorType by \ref libappletArgsCreate.
    PlayStartupSound*: U8      ## /< bool flag, default is false.
    pad*: array[7, U8]          ## /< Padding.
    tick*: U64                 ## /< System tick. Set to the output from \ref armGetSystemTick during \ref libappletArgsPush.

proc libappletArgsCreate*(a: ptr LibAppletArgs; version: U32) {.cdecl,
    importc: "libappletArgsCreate".}
## *
##  @brief Creates a LibAppletArgs struct.
##  @param a LibAppletArgs struct.
##  @param version LaVersion for \ref LibAppletArgs.
##

proc libappletArgsSetPlayStartupSound*(a: ptr LibAppletArgs; flag: bool) {.cdecl,
    importc: "libappletArgsSetPlayStartupSound".}
## *
##  @brief Sets the PlayStartupSound field in \ref LibAppletArgs.
##  @param a LibAppletArgs struct.
##  @param flag Value for \ref LibAppletArgs PlayStartupSound.
##

proc libappletCreateWriteStorage*(s: ptr AppletStorage; buffer: pointer; size: csize_t): Result {.
    cdecl, importc: "libappletCreateWriteStorage".}
## *
##  @brief Creates an AppletStorage with the specified size and writes the buffer contents to that storage at offset 0.
##  @param[out] s Storage object.
##  @param buffer Input buffer.
##  @param size Size to write.
##

proc libappletReadStorage*(s: ptr AppletStorage; buffer: pointer; size: csize_t;
                          transfer_size: ptr csize_t): Result {.cdecl,
    importc: "libappletReadStorage".}
## *
##  @brief Reads data from offset 0 from the specified storage into the buffer. If the storage-size is smaller than the size param, the storage-size is used instead.
##  @param s Storage object.
##  @param buffer Output buffer.
##  @param size Size to read.
##  @param transfer_size Optional output size field for the actual size used for the read, can be NULL.
##

proc libappletArgsPush*(a: ptr LibAppletArgs; h: ptr AppletHolder): Result {.cdecl,
    importc: "libappletArgsPush".}
## *
##  @brief Sets the tick field in LibAppletArgs, then creates a storage with it which is pushed to the AppletHolder via \ref appletHolderPushInData.
##  @param a LibAppletArgs struct.
##  @param h AppletHolder object.
##

proc libappletArgsPop*(a: ptr LibAppletArgs): Result {.cdecl,
    importc: "libappletArgsPop".}
## *
##  @brief Uses \ref appletPopInData and reads it to the specified LibAppletArgs. The LibAppletArgs is validated, an error is thrown when invalid.
##  @param[out] a LibAppletArgs struct.
##

proc libappletPushInData*(h: ptr AppletHolder; buffer: pointer; size: csize_t): Result {.
    cdecl, importc: "libappletPushInData".}
## *
##  @brief Creates a storage using the input buffer which is pushed to the AppletHolder via \ref appletHolderPushInData.
##  @param h AppletHolder object.
##  @param buffer Input data buffer.
##  @param size Input data size.
##

proc libappletPopOutData*(h: ptr AppletHolder; buffer: pointer; size: csize_t;
                         transfer_size: ptr csize_t): Result {.cdecl,
    importc: "libappletPopOutData".}
## *
##  @brief Pops a storage via \ref appletHolderPopOutData, uses \ref libappletReadStorage, then closes the storage.
##  @param h AppletHolder object.
##  @param buffer Output buffer.
##  @param size Size to read.
##  @param transfer_size Optional output size field for the actual size used for the read, can be NULL.
##

proc libappletSetJumpFlag*(flag: bool) {.cdecl, importc: "libappletSetJumpFlag".}
## *
##  @brief Sets whether \ref libappletStart uses \ref appletHolderJump.
##  @param flag Flag. Value true should not be used unless running as AppletType_LibraryApplet.
##

proc libappletStart*(h: ptr AppletHolder): Result {.cdecl, importc: "libappletStart".}
## *
##  @brief If the flag from \ref libappletSetJumpFlag is set, this just uses \ref appletHolderJump. Otherwise, starts the applet and waits for it to finish, then checks the \ref LibAppletExitReason.
##  @note Uses \ref appletHolderStart and \ref appletHolderJoin.
##  @param h AppletHolder object.
##

proc libappletLaunch*(id: AppletId; commonargs: ptr LibAppletArgs; arg: pointer;
                     arg_size: csize_t; reply: pointer; reply_size: csize_t;
                     out_reply_size: ptr csize_t): Result {.cdecl,
    importc: "libappletLaunch".}
## *
##  @brief Creates a LibraryApplet with the specified input storage data, uses \ref libappletStart, and reads the output storage reply data via \ref libappletPopOutData.
##  @param id \ref AppletId
##  @param commonargs \ref LibAppletArgs struct.
##  @param arg Input storage data buffer. Optional, can be NULL.
##  @param arg_size Size of the arg buffer.
##  @param reply Output storage data buffer. Optional, can be NULL.
##  @param reply_size Size to read for the reply buffer.
##  @param out_reply_size Actual read reply data size, see \ref libappletPopOutData.
##

proc libappletRequestHomeMenu*(): Result {.cdecl,
                                        importc: "libappletRequestHomeMenu".}
## / Wrapper for \ref appletPushToGeneralChannel, see appletPushToGeneralChannel regarding the requirements for using this.
## / Returns to the main Home Menu, equivalent to pressing the HOME button.

proc libappletRequestJumpToSystemUpdate*(): Result {.cdecl,
    importc: "libappletRequestJumpToSystemUpdate".}
## / Wrapper for \ref appletPushToGeneralChannel, see appletPushToGeneralChannel regarding the requirements for using this.
## / Equivalent to entering "System Update" under System Settings. When leaving this, it returns to the main Home Menu.

proc libappletRequestToLaunchApplication*(application_id: U64; uid: AccountUid;
    buffer: pointer; size: csize_t; sender: U32): Result {.cdecl,
    importc: "libappletRequestToLaunchApplication".}
## *
##  @brief Wrapper for \ref appletPushToGeneralChannel, see appletPushToGeneralChannel regarding the requirements for using this.
##  @note Only available on [11.0.0+].
##  @param[in] application_id ApplicationId
##  @param[in] uid \ref AccountUid
##  @param[in] buffer Input buffer.
##  @param[in] size Input buffer size.
##  @param[in] sender LaunchApplicationRequestSender
##

proc libappletRequestJumpToStory*(uid: AccountUid; application_id: U64): Result {.
    cdecl, importc: "libappletRequestJumpToStory".}
## *
##  @brief Wrapper for \ref appletPushToGeneralChannel, see appletPushToGeneralChannel regarding the requirements for using this.
##  @note Only available on [11.0.0+].
##  @param[in] uid \ref AccountUid
##  @param[in] application_id Optional ApplicationId, can be 0.
##

