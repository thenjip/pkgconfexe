import pkgconfexe/private/[ scanhelper, utf8 ]

import pkg/[ unicodeplus ]

import std/unicode except isUpper
import std/[ sugar, unittest ]



suite "scanhelper":
  test "countValidBytes":
    type TestData = tuple
      data: tuple[
        input: string,
        start, n: Natural,
        pred: proc (r: Rune): bool {. locks: 0, nimcall, noSideEffect .}
      ]
      expected: Natural

    for it in [
      (("", 1.Natural, 3.Natural, (r: Rune) => r.isPrintable()), 0.Natural),
      (("abcd", 0.Natural, 4.Natural, (r: Rune) => r.isDigit()), 0.Natural),
      (("ALP*64dfD", 1.Natural, 8.Natural, (r: Rune) => r.isUpper()), 2.Natural)
    ]:
      (proc (it: TestData) =
        check:
          it.data.input.countValidBytes(
            it.data.start, it.data.n, it.data.pred
          ) == it.expected
      )(it)


    test "countValidBytes_const":
      const
        input = "zŋßð¶"
        n = input.countValidBytes(
          input.low() + 1, input.len() - 1, func (r: Rune): bool = true
        )

      check:
        n == input.len() - 1



  test "skipWhiteSpaces":
    type TestData = tuple[data: string, expected: Natural]

    for it in [
      ("", 0.Natural),
      ("abc", 0.Natural),
      (" abc", 1.Natural),
      (" a bc", 1.Natural),
      (" \t abc", 3.Natural),
      (" \nabc", 1.Natural)
    ]:
      (proc (it: TestData) =
        check:
          it.data.skipWhiteSpaces() == it.expected
      )(it)
