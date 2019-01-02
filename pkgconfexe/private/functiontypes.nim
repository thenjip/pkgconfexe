type
  Predicate* [T] = func (t: T): bool {. locks: 0 .}

  UnaryFunctionClosure* [T, R] = func (t: T): R {. closure, locks: 0 .}

  BinaryFunctionClosure* [T1, T2, R] =
    func (t1: T1, t2: T2): R {. closure, locks: 0 .}
