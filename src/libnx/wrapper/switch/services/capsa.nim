## *
##  @file capsa.h
##  @brief Album Accessor (caps:a) service IPC wrapper.
##  @author Behemoth
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/caps

## / Initialize caps:a.

proc capsaInitialize*(): Result {.cdecl, importc: "capsaInitialize".}
## / Exit caps:a.

proc capsaExit*() {.cdecl, importc: "capsaExit".}
## / Gets the Service for caps:a.

proc capsaGetServiceSession*(): ptr Service {.cdecl,
    importc: "capsaGetServiceSession".}
## / Gets the Service for IAlbumAccessorSession, only initialized after \ref capsaOpenAlbumMovieStream was used (unaffected by using \ref capsaCloseAlbumMovieStream).

proc capsaGetServiceSessionAccessor*(): ptr Service {.cdecl,
    importc: "capsaGetServiceSession_Accessor".}
## *
##  @brief Gets the amount of files at a AlbumStorage.
##  @param[in] storage \ref CapsAlbumStorage
##  @param[out] count Amount of files.
##

proc capsaGetAlbumFileCount*(storage: CapsAlbumStorage; count: ptr U64): Result {.
    cdecl, importc: "capsaGetAlbumFileCount".}
## *
##  @brief Gets a listing of \ref CapsAlbumEntry, where the AlbumFile's storage matches the input one.
##  @param[in] storage \ref CapsAlbumStorage
##  @param[out] out Total output entries.
##  @param[out] entries Output array of \ref CapsAlbumEntry.
##  @param[in] count Reserved entry count.
##

proc capsaGetAlbumFileList*(storage: CapsAlbumStorage; `out`: ptr U64;
                           entries: ptr CapsAlbumEntry; count: U64): Result {.cdecl,
    importc: "capsaGetAlbumFileList".}
## *
##  @brief Loads a file into the specified buffer.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[out] out_size Size of the AlbumFile.
##  @param[out] filebuf File output buffer.
##  @param[in] filebuf_size Size of the filebuf.
##

proc capsaLoadAlbumFile*(fileId: ptr CapsAlbumFileId; outSize: ptr U64;
                        filebuf: pointer; filebufSize: U64): Result {.cdecl,
    importc: "capsaLoadAlbumFile".}
## *
##  @brief Deletes an AlbumFile corresponding to the specified \ref CapsAlbumFileId.
##  @param[in] file_id \ref CapsAlbumFileId
##

proc capsaDeleteAlbumFile*(fileId: ptr CapsAlbumFileId): Result {.cdecl,
    importc: "capsaDeleteAlbumFile".}
## *
##  @brief Copies an AlbumFile to the specified \ref CapsAlbumStorage.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] dst_storage \ref CapsAlbumStorage
##

proc capsaStorageCopyAlbumFile*(fileId: ptr CapsAlbumFileId;
                               dstStorage: CapsAlbumStorage): Result {.cdecl,
    importc: "capsaStorageCopyAlbumFile".}
## *
##  @brief Gets the mount status of the specified \ref CapsAlbumStorage.
##  @param[in] storage \ref CapsAlbumStorage
##  @param[out] is_mounted Boolean over whether the storage is mounted or not.
##

proc capsaIsAlbumMounted*(storage: CapsAlbumStorage; isMounted: ptr bool): Result {.
    cdecl, importc: "capsaIsAlbumMounted".}
## *
##  @brief Returns the AlbumUsage for a specified \ref CapsAlbumStorage.
##  @param[in] storage \ref CapsAlbumStorage
##  @param[out] out \ref CapsAlbumUsage2
##

proc capsaGetAlbumUsage*(storage: CapsAlbumStorage; `out`: ptr CapsAlbumUsage2): Result {.
    cdecl, importc: "capsaGetAlbumUsage".}
## *
##  @brief Gets the size for the specified AlbumFile.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[out] size Size of the file.
##

proc capsaGetAlbumFileSize*(fileId: ptr CapsAlbumFileId; size: ptr U64): Result {.cdecl,
    importc: "capsaGetAlbumFileSize".}
## *
##  @brief Load the Thumbnail for the specified AlbumFile.
##  @note Will always be 320x180.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[out] out_size Size of the Thumbnail.
##  @param[out] image JPEG image output buffer.
##  @param[in] image_size Image buffer size.
##

proc capsaLoadAlbumFileThumbnail*(fileId: ptr CapsAlbumFileId; outSize: ptr U64;
                                 image: pointer; imageSize: U64): Result {.cdecl,
    importc: "capsaLoadAlbumFileThumbnail".}
