import pkgconfexe/[ module ]

import std/[ options, unittest ]



type TestData = tuple
  input: string
  expectedStr: string
  expectedMod: Module



const SomeTestData: seq[TestData] = @[
  ("a==6", "a==6", Module(pkg: "a", cmp: Comparator.Equal, version: "6")),
  (
    "C# \t>=   2.0.5-4~ß",
    "C#>=2.0.5-4~ß",
    Module(pkg: "C#", cmp: Comparator.GreaterEq, version: "2.0.5-4~ß")
  ),
  (
    "gtk+-3.0<=	 3.10.0",
    "gtk+-3.0<=3.10.0",
    Module(pkg: "gtk+-3.0", cmp: Comparator.LessEq, version: "3.10.0")
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
