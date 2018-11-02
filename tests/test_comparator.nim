import pkgconfexe/comparator
import pkgconfexe/private/fphelper

import pkg/zero_functional

import std/[ unicode, unittest ]



const SomeInvalidComparators = [ "=", "&", "+", "-", "^", "" ]



suite "comparator":
  test "isComparator":
    check:
      Comparator.seqOfAll()-->all(($it).isComparator())
      SomeInvalidComparators-->all(not it.isComparator())


  test "option":
    check:
      Comparator.seqOfAll()-->all(it.option() == ComparatorOptions[it])


  test "comparator":
    for c in SomeInvalidComparators:
      expect ValueError:
        let cmp = c.toComparator()


  test "scanfComparator":
    for s in [ "", "ép>=" ]:
      var c: Comparator

      check:
        s.scanfComparator(c, s.low()) == 0

    for s in [ "==3.0", "<=µ" ]:
      var c: Comparator

      check:
        s.scanfComparator(c, s.low()) == ComparatorNChars
        $c == s.runeSubStr(s.low(), ComparatorNChars)
