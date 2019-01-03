import pkgconfexe/[ version ]
import pkgconfexe/private/[ scanresult ]

import pkg/[ zero_functional ]

import std/[ strformat, unittest ]



suite "version":
  test "isVersion":
    [ "", "o 6" ].zfun:
      foreach:
        check:
          not it.isVersion()

    [
      "1.1983.0567",
      "0.3.6",
      "R5",
      "1:6.9.2",
      "1.0-4~ppa+xenial28",
      "3.0+git2018.12.25-00.00.00"
    ].zfun:
      foreach:
        check:
          it.isVersion()


  test "scanVersion":
    const
      Expected = "3.5-1~97"
      Input = fmt"{Expected}|°"
    let optScanResult = Input.scanVersion()

    check:
      optScanResult.isSome()
      Input[optScanResult.unsafeGet().slice()] == Expected