import pkgconfexe

import std/[ macros, unittest ]


include "data.nims"



const SomeEnv: array[1, EnvVarValue] = [
  (EnvVar.PkgConfigPath, DataDir)
]



suite "pkgconfexe":
  test "withEnv":
    check:
      withEnv(SomeEnv, SomeEnv[SomeEnv.low()]).getAst() ==
        [ SomeEnv, SomeEnv[SomeEnv.low()] ].getAst()
