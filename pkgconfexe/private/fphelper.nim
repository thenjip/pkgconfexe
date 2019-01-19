type Iterable* [T] {. explain .} = concept x
  for it in x:
    it.type() is T



##[
  A template to implement the foreach operation in functional programming.
  ``itName`` will be used as the current item variable name.
  ``iterable`` must have an ``items`` iterator defined.
]##
template foreach* [T](
  iterable: Iterable[T]; itName: untyped{ident}, consumer: untyped{nkStmtList}
): untyped =
  for itName in iterable:
    consumer


##[
  Same as above but uses ``it`` as the current item variable name.
]##
template foreach* [T](
  iterable: Iterable[T]; consumer: untyped{nkStmtList}
): untyped =
  iterable.foreach it:
    consumer
