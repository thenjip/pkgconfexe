import pkgconfexe/private/[ fphelper ]

import std/[ sequtils, unittest ]



suite "fphelper":
  test "foreach":
    3.repeat(5).foreach:
      echo it

    toSeq({ 'a' .. 'z' }.items()).mapIt($it).foreach c:
      echo c
