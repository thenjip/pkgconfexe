import private/utf8

import pkg/unicodedb

import std/[ sequtils, unicode ]



const
  AllowedCharOthers* = { '+', '-', '_', '$', '.', '#', '@', '~' }

  AllowedCategories* = ctgL + ctgN



func isPackage* (x: string): bool {. locks: 0 .} =
  result =
    x.len() > 0 and
    x.toRunes().allIt(
      it in AllowedCharOthers or it.unicodeCategory() in AllowedCategories
    )



func scanfPackage* (input: string; pkg: var string; start: int): int {.
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
    pkg.add($r)
