import fphelper

import pkg/[ unicodedb, zero_functional ]

import std/unicode



func toRune* (c: char): Rune {. locks: 0 .} =
  let str = $c
  result = str.runeAt(str.low())



func `==`* (r: Rune; c: char): bool {. locks: 0 .} =
  let str = $c
  result = r == str.runeAt(str.low())


func `==`* (c: char; r: Rune): bool {. locks: 0 .} =
  result = r == c


func `!=`* (r: Rune; c: char): bool {. locks: 0 .} =
  result = not (r == c)


func `!=`* (c: char; r: Rune): bool {. locks: 0 .} =
  result = r != c



func `in`* (r: Rune; s: set[char]): bool {. locks: 0 .} =
  let str = $r
  result = str[str.low()] in s


func `notin`* (r: Rune; s: set[char]): bool {. locks: 0 .} =
  result = not (r in s)



func isUtf8* (x: string{lit}): bool {. locks: 0 .} =
  result = true


func isUtf8* (x: string{~lit}): bool {. locks: 0 .} =
  result = x.validateUtf8() == -1



func skipSpaces* (input: string; start: Natural): Natural {. locks: 0 .} =
  result =
    input[start .. input.high()].toRunes().callZFunc(
      takeWhile(it.unicodeCategory() == ctgZs)
    ).len()


func skipSpaces* (input: string): Natural {. locks: 0 .} =
  result = input.skipSpaces(input.low())
