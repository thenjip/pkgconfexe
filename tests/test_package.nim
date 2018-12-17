import pkgconfexe/package

import pkg/zero_functional

import std/[ os, sequtils, strformat, strscans, unittest ]


include "data.nims"



suite "package":
  test "isPackage":
    check:
      not "".isPackage()

    [ "gtk+", ".NET", "ØMQ" ]-->foreach(
      (proc (p: string) =
        check:
          p.isPackage()

        let noisyPkg = fmt"{p},d^¨"
        var match = ""

        check:
          noisyPkg.scanf("${scanfPackage}", match)
          match == p
      )(it)
    )

    toSeq(fmt"{DataDir}/*.pc".walkFiles()).zfun:
      foreach:
        check:
          it.splitFile().name.isPackage()
