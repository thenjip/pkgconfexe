import std/[ strformat ]


include "common.nims"



proc doRm (file: string) =
  let f = fmt"test_{$file}"

  if existsFile(f):
    rmFile(f)



for t in Tests:
  t.doRm()
