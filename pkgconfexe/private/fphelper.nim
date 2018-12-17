import pkg/zero_functional



template callZFunc* (iter: Iterable; zfExpr: untyped): untyped =
  iter-->zfExpr
