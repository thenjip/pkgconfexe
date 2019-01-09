import pkgconfexe/private/[ scanhelper, utf8 ]

import pkg/[ unicodeplus, zero_functional ]

import std/unicode except isUpper
import std/[ unittest ]



test "countValidBytes":
  type TestData = tuple
    data: tuple[
      input: string,
      start, n: int,
      pred: func (r: Rune): bool {. nimcall .}
    ]
    expected: Natural

  [
    (("", 1, 3, func (r: Rune): bool = r.isSpace()), 0.Natural),
    (("abcd", 0, 4, func (r: Rune): bool = r.isDigit()), 0.Natural),
    (("ALP*64dfD", 1, 8, func (r: Rune): bool = r.isUpper()), 2.Natural)
  ].zfun:
    map:
      it.TestData
    foreach:
      check:
        it.data.input.countValidBytes(
          it.data.start.Natural, it.data.n.Natural, it.data.pred
        ) == it.expected

  (proc () =
    const
      input = "zŋßð¶"
      n = input.countValidBytes(
        input.low() + 1, input.len() - 1, func (r: Rune): bool = true
      )

    check:
      n == input.len() - 1
  )()



test "skipSpaces":
  type TestData = tuple[data: string, expected: Natural]

  [
    ("", 0.Natural),
    ("abc", 0.Natural),
    (" abc", 1.Natural),
    (" a bc", 1.Natural),
    (" \t abc", 3.Natural),
    (" \nabc", 1.Natural)
  ].zfun:
    map:
      it.TestData
    foreach:
      check:
        it.data.skipSpaces() == it.expected
