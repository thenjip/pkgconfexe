import utf8

import std/unicode except isSpace



##[
  Returns the number of bytes that verify the predicate ``pred``
  starting at index ``start``.
  Stops verifying as soon as the predicate is not verified.
  Returns at most ``n``.
  If``start`` is greater than ``input.high()``, returns 0.
]##
func countValidBytes* (
  input: string; start, n: Natural; pred: func (r: Rune): bool {. nimcall .}
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
