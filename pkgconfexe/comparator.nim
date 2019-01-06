import private/[ scanresult, utf8 ]

import pkg/[ zero_functional ]

import std/[ options, tables, unicode ]



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



func default* (T: typedesc[Comparator]): T =
  T.GreaterEq



func option* (c: Comparator): string =
  ComparatorOptions[c]



func isComparator* (x: seq[Rune]): bool =
  x.len() == ComparatorNChars and x in ComparatorMap


func isComparator* (x: string): bool =
  x.toRunes().isComparator()



func findComparator* (x: seq[Rune]): Option[Comparator] =
  if x.isComparator():
    ComparatorMap[x].some()
  else:
    Comparator.none()


func findComparator* (x: string): Option[Comparator] =
  x.toRunes().findComparator()



func scanComparator* (input: string; start: Natural): ScanResult =
  if start > input.high() or input.runeSubStr(
    start, ComparatorNChars
  ).findComparator().isNone():
    emptyScanResult(start)
  else:
    someScanResult(start, ComparatorNChars)


func scanComparator* (input: string): ScanResult =
  input.scanComparator(input.low())



static:
  Comparator.zfun:
    foreach:
      doAssert(($it).isUtf8())
      doAssert(($it).len() == ComparatorNChars)
      doAssert(($it).toRunes().len() == ComparatorNChars)
      doAssert(it.option().isUtf8())
