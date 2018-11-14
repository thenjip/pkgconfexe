import comparator, package, version
import private/[ fphelper, utf8 ]

import pkg/zero_functional

import std/[ strformat, strscans, unicode ]


export comparator



type Module* = object
  pkg*: string
  case hasVersion*: bool
    of true:
      cmp*: Comparator
      version*: string
    of false:
      discard



func `==`* (l, r: Module): bool {. locks: 0 .} =
  result =
    if l.hasVersion:
      r.hasVersion and
        l.pkg == r.pkg and l.cmp == r.cmp and l.version == r.version
    else:
      (not r.hasVersion) and l.pkg == r.pkg




func `$`* (m: Module): string {. locks: 0 .} =
  result =
    if m.hasVersion:
      fmt"{m.pkg}{$m.cmp}{m.version}"
    else:
      m.pkg



func scanfModule* (input: string; m: var Module; start: int): int {.
  locks: 0
.} =
  result = 0
  var
    pkg = ""
    cmp: Comparator
    version = ""

  let pkgLen = input.scanfPackage(pkg, start)

  if pkgLen > 0:
    result += pkgLen + input.skipWhitespaces(start + pkgLen)
    let cmpLen = input.scanfComparator(cmp, start + result)

    if cmpLen > 0:
      result += cmpLen + input.skipWhitespaces(start + cmpLen)
      let versionLen = input.scanfVersion(version, start + result)

      if versionLen > 0:
        result += versionLen
        m.reset()
        m = Module(pkg: pkg, hasVersion: true, cmp: cmp, version: version)
      else:
        result = 0
    else:
      m.reset()
      m = Module(pkg: pkg, hasVersion: false)



func toModule* (s: string): Module {. locks: 0, raises: [ ValueError ] .} =
  if not s.scanf(
    "$[skipWhiteSpaces]${scanfModule}$[skipWhiteSpaces]$.", result
  ):
    raise newException(ValueError, fmt""""{s}" is not a valid module.""")


func module* (s: static[string]): Module {.
  compileTime, locks: 0, raises: [ ValueError ]
.} =
  result = s.toModule()
