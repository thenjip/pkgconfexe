import env, module
import private/filename

import std/[ ospaths, strformat, strutils ]


export env, module



const CmdName* = "pkgconf".addFileExt(ExeExt)



type
  Action* {. pure .} = enum
    CFlags = "--cflags"
    LdFlags = "--ldflags"



func buildCmdLine* (
  m: Module; env: openarray[EnvVarValue]; a: Action
): string {. locks: 0 .} =
  let cmd =
    if m.hasNoVersion():
      fmt"""{CmdName} {$a} "{m.pkg}{'"'}"""
    else:
      fmt(
        "{CmdName} {$a} " &
          """{m.cmp.option()} "{m.version}" "{m.pkg}{'"'}"""
      )

  result =
    if env.len() == 0:
      cmd
    else:
      fmt"{env.buildEnv()} {cmd}"



func execCmds (
  modules: openarray[Module]; env: openarray[EnvVarValue]; a: Action
): string {. compileTime, locks: 0 .} =
  var results = newSeqofCap[string](modules.len())

  for m in modules:
    results.add(staticExec(m.buildCmdLine(env, a)))

  result = results.join($' ')


func getCFlags* (
  modules: openarray[Module]; env: openarray[EnvVarValue]
): string {. compileTime, locks: 0 .} =
  result = modules.execCmds(env, Action.CFlags)


func getLdFlags* (
  modules: openarray[Module]; env: openarray[EnvVarValue]
): string {. compileTime, locks: 0 .} =
  result = modules.execCmds(env, Action.LdFlags)



static:
  doAssert(CmdName.isFileName())
