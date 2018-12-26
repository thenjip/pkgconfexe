import private/[ fphelper, parseresult, utf8 ]

import pkg/unicodedb

import std/[ strscans, unicode ]



const
  AllowedCharOthers = { '+', '-', '_', '$', '.', '#', '@', '~', '*', ':' }

  AllowedCategories* = ctgL + ctgN



func isValid (r: Rune): bool {. locks: 0 .} =
  result = r in AllowedCharOthers or r.unicodeCategory() in AllowedCategories



func isVersion* (x: string): bool {. locks: 0 .} =
  result =
    x.len() > 0 and
    x.toRunes().callZFunc(all(it.isValid()))



func parseVersion* (input: string): ParseResult[string] {. locks: 0 .} =
  let n = ($input.toRunes().callZFunc(takeWhile(it.isValid()))).len()

  result =
    if n > 0:
      n.some()
    else:
      string.none()
