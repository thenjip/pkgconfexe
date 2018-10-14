from ospaths import CurDir, DirSep
import std/[ strformat, unittest ]

import pkgconfexe/cmd



include "data.nims"



const
  SomeEnvVarValues = [
    (
      envVar: EnvVar.PkgConfigPath,
      val: fmt("{CurDir}{DirSep}{DataDir}")
    )
  ]

  CFlags1 = getCFlags([ (m: DummyPkg.toModule(), envVars: SomeEnvVarValues) ])
  CFlags2 = getCFlags([
    (m: DummyPkg & " >= 0.0".toModule(), envVars: SomeEnvVarValues)
  ])

  LdFlags = getLdFlags([ (m: DepsPkg.toModule(), envVars: SomeEnvVarValues) ])



suite "cmd":
  test "getCFlags":
    check:
      Cflags1 == "-Idummy -Ideps"
      Cflags2 == "-Idummy -Ideps"


  test "getLdFlags":
    check(
      LdFlags == "-ldeps"
    )
