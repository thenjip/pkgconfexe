import pkgconfexe/module
import pkgconfexe/private/utf8

import pkg/zero_functional

import std/[ sequtils, strscans, unittest ]



const
  SomeModules: array[3, Module] = [
    constructModule("a", Comparator.Equal, "6"),
    constructModule("C#", Comparator.GreaterEq, "2.0.5-4~ß"),
    constructModule("gtk+-3.0")
  ]

  SomeStringModules = [ "a==6", "C#>=2.0.5-4~ß", "gtk+-3.0" ]

  Pattern = "$[skipWhiteSpaces]${scanfModule}$[skipWhiteSpaces]$."
  Inputs = [ "a==6", " C# \t>=\f 2.0.5-4~ß", "gtk+-3.0\l\0" ]



suite "module":
  test "$":
    toSeq(SomeModules.pairs()).zfun:
      foreach:
        check:
          $it.val == SomeStringModules[it.key]


  test "scanfModule":
    toSeq(Inputs.pairs()).zfun:
      foreach:
        var match: Module
        check:
          it.val.scanf(Pattern, match)
          match == SomeModules[it.key]


  test "toModule":
    toSeq(Inputs.pairs()).zfun:
      foreach:
        check:
          it.val.toModule() == SomeModules[it.key]

    [ "", "a  p" ].zfun:
      foreach:
        expect ValueError:
          discard it.toModule()


  test "module":
    const m = module"a==6"
