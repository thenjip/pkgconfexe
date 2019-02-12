import private/[ filename, utf8 ]

from std/os import PathSep
import std/[ sequtils, strformat, strutils ]



type
  EnvVarName* {. pure .} = enum
    PkgConfigLibdir = "PKG_CONFIG_LIBDIR"
    PkgConfigPath = "PKG_CONFIG_PATH"
    PkgConfigSysrootDir = "PKG_CONFIG_SYSROOT_DIR"

  EnvVar* = object
    name*: EnvVarName
    value*: string



func `$`* (e: EnvVar): string =
  result = fmt"""{$e.name}="{e.value}{'"'}"""



func toString (e: EnvVar; envVarNames: var set[EnvVarName]): string {.
  raises: [ ValueError ]
.} =
  if e.name in envVarNames:
    raise newException(ValueError, fmt""""{$e.name}" is already set.""")

  result = $e
  envVarNames.incl(e.name)


func buildEnv* (env: openarray[EnvVar]): string {. raises: [ ValueError ] .} =
  var envVars: set[EnvVarName]

  result = env.mapIt(it.toString(envVars)).join($' ')



static:
  for it in EnvVarName:
    doAssert(($it).validIdentifier())
