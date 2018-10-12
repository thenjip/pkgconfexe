import std/strformat

include "common.nims"



for t in Tests:
  let f = fmt"test_{$t}"
  if existsFile(f):
    rmFile(f)
