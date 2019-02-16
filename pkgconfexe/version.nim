import private/[ scanhelper, scanresult, seqindexslice, utf8 ]

when nimvm:
  discard
else:
  import pkg/[ unicodedb ]

import std/[ unicode ]



const AllowedCharOthers = { '+', '-', '_', '$', '.', '#', '@', '~', '*', ':' }

when nimvm:
  discard
else:
  const AllowedCategories* = ctgL + ctgN



func isValid (r: Rune): bool =
  r in AllowedCharOthers or
    (func (r: Rune): bool =
      when nimvm:
        r.isNumber() or r.isAlpha()
      else:
        r.unicodeCategory() in AllowedCategories
    )(r)


func scanVersion* (input: string; start, nMax: Natural): ScanResult =
  buildScanResult(start, input.countValidBytes(start, nMax, isValid))


func scanVersion* (input: string; start: Natural): ScanResult =
  buildScanResult(start, input.countValidBytes(start, isValid))


func scanVersion* (input: string): ScanResult =
  input.scanVersion(input.low())



func isVersion* (x: string): bool =
  x.len() > 0 and x.scanVersion().n == x.len()
