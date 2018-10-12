import std/[ strscans, unittest ]

import pkgconfexe/module
import pkgconfexe/private/utf8



const
  SomeModules: array[3, Module] = [
    (pkg: "a", op: Operator.Equal, version: "6"),
    (pkg: "C#", op: Operator.GreaterEq, version: "2.0.5-4~ß"),
    (pkg: "gtk+-3.0", op: Operator.LessEq, version: "")
  ]

  SomeStringModules = [ "a==6", "C#>=2.0.5-4~ß", "gtk+-3.0" ]

  Pattern = "$[skipWhiteSpaces]${scanfModule}$[skipWhiteSpaces]"
  Inputs = [ "a==6", " C# \t>=\f 2.0.5-4~ß", "gtk+-3.0\l\0" ]



suite "module":
  test "$":
    for iter in SomeModules.pairs():
      check($iter.val == SomeStringModules[iter.key])


  test "scanfModule":
    for iter in Inputs.pairs():
      var match: Module
      check:
        iter.val.scanf(Pattern, match)
        match == SomeModules[iter.key]


  test "toModule":
    for iter in Inputs.pairs():
      check(iter.val.toModule() == SomeModules[iter.key])
