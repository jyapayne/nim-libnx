import strutils
# Capacity of 42 because it seems
# reasonable that the number will fit.
# If it doesn't, nim will just allocate
# more memory for us anyway
const STRING_CAPACITY = 42

type
  s128* {.importc: "__int128_t"} = object
    high: int64
    low: uint64

  u128* {.importc: "__uint128_t"} = object
    high, low: uint64

  helperInt128 = object
    hi: int64
    lo: uint64

  helperUInt128 = object
    hi: uint64
    lo: uint64

proc toHelper(val: s128): helperInt128 =
  (cast[ptr helperInt128](unsafeAddr val))[]

proc lo*(val: s128): uint64 =
  val.toHelper().lo

proc hi*(val: s128): int64 =
  val.toHelper().hi

proc toInt128(val: helperInt128): s128 =
  (cast[ptr s128](unsafeAddr val))[]

proc toHelper(val: u128): helperUInt128 =
  (cast[ptr helperUInt128](unsafeAddr val))[]

proc lo*(val: u128): uint64 =
  val.toHelper().lo

proc hi*(val: u128): uint64 =
  val.toHelper().hi

proc toUInt128(val: helperUInt128): u128 =
  (cast[ptr u128](unsafeAddr val))[]

proc newInt128*(hi: int64, lo: uint64): s128 =
  let r = helperInt128(hi: hi, lo: lo)
  return r.toInt128()

proc newUInt128*(hi: uint64, lo: uint64): u128 =
  let r = helperUInt128(hi: hi, lo: lo)
  return r.toUInt128()

proc toUInt128(val: s128): u128 =
  newUInt128(val.hi.uint64, val.lo)

converter intToInt128*(val: int): s128 =
  newInt128(0, val.uint64)

converter intToUInt128*(val: int): u128 =
  newUInt128(0, val.uint64)

