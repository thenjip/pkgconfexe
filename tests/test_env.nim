import pkgconfexe/env
import pkgconfexe/private/identifier

from std/ospaths import CurDir, DirSep, PathSep
import std/[ ospaths, strformat, strutils, unittest ]



include "data.nims"



const
  SomeConfigPath = (
    envVar: EnvVar.PkgConfigPath,
    val: [ DataDir, fmt"./{DataDir}".unixToNativePath() ].join($PathSep)
  )
  SomeSysrootDir = (envVar: EnvVar.PkgConfigSysrootDir, val: DataDir)

  SomeConfigPathString =
    fmt"""{$SomeConfigPath.envVar}="{SomeConfigPath.val}{'"'}"""
  SomeSysrootDirString =
    fmt"""{$SomeSysrootDir.envVar}="{SomeSysrootDir.val}{'"'}"""

  InvalidFileName = &"{DataDir}\0a"

  SomeInvalidLibdir = (envVar: EnvVar.PkgConfigLibdir, val: InvalidFileName)



suite "env":
  test "$":
    check:
      $SomeConfigPath == SomeConfigPathString
      $SomeSysrootDir == SomeSysrootDirString

    for e in EnvVar:
      check:
        ($e).isIdentifier()


  test "validateEnvVarValue":
    for ev in [ SomeConfigPath, SomeSysrootDir ]:
      check: ev.validateEnvVarValue()

    check:
      not SomeInvalidLibdir.validateEnvVarValue()


  test "toString":
    check:
      SomeConfigPath.toString() == SomeConfigPathString
      SomeSysrootDir.toString() == SomeSysrootDirString

    expect ValueError:
      let tmp = SomeInvalidLibdir.toString()


  test "buildEnv":
    check:
      @[ SomeConfigPath ].buildEnv() == SomeConfigPathString
      @[ SomeConfigPath, SomeSysrootDir].buildEnv() ==
        [ SomeConfigPathString, SomeSysrootDirString ].join($' ')

    expect ValueError:
      let tmp = @[ SomeConfigPath, SomeConfigPath ].buildEnv()
    expect ValueError:
      let tmp = @[ SomeInvalidLibdir ].buildEnv()
