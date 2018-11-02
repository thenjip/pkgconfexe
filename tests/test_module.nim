import pkgconfexe/module
import pkgconfexe/private/utf8

import std/[ strscans, unittest ]



const
  SomeModules: array[3, Module] = [
    (pkg: "a", cmp: Comparator.Equal, version: "6"),
    (pkg: "C#", cmp: Comparator.GreaterEq, version: "2.0.5-4~ß"),
    (pkg: "gtk+-3.0", cmp: Comparator.LessEq, version: "")
  ]

  SomeStringModules = [ "a==6", "C#>=2.0.5-4~ß", "gtk+-3.0" ]

  Pattern = "$[skipWhiteSpaces]${scanfModule}$[skipWhiteSpaces]"
  Inputs = [ "a==6", " C# \t>=\f 2.0.5-4~ß", "gtk+-3.0\l\0" ]



suite "module":
  test "hasNoVersion":
    check:
      SomeModules[2].hasNoVersion()
      not SomeModules[0].hasNoVersion()


  test "$":
    for iter in SomeModules.pairs():
      check:
        $iter.val == SomeStringModules[iter.key]


  test "scanfModule":
    for iter in Inputs.pairs():
      var match: Module
      check:
        iter.val.scanf(Pattern, match)
        match == SomeModules[iter.key]


  test "toModule":
    for iter in Inputs.pairs():
      check:
        iter.val.toModule() == SomeModules[iter.key]

    expect ValueError:
      discard "".toModule()
    expect ValueError:
      discard "a  p".toModule()
