import pkg/zero_functional

from std/sequtils import toSeq



template seqOfAll* [T](a: Iterable[T]; iter: untyped): seq[T] =
  toSeq(a.iter())


func seqOfAll* (E: typedesc[enum]): seq[E] {. locks: 0 .} =
  result = E.seqOfAll(items)



#[
  A helper to avoid putting brackets around a sub-expression (of a bigger one)
  using a zero_functional function.
]#
template callZFunc* [T](a: Iterable[T]; zfExpr: untyped): untyped =
  a-->zfExpr
