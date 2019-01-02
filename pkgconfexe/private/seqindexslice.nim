type SeqIndexSlice* = Slice[Natural]



func seqIndexSlice* (a, b: Natural): SeqIndexSlice {. locks: 0 .} =
  a .. b


func seqIndexSlice* [I: SomeInteger](s: Slice[I]): SeqIndexSlice {.
  locks: 0
.} =
  seqIndexSlice(s.a, s.b)
