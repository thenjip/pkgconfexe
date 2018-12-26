import comparator, package, version
import private/[ fphelper, parseresult, utf8 ]

import pkg/zero_functional

import std/[ options, strformat, sugar, unicode ]


export comparator



type
  VersionInfo* = tuple
    cmp: Comparator
    version: string

  Module* = tuple
    pkg: string
    versionInfo: Option[VersionInfo]



func constructModule* (pkg: string): Module {. locks: 0 .} =
  result = (pkg: pkg, versionInfo: options.none(VersionInfo))


func constructModule* (pkg: string; cmp: Comparator; version: string): Module {.
  locks: 0
.} =
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



func parseModule* (input: string): ParseResult[Module] {. locks: 0 .} =
  result = input.parsePackage().flatMap(
    (n) -> ParseResult[Module] =>
      input[n .. input.high()].parseComparator().flatMapOr(
        (cmp, n) -> ParseResult[Module] => ,
        parseresult.some(input[input.low() .. n].constructModule())
      )
  )



func module* (x: static[string]): Module {.
  locks: 0, raises: [ UnpackError ]
.} =
  result = x.parseModule(x.low()).get()
