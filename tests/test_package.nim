import pkgconfexe/package

import std/[ os, strformat, strscans, unittest ]


include "data.nims"



suite "package":
  test "isPackage":
    check(not "".isPackage())

    const
      Pattern = "${scanfPackage}"
      SomePkgNames = [ "gtk+", ".NET", "ØMQ" ]

    for p in SomePkgNames:
      check(p.isPackage())

      let noisyPkg = fmt"{p},d^¨"
      var match = ""
      check:
        noisyPkg.scanf(Pattern, match)
        match == p

    for p in walkFiles(fmt"{DataDir}/*.pc"):
      check(p.splitFile().name.isPackage())
