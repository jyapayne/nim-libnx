

type
  BufferError* = object of Exception
  BufferIndexError* = object of BufferError

  Buffer*[T] = ref object
    len*: int
    data*: ptr UncheckedArray[T]

template raiseEx*(ty: untyped, message: string): untyped =
  raise newException(ty, message)

proc `[]`[T](buff: Buffer[T], index: int): T =
  if index > (buff.len - 1):
    raiseEx(
      BufferIndexError,
    "Index: $# is greater than buffer length: $#!" % [$index, $buff.len]
    )

  result = buff.data[][index]

proc `[]=`[T](buff: Buffer[T], index: int, value: T) =
  if index > (buff.len - 1):
    raiseEx(
      BufferIndexError,
    "Index: $# is greater than buffer length: $#!" % [$index, $buff.len]
    )

  buff.data[][index] = value
