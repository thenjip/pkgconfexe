import private/[ fphelper, parseresult, utf8 ]

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



func parseVersion* (input: string; start: Natural): ParseResult[string] {.
  locks: 0
.} =
  result = buildParseResult(
    start .. (
      $input[start .. input.high()].toRunes().callZFunc(
        takeWhile(it.isValid())
      )
    ).len()
  )


func parseVersion* (input: string): ParseResult[string] {. locks: 0 .} =
  result = input.parseVersion(input.low())
