import functiontypes, scanresult

import pkg/[ unicodedb ]

import std/[ unicode ]



## The ASCII subset of Nim's char type.
type AsciiChar* = range[char.low() .. int8.high().char]



func convertRuneInfo* (x: tuple[r: Rune, len: int]): (Rune, Positive) {.
  locks: 0
.} =
  (x.r, x.len.Positive)



func firstRune* (s: string): tuple[r: Rune, len: Positive] {. locks: 0 .} =
  var i = s.low()

  s.fastRuneAt(i, result.r, true)
  result.len = i



func toRune* (c: AsciiChar): Rune {. locks: 0 .} =
  ($c).firstRune().r



func `==`* (r: Rune; c: AsciiChar): bool {. locks: 0 .} =
  r == c.toRune()


func `==`* (c: AsciiChar; r: Rune): bool {. locks: 0 .} =
  r == c


func `!=`* (r: Rune; c: AsciiChar): bool {. locks: 0 .} =
  not (r == c)


func `!=`* (c: AsciiChar; r: Rune): bool {. locks: 0 .} =
  r != c



func firstChar (s: string): char {. locks: 0 .} =
  s[s.low()]


func `in`* (r: Rune; s: set[AsciiChar]): bool {. locks: 0 .} =
  r.toUTF8().firstChar() in s


func `notin`* (r: Rune; s: set[AsciiChar]): bool {. locks: 0 .} =
  not (r in s)



func isUtf8* (x: string{lit}): bool {. locks: 0 .} =
  true


func isUtf8* (x: string{~lit}): bool {. locks: 0 .} =
  x.validateUtf8() == -1



## Unicdoe control character.
func isControl* (r: Rune): bool {. locks: 0 .} =
  r.unicodeCategory() == ctgCc


## We consider ``'\t'`` as a space unlike Unicode for string scanning purposes.
func isSpace* (r: Rune): bool {. locks: 0 .} =
  r.unicodeCategory() == ctgZs or r == '\t'



##[
  Returns the number of bytes that verify predicate ``pred``
  starting at index ``slice.a``.
  Stops verifying as soon as the predicate is not verified.
  One or more bytes are taken when verifying the predicate.
]##
func countValidBytes* (
  input: string; slice: SeqIndexSlice; pred: Predicate[Rune]
): Natural {. locks: 0 .} =
  result = slice.a

  while result < slice.len():
    let r = input.runeAt(result)

    if not r.pred():
      break

    result += r.size()

  result -= slice.a



func skipSpaces* (input: string; start: Natural): Natural {. locks: 0 .} =
  if input.len() > 0:
    input.countValidBytes(start .. input.high().Natural, isSpace)
  else:
    0


# Skip spaces starting at ``input.low()``.
func skipSpaces* (input: string): Natural {. locks: 0 .} =
  input.skipSpaces(input.low())
