import indexslice

import std/[ options, strformat, typetraits ]



type
  NoValueError* = object of Defect

  ParseResult* [T] = object
    bounds: IndexSlice[Natural] ## The bounds of the parsed input.
    when T isnot string:
      val: T



func emptySlice* [I: SomeIndexInteger](): Slice[I] {. locks: 0 .} =
  result = 0.I .. 0.I



func buildParseResult* [T: string](
  bounds: IndexSlice[Natural]
): ParseResult[T] {. locks: 0 .} =
  result =
    if bounds.isEmpty():
      T.emptyParseResult()
    else:
      bounds.someParseResult()



func someParseResult* [T: string](
  bounds: NonEmptyIndexSlice[Natural]
): ParseResult[T] {. locks: 0 .} =
  result = ParseResult[T](bounds: bounds)


func someParseResult* [T: not string](
  val: T; bounds: NonEmptyIndexSlice[Natural]
): ParseResult[T] {. locks: 0 .} =
  result = ParseResult[T](bounds: bounds, val: val)



func emptyParseResult* (T: typedesc): ParseResult[T] {. locks: 0 .} =
  result =
    when T is string:
      ParseResult[T](bounds: Natural.emptySlice())
    else:
      ParseResult[T](bounds: Natural.emptySlice(), val: T.default())



func isSome* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.bounds of NonEmptyIndexSlice[Natural]


func isNone* [T](self: ParseResult[T]): bool {. locks: 0 .} =
  result = self.bounds.isEmpty()



func get* [T: string](self: ParseResult[T]): NonEmptyIndexSlice[Natural] {.
  locks: 0, raises: [ NoValueError ]
.} =
  result =
    if self.isSome():
      self.bounds
    else:
      raise newException(NoValueError, "")


func get* [T: not string](
  self: ParseResult[T]
): (val: T, bounds: NonEmptyIndexSlice[Natural]) {. locks: 0 .} =
  result =
    if self.isSome():
      (self.val, self.bounds)
    else:
      raise newException(NoValueError, "")



proc doIfSome* [T: string](
  self: ParseResult[T]; callback: proc (bounds: NonEmptyIndexSlice[Natural])
) =
  if self.isSome():
    callback(self.bounds)


proc doIfSome* [T: not string](
  self: ParseResult[T];
  callback: proc (val: T; bounds: NonEmptyIndexSlice[Natural])
) =
  if self.isSome():
    callback(self.val, self.bounds)



func flatMapOr* [T: string, R](
  self: ParseResult[T];
  f: func (bounds: NonEmptyIndexSlice[Natural]): ParseResult[R];
  otherwise: ParseResult[R]
): ParseResult[R] =
  result =
    if self.isSome():
      f(self.bounds)
    else:
      otherwise


func flatMapOr* [T: not string, R](
  self: ParseResult[T];
  f: func (val: T; bounds: NonEmptyIndexSlice[Natural]): ParseResult[R];
  otherwise: ParseResult[R]
): ParseResult[R] =
  result =
    if self.isSome():
      f(self.val, self.bounds)
    else:
      otherwise



func flatMap* [T: string, R](
  self: ParseResult[T];
  f: func (bounds: NonEmptyIndexSlice[Natural]): ParseResult[R]
): ParseResult[R] =
  result = self.flatMapOr(f, R.none())


func flatMap* [T: not string, R](
  self: ParseResult[T];
  f: func (val: T; bounds: NonEmptyIndexSlice[Natural]): ParseResult[R]
): ParseResult[R] =
  result = self.flatMapOr(f, R.none())



func optionToParseResult* [T](
  opt: Option[T]; bounds: NonEmptyIndexSlice[Natural]
): ParseResult[T] {. locks: 0 .} =
  result =
    if opt.isSome():
      when T is string:
        bounds.someParseResult()
      else:
        opt.unsafeGet().someParseResult(bounds)
    else:
      T.emptyParseResult()



func membersToString [T](self: ParseResult[T]): string {. locks: 0 .} =
  result =
    if self.isSome():
      when T is string:
        $self.bounds
      else:
        fmt"{self.bounds}, {self.val}"
    else:
      ""


func `$`* [T](self: ParseResult[T]): string {. locks: 0 .} =
  result = fmt"[{T}]({self.membersToString()})"



static:
  doAssert(emptySlice[Natural]().isEmpty())
