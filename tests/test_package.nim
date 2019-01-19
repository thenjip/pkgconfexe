import pkgconfexe/[ package ]
import pkgconfexe/private/[ scanresult, seqindexslice ]

import std/[ os, sequtils, strformat, unittest ]


include "data.nims"



const CommonData = [ "gtk+", ".NET", "ØMQ" ]



suite "package":
  test "isPackage":
    check:
      not "".isPackage()

    for it in CommonData:
      check:
        it.isPackage()

    for it in toSeq(fmt"{DataDir}/*.pc".walkFiles()):
      echo it
      check:
        it.splitFile().name.isPackage()



  test "scanPackage":
    for it in CommonData:
      let
        noisyPkg = it & ",d^¨"
        scanResult = noisyPkg.scanPackage()

      check:
        scanResult.hasResult()
        noisyPkg[seqIndexSlice(scanResult.start, scanResult.n)] == it



  test "isPackage_const":
    const sr = "p".scanPackage()

    check:
      sr.hasResult()
