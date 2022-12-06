## *
##  @file capsu.h
##  @brief Application Album (caps:u) service IPC wrapper.
##  This is only usable with AlbumFiles associated with the current host Application.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/caps, ../services/acc

## / Initialize caps:u. Only available on [5.0.0+].

proc capsuInitialize*(): Result {.cdecl, importc: "capsuInitialize".}
## / Exit caps:u.

proc capsuExit*() {.cdecl, importc: "capsuExit".}
## / Gets the Service for caps:u.

proc capsuGetServiceSession*(): ptr Service {.cdecl,
    importc: "capsuGetServiceSession".}
## / Gets the Service for IAlbumAccessorApplicationSession, only initialized after \ref capsuOpenAlbumMovieStream was used (unaffected by using \ref capsuCloseAlbumMovieStream).

proc capsuGetServiceSessionAccessor*(): ptr Service {.cdecl,
    importc: "capsuGetServiceSession_Accessor".}
## *
##  @brief Gets a listing of \ref CapsApplicationAlbumFileEntry.
##  @note On [6.0.0+] this uses GetAlbumFileList1AafeAruidDeprecated, otherwise this uses GetAlbumFileList0AafeAruidDeprecated.
##  @note This is an old version of \ref capsuGetAlbumFileList3.
##  @param[out] entries Output array of \ref CapsApplicationAlbumFileEntry.
##  @param[in] count Max size of the output array in entries.
##  @param[in] type \ref CapsContentType
##  @param[in] start_datetime Start \ref CapsAlbumFileDateTime, when NULL the default is used.
##  @param[in] end_datetime End \ref CapsAlbumFileDateTime, when NULL the default is used.
##  @param[out] total_entries Total output entries.
##

proc capsuGetAlbumFileListDeprecated1*(entries: ptr CapsApplicationAlbumFileEntry;
                                      count: S32; `type`: CapsContentType;
                                      startDatetime: ptr CapsAlbumFileDateTime;
                                      endDatetime: ptr CapsAlbumFileDateTime;
                                      totalEntries: ptr S32): Result {.cdecl,
    importc: "capsuGetAlbumFileListDeprecated1".}
## *
##  @brief Gets a listing of \ref CapsApplicationAlbumFileEntry, where the AlbumFile has an UserId which matches the input one. See also \ref capssuSaveScreenShotWithUserIds.
##  @note Only available on [6.0.0+].
##  @note This is an old version of \ref capsuGetAlbumFileList4.
##  @param[out] entries Output array of \ref CapsApplicationAlbumFileEntry.
##  @param[in] count Max size of the output array in entries.
##  @param[in] type \ref CapsContentType
##  @param[in] start_datetime Start \ref CapsAlbumFileDateTime, when NULL the default is used.
##  @param[in] end_datetime End \ref CapsAlbumFileDateTime, when NULL the default is used.
##  @param[in] uid \ref AccountUid
##  @param[out] total_entries Total output entries.
##

proc capsuGetAlbumFileListDeprecated2*(entries: ptr CapsApplicationAlbumFileEntry;
                                      count: S32; `type`: CapsContentType;
                                      startDatetime: ptr CapsAlbumFileDateTime;
                                      endDatetime: ptr CapsAlbumFileDateTime;
                                      uid: AccountUid; totalEntries: ptr S32): Result {.
    cdecl, importc: "capsuGetAlbumFileListDeprecated2".}
## *
##  @brief Gets a listing of \ref CapsApplicationAlbumEntry.
##  @note Only available on [7.0.0+], on prior sysvers use \ref capsuGetAlbumFileListDeprecated1 instead.
##  @param[out] entries Output array of \ref CapsApplicationAlbumEntry.
##  @param[in] count Max size of the output array in entries.
##  @param[in] type \ref CapsContentType
##  @param[in] start_datetime Start \ref CapsAlbumFileDateTime, when NULL the default is used.
##  @param[in] end_datetime End \ref CapsAlbumFileDateTime, when NULL the default is used.
##  @param[out] total_entries Total output entries.
##

