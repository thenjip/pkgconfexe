import std/[ strformat, sugar, typetraits ]



type
  InvalidAccessError* = object of Defect

  ParseResult* [T] = object
    n: Natural ## The number of units (chars, bytes, Rune, ...) parsed.
    when T isnot string | cstring:
      val: T



func some* [T: string | cstring](n: Natural): ParseResult[T] {. locks: 0 .} =
  result = ParseResult[T](n: n)


func some* [T: not string | cstring](n: Natural; val: T): ParseResult[T] {.
  locks: 0
.} =
  result = ParseResult[T](n: n, val: val)



func none* [T](): ParseResult[T] {. locks: 0 .} =
  result =
    when T is string | cstring:
      ParseResult[T](n: 0)
    else:
      ParseResult[T](n: 0, val: T.default())



func isSome* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.n > 0


func isNone* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.n == 0



## Returns the number of bytes parsed.
func get* [T: string | cstring](self: ParseResult[T]): Natural {. locks: 0 .} =
  result = self.n


func get* [T: not string | cstring](
  self: ParseResult[T]
): tuple[n: Positive, val: T] {.
  locks: 0, raises: [ InvalidAccessError ]
.} =
  result =
    if self.isSome():
      (n: self.n, val: self.val)
    else:
      raise newException(InvalidAccessError, $ParseResult & " was 'none'.")



proc ifSome* [T: string | cstring](
  self: ParseResult[T]; callback: (n: Positive) -> void
) =
  if self.isSome():
    callback(self.n)


proc ifSome* [T: not string | cstring](
  self: ParseResult[T]; callback: (n: Positive, val: T) -> void
) =
  if self.isSome():
    callback(self.n, self.val)


proc ifSome* [T: not string | cstring](
  self: ParseResult[T]; callback: (tuple[n: Positive, val: T]) -> void
) =
  if self.isSome():
    callback((n: self.n, val: self.val))



func `==`* [T](l, r: ParseResult[T]): bool {. locks: 0 .} =
  result =
    when T is string | cstring:
      l.n == r.n
    else:
      l.n == r.n and l.val == r.val



func `$`* [T](self: ParseResult[T]): string {. locks: 0 .} =
  result =
    if self.isSome():
      when T is string | cstring:
        fmt"[{$T}]({self.n})"
      else:
        fmt"[{$T}]({self.n}, {self.val})"
    else:
      fmt"[{$T}]()"