## *
##  @brief Load the ScreenShotImage for the specified AlbumFile.
##  @note Only available on [2.0.0+].
##  @param[out] width Output image width. Optional, can be NULL.
##  @param[out] height Output image height. Optional, can be NULL.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 1280x720.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##

proc capsaLoadAlbumScreenShotImage*(width: ptr U64; height: ptr U64;
                                   fileId: ptr CapsAlbumFileId; image: pointer;
                                   imageSize: U64; workbuf: pointer;
                                   workbufSize: U64): Result {.cdecl,
    importc: "capsaLoadAlbumScreenShotImage".}
## *
##  @brief Load the ScreenShotThumbnailImage for the specified AlbumFile.
##  @note Only available on [2.0.0+].
##  @param[out] width Output image width. Optional, can be NULL.
##  @param[out] height Output image height. Optional, can be NULL.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 320x180.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##

proc capsaLoadAlbumScreenShotThumbnailImage*(width: ptr U64; height: ptr U64;
    fileId: ptr CapsAlbumFileId; image: pointer; imageSize: U64; workbuf: pointer;
    workbufSize: U64): Result {.cdecl,
                             importc: "capsaLoadAlbumScreenShotThumbnailImage".}
## *
##  @brief Load an \ref CapsAlbumEntry from a \ref CapsApplicationAlbumEntry and an ApplicationId.
##  @note Only available on [2.0.0+].
##  @param[out] entry \ref CapsAlbumEntry
##  @param[in] application_entry \ref CapsApplicationAlbumEntry
##  @param[in] application_id ApplicationId
##

proc capsaGetAlbumEntryFromApplicationAlbumEntry*(entry: ptr CapsAlbumEntry;
    applicationEntry: ptr CapsApplicationAlbumEntry; applicationId: U64): Result {.
    cdecl, importc: "capsaGetAlbumEntryFromApplicationAlbumEntry".}
## *
##  @brief Load the ScreenShotImage for the specified AlbumFile.
##  @note Only available on [3.0.0+].
##  @param[out] width Output image width. Optional, can be NULL.
##  @param[out] height Output image height. Optional, can be NULL.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] opts \ref CapsScreenShotDecodeOption
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 1280x720.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##

proc capsaLoadAlbumScreenShotImageEx*(width: ptr U64; height: ptr U64;
                                     fileId: ptr CapsAlbumFileId;
                                     opts: ptr CapsScreenShotDecodeOption;
                                     image: pointer; imageSize: U64;
                                     workbuf: pointer; workbufSize: U64): Result {.
    cdecl, importc: "capsaLoadAlbumScreenShotImageEx".}
## *
##  @brief Load the ScreenShotThumbnailImage for the specified AlbumFile.
##  @note Only available on [3.0.0+].
##  @param[out] width Output image width. Optional, can be NULL.
##  @param[out] height Output image height. Optional, can be NULL.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] opts \ref CapsScreenShotDecodeOption
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 320x180.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##

proc capsaLoadAlbumScreenShotThumbnailImageEx*(width: ptr U64; height: ptr U64;
    fileId: ptr CapsAlbumFileId; opts: ptr CapsScreenShotDecodeOption; image: pointer;
    imageSize: U64; workbuf: pointer; workbufSize: U64): Result {.cdecl,
    importc: "capsaLoadAlbumScreenShotThumbnailImageEx".}
## *
##  @brief Load the ScreenShotImage for the specified AlbumFile.
##  @note Only available on [3.0.0+].
##  @param[out] width Output image width. Optional, can be NULL.
##  @param[out] height Output image height. Optional, can be NULL.
##  @param[out] attr \ref CapsScreenShotAttribute
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] opts \ref CapsScreenShotDecodeOption
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 1280x720.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##

proc capsaLoadAlbumScreenShotImageEx0*(width: ptr U64; height: ptr U64;
                                      attr: ptr CapsScreenShotAttribute;
                                      fileId: ptr CapsAlbumFileId;
                                      opts: ptr CapsScreenShotDecodeOption;
                                      image: pointer; imageSize: U64;
                                      workbuf: pointer; workbufSize: U64): Result {.
    cdecl, importc: "capsaLoadAlbumScreenShotImageEx0".}
## *
##  @brief Returns the AlbumUsage for a specified \ref CapsAlbumStorage.
##  @note Only available on [4.0.0+].
##  @param[in] storage \ref CapsAlbumStorage
##  @param[out] out \ref CapsAlbumUsage3
##

