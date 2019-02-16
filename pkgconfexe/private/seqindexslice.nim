type SeqIndexSlice* = Slice[Natural]



func seqIndexSlice* (start: Natural; n: Positive): SeqIndexSlice =
  start .. Natural(start + n - 1)


func seqIndexSlice* [I: Ordinal](s: Slice[I]): SeqIndexSlice =
  seqIndexSlice(s.a.Natural, s.len().Positive)


func seqIndexSlice* [U, L: Ordinal](hs: HSlice[U, L]): SeqIndexSlice =
  seqIndexSlice(hs.a.Natural, hs.len().Positive)
