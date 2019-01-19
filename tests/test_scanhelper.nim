import pkgconfexe/private/[ scanhelper, utf8 ]

import pkg/[ unicodeplus ]

import std/unicode except isUpper
import std/[ sequtils, sugar, unittest ]



suite "scanhelper":
  test "countValidBytes":
    type TestData = tuple
      data: tuple[
        input: string,
        start, n: int,
        pred: func (r: Rune): bool {. nimcall .}
      ]
      expected: Natural

    for it in [
      (("", 1, 3, (r: Rune) => r.isSpace()), 0.Natural),
      (("abcd", 0, 4, (r: Rune) => r.isDigit()), 0.Natural),
      (("ALP*64dfD", 1, 8, (r: Rune) => r.isUpper()), 2.Natural)
    ].mapIt(it.TestData):
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

    for it in [
      ("", 0.Natural),
      ("abc", 0.Natural),
      (" abc", 1.Natural),
      (" a bc", 1.Natural),
      (" \t abc", 3.Natural),
      (" \nabc", 1.Natural)
    ].mapIt(it.TestData):
      check:
        it.data.skipSpaces() == it.expected
