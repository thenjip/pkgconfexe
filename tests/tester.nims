import pkg/zero_functional

import std/strformat



include "common.nims"



proc doExec (file: string) =
  let f = fmt"test_{$file}.nim"

  selfExec(fmt"""c -r {f}""")



Tests-->foreach(doExec(it))
