import pkgconfexe/[ module ]
import pkgconfexe/private/[ optional, scanresult ]

import pkg/[ zero_functional ]

import std/[ sequtils, unittest ]



type TestData = tuple
  input: string
  expectedStr: string
  expectedMod: Module



const SomeTestData = [
  ("a==6", "a==6", buildModule("a", Comparator.Equal, "6")),
  (
    "C# \t>=   2.0.5-4~ß",
    "C#>=2.0.5-4~ß",
    buildModule("C#", Comparator.GreaterEq, "2.0.5-4~ß")
  ),
  ("gtk+-3.0\l\0<=3.10.0", "gtk+-3.0", buildModule("gtk+-3.0"))
]-->map(it.TestData)



suite "module":
  test "$":
    SomeTestData.zfun:
      foreach:
        check:
          $it.expectedMod == it.expectedStr



  test "scanModule":
    SomeTestData.zfun:
      foreach:
        check:
          it.input.scanModule().get().value() == it.expectedMod
