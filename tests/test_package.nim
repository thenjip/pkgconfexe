import pkgconfexe/[ package ]
import pkgconfexe/private/[ scanresult, seqindexslice ]

import pkg/[ zero_functional ]

import std/[ os, sequtils, strformat, unittest ]


include "data.nims"



const CommonData = [ "gtk+", ".NET", "ØMQ" ]



suite "package":
  test "isPackage":
    check:
      not "".isPackage()

    [ "gtk+", ".NET", "ØMQ" ].zfun:
      foreach:
        check:
          it.isPackage()

    toSeq(fmt"{DataDir}/*.pc".walkFiles()).zfun:
      foreach:
        echo it
        check:
          it.splitFile().name.isPackage()



  test "scanPackage":
    CommonData.zfun:
      foreach:
        let
          noisyPkg = it & ",d^¨"
          scanResult = noisyPkg.scanPackage()

        check:
          scanResult.hasResult()
          noisyPkg[seqIndexSlice(scanResult.start, scanResult.n)] == it