proc capsuGetAlbumFileList3*(entries: ptr CapsApplicationAlbumEntry; count: S32;
                            `type`: CapsContentType;
                            startDatetime: ptr CapsAlbumFileDateTime;
                            endDatetime: ptr CapsAlbumFileDateTime;
                            totalEntries: ptr S32): Result {.cdecl,
    importc: "capsuGetAlbumFileList3".}
## *
##  @brief Gets a listing of \ref CapsApplicationAlbumEntry, where the AlbumFile has an UserId which matches the input one. See also \ref capssuSaveScreenShotWithUserIds.
##  @note Only available on [7.0.0+], on prior sysvers use \ref capsuGetAlbumFileListDeprecated2 instead.
##  @param[out] entries Output array of \ref CapsApplicationAlbumEntry.
##  @param[in] count Max size of the output array in entries.
##  @param[in] type \ref CapsContentType
##  @param[in] start_datetime Start \ref CapsAlbumFileDateTime, when NULL the default is used.
##  @param[in] end_datetime End \ref CapsAlbumFileDateTime, when NULL the default is used.
##  @param[in] uid \ref AccountUid
##  @param[out] total_entries Total output entries.
##

proc capsuGetAlbumFileList4*(entries: ptr CapsApplicationAlbumEntry; count: S32;
                            `type`: CapsContentType;
                            startDatetime: ptr CapsAlbumFileDateTime;
                            endDatetime: ptr CapsAlbumFileDateTime;
                            uid: AccountUid; totalEntries: ptr S32): Result {.cdecl,
    importc: "capsuGetAlbumFileList4".}
## *
##  @brief Deletes the specified AlbumFile.
##  @param[in] type \ref CapsContentType, must match ::CapsContentType_ExtraMovie.
##  @param[in] entry \ref CapsApplicationAlbumFileEntry
##

proc capsuDeleteAlbumFile*(`type`: CapsContentType;
                          entry: ptr CapsApplicationAlbumFileEntry): Result {.cdecl,
    importc: "capsuDeleteAlbumFile".}
## *
##  @brief Gets the filesize for the entire specified AlbumFile.
##  @param[in] entry \ref CapsApplicationAlbumFileEntry
##  @param[out] size Output filesize.
##

proc capsuGetAlbumFileSize*(entry: ptr CapsApplicationAlbumFileEntry; size: ptr U64): Result {.
    cdecl, importc: "capsuGetAlbumFileSize".}
## *
##  @brief Load the ScreenShotImage for the specified AlbumFile.
##  @param[out] width Output image width. Optional, can be NULL.
##  @param[out] height Output image height. Optional, can be NULL.
##  @param[out] attr \ref CapsScreenShotAttributeForApplication
##  @param[out] userdata Output buffer containing the UserData. Optional, can be NULL. This buffer is cleared to 0 using userdata_maxsize, prior to doing the memcpy.
##  @param[in] userdata_maxsize Max size of the userdata buffer. Optional, can be 0.
##  @param[out] userdata_size Userdata size field, clamped to max size sizeof(CapsApplicationData::userdata) when needed.
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 1280x720.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##  @param[in] entry \ref CapsApplicationAlbumFileEntry
##  @param[in] option \ref CapsScreenShotDecodeOption
##

proc capsuLoadAlbumScreenShotImage*(width: ptr S32; height: ptr S32; attr: ptr CapsScreenShotAttributeForApplication;
                                   userdata: pointer; userdataMaxsize: csize_t;
                                   userdataSize: ptr U32; image: pointer;
                                   imageSize: csize_t; workbuf: pointer;
                                   workbufSize: csize_t;
                                   entry: ptr CapsApplicationAlbumFileEntry;
                                   option: ptr CapsScreenShotDecodeOption): Result {.
    cdecl, importc: "capsuLoadAlbumScreenShotImage".}
