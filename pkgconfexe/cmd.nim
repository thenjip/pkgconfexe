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



func buildCmdLine* (me: ModuleEnv; a: Action): string {. locks: 0 .} =
  let cmd =
    if me.m.version.len() == 0:
      fmt"""{CmdName} {$a} "{me.m.pkg}{'"'}"""
    else:
      fmt(
        "{CmdName} {$a} " &
          """{me.m.op.option()} "{me.m.version}" "{me.m.pkg}{'"'}"""
      )

  result =
    if me.envVars.len() == 0:
      cmd
    else:
      fmt"{me.envVars.buildEnv()} {cmd}"



func execCmds (modEnvs: openarray[ModuleEnv]; action: Action): string {.
  compileTime, locks: 0
.} =
  var results = newSeqofCap[string](modEnvs.len())

  for me in modEnvs:
    results.add(staticExec(me.buildCmdLine(action)))

  result = results.join($' ')


func getCFlags* (modEnvs: openarray[ModuleEnv]): string {.
  compileTime, locks: 0
.} =
  result = modEnvs.execCmds(Action.CFlags)


func getLdFlags* (modEnvs: openarray[ModuleEnv]): string {.
  compileTime, locks: 0
.} =
  result = modEnvs.execCmds(Action.LdFlags)



static:
  doAssert(CmdName.isFileName())
