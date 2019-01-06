import private/[ scanresult, utf8 ]

import pkg/[ unicodedb ]

import std/[ unicode ]



const
  AllowedCharOthers*: set[AsciiChar] = {
    '+', '-', '_', '$', '.', '#', '@', '~'
  }

  AllowedCategories* = ctgL + ctgN



func isValid* (r: Rune): bool =
  r in AllowedCharOthers or r.unicodeCategory() in AllowedCategories



func scanPackage* (input: string; start, n: Natural): ScanResult =
  (func (nParsed: Natural): ScanResult =
    if nParsed > 0:
      someScanResult(start, nParsed)
    else:
      emptyScanResult(start)
  )(input.countValidBytes(start, n, isValid))


func scanPackage* (input: string; start: Natural): ScanResult =
  input.scanPackage(start, input.len())


func scanPackage* (input: string): ScanResult =
  input.scanPackage(input.low())



func isPackage* (x: string): bool =
  x.len() > 0 and x.scanPackage().n == x.len()
