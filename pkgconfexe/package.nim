import private/[ scanresult, seqindexslice, utf8 ]

import pkg/[ unicodedb ]

import std/[ unicode ]



const
  AllowedCharOthers* = { '+', '-', '_', '$', '.', '#', '@', '~' }

  AllowedCategories* = ctgL + ctgN



func isValid* (r: Rune): bool {. locks: 0 .} =
  r in AllowedCharOthers or r.unicodeCategory() in AllowedCategories



func isPackage* (x: string): bool {. locks: 0 .} =
  x.len() > 0 and
    x.countValidBytes(seqIndexSlice(x.low(), x.high()), isValid) == x.len()



func scanPackage* (input: string; start: Natural): Option[ScanResult[string]] {.
  locks: 0
.} =
  buildScanResult(
    start, input.countValidBytes(start .. input.high().Natural, isValid)
  )


func scanPackage* (input: string): Option[ScanResult[string]] {. locks: 0 .} =
  input.scanPackage(input.low())
