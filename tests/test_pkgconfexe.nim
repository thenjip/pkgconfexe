import pkgconfexe

when NimVersion <= "0.19.4":
  import std/ospaths
else:
  import os
import std/[ strformat, unittest ]

import "data.nims"



const
  envVars = {
    EnvVarName.PkgConfigPath: currentSourcePath().splitFile().dir / DataDir
  }

  modules = [ fmt"{TestPkg} >= 0.1.0" ]



{. passC: getCFlags(modules, envVars), passL: getLdFlags(modules, envVars) .}



proc fabs (arg: cdouble): cdouble {. header: "math.h", importc: "fabs" .}



suite "pkgconfexe":
  test "compiles":
    type
      SomeIntegerTestType {. header: "test.h", importc: "some_integer_t" .} =
        int


  test "fabs":
    check:
      fabs(-1.0) == 1.0
