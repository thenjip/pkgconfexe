import pkgconfexe/private/utf8

import std/[ strscans, unicode, unittest ]



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

    for c in SomeCharSet:
      let c_str = $c
      check(c_str.runeAt(c_str.low()) in SomeCharSet)

    const NotInStr = "è"
    check(NotInStr.runeAt(NotInStr.low()) notin SomeCharSet)


  test "isUtf8":
    const SomeStr = "æþ“¢ß@µŋøŧħ←đ»ŋħß“#{`|'àdop*µ §^ïŁªÐΩ§ºŁª¢§Ω§ÐÐŦ¥↑ØÞ®©‘’"
    check(SomeStr.isUtf8())


  test "skipWhiteSpaces":
    const Input = " \n\t "
    check(Input.skipWhiteSpaces(Input.low()) == Input.len())
