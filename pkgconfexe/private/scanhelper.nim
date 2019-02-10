import utf8

import std/[ unicode ]



iterator runesWithLen (s: string; start, nMax: Natural): RuneInfo =
  var i = start

  while i < s.len() and i < start + nMax:
    let result = s.runeInfoAt(i)
    i += result.len
    yield result


iterator runesWithLen (s: string; start: Natural): RuneInfo =
  var i = start

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
  input: string;
  start, nMax: Natural;
  pred: proc (r: Rune): bool {. locks: 0, noSideEffect .}
): Natural =
  result = 0

  for ri in input.runesWithLen(start, nMax):
    if not pred(ri.r):
      break

    result += ri.len


func countValidBytes* (
  input: string;
  start: Natural;
  pred: proc (r: Rune): bool {. locks: 0, noSideEffect .}
): Natural =
  result = 0

  for ri in input.runesWithLen(start):
    if not pred(ri.r):
      break

    result += ri.len


func countValidBytes* (
  input: string; pred: proc (r: Rune): bool {. locks: 0, noSideEffect .}
): Natural =
  input.countValidBytes(input.low(), pred)



func skipWhiteSpaces* (input: string; start: Natural; nMax: Natural): Natural =
  input.countValidBytes(start, nMax, isWhiteSpaceOrTab)


func skipWhiteSpaces* (input: string; start: Natural): Natural =
  input.skipWhiteSpaces(start, input.len() - start)


# Skip spaces starting at ``input.low()``.
func skipWhiteSpaces* (input: string): Natural =
  input.skipWhiteSpaces(input.low())
