import pkgconfexe/cmd

import std/[ ospaths, strformat, unittest ]


include "data.nims"



const
  DepsModule = DepsPkg.toModule()
  DummyModule = DummyPkg.toModule()

  SomeEnvVarValues = @[ (envVar: EnvVar.PkgConfigPath, val: DataDir) ]

  CFlags1 = getCFlags(@[ DummyModule, DepsModule], SomeEnvVarValues)
  CFlags2 = getCFlags(@[ fmt"{DummyPkg} >= 0.0".toModule() ], SomeEnvVarValues)

  LdFlags = getLdFlags(@[ DepsModule ], SomeEnvVarValues)



suite "cmd":
  test "buildCmdLine":
    check:
      buildCmdLine(DummyModule, @[], Action.CFlags) ==
        fmt"""{CmdName} {$Action.CFlags} "{DummyPkg.toModule().pkg}{'"'}"""
      buildCmdLine(DepsModule, SomeEnvVarValues, Action.LdFlags) ==
        fmt(
          "{SomeEnvVarValues.buildEnv()} {CmdName} {$Action.LdFlags} " &
            """{DepsModule.op.option()} "{DepsModule.version}{'"'}""" &
            """{DepsModule.pkg}{'"'}"""
        )


  test "getCFlags":
    check:
      CFlags1 == "-Idummy -Ideps"
      CFlags2 == "-Idummy -Ideps"


  test "getLdFlags":
    check:
      LdFlags == "-ldeps"
