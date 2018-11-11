import pkgconfexe/private/fphelper

import std/unittest



type Direction = enum
  north
  east
  south
  west



const
  AllDirectionSet = setOfAll(Direction)
  AllDirectionSeq = seqOfAll(Direction)



suite "fphelper":
  test "setOfAll":
    check:
      AllDirectionSet == { Direction.low()..Direction.high() }
      AllDirectionSet - { west } ==
        { Direction.low()..Direction.high() } - { west }


  test "seqOfAll":
    check:
      AllDirectionSeq == @[ north, east, south, west ]
      AllDirectionSeq != @[ east, south, west, north ]
      seqOfAll(east..south) == @[ east, south ]


  test "callZFunc":
    check:
      compiles(AllDirectionSeq.callZFunc(map(it)).len() == 4)
      compiles(AllDirectionSet.callZFunc(map(it)).len() == 4)