proc capsaGetAlbumUsage3*(storage: CapsAlbumStorage; `out`: ptr CapsAlbumUsage3): Result {.
    cdecl, importc: "capsaGetAlbumUsage3".}
## *
##  @brief Returns the result for a AlbumStorage mount.
##  @note Only available on [4.0.0+].
##  @param[in] storage \ref CapsAlbumStorage
##

proc capsaGetAlbumMountResult*(storage: CapsAlbumStorage): Result {.cdecl,
    importc: "capsaGetAlbumMountResult".}
## *
##  @brief Returns the AlbumUsage for a specified \ref CapsAlbumStorage.
##  @note Only available on [4.0.0+].
##  @param[in] storage \ref CapsAlbumStorage
##  @param[in] flags \ref CapsAlbumFileContentsFlag
##  @param[out] out \ref CapsAlbumUsage16
##

proc capsaGetAlbumUsage16*(storage: CapsAlbumStorage; flags: U8;
                          `out`: ptr CapsAlbumUsage16): Result {.cdecl,
    importc: "capsaGetAlbumUsage16".}
## *
##  @brief Returns the start and end of the Applet Id range.
##  @note Only available on [6.0.0+].
##  @param[out] success Returns bool over whether the call was handled or not.
##  @param[out] min Mimimum applet id. Always 0x0100000000001000
##  @param[out] max Maximum applet id. Always 0x0100000000001FFF
##

proc capsaGetMinMaxAppletId*(success: ptr bool; min: ptr U64; max: ptr U64): Result {.
    cdecl, importc: "capsaGetMinMaxAppletId".}
## *
##  @brief Gets the amount of files of the specified type at a AlbumStorage.
##  @note Only available on [5.0.0+].
##  @param[in] storage \ref CapsAlbumStorage
##  @param[in] flags \ref CapsAlbumFileContentsFlag
##  @param[out] count Amount of files.
##

proc capsaGetAlbumFileCountEx0*(storage: CapsAlbumStorage; flags: U8; count: ptr U64): Result {.
    cdecl, importc: "capsaGetAlbumFileCountEx0".}
## *
##  @brief Gets a listing of \ref CapsAlbumEntry, where the AlbumFile's storage and type matches the input one.
##  @note Only available on [5.0.0+].
##  @param[in] storage \ref CapsAlbumStorage
##  @param[in] flags \ref CapsAlbumFileContentsFlag
##  @param[out] out Total output entries.
##  @param[out] entries Output array of \ref CapsAlbumEntry.
##  @param[in] count Reserved entry count.
##

proc capsaGetAlbumFileListEx0*(storage: CapsAlbumStorage; flags: U8; `out`: ptr U64;
                              entries: ptr CapsAlbumEntry; count: U64): Result {.
    cdecl, importc: "capsaGetAlbumFileListEx0".}
## *
##  @brief Returns the image from the last shown ScreenShot Overlay.
##  @param[out] file_id \ref CapsAlbumFileId
##  @param[out] out_size Size of the thumbnail image. Always 0x5100.
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 96×54.
##

proc capsaGetLastOverlayScreenShotThumbnail*(fileId: ptr CapsAlbumFileId;
    outSize: ptr U64; image: pointer; imageSize: U64): Result {.cdecl,
    importc: "capsaGetLastOverlayScreenShotThumbnail".}
## *
##  @brief Returns the image from the last shown Movie Overlay.
##  @note Only available on [4.0.0+].
##  @param[out] file_id \ref CapsAlbumFileId
##  @param[out] out_size Size of the thumbnail image. Always 0x5100.
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 96×54.
##

proc capsaGetLastOverlayMovieThumbnail*(fileId: ptr CapsAlbumFileId;
                                       outSize: ptr U64; image: pointer;
                                       imageSize: U64): Result {.cdecl,
    importc: "capsaGetLastOverlayMovieThumbnail".}
## *
##  @brief Gets the currently set autosaving storage.
##  @note Wrapper around setsysGetPrimaryAlbumStorage but defaults to NAND if SD isn't available.
##  @param[out] storage \ref CapsAlbumStorage
##

proc capsaGetAutoSavingStorage*(storage: ptr CapsAlbumStorage): Result {.cdecl,
    importc: "capsaGetAutoSavingStorage".}
## *
##  @brief Gets required size to copy all files from one Storage to another.
##  @param[in] dst_storage \ref CapsAlbumStorage
##  @param[in] src_storage \ref CapsAlbumStorage
##  @param[out] out Required storage space size.
##

