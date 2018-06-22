import strutils
import ospaths
const headerfs = currentSourcePath().splitPath().head & "/nx/include/switch/services/fs.h"
import libnx_wrapper/types
import libnx_wrapper/sm
const
  FS_MAX_PATH* = 0x00000301
  FS_SAVEDATA_CURRENT_TITLEID* = 0
  FS_SAVEDATA_USERID_COMMONSAVE* = 0

type
  FsFileSystem* {.importc: "FsFileSystem", header: headerfs, bycopy.} = object
    s* {.importc: "s".}: Service

  FsFile* {.importc: "FsFile", header: headerfs, bycopy.} = object
    s* {.importc: "s".}: Service

  FsDir* {.importc: "FsDir", header: headerfs, bycopy.} = object
    s* {.importc: "s".}: Service

  FsStorage* {.importc: "FsStorage", header: headerfs, bycopy.} = object
    s* {.importc: "s".}: Service

  FsSaveDataIterator* {.importc: "FsSaveDataIterator", header: headerfs, bycopy.} = object
    s* {.importc: "s".}: Service

  FsEventNotifier* {.importc: "FsEventNotifier", header: headerfs, bycopy.} = object
    s* {.importc: "s".}: Service

  FsDeviceOperator* {.importc: "FsDeviceOperator", header: headerfs, bycopy.} = object
    s* {.importc: "s".}: Service

  FsDirectoryEntry* {.importc: "FsDirectoryEntry", header: headerfs, bycopy.} = object
    name* {.importc: "name".}: array[0x00000301, char]
    pad* {.importc: "pad".}: array[3, uint8]
    `type`* {.importc: "type".}: s8
    pad2* {.importc: "pad2".}: array[3, uint8]
    fileSize* {.importc: "fileSize".}: uint64

  FsSave* {.importc: "FsSave", header: headerfs, bycopy.} = object
    titleID* {.importc: "titleID".}: uint64
    userID* {.importc: "userID".}: u128
    saveID* {.importc: "saveID".}: uint64
    SaveDataType* {.importc: "SaveDataType".}: uint64
    unk_x28* {.importc: "unk_x28".}: uint64
    unk_x30* {.importc: "unk_x30".}: uint64
    unk_x38* {.importc: "unk_x38".}: uint64

  FsSaveDataInfo* {.importc: "FsSaveDataInfo", header: headerfs, bycopy.} = object
    saveID_unk* {.importc: "saveID_unk".}: uint64
    SaveDataSpaceId* {.importc: "SaveDataSpaceId".}: uint8
    SaveDataType* {.importc: "SaveDataType".}: uint8
    pad* {.importc: "pad".}: array[6, uint8]
    userID* {.importc: "userID".}: u128
    saveID* {.importc: "saveID".}: uint64
    titleID* {.importc: "titleID".}: uint64
    size* {.importc: "size".}: uint64
    unk_x38* {.importc: "unk_x38".}: array[0x00000028, uint8]

  FsEntryType* {.size: sizeof(cint).} = enum
    ENTRYTYPE_DIR = 0, ENTRYTYPE_FILE = 1
  FsFileFlags* {.size: sizeof(cint).} = enum
    FS_OPEN_READ = (1 shl (0)), FS_OPEN_WRITE = (1 shl (1)), FS_OPEN_APPEND = (1 shl (2))
  FsDirectoryFlags* {.size: sizeof(cint).} = enum
    FS_DIROPEN_DIRECTORY = (1 shl (0)), FS_DIROPEN_FILE = (1 shl (1))
  FsStorageId* {.size: sizeof(cint).} = enum
    FsStorageId_None = 0, FsStorageId_Host = 1, FsStorageId_GameCard = 2,
    FsStorageId_NandSystem = 3, FsStorageId_NandUser = 4, FsStorageId_SdCard = 5
  FsContentStorageId* {.size: sizeof(cint).} = enum
    FS_CONTENTSTORAGEID_NandSystem = 0, FS_CONTENTSTORAGEID_NandUser = 1,
    FS_CONTENTSTORAGEID_SdCard = 2
  FsSaveDataSpaceId* {.size: sizeof(cint).} = enum
    FsSaveDataSpaceId_All = -1, FsSaveDataSpaceId_NandSystem = 0,
    FsSaveDataSpaceId_NandUser = 1, FsSaveDataSpaceId_SdCard = 2,
    FsSaveDataSpaceId_TemporaryStorage = 3
  FsSaveDataType* {.size: sizeof(cint).} = enum
    FsSaveDataType_SystemSaveData = 0, FsSaveDataType_SaveData = 1,
    FsSaveDataType_BcatDeliveryCacheStorage = 2, FsSaveDataType_DeviceSaveData = 3,
    FsSaveDataType_TemporaryStorage = 4, FsSaveDataType_CacheStorage = 5








