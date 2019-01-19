import pkgconfexe/[ comparator ]
import pkgconfexe/private/[ scanresult, seqindexslice ]

import std/[ options, unicode, sequtils, unittest ]



const SomeInvalidComparators = [ "=", "& ", "++", "-", "^" ]



suite "comparator":
  test "isComparator":
    for c in Comparator:
      check:
        ($c).isComparator()

    for c in SomeInvalidComparators:
      check:
        not c.isComparator()



  test "option":
    for c in Comparator:
      check:
        c.option() == ComparatorOptions[c]



  test "scanComparator":
    (proc () =
      for it in [ "", "ép>=" ]:
        let scanResult = it.scanComparator()

        check:
          not scanResult.hasResult()
    )()

    type TestData = tuple
      input: string
      start: int
      expected: Comparator

    for it in [
      ("==3.0", 0, Comparator.Equal), ("g<=µ", 1, Comparator.LessEq)
    ].mapIt(it.TestData):
      let
        scanResult = it.input.scanComparator(it.start)
        slicedIn = it.input[seqIndexSlice(scanResult.start, scanResult.n)]

      check:
        scanResult.hasResult()
        slicedIn.isComparator()
        slicedIn.findComparator().get() == it.expected
