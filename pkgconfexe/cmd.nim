import env, module
import private/[ filename, utf8 ]

from std/os import ExeExt
import std/[ os, sequtils, strformat, strutils, sugar, tables ]


export env, module



const CmdName* = "pkgconf".addFileExt(ExeExt)



type Action* {. pure .} = enum
  CFlags = "--cflags"
  LdFlags = "--libs"



func buildCmdLine (components: openarray[string]): string =
  components.joinWithSpaces()


func buildCmdLine* (
  a: Action;
  m: Module;
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()]
): string =
  [
    env.buildEnv(),
    CmdName,
    $a,
    m.cmp.option(),
    """"{m.version}"""".fmt(),
    """"{m.pkg}"""".fmt()
  ].joinWithSpaces()


func buildCmdLine* (a: Action; m: Module; env: openarray[EnvVar]): string =
  a.buildCmdLine(m, env.toOrderedTable())



func checkCmdSuccess (
  cmdResult: tuple[output: string; exitCode: int]; cmdLine: string
): cmdResult.type() {. raises: [ OSError ] .} =
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



func execCmdLine (cmdLine: string): string {.
  compileTime, raises: [ OSError ]
.} =
  cmdLine.gorgeEx().checkCmdSuccess(cmdLine).output


func execCmd (
  a: Action;
  m: Module;
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()
]): string {. compileTime, raises: [ OSError ] .} =
  discard [
    env.buildEnv(), CmdName, m.cmp.option(), """"{m.version}"""".fmt(), m.pkg
  ].buildCmdLine().execCmdLine()

  result = [ env.buildEnv(), CmdName, $a, m.pkg ].buildCmdLine().execCmdLine()


func execCmds (
  a: Action;
  modules: openarray[Module];
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()]
): string {. compileTime, raises: [ OSError ] .} =
  toSeq(modules.items()).mapIt(a.execCmd(it, env)).joinWithSpaces()



func getCFlags* (
  modules: openarray[Module];
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()]
): string {. compileTime, raises: [ OSError ] .} =
  Action.CFlags.execCmds(modules, env)


func getCFlags* (modules: openarray[Module]; env: openarray[EnvVar]): string {.
  compileTime, raises: [ OSError ]
.} =
  modules.getCFlags(env.toOrderedTable())



func getLdFlags* (
  modules: openarray[Module];
  env: OrderedTable[EnvVar.name.type(), EnvVar.value.type()]
): string {. compileTime, raises: [ OSError ] .} =
  Action.LdFlags.execCmds(modules, env)


func getLdFlags* (modules: openarray[Module]; env: openarray[EnvVar]): string {.
  compileTime, raises: [ OSError ]
.} =
  modules.getLdFlags(env.toOrderedTable())



static:
  doAssert(CmdName.isFileName())
  for a in Action:
    doAssert(($a).isUtf8())
