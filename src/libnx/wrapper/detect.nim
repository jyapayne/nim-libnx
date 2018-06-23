import strutils
import ospaths
const headerdetect = currentSourcePath().splitPath().head & "/nx/include/switch/kernel/detect.h"
import libnx/wrapper/types
proc kernelAbove200*(): bool {.cdecl, importc: "kernelAbove200",
                             header: headerdetect.}
proc kernelAbove300*(): bool {.cdecl, importc: "kernelAbove300",
                             header: headerdetect.}
proc kernelAbove400*(): bool {.cdecl, importc: "kernelAbove400",
                             header: headerdetect.}
proc kernelAbove500*(): bool {.cdecl, importc: "kernelAbove500",
                             header: headerdetect.}
proc detectDebugger*(): bool {.cdecl, importc: "detectDebugger",
                             header: headerdetect.}