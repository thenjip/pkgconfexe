import pkgconfexe/private/[ scanresult ]

import pkg/[ zero_functional ]

import std/[ unittest ]



suite "scanresult":
  test "buildScanResult":
    check:
      buildScanResult(6412, 0).isNone()
      buildScanResult(3, 8).isSome()



  test "slice":
    [ (0, 94, 0 .. 93), (6387684, 164, 6387684 .. 6387684 + 164 - 1) ].zfun:
      foreach:
        check:
          someScanResult(it[0], it[1]).get().slice() == seqIndexSlice(it[2])



  test "toOptScanResult":
    check:
      { 'a' .. 'r' }.some().toOptScanResult(5, 7) ==
        someScanResult(5, 7, { 'a' .. 'r' })
      seq[int].none().toOptScanResult(6, 32) ==
        seq[int].none().toOptScanResult(53156, 23)
      (tuple[c: char, i: int]).none().toOptScanResult(6546, 31656) !=
        ('1', 0).some().toOptScanResult(6546, 31656)
