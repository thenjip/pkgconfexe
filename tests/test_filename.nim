import pkgconfexe/private/[ filename, fphelper ]

import pkg/zero_functional

import std/[ os, macros, sequtils, unittest ]



suite "filename":
  test "isFileName":
    check:
      not "".isFileName()
      "Zfmbkç9^`{'à’Ω§ŁÐŊª® Æħ̉̉ĸłþ¨¤؆".isFileName()

    toSeq("*.nim*".walkFiles()).zfun:
      foreach:
        check:
          it.isFileName()

    const winFileName = "NUL"
    check:
      when defined(windows):
        not winFileName.isFileName()
      else:
        winFileName.isFileName()
