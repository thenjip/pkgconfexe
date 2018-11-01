import ../env

import pkg/zero_functional

import std/[ macros ]



func isArrayOf* [T](n: NimNode): bool {. compileTime, locks: 0 .} =
  let baseTypeNode: NimNode = case n.typeKind():
    of ntyArray:
      n.getTypeImpl()[1]
    of ntyOpenArray, ntySequence:
      n.getTypeImpl()[0]
    else:
      nil

  result = baseTypeNode == T.getTypeImpl()


func getEnvFromBlock* (codeBlock: NimNode): NimNode {.
  compileTime, locks: 0
.} =
  result = nnkBracket.newTree(codeBlock-->filter(it.isArrayOf[: EnvVarValue]()))
