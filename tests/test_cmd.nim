import pkgconfexe/[ cmd ]
import pkgconfexe/private/[ utf8 ]

import std/strutils except splitWhitespace
when NimVersion <= "0.19.4":
  import std/ospaths
else:
  import os
import std/[ sequtils, strformat, unicode, unittest ]

import "data.nims"



const
  DepsModule = Module(pkg: DepsPkg, cmp: Comparator.LessEq, version: "0.0.1")
  DummyModule = Module(pkg: DummyPkg, cmp: Comparator.Equal, version: "0.0.0")

  SomeEnvVars = {
    EnvVarName.PkgConfigPath: currentSourcePath().splitFile().dir / DataDir
  }



suite "cmd":
  test "getCFlags":
    type TestData = tuple
      expected: string
      actual: string

    const data = [
      ("-Idummy -Ideps", getCFlags([ DummyModule, DepsModule ], SomeEnvVars)),
      ("-Idummy -Ideps", getCFlags([ DummyModule ], SomeEnvVars))
    ]

    for it in data:
      (proc (it: TestData) =
        check:
          it.expected ==
            it.actual.splitWhitespace().deduplicate().joinWithSpaces()
      )(it)


  test "getLdFlags":
    type TestData = tuple
      expected: string
      actual: string

    const data = [ ("-ldeps", getLdFlags([ DepsModule ], SomeEnvVars)) ]

    for it in data:
      (proc (it: TestData) =
        check:
          it.expected ==
            it.actual.splitWhitespace().deduplicate().joinWithSpaces()
      )(it)
