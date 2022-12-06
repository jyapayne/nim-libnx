## *
##  @file capsc.h
##  @brief Album Control (caps:c) service IPC wrapper.
##  @author Behemoth
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/caps

## / Initialize caps:c

proc capscInitialize*(): Result {.cdecl, importc: "capscInitialize".}
## / Exit caps:c.

proc capscExit*() {.cdecl, importc: "capscExit".}
## / Gets the Service for caps:c.

proc capscGetServiceSession*(): ptr Service {.cdecl,
    importc: "capscGetServiceSession".}
## *
##  @brief Notify the service that a storage is now available.
##  @note This will result in capsrv mounting the image directory on that storage medium.
##  @param[in] storage \ref CapsAlbumStorage
##

proc capscNotifyAlbumStorageIsAvailable*(storage: CapsAlbumStorage): Result {.cdecl,
    importc: "capscNotifyAlbumStorageIsAvailable".}
## *
##  @brief Notify the service that a storage is now unavailable.
##  @note This will result in capsrv unmounting the image directory on that storage medium.
##  @param[in] storage \ref CapsAlbumStorage
##

proc capscNotifyAlbumStorageIsUnAvailable*(storage: CapsAlbumStorage): Result {.
    cdecl, importc: "capscNotifyAlbumStorageIsUnAvailable".}
## *
##  @brief Register an applet for later usage.
##  @note Called at application launch by the system.
##  @note Will generate a random AES-256 key for this application for use on Shim-Version 0.
##  @note Only available on [2.0.0+].
##  @param[in] appletResourceUserId AppletResourceUserId.
##  @param[in] application_id ApplicationId.
##

proc capscRegisterAppletResourceUserId*(appletResourceUserId: U64;
                                       applicationId: U64): Result {.cdecl,
    importc: "capscRegisterAppletResourceUserId".}
## *
##  @brief Unregister an applet.
##  @note Called at application exit by the system.
##  @note Only available on [2.0.0+].
##  @param[in] appletResourceUserId AppletResourceUserId.
##  @param[in] application_id ApplicationId.
##

proc capscUnregisterAppletResourceUserId*(appletResourceUserId: U64;
    applicationId: U64): Result {.cdecl,
                               importc: "capscUnregisterAppletResourceUserId".}
## *
##  @brief Get an ApplicationId that corresponds to an AppletResourceUserId.
##  @note Returns value set by \ref capscRegisterAppletResourceUserId.
##  @note Only available on [2.0.0+].
##  @param[out] application_id ApplicationId.
##  @param[in] appletResourceUserId AppletResourceUserId.
##

proc capscGetApplicationIdFromAruid*(applicationId: ptr U64; aruid: U64): Result {.
    cdecl, importc: "capscGetApplicationIdFromAruid".}
## *
##  @brief Checks whether an ApplicationId is registered.
##  @note Only available on [2.0.0+].
##  @param[in] application_id ApplicationId.
##

proc capscCheckApplicationIdRegistered*(applicationId: U64): Result {.cdecl,
    importc: "capscCheckApplicationIdRegistered".}
## *
##  @brief Generate an AlbumFileId based on parameters and current time.
##  @param[in] application_id ApplicationId.
##  @note Only available on [2.0.0+].
##  @param[in] contents \ref CapsAlbumFileContents
##  @param[out] file_id \ref CapsAlbumFileId
##

proc capscGenerateCurrentAlbumFileId*(applicationId: U64;
                                     contents: CapsAlbumFileContents;
                                     fileId: ptr CapsAlbumFileId): Result {.cdecl,
    importc: "capscGenerateCurrentAlbumFileId".}
## *
##  @brief Generate an ApplicationAlbumEntry based on parameters.
##  @note Output will be different between Shim Version 0 and 1.
##  @note Only available on [2.0.0+].
##  @param[out] appEntry \ref CapsApplicationAlbumEntry
##  @param[in] entry \ref CapsAlbumEntry
##  @param[in] application_id ApplicationId.
##

proc capscGenerateApplicationAlbumEntry*(appEntry: ptr CapsApplicationAlbumEntry;
                                        entry: ptr CapsAlbumEntry;
                                        applicationId: U64): Result {.cdecl,
    importc: "capscGenerateApplicationAlbumEntry".}
## *
##  @brief Save a jpeg image.
##  @note Only available on [2.0.0-3.0.2].
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] buffer JPEG image buffer.
##  @param[in] buffer_size Size of the JPEG image.
##

proc capscSaveAlbumScreenShotFile*(fileId: ptr CapsAlbumFileId; buffer: pointer;
                                  bufferSize: U64): Result {.cdecl,
    importc: "capscSaveAlbumScreenShotFile".}
## *
##  @brief Save a jpeg image.
##  @note Only available on [4.0.0+].
##  @note Version 3 as of [9.1.0].
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] version Revision number.
##  @param[in] makernote_offset Offset to makernote in JPEG buffer.
##  @param[in] makernote_size Size of the makernote in JPEG buffer.
##  @param[in] buffer JPEG image buffer.
##  @param[in] buffer_size Size of the JPEG image.
##

