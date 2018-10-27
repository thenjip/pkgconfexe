import pkgconfexe/env

from std/ospaths import CurDir, DirSep, PathSep
import std/[ strformat, strutils, unittest ]



include "data.nims"



suite "env":
  test "buildEnv":
    const
      SomeEnvVarValue: EnvVarValue = (
        envVar: EnvVar.PkgConfigPath,
        val: [ DataDir, fmt"{CurDir}{DirSep}{DataDir}" ].join($PathSep)
      )
      InvalidFileName = DataDir & '\0' & 'a'

    check:
      buildEnv([ SomeEnvVarValue ]) ==
        fmt"""{$SomeEnvVarValue.envVar}="{SomeEnvVarValue.val}{'"'}"""

    expect ValueError:
      discard buildEnv([ SomeEnvVarValue, SomeEnvVarValue ])
    expect ValueError:
      discard buildEnv([(envVar: EnvVar.PkgConfigLibdir, val: InvalidFileName)])
