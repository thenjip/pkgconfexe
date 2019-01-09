import pkg/[ unicodedb ]

import std/[ sugar ]
import std/unicode except isSpace



## The ASCII subset of Nim's char type.
type AsciiChar* = range[char.low() .. int8.high().char]



func convertRuneInfo* (x: tuple[r: Rune, len: int]): (Rune, Positive) =
  (x.r, x.len.Positive)



func firstRune* (s: string): tuple[r: Rune, len: Positive] =
  result = (Rune(-1), Positive.high())

  var i = s.low()

  s.fastRuneAt(i, result.r, true)
  result.len = i



func toRune* (c: AsciiChar): Rune =
  ($c).firstRune().r



func `==`* (r: Rune; c: AsciiChar): bool =
  r == c.toRune()


func `==`* (c: AsciiChar; r: Rune): bool =
  r == c


func `!=`* (r: Rune; c: AsciiChar): bool =
  not (r == c)


func `!=`* (c: AsciiChar; r: Rune): bool =
  r != c



func firstChar (s: string): char =
  s[s.low()]


func `in`* (r: Rune; s: set[char]): bool =
  (func (first: char): bool =
    if first > AsciiChar.high():
      false
    else:
      first in s
  )(r.toUTF8().firstChar())


func `notin`* (r: Rune; s: set[char]): bool =
  not (r in s)



func isUtf8* (x: string{lit}): bool =
  true


func isUtf8* (x: string{~lit}): bool =
  x.validateUtf8() == -1



## Unicdoe control character.
func isControl* (r: Rune): bool =
  r.unicodeCategory() == ctgCc


## We consider ``'\t'`` as a space unlike Unicode for string scanning purposes.
func isSpace* (r: Rune): bool =
  r.unicodeCategory() == ctgZs or r == '\t'
