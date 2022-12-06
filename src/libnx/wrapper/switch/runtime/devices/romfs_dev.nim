## *
##  @file romfs_dev.h
##  @brief RomFS driver.
##  @author yellows8
##  @author mtheall
##  @author fincs
##  @copyright libnx Authors
##

import
  ../../types, ../../services/fs, ../../services/ncm_types

## / RomFS header.

type
  RomfsHeader* {.bycopy.} = object
    headerSize*: U64           ## /< Size of the header.
    dirHashTableOff*: U64      ## /< Offset of the directory hash table.
    dirHashTableSize*: U64     ## /< Size of the directory hash table.
    dirTableOff*: U64          ## /< Offset of the directory table.
    dirTableSize*: U64         ## /< Size of the directory table.
    fileHashTableOff*: U64     ## /< Offset of the file hash table.
    fileHashTableSize*: U64    ## /< Size of the file hash table.
    fileTableOff*: U64         ## /< Offset of the file table.
    fileTableSize*: U64        ## /< Size of the file table.
    fileDataOff*: U64          ## /< Offset of the file data.


## / RomFS directory.

type
  RomfsDir* {.bycopy.} = object
    parent*: U32               ## /< Offset of the parent directory.
    sibling*: U32              ## /< Offset of the next sibling directory.
    childDir*: U32             ## /< Offset of the first child directory.
    childFile*: U32            ## /< Offset of the first file.
    nextHash*: U32             ## /< Directory hash table pointer.
    nameLen*: U32              ## /< Name length.
    name*: UncheckedArray[uint8] ## /< Name. (UTF-8)


## / RomFS file.

type
  RomfsFile* {.bycopy.} = object
    parent*: U32               ## /< Offset of the parent directory.
    sibling*: U32              ## /< Offset of the next sibling file.
    dataOff*: U64              ## /< Offset of the file's data.
    dataSize*: U64             ## /< Length of the file's data.
    nextHash*: U32             ## /< File hash table pointer.
    nameLen*: U32              ## /< Name length.
    name*: UncheckedArray[uint8] ## /< Name. (UTF-8)

proc romfsMountSelf*(name: cstring): Result {.cdecl, importc: "romfsMountSelf".}
## *
##  @brief Mounts the Application's RomFS.
##  @param name Device mount name.
##  @remark This function is intended to be used to access one's own RomFS.
##          If the application is running as NRO, it mounts the embedded RomFS section inside the NRO.
##          If on the other hand it's an NSO, it behaves identically to \ref romfsMountFromCurrentProcess.
##

proc romfsMountFromFile*(file: FsFile; offset: U64; name: cstring): Result {.cdecl,
    importc: "romfsMountFromFile".}
## *
##  @brief Mounts RomFS from an open file.
##  @param file FsFile of the RomFS image.
##  @param offset Offset of the RomFS within the file.
##  @param name Device mount name.
##

proc romfsMountFromStorage*(storage: FsStorage; offset: U64; name: cstring): Result {.
    cdecl, importc: "romfsMountFromStorage".}
## *
##  @brief Mounts RomFS from an open storage.
##  @param storage FsStorage of the RomFS image.
##  @param offset Offset of the RomFS within the storage.
##  @param name Device mount name.
##

proc romfsMountFromCurrentProcess*(name: cstring): Result {.cdecl,
    importc: "romfsMountFromCurrentProcess".}
## *
##  @brief Mounts RomFS using the current process host program RomFS.
##  @param name Device mount name.
##

proc romfsMountDataStorageFromProgram*(programId: U64; name: cstring): Result {.cdecl,
    importc: "romfsMountDataStorageFromProgram".}
## *
##  @brief Mounts RomFS of a running program.
##  @note Permission needs to be set in the NPDM.
##  @param program_id ProgramId to mount.
##  @param name Device mount name.
##

proc romfsMountFromFsdev*(path: cstring; offset: U64; name: cstring): Result {.cdecl,
    importc: "romfsMountFromFsdev".}
## *
##  @brief Mounts RomFS from a file path in a mounted fsdev device.
##  @param path File path.
##  @param offset Offset of the RomFS within the file.
##  @param name Device mount name.
##

proc romfsMountFromDataArchive*(dataId: U64; storageId: NcmStorageId; name: cstring): Result {.
    cdecl, importc: "romfsMountFromDataArchive".}
## *
##  @brief Mounts RomFS from SystemData.
##  @param dataId SystemDataId to mount.
##  @param storageId Storage ID to mount from.
##  @param name Device mount name.
##

proc romfsUnmount*(name: cstring): Result {.cdecl, importc: "romfsUnmount".}
## / Unmounts the RomFS device.

proc romfsInit*(): Result {.inline, cdecl.} =
  ## / Wrapper for \ref romfsMountSelf with the default "romfs" device name.

  return romfsMountSelf("romfs")

proc romfsExit*(): Result {.inline, cdecl.} =
  ## / Wrapper for \ref romfsUnmount with the default "romfs" device name.

  return romfsUnmount("romfs")
