import private/[ filename, identifier, path, utf8 ]

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



func validateEnvVarValue* (e: EnvVarValue):  bool {. locks: 0 .} =
  case e.envVar:
    of PkgConfigLibdir, PkgConfigPath:
      for p in e.val.split(PathSep.toRune()):
        if not p.isPath():
          return false
    of PkgConfigSysrootDir:
      if not e.val.isPath():
        return false

  result = true



func buildEnv* (env: openarray[EnvVarValue]): string {.
  locks: 0, raises: [ ValueError ]
.} =
  var
    envVars: set[EnvVar]
    results = newSeqOfCap[string](env.len())

  for e in env:
    if e.envVar in envVars:
      raise newException(ValueError, fmt""""{$e.envVar}" is already set.""")

    if not e.validateEnvVarValue():
      raise newException(
        ValueError, fmt"""Invalid value for "{$e.envVar}": {e.val}"""
      )

    results.add($e)
    envVars.incl(e.envVar)

  result = results.join($' ')



static:
  for e in EnvVar:
    doAssert(($e).isIdentifier())
