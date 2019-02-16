import private/[ filename, utf8 ]

from std/os import PathSep
import std/[ sequtils, strformat, strutils, tables ]



type
  EnvVarName* {. pure .} = enum
    PkgConfigLibdir = "PKG_CONFIG_LIBDIR"
    PkgConfigPath = "PKG_CONFIG_PATH"
    PkgConfigSysrootDir = "PKG_CONFIG_SYSROOT_DIR"

  EnvVar* = tuple
    name: EnvVarName
    value: string



func `$`* (e: EnvVar): string =
  """{$e.name}="{e.value}"""".fmt()



func buildEnv* (
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()]
): string =
  toSeq(env.pairs()).mapIt($it.EnvVar).joinWithSpaces()


func buildEnv* (env: openarray[EnvVar]): string =
  env.toOrderedTable().buildEnv()



static:
  for it in EnvVarName:
    doAssert(($it).validIdentifier())
