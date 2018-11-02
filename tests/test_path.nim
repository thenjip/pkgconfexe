import pkgconfexe/private/path

import std/[ ospaths, unittest ]



suite "path":
  test "isPath":
    check:
      unixToNativePath("$PWD/../.").isPath()
