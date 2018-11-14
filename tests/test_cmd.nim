import pkgconfexe/cmd

import pkg/[ regex, zero_functional ]

from std/ospaths import DirSep
import std/[ ospaths, strformat, unittest ]


include "data.nims"



const
  DepsModule = Module(
    pkg: DepsPkg, hasversion: true, cmp: Comparator.LessEq, version: "0.0.1"
  )
  DummyModule = Module(pkg: DummyPkg, hasVersion: false)

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
    [ CFlags1, CFlags2 ].zfun:
      foreach:
        check:
          it.contains(re"^-Idummy -Ideps\s*$")


  test "getLdFlags":
    check:
      LdFlags == "-ldeps"
