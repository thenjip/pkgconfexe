import private/[ fphelper, utf8 ]

import pkg/[ unicodedb, zero_functional ]

import std/[ unicode ]



const
  AllowedCharOthers* = { '+', '-', '_', '$', '.', '#', '@', '~' }

  AllowedCategories* = ctgL + ctgN



func isPackage* (x: string): bool {. locks: 0 .} =
  result =
    x.len() > 0 and
    x.toRunes().callZFunc(all(
      it in AllowedCharOthers or it.unicodeCategory() in AllowedCategories
    ))



func scanfPackage* (input: string; pkg: var string; start: int): int {.
  locks: 0
.} =
  pkg = $input[start..input.high()].toRunes().callZFunc(takeWhile(
    it in AllowedCharOthers or it.unicodeCategory() in AllowedCategories
  ))
  result = pkg.len()
