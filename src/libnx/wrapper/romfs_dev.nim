import strutils
import ospaths
const headerromfs_dev = currentSourcePath().splitPath().head & "/nx/include/switch/runtime/devices/romfs_dev.h"
## *
##  @file Romfs_dev.h
##  @brief RomFS driver.
##  @author yellows8
##  @author mtheall
##  @author fincs
##  @copyright libnx Authors
## 

import
  ../libnx/wrapper/types, ../libnx/wrapper/fs

## / RomFS header.

type
  Romfs_header* {.importc: "Romfs_header", header: headerromfs_dev, bycopy.} = object
    headerSize* {.importc: "headerSize".}: uint64 ## /< Size of the header.
    dirHashTableOff* {.importc: "dirHashTableOff".}: uint64 ## /< Offset of the directory hash table.
    dirHashTableSize* {.importc: "dirHashTableSize".}: uint64 ## /< Size of the directory hash table.
    dirTableOff* {.importc: "dirTableOff".}: uint64 ## /< Offset of the directory table.
    dirTableSize* {.importc: "dirTableSize".}: uint64 ## /< Size of the directory table.
    fileHashTableOff* {.importc: "fileHashTableOff".}: uint64 ## /< Offset of the file hash table.
    fileHashTableSize* {.importc: "fileHashTableSize".}: uint64 ## /< Size of the file hash table.
    fileTableOff* {.importc: "fileTableOff".}: uint64 ## /< Offset of the file table.
    fileTableSize* {.importc: "fileTableSize".}: uint64 ## /< Size of the file table.
    fileDataOff* {.importc: "fileDataOff".}: uint64 ## /< Offset of the file data.
  

## / RomFS directory.

type
  Romfs_dir* {.importc: "Romfs_dir", header: headerromfs_dev, bycopy.} = object
    parent* {.importc: "parent".}: uint32 ## /< Offset of the parent directory.
    sibling* {.importc: "sibling".}: uint32 ## /< Offset of the next sibling directory.
    childDir* {.importc: "childDir".}: uint32 ## /< Offset of the first child directory.
    childFile* {.importc: "childFile".}: uint32 ## /< Offset of the first file.
    nextHash* {.importc: "nextHash".}: uint32 ## /< Directory hash table pointer.
    nameLen* {.importc: "nameLen".}: uint32 ## /< Name length.
    name* {.importc: "name".}: ptr uint8_t ## /< Name. (UTF-8)
  

## / RomFS file.

type
  Romfs_file* {.importc: "Romfs_file", header: headerromfs_dev, bycopy.} = object
    parent* {.importc: "parent".}: uint32 ## /< Offset of the parent directory.
    sibling* {.importc: "sibling".}: uint32 ## /< Offset of the next sibling file.
    dataOff* {.importc: "dataOff".}: uint64 ## /< Offset of the file's data.
    dataSize* {.importc: "dataSize".}: uint64 ## /< Length of the file's data.
    nextHash* {.importc: "nextHash".}: uint32 ## /< File hash table pointer.
    nameLen* {.importc: "nameLen".}: uint32 ## /< Name length.
    name* {.importc: "name".}: ptr uint8_t ## /< Name. (UTF-8)
  
  Romfs_mount* {.importc: "Romfs_mount", header: headerromfs_dev, bycopy.} = object
  

## *
##  @brief Mounts the Application's RomFS.
##  @param mount Output mount handle
## 

proc romfsMount*(mount: ptr ptr Romfs_mount): Result {.cdecl, importc: "romfsMount",
    header: headerromfs_dev.}
proc romfsInit*(): Result {.inline, cdecl, importc: "romfsInit",
                         header: headerromfs_dev.}
## *
##  @brief Mounts RomFS from an open file.
##  @param file FsFile of the RomFS image.
##  @param offset Offset of the RomFS within the file.
##  @param mount Output mount handle
## 

proc romfsMountFromFile*(file: FsFile; offset: uint64; mount: ptr ptr Romfs_mount): Result {.
    cdecl, importc: "romfsMountFromFile", header: headerromfs_dev.}
proc romfsInitFromFile*(file: FsFile; offset: uint64): Result {.inline, cdecl,
    importc: "romfsInitFromFile", header: headerromfs_dev.}
## *
##  @brief Mounts RomFS from an open storage.
##  @param storage FsStorage of the RomFS image.
##  @param offset Offset of the RomFS within the storage.
##  @param mount Output mount handle
## 

proc romfsMountFromStorage*(storage: FsStorage; offset: uint64;
                           mount: ptr ptr Romfs_mount): Result {.cdecl,
    importc: "romfsMountFromStorage", header: headerromfs_dev.}
proc romfsInitFromStorage*(storage: FsStorage; offset: uint64): Result {.inline, cdecl,
    importc: "romfsInitFromStorage", header: headerromfs_dev.}
## / Bind the RomFS mount

proc romfsBind*(mount: ptr Romfs_mount): Result {.cdecl, importc: "romfsBind",
    header: headerromfs_dev.}
## / Unmounts the RomFS device.

proc romfsUnmount*(mount: ptr Romfs_mount): Result {.cdecl, importc: "romfsUnmount",
    header: headerromfs_dev.}
proc romfsExit*(): Result {.inline, cdecl, importc: "romfsExit",
                         header: headerromfs_dev.}