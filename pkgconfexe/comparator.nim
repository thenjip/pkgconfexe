import private/[ fphelper, scanresult, utf8 ]

import pkg/zero_functional

import std/[ options, strformat, tables, unicode ]



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



func findComparator (x: seq[Rune]): Option[Comparator] {. locks: 0 .} =
  result =
    if x.isComparator():
      ComparatorMap[x].some()
    else:
      Comparator.none()


func findComparator (x: string): Option[Comparator] {. locks: 0 .} =
  result = x.toRunes().findComparator()


#[
  Assumes the input is in UTF-8.
]#
func scanComparator* (input: string; start: Natural): ScanResult[Comparator] {.
  locks: 0
.} =
  let subStr = input.runeSubStr(start, ComparatorNChars)

  result =
    if subStr.toRunes().len() < ComparatorNChars:
      Comparator.emptyScanResult()
    else:
      subStr.findComparator().optionToScanResult(start, ComparatorNChars)


#[
  Assumes the input is in UTF-8.
]#
func scanComparator* (input: string): ScanResult[Comparator] {.
  locks: 0
.} =
  result = input.scanComparator(input.low())



static:
  Comparator.zfun:
    foreach:
      doAssert(($it).isUtf8())
      doAssert(($it).len() == ComparatorNChars)
      doAssert(($it).toRunes().len() == ComparatorNChars)
      doAssert(it.option().isUtf8())
