import private/[ filename, fphelper, identifier, path, utf8 ]

import pkg/zero_functional

from std/ospaths import PathSep
import std/[ strformat, strutils, unicode ]



type
  EnvVar* {. pure .} = enum
    PkgConfigLibdir = "PKG_CONFIG_LIBDIR"
    PkgConfigPath = "PKG_CONFIG_PATH"
    PkgConfigSysrootDir = "PKG_CONFIG_SYSROOT_DIR"

  EnvVarValue* = tuple
    envVar: EnvVar
    val: string



func `$`* (e: EnvVarValue): string {. locks: 0 .} =
  result = fmt"""{$e.envVar}="{e.val}{'"'}"""



func validateEnvVarValue* (e: EnvVarValue): bool {. locks: 0 .} =
  result = case e.envVar
    of EnvVar.PkgConfigLibdir, EnvVar.PkgConfigPath:
      e.val.split(PathSep.toRune())-->all(it.isPath())
    of EnvVar.PkgConfigSysrootDir:
      e.val.isPath()



func toString* (e: EnvVarValue): string {. locks: 0, raises: [ ValueError ] .} =
  result =
    if not e.validateEnvVarValue():
      raise newException(
        ValueError, fmt"""Invalid value for "{$e.envVar}": {e.val}"""
      )
    else:
      $e



func buildEnv* (env: seq[EnvVarValue]): string {.
  locks: 0, raises: [ ValueError ]
.} =
  var envVars: set[EnvVar]

  result = env.callZFunc(map(
    (func (e: EnvVarValue): string =
      result =
        if e.envVar in envVars:
          raise newException(ValueError, fmt""""{$e.envVar}" is already set.""")
        else:
          e.toString()
      envVars.incl(e.envVar)
    )(it)
  )).join($' ')



#[
static:
  doAssert(EnvVar.seqOfAll()-->all(($it).isIdentifier()))
]#
