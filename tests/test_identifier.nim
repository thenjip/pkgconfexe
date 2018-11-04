import pkgconfexe/private/identifier

import pkg/zero_functional

import std/[ sequtils, unittest ]



suite "identifier":
  test "isIdentifier":
    check:
      [ "_", "_é", "ù1", "_1", "a3ë", "CC" ]-->all(it.isIdentifier())
      [ "1a", "-v", "ŋ-a" ]-->all(not it.isIdentifier())
      [ "SOME_ENV_VAR", "_ANOTHER" ]-->all(it.isIdentifier())
