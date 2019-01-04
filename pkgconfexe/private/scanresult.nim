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
): Optional[ScanResult[string]] {. locks: 0 .} =
  ScanResult[string](start: start, n: n).some()


func someScanResult* [T: not string](
  start: Natural; n: Positive; val: T
): Optional[ScanResult[T]] {. locks: 0 .} =
  ScanResult[T](start: start, n: n, val: val).some()



func emptyScanResult* [T](): Optional[ScanResult[T]] {. locks: 0 .} =
  ScanResult[T].none()


func emptyScanResult* (T: typedesc): Optional[ScanResult[T]] {. locks: 0 .} =
  emptyScanResult[T]()



func buildScanResult* (
  start: Natural; n: Natural
): Optional[ScanResult[string]] {. locks: 0 .} =
  if n == Natural.low():
    string.emptyScanResult()
  else:
    someScanResult(start, n.Positive)



func checkVal [T](l, r: ScanResult[T]): bool {. locks: 0 .} =
  when T is string:
    true
  else:
    l.val == r.val


func `==`* [T](l, r: ScanResult[T]): bool {. locks: 0 .} =
  l.start == r.start and l.n == r.n and checkVal(l, r)


func `!=`* [T](l, r: ScanResult[T]): bool {. locks: 0 .} =
  not (l == r)



func slice* [T](self: ScanResult[T]): SeqIndexSlice {. locks: 0 .} =
  self.start .. Natural(self.start + self.n - 1)


func value* [T: not string](self: ScanResult[T]): T {. locks: 0 .} =
  self.val


func sliceAndVal* [T: not string](
  self: ScanResult[T]
): tuple[slice: SeqIndexSlice, val: T] {. locks: 0 .} =
  (self.slice(), self.value())



func toOptionalScanResult* [T: not string](
  o: Optional[T]; start: Natural; n: Positive
): Optional[ScanResult[T]] {. locks: 0 .} =
  o.flatMap(
    func (val: T): Optional[ScanResult[T]] {. locks: 0 .} =
      someScanResult(start, n, val)
  )



func flatMapOr* [R](
  o: Optional[ScanResult[string]];
  otherwise: Optional[ScanResult[R]];
  f: func (slice: SeqIndexSlice): Optional[ScanResult[R]] {. locks: 0 .}
): Optional[ScanResult[R]] {. locks: 0 .} =
  o.flatMapOr(
    otherwise,
    func (sr: ScanResult[string]): Optional[ScanResult[R]] {. locks: 0 .} =
      f(sr.slice())
  )


func flatMapOr* [T: not string, R](
  o: Optional[ScanResult[T]];
  otherwise: Optional[ScanResult[R]];
  f: func (slice: SeqIndexSlice; val: T): Optional[ScanResult[R]] {. locks: 0 .}
): Optional[ScanResult[R]] {. locks: 0 .} =
  o.flatMapOr(
    otherwise,
    func (sr: ScanResult[T]): Optional[ScanResult[R]] {. locks: 0 .} =
      f(sr.slice(), sr.value())
  )



func flatMap* [R](
  o: Optional[ScanResult[string]];
  f: func (slice: SeqIndexSlice): Optional[ScanResult[R]] {. locks: 0 .}
): Optional[ScanResult[R]] {. locks: 0 .} =
  o.flatMapOr(ScanResult[R].none(), f)


func flatMap* [T: not string, R](
  o: Optional[ScanResult[T]];
  f: func (slice: SeqIndexSlice; val: T): Optional[ScanResult[R]] {. locks: 0 .}
): Optional[ScanResult[R]] {. locks: 0 .} =
  o.flatMapOr(ScanResult[R].none(), f)



func valueToString [T](self: ScanResult[T]): string {. locks: 0 .} =
  when T is string:
    ""
  else:
    fmt", val: {self.value()}"


func `$`* [T](self: ScanResult[T]): string {. locks: 0 .} =
  fmt"(slice: {self.slice()}" & self.valueToString() & ')'
