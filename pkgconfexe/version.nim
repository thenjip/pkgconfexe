import package
import private/[ fphelper, utf8 ]

import pkg/unicodedb

import std/[ strscans, unicode ]



const
  AllowedCharOthers = { '+', '-', '_', '$', '.', '#', '@', '~', '*', ':' }

  AllowedCategories* = ctgL + ctgN



func isVersion* (x: string): bool {. locks: 0 .} =
  result =
    x.len() > 0 and
    x.toRunes().callZFunc(all(
      it in AllowedCharOthers or it.unicodeCategory() in AllowedCategories
    ))



func scanfVersion* (input: string; version: var string; start: int): int {.
  locks: 0
.} =
  version = $input[start..input.high()].toRunes().callZFunc(takeWhile(
    it in AllowedCharOthers or it.unicodeCategory() in AllowedCategories
  ))
  result = version.len()
