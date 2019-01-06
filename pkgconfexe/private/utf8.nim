import functiontypes

import pkg/[ unicodedb ]

import std/[ sugar, unicode ]



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



##[
  Returns the number of bytes that verify the predicate ``pred``
  starting at index ``start``.
  Stops verifying as soon as the predicate is not verified.
  Returns at most ``n``.
  If``start`` is greater than ``input.high()``, returns 0.
]##
func countValidBytes* (
  input: string; start, n: Natural; pred: Predicate[Rune]
): Natural =
  if start > input.high():
    0
  else:
    (func (): Natural =
      result = 0

      while result < n:
        let r = input.runeAt(start + result)

        if result + r.size() > n or not pred(r):
          break

        result += r.size()
    )()



func skipSpaces* (input: string; start: Natural; n: Natural): Natural =
  input.countValidBytes(start, n, isSpace)


func skipSpaces* (input: string; start: Natural): Natural =
  input.skipSpaces(start, input.len())


# Skip spaces starting at ``input.low()``.
func skipSpaces* (input: string): Natural =
  input.skipSpaces(input.low())
