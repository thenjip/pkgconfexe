import pkgconfexe/comparator

import pkg/zero_functional

import std/[ unicode, unittest ]



const SomeInvalidComparators = [ "=", "&", "+", "-", "^" ]



suite "comparator":
  test "isComparator":
    AllComparators.zfun:
      foreach:
        check:
          ($it).isComparator()

    SomeInvalidComparators.zfun:
      foreach:
        check:
          not it.isComparator()


  test "option":
    AllComparators.zfun:
      foreach:
        check:
          it.option() == ComparatorOptions[it]


  test "comparator":
    SomeInvalidComparators.zfun:
      foreach:
        expect ValueError:
          let c = it.toComparator()


  test "scanfComparator":
    [ "", "ép>=" ].zfun:
      foreach:
        var c: Comparator

        check:
          it.scanfComparator(c, it.low()) == 0

    [ "==3.0", "<=µ" ].zfun:
      foreach:
        var c: Comparator

        check:
          it.scanfComparator(c, it.low()) == ComparatorNChars
