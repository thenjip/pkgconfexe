import std/[ os, unittest ]

import pkgconfexe/private/filename



suite "filename":
  test "isFileName":
    check(not "".isFileName())

    for f in walkFiles("*.nim*"):
      check(f.isFileName())

    check("Zfmbkç9^`{'à’Ω§ŁÐŊª® Æħ̉̉ĸłþ¨¤؆".isFileName())

    const winFileName = "NUL"
    when defined(windows):
      check(not winFileName.isFileName())
    else:
      check(winFileName.isFileName())
