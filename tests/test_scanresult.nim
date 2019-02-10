import pkgconfexe/private/[ scanresult ]

import std/[ sugar, unittest ]



suite "scanresult":
  test "someScanResult_start&n":
    type TestData = tuple
      data: tuple[start: Natural, n: Positive]
      expected: ScanResult

    for it in [
      ((0.Natural, 1.Positive), ScanResult(start: 0, n: 1)),
      ((654891.Natural, 7.Positive), ScanResult(start: 654891, n: 7))
    ]:
      (proc (it: TestData) =
        let some = someScanResult(it.data.start, it.data.n)

        check:
          some == it.expected
          some.hasResult()
      )(it)


  test "someScanResult_slice":
    type TestData = tuple
      data: SeqIndexSlice
      expected: ScanResult

    for it in [
      (
        seqIndexSlice(198798 .. 9842613),
        ScanResult(start: 198798, n: len(198798 .. 9842613))
      ),
      (seqIndexSlice(0, 1), ScanResult(start: 0, n: 1))
    ]:
      (proc (it: TestData) =
        let some = someScanResult(it.data)

        check:
          some == it.expected
          some.hasResult()
      )(it)


  test "emptyScanResult":
    type TestData = tuple
      data: Natural
      expected: ScanResult

    for it in [
      (0.Natural, ScanResult(start: 0, n: 0)),
      (12.Natural, ScanResult(start: 12, n: 0))
    ]:
      (proc (it: TestData) =
        let empty = emptyScanResult(it.data)

        check:
          empty == it.expected
          not empty.hasResult()
      )(it)



  test "doIfHasResult":
    (proc () =
      var checked = false
      const empty = emptyScanResult(0)

      empty.doIfHasResult(
        proc (sr: ScanResult) = discard,
        proc (sr: ScanResult) =
          checked = true

          check:
            sr == empty
      )

      check:
        checked
    )()

    (proc () =
      var checked = false
      const some = someScanResult(5, 8)

      some.doIfHasResult(
        proc (sr: ScanResult) =
          checked = true

          check:
            sr == some
        ,
        proc (sr: ScanResult) = discard
      )

      check:
        checked
    )()

  (proc () =
    var checked = false
    const
      some = someScanResult(64321, 86)
      someSlice = seqIndexSlice(some.start, some.n)

    some.doIfHasResult(
      proc (slice: SeqIndexSlice) =
        checked = true

        check:
          slice == someSlice
      ,
      proc (sr: ScanResult) = discard
    )

    check:
      checked
  )()



  test "ifHasResult":
    check:
      emptyScanResult(1).ifHasResult(
        (sr: ScanResult) => false, (sr: ScanResult) => true
      )
      someScanResult(98, 5).ifHasResult(
        (sr: ScanResult) => sr == someScanResult(98, 5),
        (sr: ScanResult) => false
      )
      someScanResult(16, 2).ifHasResult(
        (slice: SeqIndexSlice) => slice,
        (sr: ScanResult) => 1.Natural .. 0.Natural
      ).len() > 0



  test "flatMapOr":
    check:
      not emptyScanResult(0).flatMapOr(
        (slice: SeqIndexSlice) => someScanResult(0, 1),
        (sr: ScanResult) => sr
      ).hasResult()

      emptyScanResult(9).flatMapOr(
        (sr: ScanResult) => sr,
        (sr: ScanResult) => someScanResult(64, 1)
      ).hasResult()

      someScanResult(7, 4).flatMapOr(
        (sr: ScanResult) => someScanResult(sr.start + sr.n, 1),
        (sr: ScanResult) => someScanResult(0, 5)
      ) == someScanResult(11, 1)



  test "flatMap":
    check:
      not emptyScanResult(1).flatMap(
        (slice: SeqIndexSlice) => someScanResult(slice),
      ).hasResult()

      someScanResult(76, 6).flatMap(
        (slice: SeqIndexSlice) => someScanResult(slice),
      ) == someScanResult(76, 6)



  test "flatMap_const":
    const
      sr = someScanResult(0, 1).flatMap((sr: ScanResult) => sr)
      srSlice = someScanResult(0, 1).flatMap(
        (slice: SeqIndexSlice) => someScanResult(slice)
      )

    check:
      srSlice == sr
