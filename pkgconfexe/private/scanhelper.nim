import utf8

import std/unicode except isSpace, runeAt



iterator runesWithLen* (s: string): RuneInfo =
  var i = 0.Natural

  while i < s.len():
    let result = s.runeInfoAt(i)
    i += result.len
    yield result



##[
  Returns the number of bytes that verify the predicate ``pred``
  starting at index ``start``.
  Stops verifying as soon as the predicate is not verified.
  Returns at most ``n``.
  If``start`` is greater than ``input.high()``, returns 0.
]##
func countValidBytes* (
  input: string; start, nMax: Natural; pred: func (r: Rune): bool
): Natural =
  if start > input.high():
    0
  else:
    (func (): result.type() =
      result = 0

      for ri in input.runesWithLen():
        if not pred(ri.r):
          break

        result += ri.len
    )()


func countValidBytes* (
  input: string; start: Natural; pred: func (r: Rune): bool
): Natural =
  input.countValidBytes(start, input.len() - start, pred)



func skipSpaces* (input: string; start: Natural; nMax: Natural): Natural =
  input.countValidBytes(start, nMax, isSpace)


func skipSpaces* (input: string; start: Natural): Natural =
  input.skipSpaces(start, input.len() - start)


# Skip spaces starting at ``input.low()``.
func skipSpaces* (input: string): Natural =
  input.skipSpaces(input.low())
