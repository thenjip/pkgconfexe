import env, module
import private/[ filename, utf8 ]

import std/[ ospaths, sequtils, strformat, strutils, sugar, tables ]


export env, module



const CmdName* = "pkgconf".addFileExt(ExeExt)



type Action* {. pure .} = enum
  CFlags = "--cflags"
  LdFlags = "--libs"



func buildCmdLine (components: openarray[string]): string =
  components.joinWithSpaces()


func checkCmdSuccess (
  cmdResult: tuple[output: string; exitCode: int]; cmdLine: string
): cmdResult.type() =
  if cmdResult.exitCode != QuitSuccess:
    raise newException(
      OSError,
      [
        fmt"Command failed with exit code {cmdResult.exitCode}:",
        cmdLine
      ].join($'\n')
    )
  else:
    cmdResult


func execCmdLine (cmdLine: string): string {. compileTime .} =
  cmdLine.gorgeEx().checkCmdSuccess(cmdLine).output


func execCmd (
  a: Action;
  m: Module;
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()
]): string {. compileTime .} =
  discard [
    env.buildEnv(),
    CmdName,
    m.cmp.option(),
    fmt"{m.version.quoteShell()}",
    fmt"{m.pkg.quoteShell()}"
  ].buildCmdLine().execCmdLine()

  result = [
    env.buildEnv(), CmdName, $a, fmt"{m.pkg.quoteShell()}"
  ].buildCmdLine().execCmdLine()


func execCmds (
  a: Action;
  modules: openarray[Module];
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()]
): string {. compileTime .} =
  toSeq(modules.items()).mapIt(a.execCmd(it, env)).joinWithSpaces()



func getCFlags* (
  modules: openarray[Module];
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()]
): string {. compileTime .} =
  Action.CFlags.execCmds(modules, env)


func getCFlags* (modules: openarray[Module]; env: openarray[EnvVar]): string {.
  compileTime
.} =
  modules.getCFlags(env.toOrderedTable())


func getCFlags* (modules: openarray[Module]): string {. compileTime .} =
  modules.getCFlags([])


func getCFlags* (modules: openarray[string]; env: openarray[EnvVar]): string {.
  compileTime
.} =
  modules.mapIt(it.module()).getCFlags(env)


func getCFlags* (modules:openarray[string]): string {. compileTime .} =
  modules.getCFlags([])



func getLdFlags* (
  modules: openarray[Module];
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()]
): string {. compileTime .} =
  Action.LdFlags.execCmds(modules, env)


func getLdFlags* (modules: openarray[Module]; env: openarray[EnvVar]): string {.
  compileTime
.} =
  modules.getLdFlags(env.toOrderedTable())


func getLdFlags* (modules: openarray[Module]): string {. compileTime .} =
  modules.getLdFlags([])


func getLdFlags* (modules:openarray[string]; env: openarray[EnvVar]): string {.
  compileTime
.} =
  modules.mapIt(it.module()).getLdFlags(env)


func getLdFlags* (modules:openarray[string]): string {. compileTime .} =
  modules.getLdFlags([])



static:
  doAssert(CmdName.isFileName())
  for a in Action:
    doAssert(($a).isUtf8())
