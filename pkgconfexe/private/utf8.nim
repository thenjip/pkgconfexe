import zfunchelper

import pkg/[ unicodedb, zero_functional ]

import std/[ unicode ]



func firstRune* (s: string): Rune {. locks: 0 .} =
  s.runeAt(s.low())


func toRune* (c: char): Rune {. locks: 0 .} =
  ($c).firstRune()



func `==`* (r: Rune; c: char): bool {. locks: 0 .} =
  r == ($c).firstRune()


func `==`* (c: char; r: Rune): bool {. locks: 0 .} =
  r == c


func `!=`* (r: Rune; c: char): bool {. locks: 0 .} =
  not (r == c)


func `!=`* (c: char; r: Rune): bool {. locks: 0 .} =
  r != c



func firstChar (s: string): char {. locks: 0 .} =
  s[s.low()]


func `in`* (r: Rune; s: set[char]): bool {. locks: 0 .} =
  r.toUTF8().firstChar() in s


func `notin`* (r: Rune; s: set[char]): bool {. locks: 0 .} =
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



func skipSpaces* (input: string; start: Natural): Natural {. locks: 0 .} =
  if start >= input.len():
    0
  else:
    input[start .. input.high()].toRunes().zeroFunc(
      takeWhile(it.isSpace())
    ).`$`().len()


# Skip spaces starting at ``input.low()``.
func skipSpaces* (input: string): Natural {. locks: 0 .} =
  input.skipSpaces(input.low())
