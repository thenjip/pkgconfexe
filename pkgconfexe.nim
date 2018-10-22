import pkgconfexe/cmd

import std/macros



template checkModules* (modules: varargs[string]): untyped =
  {. addCFlags(modules), addLdFlags(modules) .}


macro addCFlags* (modules: varargs[string]): untyped =
  var args = nnkbracket.newNode()

  for m in modules:
    args.add(nnkpar.newNimNode(
      newCall("toModule", m),
      newCall("`@`", nnkBracket.newNimNode())
    ))

  result = nnkExprColonExpr.newNimNode(
    bindSym("passC"), newCall("getCFlags", args)
  )


macro addLdFlags* (modules: varargs[string]): untyped =
  var args = nnkbracket.newNode()

  for m in modules:
    args.add(nnkpar.newNimNode(
      newCall("toModule", m),
      newCall("`@`", nnkBracket.newNimNode())
    ))

  result = nnkExprColonExpr.newNimNode(
    bindSym("passL"), newCall("getLdFlags", args)
  )
