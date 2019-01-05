import optional, seqindexslice

import std/[ strformat ]


export optional



type ScanResult* [T] = object
  start: Natural ## The index where scanning starts.
  n: Positive ## The number of matching units (chars, bytes, ...).
  when T isnot string:
    val: T



func someScanResult* (
  start: Natural; n: Positive
): Optional[ScanResult[string]] =
  ScanResult[string](start: start, n: n).some()


func someScanResult* [T: not string](
  start: Natural; n: Positive; val: T
): Optional[ScanResult[T]] =
  ScanResult[T](start: start, n: n, val: val).some()



func emptyScanResult* [T](): Optional[ScanResult[T]] =
  ScanResult[T].none()


func emptyScanResult* (T: typedesc): Optional[ScanResult[T]] =
  emptyScanResult[T]()



func buildScanResult* (
  start: Natural; n: Natural
): Optional[ScanResult[string]] =
  if n == Natural.low():
    string.emptyScanResult()
  else:
    someScanResult(start, n.Positive)



func checkVal [T](l, r: ScanResult[T]): bool =
  when T is string:
    true
  else:
    l.val == r.val


func `==`* [T](l, r: ScanResult[T]): bool =
  l.start == r.start and l.n == r.n and checkVal(l, r)


func `!=`* [T](l, r: ScanResult[T]): bool =
  not (l == r)



func slice* [T](self: ScanResult[T]): SeqIndexSlice =
  self.start .. Natural(self.start + self.n - 1)


func value* [T: not string](self: ScanResult[T]): T =
  self.val


func sliceAndVal* [T: not string](
  self: ScanResult[T]
): tuple[slice: SeqIndexSlice, val: T] =
  (self.slice(), self.value())



func toOptionalScanResult* [T: not string](
  o: Optional[T]; start: Natural; n: Positive
): Optional[ScanResult[T]] =
  o.flatMap(
    func (val: T): Optional[ScanResult[T]] =
      someScanResult(start, n, val)
  )



func flatMapOr* [R](
  o: Optional[ScanResult[string]];
  otherwise: Optional[ScanResult[R]];
  f: func (slice: SeqIndexSlice): Optional[ScanResult[R]]
): Optional[ScanResult[R]] =
  o.flatMapOr(
    otherwise,
    func (sr: ScanResult[string]): Optional[ScanResult[R]] =
      f(sr.slice())
  )


func flatMapOr* [T: not string, R](
  o: Optional[ScanResult[T]];
  otherwise: Optional[ScanResult[R]];
  f: func (slice: SeqIndexSlice; val: T): Optional[ScanResult[R]]
): Optional[ScanResult[R]] =
  o.flatMapOr(
    otherwise,
    func (sr: ScanResult[T]): Optional[ScanResult[R]] =
      f(sr.slice(), sr.value())
  )



func flatMap* [R](
  o: Optional[ScanResult[string]];
  f: func (slice: SeqIndexSlice): Optional[ScanResult[R]]
): Optional[ScanResult[R]] =
  o.flatMapOr(ScanResult[R].none(), f)


func flatMap* [T: not string, R](
  o: Optional[ScanResult[T]];
  f: func (slice: SeqIndexSlice; val: T): Optional[ScanResult[R]]
): Optional[ScanResult[R]] =
  o.flatMapOr(ScanResult[R].none(), f)



func valueToString [T](self: ScanResult[T]): string =
  when T is string:
    ""
  else:
    fmt", val: {self.value()}"


func `$`* [T](self: ScanResult[T]): string =
  fmt"(slice: {self.slice()}" & self.valueToString() & ')'
