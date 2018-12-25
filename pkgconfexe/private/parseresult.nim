import std/typetraits



type
  InvalidAccessError* = object of Defect

  ParseResult* [T] = object
    nParsed: csize
    when T isnot string | cstring:
      val: T



func some* [T: string | cstring](nParsed: csize): ParseResult[T] {.
  locks: 0
.} =
  result = ParseResult[T](nParsed: nParsed)


func some* [T: not string | cstring](nParsed: csize; val: T): ParseResult[T] {.
  locks: 0
.} =
  result = ParseResult[T](nParsed: nParsed, val: val)



func none* [T](): ParseResult[T] {. locks: 0 .} =
  result =
    when T is string | cstring:
      ParseResult[T](nParsed: 0)
    else:
      ParseResult[T](nParsed: 0, val: T.default())



func isSome* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.nParsed > 0


func isNone* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.nParsed == 0



func get* [T: string | cstring](self: ParseResult[T]): csize {. locks: 0 .} =
  result = self.nParsed


func get* [T: not string | cstring](self: ParseResult[T]): T {.
  locks: 0, raises: [ InvalidAccessError ]
.} =
  result =
    if self.isSome():
      self.val
    else:
      raise newException(InvalidAccessError, $ParseResult & " was 'none'.")
