import functiontypes

import std/[ options ]


export options



func flatMap* [T, R](
  o: Option[T]; f: UnaryFunctionClosure[T, Option[R]]
): Option[R] {. locks: 0 .} =
  if o.isSome():
    o.unsafeGet().f()
  else:
    R.none()
