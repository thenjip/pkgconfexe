import pkg/zero_functional



template zeroFunc* (iter: Iterable; zfExpr: untyped): untyped =
  iter-->zfExpr
