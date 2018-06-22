import strutils
import ospaths
const headerutf = currentSourcePath().splitPath().head & "/nx/include/switch/runtime/util/utf.h"
import libnx/types
proc decode_utf8*(`out`: ptr uint32_t; `in`: ptr uint8_t): ssize_t {.cdecl,
    importc: "decode_utf8", header: headerutf.}
proc decode_utf16*(`out`: ptr uint32_t; `in`: ptr uint16_t): ssize_t {.cdecl,
    importc: "decode_utf16", header: headerutf.}
proc encode_utf8*(`out`: ptr uint8_t; `in`: uint32_t): ssize_t {.cdecl,
    importc: "encode_utf8", header: headerutf.}
proc encode_utf16*(`out`: ptr uint16_t; `in`: uint32_t): ssize_t {.cdecl,
    importc: "encode_utf16", header: headerutf.}
proc utf8_to_utf16*(`out`: ptr uint16_t; `in`: ptr uint8_t; len: csize): ssize_t {.
    cdecl, importc: "utf8_to_utf16", header: headerutf.}
proc utf8_to_utf32*(`out`: ptr uint32_t; `in`: ptr uint8_t; len: csize): ssize_t {.
    cdecl, importc: "utf8_to_utf32", header: headerutf.}
proc utf16_to_utf8*(`out`: ptr uint8_t; `in`: ptr uint16_t; len: csize): ssize_t {.
    cdecl, importc: "utf16_to_utf8", header: headerutf.}
proc utf16_to_utf32*(`out`: ptr uint32_t; `in`: ptr uint16_t; len: csize): ssize_t {.
    cdecl, importc: "utf16_to_utf32", header: headerutf.}
proc utf32_to_utf8*(`out`: ptr uint8_t; `in`: ptr uint32_t; len: csize): ssize_t {.
    cdecl, importc: "utf32_to_utf8", header: headerutf.}
proc utf32_to_utf16*(`out`: ptr uint16_t; `in`: ptr uint32_t; len: csize): ssize_t {.
    cdecl, importc: "utf32_to_utf16", header: headerutf.}