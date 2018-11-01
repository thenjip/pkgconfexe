import fphelper, utf8

import pkg/zero_functional

from std/ospaths import AltSep, Curdir, DirSep, ParDir, PathSep
import std/[ strutils, unicode ]



when defined(windows):
  const
    ForbiddenChars* = {
      '?', '*',
      ':', PathSep,
      '/', '\\', '|', AltSep, DirSep,
      '\"',
      '<', '>',
      '\0'..'\x1f', '\x7f', '\x80'..'\x9f'
    }

    ForbiddenLastChars* = { ' ', '.' } + ForbiddenChars
else:
  const
    ForbiddenChars* = {
      AltSep, DirSep, PathSep, '\0'..'\x1f', '\x7f', '\x80'..'\x9f'
    }

    ForbiddenLastChars* = ForbiddenChars

const
  ShortOptionPrefix* = '-'



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



func checkRunes (x: string): bool {. locks: 0 .} =
  let (lastRune, lastRuneLen) = x.lastRune(x.high())

  result =
    lastRune notin ForbiddenLastChars and
    x[x.low()..x.high() - lastRuneLen].toRunes().callZFunc(all(
      it notin ForbiddenChars
    ))


func isFileName* (x: string): bool {. locks: 0 .} =
  result =
    x.len() > 0 and
    x.runeAt(x.low()) != ShortOptionPrefix and
    checkRunes(x) and
    ReservedName.seqOfAll().callZFunc(all($it != x))



static:
  doAssert(ReservedName.seqOfAll()-->all(($it).isUtf8()))
