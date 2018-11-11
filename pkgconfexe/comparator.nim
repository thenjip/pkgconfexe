import private/[ fphelper, utf8 ]

import pkg/zero_functional

import std/[ strformat, options, unicode ]



type Comparator* {. pure .} = enum
  None = ""
  LessEq = "<="
  Equal = "=="
  GreaterEq = ">="



const
  ComparatorOptions*: array[Comparator, string] = [
    "",
    "--max-version",
    "--exact-version",
    "--atleast-version"
  ]

  ComparatorNChars* = 2

  AllComparators* = Comparator.setOfAll()
  AllNonEmptyComparators* = AllComparators - { Comparator.None }



func option* (c: Comparator): string {. locks: 0 .} =
  result = ComparatorOptions[c]



func isComparator* (x: string): bool {. locks: 0 .} =
  result = AllComparators-->exists(($it).toRunes() == x.toRunes())



func findComparator (x: string; cmps: set[Comparator]): Option[Comparator] {.
  locks: 0
.} =
  result = cmps-->find(($it).toRunes() == x.toRunes())


func toComparator* (x: string): Comparator {.
  locks: 0, raises: [ ValueError ]
.} =
  let found = findComparator(x, AllComparators)

  result =
    if found.isSome():
      found.unsafeGet()
    else:
      raise newException(
        ValueError, fmt""""{x}" is not a supported comparator."""
      )



func parseComparator (input: string; c: var Comparator): int {. locks: 0 .} =
  let found = findComparator(
    input[input.low()..ComparatorNChars - 1], AllNonEmptyComparators
  )

  if found.isSome():
    result = ComparatorNChars
    c = found.unsafeGet()
  else:
    result = 0
    c = Comparator.None


func scanfComparator* (input: string; c: var Comparator; start: int): int {.
  locks: 0
.} =
    if input.len() - start < ComparatorNChars:
      result = 0
      c = Comparator.None
    else:
      result = parseComparator(input[start..input.high()], c)



static:
  doAssert(AllNonEmptyComparators-->all(
    ($it).len() == ComparatorNChars and
    ($it).isUtf8() and
    it.option().isUtf8()
  ))
