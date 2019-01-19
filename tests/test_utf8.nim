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



  test "firstRune":
    type TestData = tuple[data: string, expected: (Rune, Positive)]

    for it in [
      (" p", (" ".runeAt(0), 1.Positive)),
      ("=mdv", ("=".runeAt(0), 1.Positive)),
      ("éf", ("é".runeAt(0), 2.Positive))
    ].mapIt(it.TestData):
      check:
        it.data.firstRune() == it.expected



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


  test "isSpace":
    for it in [ ' ', '\t' ]:
      check:
        it.toRune().isSpace()

    for it in [ '\n', '\0', '\a', '\r' ]:
      check:
        not it.toRune().isSpace()
