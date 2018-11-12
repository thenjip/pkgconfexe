import pkgconfexe/cmd

import pkg/regex

from std/ospaths import DirSep
import std/[ ospaths, strformat, unittest ]


include "data.nims"



const
  DepsModule = (pkg: DepsPkg, cmp: Comparator.LessEq, version: "0.0.1")
  DummyModule = (pkg: DummyPkg, cmp: Comparator.None, version: "")

  SomeEnvVarValues = @[
    (
      envVar: EnvVar.PkgConfigPath,
      val: currentSourcePath().splitFile().dir / DataDir
    )
  ]

  CFlags1 = getCFlags(@[ DummyModule, DepsModule ], SomeEnvVarValues)
  CFlags2 = getCFlags(@[ DummyModule ], SomeEnvVarValues)

  LdFlags = getLdFlags(@[ DepsModule ], SomeEnvVarValues)



suite "cmd":
  test "buildCmdLine":
    check:
      buildCmdLine(DummyModule, @[], Action.CFlags) ==
        fmt"""{CmdName} {$Action.CFlags} "{DummyPkg.toModule().pkg}{'"'}"""
      buildCmdLine(DepsModule, SomeEnvVarValues, Action.LdFlags) ==
        fmt(
          "{SomeEnvVarValues.buildEnv()} {CmdName} {$Action.LdFlags}" &
            """ {DepsModule.cmp.option()} "{DepsModule.version}{'"'}""" &
            """ "{DepsModule.pkg}{'"'}"""
        )


  test "getCFlags":
    const
      ExpectedCFlags = "-Idummy -Ideps"
      Pattern = fmt"^{ExpectedCFlags}\s*$"

    check:
      CFlags1.contains(re(Pattern))
      CFlags2.contains(re(Pattern))


  test "getLdFlags":
    check:
      LdFlags == "-ldeps"
