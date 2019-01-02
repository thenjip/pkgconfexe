import pkg/zero_functional


export zero_functional



template zeroFunc* (iter: Iterable; zfExpr: untyped): untyped =
  iter-->zfExpr
