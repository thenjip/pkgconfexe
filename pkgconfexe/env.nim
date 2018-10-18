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



func `$`* (v: EnvVarValue): string {. locks: 0 .} =
  result = fmt"""{$v.envVar}="{v.val}{'"'}"""



func validateEnvVarValue* (v: EnvVarValue):  bool {. locks: 0 .} =
  case v.envVar:
    of PkgConfigLibdir, PkgConfigPath:
      for p in v.val.split(PathSep.toRune()):
        if not p.isPath():
          return false
    of PkgConfigSysrootDir:
      if not v.val.isPath():
        return false

  result = true



func buildEnv* (values: openarray[EnvVarValue]): string {.
  locks: 0, raises: [ ValueError ]
.} =
  var
    envVars: set[EnvVar]
    results = newSeqOfCap[string](values.len())

  for v in values:
    if v.envVar in envVars:
      raise newException(ValueError, fmt""""{$v.envVar}" is already set.""")

    if not v.validateEnvVarValue():
      raise newException(
        ValueError, fmt"""Invalid value for "{$v.envVar}": {v.val}"""
      )

    results.add($v)
    envVars.incl(v.envVar)

  result = results.join($' ')



static:
  for e in EnvVar:
    doAssert(($e).isIdentifier())
