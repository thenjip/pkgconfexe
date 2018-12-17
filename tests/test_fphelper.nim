import pkgconfexe/private/fphelper

import pkg/zero_functional

import std/unittest



type Direction = enum
  north
  east
  south
  west



suite "fphelper":
  test "callZFunc":
    check:
      compiles(Direction.callZFunc(map(it)).len() == 4)
