import std/[ ospaths, unittest ]

import pkgconfexe/private/path



suite "path":
  test "isPath":
    check(unixToNativePath("$PWD/../.").isPath())
