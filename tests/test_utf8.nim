import pkgconfexe/private/[ utf8 ]

import pkg/[ zero_functional ]

import std/[ unicode, unittest ]



suite "utf8":
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
          ($it).runeAt(0) in SomeCharSet

    const NotInStr = "è"
    check:
      NotInStr.runeAt(NotInStr.low()) notin SomeCharSet


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


  test "skipWhiteSpaces":
    [
      ("", 0),
      ("abc", 0),
      (" abc", 1),
      (" a bc", 1),
      (" \t abc", 3),
      (" \nabc", 1)
    ].zfun:
      foreach:
        check:
          it[0].skipSpaces() == it[1]
