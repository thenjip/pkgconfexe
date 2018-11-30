import private/[ fphelper, utf8 ]

import pkg/zero_functional

import std/[ strformat, options, unicode ]



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



func default* (T: typedesc[Comparator]): T {. locks: 0 .} =
  result = T.GreaterEq



func option* (c: Comparator): string {. locks: 0 .} =
  result = ComparatorOptions[c]



func matches (c: Comparator; s: string): bool {. locks: 0 .} =
  result = $c == s


func isComparator* (x: string): bool {. locks: 0 .} =
  result = Comparator-->exists(it.matches(x))



func findComparator (x: string): Option[Comparator] {.
  locks: 0
.} =
  result = Comparator-->find(it.matches(x))


func parseComparator (input: string; c: var Comparator): int {. locks: 0 .} =
  let found = input.findComparator()

  if found.isSome():
    result = ComparatorNChars
    c = found.unsafeGet()
  else:
    result = 0


func scanfComparator* (input: string; c: var Comparator; start: int): int {.
  locks: 0
.} =
  result =
    if input.len() - start < ComparatorNChars:
      0
    else:
      parseComparator(input[start .. start + ComparatorNChars], c)



static:
  Comparator.zfun:
    foreach:
      doAssert(($it).len() == ComparatorNChars)
      doAssert(($it).isUtf8())
      doAssert(it.option().isUtf8())

