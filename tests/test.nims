import pkg/zero_functional

import std/strformat


include "common.nims"



proc doExec (test: string) =
  selfExec(fmt"""c -r 'test_{test}.nim'""")



Tests-->foreach(doExec(it))
