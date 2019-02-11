import private/[ scanhelper, scanresult, utf8 ]

when nimvm:
  discard
else:
  import pkg/[ unicodedb ]

import std/[ unicode ]



const AllowedCharOthers*: set[AsciiChar] = {
  '+', '-', '_', '$', '.', '#', '@', '~'
}

when nimvm:
  discard
else:
  const AllowedCategories = ctgL + ctgN



func isValid* (r: Rune): bool =
  r in AllowedCharOthers or
    (func (r: Rune): bool =
      when nimvm:
        r.isNumber() or r.isAlpha()
      else:
        r.unicodeCategory() in AllowedCategories
    )(r)


func scanPackage* (input: string; start, nMax: Natural): ScanResult =
  buildScanResult(start, input.countValidBytes(start, nMax, isValid))


func scanPackage* (input: string; start: Natural): ScanResult =
  buildScanResult(start, input.countValidBytes(start, isValid))


func scanPackage* (input: string): ScanResult =
  input.scanPackage(input.low())



func isPackage* (x: string): bool =
  x.len() > 0 and x.scanPackage().n == x.len()
