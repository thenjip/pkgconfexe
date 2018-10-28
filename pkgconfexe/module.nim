import comparator, package, version
import private/utf8

import pkg/unicodeplus

import std/[ strformat, strscans ]
import std/unicode except isWhiteSpace


export comparator



type Module* = tuple
  pkg: string
  cmp: Comparator
  version: string



func `$`* (m: Module): string {. locks: 0 .} =
  result =
    if m.version.len() == 0:
      m.pkg
    else:
      fmt"{m.pkg}{$m.cmp}{m.version}"



func scanfModule* (input: string; m: var Module; start: int): int {.
  locks: 0
.} =
  result = 0
  var tmp: Module

  let pkgLen = input.scanfPackage(tmp.pkg, start)

  if pkgLen > 0:
    result += pkgLen + input.skipWhitespaces(start + pkgLen)
    let cmpLen = input.scanfComparator(tmp.cmp, start + result)

    if cmpLen > 0:
      result += cmpLen + input.skipWhitespaces(start + cmpLen)
      let versionLen = input.scanfVersion(tmp.version, start + result)

      if versionLen == 0:
        result -= cmpLen
      else:
        result += versionLen

  m = tmp



func toModule* (s: string): Module {. locks: 0, raises: [ ValueError ] .} =
  if not s.scanf(
    "$[skipWhiteSpaces]${scanfModule}$[skipWhiteSpaces]$.", result
  ):
    raise newException(ValueError, fmt""""{s}" is not a valid module.""")


func toModules* (mods: openarray[string]): seq[Module] {.
  locks: 0, raises: [ ValueError ]
.} =
  result = newSeqOfCap[Module](mods.len())

  for m in mods:
    result.add(m.toModule())
