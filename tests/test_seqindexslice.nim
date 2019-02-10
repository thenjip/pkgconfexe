import pkgconfexe/private/[ seqindexslice ]

import std/[ unittest ]



suite "seqindexslice":
  test "constructor_start&n":
    type TestData = tuple
      data: tuple[start: Natural, n: Positive]
      expected: SeqIndexSlice

    for it in [
      ((0.Natural, 1.Positive), 0.Natural .. 0.Natural),
      ((56184.Natural, 25.Positive), 56184.Natural .. 56208.Natural)
    ]:
      (proc (it: TestData) =
        check:
          seqIndexSlice(it.data.start, it.data.n) == it.expected
      )(it)


  test "constructor_slice":
    check:
      seqIndexSlice(0 .. 0) == 0.Natural .. 0.Natural
      seqIndexSlice(1981.uint16 .. 6489.int) == 1981.Natural .. 6489.Natural

    expect RangeError:
      discard seqIndexSlice(3 .. 2)
