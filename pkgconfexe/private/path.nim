import filename, utf8

import pkg/zero_functional

from std/ospaths import CurDir, DirSep, ParDir
import std/unicode



func checkFileName (f: string): bool {. locks: 0 .} =
  result = case f
    of $CurDir, $ParDir:
      true
    else:
      f.isFileName()


func isPath* (x: string): bool {. locks: 0 .} =
  let path = x.split(DirSep.toRune())

  when defined(unix) or defined(macosx):
    result =
      if path.len() > 1 and path[path.low()] == "":
        path[path.low().succ()..path.high()]-->all(it.checkFileName())
      else:
        path-->all(it.checkFileName())
  else:
    result = path-->all(it.checkFileName())
