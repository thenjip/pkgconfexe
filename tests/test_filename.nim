import pkgconfexe/private/[ filename, fphelper ]

import pkg/zero_functional

import std/[ os, macros, unittest ]



suite "filename":
  test "isFileName":
    check:
      not "".isFileName()
      "Zfmbkç9^`{'à’Ω§ŁÐŊª® Æħ̉̉ĸłþ¨¤؆".isFileName()

    seqOf(walkFiles("*.nim*")).zfun:
      foreach:
        check:
          it.isFileName()

    const winFileName = "NUL"
    check:
      when defined(windows):
        not winFileName.isFileName()
      else:
        winFileName.isFileName()
