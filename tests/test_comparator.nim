import pkgconfexe/comparator

import std/[ unicode, unittest ]



const SomeInvalidComparators = [ "=", "&", "+", "-", "^", "" ]



suite "comparator":
  test "isComparator":
    for c in Comparator:
      check(($c).isComparator())

    for c in SomeInvalidComparators:
      check(not c.isComparator())


  test "option":
    for c in Comparator:
      check(c.option() == ComparatorOptions[c])


  test "comparator":
    for c in SomeInvalidComparators:
      expect ValueError:
        let cmp = c.toComparator()


  test "scanfComparator":
    for s in [ "", "ép>=" ]:
      var c: Comparator
      check(s.scanfComparator(c, s.low()) == 0)

    for s in [ "==3.0", "<=µ" ]:
      var c: Comparator
      check:
        s.scanfComparator(c, s.low()) == ComparatorNChars
        $c == s.runeSubStr(s.low(), ComparatorNChars)
