import pkgconfexe/private/identifier

import std/unittest



suite "identifier":
  test "isIdentifier":
    for input in [
      "_", "_é", "ù1", "_1", "a3ë", "CC", "SOME_ENV_VAR", "_ANOTHER"
    ]:
      check:
        input.isIdentifier()

    for input in [ "1a", "-v", "ŋ-a" ]:
      check:
        not input.isIdentifier()
