import env, module
import private/[ filename, fphelper, utf8 ]

import std/[ os, strformat, strutils ]


export env, module



const CmdName* = "pkgconf".addFileExt(ExeExt)



type Action* {. pure .} = enum
  CFlags = "--cflags"
  LdFlags = "--libs"



func buildCmdLine* (m: Module; env: seq[EnvVarValue]; a: Action): string {.
  locks: 0, raises: [ ValueError ], tags: []
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


func execCmd (cmd: string): string {.
  compileTime, locks: 0, raises: [ OSError ], tags: [ ExecIOEffect ]
.} =
  let cmdResult = gorgeEx(cmd)

  if cmdResult.exitCode != QuitSuccess:
    raise newException(OSError, &"Command failed:\n{cmd}")

  result = cmdResult.output



func execCmds (
  modules: seq[Module]; env: seq[EnvVarValue]; a: Action
): string {.
  compileTime,
  locks: 0,
  raises: [ OSError, ValueError ],
  tags: [ ExecIOEffect ]
.} =
  result = modules.callZFunc(map(it.buildCmdLine(env, a).execCmd())).join($' ')


func getCFlags* (modules: seq[Module]; env: seq[EnvVarValue]): string {.
  compileTime, locks: 0, raises: [ OSError, ValueError ], tags: [ ExecIOEffect ]
.} =
  result = modules.execCmds(env, Action.CFlags)


func getLdFlags* (modules: seq[Module]; env: seq[EnvVarValue]): string {.
  compileTime, locks: 0, raises: [ OSError, ValueError ], tags: [ ExecIOEffect ]
.} =
  result = modules.execCmds(env, Action.LdFlags)



static:
  doAssert(CmdName.isFileName())
  for a in Action:
    doAssert(($it).isUtf8())

