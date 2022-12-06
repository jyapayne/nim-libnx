## *
##  @file miiimg.h
##  @brief Mii image (miiimg) service IPC wrapper.
##  @author XorTroll
##  @copyright libnx Authors
##

import
  ../types, ../sf/service, ../services/mii

## / Image ID.

type
  MiiimgImageId* {.bycopy.} = object
    uuid*: Uuid


## / Image attribute.

type
  MiiimgImageAttribute* {.bycopy.} = object
    imageId*: MiiimgImageId    ## /< Image ID.
    createId*: MiiCreateId     ## /< Mii's create ID.
    unk*: U32
    miiName*: array[10 + 1, U16]  ## /< utf-16be, null-terminated


## / Initialize miiimg.

proc miiimgInitialize*(): Result {.cdecl, importc: "miiimgInitialize".}
## / Exit miiimg.

proc miiimgExit*() {.cdecl, importc: "miiimgExit".}
## / Gets the Service object for the actual miiimg service session.

proc miiimgGetServiceSession*(): ptr Service {.cdecl,
    importc: "miiimgGetServiceSession".}
## *
##  @brief Reloads the image database.
##

proc miiimgReload*(): Result {.cdecl, importc: "miiimgReload".}
## *
##  @brief Gets the number of mii images in the database.
##  @param[out] out_count Mii image count.
##

proc miiimgGetCount*(outCount: ptr S32): Result {.cdecl, importc: "miiimgGetCount".}
## *
##  @brief Gets whether the image database is empty.
##  @param[out] out_empty Whether the database is empty.
##

proc miiimgIsEmpty*(outEmpty: ptr bool): Result {.cdecl, importc: "miiimgIsEmpty".}
## *
##  @brief Gets whether the image database is full.
##  @param[out] out_empty Whether the database is full.
##

proc miiimgIsFull*(outFull: ptr bool): Result {.cdecl, importc: "miiimgIsFull".}
## *
##  @brief Gets the image attribute for the specified image index.
##  @param[in] index Image index.
##  @param[out] out_attr Out image attribute.
##

proc miiimgGetAttribute*(index: S32; outAttr: ptr MiiimgImageAttribute): Result {.
    cdecl, importc: "miiimgGetAttribute".}
## *
##  @brief Loads the image data (raw RGBA8) for the specified image ID.
##  @note Server doesn't seem to check the image buffer size, but 0x40000 is the optimal size.
##  @param[in] id Input image ID.
##  @param[out] out_image Out iamge buffer.
##  @param[in] out_image_size Out image buffer size.
##

proc miiimgLoadImage*(id: MiiimgImageId; outImage: pointer; outImageSize: csize_t): Result {.
    cdecl, importc: "miiimgLoadImage".}