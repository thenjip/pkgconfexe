import private/[ fphelper, utf8 ]

import pkg/zero_functional

import std/[ strformat, unicode ]



type Comparator* {. pure .} = enum
  LessEq = "<="
  Equal = "=="
  GreaterEq = ">="



const
  ComparatorOptions*: array[Comparator, string] = [
    "--max-version",
    "--exact-version",
    "--atleast-version"
  ]

  ComparatorNChars* = 2





func option* (c: Comparator): string {. locks: 0 .} =
  result = ComparatorOptions[c]



func isComparator* (x: string): bool {. locks: 0 .} =
  result = Comparator.seqOfAll()-->exists(($it).toRunes() == x.toRunes())



func toComparator* (x: string): Comparator {.
  locks: 0, raises: [ ValueError ]
.} =
  const allCmp = Comparator.seqOfAll()
  let idx = allCmp-->index(($it).toRunes() == x.toRunes())

  result =
    if idx < 0:
      raise newException(
        ValueError, fmt""""{x}" is not a supported comparator."""
      )
    else:
      allCmp[idx]



func scanfComparator* (input: string; c: var Comparator; start: int): int {.
  locks: 0
.} =
  result = 0

  if input.len() >= ComparatorNChars:
    let subStr = input.runeSubStr(start, ComparatorNChars)

    if subStr.isComparator():
      result += subStr.len()
      c = subStr.toComparator()



static:
  doAssert(Comparator.seqOfAll()-->all(
    ($it).len() == ComparatorNChars and
    ($it).isUtf8() and
    it.option().isUtf8()
  ))
