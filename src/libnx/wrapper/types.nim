import strutils
import ospaths
const headertypes = currentSourcePath().splitPath().head & "/nx/include/switch/types.h"
include libnx/ext/integer128
template BIT*(n): auto = (1.uint shl n)
type
  u8* = uint8
  u16* = uint16
  u32* = uint32
  u64* = uint64
  int8_t* = int8
  int16_t* = int16
  int32_t* = int32
  int64_t* = int64
  ssize_t* = int
  uint8_t* = uint8
  uint16_t* = uint16
  uint32_t* = uint32
  uint64_t* = uint64

  s8* = int8_t
  s16* = int16_t
  s32* = int32_t
  s64* = int64_t

  vuint8* = uint8
  vuint16* = uint16
  vuint32* = uint32
  vuint64* = uint64
  vu128* = u128
  vs8* = s8
  vs16* = s16
  vs32* = s32
  vs64* = s64
  vs128* = s128
  Handle* = uint32
  Result* = uint32
  ThreadFunc* = proc (a2: pointer) {.cdecl.}
  VoidFn* = proc () {.cdecl.}
