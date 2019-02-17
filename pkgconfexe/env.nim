import private/[ filename, utf8 ]

import std/[ ospaths, sequtils, strformat, strutils, tables ]



type
  EnvVarName* {. pure .} = enum
    PkgConfigLibdir = "PKG_CONFIG_LIBDIR"
    PkgConfigPath = "PKG_CONFIG_PATH"
    PkgConfigSysrootDir = "PKG_CONFIG_SYSROOT_DIR"

  EnvVar* = tuple
    name: EnvVarName
    value: string



func `$`* (e: EnvVar): string =
  fmt"{$e.name}={e.value.quoteShell()}"



func buildEnv* (
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()]
): string =
  toSeq(env.pairs()).mapIt($it.EnvVar).joinWithSpaces()


func buildEnv* (env: openarray[EnvVar]): string =
  env.toOrderedTable().buildEnv()



static:
  for it in EnvVarName:
    doAssert(($it).validIdentifier())
