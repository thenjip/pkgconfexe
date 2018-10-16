import env, module
import private/filename

import std/[ ospaths, strformat, strutils ]


export env, module



const CmdName* = "pkgconf".addFileExt(ExeExt)



type
  Action* {. pure .} = enum
    CFlags = "--cflags"
    LdFlags = "--ldflags"

  ModuleEnv* = tuple
    m: Module
    envVars: seq[EnvVarValue]



func buildCmdLine* (a: Action; me: ModuleEnv): string {. locks: 0 .} =
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
    if me.envVars.len() == 0:
      cmd
    else:
      fmt"{env} {cmd}"



func execCmds (action: Action; modEnvs: openarray[ModuleEnv]): string {.
  compileTime, locks: 0
.} =
  var results = newSeqofCap[string](modEnvs.len())

  for me in modEnvs:
    results.add(staticExec(action.buildCmdLine(me)))

  result = results.join($' ')


func getCFlags* (modEnvs: openarray[ModuleEnv]): string {.
  compileTime, locks: 0
.} =
  result = execCmds(Action.CFlags, modEnvs)


func getLdFlags* (modEnvs: openarray[ModuleEnv]): string {.
  compileTime, locks: 0
.} =
  result = execCmds(Action.LdFlags, modEnvs)



static:
  doAssert(CmdName.isFileName())
