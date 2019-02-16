import private/[ scanresult, utf8 ]

import std/[ options, sequtils, tables, unicode ]



type Comparator* {. pure .} = enum
  LessEq = "<="
  Equal = "=="
  GreaterEq = ">="



const
  ComparatorMap =
    toOrderedTable(toSeq(Comparator.items()).mapIt((($it).toRunes(), it)))

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
  if
    start > input.high() or
      input.runeSubStr(start, ComparatorNChars).findComparator().isNone()
  :
    emptyScanResult(start)
  else:
    someScanResult(start, ComparatorNChars)


func scanComparator* (input: string): ScanResult =
  input.scanComparator(input.low())



static:
  for c in Comparator:
    doAssert(($c).isUtf8())
    doAssert(($c).len() == ComparatorNChars)
    doAssert(($c).toRunes().len() == ComparatorNChars)
    doAssert(c.option().isUtf8())
