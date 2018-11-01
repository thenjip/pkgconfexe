from std/sequtils import toSeq



func seqOfAll* (E: typedesc[enum]): seq[E] {. locks: 0 .} =
  result = toSeq(E.items())
