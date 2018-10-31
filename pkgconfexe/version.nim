import package
import private/utf8

import pkg/unicodedb

import std/[ sequtils, strscans, unicode ]



const
  AllowedCharOthers = { '+', '-', '_', '$', '.', '#', '@', '~', '*', ':' }

  AllowedCategories* = ctgL + ctgN



func isVersion* (x: string): bool {. locks: 0 .} =
  result =
    x.len() > 0 and
    x.toRunes().allIt(
      it in AllowedCharOthers or it.unicodeCategory() in AllowedCategories
    )



func scanfVersion* (input: string; version: var string; start: int): int {.
  locks: 0
.} =
  result = 0

  for r in input[start..input.high()].runes():
    if
      r notin AllowedCharOthers and
      r.unicodeCategory() notin AllowedCategories
    :
      break

    result.inc()
    version.add($r)
