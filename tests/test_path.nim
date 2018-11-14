import pkgconfexe/private/path

import pkg/zero_functional

import std/[ ospaths, unittest ]



suite "path":
  test "isPath":
    [ "$PWD"/".."/".", ""/"usr" ].zfun:
      foreach:
        check:
          it.isPath()

    [ "\0"/"abc" ].zfun:
      foreach:
        check:
          not it.isPath()
