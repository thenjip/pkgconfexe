import private/[ fphelper, parseresult, utf8 ]

import pkg/[ unicodedb, zero_functional ]

import std/unicode



const
  AllowedCharOthers* = { '+', '-', '_', '$', '.', '#', '@', '~' }

  AllowedCategories* = ctgL + ctgN



func isValid* (r: Rune): bool {. locks: 0 .} =
  result = r in AllowedCharOthers or r.unicodeCategory() in AllowedCategories



func isPackage* (x: string): bool {. locks: 0 .} =
  result = x.len() > 0 and x.toRunes().callZFunc(all(it.isValid()))



func parsePackage* (input: string): ParseResult[string] {. locks: 0 .} =
  result = (
    input.low() .. ($input.toRunes().callZFunc(takeWhile(it.isValid()))).len()
  ).buildParseResult()
