import scanresult, utf8

import pkg/[ unicodedb, unicodeplus ]

import std/unicode except isAlpha



# 'Identifier' means 'environment variable identifier'.



const
  AllowedCharOthers* = { '_' }
  AllowedOtherCharCategories* = ctgL + ctgN



func checkFirstRune (r: Rune): bool {. locks: 0 .} =
  r in AllowedCharOthers or r.isAlpha()


func checkOtherRune (r: Rune): bool {. locks: 0 .} =
  r in AllowedCharOthers or r.unicodeCategory() in AllowedOtherCharCategories



func checkRunes (x: string; firstRune: tuple[r: Rune, len: Positive]): bool {.
  locks: 0
.} =
  firstRune.r.checkFirstRune() and
    countValidBytes(
      x,
      seqIndexSlice(x.low() + firstRune.len, x.high()),
      checkOtherRune
    ) == x.len() - firstRune.len


func isIdentifier* (x: string): bool {. locks: 0 .} =
  x.len() > 0 and x.checkRunes(x.firstRune())
