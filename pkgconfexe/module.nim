import comparator, package, version
import private/[ fphelper, utf8 ]

import pkg/zero_functional

import std/[ strformat, strscans, unicode ]


export comparator



type Module* = tuple
  pkg: string
  cmp: Comparator
  version: string



func hasNoVersion* (m: Module): bool {. locks: 0 .} =
  result = m.cmp == Comparator.None



func `==`* (l, r: Module): bool {. locks: 0 .} =
  result =
    if l.hasNoVersion():
      if r.hasNoVersion():
        l.pkg == r.pkg
      else:
        false
    elif r.hasNoVersion():
      false
    else:
      system.`==`(l, r)




func `$`* (m: Module): string {. locks: 0 .} =
  result =
    if m.hasNoVersion():
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
    else:
      m = tmp



func toModule* (s: string): Module {. locks: 0, raises: [ ValueError ] .} =
  if not s.scanf(
    "$[skipWhiteSpaces]${scanfModule}$[skipWhiteSpaces]$.", result
  ):
    raise newException(ValueError, fmt""""{s}" is not a valid module.""")


func toModules* (mods: openarray[string]): seq[Module] {.
  locks: 0, raises: [ ValueError ]
.} =
  result = mods-->map(it.toModule())
