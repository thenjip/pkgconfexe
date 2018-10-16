import pkgconfexe/version

import std/[ strscans, unittest ]



suite "version":
  test "isVersion":
    check(not "".isVersion())

    const SomeValidVersions = [
      "1.1983.0567",
      "0.3.6",
      "R5",
      "1:6.9.2",
      "1.0-4~ppa+xenial28",
      "3.0+git2018.12.25-00.00.00"
    ]

    for v in SomeValidVersions:
      check(v.isVersion())

    check(not "o 6".isVersion())


  test "scanfVersion":
    const
      Pattern = "${scanfVersion}"
      Version = "3.5-1~97"
      NoisyVersion = "3.5-1~97|°"

    var match = ""
    check:
      NoisyVersion.scanf(Pattern, match)
      match == Version