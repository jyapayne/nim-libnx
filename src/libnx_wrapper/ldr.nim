import strutils
import ospaths
const headerldr = currentSourcePath().splitPath().head & "/nx/include/switch/services/ldr.h"
import libnx_wrapper/types
import libnx_wrapper/sm
import libnx_wrapper/fs
type
  LoaderProgramInfo* {.importc: "LoaderProgramInfo", header: headerldr, bycopy.} = object
    main_thread_priority* {.importc: "main_thread_priority".}: uint8
    default_cpu_id* {.importc: "default_cpu_id".}: uint8
    application_type* {.importc: "application_type".}: uint16
    main_thread_stack_size* {.importc: "main_thread_stack_size".}: uint32
    title_id* {.importc: "title_id".}: uint64
    acid_sac_size* {.importc: "acid_sac_size".}: uint32
    aci0_sac_size* {.importc: "aci0_sac_size".}: uint32
    acid_fac_size* {.importc: "acid_fac_size".}: uint32
    aci0_fah_size* {.importc: "aci0_fah_size".}: uint32
    ac_buffer* {.importc: "ac_buffer".}: array[0x000003E0, uint8]

  LoaderNsoInfo* {.importc: "LoaderNsoInfo", header: headerldr, bycopy.} = object
    base_address* {.importc: "base_address".}: uint64
    size* {.importc: "size".}: uint64
    build_id* {.importc: "build_id".}: array[0x00000020, uint8]


proc ldrShellInitialize*(): Result {.cdecl, importc: "ldrShellInitialize",
                                  header: headerldr.}
proc ldrShellExit*() {.cdecl, importc: "ldrShellExit", header: headerldr.}
proc ldrDmntInitialize*(): Result {.cdecl, importc: "ldrDmntInitialize",
                                 header: headerldr.}
proc ldrDmntExit*() {.cdecl, importc: "ldrDmntExit", header: headerldr.}
proc ldrPmInitialize*(): Result {.cdecl, importc: "ldrPmInitialize",
                               header: headerldr.}
proc ldrPmExit*() {.cdecl, importc: "ldrPmExit", header: headerldr.}
proc ldrShellAddTitleToLaunchQueue*(tid: uint64; args: pointer; args_size: csize): Result {.
    cdecl, importc: "ldrShellAddTitleToLaunchQueue", header: headerldr.}
proc ldrShellClearLaunchQueue*(): Result {.cdecl,
                                        importc: "ldrShellClearLaunchQueue",
                                        header: headerldr.}
proc ldrDmntAddTitleToLaunchQueue*(tid: uint64; args: pointer; args_size: csize): Result {.
    cdecl, importc: "ldrDmntAddTitleToLaunchQueue", header: headerldr.}
proc ldrDmntClearLaunchQueue*(): Result {.cdecl,
                                       importc: "ldrDmntClearLaunchQueue",
                                       header: headerldr.}
proc ldrDmntGetNsoInfos*(pid: uint64; out_nso_infos: ptr LoaderNsoInfo; out_size: csize;
                        num_out: ptr uint32): Result {.cdecl,
    importc: "ldrDmntGetNsoInfos", header: headerldr.}
proc ldrPmCreateProcess*(flags: uint64; launch_index: uint64; reslimit_h: Handle;
                        out_process_h: ptr Handle): Result {.cdecl,
    importc: "ldrPmCreateProcess", header: headerldr.}
proc ldrPmGetProgramInfo*(title_id: uint64; storage_id: FsStorageId;
                         out_program_info: ptr LoaderProgramInfo): Result {.cdecl,
    importc: "ldrPmGetProgramInfo", header: headerldr.}
proc ldrPmRegisterTitle*(title_id: uint64; storage_id: FsStorageId; out_index: ptr uint64): Result {.
    cdecl, importc: "ldrPmRegisterTitle", header: headerldr.}
proc ldrPmUnregisterTitle*(launch_index: uint64): Result {.cdecl,
    importc: "ldrPmUnregisterTitle", header: headerldr.}