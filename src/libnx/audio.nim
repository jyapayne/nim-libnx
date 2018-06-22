import strutils
import ospaths
const headeraudio = currentSourcePath().splitPath().head & "/nx/include/switch/audio/audio.h"
import libnx/types
type
  PcmFormat* {.size: sizeof(cint).} = enum
    PcmFormat_Invalid = 0, PcmFormat_Int8 = 1, PcmFormat_Int16 = 2, PcmFormat_Int24 = 3,
    PcmFormat_Int32 = 4, PcmFormat_Float = 5, PcmFormat_Adpcm = 6

