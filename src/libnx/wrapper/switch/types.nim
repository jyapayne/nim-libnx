## *
##  @file switch/types.h
##  @brief Various system types.
##  @copyright libnx Authors
##
import integer128

when not defined(SSIZE_MAX):
  when defined(SIZE_MAX):
    const
      SSIZE_MAX* = ((size_Max) shr 1)
type
  U8* = uint8
  uintptrT* = culong
  intptrT* = clong

## /<   8-bit unsigned integer.

type
  U16* = uint16
  Ssize_t* = clong

## /<  16-bit unsigned integer.

type
  U32* = uint32

## /<  32-bit unsigned integer.

type
  U64* = uint64

## /<  64-bit unsigned integer.

type
  U128* = u128

## /< 128-bit unsigned integer.

type
  S8* = int8

## /<   8-bit signed integer.

type
  S16* = int16

## /<  16-bit signed integer.

type
  S32* = int32

## /<  32-bit signed integer.

type
  S64* = int64

## /<  64-bit signed integer.

type
  S128* = s128

## /< 128-bit unsigned integer.

type
  Vu8* = U8

## /<   8-bit volatile unsigned integer.

type
  Vu16* = U16

## /<  16-bit volatile unsigned integer.

type
  Vu32* = U32

## /<  32-bit volatile unsigned integer.

type
  Vu64* = U64

## /<  64-bit volatile unsigned integer.

type
  Vu128* = U128

## /< 128-bit volatile unsigned integer.

type
  Vs8* = S8

## /<   8-bit volatile signed integer.

type
  Vs16* = S16

## /<  16-bit volatile signed integer.

type
  Vs32* = S32

## /<  32-bit volatile signed integer.

type
  Vs64* = S64

## /<  64-bit volatile signed integer.

type
  Vs128* = S128

## /< 128-bit volatile signed integer.

type
  Handle* = U32

## /< Kernel object handle.

type
  Result* = U32

## /< Function error code result type.

type
  ThreadFunc* = proc (a1: pointer) {.cdecl.}

## /< Thread entrypoint function.

type
  VoidFn* = proc () {.cdecl.}

## /< Function without arguments nor return value.

type
  Uuid* {.importc: "Uuid", header: "types.h", bycopy.} = object
    uuid* {.importc: "uuid".}: array[0x10, U8]


## /< Unique identifier.

type
  UtilFloat3* {.importc: "UtilFloat3", header: "types.h", bycopy.} = object
    value* {.importc: "value".}: array[3, cfloat]


## /< 3 floats.
## / Creates a bitmask from a bit number.

template bit*(n: untyped): untyped =
  (1'u32 shl (n).int)

template bitl*(n: untyped): untyped =
  (1'u64 shl (n).int)

const INVALID_HANDLE* = 0.uint32

template `+`*[T](p: ptr T, off: SomeInteger): ptr T =
  cast[ptr type(p[])](cast[ByteAddress](p) +% (off * (off.type)sizeof(p[])).int64)

template `+=`*[T](p: ptr T, off: SomeInteger) =
  p = p + off

template `-`*[T](p: ptr T, off: SomeInteger): ptr T =
  cast[ptr type(p[])](cast[ByteAddress](p) -% (off * (off.type)sizeof(p[])).int64)

template `-=`*[T](p: ptr T, off: SomeInteger) =
  p = p - off

template `[]`*[T](p: ptr T, off: SomeInteger): T =
  (p + off)[]

template `[]=`*[T](p: ptr T, off: SomeInteger, val: T) =
  (p + off)[] = val
