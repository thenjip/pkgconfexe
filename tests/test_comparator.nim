import pkgconfexe/comparator

import std/[ strscans, unicode, unittest ]



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
    const Pattern = "${scanfComparator}"

    for s in [ "", "ép>=" ]:
      var c: Comparator
      check(not s.scanf(Pattern, c))

    for s in [ "==3.0", "<=µ" ]:
      var c: Comparator
      check:
        s.scanf(Pattern, c)
        $c == $s.runeSubStr(s.low(), ComparatorNChars)
