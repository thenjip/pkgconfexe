import pkgconfexe/[ package ]
import pkgconfexe/private/[ scanresult, seqindexslice ]

import std/[ os, strformat, unittest ]


include "data.nims"



const CommonData = [ "gtk+", ".NET", "�crire" ]



suite "package":
  test "isPackage":
    check:
      not "".isPackage()

    for it in CommonData:
      check:
        it.isPackage()

    for it in walkFiles(fmt"{DataDir}/*.pc"):
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
    const
      valid = "�crire".isPackage()
      invalid = "�MQ".isPackage() # For now since we only support ASCII digits.

    check:
      valid
      not invalid
