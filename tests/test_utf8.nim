import pkgconfexe/private/[ utf8 ]

import pkg/[ unicodeplus, zero_functional ]

import std/unicode except isUpper
import std/[ unittest ]



suite "utf8":
  test "AsciiChar":
    [ '\127', '\x03', '\0', '\t', '6' ].zfun:
      foreach:
        check:
          it in { AsciiChar.low() .. AsciiChar.high() }
    [ '\xff', '\x80', '\x9A' ].zfun:
      foreach:
        check:
          it isnot AsciiChar



  test "firstRune":
    type TestData = tuple[data: string, expected: (Rune, Positive)]

    [
      (" p", (" ".runeAt(0), 1.Positive)),
      ("=mdv", ("=".runeAt(0), 1.Positive)),
      ("éf", ("é".runeAt(0), 2.Positive))
    ].zfun:
      map:
        it.TestData
      foreach:
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

    SomeCharSet.zfun:
      foreach:
        check:
          it.toRune() in SomeCharSet



  test "isUtf8":
    const SomeStr = "æþ“¢ß@µŋøŧħ←đ»ŋħß“#{`|'àdop*µ §^ïŁªÐΩ§ºŁª¢§Ω§ÐÐŦ¥↑ØÞ®©‘’"
    check:
      SomeStr.isUtf8()



  test "isControl":
    [ '\n', '\0', '\a', '\r', '\t' ].zfun:
      foreach:
        check:
          it.toRune().isControl()

    [ 'a', ' ', '1', '\\' ].zfun:
      foreach:
        check:
          not it.toRune().isControl()


  test "isSpace":
    [ ' ', '\t' ].zfun:
      foreach:
        check:
          it.toRune().isSpace()

    [ '\n', '\0', '\a', '\r' ].zfun:
      foreach:
        check:
          not it.toRune().isSpace()
