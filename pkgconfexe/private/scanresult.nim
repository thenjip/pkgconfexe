import functiontypes, seqindexslice

import pkg/[ maybe ]

import std/[ sugar ]


export maybe



type ScanResult* [T] = object
  start: Natural ## The index where scanning starts.
  n: Positive ## The number of matching units (chars, bytes, ...).
  when T isnot string:
    val: T



func someScanResult* (start: Natural; n: Positive): Maybe[ScanResult[string]] {.
  locks: 0
.} =
  ScanResult[string](start: start, n: n).just()


func someScanResult* [T: not string](
  start: Natural; n: Positive; val: T
): Maybe[ScanResult[T]] {. locks: 0 .} =
  ScanResult[T](start: start, n: n, val: val).just()



func emptyScanResult* [T](): Maybe[ScanResult[T]] {. locks: 0 .} =
  ScanResult[T].nothing()


func emptyScanResult* (T: typedesc): Maybe[ScanResult[T]] {. locks: 0 .} =
  emptyScanResult[T]()



func buildScanResult* (start: Natural; n: Natural): Maybe[ScanResult[string]] {.
  locks: 0
.} =
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



func toMaybeScanResult* [T: not string](
  m: Maybe[T: not ScanResult[any]]; start: Natural; n: Positive
): Maybe[ScanResult[T]] {. locks: 0 .} =
  m >>= (val: T) -> Maybe[ScanResult[T]] => someScanResult(start, n, val)
