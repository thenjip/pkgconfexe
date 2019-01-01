import pkgconfexe/private/[ identifier ]

import pkg/[ zero_functional ]

import std/[ unittest ]



suite "identifier":
  test "isIdentifier":
    [ "_", "_é", "ù1", "_1", "a3ë", "CC", "SOME_ENV_VAR", "_ANOTHER"].zfun:
      foreach:
        check:
          it.isIdentifier()

    [ "1a", "-v", "ŋ-a" ].zfun:
      foreach:
        check:
          not it.isIdentifier()
