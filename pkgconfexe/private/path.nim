import filename, utf8

from std/ospaths import CurDir, DirSep, ParDir
import std/unicode



func isPath* (x: string): bool {. locks: 0 .} =
  for f in x.split(DirSep.toRune()):
    case f:
      of $CurDir, $ParDir:
        continue
      else:
        if not f.isFileName():
          return false

  result = true
