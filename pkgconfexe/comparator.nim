import private/[ scanresult, utf8 ]

import pkg/[ zero_functional ]

import std/[ strformat, tables, unicode ]



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
  ComparatorMap.hasKey(x)


func isComparator* (x: string): bool =
  x.toRunes().isComparator()



func findComparator (x: seq[Rune]): Optional[Comparator] =
  if x.len() == ComparatorNChars and x in ComparatorMap:
    ComparatorMap[x].some()
  else:
    Comparator.none()



#[
  Assumes the input is in UTF-8.
]#
func scanComparator* (
  input: string; start: Natural
): Optional[ScanResult[Comparator]] =
  if start >= input.len():
    Comparator.emptyScanResult()
  else:
    input.runeSubStr(
      start, ComparatorNChars
    ).toRunes().findComparator().toOptionalScanResult(start, ComparatorNChars)


#[
  Assumes the input is in UTF-8.
]#
func scanComparator* (input: string): Optional[ScanResult[Comparator]] =
  input.scanComparator(input.low())



static:
  Comparator.zfun:
    foreach:
      doAssert(($it).isUtf8())
      doAssert(($it).len() == ComparatorNChars)
      doAssert(($it).toRunes().len() == ComparatorNChars)
      doAssert(it.option().isUtf8())
