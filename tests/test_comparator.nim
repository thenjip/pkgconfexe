import pkgconfexe/[ comparator ]
import pkgconfexe/private/[ scanresult, seqindexslice ]

import pkg/[ zero_functional ]

import std/[ options, unicode, unittest ]



const SomeInvalidComparators = [ "=", "& ", "++", "-", "^" ]



suite "comparator":
  test "isComparator":
    Comparator.zfun:
      foreach:
        check:
          ($it).isComparator()

    SomeInvalidComparators.zfun:
      foreach:
        check:
          not it.isComparator()



  test "option":
    Comparator.zfun:
      foreach:
        check:
          it.option() == ComparatorOptions[it]



  test "scanComparator":
    (proc () =
      [ "", "ép>=" ].zfun:
        foreach:
          let scanResult = it.scanComparator()

          check:
            not scanResult.hasResult()
    )()

    type TestData = tuple
      input: string
      start: int
      expected: Comparator

    [ ("==3.0", 0, Comparator.Equal), ("g<=µ", 1, Comparator.LessEq) ].zfun:
      map:
        it.TestData
      foreach:
        let
          scanResult = it.input.scanComparator(it.start)
          slicedIn = it.input[seqIndexSlice(scanResult.start, scanResult.n)]

        check:
          scanResult.hasResult()
          slicedIn.isComparator()
          slicedIn.findComparator().get() == it.expected
