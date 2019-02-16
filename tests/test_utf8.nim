import pkgconfexe/private/[ utf8 ]

import pkg/[ unicodeplus ]

import std/unicode except isUpper
import std/[ sequtils, unittest ]



suite "utf8":
  test "AsciiChar":
    for it in [ '\127', '\x03', '\0', '\t', '6' ]:
      check:
        it in { AsciiChar.low() .. AsciiChar.high() }
    for it in [ '\xff', '\x80', '\x9A' ]:
      check:
        it isnot AsciiChar


  test "toRune":
    type TestData = tuple[data: AsciiChar, expected: Rune]

    for it in [
      ('0'.AsciiChar, "0".runeAt(0)),
      ('\127'.AsciiChar, ($'\127').runeAt(0)),
      ('\n'.AsciiChar, ($'\n').runeAt(0))
    ]:
      (proc (it: TestData) =
        check:
          it.data.toRune() == it.expected
      )(it)



  test "runeInfoAt":
    type TestData = tuple[data: string, index: Natural, expected: RuneInfo]

    for it in [
      ("dqacl", 3.Natural, ("c".runeAt(0), 1.Positive)),
      ("=mdv", 0.Natural, ("=".runeAt(0), 1.Positive)),
      ("ħéf", "ħ".len().Natural, ("é".runeAt(0), "é".runeLenAt(0).Positive))
    ]:
      (proc (it: TestData) =
        check:
          it.data.runeInfoAt(it.index) == it.expected
      )(it)


  test "firstRuneInfo":
    type TestData = tuple[data: string, expected: RuneInfo]

    for it in [
      (" p", (" ".runeAt(0), 1.Positive)),
      ("=mdv", ("=".runeAt(0), 1.Positive)),
      ("éf", ("é".runeAt(0), 2.Positive))
    ]:
      (proc (it: TestData) =
        check:
          it.data.firstRuneInfo() == it.expected
      )(it)



  test "RuneEqualsChar":
    const
      SomeString = "a"
      SomeRune = SomeString.runeAt(SomeString.low())

    check:
      'a' == SomeRune
      'b' != SomeRune
      ('a' != SomeRune) == (SomeRune != 'a')
      ('b' != SomeRune) == (SomeRune != 'b')


  test "RuneInCharSet":
    const SomeCharSet = { 'a'..'z' }

    for it in SomeCharSet:
      check:
        it.toRune() in SomeCharSet



  test "isUtf8":
    const SomeStr = "æþ“¢ß@µŋøŧħ←đ»ŋħß“#{`|'àdop*µ §^ïŁªÐΩ§ºŁª¢§Ω§ÐÐŦ¥↑ØÞ®©‘’"
    check:
      SomeStr.isUtf8()



  test "isControl":
    for it in [ '\n', '\0', '\a', '\r', '\t' ]:
      check:
        it.toRune().isControl()

    for it in [ 'a', ' ', '1', '\\' ]:
      check:
        not it.toRune().isControl()


  test "isWhiteSpaceOrTab":
    for it in [ ' ', '\t' ]:
      check:
        it.toRune().isWhiteSpaceOrTab()

    for it in [ '\n', '\0', '\a', '\r' ]:
      check:
        not it.toRune().isWhiteSpaceOrTab()


  test "isWhiteSpaceOrTab_const":
    const
      valid_results = [ ' ', '\t' ].mapIt(it.toRune().isWhiteSpaceOrTab())
      invalid_results = [ '\n', '\0', '\a', '\r' ].mapIt(
        it.toRune().isWhiteSpaceOrTab()
      )

    for r in valid_results:
      check:
        r

    for r in invalid_results:
      check:
        not r


  test "isEmptyOrBlank":
    for it in [ "", " ", "\t \t\n" ]:
      check:
        it.isEmptyOrBlank()

    for it in [ " a", "\na  " ]:
      check:
        not it.isEmptyOrBlank()


  test "joinWithSpaces":
    type TestData = tuple
      expected: string
      actual: string

    for it in [
      ("abc", [ "", "abc", "\n" ].joinWithSpaces()),
      ("f gh", [ "f", "", " ", "gh", "\t " ].joinWithSpaces())
    ]:
      (proc (it: TestData) =
        check:
          it.expected == it.actual
      )(it)
