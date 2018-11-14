import pkg/zero_functional

from std/sequtils import toSeq


template setOfAll* [E: enum](e: typedesc[E]): set[E] =
  { e.low()..e.high() }


template setOfAll* [E: enum](s: Slice[E]): set[E] =
  { s }



template seqOf* (iter: untyped): untyped =
  toSeq(iter)


template seqOfAll* [T](a: Iterable[T]; iter: untyped): seq[T] =
  seqOf(a.iter())


template seqOfAll* (E: typedesc[enum]): seq[E] =
  E.seqOfAll(items)


template seqOfAll* [E: enum](s: Slice[E]): seq[E] =
  s.seqOfAll(items)



#[
  A helper to avoid putting brackets around a sub-expression (of a bigger one)
  using a zero_functional function.
]#
template callZFunc* [T](a: Iterable[T]; zfExpr: untyped): untyped =
  a-->zfExpr
