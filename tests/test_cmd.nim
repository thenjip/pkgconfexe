import pkgconfexe/cmd

import std/[ ospaths, strformat, unittest ]


include "data.nims"



const
  SomeEnvVarValues: array[0, EnvVarValue] = [
    (
      envVar: EnvVar.PkgConfigPath,
      val: unixToNativePath(fmt"{DataDir}")
    )
  ]

  CFlags1 = getCFlags(
    [ DummyPkg.toModule(), DepsPkg.toModule()],
    SomeEnvVarValues
  )
  CFlags2 = getCFlags([ toModule(fmt"{DummyPkg} >= 0.0") ], SomeEnvVarValues)

  LdFlags = getLdFlags([ DepsPkg.toModule() ], SomeEnvVarValues)



suite "cmd":
  test "buildCmdLine":
    const DepsModule = DepsPkg.toModule()

    check:
      buildCmdLine(DummyPkg.toModule(), [], Action.CFlags) ==
        fmt"""{CmdName} {$Action.CFlags} "{DummyPkg.toModule().pkg}{'"'}"""
      buildCmdLine(
        [ m: DepsPkg.toModule() ],
        SomeEnvVarValues,
        Action.LdFlags
      ) == fmt(
        "{SomeEnvVarValues.buildEnv()} {CmdName} {$Action.LdFlags} " &
          """{DepsModule.op.option()} "{DepsModule.version}{'"'}""" &
          """{DepsModule.pkg}{'"'}"""
      )


  test "getCFlags":
    check:
      Cflags1 == "-Idummy -Ideps"
      Cflags2 == "-Idummy -Ideps"


  test "getLdFlags":
    check:
      LdFlags == "-ldeps"
