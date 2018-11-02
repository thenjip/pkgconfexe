import pkgconfexe/package

import pkg/zero_functional

import std/[ os, sequtils, strformat, strscans, unittest ]


include "data.nims"



suite "package":
  test "isPackage":
    check:
      not "".isPackage()

    const
      Pattern = "${scanfPackage}"
      SomePkgNames = [ "gtk+", ".NET", "ØMQ" ]

    for p in SomePkgNames:
      check:
        p.isPackage()

      let noisyPkg = fmt"{p},d^¨"
      var match = ""
      check:
        noisyPkg.scanf(Pattern, match)
        match == p

    check:
      (toSeq(walkFiles(fmt"{DataDir}/*.pc")))-->all(
        it.splitFile().name.isPackage()
      )
