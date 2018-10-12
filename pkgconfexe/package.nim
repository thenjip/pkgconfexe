import std/unicode

import pkg/unicodedb

import private/utf8



const
  AllowedCharOthers* = { '+', '-', '_', '$', '.', '#', '@', '~' }

  AllowedCategories* = ctgL + ctgN



func isPackage* (x: string): bool {. locks: 0 .} =
  if x.len() == 0:
    return false

  for r in x.runes():
    if
      r notin AllowedCharOthers and
      r.unicodeCategory() notin AllowedCategories
    :
      return false

  result = true



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
