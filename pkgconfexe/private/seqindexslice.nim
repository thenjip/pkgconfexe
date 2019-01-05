type SeqIndexSlice* = Slice[Natural]



func seqIndexSlice* (a, b: Natural): SeqIndexSlice =
  a .. b


func seqIndexSlice* (start: Natural; n: Positive): SeqIndexSlice =
  seqIndexSlice(start, Natural(start + n - 1))


func seqIndexSlice* [I: SomeInteger](s: Slice[I]): SeqIndexSlice =
  seqIndexSlice(s.a, s.b)
