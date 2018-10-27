import pkgconfexe/cmd
import pkgconfexe/private/dslhelper

import std/macros


export env



func toModules (mods: NimNode): NimNode {. locks: 0 .} =
  doAssert(mods.isArrayOf[: string]())

  result = "module.toModules".bindSym().newCall(mods)



macro withEnv* (env: varargs[EnvVarValue]): NimNode =
  result = nnkBracket.newNimNode()

  for e in env:
    result.add(e)



macro addCFlags* (modules: openarray[string]): untyped =

  result = nnkExprColonExpr.newTree(
    "passC".bindSym(),
    "getCFlags".bindSym().newCall(modules.toModules(), withEnv())
  )


macro addLdFlags* (modules: openarray[string]): untyped =
  result = nnkExprColonExpr.newTree(
    "passL".bindSym(),
    "getLdFlags".bindSym().newCall(modules.toModules(), withEnv())
  )


macro checkModules* (modules: openarray[string]): untyped =
  result = nnkPragmaExpr.newTree(
    addCFlags(modules, body),
    addLdFlags(modules, body)
  )



macro addCFlags* (modules: varargs[string]; body: untyped): untyped =
  result = nnkPragma.newTree(
    nnkExprColonExpr.newTree(
      "passC".bindSym(),
      "getCFlags".bindSym().newCall(modules.toModules(), body.getEnvFromBlock())
    )
  )


macro addLdFlags* (modules: varargs[string]; body: untyped): untyped =
  result = nnkPragma.newTree(
    nnkExprColonExpr.newTree(
      "passL".bindSym(),
      "getLdFlags".bindSym().newCall(
        modules.toModules(), body.getEnvFromBlock()
      )
    )
  )


macro checkModules* (modules: varargs[string]; body: untyped): untyped =
  result = nnkStmtList.newTree(
    addCFlags(modules, body),
    addLdFlags(modules, body)
  )
