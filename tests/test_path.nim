import pkgconfexe/private/path

import std/[ ospaths, unittest ]



suite "path":
  test "isPath":
    check:
      "$PWD/../.".unixToNativePath().isPath()
      not "\0/abc".unixToNativePath().isPath()
