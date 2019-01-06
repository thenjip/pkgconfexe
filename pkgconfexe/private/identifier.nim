import utf8

import pkg/[ unicodedb, unicodeplus ]

import std/unicode except isAlpha
import std/[ sugar ]



# 'Identifier' means 'environment variable identifier'.



const
  AllowedCharOthers*: set[AsciiChar] = { '_' }
  AllowedOtherCharCategories* = ctgL + ctgNd



func firstRuneIsValid (r: Rune): bool =
  r in AllowedCharOthers or r.isAlpha()


func otherRuneIsValid (r: Rune): bool =
  r in AllowedCharOthers or r.unicodeCategory() in AllowedOtherCharCategories


func checkOtherRunes (x: string; firstRuneLen: Positive): bool =
  ((len: Natural) =>
    x.countValidBytes(x.low() + firstRuneLen, len, otherRuneIsValid) == len
  )(x.len() - firstRuneLen)


func checkRunes (x: string; firstRune: tuple[r: Rune, len: Positive]): bool =
  firstRune.r.firstRuneIsValid() and x.checkOtherRunes(firstRune.len)


func isIdentifier* (x: string): bool =
  x.len() > 0 and x.checkRunes(x.firstRune())
