import std/[ strformat, unicode ]

import private/utf8



type Operator* {. pure .} = enum
  LessEq = "<="
  Equal = "=="
  GreaterEq = ">="



const
  OperatorOptions*: array[Operator, string] = [
    "--max-version",
    "--exact-version",
    "--atleast-version"
  ]

  OperatorNChars* = 2



func option* (o: Operator): static[string] {. locks: 0 .} =
  result = OperatorOptions[o]


func operator* (s: string): Operator {. locks: 0, raises: [ ValueError ] .} =
  for o in Operator:
    if s == $o:
      return o

  raise newException(ValueError, fmt""""{s}" is not a supported operator.""")



func isOperator* (x: string): bool {. locks: 0 .} =
  for op in Operator:
    if x.toRunes() == ($op).toRunes():
      return true

  result = false



func scanfOperator* (input: string; op: var Operator; start: int): int {.
  locks: 0
.} =
  result = 0

  if input.len() >= OperatorNChars:
    let subStr = input.runeSubStr(start, OperatorNChars)

    if subStr.isOperator():
      result += OperatorNChars
      op = subStr.operator()



static:
  for o in Operator:
    doAssert(($o).len() == OperatorNChars)
    doAssert(($o).isUtf8())
    doAssert(o.option().isUtf8())
