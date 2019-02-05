import pkg/[ unicodedb ]

import std/unicode except isSpace




type
  ## The ASCII subset of Nim's char type.
  AsciiChar* = range[char.low() .. int8.high().char]

  RuneInfo* = tuple
    r: Rune
    len: Positive



func toRune* (c: AsciiChar): Rune =
  (func (s: string): auto =
    s.runeAt(s.low())
  )($c)



func convertRuneInfo* (x: tuple[r: Rune, len: int]): RuneInfo =
  (x.r, x.len.Positive)



func runeInfoAt* (s: string; i: Natural): RuneInfo =
  result = (r: Rune(-1), len: result.len.type().high())
  var index = i

  s.fastRuneAt(index, result.r, true)
  result.len = index - i


func firstRuneInfo* (s: string): RuneInfo =
  s.runeInfoAt(s.low())



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