proc capsaGetRequiredStorageSpaceSizeToCopyAll*(dstStorage: CapsAlbumStorage;
    srcStorage: CapsAlbumStorage; `out`: ptr U64): Result {.cdecl,
    importc: "capsaGetRequiredStorageSpaceSizeToCopyAll".}
## *
##  @brief Load the ScreenShotThumbnailImage for the specified AlbumFile.
##  @note Only available on [3.0.0+].
##  @param[out] width Output image width. Optional, can be NULL.
##  @param[out] height Output image height. Optional, can be NULL.
##  @param[out] attr \ref CapsScreenShotAttribute
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] opts \ref CapsScreenShotDecodeOption
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 320x180.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##

proc capsLoadAlbumScreenShotThumbnailImageEx0*(width: ptr U64; height: ptr U64;
    attr: ptr CapsScreenShotAttribute; fileId: ptr CapsAlbumFileId;
    opts: ptr CapsScreenShotDecodeOption; image: pointer; imageSize: U64;
    workbuf: pointer; workbufSize: U64): Result {.cdecl,
    importc: "capsLoadAlbumScreenShotThumbnailImageEx0".}
## *
##  @brief Load the ScreenShotImage for the specified AlbumFile.
##  @note Only available on [4.0.0+].
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] opts \ref CapsScreenShotDecodeOption
##  @param[out] out \ref CapsLoadAlbumScreenShotImageOutput
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 1280x720.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##

proc capsaLoadAlbumScreenShotImageEx1*(fileId: ptr CapsAlbumFileId;
                                      opts: ptr CapsScreenShotDecodeOption; `out`: ptr CapsLoadAlbumScreenShotImageOutput;
                                      image: pointer; imageSize: U64;
                                      workbuf: pointer; workbufSize: U64): Result {.
    cdecl, importc: "capsaLoadAlbumScreenShotImageEx1".}
## *
##  @brief Load the ScreenShotThumbnailImage for the specified AlbumFile.
##  @note Only available on [4.0.0+].
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] opts \ref CapsScreenShotDecodeOption
##  @param[out] out \ref CapsLoadAlbumScreenShotImageOutput
##  @param[out] image RGBA8 image output buffer.
##  @param[in] image_size Image buffer size, should be at least large enough for RGBA8 320x180.
##  @param[out] workbuf Work buffer, cleared to 0 by the cmd before it returns.
##  @param[in] workbuf_size Work buffer size, must be at least the size of the JPEG within the AlbumFile.
##

proc capsaLoadAlbumScreenShotThumbnailImageEx1*(fileId: ptr CapsAlbumFileId;
    opts: ptr CapsScreenShotDecodeOption;
    `out`: ptr CapsLoadAlbumScreenShotImageOutput; image: pointer; imageSize: U64;
    workbuf: pointer; workbufSize: U64): Result {.cdecl,
    importc: "capsaLoadAlbumScreenShotThumbnailImageEx1".}
## *
##  @brief Unmounts the specified AlbumStorage.
##  @param[in] storage \ref CapsAlbumStorage
##

proc capsaForceAlbumUnmounted*(storage: CapsAlbumStorage): Result {.cdecl,
    importc: "capsaForceAlbumUnmounted".}
## *
##  @brief Resets mount status for the specified AlbumStorage.
##  @note Mounts the Storage if available.
##  @param[in] storage \ref CapsAlbumStorage
##

proc capsaResetAlbumMountStatus*(storage: CapsAlbumStorage): Result {.cdecl,
    importc: "capsaResetAlbumMountStatus".}
## *
##  @brief Refreshs Album Cache for the specified AlbumStorage.
##  @param[in] storage \ref CapsAlbumStorage
##

proc capsaRefreshAlbumCache*(storage: CapsAlbumStorage): Result {.cdecl,
    importc: "capsaRefreshAlbumCache".}
## *
##  @brief Gets the AlbumCache of the specified AlbumStorage.
##  @note Stubbed on [4.0.0+].
##  @note use \ref capsaGetAlbumCacheEx instead.
##  @param[in] storage \ref CapsAlbumStorage
##  @param[out] cache \ref CapsAlbumCache
##

proc capsaGetAlbumCache*(storage: CapsAlbumStorage; cache: ptr CapsAlbumCache): Result {.
    cdecl, importc: "capsaGetAlbumCache".}
