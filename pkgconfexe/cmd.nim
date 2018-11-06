import env, module
import private/[ filename, fphelper, utf8 ]

import pkg/zero_functional

import std/[ ospaths, strformat, strutils ]


export env, module



const CmdName* = "pkgconf".addFileExt(ExeExt)



type Action* {. pure .} = enum
  CFlags = "--cflags"
  LdFlags = "--ldflags"



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
  modules: seq[static[Module]]; env: seq[static[EnvVarValue]]; a: static[Action]
): static[string] {. locks: 0, compileTime, raises: [ ValueError ] .} =
  result = modules.callZFunc(map(staticExec(it.buildCmdLine(env, a)))).join(
    $' '
  )


func getCFlags* (
  modules: seq[static[Module]]; env: seq[static[EnvVarValue]]
): static[string] {. locks: 0, compileTime, raises: [ ValueError ] .} =
  result = modules.execCmds(env, Action.CFlags)


func getLdFlags* (
  modules: seq[static[Module]]; env: seq[static[EnvVarValue]]
): static[string] {. locks: 0, compileTime, raises: [ ValueError ] .} =
  result = modules.execCmds(env, Action.LdFlags)



#[
static:
  doAssert(CmdName.isFileName())
  doAssert(Action.seqOfAll()-->all(($it).isUtf8()))
]#
