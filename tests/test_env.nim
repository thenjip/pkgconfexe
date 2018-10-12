from std/ospaths import PathSep
import std/[ strformat, strutils, unittest ]

import pkgconfexe/env



include "data.nims"



suite "env":
  test "$":
    const Info: EnvInfo = (libdirs: @[], pkgPaths: @[ DataDir ], sysrootDir: "")

    check($Info == fmt"""{$EnvVar.PkgConfigPath}="{DataDir}"""")


  test "buildEnv":
    const
      libdir1 = "/usr/lib/pkgconfig"
      libdir2 = "/usr/lib64/pkgconfig"

      Info: EnvInfo = (
        libdirs: @[ libdir1, libdir2 ],
        pkgPaths: @[ DataDir ],
        sysrootDir: ""
      )

    check(
      buildEnv(Info) ==
        fmt"""{$EnvVar.PkgConfigLibdir}="{libdir1}{PathSep}{libdir2}"""" &
        ' ' &
        fmt"""{$EnvVar.PkgConfigPath}="{DataDir}""""

    )
