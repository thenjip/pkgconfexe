import zfunchelper, utf8

import pkg/[ unicodedb, unicodeplus, zero_functional ]

import std/unicode except isAlpha



# 'Identifier' means 'environment variable identifier'.



const
  AllowedCharOthers* = { '_' }
  AllowedOtherCharCategories* = ctgL + ctgN



func checkFirstRune (r: Rune): bool {. locks: 0 .} =
  r in AllowedCharOthers or r.isAlpha()


func checkRunes (x: string; firstRune: Rune; firstRuneLen: Positive): bool {.
  locks: 0
.} =
  firstRune.checkFirstRune() and
    x[x.low() + firstRuneLen .. x.high()].toRunes().zeroFunc(
      all(
        it in AllowedCharOthers or
        it.unicodeCategory() in AllowedOtherCharCategories
      )
    )


func isIdentifier* (x: string): bool {. locks: 0 .} =
  x.len() > 0 and x.checkRunes(x.firstRune(), x.runeLenAt(x.low()))
