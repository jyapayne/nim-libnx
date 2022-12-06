## *
##  @file capssu.h
##  @brief Application screenshot saving (caps:su) service IPC wrapper.
##  @author yellows8
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/acc, ../services/caps

## / Initialize caps:su. Only available on [4.0.0+].

proc capssuInitialize*(): Result {.cdecl, importc: "capssuInitialize".}
## / Exit caps:su.

proc capssuExit*() {.cdecl, importc: "capssuExit".}
## / Gets the Service for caps:su.

proc capssuGetServiceSession*(): ptr Service {.cdecl,
    importc: "capssuGetServiceSession".}
## *
##  @brief This is a wrapper for \ref capssuSaveScreenShotEx0.
##  @note This uses an all-zero \ref CapsScreenShotAttribute with orientation = input orientation, and unk_xc = 1.
##  @param[in] buffer RGBA8 1280x720 image buffer.
##  @param[in] size Size of the buffer.
##  @param[in] reportoption \ref AlbumReportOption
##  @param[in] orientation \ref AlbumImageOrientation
##  @param[out] out \ref CapsApplicationAlbumEntry. Optional, can be NULL.
##

proc capssuSaveScreenShot*(buffer: pointer; size: csize_t;
                          reportoption: AlbumReportOption;
                          orientation: AlbumImageOrientation;
                          `out`: ptr CapsApplicationAlbumEntry): Result {.cdecl,
    importc: "capssuSaveScreenShot".}
## *
##  @brief Similar to \ref capssuSaveScreenShot, except this is a wrapper for \ref capssuSaveScreenShotEx1.
##  @note This uses an all-zero \ref CapsScreenShotAttribute with orientation = input orientation, and unk_xc = 1.
##  @note Only available on [8.0.0+].
##  @param[in] buffer RGBA8 1280x720 image data buffer.
##  @param[in] size Size of the buffer.
##  @param[in] reportoption \ref AlbumReportOption
##  @param[in] orientation \ref AlbumImageOrientation
##  @param[in] userdata Input UserData buffer. If NULL, the \ref CapsApplicationData will be empty.
##  @param[in] userdata_size Input UserData size, must be within bounds for CapsApplicationData::userdata. If 0, the \ref CapsApplicationData will be empty.
##  @param[out] out \ref CapsApplicationAlbumEntry. Optional, can be NULL.
##

proc capssuSaveScreenShotWithUserData*(buffer: pointer; size: csize_t;
                                      reportoption: AlbumReportOption;
                                      orientation: AlbumImageOrientation;
                                      userdata: pointer; userdataSize: csize_t;
                                      `out`: ptr CapsApplicationAlbumEntry): Result {.
    cdecl, importc: "capssuSaveScreenShotWithUserData".}
## *
##  @brief Similar to \ref capssuSaveScreenShot, except this is a wrapper for \ref capssuSaveScreenShotEx2.
##  @note This uses an all-zero \ref CapsScreenShotAttribute with orientation = input orientation, and unk_xc = 1.
##  @note Only available on [6.0.0+].
##  @param[in] buffer RGBA8 1280x720 image data buffer.
##  @param[in] size Size of the buffer.
##  @param[in] reportoption \ref AlbumReportOption
##  @param[in] orientation \ref AlbumImageOrientation
##  @param[in] uids Input array of \ref AccountUid. If NULL, the \ref CapsUserIdList will be empty.
##  @param[in] uid_count Size of the uids array in entries, must be within bounds for CapsUserIdList::uids. If 0, the \ref CapsUserIdList will be empty.
##  @param[out] out \ref CapsApplicationAlbumEntry. Optional, can be NULL.
##

proc capssuSaveScreenShotWithUserIds*(buffer: pointer; size: csize_t;
                                     reportoption: AlbumReportOption;
                                     orientation: AlbumImageOrientation;
                                     uids: ptr AccountUid; uidCount: csize_t;
                                     `out`: ptr CapsApplicationAlbumEntry): Result {.
    cdecl, importc: "capssuSaveScreenShotWithUserIds".}
## *
##  @brief Saves an Album screenshot using the specified gfx data in the buffer, with the specified \ref CapsScreenShotAttribute.
##  @param[in] buffer RGBA8 1280x720 image data buffer.
##  @param[in] size Size of the buffer, must be at least 0x384000.
##  @param[in] attr \ref CapsScreenShotAttribute
##  @param[in] reportoption \ref AlbumReportOption
##  @param[out] out \ref CapsApplicationAlbumEntry. Optional, can be NULL.
##

proc capssuSaveScreenShotEx0*(buffer: pointer; size: csize_t;
                             attr: ptr CapsScreenShotAttribute;
                             reportoption: AlbumReportOption;
                             `out`: ptr CapsApplicationAlbumEntry): Result {.cdecl,
    importc: "capssuSaveScreenShotEx0".}
## *
##  @brief Same as \ref capssuSaveScreenShotEx0, except this allows specifying the \ref CapsApplicationData.
##  @note Only available on [8.0.0+].
##  @param[in] buffer RGBA8 1280x720 image data buffer.
##  @param[in] size Size of the buffer, must be at least 0x384000.
##  @param[in] attr \ref CapsScreenShotAttribute
##  @param[in] reportoption \ref AlbumReportOption
##  @param[in] appdata \ref CapsApplicationData
##  @param[out] out \ref CapsApplicationAlbumEntry. Optional, can be NULL.
##

proc capssuSaveScreenShotEx1*(buffer: pointer; size: csize_t;
                             attr: ptr CapsScreenShotAttribute;
                             reportoption: AlbumReportOption;
                             appdata: ptr CapsApplicationData;
                             `out`: ptr CapsApplicationAlbumEntry): Result {.cdecl,
    importc: "capssuSaveScreenShotEx1".}
## *
##  @brief Same as \ref capssuSaveScreenShotEx0, except this allows specifying the \ref CapsUserIdList.
##  @note Only available on [6.0.0+].
##  @param[in] buffer RGBA8 1280x720 image data buffer.
##  @param[in] size Size of the buffer, must be at least 0x384000.
##  @param[in] attr \ref CapsScreenShotAttribute
##  @param[in] reportoption \ref AlbumReportOption
##  @param[in] list \ref CapsUserIdList
##  @param[out] out \ref CapsApplicationAlbumEntry. Optional, can be NULL.
##

proc capssuSaveScreenShotEx2*(buffer: pointer; size: csize_t;
                             attr: ptr CapsScreenShotAttribute;
                             reportoption: AlbumReportOption;
                             list: ptr CapsUserIdList;
                             `out`: ptr CapsApplicationAlbumEntry): Result {.cdecl,
    importc: "capssuSaveScreenShotEx2".}