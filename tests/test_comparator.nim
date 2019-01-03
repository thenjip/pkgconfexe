import pkgconfexe/[ comparator ]
import pkgconfexe/private/[ scanresult, seqindexslice ]

import pkg/[ zero_functional ]

import std/[ tables, unicode, unittest ]



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
    [ "", "ép>=" ].zfun:
      foreach:
        let optScanResult = it.scanComparator()

        check:
          optScanResult.isNone()

    [ "==3.0", "<=µ" ].zfun:
      foreach:
        let
          slice = seqIndexSlice(it.low(), ComparatorNChars.Positive)
          expected = ComparatorMap[it[slice].toRunes()]
          optScanResult = it.scanComparator()

        check:
          optScanResult.isSome()
          it[optScanResult.unsafeGet().slice()] == it[slice]
          optScanResult.unsafeGet().value() == expected
