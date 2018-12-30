import private/[ fphelper, parseresult, utf8 ]

import pkg/[ unicodedb, zero_functional ]

import std/unicode



const
  AllowedCharOthers* = { '+', '-', '_', '$', '.', '#', '@', '~' }

  AllowedCategories* = ctgL + ctgN



func isValid* (r: Rune): bool {. locks: 0 .} =
  result = r in AllowedCharOthers or r.unicodeCategory() in AllowedCategories



func isPackage* (x: string): bool {. locks: 0 .} =
  result = x.len() > 0 and x.toRunes().callZFunc(all(it.isValid()))



func parsePackage* (input: string; start: Natural): ParseResult[string] {.
  locks: 0
.} =
  result = buildParseResult(
    start .. (
      $input[start .. input.high()].toRunes().callZFunc(
        takeWhile(it.isValid())
      )
    ).len()
  )


func parsePackage* (input: string): ParseResult[string] {. locks: 0 .} =
  result = input.parsePackage(input.low())
