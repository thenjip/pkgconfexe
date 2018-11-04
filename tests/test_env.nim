import pkgconfexe/env

import pkg/zero_functional

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


  test "validateEnvVarValue":
    check:
      [ SomeConfigPath, SomeSysrootDir ]-->all(it.validateEnvVarValue())
      [ SomeInvalidLibdir ]-->all(not it.validateEnvVarValue())


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
