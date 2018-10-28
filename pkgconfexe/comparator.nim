import private/utf8

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



func option* (c: Comparator): static[string] {. locks: 0 .} =
  result = ComparatorOptions[c]


func toComparator* (s: string): Comparator {.
  locks: 0, raises: [ ValueError ]
.} =
  for c in Comparator:
    if s == $c:
      return c

  raise newException(ValueError, fmt""""{s}" is not a supported operator.""")



func isComparator* (x: string): bool {. locks: 0 .} =
  for c in Comparator:
    if x.toRunes() == ($c).toRunes():
      return true

  result = false



func scanfComparator* (input: string; c: var Comparator; start: int): int {.
  locks: 0
.} =
  result = 0

  if input.len() >= ComparatorNChars:
    let subStr = input.runeSubStr(start, ComparatorNChars)

    if subStr.isComparator():
      result += ComparatorNChars
      c = subStr.toComparator()



static:
  for c in Comparator:
    doAssert(($c).len() == ComparatorNChars)
    doAssert(($c).isUtf8())
    doAssert(c.option().isUtf8())
