import pkgconfexe/private/fphelper

import std/unittest



type Direction = enum
  north
  east
  south
  west



suite "enum2seq":
  test "seqOfAll":
    const AllDirections = Direction.seqOfAll()

    check:
      AllDirections == @[ north, east, south, west ]
      AllDirections != @[ east, south, west, north ]
