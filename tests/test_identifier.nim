import pkgconfexe/private/[ identifier ]

import std/[ unittest ]



suite "identifier":
  test "isIdentifier":
    for it in [
      "_", "_é", "ù1", "_1", "a3ë", "CC", "SOME_ENV_VAR", "_ANOTHER"
    ]:
      check:
        it.isIdentifier()

    for it in [ "1a", "-v", "ŋ-a" ]:
      check:
        not it.isIdentifier()



  test "isIdentifier_const":
    const valid = "CFLAGS".isIdentifier()

    check:
      valid
