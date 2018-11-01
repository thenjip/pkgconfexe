import pkg/zero_functional

from std/sequtils import toSeq



func seqOfAll* (E: typedesc[enum]): seq[E] {. locks: 0 .} =
  result = toSeq(E.items())


#[
A helper to avoid putting brackets
around a boolean expression with the `-->` operator in it.
]#
template callZFunc* [T](a: openarray[T]; zfExpr: untyped): untyped =
  a-->zfExpr
