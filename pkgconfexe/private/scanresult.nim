import functiontypes, optional, seqindexslice

import std/[ options, strformat, sugar ]


export options



type ScanResult* [T] = object
  start: Natural ## The index where scanning starts.
  n: Positive ## The number of matching units (chars, bytes, ...).
  when T isnot string:
    val: T



func someScanResult* (
  start: Natural; n: Positive
): Option[ScanResult[string]] {. locks: 0 .} =
  ScanResult[string](start: start, n: n).some()


func someScanResult* [T: not string](
  start: Natural; n: Positive; val: T
): Option[ScanResult[T]] {. locks: 0 .} =
  ScanResult[T](start: start, n: n, val: val).some()



func emptyScanResult* [T](): Option[ScanResult[T]] {. locks: 0 .} =
  ScanResult[T].none()


func emptyScanResult* (T: typedesc): Option[ScanResult[T]] {. locks: 0 .} =
  emptyScanResult[T]()



func buildScanResult* (
  start: Natural; n: Natural
): Option[ScanResult[string]] {. locks: 0 .} =
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



func toOptionScanResult* [T: not string](
  o: Option[T]; start: Natural; n: Positive
): Option[ScanResult[T]] {. locks: 0 .} =
  o.flatMap(
    UnaryFunctionClosure(
      (val: T) -> Option[ScanResult[T]] => someScanResult(start, n, val)
    )
  )



func flatMapOr* [R](
  o: Option[ScanResult[string]];
  otherwise: Option[ScanResult[R]];
  f: UnaryFunctionClosure[SeqIndexSlice, Option[ScanResult[R]]]
): Option[ScanResult[R]] {. locks: 0 .} =
  if o.isSome():
    f(o.unsafeGet().slice())
  else:
    otherwise


func flatMapOr* [T: not string, R](
  o: Option[ScanResult[T]];
  otherwise: Option[ScanResult[R]];
  f: BinaryFunctionClosure[SeqIndexSlice, T, Option[ScanResult[R]]]
): Option[ScanResult[R]] {. locks: 0 .} =
  if o.isSome():
    ((sr: ScanResult[T]) -> Option[ScanResult[R]] =>
      f(sr.slice(), sr.value())
    )(o.unsafeGet())
  else:
    otherwise



func flatMap* [R](
  o: Option[ScanResult[string]];
  f: UnaryFunctionClosure[SeqIndexSlice, Option[ScanResult[R]]]
): Option[ScanResult[R]] {. locks: 0 .} =
  o.flatMapOr(ScanResult[R].none(), f)


func flatMap* [T: not string, R](
  o: Option[ScanResult[T]];
  f: BinaryFunctionClosure[SeqIndexSlice, T, Option[ScanResult[R]]]
): Option[ScanResult[R]] {. locks: 0 .} =
  o.flatMapOr(ScanResult[R].none(), f)



func valueToString [T](self: ScanResult[T]): string {. locks: 0 .} =
  when T is string:
    ""
  else:
    fmt", val: {self.value()}"


func `$`* [T](self: ScanResult[T]): string {. locks: 0 .} =
  fmt"(slice: {self.slice()}" & self.valueToString() & ')'
