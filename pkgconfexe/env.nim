import private/[ filename, identifier, path, utf8 ]

from std/ospaths import PathSep
import std/[ sequtils, strformat, strutils, unicode ]



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
  result = case e.envVar:
    of PkgConfigLibdir, PkgConfigPath:
      e.val.split(PathSep.toRune()).allIt(it.isPath())
    of PkgConfigSysrootDir:
      e.val.isPath()



func buildEnv* (env: openarray[EnvVarValue]): string {.
  locks: 0, raises: [ ValueError ]
.} =
  result = env.mapIt((func (e: EnvVarValue): string =
    var envVars: set[EnvVar]

    if e.envVar in envVars:
      raise newException(ValueError, fmt""""{$e.envVar}" is already set.""")
    elif not e.validateEnvVarValue():
      raise newException(
        ValueError, fmt"""Invalid value for "{$e.envVar}": {e.val}"""
      )
    else:
      $e
  )(it)).join($' ')



static:
  doAssert(toSeq(EnvVar.items()).allIt(($it).isIdentifier()))
