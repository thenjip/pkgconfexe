import std/unicode except isAlpha

import pkg/unicodeplus

import utf8



const AllowedFirstChars* = { '_' }



func isIdentifier* (x: string): bool {. locks: 0 .} =
  if x.len() == 0:
    return false

  for r in x.runes():
    if not (r in AllowedFirstChars or r.isAlpha()):
      return false

  result = true
