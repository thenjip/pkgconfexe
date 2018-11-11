import pkgconfexe/comparator

import std/[ unicode, unittest ]



const SomeInvalidComparators = [ "=", "&", "+", "-", "^" ]



suite "comparator":
  test "isComparator":
    for c in AllComparators:
      check:
        ($c).isComparator()

    for s in SomeInvalidComparators:
      check:
        not s.isComparator()


  test "option":
    for c in AllComparators:
      check:
        c.option() == ComparatorOptions[c]


  test "comparator":
    for s in SomeInvalidComparators:
      expect ValueError:
        let c = s.toComparator()


  test "scanfComparator":
    for s in [ "", "ép>=" ]:
      var c = Comparator.high()

      check:
        s.scanfComparator(c, s.low()) == 0
        c == Comparator.None

    for s in [ "==3.0", "<=µ" ]:
      var c = Comparator.None

      check:
        s.scanfComparator(c, s.low()) == ComparatorNChars
        c != Comparator.None
