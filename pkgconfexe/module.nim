import comparator, package, version
import private/[ fphelper, utf8 ]

import pkg/zero_functional

import std/[ options, strformat, strscans, unicode ]


export comparator



type
  VersionInfo* = tuple
    cmp: Comparator
    version: string

  Module* = tuple
    pkg: string
    versionInfo: Option[VersionInfo]



func constructModule* (pkg: string): Module {. locks: 0 .} =
  result = (pkg: pkg, versionInfo: VersionInfo.none())


func constructModule* (
  pkg: string; cmp: Comparator; version: string
): Module {. locks: 0 .} =
  result = (pkg: pkg, versionInfo: (cmp: cmp, version: version).some())



func hasVersion* (m: Module): bool {. locks: 0 .} =
  result = m.versionInfo.isSome()



func cmp (m: Module): Comparator {. locks: 0 .} =
  result = m.versionInfo.unsafeGet().cmp


func version (m: Module): string {. locks: 0 .} =
  result = m.versionInfo.unsafeGet().version



func `==`* (l, r: Module): bool {. locks: 0 .} =
  result =
    if l.hasVersion():
      r.hasVersion() and
        l.pkg == r.pkg and l.cmp == r.cmp and l.version == r.version
    else:
      (not r.hasVersion()) and l.pkg == r.pkg



func `$`* (m: Module): string {. locks: 0 .} =
  result =
    if m.hasVersion():
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
        m = constructModule(pkg, cmp, version)
      else:
        result = 0
    else:
      m = constructModule(pkg)



func toModule* (s: string): Module {. locks: 0, raises: [ ValueError ] .} =
  if not s.scanf(
    "$[skipWhiteSpaces]${scanfModule}$[skipWhiteSpaces]$.", result
  ):
    raise newException(ValueError, fmt""""{s}" is not a valid module.""")


func module* (s: static[string]): Module {.
  locks: 0, raises: [ ValueError ]
.} =
  result = s.toModule()
