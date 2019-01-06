import seqindexslice

import std/[ sugar ]


export seqindexslice



type ScanResult* = object
  start*: Natural ## The index where scanning starts.
  n*: Natural ## The number of matching units (chars, bytes, ...).



func someScanResult* (start: Natural; n: Positive): ScanResult =
  ScanResult(start: start, n: n)


func someScanResult* (slice: SeqIndexSlice): ScanResult =
  result = someScanResult(slice.a, slice.len().Positive)


func emptyScanResult* (start: Natural): ScanResult =
  ScanResult(start: start, n: Natural.low())



func hasResult* (self: ScanResult): bool =
  ((n: Natural) => n > Natural.low())(self.n)



func slice (self: ScanResult): SeqIndexSlice =
  seqIndexSlice(self.start, self.n.Positive)



proc doIfHasResult* (
  self: ScanResult; thenProc, elseProc: proc (self: ScanResult)
) =
  if self.hasResult():
    thenProc(self)
  else:
    elseProc(self)


proc doIfHasResult* (
  self: ScanResult;
  thenProc: proc (slice: SeqIndexSlice);
  elseProc: proc (self: ScanResult)
) =
  self.doIfHasResult((self: ScanResult) => thenProc(self.slice()), elseProc)


proc doIfHasResult* (self: ScanResult; thenProc: proc (self: ScanResult)) =
  self.doIfHasResult(thenProc, proc (self: ScanResult) = discard)


proc doIfHasResult* (self: ScanResult; thenProc: proc (self: SeqIndexSlice)) =
  self.doIfHasResult(thenProc, proc (self: ScanResult) = discard)



func ifHasResult* [T](
  self: ScanResult; thenFunc, elseFunc: func (self: ScanResult): T
): T =
  if self.hasResult():
    thenFunc(self)
  else:
    elseFunc(self)


func ifHasResult* [T](
  self: ScanResult;
  thenFunc: func (slice: SeqIndexSlice): T;
  elseFunc: func (self: ScanResult): T
): T =
  self.ifHasResult((self: ScanResult) => thenFunc(self.slice()), elseFunc)



func flatMapOr* (
  self: ScanResult;
  f: func (self: ScanResult): ScanResult;
  otherwise: func (self: ScanResult): ScanResult
): ScanResult =
  self.ifHasResult(f, otherwise)


func flatMapOr* (
  self: ScanResult;
  f: func (slice: SeqIndexSlice): ScanResult;
  otherwise: func (self: ScanResult): ScanResult
): ScanResult =
  self.ifHasResult(f, otherwise)



func flatMap* (
  self: ScanResult; f: func (self: ScanResult): ScanResult
): ScanResult =
  self.flatMapOr(f, (self: ScanResult) => emptyScanResult(self.start))


func flatMap* (
  self: ScanResult; f: func (slice: SeqIndexSlice): ScanResult
): ScanResult =
  self.flatMapOr(f, (self: ScanResult) => emptyScanResult(self.start))



func `==`* (l, r: ScanResult): bool =
  l.start == r.start and l.n == r.n


func `!=`* (l, r: ScanResult): bool =
  not (l == r)
