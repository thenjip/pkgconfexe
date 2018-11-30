import pkgconfexe/env

from std/os import CurDir, DirSep, PathSep
import std/[ os, strformat, strutils, unittest ]



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



suite "env":
  test "$":
    check:
      $SomeConfigPath == SomeConfigPathString
      $SomeSysrootDir == SomeSysrootDirString


  test "buildEnv":
    check:
      @[ SomeConfigPath ].buildEnv() == SomeConfigPathString
      @[ SomeConfigPath, SomeSysrootDir].buildEnv() ==
        [ SomeConfigPathString, SomeSysrootDirString ].join($' ')

    expect ValueError:
      let tmp = @[ SomeConfigPath, SomeConfigPath ].buildEnv()