proc fsInitialize*(): Result {.cdecl, importc: "fsInitialize", header: headerfs.}
proc fsExit*() {.cdecl, importc: "fsExit", header: headerfs.}
proc fsGetServiceSession*(): ptr Service {.cdecl, importc: "fsGetServiceSession",
                                       header: headerfs.}
proc fsMountSdcard*(`out`: ptr FsFileSystem): Result {.cdecl,
    importc: "fsMountSdcard", header: headerfs.}
proc fsMountSaveData*(`out`: ptr FsFileSystem; inval: uint8; save: ptr FsSave): Result {.
    cdecl, importc: "fsMountSaveData", header: headerfs.}
proc fsMountSystemSaveData*(`out`: ptr FsFileSystem; inval: uint8; save: ptr FsSave): Result {.
    cdecl, importc: "fsMountSystemSaveData", header: headerfs.}
proc fsOpenSaveDataIterator*(`out`: ptr FsSaveDataIterator; SaveDataSpaceId: s32): Result {.
    cdecl, importc: "fsOpenSaveDataIterator", header: headerfs.}
proc fsOpenDataStorageByCurrentProcess*(`out`: ptr FsStorage): Result {.cdecl,
    importc: "fsOpenDataStorageByCurrentProcess", header: headerfs.}
proc fsOpenDeviceOperator*(`out`: ptr FsDeviceOperator): Result {.cdecl,
    importc: "fsOpenDeviceOperator", header: headerfs.}
proc fsOpenSdCardDetectionEventNotifier*(`out`: ptr FsEventNotifier): Result {.
    cdecl, importc: "fsOpenSdCardDetectionEventNotifier", header: headerfs.}
proc fsMount_SaveData*(`out`: ptr FsFileSystem; titleID: uint64; userID: u128): Result {.
    cdecl, importc: "fsMount_SaveData", header: headerfs.}
proc fsMount_SystemSaveData*(`out`: ptr FsFileSystem; saveID: uint64): Result {.cdecl,
    importc: "fsMount_SystemSaveData", header: headerfs.}
proc fsFsCreateFile*(fs: ptr FsFileSystem; path: cstring; size: csize; flags: cint): Result {.
    cdecl, importc: "fsFsCreateFile", header: headerfs.}
proc fsFsDeleteFile*(fs: ptr FsFileSystem; path: cstring): Result {.cdecl,
    importc: "fsFsDeleteFile", header: headerfs.}
proc fsFsCreateDirectory*(fs: ptr FsFileSystem; path: cstring): Result {.cdecl,
    importc: "fsFsCreateDirectory", header: headerfs.}
proc fsFsDeleteDirectory*(fs: ptr FsFileSystem; path: cstring): Result {.cdecl,
    importc: "fsFsDeleteDirectory", header: headerfs.}
proc fsFsDeleteDirectoryRecursively*(fs: ptr FsFileSystem; path: cstring): Result {.
    cdecl, importc: "fsFsDeleteDirectoryRecursively", header: headerfs.}
proc fsFsRenameFile*(fs: ptr FsFileSystem; path0: cstring; path1: cstring): Result {.
    cdecl, importc: "fsFsRenameFile", header: headerfs.}
proc fsFsRenameDirectory*(fs: ptr FsFileSystem; path0: cstring; path1: cstring): Result {.
    cdecl, importc: "fsFsRenameDirectory", header: headerfs.}
proc fsFsGetEntryType*(fs: ptr FsFileSystem; path: cstring; `out`: ptr FsEntryType): Result {.
    cdecl, importc: "fsFsGetEntryType", header: headerfs.}
