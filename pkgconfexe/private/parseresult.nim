import std/[ strformat, sugar, typetraits ]



type
  InvalidAccessError* = object of Defect

  ParseResult* [T] = object
    n: Natural ## The number of units (chars, bytes, Rune, ...) parsed.
    when T isnot string:
      val: T



func some* (n: Natural): ParseResult[string] {. locks: 0 .} =
  result = ParseResult[string](n: n)


func some* [T: not string](val: T; n: Positive): ParseResult[T] {.
  locks: 0
.} =
  result = ParseResult[T](n: n, val: val)



func none* (T: typedesc): ParseResult[T] {. locks: 0 .} =
  result =
    when T is string:
      ParseResult[T](n: Natural.low())
    else:
      ParseResult[T](n: Natural.low(), val: T.default())



func isSome* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.n > 0


func isNone* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.n == 0



proc doIfSome* [T: string](
  self: ParseResult[T]; callback: (n: Positive) -> void
) =
  if self.isSome():
    callback(self.n)


proc doIfSome* [T: not string](
  self: ParseResult[T]; callback: (val: T, n: Positive) -> void
) =
  if self.isSome():
    callback(self.val, self.n)


proc doIfSome* [T: not string](
  self: ParseResult[T]; callback: (tuple[val: T, n: Positive]) -> void
) =
  if self.isSome():
    callback((val: self.val, n: self.n))



func `==`* [T](l, r: ParseResult[T]): bool {. locks: 0 .} =
  result =
    when T is string:
      l.n == r.n
    else:
      l.n == r.n and l.val == r.val



func `$`* [T](self: ParseResult[T]): string {. locks: 0 .} =
  result =
    if self.isSome():
      when T is string:
        fmt"[{$T}]({self.n})"
      else:
        fmt"[{$T}]({self.n}, {self.val})"
    else:
      fmt"[{$T}]()"
