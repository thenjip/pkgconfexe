when NimVersion <= "0.19.4":
  import std/ospaths
else:
  import os
import std/[ strformat ]

import "common.nims"



func buildCmd (f: string): string =
  if "CC".existsEnv():
    fmt"""c -r --cc:{"CC".getEnv().quoteShell()} {f.quoteShell()}"""
  else:
    fmt"c -r {f.quoteShell()}"


proc doExec (file: string) =
  selfExec(fmt"test_{file}.nim".buildCmd())



for t in Tests:
  t.doExec()
