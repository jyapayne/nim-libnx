import macros, strutils, math

proc size*(enumTy: typedesc): int =
  # Returns the number of items in a bit set enum
  log2(float64(enumTy.high)).int + 1

template recursive(node, action: untyped): untyped {.dirty.} =
  ## recursively iterate over AST nodes and perform an
  ## action on them
  proc helper(child: NimNode): NimNode {.gensym.}=
    action
    result = child.copy()
    for c in child.children:
      if child.kind == nnkCall and c.kind == nnkDotExpr:
        # ignore dot expressions that are also calls
        continue
      result.add helper(c)
  discard helper(node)

macro niceify*(enumType: typed, replaceNameField: string): untyped =
  ##
  ## niceify(HidMouseButton, "Hid:MOUSE_") transforms this:
  ##
  ## HidMouseButton* {.size: sizeof(cint)} = enum
  ##   MOUSE_LEFT = BIT(0), MOUSE_RIGHT = BIT(1), MOUSE_MIDDLE = BIT(2),
  ##   MOUSE_FORWARD = BIT(3), MOUSE_BACK = BIT(4)
  ##
  ## into this:
  ##
  ## MouseButton {.size: 4, pure.} = enum
  ##   Left = MOUSE_LEFT, Right = MOUSE_RIGHT, Middle = MOUSE_MIDDLE,
  ##   Forward = MOUSE_FORWARD,
  ##   Back = MOUSE_BACK
  ##
  ## If any fields begin with a number, the first letter of the name after
  ## the colon will be used in addition. (128 -> M128 in this case)

  let replaceSplit = replaceNameField.strVal.split(":")
  var
    replaceName: string
    replaceField: string
    replaceNameWith = ""
    replaceFieldWith = ""

  if replaceSplit.len == 2:
    replaceName = replaceSplit[0]
    replaceField = replaceSplit[1]
  else:
    replaceName = replaceSplit[0]
    replaceNameWith = replaceSplit[1]
    replaceField = replaceSplit[2]
    replaceFieldWith = replaceSplit[3]

  var node = enumType.getImpl().copy()
  recursive(node):
    if child.kind == nnkPragmaExpr:
      child[0] = postFix(
        ident(child[0].strVal.replace($replaceName, replaceNameWith)),
        "*"
      )

    if child.kind == nnkPragma:
      child.add(ident("pure"))

    if child.kind == nnkEnumFieldDef:
      let
        lhs = child[0]
        rhs = child[1]
        name = lhs.strVal
      var
        newName = name.replace($replaceField, replaceFieldWith)
                  .normalize().capitalizeAscii()
        firstChar = newName[0]

      if firstChar in Digits:
        newName = replaceField[0] & newName

      child[0] = ident(newName)
      child[1] = ident(name)

  return newNimNode(nnkTypeSection).add(node)

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
