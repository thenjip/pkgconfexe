import pkgconfexe/[ module ]

import std/[ options, unittest ]



type TestData = tuple
  input: string
  expectedStr: string
  expectedMod: Module



const SomeTestData: seq[TestData] = @[
  ("a==6", "a==6", buildModule("a", Comparator.Equal, "6")),
  (
    "C# \t>=   2.0.5-4~ß",
    "C#>=2.0.5-4~ß",
    buildModule("C#", Comparator.GreaterEq, "2.0.5-4~ß")
  ),
  (
    "gtk+-3.0<=	 3.10.0",
    "gtk+-3.0<=3.10.0",
    buildModule("gtk+-3.0", Comparator.LessEq, "3.10.0")
  )
]



suite "module":
  test "$":
    for it in SomeTestData:
      check:
        $it.expectedMod == it.expectedStr



  test "scanModule":
    for it in SomeTestData:
      check:
        it.input.scanModule().get() == it.expectedMod



  test "module":
    const m = module"a==6"

    check:
      m == SomeTestData[0].expectedMod