proc `<`*(val1: u128, val2: u128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  if (lhs.hi < rhs.hi):
    return true
  if (rhs.hi < lhs.hi):
    return false
  if (lhs.lo < rhs.lo):
    return true
  return false

proc `<`*(val1: s128, val2: s128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  if (lhs.hi < rhs.hi):
    return true
  if (rhs.hi < lhs.hi):
    return false
  if (lhs.lo < rhs.lo):
    return true
  return false

proc `>=`*(val1: s128, val2: s128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  if lhs.hi == rhs.hi and lhs.lo == rhs.lo:
    return true

  if lhs.hi > rhs.hi:
    return true
  if rhs.hi > lhs.hi:
    return false

  if lhs.lo > rhs.lo:
    return true
  return false

proc `>=`*(val1: u128, val2: u128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  if lhs.hi == rhs.hi and lhs.lo == rhs.lo:
    return true

  if lhs.hi > rhs.hi:
    return true
  if rhs.hi > lhs.hi:
    return false

  if lhs.lo > rhs.lo:
    return true
  return false

proc `>`*(val1: s128, val2: s128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  if (lhs.hi < rhs.hi):
    return true
  if (rhs.hi < lhs.hi):
    return false
  if (lhs.lo < rhs.lo):
    return true
  return false

proc `>`*(val1: u128, val2: u128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  if (lhs.hi < rhs.hi):
    return true
  if (rhs.hi < lhs.hi):
    return false
  if (lhs.lo < rhs.lo):
    return true
  return false

proc `<=`*(val1: s128, val2: s128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  if lhs.hi == rhs.hi and lhs.lo == rhs.lo:
    return true

  if lhs.hi < rhs.hi:
    return true
  if rhs.hi < lhs.hi:
    return false
  if lhs.lo < rhs.lo:
    return true
  return false

proc `<=`*(val1: u128, val2: u128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  if lhs.hi == rhs.hi and lhs.lo == rhs.lo:
    return true

  if lhs.hi < rhs.hi:
    return true
  if rhs.hi < lhs.hi:
    return false
  if lhs.lo < rhs.lo:
    return true
  return false

proc `!=`*(val1: s128, val2: s128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()
  return (lhs.hi != rhs.hi) or (lhs.lo != rhs.lo)

proc `!=`*(val1: u128, val2: u128): bool =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()
  return (lhs.hi != rhs.hi) or (lhs.lo != rhs.lo)

proc `==`*(val1: s128, val2: s128): bool =
  let lhs = val1.tohelper()
  let rhs = val2.tohelper()
  if lhs.hi != rhs.hi:
    return false
  if lhs.lo != rhs.lo:
    return false
  return true

proc `==`*(val1: u128, val2: u128): bool =
  let lhs = val1.tohelper()
  let rhs = val2.tohelper()
  if lhs.hi != rhs.hi:
    return false
  if lhs.lo != rhs.lo:
    return false
  return true

proc `+`*(val1, val2: s128): s128 =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  var res = result.toHelper()

  res.hi = lhs.hi + rhs.hi

  res.lo = lhs.lo + rhs.lo
  if res.lo < rhs.lo:
    res.hi.inc()
  result = res.toInt128()

proc `+`*(val1, val2: u128): u128 =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  var res = result.toHelper()

  res.hi = lhs.hi + rhs.hi

  res.lo = lhs.lo + rhs.lo
  if res.lo < rhs.lo:
    res.hi.inc()
  result = res.toUInt128()

proc `-`*(val: s128): s128 =
  var res = val.toHelper()
  res.hi = not res.hi
  res.lo = not res.lo
  res.lo += 1
  if res.lo == 0:
    res.hi += 1

  result = res.toInt128()

proc `-`*(val: u128): s128 =
  var res = newInt128(val.hi.int64, val.lo).toHelper()

  res.hi = not res.hi
  res.lo = not res.lo
  res.lo += 1
  if res.lo == 0:
    res.hi += 1

  result = res.toInt128()

proc `-`*(val1, val2: s128): s128 =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  var res = result.toHelper()

  res.hi = lhs.hi - rhs.hi
  res.lo = lhs.lo - rhs.lo
  if res.lo > lhs.lo:
    res.hi.dec()

  result = res.toInt128()

proc `-`*(val1, val2: u128): s128 =
  let lhs = val1.toHelper()
  let rhs = val2.toHelper()

  var res = result.toHelper()

  res.hi = (lhs.hi - rhs.hi).int64
  res.lo = lhs.lo - rhs.lo
  if res.lo > lhs.lo:
    res.hi.dec()

  result = res.toInt128()

proc `$`*(val: s128): string =
  var v = val

  if v == 0:
    return "0"

  var str = newStringOfCap(STRING_CAPACITY)

  var
    p10 = 1.s128
    temp: s128
    num_digits = 0
    going = 1
    digit = 0

  if v < 0:
    str.add('-')
    v = -v

  while (p10 <= v and going > 0):
    p10 = p10 + p10
    if p10 < 0:
      going = 0
    temp = p10
    p10 = p10 + p10
    if p10 < 0:
      going = 0
    p10 = p10 + p10
    if p10 < 0:
      going = 0
    p10 = p10 + temp
    if p10 < 0:
      going = 0
    num_digits.inc

  while num_digits > 0:
    num_digits -= 1
    p10 = 1
    for i in 0..<num_digits:
      p10 = p10 + p10
      temp = p10
      p10 = p10 + p10
      p10 = p10 + p10
      p10 = p10 + temp
    digit = 0

    while(v >= p10):
      v = v - p10
      digit.inc
    str.add(char(48 + digit))

  result = str

proc toHex*(val: u128): string =
  result = val.hi.toHex & val.lo.toHex

proc `$`*(val: u128): string =
  var v = val

  if v == 0:
    return "0"

  var str = newStringOfCap(STRING_CAPACITY)

  var
    p10 = 1.u128
    temp: u128
    num_digits = 0
    going = 1
    digit = 0

  while (p10 <= v and going > 0):
    p10 = p10 + p10
    if p10 < 0:
      going = 0
    temp = p10
    p10 = p10 + p10
    if p10 < 0:
      going = 0
    p10 = p10 + p10
    if p10 < 0:
      going = 0
    p10 = p10 + temp
    if p10 < 0:
      going = 0
    num_digits.inc

  while num_digits > 0:
    num_digits -= 1
    p10 = 1
    for i in 0..<num_digits:
      p10 = p10 + p10
      temp = p10
      p10 = p10 + p10
      p10 = p10 + p10
      p10 = p10 + temp
    digit = 0

    while(v >= p10):
      v = (v - p10).toUInt128()
      digit.inc
    str.add(char(48 + digit))

  result = str

