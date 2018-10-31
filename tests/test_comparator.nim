import pkgconfexe/comparator

import std/[ sequtils, unicode, unittest ]



const SomeInvalidComparators = [ "=", "&", "+", "-", "^", "" ]



suite "comparator":
  test "isComparator":
    check:
      toSeq(Comparator.items()).allIt(($it).isComparator())
      SomeInvalidComparators.allIt(not it.isComparator())


  test "option":
    check:
      toSeq(Comparator.items()).allIt(it.option() == ComparatorOptions[it])


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
