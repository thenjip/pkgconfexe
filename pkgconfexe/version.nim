import package
import private/utf8

import pkg/unicodedb

import std/[ strscans, unicode ]



const
  AllowedCharOthers = package.AllowedCharOthers + { '*', ':' }

  AllowedCategories* = package.AllowedCategories



func isVersion* (x: string): bool {. locks: 0 .} =
  if x.len() == 0:
    return false

  for r in x.runes():
    if
      r notin AllowedCharOthers and
      r.unicodeCategory() notin AllowedCategories
    :
      return false

  result = true



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
