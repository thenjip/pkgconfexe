import pkgconfexe/private/path

import std/[ ospaths, unittest ]



suite "path":
  test "isPath":
    for p in [ "$PWD"/".."/".", ""/"usr" ]:
      check:
        p.isPath()

    for p in [ "\0"/"abc" ]:
      check:
        not p.isPath()
