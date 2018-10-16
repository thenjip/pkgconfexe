import env, module
import private/filename

import std/[ macros, ospaths, strformat, strutils ]


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



macro execCmds (action: Action; modEnvs: varargs[ModuleEnv]): string =
# join([ staticExec(modEnv1.buildCmdLine(action)), ... ], ' ')
  var cmds = nnkBracket.newTree()

  for me in modEnvs:
    cmds.add(newCall("staticExec", newCall("buildCmdLine", me, action)))

  result = newCall("join", cmds, newLit(' '))
#[
  var results = newSeqofCap[string](modEnvs.len())

  for me in modEnvs:
    results.add(staticExec(me.buildCmdLine(action)))

  result = results.join($' ')
]#


template getCFlags* (modEnvs: varargs[ModuleEnv]): string =
  execCmds(Action.CFlags, modEnvs)


template getLdFlags* (modEnvs: varargs[ModuleEnv]): string =
  execCmds(Action.LdFlags, modEnvs)



static:
  doAssert(CmdName.isFileName())