proc capscSaveAlbumScreenShotFileEx*(fileId: ptr CapsAlbumFileId; version: U64;
                                    makernoteOffset: U64; makernoteSize: U64;
                                    buffer: pointer; bufferSize: U64): Result {.
    cdecl, importc: "capscSaveAlbumScreenShotFileEx".}
## *
##  @brief Sets thumbnail data for the last taken screenshot.
##  @note 96×54 Image will get saved.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] image RGBA8 image buffer.
##  @param[in] image_size size of the RGBA8 image buffer.
##

proc capscSetOverlayScreenShotThumbnailData*(fileId: ptr CapsAlbumFileId;
    image: pointer; imageSize: U64): Result {.cdecl,
    importc: "capscSetOverlayScreenShotThumbnailData".}
## *
##  @brief Sets thumbnail data for the last recorded movie.
##  @note Only availabe on [4.0.0+].
##  @note 96×54 Image will get saved.
##  @param[in] file_id \ref CapsAlbumFileId
##  @param[in] image RGBA8 image buffer.
##  @param[in] image_size size of the RGBA8 image buffer.
##

proc capscSetOverlayMovieThumbnailData*(fileId: ptr CapsAlbumFileId; image: pointer;
                                       imageSize: U64): Result {.cdecl,
    importc: "capscSetOverlayMovieThumbnailData".}
## *
##  @brief Opens an AlbumMovieReadStream.
##  @note This opens IAlbumControlSession if not previously opened, it's closed during \ref capscExit.
##  @note Up to 4 streams can be open at the same time. Multiple streams can be open at the same time for the same \ref CapsAlbumFileId.
##  @note Only available on [4.0.0+].
##  @param[out] stream Stream handle.
##  @param[in] entry \ref CapsAlbumFileId
##

proc capscOpenAlbumMovieReadStream*(stream: ptr U64; fileId: ptr CapsAlbumFileId): Result {.
    cdecl, importc: "capscOpenAlbumMovieReadStream".}
## *
##  @brief Closes an AlbumMovieReadStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscCloseAlbumMovieStream*(stream: U64): Result {.cdecl,
    importc: "capscCloseAlbumMovieStream".}
## *
##  @brief Gets the data size of an AlbumMovieReadStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[out] size Size of the actual MP4, without the JPEG at the end.
##

proc capscGetAlbumMovieStreamSize*(stream: U64; size: ptr U64): Result {.cdecl,
    importc: "capscGetAlbumMovieStreamSize".}
## *
##  @brief Reads data from an AlbumMovieReadStream.
##  @note offset(+size) must not be negative. offset and size must be aligned to 0x40000-bytes.
##  @note When offset(+size) goes beyond the size from \ref capscGetAlbumMovieStreamSize, the regions of the buffer which goes beyond that are cleared to 0, and actual_size is still set to the input size.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[in] offset Offset.
##  @param[out] Output data buffer.
##  @param[in] size Data buffer size.
##  @param[out] actual_size Actual read size.
##

proc capscReadMovieDataFromAlbumMovieReadStream*(stream: U64; offset: U64;
    buffer: pointer; size: csize_t; actualSize: ptr U64): Result {.cdecl,
    importc: "capscReadMovieDataFromAlbumMovieReadStream".}
## *
##  @brief Gets the BrokenReason for an AlbumMovieReadStream.
##  @note Official sw doesn't use this.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscGetAlbumMovieReadStreamBrokenReason*(stream: U64): Result {.cdecl,
    importc: "capscGetAlbumMovieReadStreamBrokenReason".}
## *
##  @brief Gets the data size of an Image taken from an AlbumMovieReadStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[out] size Expected size of an Image.
##

proc capscGetAlbumMovieReadStreamImageDataSize*(stream: U64; size: ptr U64): Result {.
    cdecl, importc: "capscGetAlbumMovieReadStreamImageDataSize".}
## *
##  @brief Reads data of an Image taken from an AlbumMovieReadStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[in] offset Offset.
##  @param[out] buffer Output data buffer.
##  @param[in] size Data buffer size.
##  @param[out] actual_size Actual read size.
##

proc capscReadImageDataFromAlbumMovieReadStream*(stream: U64; offset: U64;
    buffer: pointer; size: csize_t; actualSize: ptr U64): Result {.cdecl,
    importc: "capscReadImageDataFromAlbumMovieReadStream".}
## *
##  @brief Gets the file attribute of an AlbumMovieReadStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[out] attr \ref CapsScreenShotAttribute
##

proc capscReadFileAttributeFromAlbumMovieReadStream*(stream: U64;
    attribute: ptr CapsScreenShotAttribute): Result {.cdecl,
    importc: "capscReadFileAttributeFromAlbumMovieReadStream".}
## *
##  @brief Opens an AlbumMovieWriteStream.
##  @note This opens IAlbumControlSession if not previously opened, it's closed during \ref capsaExit.
##  @note Up to 2 streams can be open at the same time.
##  @note Only available on [4.0.0+].
##  @param[out] stream Stream handle.
##  @param[in] entry \ref CapsAlbumFileId
##

