import std/[ strformat, typetraits ]



##[
  Basically the same as superfunc's maybe library but without macros.
  https://github.com/superfunc/maybe
]##



type
  NoValueError* = object of Defect

  Optional* [T] = object
    case hasValue: bool
      of false:
        discard
      of true:
        val: T



func some* [T](val: T): Optional[T] {. locks: 0 .} =
  Optional[T](hasValue: true, val: val)


func none* [T](): Optional[T] {. locks: 0 .} =
  Optional[T](hasValue: false)


func none* (T: typedesc): Optional[T] {. locks: 0 .} =
  none[T]()



func isSome* [T](self: Optional[T]): bool {. locks: 0 .} =
  self.hasValue


func isNone* [T](self: Optional[T]): bool {. locks: 0 .} =
  not self.isSome()



proc doIfSome* [T](
  self: Optional[T]; someProc: proc (val: T); noneProc: proc ()
) =
  if self.isSome():
    someProc(self.val)
  else:
    noneProc()


proc doIfSome* [T](self: Optional[T]; someProc: proc (val: T)) =
  self.doIfSome(someProc, proc () = discard)



func ifSome* [T, R](self: Optional[T]; someVal, noneVal: R): R {. locks: 0 .} =
  if self.isSome():
    someVal
  else:
    noneVal


func ifSome* [T, R](
  self: Optional[T]; f: func (val: T): R {. locks: 0 .}; otherwise: R
): R {. locks: 0 .} =
  if self.isSome():
    f(self.val)
  else:
    otherwise


func ifSome* [T, R](
  self: Optional[T]; otherwise: R; f: func (val: T): R {. locks: 0 .}
): R {. locks: 0 .} =
  self.ifSome(f, otherwise)


func ifSome* [T, R](
  self: Optional[T];
  someFunc: func (val: T): R {. locks: 0 .};
  noneFunc: func (): R {. locks: 0 .}
): R {. locks: 0 .} =
  if self.isSome():
    someFunc(self.val)
  else:
    noneFunc()



func flatMapOr* [T, R](
  self: Optional[T];
  f: func (val: T): Optional[R] {. locks: 0 .};
  otherwise: Optional[R]
): Optional[R] {. locks: 0 .} =
  self.ifSome(f, otherwise)


func flatMapOr* [T, R](
  self: Optional[T];
  otherwise: Optional[R];
  f: func (val: T): Optional[R] {. locks: 0 .}
): Optional[R] {. locks: 0 .} =
  self.flatMapOr(f, otherwise)



func flatMap* [T, R](
  self: Optional[T]; f: func (val: T): Optional[R] {. locks: 0 .}
): Optional[R] {. locks: 0 .} =
  self.flatMapOr(f, R.none())



func valToString [T](self: Optional[T]): string {. locks: 0 .} =
  self.ifSome(fmt"val: {self.val}", "")


func `$`* [T](self: Optional[T]): string {. locks: 0 .} =
  fmt"[{T}](" & self.valToString() & ')'



func get* [T](self: Optional[T]): T {. locks: 0, raises: [ NoValueError ] .} =
  if self.isSome():
    self.val
  else:
    raise newException(NoValueError, fmt"type: {T}")
