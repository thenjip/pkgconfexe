import seqindexslice

import std/[ sugar ]



type ScanResult* = object
  start*: Natural ## The index where scanning starts.
  n*: Natural ## The number of matching units (chars, bytes, ...).



func hasResult* (self: ScanResult): bool =
  ((n: Natural) => n > type(n).low())(self.n)



func slice (self: ScanResult): SeqIndexSlice =
  seqIndexSlice(self.start, self.n.Positive)



proc doIfHasResult* [T](
  self: ScanResult; thenProc, elseProc: proc (self: ScanResult)
) =
  if self.hasResult():
    thenProc(self)
  else:
    elseProc(self)


proc doIfHasResult* [T](
  self: ScanResult;
  thenProc: proc (slice: SeqIndexSlice);
  elseProc: proc (self: ScanResult)
) =
  if self.hasResult():
    thenProc(self.slice())
  else:
    elseProc(self)



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
  if self.hasResult():
    thenFunc(self.slice())
  else:
    elseFunc(self)



func `==`* (l, r: ScanResult): bool =
  l.start == r.start and l.n == r.n


func `!=`* (l, r: ScanResult): bool =
  not (l == r)