proc capscOpenAlbumMovieWriteStream*(stream: ptr U64; fileId: ptr CapsAlbumFileId): Result {.
    cdecl, importc: "capscOpenAlbumMovieWriteStream".}
## *
##  @brief Finish write to AlbumMovieWriteStream.
##  @note Copies file from save to destination storage and deletes the temporary file.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscFinishAlbumMovieWriteStream*(stream: U64): Result {.cdecl,
    importc: "capscFinishAlbumMovieWriteStream".}
## *
##  @brief Closes a finished AlbumMovieWriteStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscCommitAlbumMovieWriteStream*(stream: U64): Result {.cdecl,
    importc: "capscCommitAlbumMovieWriteStream".}
## *
##  @brief Closes an AlbumMovieWriteStream in any state.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscDiscardAlbumMovieWriteStream*(stream: U64): Result {.cdecl,
    importc: "capscDiscardAlbumMovieWriteStream".}
## *
##  @brief Closes an AlbumMovieWriteStream in any state without deleting the temporary file.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscDiscardAlbumMovieWriteStreamNoDelete*(stream: U64): Result {.cdecl,
    importc: "capscDiscardAlbumMovieWriteStreamNoDelete".}
## *
##  @brief Closes a finished AlbumMovieWriteStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[out] entry \ref CapsAlbumEntry
##

proc capscCommitAlbumMovieWriteStreamEx*(stream: U64; entry: ptr CapsAlbumEntry): Result {.
    cdecl, importc: "capscCommitAlbumMovieWriteStreamEx".}
## *
##  @brief Start AlbumMovieWriteStream data section.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscStartAlbumMovieWriteStreamDataSection*(stream: U64): Result {.cdecl,
    importc: "capscStartAlbumMovieWriteStreamDataSection".}
## *
##  @brief End AlbumMovieWriteStream data section.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscEndAlbumMovieWriteStreamDataSection*(stream: U64): Result {.cdecl,
    importc: "capscEndAlbumMovieWriteStreamDataSection".}
## *
##  @brief Start AlbumMovieWriteStream meta section.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscStartAlbumMovieWriteStreamMetaSection*(stream: U64): Result {.cdecl,
    importc: "capscStartAlbumMovieWriteStreamMetaSection".}
## *
##  @brief End AlbumMovieWriteStream meta section.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscEndAlbumMovieWriteStreamMetaSection*(stream: U64): Result {.cdecl,
    importc: "capscEndAlbumMovieWriteStreamMetaSection".}
## *
##  @brief Reads data from an AlbumMovieWriteStream.
##  @note offset(+size) must not be negative. offset and size must be aligned to 0x40000-bytes.
##  @note When offset(+size) goes beyond the size from \ref capscGetAlbumMovieStreamSize, the regions of the buffer which goes beyond that are cleared to 0, and actual_size is still set to the input size.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[in] offset Offset.
##  @param[out] buffer Output data buffer.
##  @param[in] size Data buffer size.
##  @param[out] actual_size Actual read size.
##

proc capscReadDataFromAlbumMovieWriteStream*(stream: U64; offset: U64;
    buffer: pointer; size: U64; actualSize: ptr U64): Result {.cdecl,
    importc: "capscReadDataFromAlbumMovieWriteStream".}
## *
##  @brief Write data to an AlbumMovieWriteStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[in] offset Offset.
##  @param[in] buffer Input data buffer.
##  @param[in] size Data buffer size.
##

proc capscWriteDataToAlbumMovieWriteStream*(stream: U64; offset: U64;
    buffer: pointer; size: U64): Result {.cdecl, importc: "capscWriteDataToAlbumMovieWriteStream".}
## *
##  @brief Write meta data to an AlbumMovieWriteStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[in] offset Offset.
##  @param[in] buffer Input data buffer.
##  @param[in] size Data buffer size.
##

proc capscWriteMetaToAlbumMovieWriteStream*(stream: U64; offset: U64;
    buffer: pointer; size: U64): Result {.cdecl, importc: "capscWriteMetaToAlbumMovieWriteStream".}
## *
##  @brief Gets the BrokenReason for an AlbumMovieWriteStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##

proc capscGetAlbumMovieWriteStreamBrokenReason*(stream: U64): Result {.cdecl,
    importc: "capscGetAlbumMovieWriteStreamBrokenReason".}
## *
##  @brief Gets the data size of an AlbumMovieWriteStream.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[out] size Size of the data section.
##

proc capscGetAlbumMovieWriteStreamDataSize*(stream: U64; size: ptr U64): Result {.
    cdecl, importc: "capscGetAlbumMovieWriteStreamDataSize".}
## *
##  @brief Sets the data size of an AlbumMovieWriteStream.
##  @note Must not be bigger than 2GiB.
##  @note Only available on [4.0.0+].
##  @param[in] stream Stream handle.
##  @param[out] size Size of the data section.
##

proc capscSetAlbumMovieWriteStreamDataSize*(stream: U64; size: U64): Result {.cdecl,
    importc: "capscSetAlbumMovieWriteStreamDataSize".}