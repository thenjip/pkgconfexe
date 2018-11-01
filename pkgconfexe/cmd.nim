import env, module
import private/[ filename, fphelper, utf8 ]

import std/[ ospaths, strformat, strutils ]


export env, module



const CmdName* = "pkgconf".addFileExt(ExeExt)



type
  Action* {. pure .} = enum
    CFlags = "--cflags"
    LdFlags = "--ldflags"



func buildCmdLine* (
  m: Module; env: openarray[EnvVarValue]; a: Action
): string {. locks: 0, raises: [ ValueError ] .} =
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
  modules: openarray[static[Module]];
  env: openarray[static[EnvVarValue]];
  a: static[Action]
): string {. compileTime, locks: 0, raises: [ ValueError ] .} =
  result = modules.callZFunc(map(
    staticExec(it.buildCmdLine(env, a))
  )).join($' ')


func getCFlags* (
  modules: openarray[static[Module]]; env: openarray[static[EnvVarValue]]
): string {. compileTime, locks: 0, raises: [ ValueError ] .} =
  result = modules.execCmds(env, Action.CFlags)


func getLdFlags* (
  modules: openarray[static[Module]]; env: openarray[static[EnvVarValue]]
): string {. compileTime, locks: 0, raises: [ ValueError ] .} =
  result = modules.execCmds(env, Action.LdFlags)



static:
  doAssert(CmdName.isFileName())
  doAssert(Action.seqOfAll()-->all(($it).isUtf8())
