import pkgconfexe/[ env ]

from std/os import CurDir, DirSep, PathSep
import std/[ os, strformat, strutils, unittest ]

import "data.nims"



const
  SomeConfigPath = EnvVar(
    name: EnvVarName.PkgConfigPath,
    value: [ DataDir, fmt"./{DataDir}".unixToNativePath() ].join($PathSep)
  )
  SomeSysrootDir = EnvVar(name: EnvVarName.PkgConfigSysrootDir, value: DataDir)

  SomeConfigPathString =
    fmt"""{$SomeConfigPath.name}="{SomeConfigPath.value}{'"'}"""
  SomeSysrootDirString =
    fmt"""{$SomeSysrootDir.name}="{SomeSysrootDir.value}{'"'}"""



suite "env":
  test "$":
    check:
      $SomeConfigPath == SomeConfigPathString
      $SomeSysrootDir == SomeSysrootDirString



  test "buildEnv":
    check:
      [ SomeConfigPath ].buildEnv() == SomeConfigPathString
      [ SomeConfigPath, SomeSysrootDir].buildEnv() ==
        [ SomeConfigPathString, SomeSysrootDirString ].join($' ')

    expect ValueError:
      let tmp = [ SomeConfigPath, SomeConfigPath ].buildEnv()


  test "buildEnv_const":
    const envLine = [ SomeConfigPath ].buildEnv()

    check:
      envLine == SomeConfigPathString
