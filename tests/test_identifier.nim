import pkgconfexe/private/identifier

import std/[ sequtils, unittest ]



suite "identifier":
  test "isIdentifier":
    check:
      [ "_", "_é", "ù1", "_1", "a3ë", "CC" ].allIt(it.isIdentifier())
      [ "1a", "-v", "ŋ-a" ].allIt(not it.isIdentifier())
