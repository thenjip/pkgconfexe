import std/[ options, strformat, typetraits ]



type
  NoValueError* = object of Defect

  SeqIndexSlice* = Slice[Natural]

  ScanResult* [T] = object
    start: Natural
    n: Natural
    when T isnot string:
      val: T



func buildScanResult* (start, n: Natural): ScanResult[string] {.
  locks: 0
.} =
  result = ScanResult[string](start: start, n: n)



func someScanResult* [T: string](start: Natural; n: Positive): ScanResult[T] {.
  locks: 0
.} =
  result = ScanResult[T](start: start, n: n)


func someScanResult* [T: not string](
  val: T; start: Natural; n: Positive
): ScanResult[T] {. locks: 0 .} =
  result = ScanResult[T](val: val, start: start, n: n)



func emptyScanResult* (T: typedesc): ScanResult[T] {. locks: 0 .} =
  result = ScanResult[T](start: 0, n: 0)



func isSome* [T](self: ScanResult[T]): bool {. locks: 0 .} =
  result = self.n > 0


func isEmpty* [T](self: ScanResult[T]): bool {. locks: 0 .} =
  result = self.n == 0



func get* [T: string](
  self: ScanResult[T]
): tuple[start: Natural, n: Positive] {. locks: 0, raises: [ NoValueError ] .} =
  result =
    if self.isSome():
      (self.start, self.n)
    else:
      raise newException(NoValueError, "")


func get* [T: not string](self: ScanResult[T]): T {.
  locks: 0, raises: [ NoValueError ]
.} =
  result =
    if self.isSome():
      self.val
    else:
      raise newException(NoValueError, "")



func getSlice [T](self: ScanResult[T]): SeqIndexSlice {. locks: 0 .} =
  result = self.start .. Natural(self.start + self.n - 1)



proc doIfSome* [T: string](
  self: ScanResult[T]; callback: proc (slice: SeqIndexSlice)
) =
  if self.isSome():
    callback(self.getSlice())


proc doIfSome* [T: not string](
  self: ScanResult[T]; callback: proc (val: T; slice: SeqIndexSlice)
) =
  if self.isSome():
    callback(self.val, self.getSlice())



func flatMapOr* [T: string, R](
  self: ScanResult[T];
  otherwise: ScanResult[R];
  f: func (slice: SeqIndexSlice): ScanResult[R]
): ScanResult[R] =
  result =
    if self.isSome():
      f(self.getSlice())
    else:
      otherwise


func flatMapOr* [T: not string, R](
  self: ScanResult[T];
  otherwise: ScanResult[R];
  f: func (val: T; slice: SeqIndexSlice): ScanResult[R]
): ScanResult[R] =
  result =
    if self.isSome():
      f(self.val, self.getSlice())
    else:
      otherwise



func flatMap* [T: string, R](
  self: ScanResult[T]; f: func (slice: SeqIndexSlice): ScanResult[R]
): ScanResult[R] =
  result = self.flatMapOr(R.emptyScanResult(), f)


func flatMap* [T: not string, R](
  self: ScanResult[T]; f: func (val: T; slice: SeqIndexSlice): ScanResult[R]
): ScanResult[R] =
  result = self.flatMapOr(R.emptyScanResult(), f)



func optionToScanResult* [T](
  opt: Option[T]; start: Natural; n: Positive
): ScanResult[T] {. locks: 0 .} =
  result =
    if opt.isSome():
      when T is string:
        start.someScanResult()
      else:
        opt.unsafeGet().someScanResult(start, n)
    else:
      T.emptyScanResult()



func valueToString [T](self: ScanResult[T]): string {. locks: 0 .} =
  result =
    when T isnot string:
      fmt", val: {self.val}"
    else:
      ""


func membersToString [T](self: ScanResult[T]): string {. locks: 0 .} =
  result =
    if self.isSome():
      fmt"start: {self.start}, n: {self.n}" & valueToString(T)
    else:
      ""


func `$`* [T](self: ScanResult[T]): string {. locks: 0 .} =
  result = fmt"[{T}]({self.membersToString()})"
