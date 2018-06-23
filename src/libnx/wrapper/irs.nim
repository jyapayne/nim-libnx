import strutils
import ospaths
const headerirs = currentSourcePath().splitPath().head & "/nx/include/switch/services/irs.h"
import libnx/wrapper/types
import libnx/wrapper/sm
import libnx/wrapper/hid
type
  IrsPackedMomentProcessorConfig* {.importc: "IrsPackedMomentProcessorConfig",
                                   header: headerirs, bycopy.} = object
    unk_x0* {.importc: "unk_x0".}: uint64
    unk_x8* {.importc: "unk_x8".}: uint8
    unk_x9* {.importc: "unk_x9".}: uint8
    unk_xa* {.importc: "unk_xa".}: uint8
    pad* {.importc: "pad".}: array[5, uint8]
    unk_x10* {.importc: "unk_x10".}: uint16
    unk_x12* {.importc: "unk_x12".}: uint32
    unk_x16* {.importc: "unk_x16".}: uint16
    unk_constant* {.importc: "unk_constant".}: uint32
    unk_x1c* {.importc: "unk_x1c".}: uint8
    unk_x1d* {.importc: "unk_x1d".}: uint8
    pad2* {.importc: "pad2".}: array[2, uint8]

  IrsImageTransferProcessorConfig* {.importc: "IrsImageTransferProcessorConfig",
                                    header: headerirs, bycopy.} = object
    exposure* {.importc: "exposure".}: uint64
    ir_leds* {.importc: "ir_leds".}: uint32
    digital_gain* {.importc: "digital_gain".}: uint32
    color_invert* {.importc: "color_invert".}: uint8
    pad* {.importc: "pad".}: array[7, uint8]
    sensor_res* {.importc: "sensor_res".}: uint32

  IrsPackedImageTransferProcessorConfig* {.
      importc: "IrsPackedImageTransferProcessorConfig", header: headerirs, bycopy.} = object
    exposure* {.importc: "exposure".}: uint64
    ir_leds* {.importc: "ir_leds".}: uint8
    digital_gain* {.importc: "digital_gain".}: uint8
    color_invert* {.importc: "color_invert".}: uint8
    pad* {.importc: "pad".}: array[5, uint8]
    unk_constant* {.importc: "unk_constant".}: uint32
    sensor_res* {.importc: "sensor_res".}: uint8
    pad2* {.importc: "pad2".}: array[3, uint8]

  IrsImageTransferProcessorState* {.importc: "IrsImageTransferProcessorState",
                                   header: headerirs, bycopy.} = object
    unk_x0* {.importc: "unk_x0".}: array[0x00000010, uint8]


proc irsInitialize*(): Result {.cdecl, importc: "irsInitialize", header: headerirs.}
proc irsExit*() {.cdecl, importc: "irsExit", header: headerirs.}
proc irsGetSessionService*(): ptr Service {.cdecl, importc: "irsGetSessionService",
                                        header: headerirs.}
proc irsGetSharedmemAddr*(): pointer {.cdecl, importc: "irsGetSharedmemAddr",
                                    header: headerirs.}
proc irsActivateIrsensor*(activate: bool): Result {.cdecl,
    importc: "irsActivateIrsensor", header: headerirs.}
proc irsGetIrCameraHandle*(IrCameraHandle: ptr uint32; id: HidControllerID): Result {.
    cdecl, importc: "irsGetIrCameraHandle", header: headerirs.}
proc irsRunImageTransferProcessor*(IrCameraHandle: uint32;
                                  config: ptr IrsImageTransferProcessorConfig;
                                  size: csize): Result {.cdecl,
    importc: "irsRunImageTransferProcessor", header: headerirs.}
proc irsGetImageTransferProcessorState*(IrCameraHandle: uint32; buffer: pointer;
                                       size: csize; state: ptr IrsImageTransferProcessorState): Result {.
    cdecl, importc: "irsGetImageTransferProcessorState", header: headerirs.}
proc irsStopImageProcessor*(IrCameraHandle: uint32): Result {.cdecl,
    importc: "irsStopImageProcessor", header: headerirs.}
proc irsSuspendImageProcessor*(IrCameraHandle: uint32): Result {.cdecl,
    importc: "irsSuspendImageProcessor", header: headerirs.}
proc irsGetDefaultImageTransferProcessorConfig*(
    config: ptr IrsImageTransferProcessorConfig) {.cdecl,
    importc: "irsGetDefaultImageTransferProcessorConfig", header: headerirs.}