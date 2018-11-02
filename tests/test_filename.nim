import pkgconfexe/private/filename

import std/[ os, unittest ]



suite "filename":
  test "isFileName":
    check:
      not "".isFileName()

    for f in walkFiles("*.nim*"):
      check:
        f.isFileName()

    check:
      "Zfmbkç9^`{'à’Ω§ŁÐŊª® Æħ̉̉ĸłþ¨¤؆".isFileName()

    const winFileName = "NUL"
    check:
      when defined(windows):
        not winFileName.isFileName()
      else:
        winFileName.isFileName()
