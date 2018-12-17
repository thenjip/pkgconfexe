import package
import private/[ fphelper, utf8 ]

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



func scanfVersion* (input: string; version: var string; start: int): int {.
  locks: 0
.} =
  let found = $input[start .. input.high()].toRunes().callZFunc(
    takeWhile(it.isValid())
  )

  version = found
  result = found.len()
