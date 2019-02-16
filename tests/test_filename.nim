import pkgconfexe/private/[ filename ]

import std/[ os, sequtils, unittest ]



suite "filename":
  test "isFileName":
    check:
      not "".isFileName()
      "Zfmbkç9^`{'à’Ω§ŁÐŊª® Æħ̉̉ĸłþ¨¤؆".isFileName()

    for f in toSeq("*".walkFiles()):
      echo f
      check:
        f.isFileName()

    const winFileName = "NUL"

    check:
      (func (isFile: bool): bool =
        when defined(windows):
          not isFile
        else:
          isFile
      )(winFileName.isFileName())



  test "isFileName_const":
    const valid = "é_àk".isFileName()

    check:
      valid
