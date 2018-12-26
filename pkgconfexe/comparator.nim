import private/[ fphelper, parseresult, utf8 ]

import pkg/zero_functional

import std/[ strformat, tables, unicode ]



type Comparator* {. pure .} = enum
  LessEq = "<="
  Equal = "=="
  GreaterEq = ">="



const
  ComparatorMap* = toTable(
    Comparator-->map(
      (func (c: Comparator): (seq[Rune], Comparator) =
        result = (($it).toRunes(), it)
      )(it)
    )
  )

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



func isComparator* (x: seq[Rune]): bool {. locks: 0 .} =
  result = ComparatorMap.hasKey(x)


func isComparator* (x: string): bool {. locks: 0 .} =
  result = x.toRunes().isComparator()



func findComparator (x: seq[Rune]): ParseResult[Comparator] {. locks: 0 .} =
  result =
    if x.isComparator():
      ComparatorMap[x].some(ComparatorNChars)
    else:
      Comparator.none()


func findComparator (x: string): ParseResult[Comparator] {. locks: 0 .} =
  result = x.toRunes().findComparator()


#[
  Assumes the input is in UTF-8.
  All the comparators are internally encoded in ASCII.
]#
func parseComparator* (input: string): ParseResult[Comparator] {.
  locks: 0
.} =
  result =
    if input.len() < ComparatorNChars:
      Comparator.none()
    else:
      input[
        input.low() .. input.low() + ComparatorNChars
      ].findComparator()



static:
  Comparator.zfun:
    foreach:
      doAssert(($it).isUtf8())
      doAssert(($it).len() == ComparatorNChars)
      doAssert(($it).toRunes().len() == ComparatorNChars)
      doAssert(it.option().isUtf8())
