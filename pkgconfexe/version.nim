import private/[ scanresult, seqindexslice, utf8 ]

import pkg/[ unicodedb ]

import std/[ unicode ]



const
  AllowedCharOthers = { '+', '-', '_', '$', '.', '#', '@', '~', '*', ':' }

  AllowedCategories* = ctgL + ctgN



func isValid (r: Rune): bool =
  r in AllowedCharOthers or r.unicodeCategory() in AllowedCategories



func scanVersion* (input: string; start, n: Natural): ScanResult =
  (func (nParsed: Natural): ScanResult =
    if nParsed > 0:
      someScanResult(start, nParsed)
    else:
      emptyScanResult(start)
  )(input.countValidBytes(start, n, isValid))


func scanVersion* (input: string; start: Natural): ScanResult =
  input.scanVersion(start, input.len())


func scanVersion* (input: string): ScanResult =
  input.scanVersion(input.low())



func isVersion* (x: string): bool =
  x.len() > 0 and x.scanVersion().n == x.len()
