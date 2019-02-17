import pkgconfexe/[ env ]

when NimVersion >= "0.19.9":
  import std/os
else:
  import std/ospaths
import std/[ strformat, strutils, unittest ]

import "data.nims"



const
  SomeConfigPath = (
    name: EnvVarName.PkgConfigPath,
    value: [ DataDir, fmt"./{DataDir}".unixToNativePath() ].join($PathSep)
  )
  SomeSysrootDir = (name: EnvVarName.PkgConfigSysrootDir, value: DataDir)

  SomeConfigPathString =
    fmt"{$SomeConfigPath.name}={SomeConfigPath.value.quoteShell()}"
  SomeSysrootDirString =
    fmt"{$SomeSysrootDir.name}={SomeSysrootDir.value.quoteShell()}"



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


  test "buildEnv_const":
    const envLine = [ SomeConfigPath ].buildEnv()

    check:
      envLine == SomeConfigPathString
