from std/ospaths import Curdir, DirSep, ParDir, PathSep
import std/[ strutils, unicode ]

import utf8



when defined(windows):
  const
    ForbiddenChars* = {
      '?', '*',
      ':', PathSep,
      '/', '\\', '|', DirSep,
      '\"',
      '<', '>',
      '\0'..'\x1f', '\x7f', '\x80'..'\x9f'
    }

    ForbiddenLastChars* = { ' ', '.' } + ForbiddenChars
else:
  const
    ForbiddenChars* = { DirSep, PathSep, '\0'..'\x1f', '\x7f', '\x80'..'\x9f' }

    ForbiddenLastChars* = ForbiddenChars

const
  ShortOptionPrefix* = "-"



when defined(windows):
  type ReservedName* {. pure .} = enum
    CurDir = $Curdir
    ParDir = $ParDir
    Con = "CON"
    Prn = "PRN"
    Aux = "AUX"
    Nul = "NUL"
    Com1 = "COM1"
    Com2 = "COM2"
    Com3 = "COM3"
    Com4 = "COM4"
    Com5 = "COM5"
    Com6 = "COM6"
    Com7 = "COM7"
    Com8 = "COM8"
    Com9 = "COM9"
    Lpt1 = "LPT1"
    Lpt2 = "LPT2"
    Lpt3 = "LPT3"
    Lpt4 = "LPT4"
    Lpt5 = "LPT5"
    Lpt6 = "LPT6"
    Lpt7 = "LPT7"
    Lpt8 = "LPT8"
    Lpt9 = "LPT9"
else:
  type ReservedName* {. pure .} = enum
    CurDir = $Curdir
    ParDir = $ParDir



func isFileName* (x: string): bool {. locks: 0 .} =
  if x.len() == 0:
    return false

  if x.startsWith(ShortOptionPrefix):
    return false

  let (lastRune, lastRuneLen) = x.lastRune(x.high())
  if lastRune in ForbiddenLastChars:
    return false

  for r in x[x.low()..x.high() - lastRuneLen].runes():
    if r in ForbiddenChars:
      return false

  for rn in ReservedName:
    if x == $rn:
      return false

  result = true



static:
  for rn in ReservedName:
    doAssert(($rn).isUtf8())
