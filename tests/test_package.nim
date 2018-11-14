import pkgconfexe/package
import pkgconfexe/private/fphelper

import pkg/zero_functional

import std/[ os, strformat, strscans, unittest ]


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

    seqOf(walkFiles(fmt"{DataDir}/*.pc")).zfun:
      foreach:
        check:
          it.splitFile().name.isPackage()