## *
##  @brief Gets the AlbumCache for the specified type of the specified AlbumStorage.
##  @param[in] storage \ref CapsAlbumStorage
##  @param[in] contents \ref CapsAlbumFileContents
##  @param[out] cache \ref CapsAlbumCache
##

proc capsaGetAlbumCacheEx*(storage: CapsAlbumStorage;
                          contents: CapsAlbumFileContents;
                          cache: ptr CapsAlbumCache): Result {.cdecl,
    importc: "capsaGetAlbumCacheEx".}
## *
##  @brief Load an \ref CapsAlbumEntry from a \ref CapsApplicationAlbumEntry and an AppletResourceUserId.
##  @note Only available on [2.0.0+].
##  @param[out] entry \ref CapsAlbumEntry
##  @param[in] application_entry \ref CapsApplicationAlbumEntry
##

proc capsaGetAlbumEntryFromApplicationAlbumEntryAruid*(entry: ptr CapsAlbumEntry;
    applicationEntry: ptr CapsApplicationAlbumEntry): Result {.cdecl,
    importc: "capsaGetAlbumEntryFromApplicationAlbumEntryAruid".}
## *
##  @brief Opens an AlbumMovieStream.
##  @note This opens IAlbumAccessorSession if not previously opened, it's closed during \ref capsaExit.
##  @note Up to 4 streams can be open at the same time. Multiple streams can be open at the same time for the same \ref CapsAlbumFileId.
##  @note Only available on [4.0.0+].
##  @param[out] stream Stream handle.
##  @param[in] entry \ref CapsAlbumFileId
##

proc capsaOpenAlbumMovieStream*(stream: ptr U64; fileId: ptr CapsAlbumFileId): Result {.
    cdecl, importc: "capsaOpenAlbumMovieStream".}
## *
##  @brief Closes an AlbumMovieStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capsaCloseAlbumMovieStream*(stream: U64): Result {.cdecl,
    importc: "capsaCloseAlbumMovieStream".}
## *
##  @brief Gets the data size of an AlbumMovieStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[out] size Size of the actual MP4, without the JPEG at the end.
##

proc capsaGetAlbumMovieStreamSize*(stream: U64; size: ptr U64): Result {.cdecl,
    importc: "capsaGetAlbumMovieStreamSize".}
## *
##  @brief Reads data from an AlbumMovieStream.
##  @note offset(+size) must not be negative. offset and size must be aligned to 0x40000-bytes.
##  @note When offset(+size) goes beyond the size from \ref capsaGetAlbumMovieStreamSize, the regions of the buffer which goes beyond that are cleared to 0, and actual_size is still set to the input size.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[in] offset Offset.
##  @param[out] Output data buffer.
##  @param[in] size Data buffer size.
##  @param[out] actual_size Actual read size.
##

proc capsaReadMovieDataFromAlbumMovieReadStream*(stream: U64; offset: S64;
    buffer: pointer; size: csize_t; actualSize: ptr U64): Result {.cdecl,
    importc: "capsaReadMovieDataFromAlbumMovieReadStream".}
## *
##  @brief Gets the BrokenReason for an AlbumMovieStream.
##  @note Official sw doesn't use this.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capsaGetAlbumMovieReadStreamBrokenReason*(stream: U64): Result {.cdecl,
    importc: "capsaGetAlbumMovieReadStreamBrokenReason".}
## *
##  @brief Gets the data size of an Image taken from an AlbumMovieStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[out] size Expected size of an Image.
##

proc capsaGetAlbumMovieReadStreamImageDataSize*(stream: U64; size: ptr U64): Result {.
    cdecl, importc: "capsaGetAlbumMovieReadStreamImageDataSize".}
## *
##  @brief Reads data of an Image taken from an AlbumMovieStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[in] offset Offset.
##  @param[out] Output data buffer.
##  @param[in] size Data buffer size.
##  @param[out] actual_size Actual read size.
##

proc capsaReadImageDataFromAlbumMovieReadStream*(stream: U64; offset: S64;
    buffer: pointer; size: csize_t; actualSize: ptr U64): Result {.cdecl,
    importc: "capsaReadImageDataFromAlbumMovieReadStream".}
## *
##  @brief Gets the file attribute of an AlbumMovieStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[out] attr \ref CapsScreenShotAttribute
##

proc capsaReadFileAttributeFromAlbumMovieReadStream*(stream: U64;
    attr: ptr CapsScreenShotAttribute): Result {.cdecl,
    importc: "capsaReadFileAttributeFromAlbumMovieReadStream".}