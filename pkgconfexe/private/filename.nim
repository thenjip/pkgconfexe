import seqindexslice, utf8, zfunchelper

import pkg/[ unicodedb ]

from std/os import AltSep, Curdir, DirSep, ParDir, PathSep
import std/[ unicode ]



when defined(windows):
  const
    ReservedChars*: set[AsciiChar] = {
      '?', '*',
      ':', PathSep,
      '/', '\\', '|', AltSep, DirSep,
      '"',
      '<', '>'
    }

    ForbiddenLastChars*: set[AsciiChar] = { ' ', '.' } + ReservedChars
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



func isValid (r: Rune): bool =
  r notin ReservedChars and not r.isControl()


func checkRunes (x: string; firstRune, lastRune: Rune): bool =
  firstRune != ShortOptionPrefix and
    lastRune notin ForbiddenLastChars and
    x.countValidBytes(x.low(), x.len(), isValid) == x.len()


func isFileName* (x: string): bool =
  x.len() > 0 and
    x.checkRunes(x.runeAt(x.low()), x.runeAt(x.high())) and
    ReservedName.zeroFunc(all($it != x))



static:
  ReservedName.zfun:
    foreach:
      doAssert(($it).isUtf8())
