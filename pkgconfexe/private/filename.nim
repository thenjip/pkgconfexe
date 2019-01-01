import zfunchelper, utf8

import pkg/[ unicodedb, zero_functional ]

from std/os import AltSep, Curdir, DirSep, ParDir, PathSep
import std/[ strutils, unicode ]



when defined(windows):
  const
    ReservedChars* = {
      '?', '*',
      ':', PathSep,
      '/', '\\', '|', AltSep, DirSep,
      '"',
      '<', '>'
    }

    ForbiddenLastChars* = { ' ', '.' } + ReservedChars
else:
  const
    ReservedChars* = { AltSep, DirSep, PathSep }

    ForbiddenLastChars* = ReservedChars

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



func checkRunes (x: string; lastRune: tuple[r: Rune, len: int]): bool {.
  locks: 0
.} =
  lastRune.r notin ForbiddenLastChars and
    x[x.low() .. x.len() - lastRune.len].toRunes().zeroFunc(
      all(it notin ReservedChars and not it.isControl())
    )


func isFileName* (x: string): bool {. locks: 0 .} =
  x.len() > 0 and
    x.runeAt(x.low()) != ShortOptionPrefix and
    x.checkRunes(x.lastRune(x.high())) and
    ReservedName.zeroFunc(all($it != x))



static:
  ReservedName-->foreach(doAssert(($it).isUtf8()))
