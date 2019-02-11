import pkgconfexe/[ version ]
import pkgconfexe/private/[ scanresult, seqindexslice ]

import std/[ strformat, unittest ]



suite "version":
  test "isVersion":
    for it in [ "", "o 6" ]:
      check:
        not it.isVersion()

    for it in [
      "1.1983.0567",
      "0.3.6",
      "R5",
      "1:6.9.2",
      "1.0-4~ppa+xenial28",
      "3.0+git2018.12.25-00.00.00"
    ]:
      check:
        it.isVersion()


  test "scanVersion":
    const
      Expected = "3.5-1~97"
      Input = fmt"{Expected}|°"
    let scanResult = Input.scanVersion()

    check:
      scanResult.hasResult()
      Input[seqIndexSlice(scanResult.start, scanResult.n)] == Expected


  test "isVersion_const":
    const valid = "1:6.9.2-alpha".isVersion()

    check:
      valid
