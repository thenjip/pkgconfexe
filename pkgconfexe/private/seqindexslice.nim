type SeqIndexSlice* = Slice[Natural]



func seqIndexSlice* (a, b: Natural): SeqIndexSlice {. locks: 0 .} =
  a .. b


func seqIndexSlice* (start: Natural; n: Positive): SeqIndexSlice {.
  locks: 0
.} =
  seqIndexSlice(start, Natural(start + n - 1))


func seqIndexSlice* [I: SomeInteger](s: Slice[I]): SeqIndexSlice {.
  locks: 0
.} =
  seqIndexSlice(s.a, s.b)
