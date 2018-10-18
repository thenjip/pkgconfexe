import pkgconfexe/cmd

from ospaths import CurDir, DirSep
import std/[ strformat, unittest ]


include "data.nims"



const
  SomeEnvVarValues: array[0, EnvVarValue] = [
    (
      envVar: EnvVar.PkgConfigPath,
      val: fmt("{CurDir}{DirSep}{DataDir}")
    )
  ]

  CFlags1 = getCFlags([
    (m: DummyPkg.toModule(), envVars: @SomeEnvVarValues),
    (m: DepsPkg.toModule(), envVars: @[])
  ])
  CFlags2 = getCFlags([
    (m: fmt"{DummyPkg} >= 0.0".toModule(), envVars: @SomeEnvVarValues)
  ])

  LdFlags = getLdFlags([ (m: DepsPkg.toModule(), envVars: @SomeEnvVarValues) ])



suite "cmd":
  test "buildCmdLine":
    const DepsModule = DepsPkg.toModule()

    check:
      buildCmdLine(Action.CFlags, (m: DummyPkg.toModule(), envVars: @[])) ==
        fmt"""{CmdName} {$Action.CFlags} "{DummyPkg.toModule().pkg}{'"'}"""
      buildCmdLine(
        Action.LdFlags,
        (m: DepsPkg.toModule(), envVars: @SomeEnvVarValues)
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
    check(
      LdFlags == "-ldeps"
    )