## *
##  @brief Load the ScreenShotThumbnailImage for the specified AlbumFile.
##  @param[out] width Output image width. Optional, can be NULL.
##  @param[out] height Output image height. Optional, can be NULL.
##  @param[out] attr \ref CapsScreenShotAttributeForApplication
##  @param[out] userdata Output buffer containing the UserData. Optional, can be NULL. This buffer is cleared to 0 using userdata_maxsize, prior to doing the memcpy.
##  @param[in] userdata_maxsize Max size of the userdata buffer. Optional, can be 0.
##  @param[out] userdata_size Userdata size field, clamped to max size sizeof(CapsApplicationData::userdata) when needed.
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 320x180.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##  @param[in] entry \ref CapsApplicationAlbumFileEntry
##  @param[in] option \ref CapsScreenShotDecodeOption
##

proc capsuLoadAlbumScreenShotThumbnailImage*(width: ptr S32; height: ptr S32;
    attr: ptr CapsScreenShotAttributeForApplication; userdata: pointer;
    userdataMaxsize: csize_t; userdataSize: ptr U32; image: pointer;
    imageSize: csize_t; workbuf: pointer; workbufSize: csize_t;
    entry: ptr CapsApplicationAlbumFileEntry;
    option: ptr CapsScreenShotDecodeOption): Result {.cdecl,
    importc: "capsuLoadAlbumScreenShotThumbnailImage".}
## *
##  @brief PrecheckToCreateContents. Official sw only uses this with ::CapsContentType_ExtraMovie.
##  @param[in] type \ref CapsContentType
##  @param[in] unk Unknown.
##

proc capsuPrecheckToCreateContents*(`type`: CapsContentType; unk: U64): Result {.
    cdecl, importc: "capsuPrecheckToCreateContents".}
## *
##  @brief Opens an AlbumMovieStream.
##  @note This opens IAlbumAccessorApplicationSession if not previously opened, it's closed during \ref capsuExit.
##  @note Up to 4 streams can be open at the same time. Multiple streams can be open at the same time for the same \ref CapsApplicationAlbumFileEntry.
##  @param[out] stream Stream handle.
##  @param[in] entry \ref CapsApplicationAlbumFileEntry
##

proc capsuOpenAlbumMovieStream*(stream: ptr U64;
                               entry: ptr CapsApplicationAlbumFileEntry): Result {.
    cdecl, importc: "capsuOpenAlbumMovieStream".}
## *
##  @brief Closes an AlbumMovieStream.
##  @param[in] stream Stream handle.
##

proc capsuCloseAlbumMovieStream*(stream: U64): Result {.cdecl,
    importc: "capsuCloseAlbumMovieStream".}
## *
##  @brief Gets the data size of an AlbumMovieStream.
##  @param[in] stream Stream handle.
##  @param[out] size Size of the actual MP4, without the JPEG at the end.
##

proc capsuGetAlbumMovieStreamSize*(stream: U64; size: ptr U64): Result {.cdecl,
    importc: "capsuGetAlbumMovieStreamSize".}
## *
##  @brief Reads data from an AlbumMovieStream.
##  @note offset(+size) must not be negative. offset and size must be aligned to 0x40000-bytes.
##  @note When offset(+size) goes beyond the size from \ref capsuGetAlbumMovieStreamSize, the regions of the buffer which goes beyond that are cleared to 0, and actual_size is still set to the input size.
##  @param[in] stream Stream handle.
##  @param[in] offset Offset.
##  @param[out] Output data buffer.
##  @param[in] size Data buffer size.
##  @param[out] actual_size Actual read size.
##

proc capsuReadAlbumMovieStream*(stream: U64; offset: S64; buffer: pointer;
                               size: csize_t; actualSize: ptr U64): Result {.cdecl,
    importc: "capsuReadAlbumMovieStream".}
## *
##  @brief Gets the BrokenReason for an AlbumMovieStream.
##  @note Official sw doesn't use this.
##  @param[in] stream Stream handle.
##

proc capsuGetAlbumMovieStreamBrokenReason*(stream: U64): Result {.cdecl,
    importc: "capsuGetAlbumMovieStreamBrokenReason".}