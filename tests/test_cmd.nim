from ospaths import CurDir, DirSep
import std/[ strformat, unittest ]

import pkgconfexe/cmd



include "data.nims"



const SomeEnvVarValues = [
  (
    envVar: EnvVar.PkgConfigPath,
    val: fmt("{CurDir}{DirSep}{DataDir}")
  )
]



suite "cmd":
  test "getCFlags":
    check:
      getCFlags([ (m: DummyPkg.toModule(), envVars: SomeEnvVarValues) ]) ==
        "-Idummy -Ideps"
      getCFlags([
        (m: DummyPkg & " >= 0.0".toModule(), envVars: SomeEnvVarValues)
      ]) == "-Idummy -Ideps"


  test "getLdFlags":
    check(
      getLdFlags([ (m: DepsPkg.toModule(), envVars: SomeEnvVarValues) ]) ==
        "-ldeps"
    )
