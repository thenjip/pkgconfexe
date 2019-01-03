import private/[ scanresult, utf8 ]

import pkg/zero_functional

import std/[ options, strformat, tables, unicode ]



type Comparator* {. pure .} = enum
  LessEq = "<="
  Equal = "=="
  GreaterEq = ">="



const
  ComparatorMap* = toOrderedTable(Comparator-->map((($it).toRunes(), it)))

  ComparatorOptions*: array[Comparator, string] = [
    "--max-version",
    "--exact-version",
    "--atleast-version"
  ]

  ComparatorNChars* = Comparator.low().`$`().len()



func default* (T: typedesc[Comparator]): T {. locks: 0 .} =
  T.GreaterEq



func option* (c: Comparator): string {. locks: 0 .} =
  ComparatorOptions[c]



func isComparator* (x: seq[Rune]): bool {. locks: 0 .} =
  ComparatorMap.hasKey(x)


func isComparator* (x: string): bool {. locks: 0 .} =
  x.toRunes().isComparator()



func findComparator (x: seq[Rune]): Option[Comparator] {. locks: 0 .} =
  if x.len() == ComparatorNChars and x in ComparatorMap:
    ComparatorMap[x].some()
  else:
    Comparator.none()



#[
  Assumes the input is in UTF-8.
]#
func scanComparator* (
  input: string; start: Natural
): Option[ScanResult[Comparator]] {. locks: 0 .} =
  if start >= input.len():
    Comparator.emptyScanResult()
  else:
    input.runeSubStr(
      start, ComparatorNChars
    ).toRunes().findComparator().toOptionScanResult(start, ComparatorNChars)


#[
  Assumes the input is in UTF-8.
]#
func scanComparator* (input: string): Option[ScanResult[Comparator]] {.
  locks: 0
.} =
  input.scanComparator(input.low())



static:
  Comparator.zfun:
    foreach:
      doAssert(($it).isUtf8())
      doAssert(($it).len() == ComparatorNChars)
      doAssert(($it).toRunes().len() == ComparatorNChars)
      doAssert(it.option().isUtf8())
