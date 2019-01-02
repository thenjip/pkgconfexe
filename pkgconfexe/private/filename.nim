import scanresult, utf8, zfunchelper

import pkg/[ unicodedb ]

from std/os import AltSep, Curdir, DirSep, ParDir, PathSep
import std/[ unicode ]



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



## Last rune of input excluded.
func isValid (r: Rune): bool {. locks: 0 .} =
  r notin ReservedChars and not r.isControl()


func checkRunes (x: string; lastRune: tuple[r: Rune, len: Positive]): bool {.
  locks: 0
.} =
  lastRune.r notin ForbiddenLastChars and
    x.countValidBytes(
      seqIndexSlice(x.low(), x.high() - lastRune.len), isValid
    ) == x.len() - lastRune.len


func isFileName* (x: string): bool {. locks: 0 .} =
  x.len() > 0 and
    x.runeAt(x.low()) != ShortOptionPrefix and
    x.checkRunes(x.lastRune(x.high()).convertRuneInfo()) and
    ReservedName.zeroFunc(all($it != x))



static:
  ReservedName-->foreach(doAssert(($it).isUtf8()))