proc fsFsOpenFile*(fs: ptr FsFileSystem; path: cstring; flags: cint; `out`: ptr FsFile): Result {.
    cdecl, importc: "fsFsOpenFile", header: headerfs.}
proc fsFsOpenDirectory*(fs: ptr FsFileSystem; path: cstring; flags: cint;
                       `out`: ptr FsDir): Result {.cdecl,
    importc: "fsFsOpenDirectory", header: headerfs.}
proc fsFsCommit*(fs: ptr FsFileSystem): Result {.cdecl, importc: "fsFsCommit",
    header: headerfs.}
proc fsFsGetFreeSpace*(fs: ptr FsFileSystem; path: cstring; `out`: ptr uint64): Result {.
    cdecl, importc: "fsFsGetFreeSpace", header: headerfs.}
proc fsFsGetTotalSpace*(fs: ptr FsFileSystem; path: cstring; `out`: ptr uint64): Result {.
    cdecl, importc: "fsFsGetTotalSpace", header: headerfs.}
proc fsFsClose*(fs: ptr FsFileSystem) {.cdecl, importc: "fsFsClose", header: headerfs.}
proc fsFileRead*(f: ptr FsFile; off: uint64; buf: pointer; len: csize; `out`: ptr csize): Result {.
    cdecl, importc: "fsFileRead", header: headerfs.}
proc fsFileWrite*(f: ptr FsFile; off: uint64; buf: pointer; len: csize): Result {.cdecl,
    importc: "fsFileWrite", header: headerfs.}
proc fsFileFlush*(f: ptr FsFile): Result {.cdecl, importc: "fsFileFlush",
                                      header: headerfs.}
proc fsFileSetSize*(f: ptr FsFile; sz: uint64): Result {.cdecl, importc: "fsFileSetSize",
    header: headerfs.}
proc fsFileGetSize*(f: ptr FsFile; `out`: ptr uint64): Result {.cdecl,
    importc: "fsFileGetSize", header: headerfs.}
proc fsFileClose*(f: ptr FsFile) {.cdecl, importc: "fsFileClose", header: headerfs.}
proc fsDirRead*(d: ptr FsDir; inval: uint64; total_entries: ptr csize; max_entries: csize;
               buf: ptr FsDirectoryEntry): Result {.cdecl, importc: "fsDirRead",
    header: headerfs.}
proc fsDirGetEntryCount*(d: ptr FsDir; count: ptr uint64): Result {.cdecl,
    importc: "fsDirGetEntryCount", header: headerfs.}
proc fsDirClose*(d: ptr FsDir) {.cdecl, importc: "fsDirClose", header: headerfs.}
proc fsStorageRead*(s: ptr FsStorage; off: uint64; buf: pointer; len: csize): Result {.
    cdecl, importc: "fsStorageRead", header: headerfs.}
proc fsStorageClose*(s: ptr FsStorage) {.cdecl, importc: "fsStorageClose",
                                     header: headerfs.}
proc fsSaveDataIteratorRead*(s: ptr FsSaveDataIterator; buf: ptr FsSaveDataInfo;
                            max_entries: csize; total_entries: ptr csize): Result {.
    cdecl, importc: "fsSaveDataIteratorRead", header: headerfs.}
proc fsSaveDataIteratorClose*(s: ptr FsSaveDataIterator) {.cdecl,
    importc: "fsSaveDataIteratorClose", header: headerfs.}
proc fsEventNotifierGetEventHandle*(e: ptr FsEventNotifier; `out`: ptr Handle): Result {.
    cdecl, importc: "fsEventNotifierGetEventHandle", header: headerfs.}
proc fsEventNotifierClose*(e: ptr FsEventNotifier) {.cdecl,
    importc: "fsEventNotifierClose", header: headerfs.}
proc fsDeviceOperatorIsSdCardInserted*(d: ptr FsDeviceOperator; `out`: ptr bool): Result {.
    cdecl, importc: "fsDeviceOperatorIsSdCardInserted", header: headerfs.}
proc fsDeviceOperatorClose*(d: ptr FsDeviceOperator) {.cdecl,
    importc: "fsDeviceOperatorClose", header: headerfs.}