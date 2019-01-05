import seqindexslice, utf8

import pkg/[ unicodedb, unicodeplus ]

import std/unicode except isAlpha



# 'Identifier' means 'environment variable identifier'.



const
  AllowedCharOthers* = { '_' }
  AllowedOtherCharCategories* = ctgL + ctgNd



func firstRuneIsValid (r: Rune): bool =
  r in AllowedCharOthers or r.isAlpha()


func otherRuneIsValid (r: Rune): bool =
  r in AllowedCharOthers or r.unicodeCategory() in AllowedOtherCharCategories


func checkOtherRunes (x: string; firstRuneLen: Positive): bool =
  if firstRuneLen < x.len():
    x.countValidBytes(
      seqIndexSlice(x.low() + firstRuneLen, x.high()), otherRuneIsValid
    ) == x.len() - firstRuneLen
  else:
    true


func checkRunes (x: string; firstRune: tuple[r: Rune, len: Positive]): bool =
  firstRune.r.firstRuneIsValid() and x.checkOtherRunes(firstRune.len)


func isIdentifier* (x: string): bool =
  x.len() > 0 and x.checkRunes(x.firstRune())
