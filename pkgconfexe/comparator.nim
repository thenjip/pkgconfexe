import private/utf8

import std/[ sequtils, strformat, unicode ]



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
  result = toSeq(Comparator.items()).anyIt(x.toRunes() == ($it).toRunes())



func toComparator* (x: string): Comparator {.
  locks: 0, raises: [ ValueError ]
.} =
  for c in Comparator:
    if x.toRunes() == ($c).toRunes():
      return c

  raise newException(ValueError, fmt""""{x}" is not a supported operator.""")



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
  doAssert(toSeq(Comparator.items()).allIt(
    ($it).len() == ComparatorNChars and
    ($it).isUtf8() and
    it.option().isUtf8()
  ))
