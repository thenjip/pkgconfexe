import std/[ strscans, unicode, unittest ]

import pkgconfexe/operator



const SomeInvalidOperators = [ "=", "&", "+", "-", "^", "" ]



suite "operator":
  test "isOperator":
    for o in Operator:
      check(($o).isOperator())

    for o in SomeInvalidOperators:
      check(not o.isOperator())


  test "option":
    for o in Operator:
      check(o.option() == OperatorOptions[o])


  test "operator":
    for o in SomeInvalidOperators:
      expect ValueError:
        let op = o.operator()


  test "scanfOperator":
    const Pattern = "${scanfOperator}"

    for s in [ "", "ép>=" ]:
      var op: Operator
      check(not s.scanf(Pattern, op))

    for s in [ "==3.0", "<=µ" ]:
      var op: Operator
      check:
        s.scanf(Pattern, op)
        $op == $s.runeSubStr(s.low(), OperatorNChars)
