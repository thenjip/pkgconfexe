when nimvm:
  import std/[ sets ]
else:
  import pkg/[ unicodedb ]

import std/[ sequtils, strutils, unicode ]




type
  ## The ASCII subset of Nim's char type.
  AsciiChar* = range[char.low() .. int8.high().char]

  RuneInfo* = tuple
    r: Rune
    len: Positive



func toRune* (c: AsciiChar): Rune =
  (func (s: string): Rune =
    s.runeAt(s.low())
  )($c)



when nimvm:
  const
    ControlCharSet = { '\x00' .. '\x1F', '\x7F', '\x80' .. '\x9F' }

    WhiteSpaceCharSet = toSet[Rune](
      @[ ' '.toRune(), 0x00A0.Rune, 0x1680.Rune ] &
        (func (): seq[Rune] =
          const slice = 0x2000 .. 0x200A
          result = newSeqOfCap[Rune](slice.len())

          for it in slice:
            result.add(it.Rune)
        )() &
        @[ 0x202F.Rune, 0x205F.Rune, 0x3000.Rune ]
    )
else:
  discard



func convertRuneInfo* [I: SomeInteger and not Positive](
  x: tuple[r: Rune, len: I]
): RuneInfo =
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
    first <= AsciiChar.high() and first in s
  )(r.toUTF8().firstChar())


func `notin`* (r: Rune; s: set[char]): bool =
  not (r in s)



func isUtf8* (x: string{lit}): bool =
  true


func isUtf8* (x: string{~lit}): bool =
  x.validateUtf8() == -1



## Unicdoe control character.
func isControl* (r: Rune): bool =
  when nimvm:
    r in ControlCharSet
  else:
    r.unicodeCategory() == ctgCc


func isUnicodeWhiteSpace* (r: Rune): bool =
  when nimvm:
    r in WhiteSpaceCharSet
  else:
    r.unicodeCategory() == ctgZs


func isWhiteSpaceOrTab* (r: Rune): bool =
  r.isUnicodeWhiteSpace() or r == '\t'


func isNumber* (r: Rune): bool =
  when nimvm:
    ($r).firstChar().isDigit()
  else:
    r.unicodeCategory() in ctgN



func isBlank (s: string): bool =
  result = true

  for r in s.runes():
    if not r.isWhiteSpace():
      return false


## Empty or filled with Unicode whitespaces.
func isEmptyOrBlank* (s: string): bool =
  s.len() == 0 or s.isBlank()


func joinWithSpaces* (a: openarray[string]): string =
  a.filterIt(not it.isEmptyOrBlank()).join($' ')
