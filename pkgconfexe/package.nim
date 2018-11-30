import private/[ fphelper, utf8 ]

import pkg/[ unicodedb, zero_functional ]

import std/[ unicode ]



const
  AllowedCharOthers* = { '+', '-', '_', '$', '.', '#', '@', '~' }

  AllowedCategories* = ctgL + ctgN



func isValid (r: Rune): bool {. locks: 0 .} =
  result = r in AllowedCharOthers or r.unicodeCategory() in AllowedCategories



func isPackage* (x: string): bool {. locks: 0 .} =
  result = x.len() > 0 and x.toRunes().callZFunc(all(it.isValid()))



func scanfPackage* (input: string; pkg: var string; start: int): int {.
  locks: 0
.} =
  let found = $input[start .. input.high()].toRunes().callZFunc(
    takeWhile(it.isValid())
  )

  pkg = found
  result = found.len()
