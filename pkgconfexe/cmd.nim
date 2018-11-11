import env, module
import private/[ filename, fphelper, utf8 ]

import pkg/zero_functional

import std/[ ospaths, strformat, strutils ]


export env, module



const CmdName* = "pkgconf".addFileExt(ExeExt)



type Action* {. pure .} = enum
  CFlags = "--cflags"
  LdFlags = "--libs"



func buildCmdLine* (m: Module; env: seq[EnvVarValue]; a: Action): string {.
  locks: 0, raises: [ ValueError ]
.} =
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
  modules: seq[Module]; env: seq[EnvVarValue]; a: Action
): string {. locks: 0, compileTime, raises: [ ValueError ] .} =
  var results: seq[string]

  for m in modules:
    results.add(staticExec(m.buildCmdLine(env, a)))

  result = results.join($' ')


func getCFlags* (modules: seq[Module]; env: seq[EnvVarValue]): string {.
  locks: 0, compileTime, raises: [ ValueError ]
.} =
  result = modules.execCmds(env, Action.CFlags)


func getLdFlags* (modules: seq[Module]; env: seq[EnvVarValue]): string {.
  locks: 0, compileTime, raises: [ ValueError ]
.} =
  result = modules.execCmds(env, Action.LdFlags)




static:
  doAssert(CmdName.isFileName())
  doAssert(Action.seqOfAll()-->all(($it).isUtf8()))

