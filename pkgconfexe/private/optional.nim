import std/[ strformat, sugar, typetraits ]



type
  NoValueError* = object of Defect

  Optional* [T] = object
    case empty: bool
      of true:
        discard
      of false:
        val: T



func some* [T](val: T): Optional[T] {. locks: 0 .} =
  Optional[T](empty: false, val: val)


func none* [T](): Optional[T] {. locks: 0 .} =
  Optional[T](empty: true)


func none* (T: typedesc): Optional[T] {. locks: 0 .} =
  none[T]()



func isSome* [T](self: Optional[T]): bool {. locks: 0 .} =
  not self.empty


func isNone* [T](self: Optional[T]): bool {. locks: 0 .} =
  self.empty



func valToString [T](self: Optional[T]): string {. locks: 0 .} =
  if self.isSome():
    fmt"val: {self.val}"
  else:
    ""


func `$`* [T](self: Optional[T]): string {. locks: 0 .} =
  fmt"[{T}](" & self.valToString() & ")"



func get* [T](self: Optional[T]): T {. locks: 0, raises: [ NoValueError ] .} =
  if self.isSome():
    self.val
  else:
    raise newException(NoValueError, $self)



proc doIfSome* [T, R](self: Optional[T]; callback: (val: T) -> void) =
  if self.isSome():
    callback(self.val)



func flatMapOr* [T, R](
  self: Optional[T];
  otherwise: Optional[R];
  f: func (val: T): Optional[R] {. locks: 0 .}
): Optional[R] {. locks: 0 .} =
  if self.isSome():
    f(self.val)
  else:
    otherwise



func flatMap* [T, R](
  self: Optional[T]; f: func (val: T): Optional[R] {. locks: 0 .}
): Optional[R] {. locks: 0 .} =
  self.flatMapOr(R.none(), f)
