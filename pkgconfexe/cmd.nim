import std/[ ospaths, sugar, strformat, strutils ]

import env, module

import private/filename


export env, module



const CmdName* = "pkgconf".addFileExt(ExeExt)



type
  Action* {. pure .} = enum
    CFlags = "--cflags"
    LdFlags = "--ldflags"

  ModuleEnv* = tuple
    m: Module
    envVars: seq[EnvVarValue]



func buildCmdLine* (me: ModuleEnv; a: Action): string {. locks: 0 .} =
  let
    cmd =
      if me.m.version.len() == 0:
        fmt"""{CmdName} {$a} "{me.m.pkg}{'"'}"""
      else:
        fmt(
          "{CmdName} {$a} " &
            """{me.m.op.option()} "{me.m.version}" "{me.m.pkg}{'"'}"""
        )
    env = me.envVars.buildEnv()

  result =
    if env.len() == 0:
      cmd
    else:
      fmt"{env} {cmd}"



func getCFlags* (modEnvs: openarray[ModuleEnv]): string {.
  compileTime, locks: 0
.} =
  var results: seq[string]

  for me in modEnvs:
    results.add(staticExec(me.buildCmdLine(Action.CFlags)))

  result = results.join($' ')


func getLdFlags* (modEnvs: openarray[ModuleEnv]): string {.
  compileTime, locks: 0
.} =
  var results: seq[string]

  for me in modEnvs:
    results.add(staticExec(me.buildCmdLine(Action.LdFlags)))

  result = results.join($' ')



static:
  doAssert(CmdName.isFileName())
