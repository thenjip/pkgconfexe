import indexslice

import std/[ strformat, typetraits ]



type ParseResult* [T] = object
  bounds: IndexSlice[Natural] ## The bounds of the parsed input.
  when T isnot string:
    val: T



func some* [T: string](bounds: NonEmptyIndexSlice[Natural]): ParseResult[T] {.
  locks: 0
.} =
  result = ParseResult[T](bounds: bounds)


func some* [T: not string](
  val: T; bounds: NonEmptyIndexSlice[Natural]
): ParseResult[T] {. locks: 0 .} =
  result = ParseResult[T](bounds: bounds, val: val)



func none* (T: typedesc): ParseResult[T] {. locks: 0 .} =
  result =
    when T is string:
      ParseResult[T](bounds: emptySlice())
    else:
      ParseResult[T](bounds: emptySlice(), val: T.default())



func isSome* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.bounds of NonEmptyIndexSlice[Natural]


func isNone* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.bounds.a == self.bounds.b



proc doIfSome* [T: string](
  self: ParseResult[T]; callback: proc (bounds: NonEmptyIndexSlice[Natural])
) =
  if self.isSome():
    callback(self.bounds)


proc doIfSome* [T: not string](
  self: ParseResult[T]; callback: proc (val: T; bounds: IndexSlice[Natural])
) =
  if self.isSome():
    callback(self.val, self.bounds)



func flatMapOr* [T: string, R](
  self: ParseResult[T];
  f: func (bounds: IndexSlice[Natural]): ParseResult[R];
  otherwise: ParseResult[R]
): ParseResult[R] =
  result =
    if self.isSome():
      f(self.bounds)
    else:
      otherwise


func flatMapOr* [T: not string, R](
  self: ParseResult[T];
  f: func (val: T; bounds: IndexSlice[Natural]): ParseResult[R];
  otherwise: ParseResult[R]
): ParseResult[R] =
  result =
    if self.isSome():
      f(self.val, self.bounds)
    else:
      otherwise



func flatMap* [T: string, R](
  self: ParseResult[T]; f: func (bounds: IndexSlice[Natural]): ParseResult[R]
): ParseResult[R] =
  result = self.flatMapOr(f, R.none())


func flatMap* [T: not string, R](
  self: ParseResult[T]; f: func (val: T; bounds: IndexSlice[Natural]): ParseResult[R]
): ParseResult[R] =
  result = self.flatMapOr(f, R.none())



func `$`* [T](self: ParseResult[T]): string {. locks: 0 .} =
  result =
    if self.isSome():
      when T is string:
        fmt"[{T}]({self.bounds})"
      else:
        fmt"[{T}]({self.bounds}, {self.val})"
    else:
      fmt"[{T}]()"



func emptySlice* (I: typedesc[SomeInteger]): Slice[I] {. locks: 0 .} =
  result = 0.I .. 0.I
