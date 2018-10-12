import std/[ ospaths, strformat, unittest ]

import pkgconfexe/cmd



include "data.nims"



const EnvInfo: EnvInfo = (
  libdirs: @[],
  pkgPaths: @[ fmt"{ParDir}/{DataDir}".unixToNativePath() ],
  sysrootDir: ""
)



suite "cmd":
  test "getCFlags":
    const CFlags = getCFlags([ DummyPkg.toModule() ], test_cmd.EnvInfo)
    check(CFlags == "-Idummy -Ideps")


  test "getLdFlags":
    const LdFlags = getLdFlags([ DepsPkg.toModule() ], test_cmd.EnvInfo)
    check(LdFlags == "-ldeps")
