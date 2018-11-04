import filename, utf8

import pkg/zero_functional

from std/ospaths import CurDir, DirSep, ParDir
import std/unicode



func isPath* (x: string): bool {. locks: 0 .} =
  result = x.split(DirSep.toRune())-->all(
    case it
      of $CurDir, $ParDir:
        true
      else:
        it.isFileName()
  )
