import fphelper, utf8

import pkg/[ unicodedb, unicodeplus, zero_functional ]

import std/unicode except isAlpha



# 'Identifier' means 'Environment variable identifier'.



const
  AllowedCharOthers* = { '_' }
  AllowedOtherCharCategories* = ctgL + ctgN



func checkRunes (x: string): bool {. locks: 0 .} =
  let
    firstRune = x.runeAt(x.low())
    firstRuneLen = x.runeLenAt(x.low())

  result =
    (firstRune in AllowedCharOthers or firstRune.isAlpha()) and
    x[x.low() + firstRuneLen .. x.high()].toRunes().callZFunc(
      all(
        it in AllowedCharOthers or
        it.unicodeCategory() in AllowedOtherCharCategories
      )
    )


func isIdentifier* (x: string): bool {. locks: 0 .} =
  result = x.len() > 0 and x.checkRunes()
