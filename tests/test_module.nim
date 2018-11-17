import pkgconfexe/module
import pkgconfexe/private/[ fphelper, utf8 ]

import pkg/zero_functional

import std/[ strscans, unittest ]



const
  SomeModules = [
    (pkg: "a", hasVersion: true, cmp: Comparator.Equal, version: "6"),
    (
      pkg: "C#",
      hasVersion: true,
      cmp: Comparator.GreaterEq,
      version: "2.0.5-4~ß"
    ),
    (pkg: "gtk+-3.0", hasVersion: false, cmp: Comparator.low(), version: "")
  ]

  SomeStringModules = [ "a==6", "C#>=2.0.5-4~ß", "gtk+-3.0" ]

  Pattern = "$[skipWhiteSpaces]${scanfModule}$[skipWhiteSpaces]$."
  Inputs = [ "a==6", " C# \t>=\f 2.0.5-4~ß", "gtk+-3.0\l\0" ]



suite "module":
  test "$":
    seqOf(SomeModules.pairs()).zfun:
      foreach:
        check:
          $it.val == SomeStringModules[it.key]


  test "scanfModule":
    seqOf(Inputs.pairs()).zfun:
      foreach:
        var match: Module
        check:
          it.val.scanf(Pattern, match)
          match == SomeModules[it.key]


  test "toModule":
    seqOf(Inputs.pairs()).zfun:
      foreach:
        check:
          it.val.toModule() == SomeModules[it.key]

    [ "", "a  p" ].zfun:
      foreach:
        expect ValueError:
          discard it.toModule()


  test "module":
    const m = module"a==6"
