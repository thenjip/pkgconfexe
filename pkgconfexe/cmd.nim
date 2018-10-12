import std/[ ospaths, strformat, strutils ]

import env, module

import private/filename


export env, module



const
  CmdName* = "pkgconfexe"

  DefaultEnvInfo*: EnvInfo = (libdirs: @[], pkgPaths: @[], sysrootDir: "")



type Action* {. pure .} = enum
  CFlags = "--cflags"
  LdFlags = "--ldflags"



func buildCmdLine* (m: Module; a: Action; info: EnvInfo): string {.
  locks: 0
.} =
  let
    cmd =
      if m.version.len() == 0:
        fmt"""{CmdName} {$a} "{m.pkg}" """
      else:
        fmt"""{CmdName} {$a} {m.op.option()} "{m.version}" "{m.pkg}" """
    env = info.buildEnv()

  result =
    if env.len() == 0:
      cmd
    else:
      fmt"{info.buildEnv()} {cmd}"



func getCFlags* (
  modules: openarray[Module];
  info: EnvInfo = DefaultEnvInfo
): string {. compileTime, locks: 0 .} =
  var results: seq[string]

  for m in modules:
    results.add(staticExec(m.buildCmdLine(Action.CFlags, info)))

  result = results.join($' ')


func getLdFlags* (
  modules: openarray[Module];
  info: EnvInfo = DefaultEnvInfo
): string {. compileTime, locks: 0 .} =
  var results: seq[string]

  for m in modules:
    results.add(staticExec(m.buildCmdLine(Action.LdFlags, info)))

  result = results.join($' ')



static:
  doAssert(CmdName.isFileName())
