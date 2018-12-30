import private/[ fphelper, scanresult, utf8 ]

import pkg/unicodedb

import std/[ strscans, unicode ]



const
  AllowedCharOthers = { '+', '-', '_', '$', '.', '#', '@', '~', '*', ':' }

  AllowedCategories* = ctgL + ctgN



func isValid (r: Rune): bool {. locks: 0 .} =
  result = r in AllowedCharOthers or r.unicodeCategory() in AllowedCategories



func isVersion* (x: string): bool {. locks: 0 .} =
  result =
    x.len() > 0 and
    x.toRunes().callZFunc(all(it.isValid()))



func scanVersion* (input: string; start: Natural): ScanResult[string] {.
  locks: 0
.} =
  result = buildScanResult(
    start,
    (
      $input[start .. input.high()].toRunes().callZFunc(takeWhile(it.isValid()))
    ).len()
  )


func scanVersion* (input: string): ScanResult[string] {. locks: 0 .} =
  result = input.scanVersion(input.low())
