import private/[ scanresult, seqindexslice, utf8 ]

import pkg/[ unicodedb ]

import std/[ unicode ]



const
  AllowedCharOthers = { '+', '-', '_', '$', '.', '#', '@', '~', '*', ':' }

  AllowedCategories* = ctgL + ctgN



func isValid (r: Rune): bool =
  r in AllowedCharOthers or r.unicodeCategory() in AllowedCategories



func isVersion* (x: string): bool =
  x.len() > 0 and
    x.countValidBytes(
      seqIndexSlice(x.low(), x.len().Positive), isValid
    ) == x.len()



func scanVersion* (
  input: string; start: Natural
): Optional[ScanResult[string]] =
  if start >= input.len():
    string.emptyScanResult()
  else:
    buildScanResult(
      start, input.countValidBytes(start .. input.high().Natural, isValid)
    )


func scanVersion* (input: string): Optional[ScanResult[string]] =
  input.scanVersion(input.low())
