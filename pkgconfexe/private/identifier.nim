import utf8

import pkg/[ unicodedb, unicodeplus ]

import std/sequtils
import std/unicode except isAlpha



const
  AllowedCharOthers* = { '_' }
  AllowedOtherCharCategories* = ctgL + ctgN



func isIdentifier* (x: string): bool {. locks: 0 .} =
  result =
    x.len() > 0 and
    (func (x: string): bool =
      let
        firstRune = x.runeAt(x.low())
        firstRuneLen = x.runeLenAt(x.low())

      result =
        (firstRune in AllowedCharOthers or firstRune.isAlpha()) and
        x[x.low() + firstRuneLen..x.high()].toRunes().allIt(
          it.unicodeCategory() in AllowedOtherCharCategories or
          it in AllowedCharOthers
        )
    )(x)
