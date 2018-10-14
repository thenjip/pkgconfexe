from std/ospaths import CurDir, DirSep, ParDir
import std/unicode

import filename, utf8



func isPath* (x: string): bool {. locks: 0 .} =
  for f in x.split(DirSep.toRune()):
    case f:
      of $CurDir, $ParDir:
        result = true
      else:
        if not f.isFileName():
          return false

  result = true
