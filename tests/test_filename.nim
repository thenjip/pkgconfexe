import pkgconfexe/private/[ filename ]

import pkg/[ zero_functional ]

import std/[ os, sequtils, unittest ]



suite "filename":
  test "isFileName":
    check:
      not "".isFileName()
      "Zfmbkç9^`{'à’Ω§ŁÐŊª® Æħ̉̉ĸłþ¨¤؆".isFileName()

    let files = toSeq("*".walkFiles())

    files.zfun:
      foreach:
        echo it
        check:
          it.isFileName()

    const winFileName = "NUL"
    when defined(windows):
      check:
        not winFileName.isFileName()
    else:
      check:
        winFileName.isFileName()
