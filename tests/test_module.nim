import pkgconfexe/[ module ]
import pkgconfexe/private/[ optional, scanresult ]

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
  (
    "gtk+-3.0 <=	 3.10.0",
    "gtk+-3.0",
    buildModule("gtk+-3.0", Comparator.LessEq, "3.10.0")
  )
].mapIt(it.TestData)



suite "module":
  test "$":
    for it in SomeTestData:
      check:
        $it.expectedMod == it.expectedStr



  test "scanModule":
    for it in SomeTestData:
      check:
        it.input.scanModule().get().value() == it.expectedMod



  test "module":
    const m = module"a==6"
