import std/[ strformat, sugar, typetraits ]



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



func some* [T](val: T): Optional[T] =
  Optional[T](hasValue: true, val: val)


func none* [T](): Optional[T] =
  Optional[T](hasValue: false)


func none* (T: typedesc): Optional[T] =
  none[T]()



func isSome* [T](self: Optional[T]): bool =
  self.hasValue


func isNone* [T](self: Optional[T]): bool =
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



func ifSome* [T, R](self: Optional[T]; someVal, noneVal: R): R =
  if self.isSome():
    someVal
  else:
    noneVal


func ifSome* [T, R](self: Optional[T]; f: func (val: T): R; otherwise: R): R =
  if self.isSome():
    f(self.val)
  else:
    otherwise


func ifSome* [T, R](self: Optional[T]; otherwise: R; f: func (val: T): R): R =
  self.ifSome(f, otherwise)


func ifSome* [T, R](
  self: Optional[T]; someFunc: func (val: T): R; noneFunc: func (): R
): R =
  if self.isSome():
    someFunc(self.val)
  else:
    noneFunc()



func `==`* [T](l, r: Optional[T]): bool =
  l.ifSome(
    (lVal: T) => r.ifSome((rVal: T) => lVal == rVal, false),
    () => r.isNone()
  )


func `!=`* [T](l, r: Optional[T]): bool =
  not (l == r)



func flatMapOr* [T, R](
  self: Optional[T]; f: func (val: T): Optional[R]; otherwise: Optional[R]
): Optional[R] =
  self.ifSome(f, otherwise)


func flatMapOr* [T, R](
  self: Optional[T]; otherwise: Optional[R]; f: func (val: T): Optional[R]
): Optional[R] =
  self.flatMapOr(f, otherwise)



func flatMap* [T, R](
  self: Optional[T]; f: func (val: T): Optional[R]
): Optional[R] =
  self.flatMapOr(f, R.none())



func valToString [T](self: Optional[T]): string =
  self.ifSome(fmt"val: {self.val}", "")


func `$`* [T](self: Optional[T]): string =
  fmt"[{T}](" & self.valToString() & ')'



func get* [T](self: Optional[T]): T {. raises: [ NoValueError ] .} =
  if self.isSome():
    self.val
  else:
    raise newException(NoValueError, "type: " & $T)
