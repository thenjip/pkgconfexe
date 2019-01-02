import pkgconfexe/private/[ zfunchelper ]

import std/[ unittest ]



suite "fphelper":
  test "zeroFunc":
    type Direction = enum
      north, east, south, west

    check:
      compiles(Direction.zeroFunc(map(it)).len() == 4)
