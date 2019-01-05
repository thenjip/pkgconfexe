import private/[ filename, fphelper, identifier, utf8 ]

import pkg/zero_functional

from std/os import PathSep
import std/[ strformat, strutils, unicode ]



type
  EnvVar* {. pure .} = enum
    PkgConfigLibdir = "PKG_CONFIG_LIBDIR"
    PkgConfigPath = "PKG_CONFIG_PATH"
    PkgConfigSysrootDir = "PKG_CONFIG_SYSROOT_DIR"

  EnvVarValue* = tuple
    envVar: EnvVar
    val: string



func `$`* (e: EnvVarValue): string =
  result = fmt"""{$e.envVar}="{e.val}{'"'}"""



func toString (e: EnvVarValue; envVars: var set[EnvVar]): string {.
  raises: [ ValueError ]
.} =
  if e.envVar in envVars:
    raise newException(ValueError, fmt""""{$e.envVar}" is already set.""")

  result = $e
  envVars.incl(e.envVar)


func buildEnv* (env: seq[EnvVarValue]): string {. raises: [ ValueError ] .} =
  var envVars: set[EnvVar]

  result = env.callZFunc(map(it.toString(envVars))).join($' ')



static:
  EnvVar-->foreach(doAssert(($it).isIdentifier()))

