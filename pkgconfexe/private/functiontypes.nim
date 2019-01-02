type
  Predicate* [T] = func (t: T): bool {. locks: 0 .}

  UnaryFunctionClosure* [T, R] = func (t: T): R {. closure, locks: 0 .}
